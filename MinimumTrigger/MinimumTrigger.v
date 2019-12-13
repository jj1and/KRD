module MinumumTrigger # (
    // clock frequency (Hz)
    parameter integer CLK_FREQ = 500E6,
    // timer resolution freq (HZ)(must be < CLK_FREQ )
    parameter integer TIMER_RESO_FREQ = 100E6,
    // acquiasion length settings
    parameter integer MAX_DELAY_CNT_WIDTH = 5,
    // acquiasion length settings
    parameter integer POST_ACQUI_LEN = 76/2,
    // hit detection window (8 word = 2nsec)
    parameter integer HIT_DETECTION_WINDOW_WORD = 8,
    // TIME STAMP DATA WIDTH
    parameter integer TIME_STAMP_WIDTH = 48,
    // RFSoC ADC resolution
    parameter integer ADC_RESOLUTION_WIDTH = 12,
    // RF Data Converter data stream bus width
    parameter integer TDATA_WIDTH	= 256,
    // DOUT WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH*2 + (ADC_RESOLUTION_WIDTH+1) + ADC_RESOLUTION_WIDTH
    parameter integer DOUT_WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH*2 + ADC_RESOLUTION_WIDTH*2 + 1
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

  MMTrg # (
    .MAX_DELAY_CNT_WIDTH(MAX_DELAY_CNT_WIDTH),
    .POST_ACQUI_LEN(POST_ACQUI_LEN),
    .HIT_DETECTION_WINDOW_WORD(8),
    .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
    .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
    .TDATA_WIDTH(TDATA_WIDTH)
  ) TriggerLogic (
    .CLK(S_AXIS_ACLK),
    .RESETN(S_AXIS_ARESETN),
    .TDATA(S_AXIS_TDATA),
    .TVALID(S_AXIS_TVALID),
    .iREADY(iREADY),
    .PRE_ACQUIASION_LEN(PRE_ACQUIASION_LEN),
    .THRESHOLD_VAL(THRESHOLD_VAL),
    .BASELINE(BASELINE),
    .CURRENT_TIME(CURRENT_TIME),
    .DOUT(),
    .oVALID()
  );

endmodule