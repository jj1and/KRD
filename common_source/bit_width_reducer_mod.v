`timescale 1 ps / 1 ps

module bit_width_reducer_mod # (
  parameter integer DIN_WIDTH = 128,
  parameter integer DOUT_WIDTH =64
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
  wire read_ready;
  reg read_ready_delay;
  wire fast_read_ready_posedge;
  wire write_en;
  reg read_en;
  reg re_delay;

  wire [DOUT_WIDTH-1:0] convd_dataD;
  reg [DOUT_WIDTH-1:0] convd_data;
  reg [DOUT_WIDTH-1:0] dout;
  reg [DOUT_WIDTH-1:0] init_val = {8'h00, {DOUT_WIDTH-8{1'b1}}};
  wire [DOUT_WIDTH-1:0] divide_dout[BIT_DIFF:0];
  reg validD;
  reg valid;
  reg ready;

  assign read_ready = FIFO_NOT_EMPTY&MODULE_READY;
  assign fast_read_ready_posedge = (read_ready==1'b1)&(read_ready_delay==1'b0);
  assign divide_dout[BIT_DIFF] = init_val;
  assign convd_dataD = divide_dout[conv_count];
  assign DOUT = dout;
  assign CONVERT_VALID = valid;
  assign CONVERT_READY = (!FIFO_FULL)&(!FIFO_RST_BUSY);
  assign divide_en = (conv_count >= BIT_DIFF-1);
  assign write_en = DIN_VALID;
  assign FIFO_DIN = DIN;
  assign FIFO_WE = write_en;
  assign FIFO_RE = read_en;

  always @(posedge CLK ) begin
    if (!RESETN) begin
      re_delay <= #400 1'b0;
      read_ready_delay <= #400 1'b0;
      valid <= #400 validD;
      convd_data <= #400 init_val;
      dout <= #400 init_val;
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
      if ((!read_ready)&divide_en) begin
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