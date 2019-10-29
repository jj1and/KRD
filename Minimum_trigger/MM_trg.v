`timescale 1 ns / 1 ps

module MM_trg # (
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
  // Ports of Axi Slave Bus Interface S00_AXIS　
  input wire  AXIS_ACLK,
  input wire  AXIS_ARESETN,
  input wire [S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
  input wire S_AXIS_TVALID,
  // Threshold_value
  input wire signed [ADC_RESOLUTION_WIDTH+1-1:0] THRESHOLD_VAL,
  // Baseline value
  input wire signed [ADC_RESOLUTION_WIDTH-1:0] BASELINE,
  // current time
  input wire [TIME_STAMP_WIDTH-1:0] CURRENT_TIME,
  // hit time stamp
  output wire [TIME_STAMP_WIDTH-1:0] TIME_STAMP,
  // baseline value when hit
  output wire  signed [ADC_RESOLUTION_WIDTH-1:0] BASELINE_WHEN_HIT,
  // threshold when hit
  output wire  signed [ADC_RESOLUTION_WIDTH+1-1:0] THRESHOLD_WHEN_HIT,
  // trigger output
  output wire TRIGGERED,
  // recieved data
  output wire [S_AXIS_TDATA_WIDTH-1:0] DATA,
  // recived data valid signal
  output wire VALID
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
  
  // triggered
  wire triggeredD;
  reg triggered = 1'b0;

  // hit flag
  wire hit_flagD;
  wire hit_flag_posedge;
  wire hit_flag_negedge;
  reg hit_flag = 1'b0;

  // triggered after hit end
  reg finalize_flagD = 1'b0;
  // triggered length overwhelms AQUI_LEN
  reg over_len_flagD = 1'b0;
  // array for divide S_AXIS_TDATA
  wire signed [ADC_RESOLUTION_WIDTH-1:0] s_axis_tdata_word[SAMPLE_PER_TDATA-1:0];
  // POST ACQUIASION COUNTER
  reg [POST_COUNTER_WIDTH-1:0] post_count = 0;
  wire post_count_done;
  // ACQUASION COUNTER
  reg [FULL_COUNTER_WIDTH-1:0] acqui_count = 0;
  wire acqui_count_done;
  // comparing ADC value with THRESHOLD_VAL
  wire [SAMPLE_PER_TDATA-1:0] compare_result;

  // trigger time stamp
  reg [TIME_STAMP_WIDTH-1:0] time_stampD = 0;
  reg [TIME_STAMP_WIDTH-1:0] time_stamp = 0;

  // threshold when hit
  reg [ADC_RESOLUTION_WIDTH+1-1:0] threshold_when_hitD;
  reg [ADC_RESOLUTION_WIDTH+1-1:0] threshold_when_hit;

  // baseline when hit
  reg signed [ADC_RESOLUTION_WIDTH-1:0] baseline_when_hitD = ADC_MAX_VAL;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] baseline_when_hit = ADC_MAX_VAL;

  // s_axis_tdata_word - baseline
  wire signed [ADC_RESOLUTION_WIDTH+1-1:0] delta_val[SAMPLE_PER_TDATA-1:0];

  // delay for timing much
  reg [S_AXIS_TDATA_WIDTH-1 : 0] data;
  wire [S_AXIS_TDATA_WIDTH-1 : 0] dataD;
  reg valid = 1'b0;
  
  assign DATA = data;
  assign VALID = valid;

  assign hit_flagD = AXIS_ARESETN ? (|compare_result): 1'b0;
  assign hit_flag_posedge = (hit_flag == 1'b0)&&(hit_flagD == 1'b1);
  assign hit_flag_negedge = (hit_flag == 1'b1)&&(hit_flagD == 1'b0); 
  
  assign post_count_done = (post_count == POST_ACQUI_LEN) ? 1'b1: 1'b0;
  assign acqui_count_done = (acqui_count == ACQUI_LEN) ? 1'b1: 1'b0;
  
  assign triggeredD = S_AXIS_TVALID&&(!over_len_flagD) ? (hit_flagD||finalize_flagD): 1'b0;

  assign TRIGGERED = triggered;
  assign BASELINE_WHEN_HIT = baseline_when_hit;
  assign THRESHOLD_WHEN_HIT = threshold_when_hit;
  assign TIME_STAMP = time_stamp;

  // time-stampの取得
  always @(posedge hit_flagD) begin
    time_stampD <= CURRENT_TIME;
    baseline_when_hitD <= BASELINE;
    threshold_when_hitD <= THRESHOLD_VAL;
  end

  always @(posedge AXIS_ACLK) begin
    if (!AXIS_ARESETN) begin
      time_stamp <= 0;
      baseline_when_hit <= 0; 
    end else begin
      time_stamp <= time_stampD;
      baseline_when_hit <= baseline_when_hitD;
      threshold_when_hit <= threshold_when_hitD;
    end
  end

  // post count
  always @(posedge AXIS_ACLK) begin  
    if (hit_flag_negedge) begin
      post_count <= 0;
    end else begin
      if (post_count >= POST_ACQUI_LEN) begin
        post_count <= POST_ACQUI_LEN+1;
      end else begin
        post_count <= post_count + 1;
      end
    end
  end

  // full count
  always @(posedge AXIS_ACLK) begin
    if (hit_flag_posedge) begin
      acqui_count <= 0;
    end else begin
      if (acqui_count >= ACQUI_LEN) begin
        acqui_count <= ACQUI_LEN+1;
      end else begin
        acqui_count <= acqui_count + 1;
      end
    end
  end

  always @(posedge acqui_count_done or posedge hit_flag_posedge) begin
    if (hit_flag_posedge || (!AXIS_ARESETN)) begin
      over_len_flagD <= 1'b0;
    end else begin
      if (acqui_count_done) begin
        over_len_flagD <= 1'b1;
      end else begin
        over_len_flagD <= over_len_flagD;
      end
    end
  end

  always @(posedge post_count_done or posedge hit_flag_negedge) begin
    if (post_count_done || (!AXIS_ARESETN)) begin
        finalize_flagD <= 1'b0;
    end else begin
      if (hit_flag_negedge) begin
        finalize_flagD <= 1'b1;
      end else begin
        finalize_flagD <= finalize_flagD;
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
    if (!AXIS_ARESETN) begin
      data <= {S_AXIS_TDATA_WIDTH{1'b1}};
    end else begin
      data <= dataD;
    end
  end

  // S_AXIS_TDATAの分割
  genvar i;
  generate
    for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+1 ) begin
      assign s_axis_tdata_word[i] = S_AXIS_TDATA[16*(i+1)-1 -:ADC_RESOLUTION_WIDTH];
      assign delta_val[i] = s_axis_tdata_word[i] - BASELINE;
      assign dataD[16*(i+1)-1 -:16] = {{16-ADC_RESOLUTION_WIDTH{1'b0}}, S_AXIS_TDATA[16*(i+1)-1 -:ADC_RESOLUTION_WIDTH]};
    end
  endgenerate

  // Thresoldの値との比較
  generate
    for(i=0;i<SAMPLE_PER_TDATA;i=i+1) begin
      assign compare_result[i] = ( delta_val[i] >= THRESHOLD_VAL);
    end
  endgenerate

endmodule