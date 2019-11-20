`timescale 1 ps / 1 ps

module dual_ch_mixer_tb;

  // ------ definition of parameters ------
  
  // --- for DUT ---
  // CLK frequency
  parameter CLK_FREQ = 500E6;
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
  // FIFO depth
  parameter integer DEPTH = 512;
  // programmable full 
  parameter integer PROG_FULL = 200;
  parameter integer PROG_EMPTY = 60; 
  

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
  parameter integer SAMPLE_PER_TDATA = WIDTH/16;
  integer i;
  integer k;
  
  // ------ reg/wire generation -------
  reg clk = 1'b0;
  reg resetn = 1'b0;
  reg ready = 1'b0;
  reg [WIDTH-1:0] ch0_din;
  wire [WIDTH-1:0] ch0_dout;
  reg ch0_we;
  wire ch0_re;
  wire ch0_full;
  wire ch0_not_empty;
  wire ch0_prog_full;
  wire ch0_prog_empty;
  wire ch0_read_request;

  reg [WIDTH-1:0] ch1_din;
  wire [WIDTH-1:0] ch1_dout;
  reg ch1_we;
  wire ch1_re;
  wire ch1_full;
  wire ch1_not_empty;
  wire ch1_prog_full;
  wire ch1_prog_empty;
  wire ch1_read_request;

  wire [WIDTH-1:0] dout;
  reg [TIME_STAMP_WIDTH-1:0] current_time;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] base_line = BL;
  reg signed [ADC_RESOLUTION_WIDTH+1-1:0] threshold_val = THRESHOLD_VAL;

  reg signed [ADC_RESOLUTION_WIDTH-1:0] bl_min = BL_MIN;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] bl_max = BL_MAX;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] ch0_fst_height = FST_HEIGHT;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] ch0_snd_height = SND_HEIGHT;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] ch1_fst_height = FST_HEIGHT-100;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] ch1_snd_height = SND_HEIGHT-50;

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
    ready <= #400 1'b0;
    resetn <= #400 1'b0;
    ch0_we <= #400 1'b0;
    ch1_we <= #400 1'b0;
    repeat(RESET_TIME) @(posedge clk);
    resetn <= #400 1'b1;
    repeat(5) @(posedge clk);
    ready <= #400 1'b1;
    repeat(1) @(posedge clk);
  end
  endtask

    // ------ ch0 noise generation -------
  task ch0_gen_noise;
    begin
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch0_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{1'b0}}, bl_min};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch0_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{1'b0}}, bl_min};
      end
    end
  endtask

  // ------- ch0 signal generation ------
  task ch0_gen_signal;
    begin
      // first peak
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch0_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{1'b0}}, ch0_fst_height};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch0_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{1'b0}}, ch0_fst_height};
      end
      repeat(FST_WIDTH) @(posedge clk);
        
      // second peak
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch0_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{1'b0}}, ch0_snd_height};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch0_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{1'b0}}, ch0_snd_height};
      end
      repeat(SND_WIDTH) @(posedge clk);
    end
  endtask

  // ------ ch0 data frame generation ------
  task ch0_gen_dframe;
  begin
      ch0_din <= #400 {8'hFF, 4'h0, current_time[47:24], {WIDTH-36{1'b0}}};
      ch0_we <= #400 1'b1;
      repeat(1) @(posedge clk);
      ch0_gen_noise;
      repeat(PRE_SIG) @(posedge clk);
      ch0_gen_signal;
      ch0_gen_noise;
      repeat(POST_SIG) @(posedge clk);
      ch0_din <= #400 {4'hF, bl_min, 4'hF, threshold_val, current_time[23:0], 8'h0F};
      repeat(1) @(posedge clk);
      ch0_we <= #400 1'b0;
      repeat(1) @(posedge clk);
  end
  endtask

    // ------ ch1 noise generation -------
  task ch1_gen_noise;
    begin
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch1_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{1'b0}}, bl_max};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch1_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{1'b0}}, bl_max};
      end
    end
  endtask

  // ------- ch1 signal generation ------
  task ch1_gen_signal;
    begin
      // first peak
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch1_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{1'b0}}, ch1_fst_height};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch1_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{1'b0}}, ch1_fst_height};
      end
      repeat(FST_WIDTH) @(posedge clk);
        
      // second peak
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch1_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{1'b0}}, ch1_snd_height};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        ch1_din[16*i +:16] <= #400 {{16-ADC_RESOLUTION_WIDTH{1'b0}}, ch1_snd_height};
      end
      repeat(SND_WIDTH) @(posedge clk);
    end
  endtask

  // ------ ch1 data frame generation ------
  task ch1_gen_dframe;
  begin
      ch1_din <= #400 {8'hFF, 4'h1, current_time[47:24], {WIDTH-36{1'b0}}};
      ch1_we <= #400 1'b1;
      repeat(1) @(posedge clk);
      ch1_gen_noise;
      repeat(PRE_SIG) @(posedge clk);
      ch1_gen_signal;
      ch1_gen_noise;
      repeat(POST_SIG) @(posedge clk);
      ch1_din <= #400 {4'hF, bl_max, 4'hF, threshold_val, current_time[23:0], 8'h0F};
      repeat(1) @(posedge clk);
      ch1_we <= #400 1'b0;
      repeat(1) @(posedge clk);
  end
  endtask

  // ------ interupt -------
  task interupt;
  begin
    ready <= 1'b0;
    repeat(10) @(posedge clk);
    ready <= 1'b1;
    repeat(1) @(posedge clk);
  end
  endtask

  
  // ------ module instaniation ------
  Fifo # (
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .PROG_FULL_THRE(PROG_FULL),
    .PROG_EMPTY_THRE(PROG_EMPTY),
    .INIT_VALUE({{HEADER_FOOTER_ID_WIDTH{1'b0}}, {WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}})
  ) CH0 (
    .CLK(clk),
    .RESETN(resetn),
    .DIN(ch0_din),
    .DOUT(ch0_dout),
    .WE(ch0_we),
    .RE(ch0_re),
    .NOT_EMPTY(ch0_not_empty),
    .FULL(ch0_full),
    .PROGRAMMABLE_FULL(ch0_prog_full),
    .PROGRAMMABLE_EMPTY(ch0_prog_empty)
  );

  Fifo # (
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .PROG_FULL_THRE(PROG_FULL),
    .PROG_EMPTY_THRE(PROG_EMPTY),
    .INIT_VALUE({{HEADER_FOOTER_ID_WIDTH{1'b0}}, {WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}})
  ) CH1 (
    .CLK(clk),
    .RESETN(resetn),
    .DIN(ch1_din),
    .DOUT(ch1_dout),
    .WE(ch1_we),
    .RE(ch1_re),
    .NOT_EMPTY(ch1_not_empty),
    .FULL(ch1_full),
    .PROGRAMMABLE_FULL(ch1_prog_full),
    .PROGRAMMABLE_EMPTY(ch1_prog_empty)
  );

  read_requester CH0_READ_REQ (
    .CLK(clk),
    .RESETN(resetn),
    .PROGRAMMABLE_FULL(ch0_prog_full),
    .PROGRAMMABLE_EMPTY(ch0_prog_empty),
    .READ_REQUEST(ch0_read_request)
  );

  read_requester CH1_READ_REQ (
    .CLK(clk),
    .RESETN(resetn),
    .PROGRAMMABLE_FULL(ch1_prog_full),
    .PROGRAMMABLE_EMPTY(ch1_prog_empty),
    .READ_REQUEST(ch1_read_request)
  );

  dual_ch_mixer # (
    .DATA_WIDTH(WIDTH)
  ) DUT (
    .CLK(clk),
    .RESETN(resetn),

    // channel 0 interface
    .CH0_DIN(ch0_dout),
    .CH0_READ_REQUEST(ch0_read_request),
    .CH0_RE(ch0_re),

    // channel 1 interface
    .CH1_DIN(ch1_dout),
    .CH1_READ_REQUEST(ch1_read_request),
    .CH1_RE(ch1_re),
    
    // Interface of FIFO for serialized data
    .READY(ready),
    .DOUT(dout),
    .SENDING()
  );

  // ------ test bench ------
  initial
  begin
    $dumpfile("dual_ch_mixer_tb.vcd");
    $dumpvars(0, dual_ch_mixer_tb);
    reset;
    fork
    begin
      repeat(10) @(posedge clk);
      ch0_gen_dframe;
      ch0_gen_dframe;   
      ch0_gen_dframe;
      ch0_gen_dframe;
      ch0_gen_dframe;
      ch0_gen_dframe;
      interupt;   
      interupt;   
    end
    begin
      ch1_gen_dframe;
      ch1_gen_dframe;
      ch1_gen_dframe;
      ch1_gen_dframe;
      ch1_gen_dframe;
      interupt;
      ch1_gen_dframe;
      repeat(600) @(posedge clk);      
    end
    join

    $finish;
  end


endmodule