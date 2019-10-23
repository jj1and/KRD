`timescale 1 ns / 1ps

module SFP_module_IF # (

  parameter integer S_AXIS_TDATA_WIDTH = 64,
  parameter integer TX_RX_M_AXIS_WIDTH = 64

)
(
  input wire TX_ACLK,
  input wire TX_ARESETN,

  input wire CTL_CLK,
  input wire CTL_RESETN,

  input wire [S_AXIS_TDATA_WIDTH-1:0] S_AXIS_TDATA,
  input wire S_AXIS_TUSER,
  input wire S_AXIS_TLAST,
  
  output wire[TX_RX_M_AXIS_WIDTH-1:0] TX_M_AXIS_TDATA,
  output wire [7:0] TX_M_AXIS_TKEEP,
  output wire TX_M_AXIS_TUSER,
  output wire TX_M_AXIS_TLAST,
  output wire TX_M_AXIS_TREADY,

  output wire CTL_TX_CUSTOM_PREAMBLE_ENABLE,
  output wire [55:0] CTL_TX_PREAMBLE,
  output wire [3:0] CTL_TX_IPG_VALUE,
  output wire CTL_TX_ENABLE,
  output wire CTL_TX_SEND_RFI,
  output wire CTL_SEND_LFI,
  output wire CTL_SEND_IDEL,
  output wire CTL_TX_FCS_ENABLE,
  output wire CTL_IGNORE_FCS

);

  wire [TX_RX_M_AXIS_WIDTH-1:0] serialized_data;
  wire wr_en;
  wire re_en;
  wire pls_wait;
  wire data_empty;

  channel_serializer # (

    .S_AXIS_TDATA_WIDTH(S_AXIS_TDATA_WIDTH),
    .TX_RX_M_AXIS_WIDTH(TX_RX_M_AXIS_WIDTH)

  ) channel_serializer_inst (

    .TX_ACLK(TX_ACLK),
    .TX_ARESETN(TX_ARESETN),

    .S_AXIS_TDATA(S_AXIS_TDATA),
    .S_AXIS_TUSER(S_AXIS_TUSER),
    .S_AXIS_TLAST(S_AXIS_TLAST),
    
    .PLS_WAIT(pls_wait),
    .DATA_EMPTY(data_empty),

    .SERIALIZED_DATA(serialized_data),
    .WR_EN(wr_en),
    .RE_EN(re_en)

  );

  ether_IF # (

    .S_AXIS_TDATA_WIDTH(S_AXIS_TDATA_WIDTH),
    .TX_RX_M_AXIS_WIDTH(TX_RX_M_AXIS_WIDTH)

  ) ether_IF_inst (

    .TX_ACLK(TX_ACLK),
    .TX_ARESETN(TX_ARESETN),    

    .SERIALIZED_DATA(serialized_data),
    .WR_EN(wr_en),
    .RE_EN(re_en),

    .TX_M_AXIS_TDATA(TX_M_AXIS_TDATA),
    .TX_M_AXIS_TKEEP(TX_M_AXIS_TKEEP),
    .TX_M_AXIS_TUSER(TX_M_AXIS_TUSER),
    .TX_M_AXIS_TLAST(TX_M_AXIS_TLAST),
    .TX_M_AXIS_TREADY(TX_M_AXIS_TREADY),
    
    .PLS_WAIT(pls_wait),
    .DATA_EMPTY(data_empty)

  );

  ether_ctl # (

    .dummy()

  ) ether_ctl_inst (

    .CTL_CLK(CTL_CLK),
    .CTL_RESETN(CTL_RESETN),
    
    .STAT_TX_LOCAL_FAULT(),

    .CTL_TX_CUSTOM_PREAMBLE_ENABLE(),
    .CTL_TX_PREAMBLE(),
    .CTL_TX_IPG_VALUE(),
    .CTL_TX_ENABLE(),
    .CTL_TX_SEND_RFI(),
    .CTL_SEND_LFI(),
    .CTL_SEND_IDEL(),
    .CTL_TX_FCS_ENABLE(),
    .CTL_IGNORE_FCS()

  );

endmodule