`timescale 1 ns / 1ps

module channel_serializer # (

  parameter integer S_AXIS_TDATA_WIDTH = 64,
  parameter integer TX_RX_M_AXIS_WIDTH = 64

)
(

  input wire TX_ACLK,
  input wire TX_ARESETN,

  input wire [S_AXIS_TDATA_WIDTH-1:0] S_AXIS_TDATA,
  input wire S_AXIS_TUSER,
  input wire S_AXIS_TLAST,
  
  input wire PLS_WAIT,
  input wire DATA_EMPTY,

  output wire[TX_RX_M_AXIS_WIDTH-1:0] SERIALIZED_DATA,
  output wire WR_EN,
  output wire RE_EN

);

endmodule