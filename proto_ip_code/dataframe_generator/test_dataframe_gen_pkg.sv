`ifndef __TEST_DATAFRAME_GEN_PKG__
`define __TEST_DATAFRAME_GEN_PKG__

`include "dataframe_config.vh"

package test_dataframe_gen_pkg;
    typedef bit [`DATAFRAME_WIDTH-1:0] dataframe_line_t[];
    typedef bit [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] datastream_line_t[];
    typedef struct packed {
        bit [`CH_ID_WIDTH-1:0] ch_id;
        bit [`FRAME_LENGTH_WIDTH-1:0] frame_len;
        bit gain_type;
        bit [`TRIGGER_TYPE_WIDTH-1:0] trigger_type;
        bit [15:0] baseline;
        bit [`TRIGGER_CONFIG_WIDTH-16-1:0] threshold;
        bit [`TIMESTAMP_WIDTH-1:0] timestamp;        
    } frame_config_pack;

    class DataFrame;
        bit [`HEADER_ID_WIDTH-1:0] HEADER_ID = `HEADER_ID;   
        bit [`FOOTER_ID_WIDTH-1:0] FOOTER_ID = `FOOTER_ID;
        bit [`CH_ID_WIDTH-1:0] ch_id;
        bit [`FRAME_LENGTH_WIDTH-1:0] frame_len;
        int raw_stream_len;
        bit gain_type;
        bit [`TRIGGER_TYPE_WIDTH-1:0] trigger_type;
        bit [15:0] baseline;
        bit [`TRIGGER_CONFIG_WIDTH-16-1:0] threshold;
        bit [`TIMESTAMP_WIDTH-1:0] timestamp;   
        bit [`SAMPLE_WIDTH-1:0] sample_ary[];
        int charge_sum;

        function new(input frame_config_pack frame_config);
            this.ch_id = frame_config.ch_id;
            this.frame_len = frame_config.frame_len;
            this.raw_stream_len = (frame_config.frame_len)/(`RFDC_TDATA_WIDTH/`DATAFRAME_WIDTH);
            this.gain_type = frame_config.gain_type;
            this.trigger_type = frame_config.trigger_type;
            this.baseline = frame_config.baseline;
            this.threshold = frame_config.threshold;
            this.timestamp = frame_config.timestamp;               
        endfunction //new()
        
        virtual function void sampleFilling();
            int actual_frame_len;

            actual_frame_len = this.frame_len*(`DATAFRAME_WIDTH/`SAMPLE_WIDTH);
            this.sample_ary = new[this.frame_len*(`DATAFRAME_WIDTH/`SAMPLE_WIDTH)];
            this.charge_sum  = (actual_frame_len)*(actual_frame_len-1)/2;
            // FILL WITH COUNTING NUMBER
            for (int i=0; i<this.frame_len*(`DATAFRAME_WIDTH/`SAMPLE_WIDTH) ;i++ ) begin
                this.sample_ary[i] = i;
            end
        endfunction

        function automatic dataframe_line_t getDataframe(input bit [`OBJECT_ID_WIDTH-1:0] object_id, input bit [1:0] trigger_state, input bit frame_continue);
            bit [`FRAME_INFO_WIDTH-1:0] frame_info;
            bit [`CHARGE_SUM-1:0] charge_sum; 
            dataframe_line_t data_frame;            
            data_frame = new[this.frame_len+3];
            charge_sum = this.charge_sum;
            frame_info = {trigger_state, frame_continue, this.gain_type};
            if (this.sample_ary[0]==null) begin
                this.sampleFilling();
            end
            for ( int i=0; i<this.frame_len+3; i++) begin
                if (i==0) begin
                    data_frame[0] = {this.HEADER_ID, this.ch_id, this.frame_len, frame_info, this.trigger_type, this.timestamp[`HEADER_TIMESTAMP_WIDTH-1:0]};
                end else if (i==1) begin
                    data_frame[1] = {{`HEADER_ID_WIDTH{1'b0}}, charge_sum, this.baseline, this.threshold};
                end else if ((i>=2)&&(i<this.frame_len+2)) begin
                    for (int j=0; j<(`DATAFRAME_WIDTH/`SAMPLE_WIDTH); j++ ) begin
                        data_frame[i][(`DATAFRAME_WIDTH/`SAMPLE_WIDTH)*j +:`SAMPLE_WIDTH] = this.sample_ary[(i-2)*(`DATAFRAME_WIDTH/`SAMPLE_WIDTH)+j];  
                    end                     
                end else if (i==this.frame_len+2) begin
                    data_frame[this.frame_len+2] = {this.timestamp[`TIMESTAMP_WIDTH-1 -:`FOOTER_TIMESTAMP_WIDTH], object_id};
                end
            end
            return data_frame;
        endfunction

        function automatic datastream_line_t getDataStream();
            datastream_line_t raw_stream;
            raw_stream = new[this.raw_stream_len];
            if (this.sample_ary[0]==null) begin
                this.sampleFilling();
            end
            for (int i=0; i<this.raw_stream_len; i++) begin
                for (int j=0; j<`SAMPLE_NUM_PER_CLK; j++) begin
                   raw_stream[i][`SAMPLE_WIDTH*j+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH +:`SAMPLE_WIDTH] = this.sample_ary[i*`SAMPLE_NUM_PER_CLK+j]; 
                end
                raw_stream[i][`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] = {{3'h0}, this.gain_type, this.trigger_type, this.timestamp+i, this.baseline, this.threshold};
            end
            return raw_stream;
        endfunction
    endclass //DataFrame
endpackage
`endif