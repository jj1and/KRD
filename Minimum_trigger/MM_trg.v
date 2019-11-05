`timescale 1 ps / 1 ps

module MM_trg # (
    // acquiasion length settings
    parameter integer POST_ACQUI_LEN = 76/2,
    // acquiasion length settings
    parameter integer ACQUI_LEN = 200/2,
    // TIME STAMP DATA WIDTH
    parameter integer TIME_STAMP_WIDTH = 48,
    // RFSoC ADC resolution
    parameter integer ADC_RESOLUTION_WIDTH = 12,
    // RF Data Converter data stream bus width
    parameter integer TDATA_WIDTH	= 128
)
( 
  // Ports of Axi Slave Bus Interface S00_AXIS�?
  input wire  CLK,
  input wire  RESETN,
  input wire [TDATA_WIDTH-1 : 0] TDATA,
  input wire TVALID,
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
  output wire [TDATA_WIDTH-1:0] DATA,
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
  localparam integer SAMPLE_PER_TDATA = TDATA_WIDTH/16;
  localparam integer REDUCE_DIGIT = 16 - ADC_RESOLUTION_WIDTH;
  localparam signed ADC_MAX_VAL = 2**(ADC_RESOLUTION_WIDTH-1)-1;
  localparam signed ADC_MIN_VAL = -2**(ADC_RESOLUTION_WIDTH-1);
  
  // triggered
  reg triggeredD;
  reg triggered = 1'b0;

  // hit flag
  wire hit_flagD;
  wire hit_flag_posedge;
  wire fast_hit_flag_posedge;
  wire hit_flag_negedge;
  // wire fast_hit_flag_negedge;
  reg [1:0] hit_edge;
  reg hit_flag = 1'b0;

  // triggered after hit end
  reg finalize_flag = 1'b0;
  // triggered length overwhelms AQUI_LEN
  reg over_len_flag = 1'b0;
  // array for divide S_AXIS_TDATA
  wire signed [ADC_RESOLUTION_WIDTH-1:0] tdata_word[SAMPLE_PER_TDATA-1:0];
  // POST ACQUIASION COUNTER
  reg [POST_COUNTER_WIDTH-1:0] post_count = 0;
  wire post_count_done;
  // ACQUASION COUNTER
  reg [FULL_COUNTER_WIDTH-1:0] acqui_count = 0;
  wire acqui_count_done;
  // comparing ADC value with THRESHOLD_VAL
  reg [SAMPLE_PER_TDATA-1:0] compare_result;
  wire [SAMPLE_PER_TDATA-1:0] compare_resultD;

  // trigger time stamp
  reg [TIME_STAMP_WIDTH-1:0] time_stampD = 0;
  reg [TIME_STAMP_WIDTH-1:0] time_stamp = 0;

  // threshold when hit
  reg [ADC_RESOLUTION_WIDTH+1-1:0] threshold_when_hitD;
  reg [ADC_RESOLUTION_WIDTH+1-1:0] threshold_when_hit;

  // baseline when hit
  reg signed [ADC_RESOLUTION_WIDTH-1:0] baseline_when_hitD = ADC_MAX_VAL;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] baseline_when_hit = ADC_MAX_VAL;

  // tdata_word - baseline
  wire signed [ADC_RESOLUTION_WIDTH+1-1:0] delta_val[SAMPLE_PER_TDATA-1:0];

  // delay for timing much
  reg signed [TDATA_WIDTH-1:0] tdata;
  reg [TDATA_WIDTH-1 : 0] data;
  reg [TDATA_WIDTH-1:0] delayed_data;
  wire [TDATA_WIDTH-1 : 0] dataD;
  reg valid = 1'b0;
  
  assign DATA = data;
  assign VALID = valid;

  assign hit_flagD = (|compare_result);
  assign hit_flag_posedge = (hit_edge == 2'b01);
  assign hit_flag_negedge = (hit_edge == 2'b10);
  assign fast_hit_flag_posedge = (hit_flagD == 1'b1)&(hit_flag == 1'b0);
  // assign fast_hit_flag_negedge = (hit_flagD == 1'b0)&(hit_flag == 1'b1);  
  
  assign post_count_done = (post_count == POST_ACQUI_LEN-2);
  assign acqui_count_done = (acqui_count == ACQUI_LEN-1);

  assign TRIGGERED = triggered;
  assign BASELINE_WHEN_HIT = baseline_when_hit;
  assign THRESHOLD_WHEN_HIT = threshold_when_hit;
  assign TIME_STAMP = time_stamp;

  // edge detection
  always @( posedge CLK or negedge RESETN ) begin
    if ((!RESETN)|(!TVALID)) begin
      hit_edge <= #10 2'b00;
    end else begin
      hit_edge <= #10 {hit_edge[0], hit_flagD};
    end
  end

  always @(posedge CLK) begin
    if (!RESETN) begin
      time_stamp <= #10 0;
      baseline_when_hit <= #10 0; 
    end else begin
      if (hit_flag_posedge) begin
        time_stamp <= #10 CURRENT_TIME;
        baseline_when_hit <= #10 BASELINE;
        threshold_when_hit <= #10 THRESHOLD_VAL;
      end else begin
        time_stamp <= #10 time_stamp;
        baseline_when_hit <= #10 baseline_when_hit;
        threshold_when_hit <= #10 threshold_when_hit;      
      end
    end
  end

  // post count
  always @(posedge CLK) begin  
    if (!RESETN) begin
      post_count <= #10 0;
    end else begin
      if (hit_flag_negedge) begin
        post_count <= #10 0;
      end else begin
        if (post_count >= POST_ACQUI_LEN-2) begin
          post_count <= #10 POST_ACQUI_LEN;
        end else begin
          post_count <= #10 post_count + 1;
        end
      end      
    end
  end

  // full count
  always @(posedge CLK) begin
    if (!RESETN) begin
      acqui_count <= #10 0;
    end else begin
      if (fast_hit_flag_posedge) begin
        acqui_count <= #10 0;
      end else begin
        if (acqui_count >= ACQUI_LEN-1) begin
          acqui_count <= #10 ACQUI_LEN;
        end else begin
          acqui_count <= #10 acqui_count + 1;
        end
      end      
    end
  end

  always @(posedge CLK) begin
    if (!RESETN) begin
      over_len_flag <= #10 1'b0;
    end else begin
      if (acqui_count_done) begin
        over_len_flag <= #10 1'b1;
      end else begin
        if (fast_hit_flag_posedge) begin
          over_len_flag <= #10 1'b0;
        end else begin
          over_len_flag <= #10 over_len_flag;
        end
      end
    end
  end

  always @(posedge CLK) begin
    if (!RESETN) begin
      finalize_flag <= #10 1'b0;
    end else begin
      if (post_count_done) begin
          finalize_flag <= #10 1'b0;
      end else begin
        if (hit_flag_negedge) begin
          finalize_flag <= #10 1'b1;
        end else begin
          finalize_flag <= #10 finalize_flag;
        end
      end      
    end
  end

  always @(posedge CLK ) begin
    if ((!RESETN)|(!TVALID)) begin
      hit_flag <= #10 1'b0;
    end else begin
      hit_flag <= #10 hit_flagD;
    end
  end

  always @(* ) begin
    if (TVALID&(!over_len_flag)) begin
      triggeredD = |{hit_flag, hit_flag_negedge, finalize_flag};
    end else begin
      triggeredD = 1'b0;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      triggered <= #10 1'b0;
    end else begin
      triggered <= #10 triggeredD;
    end
  end

  always @(posedge CLK ) begin
    if ((!RESETN)|(!TVALID)) begin
      valid <= #10 1'b0;
    end else begin
      valid <= #10 TVALID;
    end
  end

  always @(posedge CLK ) begin
    if ((!RESETN)|(!TVALID)) begin
      data <= #10 {TDATA_WIDTH{1'b1}};
      delayed_data <= #10 {TDATA_WIDTH{1'b1}};
      tdata <= #10 {TDATA_WIDTH{1'b1}};
    end else begin
      data <= #10 delayed_data;
      delayed_data <= #10 dataD;
      tdata <= #10 TDATA;
    end
  end

  always @(posedge CLK ) begin
    if ((!RESETN)|(!TVALID)) begin
      compare_result <= #10 0;
    end else begin
      compare_result <= #10 compare_resultD;
    end
  end

  // S_AXIS_TDATAの�?割
  genvar i;
  generate
    for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+1 ) begin
      assign tdata_word[i] = TDATA[16*(i+1)-1 -:ADC_RESOLUTION_WIDTH];
      assign delta_val[i] = tdata_word[i] - BASELINE;
      assign dataD[16*(i+1)-1 -:16] = {{16-ADC_RESOLUTION_WIDTH{1'b0}}, tdata[16*(i+1)-1 -:ADC_RESOLUTION_WIDTH]};
    end
  endgenerate

  // Thresoldの値との比�?
  generate
    for(i=0;i<SAMPLE_PER_TDATA;i=i+1) begin
      assign compare_resultD[i] = ( delta_val[i] >= THRESHOLD_VAL);
    end
  endgenerate

endmodule