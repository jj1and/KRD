`timescale 1 ps / 1 ps

module data_trimmer # (
  parameter integer DATA_WIDTH = 64
)(
  input wire CLK,
  input wire RESETN,
  input wire [DATA_WIDTH-1:0] DIN,
  input wire DIN_VALID,
  output wire [DATA_WIDTH-1:0] DOUT,
  output wire TRIMMER_VALID
);
  

  wire trimmer_validD;
  reg trimmer_valid;
  reg din_valid;
  reg [DATA_WIDTH-1:0] dout;
  reg [DATA_WIDTH-1:0] din;

  assign trimmer_validD = (~&din)&(din_valid);
  assign TRIMMER_VALID = trimmer_valid;
  assign DOUT = dout;
  
  always @(posedge CLK ) begin
    if (!RESETN) begin
      din <= #1 {DATA_WIDTH{1'b1}};
      dout <= #1 {DATA_WIDTH{1'b1}};
    end else begin
      din <= #1 DIN;
      dout <= #1 din;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      trimmer_valid <= #1 1'b0;
      din_valid <= #1 1'b0;
    end else begin
      trimmer_valid <= #1 trimmer_validD;
      din_valid <= #1 DIN_VALID;
    end
  end

endmodule