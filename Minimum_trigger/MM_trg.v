`timescale 1 ns / 1 ps

module MM_trg # (

    // threshold ( percentage of max value = 2^12)
    parameter integer THRESHOLD = 10,
    
    // acquiasion length settings
    parameter integer POST_ACQUI_LEN = 76/2,

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
    input wire [ADC_RESOLUTION_WIDTH-1:0] BASELINE,
    
    // current time
    input wire [TIME_STAMP_WIDTH-1:0] CURRENT_TIME,

    // triggered time stamp
	output wire [TIME_STAMP_WIDTH-1:0] O_TIME_STAMP,

    // trigger start output
    output wire O_START_TRG,
    // trigger start output
    output wire O_FINALIZE_TRG,

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
    localparam integer SAMPLE_PER_TDATA = S_AXIS_TDATA_WIDTH/16;
    localparam integer REDUCE_DIGIT = 16 - ADC_RESOLUTION_WIDTH;
    localparam integer THRESHOLD_VAL = (2^ADC_RESOLUTION_WIDTH)*THRESHOLD/100;

    //  exec state
    localparam [1:0] INIT = 2'b00, // ADC < THRESHOLD_VAL
                     TRG = 2'b11; // ADC > THRESHOLD_VAL

    // ADC value state
    localparam [1:0] ZONE_0 = 2'b00, // ADC < THRESHOLD_VAL
                     ZONE_1 = 2'b11, // ADC > THRESHOLD_VAL
                     CALB = 2'b01; // calibration
    reg [1:0] adc_val_state = ZONE_0;
    reg [1:0] adc_val_state_delay = ZONE_0;

    // start trigger flag
    reg start_trg;

    // finalize trigger flag
    reg finalize_trg;

    // POST ACQUIASION COUNTER
    reg [POST_COUNTER_WIDTH-1:0] post_count = 0;

    // comparing ADC value with THRESHOLD_VAL
    wire [SAMPLE_PER_TDATA-1:0] compare_result;

    // trigger time stamp
    reg [TIME_STAMP_WIDTH-1:0] time_stamp;

   // ADCの値がどの範囲にあるか判定
    always @(posedge AXIS_ACLK) 
	begin  
	  if (!AXIS_ARESETN) 
	    begin
	      adc_val_state <= ZONE_0;
          adc_val_state_delay <= adc_val_state;
	    end
	  else
	    begin
          if (EXEC_STATE == INIT)
            begin
              adc_val_state_delay <= adc_val_state;
              adc_val_state <= CALB;
            end
          else
            begin
              if (|compare_result)
                begin
                  adc_val_state_delay <= adc_val_state;
                  adc_val_state <= ZONE_1;
                end
              else
                begin
                  adc_val_state_delay <= adc_val_state;
                  adc_val_state <= ZONE_0;
                end
            end
	    end
	end

    // trigger flag の 動作
    always @(posedge AXIS_ACLK) 
	begin  
	  if (!AXIS_ARESETN) 
	    begin
	      start_trg <= 1'b0;
          finalize_trg <= 1'b0;
          time_stamp <= 0;
	    end
	  else
	    begin
          if (adc_val_state == ZONE_1)
            begin
              start_trg <= 1'b1;
              time_stamp <= CURRENT_TIME;
            end
          else
            begin
              time_stamp <= time_stamp;
              if (adc_val_state_delay == ZONE_1)
                begin
                  start_trg <= 1'b1;
                  finalize_trg <= 1'b1;
                end
              else
                begin
                  if ((post_count>0)&(post_count<POST_ACQUI_LEN))
                    begin
                      start_trg <= 1'b1;
                      finalize_trg <= 1'b1;
                    end
                  else
                    begin
                      start_trg <= 1'b0;
                      finalize_trg <= 1'b0;                      
                    end
                end
            end
	    end
	end

    // post countの動作
    always @(posedge AXIS_ACLK) 
	begin  
	  if (!AXIS_ARESETN) 
	    begin
          post_count <= 0;
	    end
	  else
	    begin
          if (finalize_trg)
            begin
              if (post_count>POST_ACQUI_LEN-1)
                begin
                  post_count <= 0;
                end
              else 
                begin
                  post_count <= post_count + 1;
                end
            end
          else
            begin
              post_count <= 0;
            end        
	    end
	end

    // Thresoldの値との比較
    genvar i;
	generate
	  for(i=0;i<SAMPLE_PER_TDATA;i=i+1)
	    begin
	      assign compare_result[i] = ((S_AXIS_TDATA[16*(i+1)-1:16*i+REDUCE_DIGIT]-BASELINE) >= THRESHOLD_VAL);
	    end
	endgenerate

    assign O_TIME_STAMP = time_stamp;
    assign O_START_TRG = start_trg;
    assign O_FINALIZE_TRG = finalize_trg;



endmodule