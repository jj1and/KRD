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
                sample_ary[i] = {val[`SAMPLE_WIDTH-1], val[0 +:`ADC_RESOLUTION_WIDTH-1], {`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH{1'b0}}};
                if (i%LGAIN_TIME_SCALE==0) begin
                    val = l_gain_baseline;
                    l_gain_sample_ary[i/LGAIN_TIME_SCALE] = val[`SAMPLE_WIDTH-1:0];                    
                end                
            end
            for (int i=this.pre_time; i<this.pre_time+this.rise_time; i++) begin
                val = (i-this.pre_time)*(h_gain_max_val-h_gain_baseline)/(this.rise_time-1) + h_gain_baseline;
                sample_ary[i] = {val[`SAMPLE_WIDTH-1], val[0 +:`ADC_RESOLUTION_WIDTH-1], {`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH{1'b0}}};
                if (i%LGAIN_TIME_SCALE==0) begin
                    val =  (i-this.pre_time)*(l_gain_max_val-l_gain_baseline)/(this.rise_time-1) + l_gain_baseline;
                    l_gain_sample_ary[i/LGAIN_TIME_SCALE] = val[`SAMPLE_WIDTH-1:0];    
                end
            end
            for (int i=this.pre_time+this.rise_time; i<this.pre_time+this.rise_time+this.high_time; i++) begin
                val = h_gain_max_val;
                sample_ary[i] = {val[`SAMPLE_WIDTH-1], val[0 +:`ADC_RESOLUTION_WIDTH-1], {`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH{1'b0}}};
                if (i%LGAIN_TIME_SCALE==0) begin
                    val = l_gain_max_val;
                    l_gain_sample_ary[i/LGAIN_TIME_SCALE] = val[`SAMPLE_WIDTH-1:0];                    
                end
            end
            for (int i=this.pre_time+this.rise_time+this.high_time; i<this.pre_time+this.rise_time+this.high_time+this.fall_time; i++) begin
                val = h_gain_max_val - (i-this.pre_time-this.rise_time-this.high_time)*(h_gain_max_val-h_gain_baseline)/(this.fall_time-1);
                sample_ary[i] = {val[`SAMPLE_WIDTH-1], val[0 +:`ADC_RESOLUTION_WIDTH-1], {`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH{1'b0}}};
                if (i%LGAIN_TIME_SCALE==0) begin
                    val = l_gain_max_val - (i-this.pre_time-this.rise_time-this.high_time)*(l_gain_max_val-l_gain_baseline)/(this.fall_time-1);
                    l_gain_sample_ary[i/LGAIN_TIME_SCALE] = val[`SAMPLE_WIDTH-1:0];                    
                end                
            end
            for (int i=this.pre_time+this.rise_time+this.high_time+this.fall_time; i<this.pre_time+this.rise_time+this.high_time+this.fall_time+extended; i++) begin
                val = h_gain_baseline;
                sample_ary[i] = {val[`SAMPLE_WIDTH-1], val[0 +:`ADC_RESOLUTION_WIDTH-1], {`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH{1'b0}}};
                if (i%LGAIN_TIME_SCALE==0) begin
                    val = l_gain_baseline;
                    l_gain_sample_ary[i/LGAIN_TIME_SCALE] = val[`SAMPLE_WIDTH-1:0];                    
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

endpackage
`endif