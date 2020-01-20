`timescale 1 ps / 1 ps

module MinimumTrigger_tb;

  // ------ definetion of parameters ------
  
  // --- for DUT ---
  // clock frequency (Hz)
  parameter integer CLK_FREQ = 500E6;
  // hit detection window (8 word = 2nsec)
  parameter integer HIT_DETECTION_WINDOW_WORD = 8;
  // Trigger channel ID setting
  parameter integer CHANNEL_ID  = 0;
  // RFSoC ADC resolution
  parameter integer ADC_RESOLUTION_WIDTH = 12;
  // Triger threshold settigns
  parameter integer THRESHOLD = 80;
  /* data frame settings */
  // acquiasion length settings
  parameter integer MAX_FRAME_LENGTH = 100/2;
  // max pre-acquiasion length settings max pre acqui len will be 2**(MAX_DELAY_CNT_WIDTH-1)
  parameter integer MAX_DELAY_CNT_WIDTH = 4;
  // post-acquiasion length
  parameter integer POST_ACQUI_LEN = 76/2;
  // pre-acquiasion length
  parameter integer PRE_ACQUI_LEN = MAX_FRAME_LENGTH-POST_ACQUI_LEN;
  /* timestamp settings */
  // timer resolution freq (HZ)(must be < CLK_FREQ )
  parameter integer TIMER_RESO_FREQ = 100E6;
  // TIME STAMP DATA WIDTH
  parameter integer TIME_STAMP_WIDTH = 48;
  // TIMESTAMP WIDTH which on header
  parameter integer FIRST_TIME_STAMP_WIDTH = 32;
  // RF Data Converter data stream bus width
  parameter integer TDATA_WIDTH	= 128;
  parameter integer DOUT_WIDTH = 64;

  // --- for function/task ---
  parameter signed ADC_MAX_VAL = 2**(ADC_RESOLUTION_WIDTH-1)-1;
  parameter signed ADC_MIN_VAL = -2**(ADC_RESOLUTION_WIDTH-1);
  parameter integer CLK_PERIOD = 1E12/CLK_FREQ;
  parameter RESET_TIME = 10;
  parameter PRE_SIG = 30;
  parameter POST_SIG = 31;
  parameter FST_WIDTH = 50;
  parameter SND_WIDTH = 38;
  parameter SIGNAL_INTERVAL = 100; 
  parameter signed BL_MIN = 2047 + ADC_MIN_VAL;
  parameter signed BL_MAX = 2049 + ADC_MIN_VAL;
  parameter signed BL = 2048 + ADC_MIN_VAL;
  parameter integer SAMPLE_PER_TDATA = TDATA_WIDTH/16;
  // parameter signed THRESHOLD_VAL = (ADC_MAX_VAL+BL)*THRESHOLD/100;
  parameter integer THRESHOLD_VAL = 1024;  
  parameter signed FST_HEIGHT = (ADC_MAX_VAL-BL)*80/100;
  parameter signed SND_HEIGHT = (ADC_MAX_VAL-BL)*10/100;  
  integer i;
  integer k;
  
  // ------ reg/wire generation -------
  reg clk = 1'b0;
  reg rd_clk = 1'b0;
  reg rd_resetn = 1'b0;
  reg resetn = 1'b0;

  reg [MAX_DELAY_CNT_WIDTH-1:0] pre_acquiasion_len = PRE_ACQUI_LEN;
  reg [TIME_STAMP_WIDTH-1:0] current_time;
  reg  [ADC_RESOLUTION_WIDTH-1:0] base_line = BL;
  reg  [ADC_RESOLUTION_WIDTH+1-1:0] threshold_val = THRESHOLD_VAL;
  
  reg [TDATA_WIDTH-1:0] tdata = 0;
  reg tvalid = 1'b0;

  wire [DOUT_WIDTH-1:0] DUT_DOUT;
  wire DUT_S_AXIS_TREADY;
  wire DUT_oVALID;


  reg later_module_ready;

  reg signed [ADC_RESOLUTION_WIDTH-1:0] bl_min = BL_MIN;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] bl_max = BL_MAX;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] fst_height = FST_HEIGHT;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] snd_height = SND_HEIGHT;

  wire signed [ADC_RESOLUTION_WIDTH-1:0] tdata_word[SAMPLE_PER_TDATA-1:0];


  // ------ write clock generation ------
  initial
  begin
      clk = 1'b0;
  end

  always #( CLK_PERIOD/2 )
  begin
    clk <= ~clk;
  end

  // ------ read clock generation ------
  initial
  begin
      rd_clk = 1'b0;
  end

  always #( CLK_PERIOD )
  begin
    rd_clk <= ~rd_clk;
  end  

  // ------ time counter generation ------
  initial
  begin
    current_time = 0;
  end

  always #( CLK_PERIOD )
  begin
    current_time <= #400 current_time + 1;
  end

  // ------ DUTs ------
MinimumTrigger # (
  // clock frequency (Hz)
    .CLK_FREQ(CLK_FREQ),
  // hit detection window (8 word = 2nsec)
    .HIT_DETECTION_WINDOW_WORD(HIT_DETECTION_WINDOW_WORD),
  // Trigger channel ID setting
    .CHANNEL_ID (CHANNEL_ID),
  // RFSoC ADC resolution
    .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
  /* data frame settings */
  // acquiasion length settings
    .MAX_FRAME_LENGTH(MAX_FRAME_LENGTH),
  // max pre-acquiasion length settings max pre acqui len will be 2**(MAX_DELAY_CNT_WIDTH-1)
    .MAX_DELAY_CNT_WIDTH(MAX_DELAY_CNT_WIDTH),  
  // post-acquiasion length
    .POST_ACQUI_LEN(POST_ACQUI_LEN),
  /* timestamp settings */
  // TIME STAMP DATA WIDTH
    .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
  // TIMESTAMP WIDTH which on header
    .FIRST_TIME_STAMP_WIDTH(FIRST_TIME_STAMP_WIDTH),
  // RF Data Converter data stream bus width
    .TDATA_WIDTH(TDATA_WIDTH),
    .DOUT_WIDTH(DOUT_WIDTH)
) DUT (
  /* Ports of AXI-Stream Slave Interface  */ 
  .S_AXIS_ACLK(clk),
  .S_AXIS_ARESETN(resetn),
  .S_AXIS_TDATA(tdata),
  .S_AXIS_TVALID(tvalid),
  .S_AXIS_TREADY(DUT_S_AXIS_TREADY),
  /* read out clock domain */ 
  .RD_CLK(rd_clk),
  .RD_RESET(~rd_resetn),
  /* S_AXIS_ACLK clock domain */
  // pre acquiasion length
  .PRE_ACQUIASION_LEN(pre_acquiasion_len),
  // Threshold_value
  .THRESHOLD_VAL(threshold_val),
  // Baseline value
  .BASELINE(base_line),
  // current time
  .CURRENT_TIME(current_time),
  /* RD_CLK clock domain */
  .iREADY(later_module_ready),
  // recieved data
  .DOUT(DUT_DOUT),
  // recived data valid signal
  .oVALID(DUT_oVALID)
);

  // ------ noise part generation task -------
  task gen_noise;
    begin
      #400 
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        tdata[16*i +:16] <= {bl_min, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        tdata[16*i +:16] <= {bl_max, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      repeat(1) @(posedge clk);
    end
  endtask

  // ------- signal part generation task ------
  task gen_signal;
    begin
      #400 
      // first peak
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        tdata[16*i +:16] <= {fst_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        tdata[16*i +:16] <= {fst_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      repeat(FST_WIDTH) @(posedge clk);
      
      #400 
      // second peak
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        tdata[16*i +:16] <= {snd_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        tdata[16*i +:16] <= {snd_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      repeat(SND_WIDTH) @(posedge clk);
    end
  endtask
  
    // ------- signal part generation task ------
  task gen_signal2;
    begin
      #400 
      // first peak
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        tdata[16*i +:16] <= {fst_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        tdata[16*i +:16] <= {fst_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      repeat(SND_WIDTH) @(posedge clk);
      
      #400 
      // second peak
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        tdata[16*i +:16] <= {snd_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        tdata[16*i +:16] <= {snd_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      repeat(FST_WIDTH) @(posedge clk);
    end
  endtask

  // ------ data generation ------
  task gen_signal_set;
  begin
      gen_noise;
      repeat(PRE_SIG) @(posedge clk);
      gen_signal;
      gen_noise;
      gen_signal;
      repeat(POST_SIG) @(posedge clk);
  end
  endtask
  
  // ------ data generation ------
  task gen_signal_set2;
  begin
      gen_noise;
      repeat(PRE_SIG) @(posedge clk);
      gen_signal2;
      gen_noise;
      gen_signal2;
      repeat(POST_SIG) @(posedge clk);
  end
  endtask  

  // ------ write reset task ------
  task wr_reset;
  begin
    #400 
    resetn <= 1'b0;
    tvalid <= 1'b0;
    repeat(RESET_TIME*10) @(posedge clk);
    #400
    resetn <= 1'b1;
    repeat(5) @(posedge clk);
    #400
    gen_noise;
    tvalid <= 1'b1;
    repeat(10) @(posedge clk);
  end
  endtask

  // ------ later module ready task
  task rd_reset;
  begin
    #400 
    rd_resetn <= 1'b0;
    later_module_ready <= 1'b0;
    repeat(RESET_TIME) @(posedge rd_clk);
    #400
    rd_resetn <= 1'b1;
    repeat(2) @(posedge rd_clk);
    #400
    later_module_ready <= 1'b1;
    repeat(1) @(posedge rd_clk);
  end
  endtask

  // ----- both reset task -----
  task reset;
  begin
    fork
    begin
      wr_reset;
    end
    begin
      rd_reset;
    end
    join
  end
  endtask 

  genvar j;
  generate
      for ( j=0 ; j<SAMPLE_PER_TDATA ; j=j+1 )
      begin
          assign tdata_word[j] = tdata[16*(j+1)-1 -:ADC_RESOLUTION_WIDTH];
      end
  endgenerate

  // ------ testbench ------
  initial
  begin
    $dumpfile("MinimumTrigger_tb.vcd");
    $dumpvars(0, MinimumTrigger_tb);
    reset;
    gen_signal_set;
    gen_noise;
    later_module_ready <= 1'b0;
    gen_signal_set;
    later_module_ready <= 1'b1;
    gen_noise;
    repeat(100) @(posedge clk);
    gen_signal;
    gen_noise;
    later_module_ready <= 1'b0;
    repeat(1000) @(posedge clk);
    gen_signal;
    gen_noise;
    repeat(500) @(posedge clk);
    later_module_ready <= 1'b1;
    gen_signal;
    gen_noise;
    gen_signal;
    gen_noise;
    later_module_ready <= 1'b0;
    gen_signal;
    gen_noise;
    repeat(500) @(posedge clk);
    later_module_ready <= 1'b1;
    repeat(10) begin
      gen_signal;
      gen_signal2;
    end
    gen_noise;
    wait ((DUT.FirstDataFrameGen.DataFrameGen.frame_len_check_count==DUT.FirstDataFrameGen.DataFrameGen.frame_len-2)&(DUT.FirstDataFrameGen.DataFrameGen.INFO_FIFO_EMPTY==1'b1)) begin
      repeat(1) @(posedge rd_clk);
      #400
      force DUT.FirstDataFrameGen.InfoFifo.empty=1'b0;
      repeat(1) @(posedge rd_clk);
    end
//      release DUT.FirstDataFrameGen.InfoFifo.empty;
    repeat(10) begin
      gen_signal;
      gen_signal2;
    end
    $finish;

  end

endmodule