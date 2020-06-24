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

    reg [`FRAME_LENGTH_WIDTH:0] frame_len_cnt;
    wire [`FRAME_LENGTH_WIDTH:0] INIT_FRAME_LEN = {`FRAME_LENGTH_WIDTH+1{1'b1}};
    wire [`FRAME_LENGTH_WIDTH:0] frame_len = {2'b0, HF_FIFO_DOUT[(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-`HEADER_ID_WIDTH-`CH_ID_WIDTH-1 -:`FRAME_LENGTH_WIDTH-1]}; // actual frame_len/2

    wire hd_rd_en = (frame_len_cnt==INIT_FRAME_LEN)&(HF_FIFO_EMPTY==1'b0);
    reg hd_rd_en_delay;
    always @(posedge ACLK ) begin
        hd_rd_en_delay <= #100 hd_rd_en;
    end
    
    wire adc_rd_en;
    generate
        if (`HEADER_LINE==2) begin
            assign adc_rd_en = hd_rd_en|(&{M_AXIS_TREADY, frame_len_cnt+`HEADER_LINE+`FOOTER_LINE<frame_len}); 
        end else begin
            assign adc_rd_en = hd_rd_en|(&{M_AXIS_TREADY, frame_len_cnt+`HEADER_LINE+`FOOTER_LINE<frame_len, frame_len_cnt>=`HEADER_LINE-1, M_AXIS_TVALID});                         
        end
    endgenerate

    reg [`RFDC_TDATA_WIDTH-1:0] adc_data_delay;


    wire [`RFDC_TDATA_WIDTH-1:0] header[`HEADER_LINE/2+`HEADER_LINE%2-1:0];
    wire [`RFDC_TDATA_WIDTH-1:0] footer[`FOOTER_LINE/2+`FOOTER_LINE%2-1:0];


    reg [`RFDC_TDATA_WIDTH-1:0] tdata;
    reg tvalid;
    wire tlast = (frame_len_cnt==frame_len+`HEADER_LINE+`FOOTER_LINE-1);
    wire [`RFDC_TDATA_WIDTH/8-1:0] tkeep;
    genvar i; // `HEADER_LINE must be multiple of 2 and larger than 2; `FOOTER_LINE must be larger than 1
    generate
        for (i=0; i<(`HEADER_LINE/2); i=i+1) begin
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
            frame_len_cnt <= #100 INIT_FRAME_LEN;
        end else begin
            if (&{!HF_FIFO_EMPTY, (frame_len_cnt==INIT_FRAME_LEN)|(tlast&M_AXIS_TREADY)}) begin
                frame_len_cnt <= #100 0;
            end else begin
                if (M_AXIS_TREADY&tvalid) begin
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
            tvalid <= #100 1'b0;
        end else begin
            if (hd_rd_en_delay) begin
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
            if (M_AXIS_TREADY) begin
                adc_data_delay <= #100 ADC_FIFO_DOUT;
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

    assign HF_FIFO_RD_EN = hd_rd_en;
    assign ADC_FIFO_RD_EN = adc_rd_en;
    assign M_AXIS_TVALID = tvalid;
    assign M_AXIS_TLAST = tlast;
    assign M_AXIS_TDATA = tdata;
    assign M_AXIS_TKEEP = tkeep;
    assign DATAFRAME_GEN_ERROR = internal_error;

endmodule // 