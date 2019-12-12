`timescale 1 ps / 1 ps

module Trg_and_Adding_tb;

  // ------ definetion of parameters ------
  
  // --- for DUT ---
  // AXIS_ACLK frequency
  parameter CLK_FREQ = 250E6;
  // threshold ( percentage of max value = 2^12)
  parameter integer THRESHOLD = 80;
  // max pre acquasion width
  parameter integer MAX_DELAY_CNT_WIDTH = 7;
  // pre acquasion length setting
  parameter integer PRE_ACQUI_LEN = 12/2;
  // acquiasion length settings
  parameter integer POST_ACQUI_LEN = 38/2;
  // acquiasion length settings
  parameter integer ACQUI_LEN = 100/2;
  // TIME STAMP DATA WIDTH
  parameter integer TIME_STAMP_WIDTH = 48;
  // RFSoC ADC resolution
  parameter integer ADC_RESOLUTION_WIDTH = 12;
  // RF Data Converter data stream bus width
  parameter integer TDATA_WIDTH	= 256;

  // buffer width before add header/footer
  parameter integer BUFF_WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH*2 + (ADC_RESOLUTION_WIDTH+1) + ADC_RESOLUTION_WIDTH;

  // --- for function/task ---
  parameter signed ADC_MAX_VAL = 2**(ADC_RESOLUTION_WIDTH-1)-1;
  parameter signed ADC_MIN_VAL = -2**(ADC_RESOLUTION_WIDTH-1);
  parameter integer CLK_PERIOD = 1E12/CLK_FREQ;
  parameter RESET_TIME = 10;
  parameter PRE_SIG = 10;
  parameter POST_SIG = 10;
  parameter signed THRESHOLD_VAL = (ADC_MAX_VAL+BL)*THRESHOLD/100;
  parameter signed FST_HEIGHT = (ADC_MAX_VAL-ADC_MIN_VAL)*80/100 + BL;
  parameter signed SND_HEIGHT = (ADC_MAX_VAL-ADC_MIN_VAL)*10/100 + BL;
  parameter FST_WIDTH = 10;
  parameter SND_WIDTH = 20;
  parameter SIGNAL_INTERVAL = 100; 
  parameter signed BL_MIN = 10 + ADC_MIN_VAL;
  parameter signed BL_MAX = 12 + ADC_MIN_VAL;
  parameter signed BL = 11 + ADC_MIN_VAL;
  parameter integer SAMPLE_PER_TDATA = TDATA_WIDTH/16;
  integer i;
  integer k;
  
  // ------ reg/wire generation -------
  reg clk = 1'b0;
  reg resetn = 1'b0;
  reg all_module_ready = 1'b0;

  reg [MAX_DELAY_CNT_WIDTH-1:0] pre_acquiasion_len = PRE_ACQUI_LEN;
  reg [TIME_STAMP_WIDTH-1:0] current_time;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] base_line = BL;
  reg signed [ADC_RESOLUTION_WIDTH+1-1:0] threshold_val = THRESHOLD_VAL;
  
  reg [TDATA_WIDTH-1:0] tdata = 0;
  reg tvalid = 1'b0;

  wire [BUFF_WIDTH-1:0] mm_trg_dout;
  wire mm_trg_valid;
  wire triggered;
  wire [BUFF_WIDTH-1:0] fifo_din;
  wire [BUFF_WIDTH-1:0] fifo_dout;
  wire fifo_we;
  wire fifo_re;
  wire fifo_not_empty;
  wire fifo_full;
  reg fifo_rst_busy;

  reg signed [ADC_RESOLUTION_WIDTH-1:0] bl_min = BL_MIN;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] bl_max = BL_MAX;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] fst_height = FST_HEIGHT;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] snd_height = SND_HEIGHT;

  wire signed [ADC_RESOLUTION_WIDTH-1:0] tdata_word[SAMPLE_PER_TDATA-1:0];


  // ------ clock generation ------
  initial
  begin
      clk = 1'b0;
  end

  always #( CLK_PERIOD/2 )
  begin
    clk <= ~clk;
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
  MM_trg # (
    .MAX_DELAY_CNT_WIDTH(MAX_DELAY_CNT_WIDTH),
    .POST_ACQUI_LEN(POST_ACQUI_LEN),
    .HIT_DETECTION_WINDOW_WORD(8),
    .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
    .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
    .TDATA_WIDTH(TDATA_WIDTH)
  ) MM_Trg (
    .CLK(clk),
    .RESETN(resetn),
    .TDATA(tdata),
    .TVALID(tvalid),
    .ALL_MODULE_READY(all_module_ready),
    .PRE_ACQUIASION_LEN(pre_acquiasion_len),
    .THRESHOLD_VAL(threshold_val),
    .BASELINE(base_line),
    .CURRENT_TIME(current_time),
    .TRIGGERED(triggered),
    .DOUT(mm_trg_dout),
    .VALID(mm_trg_valid)
  );


add_header_footer # (
  .MAX_DELAY_CNT_WIDTH(MAX_DELAY_CNT_WIDTH),
  .MAX_FRAME_LENGTH(ACQUI_LEN), 
  .HEADER_FOOTER_WIDTH(64),
  .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
  .FIRST_TIME_STAMP_WIDTH(24),
  .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
  .CHANNEL_ID(0),
  .TDATA_WIDTH(TDATA_WIDTH)  
  // DIN WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH*2 + (ADC_RESOLUTION_WIDTH+1) + ADC_RESOLUTION_WIDTH
  // .DIN_WIDTH(DOUT_WIDTH + TIME_STAMP_WIDTH*2 + ADC_RESOLUTION_WIDTH*2 + 1),
) DUT (
  .CLK(clk),
  .RESETN(resetn),
  .PRE_ACQUIASION_LEN(pre_acquiasion_len), 
  .DIN_VALID(mm_trg_valid),
  .TRIGGERED(triggered),
  .DIN(mm_trg_dout),
  .FIFO_DIN(fifo_din),
  .FIFO_DOUT(fifo_dout),
  .FIFO_WE(fifo_we),
  .FIFO_RE(fifo_re),
  .FIFO_FULL(fifo_full),
  .FIFO_EMPTY(~fifo_not_empty),
  .FIFO_RST_BUSY(fifo_rst_busy),
  .VALID(),
  .DOUT()
);

  Fifo # (
    .WIDTH(BUFF_WIDTH),
    .DEPTH(10),
    .PROG_FULL_THRE(),
    .PROG_EMPTY_THRE(),
    .INIT_VALUE(8'hFF)
  ) buff_fifo (
    .CLK(clk),
    .RESETN(resetn),
    .DIN(fifo_din),
    .DOUT(fifo_dout),
    .WE(fifo_we),
    .RE(fifo_re),
    .NOT_EMPTY(fifo_not_empty),
    .FULL(fifo_full),
    .PROGRAMMABLE_FULL(),
    .PROGRAMMABLE_EMPTY()
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

  // ------ reset task ------
  task reset;
  begin
    #400 
    resetn <= 1'b0;
    tvalid <= 1'b0;
    all_module_ready <= 1'b0;
    fifo_rst_busy <= 1'b1;
    repeat(RESET_TIME) @(posedge clk);
    #400
    resetn <= 1'b1;
    repeat(5) @(posedge clk);
    gen_noise;
    tvalid <= 1'b1;
    fifo_rst_busy <= 1'b0;
    repeat(10) @(posedge clk);
    all_module_ready <= 1'b1;
    repeat(1) @(posedge clk);
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
      $dumpfile("Trg_and_Adding_tb.vcd");
      $dumpvars(0, Trg_and_Adding_tb);
      // for ( k=0 ; k<SAMPLE_PER_TDATA ; k=k+1 ) begin
      //   $dumpvars(1, MM_Trg_tb.DUT.delta_val[k]);
      // end

      reset;
      gen_signal_set;
      gen_noise;
      gen_signal_set;
      gen_noise;
      repeat(100) @(posedge clk);
      gen_signal;
      gen_noise;
      repeat(100) @(posedge clk);
      $finish;

  end

endmodule