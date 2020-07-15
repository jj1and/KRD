`timescale 1ps/1ps
`include "dataframe_config.vh"

module dataframe_generator # (
    parameter integer CHANNEL_ID = 0,
    parameter integer ADC_FIFO_DEPTH = 256*512,
    parameter integer HF_FIFO_DEPTH = 256
)(
    input wire ACLK,
    input wire ARESET,

    // Data frame length configuration
    input wire SET_CONFIG,
    input wire [15:0] MAX_TRIGGER_LENGTH, // maximum value should be 512 (charge_sum will be over-flow with larger value)

    // Input signals from trigger
    input wire [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] S_AXIS_TDATA, // TDATA from RF Data Converter logic IP
    input wire S_AXIS_TVALID,

    // h-gain data for charge_sum
    input wire [`RFDC_TDATA_WIDTH-1:0] H_GAIN_TDATA,

    input wire M_AXIS_TREADY,
    output wire M_AXIS_TVALID,
    output wire [`RFDC_TDATA_WIDTH-1:0] M_AXIS_TDATA,
    output wire [`RFDC_TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,    
    output wire M_AXIS_TLAST,

    output wire DATAFRAME_GEN_ERROR
);

    wire [(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-1:0] HEADER_FOOTER_DATA;
    wire HEADER_FOOTER_VALID;
    wire [(`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH-1:0] HF_FIFO_DOUT;
    wire HF_FIFO_RD_EN;
    wire HF_FIFO_FULL;
    wire HF_FIFO_EMPTY;
    wire HF_FIFO_ALMOST_FULL;


    wire [`RFDC_TDATA_WIDTH-1:0] ADC_DATA;
    wire ADC_VALID;
    wire [`RFDC_TDATA_WIDTH-1:0] ADC_FIFO_DOUT;
    wire ADC_FIFO_RD_EN;
    wire ADC_FIFO_ALMOST_FULL;
    wire ADC_FIFO_FULL;
    wire ADC_FIFO_EMPTY;

    header_footer_gen # (
        .CHANNEL_ID(CHANNEL_ID)
    ) header_footer_gen_inst (
        .ACLK(ACLK),
        .ARESET(ARESET),

        // Data frame length configuration
        .SET_CONFIG(SET_CONFIG),
        .MAX_TRIGGER_LENGTH(MAX_TRIGGER_LENGTH),

        // Input signals from trigger
        .S_AXIS_TDATA(S_AXIS_TDATA), // TDATA from data trigger
        .S_AXIS_TVALID(S_AXIS_TVALID),

        .H_GAIN_TDATA(H_GAIN_TDATA),
        
        .HEADER_FOOTER_DATA(HEADER_FOOTER_DATA),
        .HEADER_FOOTER_VALID(HEADER_FOOTER_VALID),
        .HF_FIFO_RD_EN(HF_FIFO_RD_EN),
        .HF_FIFO_ALMOST_FULL(HF_FIFO_ALMOST_FULL),
        .HF_FIFO_FULL(HF_FIFO_FULL),

        .ADC_DATA(ADC_DATA),
        .ADC_VALID(ADC_VALID),
        .ADC_FIFO_RD_EN(ADC_FIFO_RD_EN),
        .ADC_FIFO_ALMOST_FULL(ADC_FIFO_ALMOST_FULL),
        .ADC_FIFO_FULL(ADC_FIFO_FULL)
    );

    bram_fifo # (
        .DATA_WIDTH(`RFDC_TDATA_WIDTH),
        .PTR_WIDTH($clog2(ADC_FIFO_DEPTH)), // 2^17 = 512CLK * 256frame > 1msec trigger 
        .INIT_VAL()
    ) adc_fifo (
        .CLK(ACLK),
        .RESET(ARESET|SET_CONFIG),
        .DIN(ADC_DATA),
        .WR_EN(ADC_VALID),
        .RD_EN(ADC_FIFO_RD_EN),
        .DOUT(ADC_FIFO_DOUT),
        .ALMOST_EMPTY(),
        .EMPTY(ADC_FIFO_EMPTY),
        .ALMOST_FULL(ADC_FIFO_ALMOST_FULL),
        .FULL(ADC_FIFO_FULL)
    );

    bram_fifo # (
        .DATA_WIDTH((`HEADER_LINE+`FOOTER_LINE)*`DATAFRAME_WIDTH),
        .PTR_WIDTH($clog2(HF_FIFO_DEPTH)), // 256frame = 2^8 frame
        .INIT_VAL()
    ) hf_fifo (
        .CLK(ACLK),
        .RESET(ARESET|SET_CONFIG),
        .DIN(HEADER_FOOTER_DATA),
        .WR_EN(HEADER_FOOTER_VALID),
        .RD_EN(HF_FIFO_RD_EN),
        .DOUT(HF_FIFO_DOUT),
        .ALMOST_EMPTY(),
        .EMPTY(HF_FIFO_EMPTY),
        .ALMOST_FULL(HF_FIFO_ALMOST_FULL),
        .FULL(HF_FIFO_FULL)
    );                

    dataframe_gen dataframe_gen_inst (
        .ACLK(ACLK),
        .ARESET(ARESET|SET_CONFIG),

        .HF_FIFO_EMPTY(HF_FIFO_EMPTY),
        .HF_FIFO_DOUT(HF_FIFO_DOUT),
        .HF_FIFO_RD_EN(HF_FIFO_RD_EN),

        .ADC_FIFO_EMPTY(ADC_FIFO_EMPTY),
        .ADC_FIFO_DOUT(ADC_FIFO_DOUT),
        .ADC_FIFO_RD_EN(ADC_FIFO_RD_EN),

        .M_AXIS_TREADY(M_AXIS_TREADY),
        .M_AXIS_TVALID(M_AXIS_TVALID),
        .M_AXIS_TDATA(M_AXIS_TDATA),
        .M_AXIS_TKEEP(M_AXIS_TKEEP),
        .M_AXIS_TLAST(M_AXIS_TLAST),

        .DATAFRAME_GEN_ERROR(DATAFRAME_GEN_ERROR)
    );



endmodule // 