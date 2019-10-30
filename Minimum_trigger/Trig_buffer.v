`timescale 1 ns / 1 ps

module Trig_buffer # (
    parameter integer WIDTH = 128,
    parameter integer HEADER_FOOTER_WIDTH = 64,
    parameter integer TIME_STAMP_WIDTH = 49,
    parameter integer ADC_RESOLUTION_WIDTH = 12,
    parameter integer CHANNEL_ID = 0,
    parameter integer FIFO_DEPTH = 100,
    parameter integer MAX_BACK_LEN_WIDTH = 6,
    parameter integer ALMOST_FULL_ASSERT_RATE = 50
)
(
    input wire CLK,
    input wire RESETN,
    input wire [MAX_BACK_LEN_WIDTH-1:0] BACK_LEN,
    input wire [WIDTH-1:0] DIN,
    output wire [WIDTH-1:0] DOUT,
    input wire TRIGGERED,
    input wire [TIME_STAMP_WIDTH-1:0] TIME_STAMP,
    input wire [ADC_RESOLUTION_WIDTH+1-1:0] THRESHOLD_WHEN_HIT,
    input wire [ADC_RESOLUTION_WIDTH-1:0] BASELINE_WHEN_HIT,
    input wire RE,
    output wire BUFF_WRITE_READY,
    output wire BUFF_READ_VALID,
    output wire BUFF_ALMOST_FULL
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth);
    begin
      for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
        bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer DEPTH_WIDTH = clogb2(FIFO_DEPTH-1);

  wire [WIDTH-1:0] delay_dout;
  wire delay_ready;
  wire delay_valid;

  wire [WIDTH-1:0] adding_dout;
  wire adding_valid;

  wire not_empty;
  wire read_en;
  wire almost_full;

  assign read_en = RE;
  
  assign BUFF_WRITE_READY = (!full)&&delay_ready;
  assign BUFF_READ_VALID = not_empty&read_en;
  assign BUFF_ALMOST_FULL = almost_full;

  Variable_delay # (
    .MAX_DELAY_CNT_WIDTH(MAX_BACK_LEN_WIDTH),
    .WIDTH(WIDTH)
  ) back_delay (
    .CLK(CLK),
    .RESETN(RESETN),
    .DELAY(BACK_LEN),
    .DIN(DIN),
    .DOUT(delay_dout),
    .DELAY_READY(delay_ready),
    .DELAY_VALID(delay_valid)
  ); 

  add_header_footer # (
    .DATA_WIDTH(WIDTH),
    .HEADER_FOOTER_WIDTH(HEADER_FOOTER_WIDTH),
    .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
    .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
    .CHANNEL_ID(CHANNEL_ID)
  ) add_header_footer_inst (
    .CLK(CLK),
    .RESETN(RESETN),
    .DIN_VALID(delay_valid),
    .TRIGGERED(TRIGGERED),
    .TIME_STAMP(TIME_STAMP),
    .THRESHOLD_WHEN_HIT(THRESHOLD_WHEN_HIT),
    .BASELINE_WHEN_HIT(BASELINE_WHEN_HIT),
    .DIN(delay_dout),
    .DOUT(adding_dout),
    .ADDING_VALID(adding_valid)
  );

  Threshold_Fifo # (
    .WIDTH(WIDTH),
    .DEPTH(FIFO_DEPTH),
    .ALMOST_FULL_ASSERT_RATE(ALMOST_FULL_ASSERT_RATE)
  ) buff_fifo (
    .CLK(CLK),
    .RESETN(RESETN),
    .DIN(adding_dout),
    .DOUT(DOUT),
    .WE(adding_valid),
    .RE(read_en),
    .NOT_EMPTY(not_empty),
    .ALMOST_FULL(almost_full),
    .FULL(full)
  );

endmodule