`timescale 1 ps / 1 ps

module Variable_delay_mod # (
  parameter integer MAX_DELAY_CNT_WIDTH = 7,
  parameter integer WIDTH = 1

)
(
  input wire CLK,
  input wire RESETN,
  input wire [MAX_DELAY_CNT_WIDTH-1:0] DELAY,
  input wire [WIDTH-1:0] DIN,
  output wire [WIDTH-1:0] DOUT,
  output wire [WIDTH-1:0] FIFO_DIN,
  output wire FIFO_WE,
  output wire FIFO_RE,
  input wire [WIDTH-1:0] FIFO_DOUT,
  input wire FIFO_NOT_EMPTY,
  input wire FIFO_FULL,
  output wire DELAY_READY,
  output wire DELAY_VALID
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth); begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction

  wire full;
  wire not_empty;

  reg [MAX_DELAY_CNT_WIDTH-1:0] delay_cnt;
  reg [MAX_DELAY_CNT_WIDTH-1:0] delay;
  reg write_en;
  reg read_en;
  reg valid;
  assign DELAY_VALID = valid;
  assign DELAY_READY = write_en;
  assign FIFO_DIN = DIN;
  assign FIFO_WE = write_en;
  assign FIFO_RE = read_en;
  assign not_empty = FIFO_NOT_EMPTY;
  assign full = FIFO_FULL;
  assign DOUT = FIFO_DOUT;
  
  always @(posedge CLK ) begin
    if (!RESETN) begin
      read_en <= #400 1'b0;
      delay_cnt <= #400 0;
      delay <= #400 DELAY;
    end else begin
      if (delay_cnt >= delay) begin
        delay_cnt <= #400 delay;
        read_en <= #400 1'b1;
      end else begin
        delay_cnt <= #400 delay_cnt + 1;
        read_en <= #400 1'b0;
      end
    end
  end

  always @(posedge CLK) begin
    if (!RESETN) begin
      write_en <= #400 1'b0;
    end else begin
      if (!full) begin
        write_en <= #400 1'b1;
      end else begin
        write_en <= #400 1'b0;
      end
    end
  end

  always @(posedge CLK) begin
    if (!RESETN) begin
      valid <= #400 1'b0;
    end else begin
      if (not_empty && (delay_cnt >= delay)) begin
        valid <= #400 1'b1;
      end else begin
        valid <= #400 1'b0;
      end
    end
  end

endmodule