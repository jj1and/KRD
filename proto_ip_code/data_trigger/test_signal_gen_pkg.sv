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
        int max_val;
        int baseline;
        int rise_time;
        int high_time;
        int fall_time;
        int total_length;
        int total_stream_len;
        int noise_amp;
        int sample_ary[];

        function new(input signal_config_pack signal_config);
            this.rise_time = signal_config.rise_time;
            this.high_time = signal_config.high_time;
            this.fall_time = signal_config.fall_time;
            this.total_length = this.rise_time + this.high_time + this.fall_time;
            this.total_stream_len = this.total_length/`SAMPLE_NUM_PER_CLK;  
        endfunction //new()

        virtual function void sampleFilling(input int max_val, input int baseline, input int noise_amp);
            int sign;
            this.max_val = max_val;
            this.baseline = baseline;
            this.noise_amp = noise_amp;
            this.sample_ary = new[this.total_length];

            for (int i=0; i<this.rise_time; i++) begin
                sign = $urandom_range(0, 1);
                sample_ary[i] = i*(max_val-baseline)/(this.rise_time-1) + baseline + sign*$urandom_range(0, noise_amp/2) - (1-sign)*$urandom_range(0, noise_amp/2);
            end
            for (int i=this.rise_time; i<this.rise_time+this.high_time; i++) begin
                sign = $urandom_range(0, 1);
                sample_ary[i] = max_val + sign*$urandom_range(0, noise_amp/2) - (1-sign)*$urandom_range(0, noise_amp/2);
            end
            for (int i=this.rise_time+this.high_time; i<this.rise_time+this.high_time+this.fall_time; i++) begin
                sign = $urandom_range(0, 1);
                sample_ary[i] = max_val - (i-this.rise_time-this.high_time)*(max_val-baseline)/(this.fall_time-1) + sign*$urandom_range(0, noise_amp/2) - (1-sign)*$urandom_range(0, noise_amp/2);
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
            int sample_sum;
            signal_stream = new[this.total_stream_len];
            for (int i=0; i<this.total_stream_len; i++) begin
                for (int j=0; j<`LGAIN_SAMPLE_NUM_PER_CLK; j++) begin
                    sample_sum = 0;
                    for (int k=0; k<`SAMPLE_NUM_PER_CLK/`LGAIN_SAMPLE_NUM_PER_CLK; k++) begin
                        sample_sum += sample_ary[i*`SAMPLE_NUM_PER_CLK+j*(`SAMPLE_NUM_PER_CLK/`LGAIN_SAMPLE_NUM_PER_CLK)+k];
                    end
                    signal_stream[i][j*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = {sample_sum[`SAMPLE_WIDTH] ,sample_sum[`SAMPLE_WIDTH:2]}/GAIN_CORRECTION;
                end
            end
            return signal_stream;
        endfunction        
    endclass

endpackage
`endif