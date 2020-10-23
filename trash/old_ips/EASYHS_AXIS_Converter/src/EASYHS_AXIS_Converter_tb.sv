`timescale 1ps / 1ps



import axi4stream_vip_pkg::*;
import axi4stream_slv_vip_0_pkg::*;
//import axi4stream_cmd_slv_vip_pkg::*;

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/07 15:43:58
// Design Name: 
// Module Name: EASYHS_AXIS_Converter_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
///////////////////////////////////////////////////////////////////////////////// 

module EASYHS_AXIS_Converter_tb();

  // ------ definition of parameters ------
  
  // --- for DUT ---
  // CLK frequency
  parameter CLK_FREQ = 250E6;
  // threshold ( percentage of max value = 2^12)
  parameter integer THRESHOLD = 80;
  // TIME STAMP DATA WIDTH
  parameter integer TIME_STAMP_WIDTH = 48;
  // RFSoC ADC resolution
  parameter integer ADC_RESOLUTION_WIDTH = 12;
  // MM_trigger bus width
  parameter integer WIDTH	= 64;
  
//  // ADDR WIDTH
//  parameter integer ADDR_WIDTH =64;
//  //BASE ADDR
//  parameter integer BASE_ADDR = 0;
//  // LOG2BURST_BYTE_SIZE 
//  parameter integer LOG2BURST_BYTE_SIZE =12;
  

  // --- for function/task ---
  parameter signed ADC_MAX_VAL = 2**(ADC_RESOLUTION_WIDTH-1)-1;
  parameter signed ADC_MIN_VAL = -2**(ADC_RESOLUTION_WIDTH-1);
  parameter integer CLK_PERIOD = 1E12/CLK_FREQ;
  parameter RESET_TIME = 10;
  parameter PRE_SIG = 40;
  parameter POST_SIG = 40;
  parameter FST_WIDTH = 30;
  parameter SND_WIDTH = 50;
  parameter SIGNAL_INTERVAL = 100; 
  parameter signed BL = 0;  
  parameter signed BL_MIN = BL-1;
  parameter signed BL_MAX = BL+1;
  parameter signed THRESHOLD_VAL = (ADC_MAX_VAL-BL)*THRESHOLD/100;
  parameter signed FST_HEIGHT = (ADC_MAX_VAL-BL)*80/100 + BL;
  parameter signed SND_HEIGHT = (ADC_MAX_VAL-BL)*10/100 + BL;
  parameter integer SAMPLE_PER_TDATA = WIDTH/16;
  integer i;
  integer k;
  
  // ------ reg/wire generation -------
  reg clk = 1'b0;
  reg resetn = 1'b0;
   
  wire CH0_oREADY;
  wire CH1_oREADY;

  reg [WIDTH-1:0] ch0_din;
  reg ch0_we;

  reg [WIDTH-1:0] ch1_din;
  reg ch1_we;
  
  wire [WIDTH-1:0] TwoChMixer_DOUT;
  wire TwoChMixer_oVALID;
  
  wire DUT_oREADY;
  wire DUT_TVALID;
  wire [WIDTH-1:0] DUT_TDATA;
  
//  wire DUT_CMD_TVALID;
//  wire [ADDR_WIDTH+39:0] DUT_CMD_TDATA;  
  
  wire axi4stream_slv_vip_tready;
  wire axi4stream_slv_vip_tlast;
  
//  wire axi4stream_cmd_slv_vip_tready; 

  reg [TIME_STAMP_WIDTH-1:0] current_time;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] base_line = BL;
  reg signed [ADC_RESOLUTION_WIDTH+1-1:0] threshold_val = THRESHOLD_VAL;

  reg signed [ADC_RESOLUTION_WIDTH-1:0] bl_min = BL_MIN;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] bl_max = BL_MAX;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] ch0_fst_height = FST_HEIGHT;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] ch0_snd_height = SND_HEIGHT;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] ch1_fst_height = FST_HEIGHT-100;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] ch1_snd_height = SND_HEIGHT-50;
  reg [11:0] frame_len = PRE_SIG+FST_WIDTH+SND_WIDTH+POST_SIG;
  
  wire reset_active_high = ~resetn;

  // ------ clock generation ------
  initial begin
    clk = 1'b0;
  end

  always #( CLK_PERIOD/2 ) begin
      clk <= ~clk;
  end

  // ------ time counter ------
  initial
  begin
    current_time = 0;
  end

  always #( CLK_PERIOD )
  begin
    current_time <= current_time + 1;
  end

  // ------ reset task ------
  task reset;
  begin
    #400
    resetn <= 1'b0;
    ch0_we <= 1'b0;
    ch1_we <= 1'b0;
    repeat(RESET_TIME) @(posedge clk);
    #400
    resetn <= 1'b1;
    repeat(5) @(posedge clk);
    #400
    // wait for Asyncronus FIFO reset
    repeat(100) @(posedge clk);
  end
  endtask

    // ------ ch0 noise generation -------
  task ch0_gen_noise;
    begin
      #400
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch0_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{bl_min[ADC_RESOLUTION_WIDTH-1]}}, bl_min};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch0_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{bl_min[ADC_RESOLUTION_WIDTH-1]}}, bl_min};
      end
    end
  endtask

  // ------- ch0 signal generation ------
  task ch0_gen_signal;
    begin
      #400
      // first peak
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch0_din[16*i +:16] <= {{16-ADC_RESOLUTION_WIDTH{ch0_fst_height[ADC_RESOLUTION_WIDTH-1]}}, ch0_fst_height};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch0_din[16*i +:16] <= {{16-ADC_RESOLUTION_WIDTH{ch0_fst_height[ADC_RESOLUTION_WIDTH-1]}}, ch0_fst_height};
      end
      repeat(FST_WIDTH) @(posedge clk);
        
      #400
      // second peak
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch0_din[16*i +:16] <= {{16-ADC_RESOLUTION_WIDTH{ch0_snd_height[ADC_RESOLUTION_WIDTH-1]}}, ch0_snd_height};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch0_din[16*i +:16] <= {{16-ADC_RESOLUTION_WIDTH{ch0_snd_height[ADC_RESOLUTION_WIDTH-1]}}, ch0_snd_height};
      end
      repeat(SND_WIDTH) @(posedge clk);
    end
  endtask

  // ------ ch0 data frame generation ------
  task ch0_gen_dframe;
  begin
      #400
      ch0_din <= {16'hAAAA, 4'h0, current_time[31:0], frame_len};
      ch0_we <= 1'b1;
      repeat(1) @(posedge clk);
      ch0_gen_noise;
      repeat(PRE_SIG) @(posedge clk);
      ch0_gen_signal;
      ch0_gen_noise;
      repeat(POST_SIG) @(posedge clk);
      #400
      ch0_din <= { { {4{bl_min[ADC_RESOLUTION_WIDTH-1]} }, bl_min }, { {3{threshold_val[ADC_RESOLUTION_WIDTH]}}, threshold_val }, current_time[47:32], 16'h5555};
      repeat(1) @(posedge clk);
      #400
      ch0_we <= 1'b0;
      repeat(1) @(posedge clk);
  end
  endtask

  // ------ ch0 footer lost data frame generation ------
  task ch0_gen_footer_lost_dframe;
  begin
      #400
      ch0_din <= {16'hAAAA, 4'h0, current_time[31:0], frame_len};
      ch0_we <= 1'b1;
      repeat(1) @(posedge clk);
      ch0_gen_noise;
      repeat(PRE_SIG) @(posedge clk);
      ch0_gen_signal;
      ch0_gen_noise;
      repeat(POST_SIG) @(posedge clk);
      #400
      ch0_din <= { { {4{bl_min[ADC_RESOLUTION_WIDTH-1]} }, bl_min }, { {3{threshold_val[ADC_RESOLUTION_WIDTH]}}, threshold_val }, current_time[47:32], 16'h5678};
      repeat(1) @(posedge clk);
      #400
      ch0_we <= 1'b0;
      repeat(1) @(posedge clk);
  end
  endtask

  // ------ ch0 header lost data frame generation ------
  task ch0_gen_header_lost_dframe;
  begin
      #400
      ch0_din <= {16'hABCD, 4'h0, current_time[31:0], frame_len};
      ch0_we <= 1'b1;
      repeat(1) @(posedge clk);
      ch0_gen_noise;
      repeat(PRE_SIG) @(posedge clk);
      ch0_gen_signal;
      ch0_gen_noise;
      repeat(POST_SIG) @(posedge clk);
      #400
      ch0_din <= { { {4{bl_min[ADC_RESOLUTION_WIDTH-1]} }, bl_min }, { {3{threshold_val[ADC_RESOLUTION_WIDTH]}}, threshold_val }, current_time[47:32], 16'h5555};
      repeat(1) @(posedge clk);
      #400
      ch0_we <= 1'b0;
      repeat(1) @(posedge clk);
  end
  endtask    

    // ------ ch1 noise generation -------
  task ch1_gen_noise;
    begin
      #400
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch1_din[16*i +:16] <= {{16-ADC_RESOLUTION_WIDTH{bl_max[ADC_RESOLUTION_WIDTH-1]}}, bl_max};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch1_din[16*i +:16] <= {{16-ADC_RESOLUTION_WIDTH{bl_max[ADC_RESOLUTION_WIDTH-1]}}, bl_max};
      end
    end
  endtask

  // ------- ch1 signal generation ------
  task ch1_gen_signal;
    begin
      #400
      // first peak
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch1_din[16*i +:16] <= {{16-ADC_RESOLUTION_WIDTH{ch1_fst_height[ADC_RESOLUTION_WIDTH-1]}}, ch1_fst_height};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch1_din[16*i +:16] <= {{16-ADC_RESOLUTION_WIDTH{ch1_fst_height[ADC_RESOLUTION_WIDTH-1]}}, ch1_fst_height};
      end
      repeat(FST_WIDTH) @(posedge clk);
        
      #400 
      // second peak
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch1_din[16*i +:16] <= {{16-ADC_RESOLUTION_WIDTH{ch1_snd_height[ADC_RESOLUTION_WIDTH-1]}}, ch1_snd_height};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch1_din[16*i +:16] <= {{16-ADC_RESOLUTION_WIDTH{ch1_snd_height[ADC_RESOLUTION_WIDTH-1]}}, ch1_snd_height};
      end
      repeat(SND_WIDTH) @(posedge clk);
    end
  endtask

  // ------ ch1 data frame generation ------
  task ch1_gen_dframe;
  begin
      #400
      ch1_din <= {16'hAAAA, 4'h1, current_time[31:0], frame_len};
      ch1_we <= 1'b1;
      repeat(1) @(posedge clk);
      ch1_gen_noise;
      repeat(PRE_SIG) @(posedge clk);
      ch1_gen_signal;
      ch1_gen_noise;
      repeat(POST_SIG) @(posedge clk);
      #400
      ch1_din <= { { {4{bl_min[ADC_RESOLUTION_WIDTH-1]} }, bl_min }, { {3{threshold_val[ADC_RESOLUTION_WIDTH]}}, threshold_val }, current_time[47:32], 16'h5555};
      repeat(1) @(posedge clk);
      #400
      ch1_we <= 1'b0;
      repeat(1) @(posedge clk);
  end
  endtask

  // ------ ch1 footer lost data frame generation ------
  task ch1_gen_footer_lost_dframe;
  begin
      #400
      ch1_din <= {16'hAAAA, 4'h0, current_time[31:0], frame_len};
      ch1_we <= 1'b1;
      repeat(1) @(posedge clk);
      ch1_gen_noise;
      repeat(PRE_SIG) @(posedge clk);
      ch1_gen_signal;
      ch1_gen_noise;
      repeat(POST_SIG) @(posedge clk);
      #400
      ch1_din <= { { {4{bl_min[ADC_RESOLUTION_WIDTH-1]} }, bl_min }, { {3{threshold_val[ADC_RESOLUTION_WIDTH]}}, threshold_val }, current_time[47:32], 16'h5678};
      repeat(1) @(posedge clk);
      #400
      ch1_we <= 1'b0;
      repeat(1) @(posedge clk);
  end
  endtask

  // ------ ch1 header lost data frame generation ------
  task ch1_gen_header_lost_dframe;
  begin
      #400
      ch1_din <= {16'hABCD, 4'h0, current_time[31:0], frame_len};
      ch1_we <= 1'b1;
      repeat(1) @(posedge clk);
      ch1_gen_noise;
      repeat(PRE_SIG) @(posedge clk);
      ch1_gen_signal;
      ch1_gen_noise;
      repeat(POST_SIG) @(posedge clk);
      #400
      ch1_din <= { { {4{bl_min[ADC_RESOLUTION_WIDTH-1]} }, bl_min }, { {3{threshold_val[ADC_RESOLUTION_WIDTH]}}, threshold_val }, current_time[47:32], 16'h5555};
      repeat(1) @(posedge clk);
      #400
      ch1_we <= 1'b0;
      repeat(1) @(posedge clk);
  end
  endtask  


//  // ------ interupt -------
//  task interupt;
//  begin
//    ready <= 1'b0;
//    repeat(200) @(posedge clk);
//    ready <= 1'b1;
//    repeat(1) @(posedge clk);
//  end
//  endtask
  
  // ------ module instaniation ------
  
  TwoChMixer_0 TwoChMixer (
  .CLK(clk),                // input wire CLK
  .RESET(!resetn),            // input wire RESET
  .CH0_DIN(ch0_din),        // input wire [63 : 0] CH0_DIN
  .CH0_iVALID(ch0_we),  // input wire CH0_iVALID
  .CH0_oREADY(CH0_oREADY),  // output wire CH0_oREADY
  .CH1_DIN(ch1_din),        // input wire [63 : 0] CH1_DIN
  .CH1_iVALID(ch1_we),  // input wire CH1_iVALID
  .CH1_oREADY(CH1_oREADY),  // output wire CH1_oREADY
  .DOUT(TwoChMixer_DOUT),              // output wire [63 : 0] DOUT
  .oVALID(TwoChMixer_oVALID),          // output wire oVALID
  .iREADY(DUT_oREADY)          // input wire iREADY
);

  EASYHS_AXIS_converter # (
    .DATA_WIDTH(WIDTH)
//    .ADDR_WIDTH(ADDR_WIDTH),
//    .LOG2BURST_BYTE_SIZE(LOG2BURST_BYTE_SIZE),
//    .BASE_ADDR(BASE_ADDR)    
  ) DUT (
    .CLK(clk),
    .RESET(reset_active_high),

    // EASYHS bus signals
    .DIN(TwoChMixer_DOUT),
    .iVALID(TwoChMixer_oVALID),
    .oREADY(DUT_oREADY),
  
    // AXIS bus signals
    .TDATA(DUT_TDATA),
    .TVALID(DUT_TVALID),
    .TREADY(axi4stream_slv_vip_tready),
    .TLAST(axi4stream_slv_vip_tlast)
    
  // AXIS CMD signals (for AXI Data Mover)
//    .CMD_TDATA(DUT_CMD_TDATA),
//    .CMD_TVALID(DUT_CMD_TVALID),
//    .CMD_TREADY(axi4stream_cmd_slv_vip_tready)
  );    
  
  axi4stream_slv_vip_0 axi4stream_slv_vip (
    .aclk(clk),                    // input wire aclk
    .aresetn(resetn),              // input wire aresetn
    .s_axis_tvalid(DUT_TVALID),  // input wire [0 : 0] s_axis_tvalid
    .s_axis_tready(axi4stream_slv_vip_tready),  // output wire [0 : 0] s_axis_tready
    .s_axis_tdata(DUT_TDATA),    // input wire [63 : 0] s_axis_tdata
    .s_axis_tlast(axi4stream_slv_vip_tlast)    // input wire [0 : 0] s_axis_tlast
  );
  
//axi4stream_cmd_slv_vip axi4stream_cmd_slv_vip (
//  .aclk(clk),                    // input wire aclk
//  .aresetn(resetn),              // input wire aresetn
//  .s_axis_tvalid(DUT_CMD_TVALID),  // input wire [0 : 0] s_axis_tvalid
//  .s_axis_tready(axi4stream_cmd_slv_vip_tready),  // output wire [0 : 0] s_axis_tready
//  .s_axis_tdata(DUT_CMD_TDATA)    // input wire [103 : 0] s_axis_tdata
//);  
  
  // Slave VIP agent verbosity level
  xil_axi4stream_uint                           slv_agent_verbosity = 0;  
  
  // transaction data
  xil_axi4stream_data_byte ext_data[7:0];

  // Monitor transaction for slave VIP
  axi4stream_monitor_transaction                 slv_monitor_transaction;
  // Monitor transaction queue for slave VIP
  axi4stream_monitor_transaction                 slave_moniter_transaction_queue[$];
  // Size of slave_moniter_transaction_queue
  xil_axi4stream_uint                            slave_moniter_transaction_queue_size =0;
  // Scoreboard transaction from slave monitor transaction queue
  axi4stream_monitor_transaction                 slv_scb_transaction;

  // slave agent 
  axi4stream_slv_vip_0_slv_t slv_agent;
//  axi4stream_cmd_slv_vip_slv_t cmd_slv_agent;
 
  /*****************************************************************************************************************
  * Task slv_gen_tready shows how slave VIP agent generates one customerized tready signal. 
  * Declare axi4stream_ready_gen  ready_gen
  * Call create_ready from agent's driver to create a new class of axi4stream_ready_gen 
  * Set the poicy of ready generation in this example, it select XIL_AXI4STREAM_READY_GEN_OSC 
  * Set low time 
  * Set high time
  * Agent's driver send_tready out
  * Ready generation policy are listed below:
  *  XIL_AXI4STREAM_READY_GEN_NO_BACKPRESSURE     - Ready stays asserted and will not change. The driver
                                                 will still check for policy changes.
  *   XIL_AXI4STREAM_READY_GEN_SINGLE             - Ready stays low for low_time,goes high and stay high till one 
  *                                         ready/valid handshake occurs, it then goes to low repeats this pattern. 
  *   XIL_AXI4STREAM_READY_GEN_EVENTS             - Ready stays low for low_time,goes high and stay high till one
  *                                          a certain amount of ready/valid handshake occurs, it then goes to 
  *                                          low and repeats this pattern.  
  *   XIL_AXI4STREAM_READY_GEN_OSC                - Ready stays low for low_time and then goes to high and stays 
  *                                          high for high_time, it then goes to low and repeat the same pattern
  *   XIL_AXI4STREAM_READY_GEN_RANDOM             - Ready generates randomly 
  *   XIL_AXI4STREAM_READY_GEN_AFTER_VALID_SINGLE - Ready stays low, once valid goes high, ready stays low for
  *                                          low_time, then it goes high and stay high till one ready/valid handshake 
  *                                          occurs. it then goes low and repeate the same pattern.
  *   XIL_AXI4STREAM_READY_GEN_AFTER_VALID_EVENTS - Ready stays low, once valid goes high, ready stays low for low_time,
  *                                          then it goes high and stay high till some amount of ready/valid handshake
  *                                          event occurs. it then goes low and repeate the same pattern.
  *   XIL_AXI4STREAM_READY_GEN_AFTER_VALID_OSC    - Ready stays low, once valid goes high, ready stays low for low_time, 
  *                                          then it goes high and stay high for high_time. it then goes low 
  *                                          and repeate the same pattern.
  *****************************************************************************************************************/
  task slv_gen_tready();
    axi4stream_ready_gen                           ready_gen;
    ready_gen = slv_agent.driver.create_ready("ready_gen");
    ready_gen.set_ready_policy(XIL_AXI4STREAM_READY_GEN_OSC);
    ready_gen.set_low_time(2);
    ready_gen.set_high_time(6);
    slv_agent.driver.send_tready(ready_gen);
  endtask :slv_gen_tready
  
//  task cmd_slv_gen_tready();
//    axi4stream_ready_gen                           cmd_ready_gen;
//    cmd_ready_gen = cmd_slv_agent.driver.create_ready("ready_gen");
//    cmd_ready_gen.set_ready_policy(XIL_AXI4STREAM_READY_GEN_OSC);
//    cmd_ready_gen.set_low_time(2);
//    cmd_ready_gen.set_high_time(6);
//    cmd_slv_agent.driver.send_tready(cmd_ready_gen);
//  endtask :cmd_slv_gen_tready  

  // ------ test bench ------
  initial
  begin
    $dumpfile("EASYHS_AXIS_Converter_tb.vcd");
    $dumpvars(0, EASYHS_AXIS_Converter_tb);

    slv_agent = new("slave vip agent", axi4stream_slv_vip.inst.IF);
    slv_agent.start_slave();
    slv_agent.vif_proxy.set_dummy_drive_type(XIL_AXI4STREAM_VIF_DRIVE_NONE);
    slv_agent.set_agent_tag("Slave VIP");
    slv_agent.set_verbosity(slv_agent_verbosity);
    
//    cmd_slv_agent = new("cmd slave vip agent", axi4stream_cmd_slv_vip.inst.IF);
//    cmd_slv_agent.start_slave();
//    cmd_slv_agent.vif_proxy.set_dummy_drive_type(XIL_AXI4STREAM_VIF_DRIVE_NONE);
//    cmd_slv_agent.set_agent_tag("CMD Slave VIP");
//    cmd_slv_agent.set_verbosity(slv_agent_verbosity);    
    
    reset;
    fork
    begin
      repeat(10) @(posedge clk);
      repeat(10) begin
        ch0_gen_dframe;
         ch0_gen_header_lost_dframe;   
        ch0_gen_dframe;
         ch0_gen_footer_lost_dframe;
         ch0_gen_footer_lost_dframe;
        ch0_gen_dframe;
      end
      repeat(10) begin
        ch0_gen_dframe;
        ch0_gen_header_lost_dframe;   
        ch0_gen_dframe;
        repeat(100) @(posedge clk);
         ch0_gen_footer_lost_dframe;
         ch0_gen_footer_lost_dframe;
        ch0_gen_dframe;
      end
    end
    begin
      repeat(20) begin
        ch1_gen_dframe;
        ch1_gen_dframe;
         ch1_gen_footer_lost_dframe;
         ch1_gen_footer_lost_dframe;
        @(posedge clk);
        ch1_gen_dframe;
         ch1_gen_header_lost_dframe;
        ch1_gen_dframe;
      end  
    end
    begin
      slv_gen_tready();
//      cmd_slv_gen_tready();
    end
    join

    repeat(1000) @(posedge clk);        
    slv_agent.stop_slave();
//    cmd_slv_agent.stop_slave();    
    $finish;
  end
  
 /***************************************************************************************************
  * Get monitor transaction from slave VIP monitor analysis port
  * Put the transactin into slave monitor transaction queue 
  ***************************************************************************************************/
  initial begin
    forever begin
      slv_agent.monitor.item_collected_port.get(slv_monitor_transaction);
      slave_moniter_transaction_queue.push_back(slv_monitor_transaction);
      slave_moniter_transaction_queue_size++;
    end
  end
  
  /***************************************************************************************************
  * Simple scoreboard doing self checking 
  * Comparing transaction from passthrough VIP in master side with transaction from Slave VIP 
  * if they are match, SUCCESS. else, ERROR
  ***************************************************************************************************/
  xil_axi4stream_uint ext_data_cnt = 0;

  reg [15:0] HEADER_ID = 16'hAAAA;
  reg [15:0] FOOTER_ID = 16'h5555;
  reg [15:0] ERROR_HEADER_ID = 16'hAAEE;
  reg [15:0] ERROR_FOOTER_ID = 16'h55EE;  
  
  initial begin
    forever begin
      wait (slave_moniter_transaction_queue_size>0 ) begin
        slv_scb_transaction = slave_moniter_transaction_queue.pop_front;
        slv_scb_transaction.get_data(ext_data);
        slave_moniter_transaction_queue_size--;
        if (({ext_data[0], ext_data[1]}==HEADER_ID)|({ext_data[0], ext_data[1]}==ERROR_HEADER_ID)) begin
          ext_data_cnt = 1;
        end else begin
          ext_data_cnt++;
        end
      end
    end
  end

endmodule
