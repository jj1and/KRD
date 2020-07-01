`timescale 1 ps / 1 ps

module bit_width_reducer_mod # (
  parameter integer DIN_WIDTH = 128,
  parameter integer DOUT_WIDTH =64
)
(
  input wire CLK,
  input wire RESETN,
  input wire DIN_VALID,
  input wire [DIN_WIDTH-1:0] DIN,
  output wire [DOUT_WIDTH-1:0] DOUT,
  output wire FIFO_WE,
  output wire FIFO_RE,
  output wire [DIN_WIDTH-1:0] FIFO_DIN,
  input wire [DIN_WIDTH-1:0] FIFO_DOUT,
  input wire FIFO_EMPTY,
  input wire FIFO_FULL,
  input wire FIFO_RST_BUSY,
  input wire MODULE_READY,
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

  reg [BIT_CONV_COUNT_WIDTH:0] conv_count;
  wire divide_en;
  reg divide_en_delay;
  wire read_ready;
  reg read_ready_delay;
  wire fast_read_ready_posedge;
  reg read_en;
  reg re_delay;

  reg [DIN_WIDTH-1:0] din;
  reg din_valid;

  wire [DOUT_WIDTH-1:0] convd_dataD;
  reg [DOUT_WIDTH-1:0] convd_data;
  reg [DOUT_WIDTH-1:0] dout;
  wire [DOUT_WIDTH-1:0] divide_dout[BIT_DIFF:0];
  wire convert_readyD;
  reg convert_ready;
  reg validD;
  reg valid;
  reg ready;

  assign read_ready = &{~FIFO_EMPTY, MODULE_READY, ~FIFO_RST_BUSY};
  assign fast_read_ready_posedge = (read_ready==1'b1)&(read_ready_delay==1'b0);
  assign divide_dout[BIT_DIFF] = {DOUT_WIDTH{1'b1}};
  assign convd_dataD = divide_dout[conv_count];
  assign FIFO_DIN = din;
  assign FIFO_WE = din_valid;
  assign DOUT = dout;
  assign CONVERT_VALID = valid;
  assign convert_readyD = (~FIFO_FULL)&(~FIFO_RST_BUSY);
  assign CONVERT_READY = convert_ready;
  assign divide_en = (conv_count >= BIT_DIFF-1);
  assign FIFO_RE = read_en;

  always @(posedge CLK ) begin
    if (!RESETN) begin
      din  <= #400 {DIN_WIDTH{1'b1}};
      din_valid <= #400 1'b1;
      convert_ready <= #400 1'b1;
    end else begin
      din <= #400 DIN;
      din_valid <= #400 DIN_VALID;
      convert_ready <= #400 convert_readyD;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      re_delay <= #400 1'b0;
      read_ready_delay <= #400 1'b0;
      valid <= #400 validD;
      convd_data <= #400 {DOUT_WIDTH{1'b1}};
      dout <= #400 {DOUT_WIDTH{1'b1}};
    end else begin
      re_delay <= #400 read_en;
      read_ready_delay <= #400 read_ready;
      valid <= #400 validD;
      convd_data <= #400 convd_dataD;
      dout <= #400 convd_data;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      conv_count <= #400 BIT_DIFF;
    end else begin
      if (read_ready) begin
        if (divide_en) begin
          conv_count <= #400 0;
        end else begin
          conv_count <= #400 conv_count + 1;
        end
      end else begin
        if (divide_en) begin
          conv_count <= #400 BIT_DIFF;
        end else begin
          conv_count <= #400 conv_count + 1;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      read_en <= #400 1'b0;
    end else begin
      if (conv_count==BIT_DIFF-2) begin
        read_en <= #400 1'b1;
      end else begin
        if (conv_count==BIT_DIFF) begin
          read_en <= #400 1'b0;
        end else begin
          read_en <= #400 1'b0;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      validD <= #400 1'b0;
    end else begin
      if ((!read_ready)&(conv_count==BIT_DIFF)) begin
        validD <= #400 1'b0;
      end else begin
        if (re_delay) begin
          validD <= #400 1'b1;
        end else begin
          validD <= #400 validD;
        end
      end
    end
  end

  genvar i;
  generate
    for ( i=0 ; i<BIT_DIFF ; i=i+1 ) begin
      assign divide_dout[i] = FIFO_DOUT[DOUT_WIDTH*i +:DOUT_WIDTH];
    end
  endgenerate

endmodule