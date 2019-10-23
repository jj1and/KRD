`timescale 1 ns / 1ps

module ether_ctl # (

  parameter integer dummy = 1

)
(

  input wire CTL_CLK,
  input wire CTL_RESETN,
  
  input wire STAT_TX_LOCAL_FAULT,

  output wire CTL_TX_CUSTOM_PREAMBLE_ENABLE,
  output wire [55:0] CTL_TX_PREAMBLE,
  output wire [3:0] CTL_TX_IPG_VALUE,
  output wire CTL_TX_ENABLE,
  output wire CTL_TX_SEND_RFI,
  output wire CTL_SEND_LFI,
  output wire CTL_SEND_IDEL,
  output wire CTL_TX_FCS_ENABLE,
  output wire CTL_IGNORE_FCS

);

endmodule