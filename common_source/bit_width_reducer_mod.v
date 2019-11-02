`timescale 1 ps / 1 ps

module bit_width_reducer_mod # (
  parameter integer DIN_WIDTH = 128,
  parameter integer DOUT_WIDTH =64,
  // internal fifo depth = (DIN_WIDTH/DOUT_WIDTH)*CONVERT_MARGIN
  parameter integer CONVERT_MARGIN = 200/2
)
(
  input wire CLK,
  input wire RESETN,
  input wire [DIN_WIDTH-1:0] DIN,
  input wire DIN_VALID,
  output wire [DOUT_WIDTH-1:0] DOUT,
  output wire [DIN_WIDTH-1:0] FIFO_DIN,
  output wire FIFO_WE,
  output wire FIFO_RE,
  input wire [DIN_WIDTH-1:0] FIFO_DOUT,
  input wire FIFO_NOT_EMPTY,
  input wire FIFO_FULL,
  input wire FIFO_ALMOST_FULL, 
  output wire CONVERT_READY,
  output wire CONVERT_VALID
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth); begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer BIT_DIFF = DIN_WIDTH/DOUT_WIDTH;
  localparam integer BIT_CONV_COUNT_WIDTH = clogb2(BIT_DIFF-1);

  // wire [DIN_WIDTH-1:0] fifo_dout;
  // wire fifo_not_empty;
  // wire fifo_full;
  // wire fifo_almost_full;

  reg [BIT_CONV_COUNT_WIDTH-1:0] conv_count = 0;
  reg divide_en;
  wire write_en;
  wire read_en;

  wire [DOUT_WIDTH-1:0] doutD;
  reg [DOUT_WIDTH-1:0] dout;
  wire [DOUT_WIDTH-1:0] divide_dout[BIT_DIFF-1:0];
  // wire [DOUT_WIDTH-1:0] reduced_dout;
  reg fifo_not_empty;
  reg valid;
  reg ready;

  assign read_en = FIFO_NOT_EMPTY&divide_en;

  assign doutD = divide_dout[conv_count];
  assign DOUT = dout;
  assign CONVERT_VALID = valid;
  assign CONVERT_READY = ready;
  assign write_en = DIN_VALID;
  assign FIFO_DIN = DIN;
  assign FIFO_WE = write_en;
  assign FIFO_RE = read_en;


  // always @(posedge CLK) begin
  //   reduced_dout <= divide_dout[conv_count];
  // end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      conv_count <= #1 0;
      divide_en <= #1 1'b0;
    end else begin
        if (conv_count >= BIT_DIFF-1) begin
          conv_count <= #1 0;
          divide_en <= #1 1'b1;
        end else begin
          conv_count <= #1 conv_count + 1;
          divide_en <= #1 1'b0;
        end;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      fifo_not_empty <= #1 1'b0; 
      valid <= #1 1'b0;
      ready <= #1 1'b0;
      dout <= #1 {DOUT_WIDTH{1'b1}};
    end else begin
      fifo_not_empty <= #1 FIFO_NOT_EMPTY;
      valid <= #1 fifo_not_empty;
      ready <= #1 !(FIFO_ALMOST_FULL|FIFO_FULL);
      dout <= #1 doutD;
    end
  end

  genvar i;
  generate
    for ( i=0 ; i<BIT_DIFF ; i=i+1 ) begin
      assign divide_dout[i] = FIFO_DOUT[DOUT_WIDTH*i +:DOUT_WIDTH];
    end
  endgenerate

endmodule