module DataFrameGenerator # (

  parameter integer MAX_DELAY_CNT_WIDTH = 5,
  parameter integer MAX_FRAME_LENGTH = 200, 
  parameter integer HEADER_FOOTER_WIDTH = 64,
  parameter integer TIME_STAMP_WIDTH = 48,
  parameter integer FIRST_TIME_STAMP_WIDTH = 24,
  parameter integer ADC_RESOLUTION_WIDTH = 12,
  parameter integer CHANNEL_ID  = 0,
  parameter integer TDATA_WIDTH = 128,
  // DIN WIDTH = TIME_STAMP_WIDTH + (ADC_RESOLUTION_WIDTH+1) + ADC_RESOLUTION_WIDTH
  parameter integer DIN_WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH + ADC_RESOLUTION_WIDTH*2 + 1,
  parameter integer DOUT_WIDTH = 64

)(
  input wire WR_CLK,
  input wire WR_RESETN,

  input wire RD_CLK,
  input wire RD_RESETN,

  input wire [MAX_DELAY_CNT_WIDTH-1:0] PRE_ACQUIASION_LEN, 

  // handshake signals
  output wire oREADY,  
  input wire iVALID,
  input wire [DIN_WIDTH-1:0] DIN,

  input wire iREADY,
  output wire oVALID,
  output wire [TDATA_WIDTH-1:0] DOUT

);

    DataFrameGenerator_mod # (

    .MAX_DELAY_CNT_WIDTH (MAX_DELAY_CNT_WIDTH),
    .MAX_FRAME_LENGTH(MAX_FRAME_LENGTH), 
    .HEADER_FOOTER_WIDTH(DOUT_WIDTH),
    .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
    .FIRST_TIME_STAMP_WIDTH(FIRST_TIME_STAMP_WIDTH),
    .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
    .CHANNEL_ID(CHANNEL_ID),
    .TDATA_WIDTH(TDATA_WIDTH),
    .INFO_WIDTH(DOUT_WIDTH*2),
    .DOUT_WIDTH(DOUT_WIDTH)

    ) DataFrameGen (
    .WR_CLK(WR_CLK),
    .WR_RESETN(WR_RESETN),
    .RD_CLK(RD_CLK),
    .RD_RESETN(RD_RESETN),

    .PRE_ACQUIASION_LEN(PRE_ACQUIASION_LEN), 

    .WRITE_DATA(),
    .READ_DATA(),
    .DATA_FIFO_WE(),
    .DATA_FIFO_RE(),
    .DATA_FIFO_FULL(),
    .DATA_FIFO_EMPTY(),
    .DATA_FIFO_WR_RST_BUSY(),
    .DATA_FIFO_RD_RST_BUSY(),

    .WRITE_INFO(),
    .READ_INFO(),
    .INFO_FIFO_WE(),
    .INFO_FIFO_RE(),
    .INFO_FIFO_FULL(),
    .INFO_FIFO_EMPTY(),
    .INFO_FIFO_WR_RST_BUSY(),
    .INFO_FIFO_RD_RST_BUSY(),

    /* handshake signals*/
    // S_AXIS_ACLK clock domain
    .oREADY(),
    .iVALID(),
    .DIN(),
    // RD_CLK clock domain
    .iREADY(),
    .oVALID(),
    .DOUT()

    );

endmodule