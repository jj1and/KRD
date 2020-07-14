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
        shortint max_val;
        shortint baseline;
        int rise_time;
        int high_time;
        int fall_time;
        int total_length;
        int total_stream_len;
        bit [`SAMPLE_WIDTH-1:0] sample_ary[];

        function new(input signal_config_pack signal_config);
            int remain;
            this.rise_time = signal_config.rise_time;
            this.high_time = signal_config.high_time;
            this.fall_time = signal_config.fall_time;
            this.total_length = this.rise_time + this.high_time + this.fall_time;
            remain = (this.rise_time + this.high_time + this.fall_time)%`SAMPLE_NUM_PER_CLK;
            if (remain) begin
                this.total_length = this.rise_time + this.high_time + this.fall_time + (`SAMPLE_NUM_PER_CLK-remain);  
            end else begin
                this.total_length = this.rise_time + this.high_time + this.fall_time;  
            end
            this.total_stream_len = this.total_length/`SAMPLE_NUM_PER_CLK; 
        endfunction //new()

        virtual function void sampleFilling(input shortint max_val, input shortint baseline);
            shortint val;
            int extended;
            this.max_val = max_val;
            this.baseline = baseline;
            this.sample_ary = new[this.total_length];
            extended = `SAMPLE_NUM_PER_CLK-(this.rise_time + this.high_time + this.fall_time)%`SAMPLE_NUM_PER_CLK;

            for (int i=0; i<this.rise_time; i++) begin
                val = i*(max_val-baseline)/(this.rise_time-1) + baseline;
                sample_ary[i] = {{`SAMPLE_WIDTH-(`ADC_RESOLUTION_WIDTH+1){val[$bits(val)-1]}}, val[0 +:`ADC_RESOLUTION_WIDTH+1]};
            end
            for (int i=this.rise_time; i<this.rise_time+this.high_time; i++) begin
                val = max_val;
                sample_ary[i] = {{`SAMPLE_WIDTH-(`ADC_RESOLUTION_WIDTH+1){val[$bits(val)-1]}}, val[0 +:`ADC_RESOLUTION_WIDTH+1]};
            end
            for (int i=this.rise_time+this.high_time; i<this.rise_time+this.high_time+this.fall_time; i++) begin
                val = max_val - (i-this.rise_time-this.high_time)*(max_val-baseline)/(this.fall_time-1);
                sample_ary[i] = {{`SAMPLE_WIDTH-(`ADC_RESOLUTION_WIDTH+1){val[$bits(val)-1]}}, val[0 +:`ADC_RESOLUTION_WIDTH+1]};
            end
            for (int i=this.rise_time+this.high_time+this.fall_time; i<this.rise_time+this.high_time+this.fall_time+extended; i++) begin
                sample_ary[i] = 0;
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
            int GAIN_CORRECTION = 20;
            l_gain_signal_line_t signal_stream;
            bit [`SAMPLE_WIDTH:0] sample_sum;
            signal_stream = new[this.total_stream_len];
            for (int i=0; i<this.total_stream_len; i++) begin
                for (int j=0; j<`LGAIN_SAMPLE_NUM_PER_CLK; j++) begin
                    sample_sum = 0;
                    for (int k=0; k<`SAMPLE_NUM_PER_CLK/`LGAIN_SAMPLE_NUM_PER_CLK; k++) begin
                        sample_sum += sample_ary[i*`SAMPLE_NUM_PER_CLK+j*(`SAMPLE_NUM_PER_CLK/`LGAIN_SAMPLE_NUM_PER_CLK)+k];
                    end
                    signal_stream[i][j*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = sample_sum[`SAMPLE_WIDTH:1]/GAIN_CORRECTION;
                end
            end
            return signal_stream;
        endfunction        
    endclass

endpackage
`endif