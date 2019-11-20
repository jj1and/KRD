`timescale 1 ps / 1 ps

module Fifo # (
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 32,
    parameter integer PROG_FULL_THRE = 30,
    parameter integer PROG_EMPTY_THRE = 2,
    parameter INIT_VALUE = {WIDTH{1'b1}}
)
(
    input wire CLK,
    input wire RESETN,
    input wire [WIDTH-1:0] DIN,
    output wire [WIDTH-1:0] DOUT,
    input wire WE,
    input wire RE,
    output wire NOT_EMPTY,
    output wire FULL,
    output wire PROGRAMMABLE_FULL,
    output wire PROGRAMMABLE_EMPTY
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

  integer i;

  reg [WIDTH-1:0] sram[ACTUAL_DEPTH-1:0];
  
  wire [DEPTH_BIT_WIDTH:0] next_wp;
  wire [DEPTH_BIT_WIDTH:0] wpD;
  reg [DEPTH_BIT_WIDTH:0]  wp;

  wire [DEPTH_BIT_WIDTH:0] next_rp;
  wire [DEPTH_BIT_WIDTH:0] rpD;
  reg [DEPTH_BIT_WIDTH:0] rp;

  wire not_emptyD;
  reg not_empty;

  wire fullD;
  reg full;

  wire wp_inc;
  wire rp_inc;
   
  assign wp_inc = WE&(!full);
  assign rp_inc = RE&not_empty;

  assign wpD = wp + {{ACTUAL_DEPTH-1{1'b0}}, wp_inc};
  assign rpD = rp + {{ACTUAL_DEPTH-1{1'b0}}, rp_inc};

  assign next_wp = wp + 1;
  assign next_rp = rp + 1; 

  assign fullD = ( (next_wp[DEPTH_BIT_WIDTH] != rp[DEPTH_BIT_WIDTH]) && (next_wp[DEPTH_BIT_WIDTH-1:0] == rp[DEPTH_BIT_WIDTH-1:0]) );
  assign not_emptyD = (wp != rp);

  assign NOT_EMPTY = not_empty;
  assign FULL = full;

  assign PROGRAMMABLE_EMPTY = ((wp-rp)<=PROG_EMPTY_THRE);
  assign PROGRAMMABLE_FULL = ((wp-rp)>=PROG_FULL_THRE);

  assign DOUT = sram[rp[DEPTH_BIT_WIDTH-1:0]];

  
  always @(posedge CLK ) begin
    if (!RESETN) begin
      for ( i=0 ; i<ACTUAL_DEPTH ; i=i+1 ) begin
          sram[i] <= #400 INIT_VALUE;
        end      
    end else begin
      if (wp_inc) begin
        sram[wp[DEPTH_BIT_WIDTH-1:0]] <= DIN; 
      end else begin
        for ( i=0 ; i<ACTUAL_DEPTH ; i=i+1 ) begin
            sram[i] <= #400 sram[i];
          end
      end      
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      full <= #400 1'b0;
      not_empty <= #400 1'b0;
    end else begin
      full <= #400 fullD;
      not_empty <= #400 not_emptyD;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      wp <= #400 0;
    end else begin
      if (wp_inc) begin
        wp <= #400 wp + 1;
      end else begin
        wp <= #400 wp;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      rp <= #400 0;
    end else begin
      if (rp_inc) begin
        rp <= #400 rp + 1;
      end else begin
        rp <= #400 rp;
      end
    end
  end

endmodule