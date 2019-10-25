`timescale 1 ns / 1 ps

module MM_trg # (

    // threshold ( percentage of max value = 2^12)
    parameter integer THRESHOLD = 10,
    // acquiasion length settings
    parameter integer POST_ACQUI_LEN = 76/2,
    // acquiasion length settings
    parameter integer ACQUI_LEN = 200/2,
    // TIME STAMP DATA WIDTH
    parameter integer TIME_STAMP_WIDTH = 44,
    // RFSoC ADC resolution
    parameter integer ADC_RESOLUTION_WIDTH = 12,
    // RF Data Converter data stream bus width
    parameter integer S_AXIS_TDATA_WIDTH	= 128
)
(    
  // exec statte
  input wire [1:0] EXEC_STATE,
  // Baseline value
  input wire signed [ADC_RESOLUTION_WIDTH-1:0] BASELINE,
  // current time
  input wire [TIME_STAMP_WIDTH-1:0] CURRENT_TIME,
  // hit time stamp
  output wire [TIME_STAMP_WIDTH-1:0] TIME_STAMP,
  // baseline value when hit
  output wire [ADC_RESOLUTION_WIDTH-1:0] BASELINE_WHEN_HIT,
  // trigger output
  output wire TRIGGERED,
  // recieved data
  output wire [S_AXIS_TDATA_WIDTH-1:0] DATA,
  // recived data valid signal
  output wire VALID,

  // Ports of Axi Slave Bus Interface S00_AXIS　
  input wire  AXIS_ACLK,
  input wire  AXIS_ARESETN,
  input wire [S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
  input wire S_AXIS_TVALID

);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth);
    begin
      for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
        bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer POST_COUNTER_WIDTH = clogb2(POST_ACQUI_LEN); 
  localparam integer FULL_COUNTER_WIDTH = clogb2(ACQUI_LEN);
  localparam integer SAMPLE_PER_TDATA = S_AXIS_TDATA_WIDTH/16;
  localparam integer REDUCE_DIGIT = 16 - ADC_RESOLUTION_WIDTH;
  localparam signed ADC_MAX_VAL = 2**(ADC_RESOLUTION_WIDTH-1)-1;
  localparam signed ADC_MIN_VAL = -2**(ADC_RESOLUTION_WIDTH-1);
  localparam signed THRESHOLD_VAL = (ADC_MAX_VAL-ADC_MIN_VAL)*THRESHOLD/100;

  //  exec state
  localparam [1:0] INIT = 2'b00, // ADC < THRESHOLD_VAL
                    TRG = 2'b11; // ADC > THRESHOLD_VAL
  
  // triggered
  wire triggeredD;
  reg triggered;

  // hit flag 
  wire hit_flagD;
  reg hit_flag;

  // triggered after hit end
  reg finalize_flag;
  // triggered length overwhelms AQUI_LEN
  reg over_len_flag;
  // array for divide S_AXIS_TDATA
  wire signed [ADC_RESOLUTION_WIDTH-1:0] s_axis_tdata_word[SAMPLE_PER_TDATA-1:0];
  // POST ACQUIASION COUNTER
  reg [POST_COUNTER_WIDTH-1:0] post_count = 0;
  // ACQUASION COUNTER
  reg [FULL_COUNTER_WIDTH-1:0] full_count = 0;
  // comparing ADC value with THRESHOLD_VAL
  wire [SAMPLE_PER_TDATA-1:0] compare_result;

  // trigger time stamp
  reg [TIME_STAMP_WIDTH-1:0] time_stampD;
  reg [TIME_STAMP_WIDTH-1:0] time_stamp;

  // baseline when hit
  reg [ADC_RESOLUTION_WIDTH-1:0] baseline_when_hitD;
  reg [ADC_RESOLUTION_WIDTH-1:0] baseline_when_hit;

  // delay for timing much
  reg data;
  assign DATA = data;
  reg valid;
  assign VALID = valid;

  assign hit_flagD = (|compare_result);
  assign triggeredD = S_AXIS_TVALID&&(!over_len_flag) ? (hit_flag||finalize_flag): 1'b0;

  // time-stampの取得
  always @(posedge hit_flagD) begin
    time_stampD <= CURRENT_TIME;
    baseline_when_hitD <= BASELINE;
  end

  always @(posedge AXIS_ACLK) begin
    if (!AXIS_ARESETN) begin
      time_stamp <= 0;
      baseline_when_hit <= 0; 
    end else begin
      time_stamp <= time_stampD;
      baseline_when_hit <= baseline_when_hitD;
    end
  end

  // post count and finalizing flag
  always @(posedge AXIS_ACLK or negedge hit_flagD) begin  
    if (!hit_flagD) begin
      post_count <= 0;
      finalize_flag <= 1'b1;
    end else begin
      if (post_count >= POST_ACQUI_LEN) begin
        post_count <= post_count;
        finalize_flag <= 1'b0;
      end else begin
        post_count <= post_count + 1;
        finalize_flag <= 1'b1;
      end
    end
  end

  // full count and over_len_flag
  always @(posedge AXIS_ACLK or posedge hit_flagD ) begin
    if (hit_flagD) begin
      full_count <= 0;
      over_len_flag <= 1'b0;
    end else begin
      if (full_count >= ACQUI_LEN) begin
        full_count <= full_count;
        over_len_flag <= 1'b1;
      end else begin
        full_count <= full_count + 1;
        over_len_flag <= 1'b0;
      end
    end
  end

  always @(posedge AXIS_ACLK ) begin
    if (!AXIS_ARESETN) begin
      hit_flag <= 1'b0;
    end else begin
      hit_flag <= hit_flagD;
    end
  end

  always @(posedge AXIS_ACLK ) begin
    if (!AXIS_ARESETN) begin
      triggered <= 1'b0;
    end else begin
      triggered <= triggeredD;
    end
  end

  always @(posedge AXIS_ACLK ) begin
    if (!AXIS_ARESETN) begin
      valid <= 1'b0;
    end else begin
      valid <= S_AXIS_TVALID;
    end
  end

  always @(posedge AXIS_ACLK ) begin
    data <= S_AXIS_TDATA;
  end

  // S_AXIS_TDATAの分割
  genvar i;
  generate
    for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+1 ) begin
      assign s_axis_tdata_word[i] = S_AXIS_TDATA[16*(i+1)-1 -:ADC_RESOLUTION_WIDTH];
    end
  endgenerate  

  // Thresoldの値との比較
  generate
    for(i=0;i<SAMPLE_PER_TDATA;i=i+1) begin
      assign compare_result[i] = ((s_axis_tdata_word[i]-BASELINE) >= THRESHOLD_VAL);
    end
  endgenerate

  assign TIME_STAMP = time_stamp;

endmodule