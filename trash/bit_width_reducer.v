`timescale 1 ns / 1 ps

module bit_width_reducer # (
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
  localparam integer ALMOST_FULL_ASSERT_RATE = 90;

  wire [DIN_WIDTH-1:0] fifo_dout;
  wire fifo_not_empty;
  wire fifo_full;
  wire fifo_almost_full;

  reg [BIT_CONV_COUNT_WIDTH-1:0] conv_count = 0;
  wire write_en;
  wire read_en;

  wire [DOUT_WIDTH-1:0] divide_dout[BIT_DIFF-1:0];
  // wire [DOUT_WIDTH-1:0] reduced_dout;
  reg valid;
  reg ready;

  assign read_en = fifo_not_empty && (conv_count == BIT_DIFF-1);
  assign DOUT = divide_dout[conv_count];
  assign CONVERT_VALID = valid;
  assign CONVERT_READY = ready;
  assign write_en = DIN_VALID;

  Threshold_Fifo # (
    .WIDTH(DIN_WIDTH),
    .DEPTH(BIT_DIFF*CONVERT_MARGIN),
    .ALMOST_FULL_ASSERT_RATE(ALMOST_FULL_ASSERT_RATE)
  ) convert_buff_inst (
    .CLK(CLK),
    .RESETN(RESETN),
    .DIN(DIN),
    .DOUT(fifo_dout),
    .WE(write_en),
    .RE(read_en),
    .NOT_EMPTY(fifo_not_empty),
    .ALMOST_FULL(fifo_almost_full),
    .FULL(fifo_full)
  );

  // always @(posedge CLK) begin
  //   reduced_dout <= divide_dout[conv_count];
  // end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      conv_count <= 0;
    end else begin
      if (valid) begin
        if (conv_count >= BIT_DIFF-1) begin
          conv_count <= 0;
        end else begin
          conv_count <= conv_count + 1;
        end
      end else begin
        conv_count <= 0;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      valid <= 1'b0;
      ready <= 1'b0;
    end else begin
      valid <= fifo_not_empty;
      ready <= !fifo_almost_full;
    end
  end

  genvar i;
  generate
    for ( i=0 ; i<BIT_DIFF ; i=i+1 ) begin
      assign divide_dout[i] = fifo_dout[DOUT_WIDTH*i +:DOUT_WIDTH];
    end
  endgenerate

endmodule