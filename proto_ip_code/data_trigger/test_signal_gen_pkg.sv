`ifndef __TEST_SIGNAL_GEN_PKG__
`define __TEST_SIGNAL_GEN_PKG__ 

`include "trigger_config.vh"

package test_signal_gen_pkg;
    typedef bit [`RFDC_TDATA_WIDTH-1:0] signal_line_t[];

    class Signal_generator;
        bit signed [`ADC_RESOLUTION_WIDTH-1:0] max_val;
        bit signed [`ADC_RESOLUTION_WIDTH-1:0] baseline;
        int rise_time;
        int high_time;
        int fall_time;
        int total_length;
        int total_stream_length;
        int noise_amp;
        bit signed [`SAMPLE_WIDTH-1:0] sample_ary[];

        function new(input int rise_time, input int high_time, input int fall_time, input noise_amp);
            this.rise_time = rise_time;
            this.high_time = high_time;
            this.fall_time = fall_time;
            this.noise_amp = noise_amp;

            this.total_length = rise_time + high_time + fall_time;
            this.total_stream_length = (this.total_length)/`SAMPLE_NUM_PER_CLK;        
        endfunction //new()

        virtual function void sampleFilling(input bit signed [`ADC_RESOLUTION_WIDTH-1:0] max_val, input bit signed [`ADC_RESOLUTION_WIDTH-1:0] baseline);
            this.max_val = max_val;
            this.baseline = baseline;
            this.sample_ary = new[this.total_length];

            for (int i=0; i<this.rise_time; i++) begin
                sample_ary[i] = i*(max_val-baseline)/(this.rise_time-1) + baseline;
            end
            for (int i=this.rise_time; i<this.rise_time+this.high_time; i++) begin
                sample_ary[i] = max_val;
            end
            for (int i=this.rise_time+this.high_time; i<this.rise_time+this.high_time+this.fall_time; i++) begin
                sample_ary[i] = max_val - (i-this.rise_time-this.high_time)*(max_val-baseline)/(this.fall_time-1);
            end
        endfunction

        function automatic signal_line_t getSignalStream(input int gain_type);
            signal_line_t signal_stream;
            signal_stream = new[total_stream_length];

            if (gain_type == 0) begin
                
            end else begin
                
            end
        endfunction

    endclass //className

endpackage
`endif