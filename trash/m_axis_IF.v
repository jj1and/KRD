`timescale 1 ns / 1 ps

module m_axis_IF # (

    // threshold ( percentage of max value = 2^12)
    parameter integer THRESHOLD = 10,
    
    // acquiasion length settings
    parameter integer PRE_ACQUI_LEN = 24/2,
    parameter integer POST_ACQUI_LEN = 76/2,

    // FIFO depth setting
    parameter integer ACQUI_LEN = 200/2,

    // TIME STAMP DATA WIDTH
    parameter integer TIME_STAMP_WIDTH = 16,

    // RFSoC ADC resolution
    parameter integer ADC_RESOLUTION_WIDTH = 12,
    
    // RF Data Converter data stream bus width
    parameter integer S_AXIS_TDATA_WIDTH = 128,

    // AXI DMA S2MM bus width
    parameter integer M_AXIS_TDATA_WIDTH = 64

)
(    
    
    // triggered time stanp
	input wire [TIME_STAMP_WIDTH-1:0] TIME_STAMP,

    // start trigger flag
    input wire TRIGGERD_FLAG,

    // internal fifo full flag
    output wire O_FIFO_FULL,

    // Ports of Axi-stream Bus Interface
    input wire  AXIS_ACLK,
    input wire  AXIS_ARESETN,

    // Ports of Axi-stream Slave Bus Interface　
    input wire  S_AXIS_TREADY,
    input wire [S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
    input wire  S_AXIS_TVALID,

    // Ports of Axi-stream Master Bus Interface
    output wire [M_AXIS_TDATA_WIDTH-1:0] M_AXIS_TDATA,
    output wire M_AXIS_TVALID,
    output wire M_AXIS_TLAST,
    output wire M_AXIS_TUSER,
    input wire M_AXIS_TREADY
);

	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction
   
  localparam integer BIT_DIFF = S_AXIS_TDATA_WIDTH/M_AXIS_TDATA_WIDTH;
  localparam integer BIT_CONVERT_CNT_WIDTH = clogb2(BIT_DIFF-1);
  integer i;

  // pre acquiasion buffer write enable
  wire pre_wren;
  assign pre_wren = S_AXIS_TVALID&S_AXIS_TREADY;
  
  // data to put into FIFO
  reg [S_AXIS_TDATA_WIDTH-1:0] fifo_input;

  // fifo data output
  wire [M_AXIS_TDATA_WIDTH-1:0] fifo_output;
  
  // bit width convert buffer
  reg [S_AXIS_TDATA_WIDTH-1:0] bit_conv_buff[BIT_DIFF-1:0];

  // bit width converting counter
  reg [BIT_CONVERT_CNT_WIDTH-1:0] bit_conv_cnt;

  // fifo read out counter
  reg [ACQUI_LEN*BIT_DIFF-1:0] fifo_read_cnt;
  // finalize counter
  reg [ACQUI_LEN*BIT_DIFF-1:0] fin_read_cnt;

  // fifo read enable
  wire fifo_reen;

  // fifo empty
  wire fifo_empty;

  // fifo full
  wire fifo_full;
  assign O_FIFO_FULL = fifo_full;

  // fifo 1hit dout done
  wire DOUT_DONE;
  wire dout_done_delay;

  // start_trg delay
  wire triggerd_flag_delay;

  // first/last_flag
  wire first_data_flag;
  wire last_data_flag;
  wire last_data_flag_delay;

  assign M_AXIS_TUSER = first_data_flag;
  assign M_AXIS_TLAST = last_data_flag_delay;
  assign fifo_reen = !fifo_empty;
  assign M_AXIS_TVALID = fifo_reen;

  wire [TIME_STAMP_WIDTH-1:0] next_time_stamp;

  // S_AXIS_TDATA_delay
  wire [M_AXIS_TDATA_WIDTH-1:0] m_axis_tdata_delay;

  Ring_buffer # (
      .DIN_WIDTH(S_AXIS_TDATA_WIDTH),
      .DOUT_WIDTH(M_AXIS_TDATA_WIDTH),
      .FIFO_DEPTH(ACQUI_LEN*BIT_DIFF*10),
      .PRE_ACQUI_LEN(PRE_ACQUI_LEN)
  ) Ring_buff_inst ( 
      .CLK(AXIS_ACLK),
      .RESET(AXIS_ARESETN),
      .DIN(S_AXIS_TDATA),
      .DOUT(fifo_output),
      .WE(S_AXIS_TVALID),
      .RE(fifo_reen),
      .TRIGGERD_FLAG(TRIGGERD_FLAG),
      .O_DOUT_DONE(DOUT_DONE),
      .FIRST_DATA_FLAG(first_data_flag),
      .LAST_DATA_FLAG(last_data_flag),
      .EMPTY(fifo_empty),
      .FULL(fifo_full)
  );

  Delay #(
    .DELAY_CLK(1),
    .WIDTH(M_AXIS_TDATA_WIDTH)
  ) s_axis_tdata_delay_inst (
    .CLK(AXIS_ACLK),
    .RESETn(AXIS_ARESETN),
    .DIN(fifo_output),
    .DOUT(m_axis_tdata_delay)
  );

  Delay #(
    .DELAY_CLK(2),
    .WIDTH(1)
  ) dout_done_delay_inst (
    .CLK(AXIS_ACLK),
    .RESETn(AXIS_ARESETN),
    .DIN(DOUT_DONE),
    .DOUT(dout_done_delay)
  );
    
  Delay #(
    .DELAY_CLK(1),
    .WIDTH(1)
  ) triggerd_flag_delay_inst (
    .CLK(AXIS_ACLK),
    .RESETn(AXIS_ARESETN),
    .DIN(TRIGGERD_FLAG),
    .DOUT(triggerd_flag_delay)
  );
 
  Delay #(
    .DELAY_CLK(1),
    .WIDTH(1)
  ) lats_data_flag_delay_inst (
    .CLK(AXIS_ACLK),
    .RESETn(AXIS_ARESETN),
    .DIN(last_data_flag),
    .DOUT(last_data_flag_delay)
  );

  Fifo # (
    .WIDTH(TIME_STAMP_WIDTH),
    .DEPTH(ACQUI_LEN)
  ) time_stamp_fifo (
    .CLK(AXIS_ACLK),
    .RESET(AXIS_ARESETN),
    .DIN(TIME_STAMP),
    .DOUT(next_time_stamp),
    .WE(TRIGGERD_FLAG&&(!triggerd_flag_delay)),
    .RE(first_data_flag),
    .EMPTY(),
    .ALMOST_EMPTY(),
    .FULL()
  );

  assign M_AXIS_TDATA = first_data_flag ? next_time_stamp: m_axis_tdata_delay; 

endmodule