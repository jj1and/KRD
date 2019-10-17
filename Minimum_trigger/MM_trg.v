`timescale 1 ns / 1 ps

module MM_trg # (

    // threshold ( percentage of max value = 2^12)
    parameter integer THRESHOLD = 10,
    
    // acquiasion length settings
    parameter integer POST_ACQUI_LEN = 76/2,

    // acquiasion length settings
    parameter integer ACQUI_LEN = 200/2,

    // TIME STAMP DATA WIDTH
    parameter integer TIME_STAMP_WIDTH = 16,

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

    // triggered time stamp
	output wire [TIME_STAMP_WIDTH-1:0] O_TIME_STAMP,

    // triggered flag output
    output wire O_TRIGGERD_FLAG,

    // Ports of Axi Slave Bus Interface S00_AXIS　
    input wire  AXIS_ACLK,
    input wire  AXIS_ARESETN,
    input wire [S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA

);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth);
    begin
      for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
        bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer POST_COUNTER_WIDTH = clogb2(POST_ACQUI_LEN-1); 
  localparam integer FULL_COUNTER_WIDTH = clogb2(ACQUI_LEN-1);
  localparam integer SAMPLE_PER_TDATA = S_AXIS_TDATA_WIDTH/16;
  localparam integer COMPARE_RESULT_BIT_SUM_WIDTH = clogb2(SAMPLE_PER_TDATA-1);
  localparam integer REDUCE_DIGIT = 16 - ADC_RESOLUTION_WIDTH;
  localparam signed ADC_MAX_VAL = 2**(ADC_RESOLUTION_WIDTH-1)-1;
  localparam signed ADC_MIN_VAL = -2**(ADC_RESOLUTION_WIDTH-1);
  localparam signed THRESHOLD_VAL = (ADC_MAX_VAL-ADC_MIN_VAL)*THRESHOLD/100;

  //  exec state
  localparam [1:0] INIT = 2'b00, // ADC < THRESHOLD_VAL
                    TRG = 2'b11; // ADC > THRESHOLD_VAL

  // trigger state
  localparam [1:0] WAIT = 2'b00,
                    TRIGGERD = 2'b01,
                    END = 2'b11;
  reg [1:0] trigger_state;

  // ADC value state
  localparam [1:0] ZONE_0 = 2'b00, // ADC < THRESHOLD_VAL
                    ZONE_1 = 2'b11, // ADC > THRESHOLD_VAL
                    CALB = 2'b01; // calibration
  reg [1:0] adc_val_state = ZONE_0;
  wire [1:0] adc_val_state_delay;

  // triggered flag 
  reg triggerd_flag;
  wire trigger_flag_delay;
  assign TRIGGERD_FLAG = triggerd_flag;

  // finish trigger flag
  reg finish_trg;

  // ACQUI_LEN 内にtriggerが終わらなかった場合のフラグ
  reg over_len_flag;
  wire over_len_flag_delay;

  // S_AXIS_TDATAを分割するための配列
  wire signed [ADC_RESOLUTION_WIDTH-1:0] s_axis_tdata_word[SAMPLE_PER_TDATA-1:0];

  // POST ACQUIASION COUNTER
  reg [POST_COUNTER_WIDTH-1:0] post_count = 0;

  // ACQUASION COUNTER
  reg [FULL_COUNTER_WIDTH-1:0] full_count = 0;

  // comparing ADC value with THRESHOLD_VAL
  reg compare_result;
  reg [COMPARE_RESULT_BIT_SUM_WIDTH-1:0] compare_result_sum;

  // trigger time stamp
  reg [TIME_STAMP_WIDTH-1:0] time_stamp;

  // ADCの値がどの範囲にあるか判定
  always @(posedge AXIS_ACLK) begin  
    if (!AXIS_ARESETN) begin
      adc_val_state <= ZONE_0;
    end else begin
      if (EXEC_STATE == INIT) begin
        adc_val_state <= CALB;
      end else begin
        if (compare_result) begin
          adc_val_state <= ZONE_1;
        end else begin
          adc_val_state <= ZONE_0;
        end
      end
    end
  end

  Delay #(
    .DELAY_CLK(1),
    .WIDTH(2)
  ) adc_val_state_delay_inst (
    .CLK(AXIS_ACLK),
    .RESETn(AXIS_ARESETN),
    .DIN(adc_val_state),
    .DOUT(adc_val_state_delay)
  );

  Delay #(
    .DELAY_CLK(1),
    .WIDTH(1)
  ) triggerd_flag_delay_inst (
    .CLK(AXIS_ACLK),
    .RESETn(AXIS_ARESETN),
    .DIN(triggerd_flag),
    .DOUT(trigger_flag_delay)
  );

  Delay #(
    .DELAY_CLK(1),
    .WIDTH(1)
  ) over_len_flag_delay_inst (
    .CLK(AXIS_ACLK),
    .RESETn(AXIS_ARESETN),
    .DIN(over_len_flag),
    .DOUT(over_len_flag_delay)
  );

  // trigger_state の 動作
  always @(posedge AXIS_ACLK) begin  
    if (!AXIS_ARESETN) begin
      trigger_state <= WAIT;
    end else begin
      if (adc_val_state == ZONE_1) begin
        if (over_len_flag) begin
          trigger_state <= END;
        end else begin
          trigger_state <= TRIGGERD;
        end
      end else begin
        if (finish_trg) begin
          trigger_state <= END;
        end else begin
          trigger_state <= TRIGGERD;
        end
      end
    end
  end

  // time-stampの代入
  always @(posedge AXIS_ACLK ) begin
    if (!AXIS_ARESETN) begin
      time_stamp <= 0;
    end else begin
      if (triggerd_flag&(!trigger_flag_delay)) begin
          time_stamp <= CURRENT_TIME;
      end else begin
        time_stamp <= time_stamp;
      end
    end
  end

  // trigger flagの動作
  always @(posedge AXIS_ACLK ) begin
    if (!AXIS_ARESETN) begin
      triggerd_flag <= 1'b0;
    end else begin
      case (trigger_state)
        WAIT:
          begin
            triggerd_flag <= 1'b0;
          end
        TRIGGERD:
          begin
            triggerd_flag <= 1'b1;
          end
        END:
          begin
            triggerd_flag <= 1'b0;
          end 
        default:
          begin
            triggerd_flag <= 1'b0;
          end 
      endcase
    end  
  end

  // post count
  always @(posedge AXIS_ACLK) begin  
    if (!AXIS_ARESETN) begin
      post_count <= POST_ACQUI_LEN-1;
    end else begin
      if ((adc_val_state == ZONE_0)&&(adc_val_state_delay == ZONE_1)) begin
          post_count <= 0;
      end else begin
        if (post_count>=POST_ACQUI_LEN-1) begin
          post_count <= post_count;
        end else begin
          post_count <= post_count + 1;
        end
      end        
    end
  end

  // finished_flagの動作
  always @(posedge AXIS_ACLK ) begin
    if (!AXIS_ARESETN) begin
      finish_trg <= 1'b1;
    end else begin
      if (triggerd_flag && (post_count < POST_ACQUI_LEN-1)) begin
        finish_trg <= 1'b0;
      end else begin
        finish_trg <= 1'b1;
      end
    end
  end

  // full count
  always @(posedge AXIS_ACLK ) begin
    if (!AXIS_ARESETN) begin
      full_count <= 0;
    end else begin
      if ((adc_val_state == ZONE_1)&&(adc_val_state_delay == ZONE_0)) begin
        full_count <= 0;
      end else begin
        if (full_count >= ACQUI_LEN) begin
          full_count <= full_count;
        end else begin
          full_count <= full_count + 1;
        end
      end
    end
  end

  // over_len_flagの動作
  always @(posedge AXIS_ACLK ) begin
    if (!AXIS_ARESETN) begin
      over_len_flag <= 1'b0;
    end else begin
      if (triggerd_flag && (full_count >= ACQUI_LEN-1)) begin
        over_len_flag <= 1'b1;
      end else begin
        over_len_flag <= 1'b0;
      end
    end
  end

  // S_AXIS_TDATAの分割
  genvar i;
  generate
    for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+1 )
      begin
        assign s_axis_tdata_word[i] = S_AXIS_TDATA[16*(i+1)-1 -:ADC_RESOLUTION_WIDTH];
      end
  endgenerate  

  // Thresoldの値との比較
  integer j;
  always @(posedge AXIS_ACLK ) begin
    if (!AXIS_ARESETN) begin
      compare_result_sum = 0;
    end else begin
      for (j=0;j<SAMPLE_PER_TDATA;j=j+1)
        begin
          compare_result_sum = compare_result_sum + ((s_axis_tdata_word[j]-BASELINE) >= THRESHOLD_VAL);
        end
    end
  end

  always @(posedge AXIS_ACLK ) begin
    if (!AXIS_ARESETN) begin
      compare_result <= 1'b0;
    end else begin
      if (compare_result_sum[0]==1'b0) begin
        compare_result <= 1'b0;
      end else begin
        compare_result <= 1'b1;
      end
    end
  end

  assign O_TIME_STAMP = time_stamp;
  assign O_TRIGGERD_FLAG = triggerd_flag;

endmodule