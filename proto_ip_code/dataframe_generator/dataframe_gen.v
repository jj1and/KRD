`timescale 1ps / 1ps
`include "dataframe_config.vh"

module dataframe_gen (
    input wire ACLK,
    input wire ARESET,

    input wire HF_FIFO_EMPTY,
    input wire [(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-1:0] HEADER_FOOTER_DATA,
    output wire HF_FIFO_RD_EN,

    input wire ADC_FIFO_EMPTY,
    input wire [`RFDC_TDATA_WIDTH-1:0] ADC_DATA,
    output wire ADC_FIFO_RD_EN,

    input wire M_AXIS_TREADY,
    output wire M_AXIS_TVALID,
    output wire [`RFDC_TDATA_WIDTH-1:0] M_AXIS_TDATA,
    output wire M_AXIS_TLAST,

    output wire DATAFRAME_GEN_ERROR
);

    reg [`FRAME_LENGTH_WIDTH:0] frame_len_cnt;
    reg [`FRAME_LENGTH_WIDTH:0] frame_len_cnt_delay;
    wire [`FRAME_LENGTH_WIDTH:0] INIT_FRAME_LEN = {`FRAME_LENGTH_WIDTH+1{1'b1}};
    wire [`FRAME_LENGTH_WIDTH:0] frame_len = {2'b0, HEADER_FOOTER_DATA[(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-`HEADER_ID_WIDTH-`CH_ID_WIDTH -:`FRAME_LENGTH_WIDTH-1]}; // actual frame_len/2

    wire hd_rd_en = (frame_len_cnt==INIT_FRAME_LEN)&(HF_FIFO_EMPTY==1'b0);
    
    wire adc_rd_en = (frame_len_cnt_delay<frame_len)&(M_AXIS_TREADY==1'b1);
    wire [`RFDC_TDATA_WIDTH-1:0] adc_data_swapped = {ADC_DATA[`DATAFRAME_WIDTH]};
    reg [`RFDC_TDATA_WIDTH-1:0] adc_data_delay;


    wire [`RFDC_TDATA_WIDTH-1:0] header[`HEADER_LINE-1:0];
    wire [`RFDC_TDATA_WIDTH-1:0] footer[`FOOTER_LINE-1:0];
    genvar i; // `HEADER_LINE must be larger than 2; `FOOTER_LINE must be larger than 1
    generate
        for (i=0; i<`HEADER_LINE; i++) begin
            assign header[i] = {{`DATAFRAME_WIDTH{1'b1}}, HEADER_FOOTER_DATA[(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-i*`DATAFRAME_WIDTH-1 -:`DATAFRAME_WIDTH]};
        end
        for (i=0; i<`FOOTER_LINE; i++) begin
            assign footer[i] = {{`DATAFRAME_WIDTH{1'b1}}, HEADER_FOOTER_DATA[i*`DATAFRAME_WIDTH +:`DATAFRAME_WIDTH]};
        end
    endgenerate

    reg [`RFDC_TDATA_WIDTH-1:0] tdata;
    wire tvalid = (frame_len_cnt_delay!=INIT_FRAME_LEN);
    wire tlast = (frame_len_cnt==frame_len+`HEADER_LINE+`FOOTER_LINE-1);

    reg internal_error; // ADC_FIFO_EMPTY==1 & HF_FIFO_EMPTY==0 -> 1

    always @(posedge ACLK ) begin
        if (|{ARESET, internal_error}) begin
            frame_len_cnt <= #100 INIT_FRAME_LEN;
        end else begin
            if (&{!HF_FIFO_EMPTY, (frame_len_cnt==INIT_FRAME_LEN)|(tlast&M_AXIS_TREADY)}) begin
                frame_len_cnt <= #100 0;
            end else begin
                if (M_AXIS_TREADY) begin
                    if (tlast&HF_FIFO_EMPTY) begin
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

    always @(posedge ACLK ) begin
        if (|{ARESET, internal_error}) begin
            frame_len_cnt_delay <= #100 INIT_FRAME_LEN;
        end else begin
            if (M_AXIS_TREADY) begin
                frame_len_cnt_delay <= #100 frame_len_cnt;
            end else begin
                frame_len_cnt_delay <= #100 frame_len_cnt_delay;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, internal_error}) begin
            adc_data_delay <= #100 {`RFDC_TDATA_WIDTH{1'b1}};
        end else begin
            if (M_AXIS_TREADY) begin
                adc_data_delay <= #100 ADC_DATA;
            end else begin
                adc_data_delay <= #100 adc_data_delay;
            end
        end
    end

    always @(posedge ACLK ) begin
        if (|{ARESET, internal_error}) begin
            tdata <= #100 {`RFDC_TDATA_WIDTH{1'b1}};
        end else begin
            if (&{M_AXIS_TREADY, frame_len_cnt!=INIT_FRAME_LEN}) begin
                if (frame_len_cnt<`HEADER_LINE) begin
                    tdata <= #100 header[frame_len_cnt];
                end else begin
                    if (&{frame_len_cnt<frame_len+`HEADER_LINE}) begin
                        tdata <= #100 adc_data_delay;
                    end else begin
                        // tdata <= #100 footer[frame_len_cnt-(frame_len+`HEADER_LINE)]; when need to use `FOOTER_LINE > 1
                        tdata <= #100 footer[0];
                    end
                end
            end else begin
                tdata <= #100 tdata;
            end
        end
    end


    assign HF_FIFO_RD_EN = hd_rd_en;
    assign ADC_FIFO_RD_EN = adc_rd_en;
    assign M_AXIS_TVALID = tvalid;
    assign M_AXIS_TLAST = tlast;
    assign M_AXIS_TDATA = tdata;
    assign DATAFRAME_GEN_ERROR = internal_error;

endmodule // 