`timescale 1 ns / 1 ps

module Variable_delay # (
  parameter integer MAX_DELAY_CLK = 100,
  parameter integer WIDTH = 1

)
(
  input wire CLK,
  input wire RESETN,
  input wire [MAX_DELAY_CNT_WIDTH-1:0] DELAY_CLK,
  input wire [WIDTH-1:0] DIN,
  output wire [WIDTH-1:0] DOUT,
  output wire READY,
  output wire VALID
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth); begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer MAX_DELAY_CNT_WIDTH = clogb2(MAX_DELAY_CLK);

    wire full;
    wire not_empty;

    reg [MAX_DELAY_CNT_WIDTH-1:0] delay_cnt;
    reg [MAX_DELAY_CNT_WIDTH-1:0] delay_clk;
    reg write_en;
    reg read_en;
    reg valid;
    assign VALID = valid;
    assign READY = write_en;

    Fifo # (
      .WIDTH(WIDTH),
      .DEPTH(MAX_DELAY_CLK)
    ) delay_buff (
      .CLK(CLK),
      .RESETN(RESETN),
      .DIN(DIN),
      .DOUT(DOUT),
      .WE(write_en),
      .RE(read_en),
      .NOT_EMPTY(not_empty),
      .FULL(full)
    );
    
    always @(posedge CLK ) begin
      if (!RESETN) begin
        read_en <= 1'b0;
        delay_cnt <= 0;
        delay_clk <= DELAY_CLK;
      end else begin
        if (delay_cnt >= delay_clk) begin
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
        if (!full) begin
          write_en <= 1'b1;
        end else begin
          write_en <= 1'b0;
        end
      end
    end

    always @(posedge CLK) begin
      if (!RESETN) begin
        valid <= 1'b0;
      end else begin
        if (not_empty && (delay_cnt >= delay_clk)) begin
          valid <= 1'b1;
        end else begin
          valid <= 1'b0;
        end
      end
    end

endmodule