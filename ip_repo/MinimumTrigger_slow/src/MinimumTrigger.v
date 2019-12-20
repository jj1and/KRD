`timescale 1 ps / 1 ps
module MinimumTrigger # (
  // hit detection window (8 word = 2nsec)
  parameter integer HIT_DETECTION_WINDOW_WORD = 8,

  // Trigger channel ID setting
  parameter integer CHANNEL_ID  = 0,
  // RFSoC ADC resolution
  parameter integer ADC_RESOLUTION_WIDTH = 12,

  /* data frame settings */
  // acquiasion length settings
  parameter integer MAX_FRAME_LENGTH = 200,
  // max pre-acquiasion length settings max pre acqui len will be 2**(MAX_DELAY_CNT_WIDTH-1)
  parameter integer MAX_DELAY_CNT_WIDTH = 5,  
  // post-acquiasion length
  parameter integer POST_ACQUI_LEN = 76/2,

  /* timestamp settings */
  // TIME STAMP DATA WIDTH
  parameter integer TIME_STAMP_WIDTH = 48,
  // TIMESTAMP WIDTH which on header
  parameter integer FIRST_TIME_STAMP_WIDTH = 24,

  // RF Data Converter data stream bus width
  parameter integer TDATA_WIDTH	= 128,
  parameter integer DOUT_WIDTH = 64
)
(
  /* Ports of AXI-Stream Slave Interface  */ 
  input wire S_AXIS_ACLK,
  input wire S_AXIS_ARESETN,
  input wire [TDATA_WIDTH-1:0] S_AXIS_TDATA,
  input wire S_AXIS_TVALID,
  output wire S_AXIS_TREADY,

  /* read out clock domain */ 
  input wire  RD_CLK,
  input wire  RD_RESETN,
  
  /* S_AXIS_ACLK clock domain */
  // pre acquiasion length
  input wire [MAX_DELAY_CNT_WIDTH-1:0] PRE_ACQUIASION_LEN,
  // Threshold_value
  input wire signed [ADC_RESOLUTION_WIDTH+1-1:0] THRESHOLD_VAL,
  // Baseline value
  input wire signed [ADC_RESOLUTION_WIDTH-1:0] BASELINE,
  // current time
  input wire [TIME_STAMP_WIDTH-1:0] CURRENT_TIME,

  /* RD_CLK clock domain */
  input wire iREADY,
  // recieved data
  output wire [DOUT_WIDTH-1:0] DOUT,
  // recived data valid signal
  output wire oVALID
);

  // header amd footer width
  localparam integer HEADER_FOOTER_WIDTH = 64;
  //  TriggerLogic DOUT_WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH + (ADC_RESOLUTION_WIDTH+1) + ADC_RESOLUTION_WIDTH
  localparam integer TriggerLogic_DOUT_WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH + ADC_RESOLUTION_WIDTH*2 + 1;

  wire FirstDataFrameGen_oREADY;
  wire [TriggerLogic_DOUT_WIDTH-1:0] TriggerLogic_DOUT;
  wire TriggerLogic_TRIGGERED;
  wire TriggerLogic_oVALID;

  MMTrg # (
    .MAX_DELAY_CNT_WIDTH(MAX_DELAY_CNT_WIDTH),
    .POST_ACQUI_LEN(POST_ACQUI_LEN),
    .HIT_DETECTION_WINDOW_WORD(HIT_DETECTION_WINDOW_WORD),
    .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
    .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
    .TDATA_WIDTH(TDATA_WIDTH)
  ) TriggerLogic (
    .CLK(S_AXIS_ACLK),
    .RESETN(S_AXIS_ARESETN),
    .TDATA(S_AXIS_TDATA),
    .TVALID(S_AXIS_TVALID),
    .iREADY(FirstDataFrameGen_oREADY),
    .PRE_ACQUIASION_LEN(PRE_ACQUIASION_LEN),
    .THRESHOLD_VAL(THRESHOLD_VAL),
    .BASELINE(BASELINE),
    .CURRENT_TIME(CURRENT_TIME),
    .TRIGGERED(TriggerLogic_TRIGGERED),
    .DOUT(TriggerLogic_DOUT),
    .oVALID(TriggerLogic_oVALID)
  );

  wire [TriggerLogic_DOUT_WIDTH-1:0] PreAcquiDelay_DOUT;
  wire PreAcquiDelay_oVALID;  

  VariableShiftregDelay # (
    .MAX_DELAY_CNT_WIDTH(MAX_DELAY_CNT_WIDTH),
    .WIDTH(TriggerLogic_DOUT_WIDTH)
  ) PreAcquiDelay (
    .CLK(S_AXIS_ACLK),
    .RESETN(S_AXIS_ARESETN),
    .DELAY(PRE_ACQUIASION_LEN),
    .iVALID(TriggerLogic_oVALID),
    .DIN(TriggerLogic_DOUT),
    .DOUT(PreAcquiDelay_DOUT),
    .oVALID(PreAcquiDelay_oVALID)
  );

  wire [DOUT_WIDTH-1:0] FirstDataFrameGen_DOUT;
  wire FirstDataFrameGen_oVALIID;

  DataFrameGenerator # (
  .MAX_DELAY_CNT_WIDTH(MAX_DELAY_CNT_WIDTH),
  .MAX_FRAME_LENGTH(MAX_FRAME_LENGTH), 
  .HEADER_FOOTER_WIDTH(HEADER_FOOTER_WIDTH),
  .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
  .FIRST_TIME_STAMP_WIDTH(FIRST_TIME_STAMP_WIDTH),
  .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
  .CHANNEL_ID(CHANNEL_ID),
  .TDATA_WIDTH(TDATA_WIDTH),
  .DIN_WIDTH(TriggerLogic_DOUT_WIDTH),
  .DOUT_WIDTH(DOUT_WIDTH)
  ) FirstDataFrameGen (
  .WR_CLK(S_AXIS_ACLK),
  .WR_RESETN(S_AXIS_ARESETN),
  .RD_CLK(RD_CLK),
  .RD_RESETN(RD_RESETN),
  .PRE_ACQUIASION_LEN(PRE_ACQUIASION_LEN), 
  /* handshake signals */
  // WR_CLK clock domain
  .oREADY(FirstDataFrameGen_oREADY),  
  .iVALID(PreAcquiDelay_oVALID&TriggerLogic_TRIGGERED),
  .DIN(PreAcquiDelay_DOUT),
  // RD_CLK clock domain
  .iREADY(iREADY),
  .oVALID(FirstDataFrameGen_oVALIID),
  .DOUT(FirstDataFrameGen_DOUT)
);

assign oVALID = FirstDataFrameGen_oVALIID;
assign DOUT = FirstDataFrameGen_DOUT;
assign S_AXIS_TREADY = FirstDataFrameGen_oREADY;

endmodule