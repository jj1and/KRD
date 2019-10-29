`timescale 1 ps / 1 ps

module Trimmer_tb;

  // ------ パラメータの定義 ------
  
  // --- DUT用 ---
  // AXIS_ACLK frequency
  parameter AXIS_ACLK_FREQ = 500E6;
  // threshold ( percentage of max value = 2^12)
  parameter integer THRESHOLD = 80;
  // acquiasion length settings
  parameter integer POST_ACQUI_LEN = 76/2;
  // acquiasion length settings
  parameter integer ACQUI_LEN = 200/2;
  // RFSoC ADC resolution
  parameter integer ADC_RESOLUTION_WIDTH = 12;
  // RF Data Converter data stream bus width
  parameter integer S_AXIS_TDATA_WIDTH	= 64;

  // --- function/task用 ---
  parameter signed ADC_MAX_VAL = 2**(ADC_RESOLUTION_WIDTH-1)-1;
  parameter signed ADC_MIN_VAL = -2**(ADC_RESOLUTION_WIDTH-1);
  parameter integer ACLK_PERIOD = 1E12/AXIS_ACLK_FREQ;
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
  parameter integer SAMPLE_PER_TDATA = S_AXIS_TDATA_WIDTH/16;
  integer i;
  integer k;
  
  // ------ reg/wireの生成 -------
  reg axis_aclk = 1'b0;
  reg axis_aresetn = 1'b0;
  
  reg [S_AXIS_TDATA_WIDTH-1:0] s_axis_tdata = 0;
  reg s_axis_tvalid = 1'b0;

  wire [S_AXIS_TDATA_WIDTH-1:0] dout;
  wire trim_valid;
  wire trim_ready;


  reg signed [ADC_RESOLUTION_WIDTH-1:0] bl_min = BL_MIN;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] bl_max = BL_MAX;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] fst_height = FST_HEIGHT;
  reg signed [ADC_RESOLUTION_WIDTH-1:0] snd_height = SND_HEIGHT;

  wire signed [ADC_RESOLUTION_WIDTH-1:0] s_axis_tdata_word[SAMPLE_PER_TDATA-1:0];
  wire signed [16-1:0] data_word[SAMPLE_PER_TDATA-1:0];


  // ------ クロックの生成 ------
  initial
  begin
      axis_aclk = 1'b0;
  end

  always #( ACLK_PERIOD/2 )
  begin
    axis_aclk <= ~axis_aclk;
  end

  // ------ DUT ------
  data_trimmer # (
    .DATA_WIDTH(S_AXIS_TDATA_WIDTH)
  ) DUT (
    .CLK(axis_aclk),
    .RESETN(axis_aresetn),
    .DIN(s_axis_tdata),
    .DIN_VALID(s_axis_tvalid),
    .DOUT(dout),
    .TRIMMER_VALID(trim_valid),
    .TRIMMER_READY(trim_ready)
  );

  // ------ リセットタスク ------
  task reset;
  begin
    axis_aresetn <= 1'b0;
    repeat(RESET_TIME) @(posedge axis_aclk);
    axis_aresetn <= 1'b1;
  end
  endtask

  // ------ FFFF生成タスク -------
  task gen_ffff;
    begin
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        s_axis_tdata[16*i +:16] <= {16{1'b1}};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        s_axis_tdata[16*i +:16] <= {16{1'b1}};
      end
    end
  endtask

  // ------- 信号部生成タスク ------
  task gen_signal;
    begin
      // 最初の山
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        s_axis_tdata[16*i +:16] <= {fst_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        s_axis_tdata[16*i +:16] <= {fst_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      repeat(FST_WIDTH) @(posedge axis_aclk);
        
      // 二段目の山 (最初より低い)
      for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        s_axis_tdata[16*i +:16] <= {snd_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 ) begin
        s_axis_tdata[16*i +:16] <= {snd_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
      repeat(SND_WIDTH) @(posedge axis_aclk);
    end
  endtask

  // ------ 信号セット生成タスク ------
  task gen_signal_set;
  begin
      gen_ffff;
      repeat(PRE_SIG) @(posedge axis_aclk);
      gen_signal;
      gen_ffff;
      repeat(POST_SIG) @(posedge axis_aclk);
  end
  endtask

  // S_AXIS_TDATAの分割
  genvar j;
  generate
      for ( j=0 ; j<SAMPLE_PER_TDATA ; j=j+1 )
      begin
        assign s_axis_tdata_word[j] = s_axis_tdata[16*(j+1)-1 -:ADC_RESOLUTION_WIDTH];
      end
  endgenerate

  // DATAの分割
  generate
      for ( j=0 ; j<SAMPLE_PER_TDATA ; j=j+1 )
      begin
        assign data_word[j] = dout[16*(j+1)-1 -:16];
      end
  endgenerate

  // ------ テストベンチ本体 ------
  initial
  begin
      $dumpfile("Trimmer_tb.vcd");
      $dumpvars(0, Trimmer_tb);
      for ( k=0 ; k<SAMPLE_PER_TDATA ; k=k+1 ) begin
        $dumpvars(1, Trimmer_tb.data_word[k]);
      end

      s_axis_tvalid <= 1'b0;
      reset;
      s_axis_tvalid <= 1'b1;

      gen_signal_set;
      gen_ffff;
      repeat(SIGNAL_INTERVAL) @(posedge axis_aclk);
      gen_signal_set;
      repeat(SIGNAL_INTERVAL) @(posedge axis_aclk);
      $finish;

  end

endmodule