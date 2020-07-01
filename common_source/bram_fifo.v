`timescale 1ps / 1ps
module bram_fifo # (
  parameter DATA_WIDTH = 128,
  parameter PTR_WIDTH = 8,
  parameter INIT_VAL = {DATA_WIDTH{1'b1}}
)(
  input wire CLK,
  input wire RESET,
  input wire [DATA_WIDTH-1:0] DIN,
  input wire WR_EN,
  input wire RD_EN,
  output wire [DATA_WIDTH-1:0] DOUT,
  output wire ALMOST_EMPTY,
  output wire EMPTY,
  output wire ALMOST_FULL,
  output wire FULL
);

  reg [PTR_WIDTH:0] wp;
  reg [PTR_WIDTH:0] rp;
  wire [PTR_WIDTH:0] next_wp = wp+1;
  wire [PTR_WIDTH:0] next_rp = rp+1;
  assign EMPTY = (rp == wp);
  assign ALMOST_EMPTY = (next_rp[PTR_WIDTH-1:0] == wp[PTR_WIDTH-1:0])&(next_rp[PTR_WIDTH] == wp[PTR_WIDTH]);
  assign ALMOST_FULL = (next_wp[PTR_WIDTH-1:0] == rp[PTR_WIDTH-1:0])&(next_wp[PTR_WIDTH] != rp[PTR_WIDTH]);
  assign FULL = (wp[PTR_WIDTH-1:0] == rp[PTR_WIDTH-1:0])&(wp[PTR_WIDTH] != rp[PTR_WIDTH]);

  simple_dp_bram #(
    .DATA_WIDTH(DATA_WIDTH),
    .PTR_WIDTH(PTR_WIDTH),
    .INIT_VAL(INIT_VAL)
  ) bram (
    .CLK(CLK),
    .WR_PTR_EN(WR_EN),
    .RD_EN(RD_EN&(!EMPTY)),
    .WR_EN(WR_EN&(!FULL)),
    .WR_PTR(wp[PTR_WIDTH-1:0]),
    .RD_PTR(rp[PTR_WIDTH-1:0]),
    .DIN(DIN),
    .DOUT(DOUT)
  );
  
  always @(posedge CLK ) begin
    if (RESET) begin
      wp <= #100 0;
    end else begin
      if (WR_EN&(!FULL)) begin
        wp <= #100 wp + 1;
      end else begin
        wp <= #100 wp;
      end
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      rp <= #100 0;
    end else begin
      if (RD_EN&(!EMPTY)) begin
        rp <= #100 rp + 1;
      end else begin
        rp <= #100 rp;
      end
    end
  end

endmodule // 