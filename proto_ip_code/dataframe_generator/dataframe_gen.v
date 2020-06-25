`timescale 1ps / 1ps
`include "dataframe_config.vh"

module dataframe_gen (
    input wire ACLK,
    input wire ARESET,

    input wire HF_FIFO_EMPTY,
    input wire [(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-1:0] HF_FIFO_DOUT,
    output wire HF_FIFO_RD_EN,

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

    reg [`FRAME_LENGTH_WIDTH:0] frame_len_cnt;
    wire [`FRAME_LENGTH_WIDTH:0] INIT_FRAME_LEN = {`FRAME_LENGTH_WIDTH+1{1'b1}};
    wire frame_len_cnt_is_init = (frame_len_cnt==INIT_FRAME_LEN);
    reg  frame_len_cnt_is_init_delay;    
    reg [`FRAME_LENGTH_WIDTH:0] frame_len; // actual frame_len/2
    

    wire hf_rd_en = (HF_FIFO_EMPTY==1'b0)&(|{frame_len_cnt_is_init, frame_len_cnt==frame_len+ACTUAL_HEADER_LINE+ACTUAL_FOOTER_LINE-2});
    reg hf_rd_en_delay;
    always @(posedge ACLK ) begin
        hf_rd_en_delay <= #100 hf_rd_en;
    end

    reg next_frame_exist;
    
    wire adc_rd_en;
    generate
        if (`HEADER_LINE==2) begin
            assign adc_rd_en = |{hf_rd_en, hf_rd_en_delay, M_AXIS_TREADY&(frame_len_cnt+ACTUAL_HEADER_LINE+ACTUAL_FOOTER_LINE<frame_len)}; 
        end else begin
            assign adc_rd_en = hf_rd_en|(&{M_AXIS_TREADY, frame_len_cnt+ACTUAL_FOOTER_LINE+ACTUAL_FOOTER_LINE<frame_len, frame_len_cnt>=ACTUAL_HEADER_LINE-1, M_AXIS_TVALID});                         
        end
    endgenerate

    reg [`RFDC_TDATA_WIDTH-1:0] adc_data_delay;


    wire [`RFDC_TDATA_WIDTH-1:0] header[ACTUAL_HEADER_LINE-1:0];
    wire [`RFDC_TDATA_WIDTH-1:0] footer[ACTUAL_FOOTER_LINE-1:0];


    reg [`RFDC_TDATA_WIDTH-1:0] tdata;
    reg tvalid;
    wire tlast = (frame_len_cnt==frame_len+ACTUAL_HEADER_LINE+ACTUAL_FOOTER_LINE-1);
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

    always @(posedge ACLK ) begin
        if (|{ARESET, internal_error}) begin
            frame_len <= #100 0;
        end else begin
            if (frame_len_cnt==0) begin
                frame_len <= #100 {2'b0, HF_FIFO_DOUT[(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-`HEADER_ID_WIDTH-`CH_ID_WIDTH-1 -:`FRAME_LENGTH_WIDTH-1]};
            end else begin
                frame_len <= #100 frame_len;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, internal_error}) begin
            next_frame_exist <= #100 1'b0;
        end else begin
            if (frame_len_cnt==frame_len+ACTUAL_HEADER_LINE+ACTUAL_FOOTER_LINE-2) begin
                if (HF_FIFO_EMPTY) begin
                    next_frame_exist <= #100 1'b0;
                end else begin
                    next_frame_exist <= #100 1'b1;
                end
            end else begin
                next_frame_exist <= #100 next_frame_exist;
            end
        end
    end

    wire go_to_first_frame = (!HF_FIFO_EMPTY)&(frame_len_cnt_is_init);
    wire go_to_next_frame = &{next_frame_exist, tlast, M_AXIS_TREADY}; 
    always @(posedge ACLK ) begin
        if (|{ARESET, internal_error}) begin
            frame_len_cnt <= #100 INIT_FRAME_LEN;
        end else begin
            if (go_to_first_frame|go_to_next_frame) begin
                frame_len_cnt <= #100 0;
            end else begin
                if (M_AXIS_TREADY&tvalid) begin
                    if (tlast&(!next_frame_exist)) begin
                        frame_len_cnt <= #100 INIT_FRAME_LEN;
                    end else begin
                        frame_len_cnt <= #100 frame_len_cnt+1;
                    end
                end else begin
                    frame_len_cnt <= #100 frame_len_cnt;
                end
            end
        end
    end

    always @(posedge ACLK) begin
        frame_len_cnt_is_init_delay <= #100 frame_len_cnt_is_init;
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, internal_error}) begin
            tvalid <= #100 1'b0;
        end else begin
            if (hf_rd_en_delay) begin
                tvalid <= #100 1'b1;
            end else begin
                if (M_AXIS_TREADY&tlast) begin
                    tvalid <= #100 1'b0;
                end else begin
                    tvalid <= #100 tvalid;
                end
            end
        end
    end


    always @(posedge ACLK ) begin
        if (|{ARESET, internal_error}) begin
            adc_data_delay <= #100 {`RFDC_TDATA_WIDTH{1'b1}};
        end else begin
            if (|{M_AXIS_TREADY, hf_rd_en_delay&frame_len_cnt_is_init_delay}) begin
                adc_data_delay <= #100 ADC_FIFO_DOUT;
            end else begin
                adc_data_delay <= #100 adc_data_delay;           
            end
        end
    end

    generate
        if (`HEADER_LINE==2) begin
            always @(posedge ACLK ) begin
                if (|{ARESET, internal_error, frame_len_cnt_is_init}) begin
                    tdata <= #100 {`RFDC_TDATA_WIDTH{1'b1}};
                end else begin
                    if (M_AXIS_TREADY) begin
                        if (|{tlast, hf_rd_en_delay&frame_len_cnt_is_init_delay}) begin
                            tdata <= #100 header[0];
                        end else begin
                            if (&{frame_len_cnt<frame_len-1+(ACTUAL_HEADER_LINE)}) begin
                                tdata <= #100 adc_data_delay;
                            end else begin
                                // tdata <= #100 footer[frame_len_cnt-(frame_len+(ACTUAL_HEADER_LINE))]; when need to use `FOOTER_LINE > 1
                                tdata <= #100 footer[0];
                            end
                        end
                    end else begin
                        if (hf_rd_en_delay&frame_len_cnt_is_init_delay) begin
                            tdata <= #100 header[0];
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
                    if (&{M_AXIS_TREADY, frame_len_cnt!=INIT_FRAME_LEN}) begin
                        if (frame_len_cnt<ACTUAL_HEADER_LINE-1) begin
                            if (|{tlast, hf_rd_en_delay&frame_len_cnt_is_init_delay}) begin
                                tdata <= #100 header[0];
                            end else begin
                                tdata <= #100 header[frame_len_cnt+1];
                            end
                        end else begin
                            if (&{frame_len_cnt<frame_len-1+(ACTUAL_HEADER_LINE)}) begin
                                tdata <= #100 adc_data_delay;
                            end else begin
                                // tdata <= #100 footer[frame_len_cnt-(frame_len+(ACTUAL_HEADER_LINE))]; when need to use `FOOTER_LINE > 1
                                tdata <= #100 footer[0];
                            end
                        end
                    end else begin
                        if (hf_rd_en_delay&frame_len_cnt_is_init_delay) begin
                            tdata <= #100 header[0];
                        end else begin
                            tdata <= #100 tdata;
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
            if ((!HF_FIFO_EMPTY)&ADC_FIFO_EMPTY) begin
                internal_error <= #100 1'b1;
            end else begin
                internal_error <= #100 internal_error;
            end
        end
    end

    assign HF_FIFO_RD_EN = hf_rd_en;
    assign ADC_FIFO_RD_EN = adc_rd_en;
    assign M_AXIS_TVALID = tvalid;
    assign M_AXIS_TLAST = tlast;
    assign M_AXIS_TDATA = tdata;
    assign M_AXIS_TKEEP = tkeep;
    assign DATAFRAME_GEN_ERROR = internal_error;

endmodule // 