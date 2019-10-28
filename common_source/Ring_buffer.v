`timescale 1 ns / 1 ps

module Ring_buffer # (
    parameter integer WIDTH = 128,
    parameter integer FIFO_DEPTH = 100,
    parameter integer MAX_BACK_LEN = 40,
    parameter integer ALMOST_FULL_ASSERT_RATE = 50
)
(
    input wire CLK,
    input wire RESETN,
    input wire [MAX_BACK_LEN_WIDTH-1:0] BACK_LEN,
    input wire [WIDTH-1:0] DIN,
    output wire [WIDTH-1:0] DOUT,
    input wire WE,
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
  localparam integer MAX_BACK_LEN_WIDTH = clogb2(MAX_BACK_LEN);

  wire [WIDTH-1:0] delay_dout;
  wire delay_ready;
  wire delay_valid;

  wire [WIDTH-1:0] dout;

  wire not_empty;
  wire read_en;
  wire write_en;
  wire almost_full;

  assign write_en = WE&&delay_valid;
  assign read_en = RE;
  
  assign BUFF_WRITE_READY = (!full)&&delay_ready;
  assign BUFF_READ_VALID = not_empty;
  assign BUFF_ALMOST_FULL = almost_full;
  
  Variable_delay # (
    .MAX_DELAY_CLK(MAX_BACK_LEN),
    .WIDTH(WIDTH)
  ) back_delay (
    .CLK(CLK),
    .RESETN(RESETN),
    .DELAY_CLK(BACK_LEN),
    .DIN(DIN),
    .DOUT(delay_dout),
    .DELAY_READY(delay_ready),
    .DELAY_VALID(delay_valid)
  );

  Threshold_Fifo # (
    .WIDTH(WIDTH),
    .DEPTH(FIFO_DEPTH),
    .ALMOST_FULL_ASSERT_RATE(ALMOST_FULL_ASSERT_RATE)
  ) buff_fifo (
    .CLK(CLK),
    .RESETN(RESETN),
    .DIN(delay_dout),
    .DOUT(DOUT),
    .WE(write_en),
    .RE(read_en),
    .NOT_EMPTY(not_empty),
    .ALMOST_FULL(almost_full),
    .FULL(full)
  );

endmodule