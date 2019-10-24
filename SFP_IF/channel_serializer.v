`timescale 1 ns / 1 ps

module channel_serializer # (

  parameter integer S_AXIS_TDATA_WIDTH = 64,
  parameter integer TX_RX_M_AXIS_WIDTH = 64,
  parameter integer CHANNEL_FIFO_DEPTH = (200/2)*2*8

)
(

  input wire TX_ACLK,
  input wire TX_ARESETN,

  input wire [S_AXIS_TDATA_WIDTH-1:0] S0_AXIS_TDATA,
  input wire S0_AXIS_TUSER,
  input wire S0_AXIS_TLAST,
  input wire S0_AXIS_TVALID,

  input wire [S_AXIS_TDATA_WIDTH-1:0] S1_AXIS_TDATA,
  input wire S1_AXIS_TUSER,
  input wire S1_AXIS_TLAST,
  input wire S1_AXIS_TVALID,
  
  input wire [S_AXIS_TDATA_WIDTH-1:0] S2_AXIS_TDATA,
  input wire S2_AXIS_TUSER,
  input wire S2_AXIS_TLAST,
  input wire S2_AXIS_TVALID,

  input wire [S_AXIS_TDATA_WIDTH-1:0] S3_AXIS_TDATA,
  input wire S3_AXIS_TUSER,
  input wire S3_AXIS_TLAST,
  input wire S3_AXIS_TVALID,

  input wire [S_AXIS_TDATA_WIDTH-1:0] S4_AXIS_TDATA,
  input wire S4_AXIS_TUSER,
  input wire S4_AXIS_TLAST,
  input wire S4_AXIS_TVALID,

  input wire [S_AXIS_TDATA_WIDTH-1:0] S5_AXIS_TDATA,
  input wire S5_AXIS_TUSER,
  input wire S5_AXIS_TLAST,
  input wire S5_AXIS_TVALID,

  input wire [S_AXIS_TDATA_WIDTH-1:0] S6_AXIS_TDATA,
  input wire S6_AXIS_TUSER,
  input wire S6_AXIS_TLAST,
  input wire S6_AXIS_TVALID,    

  input wire [S_AXIS_TDATA_WIDTH-1:0] S7_AXIS_TDATA,
  input wire S7_AXIS_TUSER,
  input wire S7_AXIS_TLAST,
  input wire S7_AXIS_TVALID,
  
  input wire PLS_WAIT,
  input wire DATA_EMPTY,

  output wire[TX_RX_M_AXIS_WIDTH-1:0] SERIALIZED_DATA,
  output wire WR_EN,
  output wire RE_EN

);


  localparam integer CHANNEL_NUM = 8;

  integer i;
  genvar j;

  wire [CHANNEL_NUM-1:0] sig_revs;

  wire [CHANNEL_NUM-1:0] fifo_fulls;
  wire [CHANNEL_NUM-1:0] fifo_emptys;
  wire [CHANNEL_NUM-1:0] fifo_almost_fulls;
  wire [CHANNEL_NUM-1:0] fifo_wr_ens;
  wire [CHANNEL_NUM-1:0] fifo_re_ens;
  wire [S_AXIS_TDATA_WIDTH-1:0] fifo_dins[CHANNEL_NUM-1:0];
  reg [S_AXIS_TDATA_WIDTH-1:0] fifo_dins_delays[CHANNEL_NUM-1:0]; 
  wire [TX_RX_M_AXIS_WIDTH-1:0] fifo_douts[CHANNEL_NUM-1:0];
  
  wire [CHANNEL_NUM-1:0] s_axis_tvalids;
  wire [CHANNEL_NUM-1:0] s_axis_tvalids_delays;
  wire [CHANNEL_NUM-1:0] s_axis_tusers;
  wire [CHANNEL_NUM-1:0] s_axis_tlasts;

  reg [3:0] selected_channel;

  assign s_axis_tusers[0] = S0_AXIS_TUSER;
  assign s_axis_tusers[1] = S1_AXIS_TUSER;
  assign s_axis_tusers[2] = S2_AXIS_TUSER;
  assign s_axis_tusers[3] = S3_AXIS_TUSER;
  assign s_axis_tusers[4] = S4_AXIS_TUSER;
  assign s_axis_tusers[5] = S5_AXIS_TUSER;
  assign s_axis_tusers[6] = S6_AXIS_TUSER;
  assign s_axis_tusers[7] = S7_AXIS_TUSER;

  assign s_axis_tlasts[0] = S0_AXIS_TLAST;
  assign s_axis_tlasts[1] = S1_AXIS_TLAST;
  assign s_axis_tlasts[2] = S2_AXIS_TLAST;
  assign s_axis_tlasts[3] = S3_AXIS_TLAST;
  assign s_axis_tlasts[4] = S4_AXIS_TLAST;
  assign s_axis_tlasts[5] = S5_AXIS_TLAST;
  assign s_axis_tlasts[6] = S6_AXIS_TLAST;
  assign s_axis_tlasts[7] = S7_AXIS_TLAST;

  assign s_axis_tvalids[0] = S0_AXIS_TVALID;
  assign s_axis_tvalids[1] = S1_AXIS_TVALID;
  assign s_axis_tvalids[2] = S2_AXIS_TVALID;
  assign s_axis_tvalids[3] = S3_AXIS_TVALID;
  assign s_axis_tvalids[4] = S4_AXIS_TVALID;
  assign s_axis_tvalids[5] = S5_AXIS_TVALID;
  assign s_axis_tvalids[6] = S6_AXIS_TVALID;
  assign s_axis_tvalids[7] = S7_AXIS_TVALID;

  assign fifo_dins[0] = S0_AXIS_TDATA;
  assign fifo_dins[1] = S1_AXIS_TDATA;  
  assign fifo_dins[2] = S2_AXIS_TDATA;  
  assign fifo_dins[3] = S3_AXIS_TDATA;  
  assign fifo_dins[4] = S4_AXIS_TDATA;  
  assign fifo_dins[5] = S5_AXIS_TDATA;  
  assign fifo_dins[6] = S6_AXIS_TDATA;  
  assign fifo_dins[7] = S7_AXIS_TDATA;

  Delay #(
    .DELAY_CLK(1),
    .WIDTH(CHANNEL_NUM)
  ) trg_delay_inst (
    .CLK(TX_ACLK),
    .RESETn(TX_ARESETN),
    .DIN(s_axis_tvalids),
    .DOUT(s_axis_tvalids_delays)
  );

  always @(posedge TX_ACLK ) begin
    if (!TX_ARESETN) begin
      for ( i=0 ; i<CHANNEL_NUM ; i=i+1 ) begin
        fifo_dins_delays[i] <= 0;
      end
    end else begin
      for ( i=0 ; i<CHANNEL_NUM ; i=i+1 ) begin
        fifo_dins_delays[i] <= fifo_dins[i];
      end
    end
  end

  generate begin
    for ( j=0 ; j<CHANNEL_NUM ; j=j+1 ) begin
      gen_write_en gen_write_en_inst(
        .SIGNAL_BEGIN(s_axis_tusers[j]),
        .SIGNAL_END(s_axis_tlasts[j]),
        .SIGNAL_RECIEVE(sig_revs[j])
      );
    end
  end
  endgenerate

  generate begin
    for ( j=0 ; j<CHANNEL_NUM ; j=j+1 ) begin
      assign fifo_wr_ens[j] = s_axis_tvalids_delays[j]&sig_revs[j];
    end
  end
  endgenerate

  generate begin
    for ( j=0 ; j<CHANNEL_NUM ; j=j+1 ) begin
      Custom_Fifo # (
        .WIDTH(S_AXIS_TDATA_WIDTH),
        .DEPTH(CHANNEL_FIFO_DEPTH),
        .ALMOST_EMPTY_ASSERT_RATE(5),
        .ALMOST_EMPTY_ASSERT_RATE(95)
      ) channel_data_fifo (
        .CLK(TX_ACLK),
        .RESETN(TX_ARESETN),
        .DIN(fifo_dins_delays[j]),
        .DOUT(fifo_douts[j]),
        .WE(fifo_wr_ens[j]),
        .RE(fifo_re_ens[j]),
        .EMPTY(fifo_emptys[j]),
        .ALMOST_EMPTY(),
        .ALMOST_FULL(fifo_almost_fulls[j]),
        .FULL(fifo_fulls[j])
      );
    end
  end
  endgenerate

  always @(posedge TX_ACLK ) begin
    if (!TX_ARESETN) begin
      selected_channel <= 0;
    end else begin
    end
  end


endmodule