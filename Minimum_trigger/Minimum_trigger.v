`timescale 1 ns / 1 ps
`include "./Fifo.vhd"
`include "./MM_trg.v"

module Minimum_trigger # (
    // threshold ( percentage of max value = 2^12)
    parameter integer THRESHOLD = 10,
    
    // acquiasion length settings
    parameter integer PRE_ACQUI_LEN = 24/2,
    parameter integer POST_ACQUI_LEN = 76/24,

    // FIFO depth setting
    parameter integer ACQUI_LEN = 200/2,

    // TIME STAMP DATA WIDTH
    parameter integer TIME_STAMP_WIDTH = 16,

    // RFSoC ADC resolution
    parameter integer ADC_RESOLUTION_WIDTH = 12,
    
    // RF Data Converter data stream bus width
    parameter integer S_AXIS_TDATA_WIDTH	= 128

    // AXI DMA S2MM bus width
    parameter integer M_AXIS_TDATA_WIDTH	= 64
)
(    
    // Ports of Axi-stream Bus Interface
    input wire  AXIS_ACLK,
    input wire  AXIS_ARESETN,

    // Ports of Axi-stream Slave Bus Interface　
    output wire  S_AXIS_TREADY,
    input wire [S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
    input wire  S_AXIS_TVALID,

    // Ports of Axi-stream Master Bus Interface
    output wire [M_AXIS_TDATA_WIDTH-1:0] M_AXIS_TDATA,
    output wire M_AXIS_TLAST,
);

	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction

  MM_trg # (
    .THRESHOLD(THRESHOLD),
    .PRE_ACQUI_LEN(PRE_ACQUI_LEN),
    .POST_ACQUI_LEN(POST_ACQUI_LEN),
    .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
    .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),  
    .AXIS_TDATA_WIDTH(S_AXIS_TDATA_WIDTH)
  ) MM_trg_inst (
      .EXEC_STATE(),    
      .BASELINE(),
      .CURRENT_TIME(),
      .O_TIME_STAMP(),
      .O_start_trg(),
      .O_finalize_trg(),
      .AXIS_ACLK(AXIS_ACLK),
      .AXIS_ARESETN(AXIS_ARESETN),
      .AXIS_TDATA(S_AXIS_TDATA)
  );

endmodule