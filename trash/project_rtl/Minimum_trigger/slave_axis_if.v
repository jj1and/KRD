`timescale 1 ps / 1ps

module slave_axis_if # (
  parameter integer S_AXIS_TDATA_WIDTH = 128
)(
  input wire AXIS_ACLK,
  input wire AXIS_ARESETN,
  input wire [S_AXIS_TDATA_WIDTH-1:0] S_AXIS_TDATA,
  input wire S_AXIS_TVALID,
  output wire S_AXIS_TREADY,

  output wire CLK,
  output wire RESETN,
  output wire [S_AXIS_TDATA_WIDTH-1:0] TDATA,
  output wire TVALID,
  input wire MODULE_READY
);

// wire s_axis_treadyD;
// reg s_axis_tready;
// wire s_axis_tvalidD;
// reg tvalid;
// wire [S_AXIS_TDATA_WIDTH-1:0] s_axis_tdataD;
// reg [S_AXIS_TDATA_WIDTH-1:0] tdata;

// assign s_axis_treadyD = BUFF_WRITE_READY&TRIMMER_READY;
// assign s_axis_tdataD = S_AXIS_TDATA;
// assign s_axis_tvalidD = S_AXIS_TVALID;

assign CLK = AXIS_ACLK;
assign RESETN = AXIS_ARESETN;
assign TDATA = S_AXIS_TDATA;
assign TVALID = S_AXIS_TVALID;
assign S_AXIS_TREADY = MODULE_READY;

// Bellow code violated to timing constrains
// always @(posedge CLK ) begin
//   tdata <= s_axis_tdataD;
//   s_axis_tready <= s_axis_treadyD;
//   tvalid <= s_axis_tvalidD;
// end


endmodule