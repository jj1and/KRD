`ifndef __TEST_SIGNAL_GEN_PKG__
`define __TEST_SIGNAL_GEN_PKG__ 

`include "trigger_config.vh"

package test_signal_gen_pkg;
    typedef bit [`RFDC_TDATA_WIDTH-1:0] h_gain_signal_line_t[];
    typedef bit [`LGAIN_TDATA_WIDTH-1:0] l_gain_signal_line_t[];

    typedef struct {
        int rise_time;
        int high_time;
        int fall_time;
    } signal_config_pack;

    class SignalGenerator;
        shortint h_gain_max_val;
        shortint l_gain_max_val;
        shortint h_gain_baseline;
        shortint l_gain_baseline;
        int pre_time = 0;
        int rise_time;
        int high_time;
        int fall_time;
        int total_length;
        int total_stream_len;
        bit [`SAMPLE_WIDTH-1:0] sample_ary[];
        bit [`SAMPLE_WIDTH-1:0] l_gain_sample_ary[];

        function new(input signal_config_pack signal_config);
            int remain;
            this.rise_time = signal_config.rise_time;
            this.high_time = signal_config.high_time;
            this.fall_time = signal_config.fall_time;
            this.total_length = this.pre_time + this.rise_time + this.high_time + this.fall_time;
            remain = this.total_length%`SAMPLE_NUM_PER_CLK;
            if (remain) begin
                this.total_length +=  (`SAMPLE_NUM_PER_CLK-remain);  
            end
            this.total_stream_len = this.total_length/`SAMPLE_NUM_PER_CLK; 
        endfunction //new()

        function bit [`SAMPLE_WIDTH-1:0] int16_to_hGainSample(input shortint val);
            bit [`SAMPLE_WIDTH-1:0] result;
            if (val>2046) begin
                val = 2047;
            end else if (val<-2047) begin
                val = -2048;
            end            
            result = {val[`SAMPLE_WIDTH-1], val[0 +:`ADC_RESOLUTION_WIDTH-1], {`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH{1'b0}}};
            return result;
        endfunction    

        virtual function void sampleFilling(input shortint h_gain_max_val, input shortint h_gain_baseline, input shortint l_gain_max_val, input shortint l_gain_baseline);
            shortint val;
            int GAIN_CORRECTION = 20;
            int LGAIN_TIME_SCALE = (`SAMPLE_NUM_PER_CLK/`LGAIN_SAMPLE_NUM_PER_CLK);
            int extended;
            this.h_gain_max_val = h_gain_max_val;
            this.h_gain_baseline = h_gain_baseline;
            this.sample_ary = new[this.total_length];
            this.l_gain_sample_ary = new[this.total_length/LGAIN_TIME_SCALE];
            extended = `SAMPLE_NUM_PER_CLK-(this.pre_time + this.rise_time + this.high_time + this.fall_time)%`SAMPLE_NUM_PER_CLK;

            for (int i=0; i<this.pre_time; i++) begin
                val = h_gain_baseline;
                sample_ary[i] = this.int16_to_hGainSample(val);
                if (i%LGAIN_TIME_SCALE==0) begin
                    val = l_gain_baseline;
                    l_gain_sample_ary[i/LGAIN_TIME_SCALE] = val;                    
                end                
            end
            for (int i=this.pre_time; i<this.pre_time+this.rise_time; i++) begin
                val = (i-this.pre_time)*(h_gain_max_val-h_gain_baseline)/(this.rise_time-1) + h_gain_baseline;
                sample_ary[i] = this.int16_to_hGainSample(val);
                if (i%LGAIN_TIME_SCALE==0) begin
                    val =  (i-this.pre_time)*(l_gain_max_val-l_gain_baseline)/(this.rise_time-1) + l_gain_baseline;
                    l_gain_sample_ary[i/LGAIN_TIME_SCALE] = val;    
                end
            end
            for (int i=this.pre_time+this.rise_time; i<this.pre_time+this.rise_time+this.high_time; i++) begin
                val = h_gain_max_val;
                sample_ary[i] = this.int16_to_hGainSample(val);
                if (i%LGAIN_TIME_SCALE==0) begin
                    val = l_gain_max_val;
                    l_gain_sample_ary[i/LGAIN_TIME_SCALE] = val;                    
                end
            end
            for (int i=this.pre_time+this.rise_time+this.high_time; i<this.pre_time+this.rise_time+this.high_time+this.fall_time; i++) begin
                val = h_gain_max_val - (i-this.pre_time-this.rise_time-this.high_time)*(h_gain_max_val-h_gain_baseline)/(this.fall_time-1);
                sample_ary[i] = this.int16_to_hGainSample(val);
                if (i%LGAIN_TIME_SCALE==0) begin
                    val = l_gain_max_val - (i-this.pre_time-this.rise_time-this.high_time)*(l_gain_max_val-l_gain_baseline)/(this.fall_time-1);
                    l_gain_sample_ary[i/LGAIN_TIME_SCALE] = val[`SAMPLE_WIDTH-1:0];                    
                end                
            end
            for (int i=this.pre_time+this.rise_time+this.high_time+this.fall_time; i<this.pre_time+this.rise_time+this.high_time+this.fall_time+extended; i++) begin
                val = h_gain_baseline;
                sample_ary[i] = this.int16_to_hGainSample(val);
                if (i%LGAIN_TIME_SCALE==0) begin
                    val = l_gain_baseline;
                    l_gain_sample_ary[i/LGAIN_TIME_SCALE] = val;                    
                end                
            end

        endfunction

        function automatic h_gain_signal_line_t getHGainSignalStream();
            h_gain_signal_line_t signal_stream;
            bit [`SAMPLE_WIDTH-1:0] sample_sum;
            signal_stream = new[this.total_stream_len];

            for (int i=0; i<this.total_stream_len; i++) begin
                for (int j=0; j<`SAMPLE_NUM_PER_CLK; j++) begin
                    signal_stream[i][j*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = sample_ary[i*`SAMPLE_NUM_PER_CLK+j];
                end
            end
            return signal_stream;
        endfunction

        function automatic l_gain_signal_line_t getLGainSignalStream();
            bit signed [`SAMPLE_WIDTH-1:0] val;
            l_gain_signal_line_t signal_stream;
            signal_stream = new[this.total_stream_len];
            for (int i=0; i<this.total_stream_len; i++) begin
                for (int j=0; j<`LGAIN_SAMPLE_NUM_PER_CLK; j++) begin
                    signal_stream[i][j*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = l_gain_sample_ary[i*`LGAIN_SAMPLE_NUM_PER_CLK+j];
                end
            end
            return signal_stream;
        endfunction        
    endclass

    function bit [15:0] int12_to_int16(input bit [11:0] sample);
        bit [15:0] result;
        bit [3:0] sign_extention;
        sign_extention = {4{sample[11]}};
        result = {sign_extention, sample};
        return result;
    endfunction

    function bit [12:0] int12_to_int13(input bit [11:0] sample);
        bit [12:0] result;
        bit sign_extention;
        sign_extention = sample[11];
        result = {sign_extention, sample};
        return result;
    endfunction

    function bit [15:0] int13_to_int16(input bit [12:0] sample);
        bit [15:0] result;
        bit [2:0] sign_extention;
        sign_extention = {3{sample[12]}};
        result = {sign_extention, sample};
        return result;
    endfunction

    function bit [11:0] int16_to_int12(input bit [15:0] sample);
        bit [11:0] result;
        bit sign;
        bit [10:0] lower_11bits;
        sign = sample[15];
        lower_11bits = sample[10:0];
        result = {sign, lower_11bits};
        return result;
    endfunction

    function bit [12:0] int16_to_int13(input bit [15:0] sample);
        bit [11:0] result;
        bit sign;
        bit [10:0] lower_12bits;
        sign = sample[15];
        lower_12bits = sample[11:0];
        result = {sign, lower_12bits};
        return result;
    endfunction

    function bit [`ADC_RESOLUTION_WIDTH:0] iSample_in_rawHGainTDATA(input bit [`RFDC_TDATA_WIDTH-1:0] raw_h_gain_tdata, input int i);
        bit [`ADC_RESOLUTION_WIDTH:0] result;
        result = {raw_h_gain_tdata[(i+1)*`SAMPLE_WIDTH-1], raw_h_gain_tdata[i*`SAMPLE_WIDTH+`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH +:`ADC_RESOLUTION_WIDTH]};
        return result;
    endfunction

    function bit [`SAMPLE_WIDTH-1:0] iSample_in_expectedTDATA(input bit [`RFDC_TDATA_WIDTH-1:0] expected_tdata, input int i);
        bit [`SAMPLE_WIDTH-1:0] result;
        result = expected_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
        return result;
    endfunction

    function bit [`RFDC_TDATA_WIDTH-1:0] rawHGainTDATA_to_expectedNormalTDATA(input bit [`RFDC_TDATA_WIDTH-1:0] raw_h_gain_tdata, input bit signed [`ADC_RESOLUTION_WIDTH:0] h_gain_baseline);
        bit [`RFDC_TDATA_WIDTH-1:0] result;
        bit signed [`ADC_RESOLUTION_WIDTH:0] int13_sample;
        bit signed [`ADC_RESOLUTION_WIDTH:0] int13_sample_bl_subtracted;
        for (int i=0; i<`SAMPLE_NUM_PER_CLK; i++) begin
            int13_sample = iSample_in_rawHGainTDATA(raw_h_gain_tdata, i);
            int13_sample_bl_subtracted = int13_sample-h_gain_baseline;
            result[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = int13_to_int16(int13_sample_bl_subtracted);
        end
        return result;
    endfunction

    function bit [`RFDC_TDATA_WIDTH-1:0] rawTDATA_to_expectedCombinedTDATA(
        input bit [`RFDC_TDATA_WIDTH-1:0] raw_h_gain_tdata, input bit signed [`ADC_RESOLUTION_WIDTH:0] h_gain_baseline, 
        input bit [`LGAIN_TDATA_WIDTH-1:0] raw_l_gain_tdata, input bit signed [`SAMPLE_WIDTH-1:0] l_gain_baseline );
        bit [`RFDC_TDATA_WIDTH-1:0] result;
        bit signed [`ADC_RESOLUTION_WIDTH:0] int13_hGainSample[`SAMPLE_NUM_PER_CLK];
        bit signed [`ADC_RESOLUTION_WIDTH+1:0] int13_hGainSampleSum;
        bit signed [`ADC_RESOLUTION_WIDTH:0] int13_hGainAveragedSample_bl_subtracted;
        bit signed [`SAMPLE_WIDTH-1:0] int16_lGainSample;
        for (int i=0; i<`SAMPLE_NUM_PER_CLK; i++) begin
            int13_hGainSample[i] = iSample_in_rawHGainTDATA(raw_h_gain_tdata, i);
        end

        for (int i=0; i<`SAMPLE_NUM_PER_CLK; i++) begin
            if (i%4==0) begin
                int16_lGainSample = raw_l_gain_tdata[(i/4)*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
                result[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = int16_lGainSample - l_gain_baseline;
            end else if ((i-1)%4==0) begin
                int13_hGainSampleSum = int13_hGainSample[i] + int13_hGainSample[i-1];
                int13_hGainAveragedSample_bl_subtracted = int13_hGainSampleSum[`ADC_RESOLUTION_WIDTH+1:1]-h_gain_baseline;
                result[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = int13_to_int16(int13_hGainAveragedSample_bl_subtracted);
            end else if ((i-2)%4==0) begin
                int13_hGainSampleSum = int13_hGainSample[i] + int13_hGainSample[i+1];
                int13_hGainAveragedSample_bl_subtracted = int13_hGainSampleSum[`ADC_RESOLUTION_WIDTH+1:1]-h_gain_baseline;
                result[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = int13_to_int16(int13_hGainAveragedSample_bl_subtracted);
            end else if ((i-3)%4==0) begin
                result[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] =16'hCC00;
            end                      
        end
        return result;
    endfunction           


endpackage
`endif