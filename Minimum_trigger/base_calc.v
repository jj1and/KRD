`timescale 1 ns / 1 ps

module base_calc # (

    // threshold ( percentage of max value = 2^12)
    parameter integer THRESHOLD = 10,

    // Baselineの計算時間
    parameter integer BASELINE_CALC_LEN = 5E8,

    // RFSoC ADC resolution
    parameter integer ADC_RESOLUTION_WIDTH = 12,
    
    // RF Data Converter data stream bus width
    parameter integer S_AXIS_TDATA_WIDTH	= 128

)
(    
    // exec statte
    input wire [1:0] EXEC_STATE,

    // Baseline value
    output wire [ADC_RESOLUTION_WIDTH-1:0] O_BASELINE,

    // Baselineの計算完了フラグ
    output wire O_CALC_COMPLETE,

    // Ports of Axi Slave Bus Interface S00_AXIS　
    input wire  AXIS_ACLK,
    input wire  AXIS_ARESETN,
    input wire [S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
    input wire  S_AXIS_TVALID

);

	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction

    localparam integer CALC_COUNTER_WIDTH = clogb2(BASELINE_CALC_LEN-1);
    localparam integer SAMPLE_PER_TDATA = S_AXIS_TDATA_WIDTH/16;
    localparam integer REDUCE_DIGIT = 16 - ADC_RESOLUTION_WIDTH;
    localparam integer SUM_BIT_WIDTH = clogb2(SAMPLE_PER_TDATA);

    integer j;

    //  exec state
    localparam [1:0] INIT = 2'b00, // ADC < THRESHOLD_VAL
                     TRG = 2'b11; // ADC > THRESHOLD_VAL

    // baseline 計算用カウンター
    reg signed [CALC_COUNTER_WIDTH-1:0]  bl_calc_cnt;

    // 平均baseline
    reg signed [ADC_RESOLUTION_WIDTH-1:0] ave_baseline;
    assign O_BASELINE = ave_baseline;

    // 平均baseline
    reg signed [ADC_RESOLUTION_WIDTH-1:0] temp_ave_baseline;
    // temporary baseline sum (data bus が 128bitを想定)
    reg signed [ADC_RESOLUTION_WIDTH-1+SUM_BIT_WIDTH:0] temp_bl_sum;

    // S_AXIS_TDATAを分割するための配列
    wire signed [ADC_RESOLUTION_WIDTH-1:0] s_axis_tdata_word[SAMPLE_PER_TDATA-1:0];

    // baseline calc start enable
    wire calc_en;
    assign calc_en = (EXEC_STATE == INIT)&(S_AXIS_TVALID);

    // baseline calc complete
    reg calc_comp;
    assign O_CALC_COMPLETE = calc_comp;

    // baselineの計算カウンターの動作
    always @(posedge AXIS_ACLK) 
	begin  
	  if (!AXIS_ARESETN) 
	    begin
          bl_calc_cnt <= 0;
          calc_comp <= 1'b0;
	    end
	  else
	    begin
          if ( calc_en )
            begin
              if (bl_calc_cnt >= BASELINE_CALC_LEN-1)
                begin
                  bl_calc_cnt <= bl_calc_cnt;
                  calc_comp <= 1'b1;
                end
              else
                begin
                  bl_calc_cnt <= bl_calc_cnt + 1;
                  calc_comp <= 1'b0;
                end
            end
          else
            begin
              bl_calc_cnt <= 0;
              calc_comp <= calc_comp;
            end
	    end
	end

    // S_AXIS_TDATAの分割
    genvar i;
    generate
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+1 )
        begin
          assign s_axis_tdata_word[i] = S_AXIS_TDATA[16*i +:ADC_RESOLUTION_WIDTH];
        end
    endgenerate

    // baselineの計算
    always @(posedge AXIS_ACLK) 
	begin  
	  if (!AXIS_ARESETN) 
	    begin
          ave_baseline <= 0;
          temp_ave_baseline <= 0;
          temp_bl_sum <= 0;
	    end
	  else
	    begin
          if ( calc_en )
            begin
              if (bl_calc_cnt < BASELINE_CALC_LEN-1)
                begin
                  if (bl_calc_cnt==0)
                    begin
                      temp_ave_baseline <= temp_bl_sum/SAMPLE_PER_TDATA;
                    end
                  else
                    begin
                      temp_ave_baseline <= temp_ave_baseline/2 + temp_bl_sum/(SAMPLE_PER_TDATA*2);
                    end
                end
              else
                begin
                  ave_baseline <= temp_ave_baseline;
                end
            end
          else
            begin
              ave_baseline <= ave_baseline;
              temp_ave_baseline <= temp_ave_baseline;
            end
	    end
	end

  always @(posedge AXIS_ACLK )
  begin
    if (!AXIS_ARESETN)
      begin
        temp_bl_sum <= 0;
      end
    else
      begin
        for ( j=1 ; j<SAMPLE_PER_TDATA ; j=j+1 ) begin
          temp_bl_sum <= temp_bl_sum + s_axis_tdata_word[j];
        end
      end  
  end

endmodule