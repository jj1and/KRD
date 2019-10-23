`timescale 1 ns / 1 ps

module Delay # (
    parameter integer DELAY_CLK = 1,
    parameter integer WIDTH = 1

)
(
    input wire CLK,
    input wire RESETn,
    input wire [WIDTH-1:0] DIN,
    output wire [WIDTH-1:0] DOUT
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth); begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer DELAY_CNT_WIDTH = clogb2(DELAY_CLK);

  reg [DELAY_CNT_WIDTH-1:0] delay_cnt; 
  wire fifo_full;
  wire fifo_empty;
  reg read_en;
  reg write_en;

  Fifo # (
      .WIDTH(WIDTH),
      .DEPTH(DELAY_CLK+2)
  ) delay_fifo (
      .CLK(CLK),
      .RESET(RESETn),
      .DIN(DIN),
      .DOUT(DOUT),
      .WE(write_en),
      .RE(read_en),
      .EMPTY(fifo_empty),
      .ALMOST_EMPTY(),
      .FULL(fifo_full)
  );


  always @(posedge CLK) begin
    if (!RESETn) begin
      delay_cnt <= 0;
    end else begin
      if (delay_cnt >= DELAY_CLK) begin
        delay_cnt <= delay_cnt;
      end else begin
          delay_cnt <= delay_cnt + 1;
      end
    end
  end
      
  always @(posedge CLK) begin
    if (!RESETn) begin
      read_en <= 1'b0;
    end else begin
      if (delay_cnt >= DELAY_CLK) begin
        read_en <= 1'b1;    
      end else begin
        read_en <= 1'b0;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETn) begin
      write_en <= 1'b0;
    end else begin
      if (!fifo_full) begin
        write_en <= 1'b1;
      end else begin
        write_en <= 1'b0;
      end
    end 
  end

endmodule