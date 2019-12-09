`timescale 1 ps / 1 ps

module MM_trigger_total_tb;

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

  // variable delay fifo depth
  parameter integer VDELAY_FIFO_DEPTH = 2**MAX_DELAY_CNT_WIDTH-1;

  // buffer width before add header/footer
  parameter integer BUFF_WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH*2 + (ADC_RESOLUTION_WIDTH+1) + ADC_RESOLUTION_WIDTH;
  // add header footer fifo depth
  parameter integer BUFF_FIFO_DEPTH = 10;

  // 10G-BASE Ether bit width
  parameter integer ETHER_BIT_WIDTH = 64;
  // bit width reducer fifo depth
  parameter integer REDUCE_FIFO_DEPTH = 100*(TDATA_WIDTH/ETHER_BIT_WIDTH) + 3;

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
  wire all_module_ready = &{delay_ready, add_ready, conv_ready, later_module_ready};

  reg [MAX_DELAY_CNT_WIDTH-1:0] pre_acquiasion_len = PRE_ACQUI_LEN;
  reg [TIME_STAMP_WIDTH-1:0] current_time;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] base_line = BL;
  reg signed [ADC_RESOLUTION_WIDTH+1-1:0] threshold_val = THRESHOLD_VAL;
  
  reg [TDATA_WIDTH-1:0] tdata = 0;
  reg tvalid = 1'b0;

  wire [BUFF_WIDTH-1:0] mm_trg_dout;
  wire mm_trg_valid;
  wire triggered;

  wire [BUFF_WIDTH-1:0] delay_dout;
  wire delay_valid;
  wire [BUFF_WIDTH-1:0] delay_fifo_din;
  wire [BUFF_WIDTH-1:0] delay_fifo_dout;
  wire delay_fifo_we;
  wire delay_fifo_re;
  wire delay_fifo_not_empty;
  wire delay_fifo_full; 
  wire delay_ready;
  reg delay_fifo_rst_busy;

  wire [TDATA_WIDTH-1:0] add_dout;
  wire add_valid;
  wire [BUFF_WIDTH-1:0] add_fifo_din;
  wire [BUFF_WIDTH-1:0] add_fifo_dout;
  wire add_fifo_we;
  wire add_fifo_re;
  wire add_fifo_not_empty;
  wire add_fifo_full;
  reg add_fifo_rst_busy;
  wire add_ready;

  wire [ETHER_BIT_WIDTH-1:0] bit_redu_dout;
  wire bit_redu_valid;
  wire [TDATA_WIDTH-1:0] bit_redu_fifo_din;
  wire [TDATA_WIDTH-1:0] bit_redu_fifo_dout;
  wire bit_redu_fifo_we;
  wire bit_redu_fifo_re;
  wire bit_redu_fifo_not_empty;
  wire bit_redu_fifo_full;
  reg redu_fifo_wr_rst_busy;
  reg redu_fifo_rd_rst_busy;
  wire conv_ready;

  wire [ETHER_BIT_WIDTH-1:0] trim_dout;
  wire trim_valid;

  reg later_module_ready;

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

  Variable_delay_mod # (
    .MAX_DELAY_CNT_WIDTH(MAX_DELAY_CNT_WIDTH),
    .WIDTH(BUFF_WIDTH)
  ) variable_delay (
    .CLK(clk),
    .RESETN(resetn),
    .DELAY(pre_acquiasion_len),
    .DIN(mm_trg_dout),
    .DOUT(delay_dout),
    .FIFO_DIN(delay_fifo_din),
    .FIFO_WE(delay_fifo_we),
    .FIFO_RE(delay_fifo_re),
    .FIFO_DOUT(delay_fifo_dout),
    .FIFO_EMPTY(~delay_fifo_not_empty),
    .FIFO_FULL(delay_fifo_full),
    .FIFO_RST_BUSY(delay_fifo_rst_busy),
    .DELAY_READY(delay_ready),
    .DELAY_VALID(delay_valid)
  );

    Fifo # (
    .WIDTH(BUFF_WIDTH),
    .DEPTH(VDELAY_FIFO_DEPTH),
    .PROG_FULL_THRE(),
    .PROG_EMPTY_THRE(),
    .INIT_VALUE({BUFF_WIDTH{1'b1}})
  ) delay_fifo (
    .CLK(clk),
    .RESETN(resetn),
    .DIN(delay_fifo_din),
    .DOUT(delay_fifo_dout),
    .WE(delay_fifo_we),
    .RE(delay_fifo_re),
    .NOT_EMPTY(delay_fifo_not_empty),
    .FULL(delay_fifo_full),
    .PROGRAMMABLE_FULL(),
    .PROGRAMMABLE_EMPTY()
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
  ) add_header_footer (
    .CLK(clk),
    .RESETN(resetn),
    .PRE_ACQUIASION_LEN(pre_acquiasion_len), 
    .DIN_VALID(delay_valid),
    .TRIGGERED(triggered),
    .DIN(delay_dout),
    .FIFO_DIN(add_fifo_din),
    .FIFO_DOUT(add_fifo_dout),
    .FIFO_WE(add_fifo_we),
    .FIFO_RE(add_fifo_re),
    .FIFO_FULL(add_fifo_full),
    .FIFO_EMPTY(~add_fifo_not_empty),
    .FIFO_RST_BUSY(add_fifo_rst_busy),
    .VALID(add_valid),
    .ADD_READY(add_ready),
    .DOUT(add_dout)
  );

  Fifo # (
    .WIDTH(BUFF_WIDTH),
    .DEPTH(BUFF_FIFO_DEPTH),
    .PROG_FULL_THRE(),
    .PROG_EMPTY_THRE(),
    .INIT_VALUE({BUFF_WIDTH{1'b1}})
  ) buff_fifo (
    .CLK(clk),
    .RESETN(resetn),
    .DIN(add_fifo_din),
    .DOUT(add_fifo_dout),
    .WE(add_fifo_we),
    .RE(add_fifo_re),
    .NOT_EMPTY(add_fifo_not_empty),
    .FULL(add_fifo_full),
    .PROGRAMMABLE_FULL(),
    .PROGRAMMABLE_EMPTY()
  );

  async_bit_width_reducer_mod # (
  .DIN_WIDTH(TDATA_WIDTH),
  .DOUT_WIDTH(ETHER_BIT_WIDTH)
  ) bit_reducer (
    .WR_CLK(clk),
    .WR_RESETN(resetn),
    .RD_CLK(clk),
    .RD_RESETN(resetn),
    .DIN(add_dout),
    .DIN_VALID(add_valid),
    .DOUT(bit_redu_dout),
    .FIFO_DIN(bit_redu_fifo_din),
    .FIFO_WE(bit_redu_fifo_we),
    .FIFO_DOUT(bit_redu_fifo_dout),
    .FIFO_RE(bit_redu_fifo_re),
    .FIFO_EMPTY(~bit_redu_fifo_not_empty),
    .FIFO_FULL(bit_redu_fifo_full),
    .FIFO_WR_RST_BUSY(redu_fifo_wr_rst_busy),
    .FIFO_RD_RST_BUSY(redu_fifo_rd_rst_busy),
    .MODULE_READY(later_module_ready),
    .CONVERT_READY(conv_ready),
    .CONVERT_VALID(bit_redu_valid)
  );

  Fifo # (
    .WIDTH(TDATA_WIDTH),
    .DEPTH(REDUCE_FIFO_DEPTH),
    .PROG_FULL_THRE(),
    .PROG_EMPTY_THRE(),
    .INIT_VALUE({TDATA_WIDTH{1'b1}})
  ) reduce_fifo (
    .CLK(clk),
    .RESETN(resetn),
    .DIN(bit_redu_fifo_din),
    .DOUT(bit_redu_fifo_dout),
    .WE(bit_redu_fifo_we),
    .RE(bit_redu_fifo_re),
    .NOT_EMPTY(bit_redu_fifo_not_empty),
    .FULL(bit_redu_fifo_full),
    .PROGRAMMABLE_FULL(),
    .PROGRAMMABLE_EMPTY()
  );

  data_trimmer # (
    .DATA_WIDTH(ETHER_BIT_WIDTH)
  ) trimmer (
    .CLK(clk),
    .RESETN(resetn),
    .DIN(bit_redu_dout),
    .DIN_VALID(bit_redu_valid),
    .DOUT(),
    .TRIMMER_VALID()
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
    delay_fifo_rst_busy <= 1'b1;
    add_fifo_rst_busy <= 1'b1;
    redu_fifo_wr_rst_busy <= 1'b1;
    redu_fifo_rd_rst_busy <= 1'b1;
    later_module_ready <= 1'b0;
    repeat(RESET_TIME) @(posedge clk);
    #400
    resetn <= 1'b1;
    repeat(5) @(posedge clk);
    #400
    add_fifo_rst_busy <= 1'b0;
    repeat(5) @(posedge clk);
    #400
    redu_fifo_wr_rst_busy <= 1'b0;
    redu_fifo_rd_rst_busy <= 1'b0;  
    repeat(5) @(posedge clk);
    #400
    delay_fifo_rst_busy <= 1'b0;
    repeat(5) @(posedge clk);
    #400
    later_module_ready <= 1'b1;
    repeat(5) @(posedge clk);  
    gen_noise;
    tvalid <= 1'b1;
    repeat(10) @(posedge clk);
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
      $dumpfile("MM_trigger_total_tb.vcd");
      $dumpvars(0, MM_trigger_total_tb);
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
      repeat(1000) @(posedge clk);
      $finish;

  end

endmodule