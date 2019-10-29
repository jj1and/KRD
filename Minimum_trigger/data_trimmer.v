`timescale 1 ps / 1 ps

module data_trimmer # (
  parameter integer DATA_WIDTH = 64
)(
  input wire CLK,
  input wire RESETN,
  input wire [DATA_WIDTH-1:0] DIN,
  input wire DIN_VALID,
  output wire [DATA_WIDTH-1:0] DOUT,
  output wire TRIMMER_VALID,
  output wire TRIMMER_READY
);
  
  localparam integer FIFO_DEPTH = 3;

  wire [DATA_WIDTH-1:0] doutD;
  reg [DATA_WIDTH-1:0] dout;
  
  wire trimmer_validD;
  reg trimmer_valid;
  
  wire trimmer_readyD;
  reg trimmer_ready;

  wire write_en;
  wire read_en;
  wire not_empty;
  wire full;

  assign write_en = (~&DIN)&&(DIN_VALID);
  assign read_en = not_empty;
  assign trimmer_validD = not_empty;
  assign trimmer_readyD = !full;

  assign DOUT = dout;
  assign TRIMMER_VALID = trimmer_valid;
  assign TRIMMER_READY = trimmer_ready;

  always @(posedge CLK ) begin
    if (!RESETN) begin
      trimmer_valid <= 1'b0;
      trimmer_ready <= 1'b0;
      dout <= {DATA_WIDTH{1'b1}};
    end else begin
      trimmer_valid <= trimmer_validD;
      trimmer_ready <= trimmer_readyD;
      dout <= doutD;
    end
  end

  Fifo # (
    .WIDTH(DATA_WIDTH),
    .DEPTH(FIFO_DEPTH)
  ) trimmer_fifo_inst (
    .CLK(CLK),
    .RESETN(RESETN),
    .DIN(DIN),
    .DOUT(doutD),
    .WE(write_en),
    .RE(read_en),
    .NOT_EMPTY(not_empty),
    .FULL(full)
  );

endmodule