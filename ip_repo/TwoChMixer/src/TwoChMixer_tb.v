`timescale 1 ps / 1 ps

module TwoChMixer_tb;

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
  // header/fotter id widht
  parameter integer HEADER_FOOTER_ID_WIDTH = 8;
  

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
  reg ready = 1'b0;
   
  wire DUT_CH0_oREADY;
  wire DUT_CH1_oREADY;
  wire [WIDTH-1:0] DUT_DOUT;
  wire DUT_oVALID;

  reg [WIDTH-1:0] ch0_din;
  reg ch0_we;

  reg [WIDTH-1:0] ch1_din;
  reg ch1_we;

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
    ready <= 1'b0;
    resetn <= 1'b0;
    ch0_we <= 1'b0;
    ch1_we <= 1'b0;
    repeat(RESET_TIME) @(posedge clk);
    #400
    resetn <= 1'b1;
    repeat(5) @(posedge clk);
    #400
    ready <= 1'b1;
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

  // ------ interupt -------
  task interupt;
  begin
    ready <= 1'b0;
    repeat(200) @(posedge clk);
    ready <= 1'b1;
    repeat(1) @(posedge clk);
  end
  endtask

  
  // ------ module instaniation ------
  TwoChMixer # (
    .DATA_WIDTH(WIDTH)

  ) DUT (
    .CLK(clk),
    .RESET(~resetn),
  
    // handshake signals
    .CH0_DIN(ch0_din),
    .CH0_iVALID(ch0_we),
    .CH0_oREADY(DUT_CH0_oREADY),

    .CH1_DIN(ch1_din),
    .CH1_iVALID(ch1_we), 
    .CH1_oREADY(DUT_CH1_oREADY),

    .DOUT(DUT_DOUT),
    .oVALID(DUT_oVALID),
    .iREADY(ready)
  
  );  


  // ------ test bench ------
  initial
  begin
    $dumpfile("TwoChMixer_tb.vcd");
    $dumpvars(0, TwoChMixer_tb);
    reset;
    fork
    begin
      repeat(10) @(posedge clk);
      repeat(10) begin
        ch0_gen_dframe;
        // ch0_gen_header_lost_dframe;   
        ch0_gen_dframe;
        // ch0_gen_footer_lost_dframe;
        // ch0_gen_footer_lost_dframe;
        ch0_gen_dframe;
      end
      interupt;  
      repeat(10) begin
        ch0_gen_dframe;
        // ch0_gen_header_lost_dframe;   
        ch0_gen_dframe;
        repeat(100) @(posedge clk);
        // ch0_gen_footer_lost_dframe;
        // ch0_gen_footer_lost_dframe;
        ch0_gen_dframe;
      end
    end
    begin
      repeat(20) begin
        ch1_gen_dframe;
        ch1_gen_dframe;
        // ch1_gen_footer_lost_dframe;
        // ch1_gen_footer_lost_dframe;
        @(posedge clk);
        ch1_gen_dframe;
        // ch1_gen_header_lost_dframe;
        ch1_gen_dframe;
      end  
    end
    join

    repeat(1000) @(posedge clk);        
    
    $finish;
  end


endmodule