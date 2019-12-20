`timescale 1 ps / 1 ps

module MMTrg # (
    // RFSoC ADC resolution
    parameter integer ADC_RESOLUTION_WIDTH = 12,  
    // hit detection window (8 word = 2nsec)
    parameter integer HIT_DETECTION_WINDOW_WORD = 8,
    // acquiasion length settings
    parameter integer MAX_DELAY_CNT_WIDTH = 5,
    // acquiasion length settings
    parameter integer POST_ACQUI_LEN = 76/2,
    // TIME STAMP DATA WIDTH
    parameter integer TIME_STAMP_WIDTH = 48,
    // RF Data Converter data stream bus width
    parameter integer TDATA_WIDTH	= 256,
    // DOUT WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH*2 + (ADC_RESOLUTION_WIDTH+1) + ADC_RESOLUTION_WIDTH
    parameter integer DOUT_WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH + ADC_RESOLUTION_WIDTH*2 + 1
)
( 
  input wire  CLK,
  input wire  RESETN,

  /* AXI-Stream Slave signals */
  input wire [TDATA_WIDTH-1 : 0] TDATA,
  input wire TVALID,

  /* Trigger infomation & settings */ 
  // pre acquiasion length
  input wire [MAX_DELAY_CNT_WIDTH-1:0] PRE_ACQUIASION_LEN,
  // Threshold_value
  input wire signed [ADC_RESOLUTION_WIDTH+1-1:0] THRESHOLD_VAL,
  // Baseline value
  input wire signed [ADC_RESOLUTION_WIDTH-1:0] BASELINE,
  // current time
  input wire [TIME_STAMP_WIDTH-1:0] CURRENT_TIME,
  // trigger signal
  output wire TRIGGERED,

  /* handshake signals */
  input wire iREADY,
  output wire [DOUT_WIDTH-1:0] DOUT,
  // oVALID and DOUT relation is corresponding to TVALID and TDATA
  output wire oVALID
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
  localparam integer SAMPLE_PER_TDATA = TDATA_WIDTH/16;
  localparam integer COMPARE_RESULT_SET_WIDTH = SAMPLE_PER_TDATA/HIT_DETECTION_WINDOW_WORD;
  localparam integer REDUCE_DIGIT = 16 - ADC_RESOLUTION_WIDTH;
  localparam signed ADC_MAX_VAL = 2**(ADC_RESOLUTION_WIDTH-1)-1;
  localparam signed ADC_MIN_VAL = -2**(ADC_RESOLUTION_WIDTH-1);

  wire all_ready;
  reg all_ready_delay;
  
  // triggered
  reg triggered;
  reg triggered_delay;
  wire fast_triggered_posedge;

  // hit flag
  wire hit_flagD;
  reg hit_flag;
  reg hit_flag_delay;
  wire hit_flag_echo;
  reg hit_flag_echo_delay;
  wire fast_hit_flag_echo_negedge;

  // array for divide S_AXIS_TDATA
  wire signed [ADC_RESOLUTION_WIDTH-1:0] tdata_word[SAMPLE_PER_TDATA-1:0];
  // pre_acquiasion length
  reg [MAX_DELAY_CNT_WIDTH-1:0] pre_acquiasion_len;
  // PRE ACQUIASION COUNTER
  reg [MAX_DELAY_CNT_WIDTH-1:0] pre_count;
  wire pre_count_done;
  // POST ACQUIASION COUNTER
  reg [POST_COUNTER_WIDTH:0] post_count;
  wire post_count_done;
  wire post_count_init;
  // comparing ADC value with THRESHOLD_VAL
  wire [SAMPLE_PER_TDATA-1:0] compare_resultD;
  reg [SAMPLE_PER_TDATA-1:0] compare_result;
  wire [COMPARE_RESULT_SET_WIDTH-1:0] compare_result_set;

  // trigger time stamp
  reg [TIME_STAMP_WIDTH-1:0] time_stamp;
  reg [TIME_STAMP_WIDTH-1:0] current_time;
  reg [TIME_STAMP_WIDTH-1:0] current_time_delay;
  reg [TIME_STAMP_WIDTH-1:0] current_time_delay_delay;

  // threshold when hit
  reg [ADC_RESOLUTION_WIDTH+1-1:0] threshold_val;
  reg [ADC_RESOLUTION_WIDTH+1-1:0] threshold_when_hit;

  // baseline when hit
  reg signed [ADC_RESOLUTION_WIDTH-1:0] baseline;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] baseline_when_hit;

  // tdata_word - baseline
  wire signed [ADC_RESOLUTION_WIDTH+1-1:0] delta_val[SAMPLE_PER_TDATA-1:0];

  // delay for timing much
  reg signed [TDATA_WIDTH-1:0] tdata;
  wire [TDATA_WIDTH-1 : 0] dataD;  
  reg [TDATA_WIDTH-1 : 0] data;
  reg [TDATA_WIDTH-1:0] delayed_data;
  reg tvalid;
  reg valid;
  reg delayed_valid;

  assign all_ready = &{TVALID, iREADY, pre_count_done};
  
  assign TRIGGERED = triggered;
  assign DOUT = {delayed_data, current_time_delay_delay, baseline_when_hit, threshold_val};
  assign oVALID = delayed_valid;

  assign hit_flagD = (|compare_result_set);
  assign hit_flag_echo  = (hit_flag|hit_flag_delay);
  assign fast_hit_flag_echo_negedge = (hit_flag_echo == 1'b0)&(hit_flag_echo_delay==1'b1);
  assign fast_triggered_posedge = (triggered == 1'b1)&(triggered_delay == 1'b0);  
  
  assign pre_count_done = (pre_count == pre_acquiasion_len-1);
  assign post_count_done = (post_count == POST_ACQUI_LEN-1);
  assign post_count_init = (post_count == POST_ACQUI_LEN);

  always @(posedge CLK ) begin
    if (!RESETN) begin
      pre_acquiasion_len <= #400 PRE_ACQUIASION_LEN;
      baseline <= #400 BASELINE;
      threshold_val <= #400 THRESHOLD_VAL;
    end else begin
      pre_acquiasion_len <= #400 pre_acquiasion_len;
      baseline <= #400 baseline;
      threshold_val <= #400 threshold_val;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      pre_count <= #400 0;
    end else begin
      if (pre_count_done) begin
        pre_count <= #400 pre_count;
      end else begin
        if (TVALID) begin
          pre_count <= #400 pre_count + 1;
        end else begin
          pre_count <= #400 0;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      all_ready_delay <= #400 1'b0;
    end else begin
      all_ready_delay <= #400 all_ready;
    end
  end

  // post count
  always @(posedge CLK) begin  
    if (|{~all_ready_delay, post_count_done}) begin
      post_count <= #400 POST_ACQUI_LEN;
    end else begin
      if (hit_flag_echo) begin
        post_count <= #400 0;
      end else begin
        if (post_count < POST_ACQUI_LEN-1) begin
          post_count <= #400 post_count + 1;
        end else begin
          post_count <= #400 post_count;
        end
      end      
    end
  end

  always @(posedge CLK ) begin
    if (~(&{all_ready_delay, RESETN})) begin
      hit_flag <= #400 1'b0;
      hit_flag_delay <= #400 1'b0;
      hit_flag_echo_delay <= #400 1'b0;
      triggered_delay <= #400 1'b0;
    end else begin
      hit_flag <= #400 hit_flagD;
      hit_flag_delay <= #400 hit_flag;
      hit_flag_echo_delay <= #400 hit_flag_echo;
      triggered_delay <= #400 triggered;
    end
  end

  always @(posedge CLK ) begin
    if (~(&{all_ready_delay, RESETN})) begin
      triggered <= #400 1'b0;
    end else begin
      if (post_count_done) begin
        triggered <= #400 1'b0;
      end else begin
        if (hit_flag_echo) begin
          triggered <= #400 1'b1; 
        end else begin
          triggered <= #400 triggered;
        end
      end
    end
  end

  always @(posedge CLK) begin
    if (!RESETN) begin
      time_stamp <= #400 0;
      baseline_when_hit <= #400 BASELINE;
      threshold_when_hit <= #400 THRESHOLD_VAL;      
    end else begin
      if (fast_triggered_posedge) begin
        time_stamp <= #400 CURRENT_TIME;
        baseline_when_hit <= #400 baseline;
        threshold_when_hit <= #400 threshold_val;
      end else begin
        time_stamp <= #400 time_stamp;
        baseline_when_hit <= #400 baseline_when_hit;
        threshold_when_hit <= #400 threshold_when_hit;      
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      tvalid <= #400 1'b0;
      valid <= #400 1'b0;
      delayed_valid <= #400 1'b0;
    end else begin
      tvalid <= #400 TVALID;
      valid <= #400 tvalid;
      delayed_valid <= #400 valid;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      tdata <= #400 {TDATA_WIDTH{1'b1}};
      data <= #400 {TDATA_WIDTH{1'b1}};
      delayed_data <= #400 {TDATA_WIDTH{1'b1}};
      current_time <= #400 0;
      current_time_delay <= #400 0;
      current_time_delay_delay <= #400 0;      
    end else begin
      tdata <= #400 TDATA;
      data <= #400 dataD;
      delayed_data <= #400 data;
      current_time <= #400 CURRENT_TIME;
      current_time_delay <= #400 current_time;
      current_time_delay_delay <= #400 current_time_delay;
    end
  end

  always @(posedge CLK ) begin
    if ((!RESETN)|(!TVALID)) begin
      compare_result <= #400 0;
    end else begin
      compare_result <= #400 compare_resultD;
    end
  end

  genvar i;
  generate
    for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+1 ) begin
      assign tdata_word[i] = TDATA[16*(i+1)-1 -:ADC_RESOLUTION_WIDTH];
      assign delta_val[i] = tdata_word[i] - baseline;
      assign dataD[16*(i+1)-1 -:16] = {{16-ADC_RESOLUTION_WIDTH{1'b0}}, tdata[16*(i+1)-1 -:ADC_RESOLUTION_WIDTH]};
    end
  endgenerate

  generate
    for(i=0;i<SAMPLE_PER_TDATA;i=i+1) begin
      assign compare_resultD[i] = ( delta_val[i] >= threshold_val);
    end
  endgenerate

  generate
    for (i=0;i<COMPARE_RESULT_SET_WIDTH;i=i+1) begin
      assign compare_result_set[i] = &compare_result[HIT_DETECTION_WINDOW_WORD*i +:HIT_DETECTION_WINDOW_WORD];
    end
  endgenerate

endmodule