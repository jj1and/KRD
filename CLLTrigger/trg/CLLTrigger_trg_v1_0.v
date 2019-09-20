
`timescale 1 ns / 1 ps
`include "./cfg_updater.v"

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
                    CFG_UPDATE  = 2'b11; // In this state the threshold is being update
                
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
  // value is valid or not
	reg valid_trg = 1'b0;
  assign trg_state = { valid_trg, trg_end_flag, noise_flag };
	
  // when initialize has done, this value must be 1
	wire init_done;
	wire init_done_delay;
	// when initialization is completed, this value must be 1 
	// when cfg_update_flag is 1, this value must be 0 untill cfg update has done.
	wire cfg_update_done;
	// threshold 1 (nearly Baseline)
	wire [ADC_RESO_WIDTH-1-1:0] thre_1;
	// threshold 2 (value is larger than thre1)
	wire [ADC_RESO_WIDTH-1-1:0] thre_2;
	// thre_1 down cross to thre_2 down cross (unit is clock)
	wire [MAX_PRE_ACQUI_LENGTH_WIDTH-1:0] max_pre_cnt;
	// thre_2 up cross to trigger end (unit is clock)
	wire [MAX_PRO_ACQUI_LENGTH_WIDTH-1:0] max_pro_cnt;
	// thre_2 down cross to trigger end (unit is clock)
	wire [MAX_TIMEOUT_LENGTH_WIDTH-1:0] max_out_cnt;
	wire [ADC_RESO_WIDTH-1 : 0] init_curr_bl;
  
  cfg_updater #
  (
    .C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH(C_S_AXI_LITE_CFG_THRE_LEVEL_WIDTH),
    .THRE_1_LEVEL_WIDTH(THRE_1_LEVEL_WIDTH),
    .C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH(C_S_AXI_LITE_CFG_ACQUI_LENGTH_WIDTH),
    .MAX_PRO_ACQUI_LENGTH_WIDTH(MAX_PRO_ACQUI_LENGTH_WIDTH),
    .MAX_TIMEOUT_LENGTH_WIDTH(MAX_TIMEOUT_LENGTH_WIDTH),
    .TIME_COUNTER_WIDTH(TIME_COUNTER_WIDTH),
    .ADC_RESO_WIDTH(ADC_RESO_WIDTH),
    .INIT_BL_SCALE(INIT_BL_SCALE),
    .C_S00_AXIS_TDATA_WIDTH(C_S00_AXIS_TDATA_WIDTH)

  ) cfg_updater_inst ( 

	  .cfg_new_thre(cfg_new_thre),
		.cfg_new_len(cfg_new_len),
		.new_bl(new_bl),
		.cfg_update_flag(cfg_update_flag),
    .o_init_curr_bl(init_curr_bl),
    .o_thre_1(thre_1),
    .o_thre_2(thre_2),
    .o_max_pre_cnt(max_pre_cnt),
    .o_max_pro_cnt(max_pro_cnt),
    .o_max_out_cnt(max_out_cnt),
    .o_cfg_update_done(cfg_update_done),
    .o_init_done(init_done),
    .o_init_done_delay(init_done_delay),
    .s00_axis_aclk(s00_axis_aclk),
		.s00_axis_aresetn(s00_axis_aresetn),
		.s00_axis_tready(s00_axis_tready),
		.s00_axis_tdata(s00_axis_tdata),
		.s00_axis_tvalid(s00_axis_tvalid)
  );


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

	// User logic ends

	endmodule
