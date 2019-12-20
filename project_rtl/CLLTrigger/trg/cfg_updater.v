`timescale 1 ns / 1 ps

module cfg_updater # (

    	// S_AXI_LITE_CFG threshold level data bus width (bit)
        parameter integer C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH = 16,
        // Width of threshold level 1 data bus
        parameter integer THRE_1_LEVEL_WIDTH = 8,
        // S_AXI_LITE_CFG acquisition length data bus width (bit)
        parameter integer C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH = 16,
        // max proceeding_acquisition length (unit is clock) data bus width
        parameter integer MAX_PRO_ACQUI_LENGTH_WIDTH = 5,
        parameter integer MAX_TIMEOUT_LENGTH_WIDTH = 8,
        
        // data_width for time counter data bus width (bit)
        parameter integer TIME_COUNTER_WIDTH = 16,
        
        //RF ADC resolution (bit)
        parameter integer ADC_RESO_WIDTH = 12,
        
        // initial baseline scan scale
        parameter integer INIT_BL_SCALE = 10,

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Parameters of Axi Slave Bus Interface S00_AXIS
		parameter integer C_S00_AXIS_TDATA_WIDTH	= 128

)(
    // updated threshold =  { thre_1 (THRE_1_LEVEL_WIDTH bit), thre_2 (THRE_2_LEVEL_WIDTH bit) }
	  input wire [C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH-1:0] cfg_new_thre,
		// updated pre/proceeding wait length =  { max_pre_cnt (MAX_PRE_ACQUI_LENGTH_WIDTH bit), max_pro_cnt (MAX_PRO_ACQUI_LENGTH_WIDTH bit), max_out_cnt (MAX_TIMEOUT_LENGTH_WIDTH bit) }
		input wire [C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH-1:0] cfg_new_len,
		// new BaseLine from BL-Calc module
		input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] new_bl,
		// cfg update flag
		input wire cfg_update_flag,

    // initial baseline
    output wire [ADC_RESO_WIDTH-1 : 0] o_init_curr_bl,
    // threshold 1 (nearly Baseline)
    output wire [ADC_RESO_WIDTH-1-1:0] o_thre_1,
    // threshold 2 (value is larger than thre1)
    output wire [ADC_RESO_WIDTH-1-1:0] o_thre_2,
    // thre_1 down cross to thre_2 down cross (unit is clock)
    output wire [MAX_PRE_ACQUI_LENGTH_WIDTH-1:0] o_max_pre_cnt,
    // thre_2 up cross to trigger end (unit is clock)
    output wire [MAX_PRO_ACQUI_LENGTH_WIDTH-1:0] o_max_pro_cnt,
    // thre_2 down cross to trigger end (unit is clock)
    output wire [MAX_TIMEOUT_LENGTH_WIDTH-1:0] o_max_out_cnt,
    // config update done flag
    output wire o_cfg_update_done,
    // initialize done
    output wire o_init_done,
    // initialize done delay
    output wire o_init_done_delay,

    // Ports of Axi Slave Bus Interface S00_AXIS　
		input wire  s00_axis_aclk,
		input wire  s00_axis_aresetn,
		output wire  s00_axis_tready,
		input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
		input wire  s00_axis_tvalid
);

	// Add user logic here
	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction

    localparam integer THRE_2_LEVEL_WIDTH = C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH - THRE_1_LEVEL_WIDTH;
    localparam integer THRE_1_LEVEL_DELTA = 2 ** (ADC_RESO_WIDTH-THRE_1_LEVEL_WIDTH);
    localparam integer THRE_2_LEVEL_DELTA = 2 ** (ADC_RESO_WIDTH-THRE_2_LEVEL_WIDTH);
    localparam integer MAX_PRE_ACQUI_LENGTH_WIDTH =  C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH-MAX_PRO_ACQUI_LENGTH_WIDTH-MAX_TIMEOUT_LENGTH_WIDTH;
    localparam integer SAMPLE_PER_TDATA = C_S00_AXIS_TDATA_WIDTH/16;
    localparam integer REDUCE_DIGIT = 16 - ADC_RESO_WIDTH;
    localparam integer TMP_BL_SUM_WIDTH = clogb2(ADC_RESO_WIDTH*INIT_BL_SCALE-1);
    localparam integer INIT_BL_SCALE_WIDTH = clogb2(INIT_BL_SCALE-1);
	
	// when initialize has done, this value must be 1
	reg init_done = 1'b0;
	reg init_done_delay = 1'b0;
	reg curr_cfg_update_flag = 1'b0;
	reg curr_cfg_update_flag_delay = 1'b0;
	// when initialization is completed, this value must be 1 
	// when cfg_update_flag is 1, this value must be 0 untill cfg update has done.
	reg cfg_update_done = 1'b0;
	
	// threshold 1 (nearly Baseline)
	reg [ADC_RESO_WIDTH-1-1:0] thre_1 = 1;
	// threshold 2 (value is larger than thre1)
	reg [ADC_RESO_WIDTH-1-1:0] thre_2 = 5;
	// thre_1 down cross to thre_2 down cross (unit is clock)
	reg [MAX_PRE_ACQUI_LENGTH_WIDTH-1:0] max_pre_cnt = 8;
	// thre_2 up cross to trigger end (unit is clock)
	reg [MAX_PRO_ACQUI_LENGTH_WIDTH-1:0] max_pro_cnt = 32;
	// thre_2 down cross to trigger end (unit is clock)
	reg [MAX_TIMEOUT_LENGTH_WIDTH-1:0] max_out_cnt = 0;

    // for initial baseline scan
	reg [TMP_BL_SUM_WIDTH-1 : 0] tmp_bl_sum = 0;
	reg [INIT_BL_SCALE_WIDTH-1:0] init_bl_cnt = 0;
	// initial current baseline
	reg [ADC_RESO_WIDTH-1 : 0] init_curr_bl = 0;

  assign o_init_curr_bl = init_curr_bl;
  assign o_thre_1 = thre_1;
  assign o_thre_2 = thre_2;
  assign o_max_pre_cnt = max_pre_cnt;
  assign o_max_pro_cnt = max_pro_cnt;
  assign o_max_out_cnt = max_out_cnt;
  assign o_cfg_update_done = cfg_update_done;
  assign o_init_done = init_done;
  assign o_init_done_delay = init_done_delay;

    //cfg update & init implementation
	always @(posedge s00_axis_aclk) 
	begin  
	  if (!s00_axis_aresetn) 
	  // Synchronous reset (active low)
	    begin
	      init_done <= 1'b0;
	      init_done_delay <= 1'b0;
	      init_bl_cnt <= 13'd0;
	      curr_cfg_update_flag <= 1'b0;
	      curr_cfg_update_flag_delay <= 1'b0;
	      cfg_update_done <= 1'b0;
	    end
	  else
	    begin
	      curr_cfg_update_flag_delay <= curr_cfg_update_flag;
	      curr_cfg_update_flag <= cfg_update_flag;
	      if ( !cfg_update_done )
	        begin
              max_pre_cnt <= cfg_new_len[C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH-1:MAX_PRO_ACQUI_LENGTH_WIDTH + MAX_TIMEOUT_LENGTH_WIDTH];
              max_pro_cnt <= cfg_new_len[MAX_PRO_ACQUI_LENGTH_WIDTH + MAX_TIMEOUT_LENGTH_WIDTH-1:MAX_TIMEOUT_LENGTH_WIDTH];
              max_out_cnt <= cfg_new_len[MAX_TIMEOUT_LENGTH_WIDTH-1:0];
              thre_1 <= cfg_new_thre[C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH-1:THRE_2_LEVEL_WIDTH]*THRE_1_LEVEL_DELTA;
              thre_2 <= cfg_new_thre[THRE_2_LEVEL_WIDTH-1:0]*THRE_2_LEVEL_DELTA; 
              cfg_update_done <= 1'b1;
              init_done_delay <= init_done;
              init_done <= 1'b0; 
	        end
	          //this if section is for initial baseline scan
              else if ( !init_done )
                begin
                  if ( s00_axis_tvalid )
                    begin
                      if ( init_bl_cnt < INIT_BL_SCALE )
                        begin
                          if ( init_curr_bl != new_bl )
                            begin
                              tmp_bl_sum <= tmp_bl_sum + init_curr_bl;
                              init_curr_bl <= new_bl;
                              init_bl_cnt <= init_bl_cnt + 13'd1;
                              init_done_delay <= init_done;
                              init_done <= 1'b0;                              
                            end
                        end
                      else
                        begin
                          init_curr_bl <= tmp_bl_sum/INIT_BL_SCALE;
                          init_bl_cnt <= 13'd0;
                          init_done_delay <= init_done;
                          init_done <= 1'b1;
                        end
                    end
                  else
                    begin
                      init_done_delay <= init_done;
                      init_done <= 1'b0;                       
                    end
	           end
	      // cfg_update_flag = 0 or 1, cfg_update_done = init_done = 1;  
	      else
	        begin
	          if ( (curr_cfg_update_flag == 1'b1) & ( !curr_cfg_update_flag_delay == 1'b0 )  )
	            begin
	              cfg_update_done <= 1'b0;
	              init_done_delay <= init_done;
                  init_done <= 1'b0;
	            end    
	          // this else is (cfg_update_flag, delay) = (0,0),(0,1),(1,1) , cfg_update_done = init_done = 1; this is normal. nothing to do
              // else
              //   begin
              //   end 	          
	        end
	    end
	end

endmodule