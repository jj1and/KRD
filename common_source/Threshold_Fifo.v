`timescale 1 ns / 1 ps

module Threshold_Fifo # (
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 32,
    parameter integer ALMOST_FULL_ASSERT_RATE = 95
)
(
    input wire CLK,
    input wire RESETN,
    input wire [WIDTH-1:0] DIN,
    output wire [WIDTH-1:0] DOUT,
    input wire WE,
    input wire RE,
    output wire NOT_EMPTY,
    output wire ALMOST_FULL,
    output wire FULL
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth); begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer DEPTH_BIT_WIDTH = clogb2(DEPTH-1);
  localparam integer ACTUAL_DEPTH = 2**DEPTH_BIT_WIDTH;
  localparam integer ALMOST_FULL_ASSERT_DIFF = (ACTUAL_DEPTH*ALMOST_FULL_ASSERT_RATE)/100;

  integer i;

  reg [WIDTH-1:0] sram[ACTUAL_DEPTH-1:0];
  reg [WIDTH-1:0] dout;
  assign DOUT = dout;
  
  wire [DEPTH_BIT_WIDTH:0] wpD;
  reg [DEPTH_BIT_WIDTH:0]  wp;

  wire [DEPTH_BIT_WIDTH:0] rpD;
  reg [DEPTH_BIT_WIDTH:0] rp;

  wire not_emptyD;
  reg not_empty;

  wire [DEPTH_BIT_WIDTH:0] diff;
  wire almost_fullD;
  reg almost_full;

  wire fullD;
  reg full;

  wire wp_inc;
  wire rp_inc;
  
  assign wp_inc = WE&(!full);
  assign rp_inc = RE&not_empty;

  assign wpD = wp + {{ACTUAL_DEPTH-1{1'b0}}, wp_inc};
  assign rpD = rp + {{ACTUAL_DEPTH-1{1'b0}}, rp_inc};

  assign fullD = ( (wpD[DEPTH_BIT_WIDTH] != rpD[DEPTH_BIT_WIDTH]) && (wpD[DEPTH_BIT_WIDTH-1:0] == rpD[DEPTH_BIT_WIDTH-1:0]) );
  assign not_emptyD = (wpD != rpD);
  assign diff = (wpD - rpD);
  assign almost_fullD = (diff > ALMOST_FULL_ASSERT_DIFF);

  assign NOT_EMPTY = not_empty;
  assign ALMOST_FULL = almost_full;
  assign FULL = full;

  
  always @(posedge CLK ) begin
    if (wp_inc) begin
      sram[wp[DEPTH_BIT_WIDTH-1:0]] <= DIN; 
    end else begin
      for ( i=0 ; i<ACTUAL_DEPTH ; i=i+1 ) begin
          sram[i] <= sram[i];
        end
    end
  end

  always @(posedge CLK ) begin
    if (wp_inc && (wp[DEPTH_BIT_WIDTH-1:0] == rpD[DEPTH_BIT_WIDTH-1:0]) ) begin
      dout <= DIN;
    end else begin
      dout <= sram[rpD[DEPTH_BIT_WIDTH-1:0]];
    end    
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      full <=1'b0;
      almost_full <= 1'b0;
      not_empty <= 1'b0;
    end else begin
      full <= fullD;
      almost_full <= almost_fullD;
      not_empty <= not_emptyD;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      wp <= 0;
      rp <= 0;
    end else begin
      wp <= wpD;
      rp <= rpD;
    end
  end

endmodule