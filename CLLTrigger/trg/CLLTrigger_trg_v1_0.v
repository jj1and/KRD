
`timescale 1 ns / 1 ps

	module CLLTrigger_trg_v1_0 #
	(
		// Users to add parameters here
		
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
	)
	(
		// Users to add ports here
	   
		// triggered time stanp
		output wire [TIME_COUNTER_WIDTH-1:0] time_stamp,
		// time counter input
		input wire [TIME_COUNTER_WIDTH-1:0] curr_time,
		// updated threshold =  { thre_1 (THRE_1_LEVEL_WIDTH bit), thre_2 (THRE_2_LEVEL_WIDTH bit) }
		input wire [C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH-1:0] cfg_new_thre,
		// updated pre/proceeding wait length =  { max_pre_cnt (MAX_PRE_ACQUI_LENGTH_WIDTH bit), max_pro_cnt (MAX_PRO_ACQUI_LENGTH_WIDTH bit), max_out_cnt (MAX_TIMEOUT_LENGTH_WIDTH bit) }
		input wire [C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH-1:0] cfg_new_len,
		// new BaseLine from BL-Calc module
		input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] new_bl,
		output wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] recv_tdata,
		
		// cfg update flag
		input wire cfg_update_flag,
//		// baseline update flag
//		input wire bl_update_flag,
		// cfg update done or not ; done => 1, not => 0
		output wire cfg_update_state,
		//trigger state
		output wire [2:0] trg_state,
		// exception assert
		output wire [2:0] err_assert,
		
//		// BL update done or not ; done => 1, not => 0
//		output wire bl_update_state,

		// User ports ends
		// Do not modify the ports beyond this line

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
	
	// mst exec state
    localparam [1:0] TRG_MODE = 2'b00,    // In this state Trigger mode is enabled
                    CFG_UPDATE  = 2'b11; // In this state the threshold is being updated
    
    // thre cross state                
    localparam [2:0] NO_TRG = 3'b000,       // non triggered
                    POSSIBLE_TRG = 3'b100, // down cross thre_1
                    CANCEL_TRG = 3'b101, // down cross thre_1 but not down cross thre_2, and down cross thre_1, or time out (pre_cnt >= max_pre_cnt)
                    CONFIRM_TRG = 3'b110,  // up cross thre_2
                    FINALIZE_TRG = 3'b111, // after down cross thre_2, up cross thre_1 trigger WILL end after max_pro_length (clock)
                    TIMEOUT_TRG = 3'b010;
                    // 3'b011, 3'b001 -> not-exist; 
                
    // ADC value state
    localparam [1:0] ZONE_1 = 2'b00, // ADC < thre_1, thre_2
                     ZONE_2 = 2'b10, // ADC > thre_1, ADC < thre_2
                     ZONE_3 = 2'b11; // ADC > thre_1, thre_2
               
    // error code
    localparam [2:0] NO_ERROR = 3'b000,           // no error
                     CFG_ERROR = 3'b001,          // config & init error. check config & init implementation section
                     TRG_LOGIC_ERROR = 3'b010,    // trigger logic error. check trigger logic implementation section
                     VAL_JUMP = 3'b111,           // ADC value is jumped. check threshold value ( this is configurable from PS )
                     VAL_STAY = 3'b110;           // ADC value doesn't go back to BL. Check Baseline setting etc.
                
    localparam integer THRE_2_LEVEL_WIDTH = C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH - THRE_1_LEVEL_WIDTH;
    localparam integer THRE_1_LEVEL_DELTA = 2 ** (ADC_RESO_WIDTH-THRE_1_LEVEL_WIDTH);
    localparam integer THRE_2_LEVEL_DELTA = 2 ** (ADC_RESO_WIDTH-THRE_2_LEVEL_WIDTH);
    localparam integer MAX_PRE_ACQUI_LENGTH_WIDTH =  C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH-MAX_PRO_ACQUI_LENGTH_WIDTH-MAX_TIMEOUT_LENGTH_WIDTH;
    localparam integer SAMPLE_PER_TDATA = C_S00_AXIS_TDATA_WIDTH/16;
    localparam integer REDUCE_DIGIT = 16 - ADC_RESO_WIDTH;
    localparam integer TMP_BL_SUM_WIDTH = clogb2(ADC_RESO_WIDTH*INIT_BL_SCALE-1);
    localparam integer INIT_BL_SCALE_WIDTH = clogb2(INIT_BL_SCALE-1);
	
    // Macine state variable
	reg [1:0] mst_exec_state = CFG_UPDATE;
	// threshold cross state ( = { thre_1 down cross, thre_2 down cross, thre_1 up cross } no tsumori datta )
	reg [2:0] thre_cross_state = NO_TRG;
	// ADC value state variable
	reg [1:0] adc_val_state = ZONE_1;
	reg [1:0] adc_val_state_delay = ZONE_1;
	// eeception state
	reg [2:0] err_code = NO_ERROR;
	assign err_assert = err_code;
	
 	// thre_1 down cross to thre_2 down cross counter var
	reg [MAX_PRE_ACQUI_LENGTH_WIDTH:0] pre_cnt = 0;
  // thre_1 up cross to trigger end counter var
	reg [MAX_PRO_ACQUI_LENGTH_WIDTH:0] pro_cnt = 0;
	reg [MAX_TIMEOUT_LENGTH_WIDTH-1:0] out_cnt = 0;
	
	// AXI-Stream singnals
	reg tvalid;
	assign s00_axis_tready = (mst_exec_state == TRG_MODE);
	
	// current baseline
	reg [ADC_RESO_WIDTH-1 : 0] curr_bl = 0;
	
	//trigger end flag
	reg trg_end_flag = 1'b0;
	//when triggered signal is noise, this flag is 1
	reg noise_flag = 1'b0;
	// value is valid or not
	reg valid_trg = 1'b0;
	// thre_1 down cross time stamp
	reg [TIME_COUNTER_WIDTH-1:0] thre_1_time_stamp = 0;
	assign time_stamp = thre_1_time_stamp;
	// comparison result with thre_1
	wire [SAMPLE_PER_TDATA-1 : 0] comp_result_thre_1 = 0;
	// comparison result with thre_2
	wire [SAMPLE_PER_TDATA-1 : 0] comp_result_thre_2 = 0;

	assign cfg_update_state = cfg_update_done;
	assign trg_state = { valid_trg, trg_end_flag, noise_flag };
	
	// Control state machine implementation
	always @(posedge s00_axis_aclk) 
	begin  
	  if (!s00_axis_aresetn) 
	  // Synchronous reset (active low)
	    begin
	      mst_exec_state <= CFG_UPDATE;
	    end  
	  else
	    begin
	    case ( mst_exec_state )
	    CFG_UPDATE:
	      begin
	        valid_trg <= 1'b0;
	        if ( cfg_update_done )
	          begin
	            mst_exec_state <= TRG_MODE;
              end
	        else
	          begin
	            mst_exec_state <= CFG_UPDATE;
	          end
	      end
	    TRG_MODE:
          begin
            if ( cfg_update_flag )
              begin
                mst_exec_state <= CFG_UPDATE;
              end
	        else
	          begin
	            if ( init_done&init_done_delay )
	              begin
	                valid_trg <= 1'b1;
	              end
	            mst_exec_state <= TRG_MODE;
	          end
          end
	    endcase
	    end
	end
	
  module cfg_updater #
  (
        .C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH()
        .THRE_1_LEVEL_WIDTH(),
        .C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH(),
        .MAX_PRO_ACQUI_LENGTH_WIDTH(),
        .MAX_TIMEOUT_LENGTH_WIDTH(),
        .TIME_COUNTER_WIDTH = 16,
        .ADC_RESO_WIDTH = 12,
        . INIT_BL_SCALE = 10,
		    .C_S00_AXIS_TDATA_WIDTH	= 128

  ) cfg_updater_inst (

  )

	
    //trg mode logic implementation
	always @(posedge s00_axis_aclk) 
	begin  
	  if (!s00_axis_aresetn) 
	    begin
	      thre_cross_state <= NO_TRG;
          trg_end_flag <= 1'b0;
          noise_flag <= 1'b0;
	    end
	  else
	    begin
          if ( !init_done_delay )
            begin
              curr_bl <= init_curr_bl;
            end
          else if (curr_bl != new_bl)
            begin
              curr_bl <= new_bl;
            end
          case (adc_val_state)
          ZONE_1:
            begin
              if( adc_val_state_delay == ZONE_1 )
                begin
                  if ( thre_cross_state == FINALIZE_TRG )
                    begin
                      if ( pro_cnt >= max_pro_cnt )
                        begin
                          thre_cross_state <= NO_TRG;
                          trg_end_flag <= 1'b1;
                          pro_cnt <= 0;                                  
                        end
                      else
                        begin
                          // thre_cross_state_delay <= thre_cross_state;
                          // thre_cross_state_delay <= FINALIZE_TRG;
                          pro_cnt <= pro_cnt + 1;
                        end
                    end    
                  else
                    begin
                      thre_cross_state <= NO_TRG;
                      trg_end_flag <= 1'b0;
                      noise_flag <= 1'b0;                                                        
                    end
                end
              else
                begin
                  if ( adc_val_state_delay == ZONE_2 )
                    begin
                      case ( thre_cross_state )
                      CONFIRM_TRG:
                        begin
                          thre_cross_state <= FINALIZE_TRG;
                          trg_end_flag <= 1'b1;
                          pro_cnt <= 0;                                   
                        end
                      POSSIBLE_TRG:
                        begin
                          thre_cross_state <= CANCEL_TRG;
                          noise_flag <= 1'b1;
                          pre_cnt <= 0;
                        end
                      CANCEL_TRG:
                        begin
                          thre_cross_state <= NO_TRG;
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;
                        end
                      TIMEOUT_TRG:
                        begin
                          thre_cross_state <= NO_TRG;
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;
                        end
                      default
                        begin
                          err_code <= TRG_LOGIC_ERROR;
                          thre_cross_state <= NO_TRG;                              
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;                                 
                        end                               
                      endcase                            
                    end
                  else
                    begin
                      err_code <= VAL_JUMP;
                      case ( thre_cross_state )
                      CONFIRM_TRG:
                        begin
                          thre_cross_state <= FINALIZE_TRG;
                          trg_end_flag <= 1'b1;
                          pro_cnt <= 0;                                   
                        end
                      default
                        begin
                          err_code <= TRG_LOGIC_ERROR;
                          thre_cross_state <= NO_TRG;                              
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;                                 
                        end                               
                      endcase                              
                    end              
                end
            end
          ZONE_2:
            begin
              if( thre_cross_state == POSSIBLE_TRG )
                begin
                  if ( pre_cnt < max_pre_cnt )
                    begin
                      pre_cnt <= pre_cnt + 1;
                    end
                  else
                    begin
                      thre_cross_state <= CANCEL_TRG;
                      noise_flag <= 1'b1;
                      pre_cnt <= 0;
                    end                          
                end
              else
                begin
                  case ( adc_val_state_delay )
                  ZONE_1:
                    begin
                      case ( thre_cross_state )
                      NO_TRG:
                        begin
                          thre_cross_state <= POSSIBLE_TRG;
                          thre_1_time_stamp <= curr_time;
                          pre_cnt <= 0;
                        end
                      CANCEL_TRG:
                        begin
                          thre_cross_state <= NO_TRG;                              
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;                                  
                        end
                      FINALIZE_TRG:
                        begin
                          if ( pro_cnt >= max_pro_cnt )
                            begin
                              thre_cross_state <= NO_TRG;
                              trg_end_flag <= 1'b1;
                              pro_cnt <= 0;                                  
                            end
                          else
                            begin
                              // thre_cross_state_delay <= thre_cross_state;
                              // thre_cross_state_delay <= FINALIZE_TRG;
                              pro_cnt <= pro_cnt + 1;
                            end                                   
                        end
                      default
                        begin
                          err_code <= TRG_LOGIC_ERROR;
                          thre_cross_state <= NO_TRG;                              
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;                                  
                        end
                      endcase
                    end
                  ZONE_2:
                    begin
                      case ( thre_cross_state )
                      CONFIRM_TRG:
                        begin
                          if ( out_cnt < max_out_cnt )
                            begin
                              out_cnt <= out_cnt + 1;
                            end
                          else
                            begin;
                              thre_cross_state <= TIMEOUT_TRG;
                              trg_end_flag <= 1'b1;
                              out_cnt <= 0;
                            end                                   
                        end
                      NO_TRG:
                        begin
                          err_code <= VAL_STAY;
                          thre_cross_state <= POSSIBLE_TRG;
                          thre_1_time_stamp <= curr_time;                              
                          pre_cnt <= 0;                              
                        end
                      default
                        begin
                          thre_cross_state <= NO_TRG;
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;
                        end  
                      endcase
                    end
                  ZONE_3:
                    begin
                      case (thre_cross_state)
                      CONFIRM_TRG:
                        begin
                          if ( out_cnt < max_out_cnt )
                            begin
                              out_cnt <= out_cnt + 1;
                            end
                          else
                            begin;
                              thre_cross_state <= TIMEOUT_TRG;
                              trg_end_flag <= 1'b1;
                              out_cnt <= 0;
                            end                                   
                        end
                      TIMEOUT_TRG:
                        begin
                          thre_cross_state <= NO_TRG;
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;                                
                        end
                      default
                        begin
                          err_code <= TRG_LOGIC_ERROR;
                          thre_cross_state <= NO_TRG;                              
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;                                    
                        end
                      endcase
                    end
                  endcase
                end
            end
          ZONE_3:
            begin
              if( thre_cross_state == CONFIRM_TRG )
                begin
                  if ( out_cnt < max_out_cnt )
                    begin
                      out_cnt <= out_cnt + 1;
                    end
                  else
                    begin
                      thre_cross_state <= TIMEOUT_TRG;
                      trg_end_flag <= 1'b0;
                      out_cnt <= 0;
                    end                          
                end
              else
                begin
                  case ( adc_val_state_delay )
                  ZONE_1:
                    begin
                      case ( thre_cross_state )
                      NO_TRG:
                        begin
                          err_code <= VAL_JUMP;
                          thre_cross_state <= CONFIRM_TRG;
                          thre_1_time_stamp <= curr_time;
                          noise_flag <= 1'b0;
                          pre_cnt <= 0;
                          out_cnt <= 0;
                        end
                      CANCEL_TRG:
                        begin
                          err_code <= VAL_JUMP;
                          thre_cross_state <= NO_TRG;                              
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;                                  
                        end
                      FINALIZE_TRG:  
                        begin
                          if ( pro_cnt >= max_pro_cnt )
                            begin
                              thre_cross_state <= NO_TRG;
                              trg_end_flag <= 1'b1;
                              pro_cnt <= 0;                                  
                            end
                          else
                            begin
                              // thre_cross_state_delay <= thre_cross_state;
                              // thre_cross_state_delay <= FINALIZE_TRG;
                              pro_cnt <= pro_cnt + 1;
                            end                                
                        end
                      default
                        begin
                          err_code <= TRG_LOGIC_ERROR;
                          thre_cross_state <= NO_TRG;                              
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;                                  
                        end
                      endcase
                    end
                  ZONE_2:
                    begin
                      case ( thre_cross_state )
                      POSSIBLE_TRG:
                        begin
                          thre_cross_state <= CONFIRM_TRG;
                          noise_flag <= 1'b0;
                          out_cnt <= 0;                                                                  
                        end
                      NO_TRG:
                        begin
                          err_code <= VAL_STAY;
                          thre_cross_state <= CONFIRM_TRG;
                          thre_1_time_stamp <= curr_time;
                          noise_flag <= 1'b0;
                          pre_cnt <= 0;
                          out_cnt <= 0;                                  
                        end
                      FINALIZE_TRG:  
                        begin
                          err_code <= TRG_LOGIC_ERROR;
                          thre_cross_state <= NO_TRG;                              
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;
                          pro_cnt <= 0;                                  
                        end
                      default
                        begin
                          thre_cross_state <= NO_TRG;                              
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;
                          pre_cnt <= 0;
                          out_cnt <= 0;
                        end  
                      endcase
                    end
                  ZONE_3:
                    begin
                      case (thre_cross_state)
                      TIMEOUT_TRG:
                        begin
                          thre_cross_state <= NO_TRG;
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;                                
                        end
                      NO_TRG:
                        begin
                          err_code <= VAL_JUMP;
                          thre_cross_state <= CONFIRM_TRG;
                          thre_1_time_stamp <= curr_time;
                          noise_flag <= 1'b0;
                          out_cnt <= 0;                                  
                        end
                      default
                        begin
                          err_code <= TRG_LOGIC_ERROR;
                          thre_cross_state <= NO_TRG;                              
                          noise_flag <= 1'b0;
                          trg_end_flag <= 1'b0;                                    
                        end
                      endcase
                    end
                  endcase
                end
            end
          endcase                              	          
	    end
	end
	
	// threshold cross check implementation
    always @(posedge s00_axis_aclk) 
	begin  
	  if (!s00_axis_aresetn) 
	    begin
          pre_cnt <= 0;
          out_cnt <= 0;
	      adc_val_state_delay <= adc_val_state;
	      adc_val_state <= ZONE_1;
	    end
	  else
	    begin
          if ( (|comp_result_thre_1) ^ (|comp_result_thre_2) )
            begin
              adc_val_state <= ZONE_2;
            end
              else if ( (|comp_result_thre_1) & (|comp_result_thre_2) )
                begin
                  adc_val_state <= ZONE_3;
                end
          else
            begin
              adc_val_state <= ZONE_1;
            end
	    end
	end
	
	
	genvar i;
	generate
	  for(i=0;i<SAMPLE_PER_TDATA;i=i+1)
	    begin
	      assign comp_result_thre_1[i] = ((s00_axis_tdata[16*(i+1)-1:16*i+REDUCE_DIGIT]-curr_bl) >= thre_1);
	      assign comp_result_thre_2[i] = ((s00_axis_tdata[16*(i+1)-1:16*i+REDUCE_DIGIT]-curr_bl) >= thre_2);
	    end
	endgenerate
	
	assign recv_tdata = s00_axis_tdata;

	// User logic ends

	endmodule
