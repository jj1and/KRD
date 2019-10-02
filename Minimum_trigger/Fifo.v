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
    output wire EMPTY,
    output wire FULL
);

    integer i;

    reg [WIDTH-1:0] SRAM[DEPTH-1:0];
    reg [DEPTH-1:0] WP;
    reg [DEPTH-1:0] RP;

    assign DOUT = SRAM[RP];
    assign EMPTY = (WP == RP);
    assign FULL = (WP+1 == RP);

    always @(posedge CLK )
    begin
      if (!RESET)
        begin
          for ( i=0 ; i<WIDTH ; i=i+1 )
            begin
              SRAM[i] <= 0;
            end
        end
      else
        begin
          if ( WE & (WP+1 != RP) )
            begin
              SRAM[WP] <= DIN; 
            end
          else
            begin
              for ( i=0 ; i<WIDTH ; i=i+1 )
                begin
                  SRAM[i] <= SRAM[i];
                end 
            end
        end
    end

    always @(posedge CLK )
    begin
      if (!RESET)
        begin
          WP <= 0;  
        end
      else
        begin
          if ( WE & (WP+1 != RP) )
            begin
              if (WP == DEPTH-1)
                begin
                  WP <= 0;
                end 
              else
                begin
                  WP <= WP + 1;
                end
            end
          else
            begin
              WP <= WP;
            end          
        end    
    end

    always @(posedge CLK )
    begin
      if (!RESET)
        begin
          RP <= 0;  
        end
      else
        begin
          if ( RE & (RP != WP) )
            begin
              if (RP == DEPTH-1)
                begin
                  RP <= 0;
                end 
              else
                begin
                  RP <= RP + 1;
                end
            end
          else
            begin
              RP <= RP;
            end          
        end    
    end

endmodule