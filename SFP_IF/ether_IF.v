`timescale 1 ns / 1ps

module ether_IF # (

  parameter integer S_AXIS_TDATA_WIDTH = 64,
  parameter integer TX_RX_M_AXIS_WIDTH = 64

)
(

  input wire TX_ACLK,
  input wire TX_ARESETN,

  input wire[TX_RX_M_AXIS_WIDTH-1:0] SERIALIZED_DATA,
  input wire WR_EN,
  input wire RE_EN,

  output wire[TX_RX_M_AXIS_WIDTH-1:0] TX_M_AXIS_TDATA,
  output wire [7:0] TX_M_AXIS_TKEEP,
  output wire TX_M_AXIS_TUSER,
  output wire TX_M_AXIS_TLAST,
  output wire TX_M_AXIS_TREADY,
  
  output wire PLS_WAIT,
  output wire DATA_EMPTY

);

endmodule