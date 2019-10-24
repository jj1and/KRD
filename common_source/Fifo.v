`timescale 1 ns / 1 ps

module Fifo # (
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 32
)
(
    input wire CLK,
    input wire RESET,
    input wire [WIDTH-1:0] DIN,
    output wire [WIDTH-1:0] DOUT,
    input wire WE,
    input wire RE,
    output wire ALMOST_EMPTY,
    output wire EMPTY,
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

  integer i;

  reg [WIDTH-1:0] SRAM[DEPTH-1:0];
  reg [DEPTH_BIT_WIDTH-1:0] WP;
  reg [DEPTH_BIT_WIDTH-1:0] RP;

  assign DOUT = SRAM[RP];
  assign EMPTY = (WP == RP);
  assign ALMOST_EMPTY = (WP-1 == RP);
  assign FULL = (WP+1 == RP);

  always @(posedge CLK ) begin
    if (!RESET) begin
      for ( i=0 ; i<DEPTH ; i=i+1 )
        begin
          SRAM[i] <= 0;
        end
    end else begin
      if ( WE & (WP+1 != RP)) begin
        SRAM[WP] <= DIN; 
      end else begin
        for ( i=0 ; i<DEPTH ; i=i+1 )
          begin
            SRAM[i] <= SRAM[i];
          end 
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESET) begin
        WP <= 0;  
    end else begin
        if ( WE & (!FULL) ) begin
            if (WP == DEPTH-1) begin
              WP <= 0;
            end else begin
              WP <= WP + 1;
            end
        end else begin
          WP <= WP;
        end          
    end    
  end

  always @(posedge CLK ) begin
    if (!RESET) begin
      RP <= 0;  
    end else begin
      if ( RE & (!EMPTY) ) begin
        if (RP == DEPTH-1) begin
          RP <= 0;
        end else begin
          RP <= RP + 1;
        end
      end else begin
        RP <= RP;
      end          
    end    
  end

endmodule