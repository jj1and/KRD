`timescale 1 ps/1 ps
module trigger_core # (
    parameter integer DATA_WIDTH = 128,
    parameter integer ADC_RESOLUTION = 12,
    parameter integer MAX_PRE_ACQUISITION_LENGTH = 2,
    parameter integer MAX_POST_ACQUISITION_LENGTH = 2,
    parameter integer ADC_SELECTION_PERIOD = 2
)(
    // S_AXIS interface from RF Data Converter logic IP
    input wire [DATA_WIDTH-1:0] S_AXIS_TDATA,
    input wire S_AXIS_TVALID,
    output wire S_AXIS_TREADY,

    // trigger settings
    input wire [ADC_RESOLUTION:0] threshold,
    input wire [ADC_RESOLUTION-1:0] baseline,

    // trigger and gain-mode for ADC selector
    output wire trigger,
    output wire gain_type
);
    
endmodule 