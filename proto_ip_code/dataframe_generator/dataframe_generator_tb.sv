`timescale 1ps/1ps


`include "test_dataframe_gen_pkg.sv"
import test_dataframe_gen_pkg::*;

module dataframe_generator_tb;

    parameter integer ACLK_PERIOD = 8000;
    parameter integer RESET_CLK_NUM = 10;
    parameter integer CHANNEL_ID_NUM = 0;

    reg ACLK = 1'b1;
    reg ARESET = 1'b1;

    // Data frame length configuration
    reg SET_CONFIG = 1'b0;
    reg [15:0] MAX_TRIGGER_LENGTH = 256;

    // Input signals from trigger
    reg [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] S_AXIS_TDATA; // TDATA from RF Data Converter logic IP
    reg S_AXIS_TVALID = 1'b0;
    wire [`RFDC_TDATA_WIDTH-1:0] s_axis_rfdc_tdata = S_AXIS_TDATA[`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH +:`RFDC_TDATA_WIDTH];
    wire [`TRIGGER_INFO_WIDTH-1:0] s_axis_trigger_info = S_AXIS_TDATA[`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH +:`TRIGGER_INFO_WIDTH];
    wire [`TIMESTAMP_WIDTH-1:0] s_axis_timestamp =  S_AXIS_TDATA[`TRIGGER_CONFIG_WIDTH +:`TIMESTAMP_WIDTH];
    wire [`TRIGGER_CONFIG_WIDTH-1:0] s_axis_trigger_config = S_AXIS_TDATA[0 +:`TRIGGER_CONFIG_WIDTH];
    
    wire S_AXIS_TREADY;

    wire M_AXIS_TREADY;
    wire M_AXIS_TVALID;
    wire [`RFDC_TDATA_WIDTH-1:0] M_AXIS_TDATA;
    wire M_AXIS_TLAST;

    wire DATAFRAME_GEN_ERROR;


    dataframe_generator_top # (
        .CHANNEL_ID(CHANNEL_ID_NUM)
    ) DUT (
        .*
    );

    initial begin
        ACLK =0;
        forever #(ACLK_PERIOD/2)   ACLK = ~ ACLK;   
    end        
    
endmodule