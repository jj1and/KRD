`timescale 1 ps/1 ps
`include "trigger_config.vh"

module data_trigger_tb;

    // these parameter must be configured before logic synthesis
    parameter integer MAX_PRE_ACQUISITION_LENGTH = 2;
    parameter integer MAX_POST_ACQUISITION_LENGTH = 2;
    parameter integer MAX_ADC_SELECTION_PERIOD_LENGTH = 4;
    parameter integer ADC_SELECTION_PERIOD = 2;

    reg ACLK = 1'b0;
    reg ARESET = 1'b0;
    reg SET_CONFIG = 1'b0;
    reg STOP = 1'b1;

    // S_AXIS interface from RF Data Converter logic IP
    reg [`RFDC_TDATA_WIDTH-1:0] H_S_AXIS_TDATA;
    reg H_S_AXIS_TVALID;

    // S_AXIS interfrace from L-gain ADC
    reg [`SAMPLE_WIDTH*2-1:0] L_S_AXIS_TDATA;
    reg L_S_AXIS_TVALID;

    // Timestamp
    reg [`TIMESTAMP_WIDTH-1:0] TIMESTAMP;    

    // trigger settings
    reg signed [`ADC_RESOLUTION_WIDTH:0] RISING_EDGE_THRSHOLD;
    reg signed [`ADC_RESOLUTION_WIDTH:0] FALLING_EDGE_THRESHOLD;
    reg signed [`ADC_RESOLUTION_WIDTH:0] DIGITAL_BASELINE;
    reg [$clog2(MAX_PRE_ACQUISITION_LENGTH)-1:0] PRE_ACQUISITION_LENGTH;
    reg [$clog2(MAX_POST_ACQUISITION_LENGTH)-1:0] POST_ACQUISITION_LENGTH;
    reg [$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH)-1:0] ADC_SELECTION_PERIOD_LENGTH;

    wire [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] M_AXIS_TDATA;
    wire M_AXIS_TVALID;

    // h-gain data for charge_sum. timing is syncronized width M_AXIS_TDATA
    wire [`RFDC_TDATA_WIDTH-1:0] H_GAIN_BASELINE_SUBTRACTED_TDATA;

    
    data_trigger # (
        // these parameter must be configured before logic synthesis
        .MAX_PRE_ACQUISITION_LENGTH(MAX_PRE_ACQUISITION_LENGTH),
        .MAX_POST_ACQUISITION_LENGTH(MAX_POST_ACQUISITION_LENGTH),
        .MAX_ADC_SELECTION_PERIOD_LENGTH(MAX_ADC_SELECTION_PERIOD_LENGTH),
        .ADC_SELECTION_PERIOD(ADC_SELECTION_PERIOD)
    ) DUT (
        .*
    );

    
endmodule