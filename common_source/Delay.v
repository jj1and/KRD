`timescale 1 ns / 1 ps

module Delay # (
  parameter integer DELAY_CLK = 1,
  parameter integer WIDTH = 1

)
(
  input wire CLK,
  input wire RESETN,
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

  generate
  if (DELAY_CLK <= 1) begin
    
    reg [WIDTH-1:0] dout;
    assign DOUT = dout;

    always @(posedge CLK ) begin
      dout <= DIN;
    end

  end else begin
    
    reg [DELAY_CNT_WIDTH-1:0] delay_cnt;
    wire full;
    wire write_enD;
    reg write_en;
    reg read_en;

    assign write_enD = !full;

    Fifo # (
      .WIDTH(WIDTH),
      .DEPTH(DELAY_CLK)
    ) delay_buff (
      .CLK(CLK),
      .RESETN(RESETN),
      .DIN(DIN),
      .DOUT(DOUT),
      .WE(write_en),
      .RE(read_en),
      .NOT_EMPTY(),
      .FULL(full)
    );
    
    always @(posedge CLK ) begin
      if (!RESETN) begin
        read_en <= 1'b0;
        delay_cnt <= 0;
      end else begin
        if (delay_cnt >= DELAY_CLK) begin
          delay_cnt <= delay_cnt;
          read_en <= 1'b1;
        end else begin
          delay_cnt <= delay_cnt + 1;
          read_en <= 1'b0;
        end
      end
    end

    always @(posedge CLK) begin
      if (!RESETN) begin
        write_en <= 1'b0;
      end else begin
        write_en <= write_enD;
      end
    end
  
  end
  endgenerate

endmodule