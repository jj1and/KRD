`timescale 1 ps / 1 ps
module DataFrameGenerator # (

  // Trigger channel ID setting
  parameter integer CHANNEL_ID  = 0,
  // RFSoC ADC resolution
  parameter integer ADC_RESOLUTION_WIDTH = 12,

  /* data frame settings */
  // acquiasion length settings
  parameter integer MAX_FRAME_LENGTH = 200,
  // max pre-acquiasion length settings max pre acqui len will be 2**(MAX_DELAY_CNT_WIDTH-1)
  parameter integer MAX_DELAY_CNT_WIDTH = 2,  

  // Header and Footer width setting
  parameter integer HEADER_FOOTER_WIDTH = 64,
  
  /* timestamp settings */
  // TIME STAMP DATA WIDTH
  parameter integer TIME_STAMP_WIDTH = 48,
  // TIMESTAMP WIDTH which on header
  parameter integer FIRST_TIME_STAMP_WIDTH = 24,
  
  parameter integer TDATA_WIDTH = 128,
  parameter integer DIN_WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH + ADC_RESOLUTION_WIDTH*2 + 1,
  parameter integer DOUT_WIDTH = 64

)(
  input wire WR_CLK,
  input wire WR_RESETN,

  input wire RD_CLK,
  input wire RD_RESETN,

  input wire [MAX_DELAY_CNT_WIDTH-1:0] PRE_ACQUIASION_LEN, 

  /* handshake signals */
  // WR_CLK clock domain
  output wire oREADY,  
  input wire iVALID,
  input wire [DIN_WIDTH-1:0] DIN,

  // RD_CLK clock domain
  input wire iREADY,
  output wire oVALID,
  output wire [DOUT_WIDTH-1:0] DOUT

);

  localparam integer INFO_WIDTH = HEADER_FOOTER_WIDTH*2;

  wire DataFrameGen_oREADY;
  wire DataFrameGen_oVALID;
  wire [DOUT_WIDTH-1:0] DataFrameGen_DOUT;

  wire [TDATA_WIDTH-1:0] DataFrameGen_WRITTEN_DATA;
  wire DataFrameGen_DATA_FIFO_WE;
  wire DataFrameGen_DATA_FIFO_RE;

  wire [DOUT_WIDTH-1:0] DataFifo_dout;
  wire DataFifo_full;
  wire DataFifo_empty;
  wire DataFifo_wr_rst_busy;
  wire DataFifo_rd_rst_busy;    

  wire [INFO_WIDTH-1:0] DataFrameGen_WRITTEN_INFO;
  wire DataFrameGen_INFO_FIFO_WE;
  wire DataFrameGen_INFO_FIFO_RE;

  wire [INFO_WIDTH-1:0] InfoFifo_dout;
  wire InfoFifo_full;
  wire InfoFifo_empty;
  wire InfoFifo_wr_rst_busy;
  wire InfoFifo_rd_rst_busy;

  DataFrameGenerator_mod # (
  .MAX_DELAY_CNT_WIDTH (MAX_DELAY_CNT_WIDTH),
  .MAX_FRAME_LENGTH(MAX_FRAME_LENGTH), 
  .HEADER_FOOTER_WIDTH(HEADER_FOOTER_WIDTH),
  .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
  .FIRST_TIME_STAMP_WIDTH(FIRST_TIME_STAMP_WIDTH),
  .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
  .CHANNEL_ID(CHANNEL_ID),
  .TDATA_WIDTH(TDATA_WIDTH),
  .INFO_WIDTH(HEADER_FOOTER_WIDTH*2),
  .DIN_WIDTH(DIN_WIDTH),
  .DOUT_WIDTH(DOUT_WIDTH)
  ) DataFrameGen (
  .WR_CLK(WR_CLK),
  .WR_RESETN(WR_RESETN),
  .RD_CLK(RD_CLK),
  .RD_RESETN(RD_RESETN),

  .PRE_ACQUIASION_LEN(PRE_ACQUIASION_LEN), 

  .WRITTEN_DATA(DataFrameGen_WRITTEN_DATA),
  .READ_DATA(DataFifo_dout),
  .DATA_FIFO_WE(DataFrameGen_DATA_FIFO_WE),
  .DATA_FIFO_RE(DataFrameGen_DATA_FIFO_RE),
  .DATA_FIFO_FULL(DataFifo_full),
  .DATA_FIFO_EMPTY(DataFifo_full),
  .DATA_FIFO_WR_RST_BUSY(DataFifo_wr_rst_busy),
  .DATA_FIFO_RD_RST_BUSY(DataFifo_rd_rst_busy),

  .WRITTEN_INFO(DataFrameGen_WRITTEN_INFO),
  .READ_INFO(InfoFifo_dout),
  .INFO_FIFO_WE(DataFrameGen_INFO_FIFO_WE),
  .INFO_FIFO_RE(DataFrameGen_INFO_FIFO_RE),
  .INFO_FIFO_FULL(InfoFifo_full),
  .INFO_FIFO_EMPTY(InfoFifo_empty),
  .INFO_FIFO_WR_RST_BUSY(InfoFifo_wr_rst_busy),
  .INFO_FIFO_RD_RST_BUSY(InfoFifo_rd_rst_busy),

  /* handshake signals*/
  // S_AXIS_ACLK clock domain
  .oREADY(DataFrameGen_oREADY),
  .iVALID(iVALID),
  .DIN(DIN),
  // RD_CLK clock domain
  .iREADY(iREADY),
  .oVALID(DataFrameGen_oVALID),
  .DOUT(DataFrameGen_DOUT)

  );
  
  data_fifo DataFifo (
  .rst(~WR_RESETN),                  // input wire rst
  .wr_clk(WR_CLK),            // input wire wr_clk
  .rd_clk(RD_CLK),            // input wire rd_clk
  .din(DataFrameGen_WRITTEN_DATA),                  // input wire [127 : 0] din
  .wr_en(DataFrameGen_DATA_FIFO_WE),              // input wire wr_en
  .rd_en(DataFrameGen_DATA_FIFO_RE),              // input wire rd_en
  .dout(DataFifo_dout),                // output wire [63 : 0] dout
  .full(DataFifo_full),                // output wire full
  .empty(DataFifo_empty),              // output wire empty
  .wr_rst_busy(DataFifo_wr_rst_busy),  // output wire wr_rst_busy
  .rd_rst_busy(DataFifo_rd_rst_busy)  // output wire rd_rst_busy
);

info_fifo InfoFifo (
  .rst(~WR_RESETN),                  // input wire rst
  .wr_clk(WR_CLK),            // input wire wr_clk
  .rd_clk(RD_CLK),            // input wire rd_clk
  .din(DataFrameGen_WRITTEN_INFO),                  // input wire [63 : 0] din
  .wr_en(DataFrameGen_INFO_FIFO_WE),              // input wire wr_en
  .rd_en(DataFrameGen_INFO_FIFO_RE),              // input wire rd_en
  .dout(InfoFifo_dout),                // output wire [63 : 0] dout
  .full(InfoFifo_full),                // output wire full
  .empty(InfoFifo_empty),              // output wire empty
  .wr_rst_busy(InfoFifo_wr_rst_busy),  // output wire wr_rst_busy
  .rd_rst_busy(InfoFifo_rd_rst_busy)  // output wire rd_rst_busy
);

  assign oREADY = DataFrameGen_oREADY;
  assign oVALID = DataFrameGen_oVALID;
  assign DOUT = DataFrameGen_DOUT;

endmodule