`timescale 1 ps / 1 ps

module DummyDataSink_tb;

  // ------ definition of parameters ------
  
  // --- for DUT ---
  // CLK frequency
  parameter integer CLK_FREQ = 500E6;
  // DATA WIDTH
  parameter integer TDATA_WIDTH = 128;
  // DATA WORD WIDTH
  parameter integer TDATA_WORD_WIDTH = 16;
  // ADC RESOLUTION
  parameter integer ADC_RESOLUTION_WIDTH = 12;
  

  // --- for function/task ---
  parameter integer CLK_PERIOD = 1E12/CLK_FREQ;
  parameter integer RESET_TIME = 10;
  integer i;
  
  // ------ reg/wire generation -------
  reg clk = 1'b0;
  reg resetn = 1'b0;
  reg tready;
  reg [ADC_RESOLUTION_WIDTH:0] count_max;
  wire [TDATA_WIDTH-1:0] tdata;
  wire tvalid;

  // ------ clock generation ------
  initial begin
    clk = 1'b0;
  end

  always #( CLK_PERIOD/2 ) begin
      clk <= ~clk;
  end

  // ------ reset task ------
  task reset;
  begin
    #400
    resetn <= 1'b0;
    tready <= 1'b0;
    count_max <= 32; 
    repeat(RESET_TIME) @(posedge clk);
    #400
    resetn <= 1'b1;
    repeat(1) @(posedge clk);
  end
  endtask


  DummyDataSink # (
    .TDATA_WIDTH(TDATA_WIDTH),
    .TDATA_WORD_WIDTH(TDATA_WORD_WIDTH),
    .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH)
  ) DUT (
    .CLK(clk),
    .ARESETN(resetn),
    .COUNT_MAX(count_max),
    .M_AXIS_TREADY(tready),
    .M_AXIS_TDATA(tdata),
    .M_AXIS_TVALID(tvalid)
  );

  initial
  begin
    $dumpfile("DummyDataSink_tb.vcd");
    $dumpvars(0, DummyDataSink_tb);   

    reset;
    #400
    tready <= 1'b0;    
    repeat(10) @(posedge clk);
    #400
    tready <= 1'b1;    
    repeat(200) @(posedge clk);

    $finish;

  end

endmodule