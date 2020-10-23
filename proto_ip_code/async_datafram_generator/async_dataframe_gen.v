`timescale 1ps / 1ps
`include "async_dataframe_config.vh"

module async_dataframe_gen (
    input wire ACLK,
    input wire ARESET,

    input wire HF_FIFO_RD_RST_BUSY,
    input wire HF_FIFO_EMPTY,
    input wire [(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-1:0] HF_FIFO_DOUT,
    output wire HF_FIFO_RD_EN,

    input wire ADC_FIFO_RD_RST_BUSY,
    input wire ADC_FIFO_EMPTY,
    input wire [`RFDC_TDATA_WIDTH-1:0] ADC_FIFO_DOUT,
    output wire ADC_FIFO_RD_EN,

    input wire M_AXIS_TREADY,
    output wire M_AXIS_TVALID,
    output wire [`RFDC_TDATA_WIDTH-1:0] M_AXIS_TDATA,
    output wire [`RFDC_TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,
    output wire M_AXIS_TLAST,

    output wire DATAFRAME_GEN_ERROR
);

    // `HEADER_LINE must be multiple of 2 and larger than 2; `FOOTER_LINE must be larger than 1
    // **AXI protocol suports TKEEP only at TLAST is high
    parameter integer ACTUAL_HEADER_LINE = `HEADER_LINE/2; 
    parameter integer ACTUAL_FOOTER_LINE = `FOOTER_LINE/2 + `FOOTER_LINE%2;

    wire [`RFDC_TDATA_WIDTH-1:0] header[ACTUAL_HEADER_LINE-1:0];
    wire [`RFDC_TDATA_WIDTH-1:0] footer[ACTUAL_FOOTER_LINE-1:0];

    reg [`RFDC_TDATA_WIDTH-1:0] tdata;
    reg tvalid;
    wire [`RFDC_TDATA_WIDTH/8-1:0] tkeep;
    genvar i;
    generate
        for (i=0; i<(ACTUAL_HEADER_LINE); i=i+1) begin
            // AXI protocol is little endian 
            assign header[i] = {HF_FIFO_DOUT[(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-(i+1)*`DATAFRAME_WIDTH-1 -:`DATAFRAME_WIDTH], HF_FIFO_DOUT[(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-i*`DATAFRAME_WIDTH-1 -:`DATAFRAME_WIDTH]};
        end

        if (`FOOTER_LINE%2!=0) begin
            assign tkeep = tlast ? {{`RFDC_TDATA_WIDTH/8/2{1'b0}}, {`RFDC_TDATA_WIDTH/8/2{1'b1}}} : {`RFDC_TDATA_WIDTH/8{1'b1}};
            assign footer[`FOOTER_LINE/2] = {{`DATAFRAME_WIDTH{1'b1}}, HF_FIFO_DOUT[(`FOOTER_LINE/2)*`DATAFRAME_WIDTH +:`DATAFRAME_WIDTH]};
        end else begin
            assign tkeep = {`RFDC_TDATA_WIDTH/8{1'b1}};
        end

        if (`FOOTER_LINE>1) begin
            for (i=0; i<(`FOOTER_LINE/2); i=i+1) begin
                assign footer[i] = {HF_FIFO_DOUT[(i+1)*`DATAFRAME_WIDTH +:`DATAFRAME_WIDTH], HF_FIFO_DOUT[i*`DATAFRAME_WIDTH +:`DATAFRAME_WIDTH]};
            end            
        end
    endgenerate    

    reg internal_error; // ADC_FIFO_EMPTY==1 & HF_FIFO_EMPTY==0 -> 1

    wire [`FRAME_LENGTH_WIDTH:0] frame_lenD = {2'b0, HF_FIFO_DOUT[(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-`HEADER_ID_WIDTH-`CH_ID_WIDTH-1 -:`FRAME_LENGTH_WIDTH-1]};
    reg [`FRAME_LENGTH_WIDTH:0] frame_len;
    reg [`FRAME_LENGTH_WIDTH:0] actual_frame_len; // count from 0, so actual_frame_len = frame_lenD+ACTUAL_HEADER_LINE+ACTUAL_FOOTER_LINE-1
    reg [`FRAME_LENGTH_WIDTH:0] adc_frame_len; // count from 0, so adc_frame_len = frame_len-1;
    always @(posedge ACLK) begin
        frame_len <= #100 frame_lenD;
        actual_frame_len <= #100 frame_lenD+ACTUAL_HEADER_LINE+ACTUAL_FOOTER_LINE-1;
        adc_frame_len <= #100 frame_lenD-1;
    end


    wire [`FRAME_LENGTH_WIDTH:0] INIT_FRAME_LEN = {`FRAME_LENGTH_WIDTH+1{1'b1}};
    
    reg [`FRAME_LENGTH_WIDTH:0] frame_len_cnt;
    wire frame_len_cnt_is_init = (frame_len_cnt==INIT_FRAME_LEN);
    wire tlast = (frame_len_cnt==actual_frame_len);

    reg [`FRAME_LENGTH_WIDTH:0] adc_cnt;
    wire adc_cnt_is_init = (adc_cnt == INIT_FRAME_LEN);
    wire adc_last = (adc_frame_len == adc_cnt);

    wire frame_exist = !HF_FIFO_EMPTY;
    wire read_done = &{tlast, M_AXIS_TREADY, tvalid};
    reg read_ready;
    always @(posedge ACLK ) begin
        if (|{ARESET, HF_FIFO_RD_RST_BUSY, ADC_FIFO_RD_RST_BUSY}) begin
            read_ready <= #100 1'b1;
        end else begin
            if (frame_exist) begin
                if (read_ready) begin
                    read_ready <= #100 1'b0;
                end else begin
                    read_ready <= #100 read_ready;
                end
            end else begin
                if (read_done) begin
                    read_ready <= #100 1'b1;
                end else begin
                    read_ready <= #100 read_ready;
                end
            end
        end
    end

    assign HF_FIFO_RD_EN = frame_exist&(read_ready|read_done);
    reg adc_cnt_start;
    always @(posedge ACLK ) begin
        adc_cnt_start <= #100 HF_FIFO_RD_EN;
    end


    reg adc_read;
    assign ADC_FIFO_RD_EN =  adc_cnt_start|(&{adc_read, tvalid, M_AXIS_TREADY, frame_len!=1});

    always @(posedge ACLK ) begin
        if (|{ARESET, HF_FIFO_RD_RST_BUSY, ADC_FIFO_RD_RST_BUSY}) begin
            tvalid <= #100 1'b0;
        end else begin
            if (frame_len_cnt==0) begin
                tvalid <= #100 1'b1;
            end else begin
                if (read_done) begin
                    tvalid <= #100 1'b0;
                end else begin
                    tvalid <= #100 tvalid;
                end
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, HF_FIFO_RD_RST_BUSY, ADC_FIFO_RD_RST_BUSY}) begin
            frame_len_cnt <= #100 INIT_FRAME_LEN;
        end else begin
            if (HF_FIFO_RD_EN) begin
                frame_len_cnt <= #100 0;
            end else begin
                if (HF_FIFO_EMPTY&read_done) begin
                    frame_len_cnt <= INIT_FRAME_LEN;
                end else begin
                    if (tvalid&M_AXIS_TREADY) begin
                        frame_len_cnt <= #100 frame_len_cnt + 1;
                    end else begin
                        frame_len_cnt <= #100 frame_len_cnt;
                    end
                end
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, HF_FIFO_RD_RST_BUSY, ADC_FIFO_RD_RST_BUSY}) begin
            adc_read <= #100 1'b0;
        end else begin
            if (adc_cnt_start) begin
                adc_read <= #100 1'b1;
            end else begin
                if (|{adc_last&ADC_FIFO_RD_EN, frame_len==1}) begin
                    adc_read <= #100 1'b0;
                end else begin
                    adc_read <= #100 adc_read;
                end
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, HF_FIFO_RD_RST_BUSY, ADC_FIFO_RD_RST_BUSY}) begin
            adc_cnt <= #100 INIT_FRAME_LEN;
        end else begin
            if (adc_cnt_start) begin
                adc_cnt <= #100 1;
            end else begin
                if (HF_FIFO_EMPTY&read_done) begin
                    adc_cnt <= INIT_FRAME_LEN;
                end else begin
                    if (&{ADC_FIFO_RD_EN, adc_read, !adc_cnt_is_init}) begin
                        adc_cnt <= #100 adc_cnt + 1;
                    end else begin
                        adc_cnt <= #100 adc_cnt;
                    end
                end
            end
        end
    end    

    generate
        if ((`HEADER_LINE==2)&(`FOOTER_LINE==1)) begin
            always @(posedge ACLK ) begin
                if (|{ARESET, internal_error}) begin
                    tdata <= #100 {`RFDC_TDATA_WIDTH{1'b1}};
                end else begin
                    if (&{frame_len_cnt==0, adc_cnt_start}) begin
                        tdata <= #100 header[0];
                    end else begin
                        if (M_AXIS_TREADY) begin
                            if (frame_len_cnt==frame_len) begin
                                tdata <= #100 footer[0];                                
                            end else begin
                                tdata <= #100 ADC_FIFO_DOUT;
                            end                            
                        end else begin
                            tdata <= #100 tdata;
                        end
                    end
                end
            end             
        end else begin
            always @(posedge ACLK ) begin
                if (|{ARESET, internal_error}) begin
                    tdata <= #100 {`RFDC_TDATA_WIDTH{1'b1}};
                end else begin
                    if (frame_len_cnt<ACTUAL_HEADER_LINE-1) begin
                        if (frame_len_cnt==0) begin
                            tdata <= #100 header[0];
                        end else begin
                            tdata <= #100 header[frame_len_cnt+1];
                        end
                    end else begin
                        if ((frame_len_cnt>frame_len+ACTUAL_HEADER_LINE-2)&M_AXIS_TREADY) begin
                            tdata <= #100 footer[frame_len_cnt-frame_len+ACTUAL_HEADER_LINE-1]; // when need to use `FOOTER_LINE > 1                                                          
                        end else begin
                            tdata <= #100 ADC_FIFO_DOUT;
                        end
                    end
                end
            end                   
        end
    endgenerate

    always @(posedge ACLK ) begin
        if (ARESET) begin
            internal_error <= #100 1'b0;
        end else begin
            if (frame_exist&ADC_FIFO_EMPTY) begin
                internal_error <= #100 1'b1;
            end else begin
                internal_error <= #100 internal_error;
            end
        end
    end

    // for afording timing contraint
    reg tvalid_delay;
    reg [`RFDC_TDATA_WIDTH-1:0] tdata_delay;
    reg [`RFDC_TDATA_WIDTH/8-1:0] tkeep_delay;
    reg tlast_delay;
    always @(posedge ACLK ) begin
        if (|{ARESET, internal_error}) begin
            tvalid_delay <= #100 1'b0;
            tlast_delay <= #100 1'b0;
            tdata_delay <= #100 {`RFDC_TDATA_WIDTH{1'b1}};
            tkeep_delay <= #100 {`RFDC_TDATA_WIDTH/8{1'b1}};
        end else begin
            if (M_AXIS_TREADY) begin
                tvalid_delay <= #100 tvalid;
                tlast_delay <= #100 tlast&tvalid;
                tdata_delay <= #100 tdata;
                tkeep_delay <= #100 tkeep;                
            end else begin
                tvalid_delay <= #100 tvalid_delay;
                tlast_delay <= #100 tlast_delay;
                tdata_delay <= #100 tdata_delay;
                tkeep_delay <= #100 tkeep_delay;
            end
        end
    end

    assign M_AXIS_TVALID = tvalid_delay;
    assign M_AXIS_TLAST = tlast_delay;
    assign M_AXIS_TDATA = tdata_delay;
    assign M_AXIS_TKEEP = tkeep_delay;

    // assign M_AXIS_TVALID = tvalid;
    // assign M_AXIS_TLAST = tlast&tvalid;
    // assign M_AXIS_TDATA = tdata;
    // assign M_AXIS_TKEEP = tkeep;    
    assign DATAFRAME_GEN_ERROR = internal_error;

endmodule // 