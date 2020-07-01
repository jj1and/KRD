`timescale 1ps / 1ps 

module simple_dp_bram # (
  parameter integer DATA_WIDTH = 72,
  parameter integer PTR_WIDTH = 3,
  parameter integer INIT_VAL = {DATA_WIDTH{1'b1}}

)(
  input wire CLK,
  input wire WR_PTR_EN,
  input wire RD_EN,
  input wire WR_EN,
  input wire [PTR_WIDTH-1:0]  WR_PTR,
  input wire [PTR_WIDTH-1:0]  RD_PTR,
  input wire [DATA_WIDTH-1:0] DIN,
  output wire [DATA_WIDTH-1:0] DOUT
);

  (* ram_style = "block" *) reg [DATA_WIDTH-1:0] ram [2**PTR_WIDTH-1:0];
  integer i;
  initial
  begin
    for (i=0; i<2**PTR_WIDTH; i=i+1) begin
      ram[i] = INIT_VAL;
    end
  end

  reg [DATA_WIDTH-1:0] dout;

  always @(posedge CLK) begin 
    if (WR_PTR_EN) begin
      if (WR_EN)
        ram[WR_PTR] <= #100 DIN;
    end
  end

  always @(posedge CLK) begin 
    if (RD_EN)
      dout <= #100 ram[RD_PTR];
  end
  assign DOUT = dout;

endmodule