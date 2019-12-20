`timescale 1 ps / 1 ps

module VariableShiftregDelay_tb;
  
  // ------ definition of parameters ------
  
  // --- for DUT ---
  // CLK frequency
  parameter integer CLK_FREQ = 500E6;
  // TIME STAMP DATA WIDTH
  parameter integer TIME_STAMP_WIDTH = 48;
  // DATA WIDTH
  parameter integer WIDTH = TIME_STAMP_WIDTH;
  // MAX_DELAY_CNT_WIDTH
  parameter integer MAX_DELAY_CNT_WIDTH = 7;
  

  // --- for function/task ---
  parameter integer CLK_PERIOD = 1E12/CLK_FREQ;
  parameter integer RESET_TIME = 10;
  integer i;
  
  // ------ reg/wire generation -------
  reg clk = 1'b0;
  reg resetn = 1'b0;
  reg [TIME_STAMP_WIDTH-1:0] current_time;
  reg [MAX_DELAY_CNT_WIDTH-1:0] delay = 7'd4;


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

  always @(posedge clk )
  begin
    current_time <= #400 current_time + 1;
  end  

  // ------ reset task ------
  task reset;
  begin
    #400
    resetn <= 1'b0;
    repeat(RESET_TIME) @(posedge clk);
    #400
    resetn <= 1'b1;
    repeat(1) @(posedge clk);
  end
  endtask

  // ------  instance ------
  VariableShiftregDelay # (
    .MAX_DELAY_CNT_WIDTH(MAX_DELAY_CNT_WIDTH),
    .WIDTH(WIDTH)
  ) DUT (
    .CLK(clk),
    .RESETN(resetn),
    .DELAY(delay),
    .iVALID(resetn),
    .DIN(current_time),
    .DOUT(),
    .oVALID()
  );

  // ------ testbench -------
  initial
  begin
    $dumpfile("VariableShiftregDelay_tb.vcd");
    $dumpvars(0, VariableShiftregDelay_tb);
  
    reset;
    repeat(200) @(posedge clk);
    delay <= 10;
    reset;
    repeat(200) @(posedge clk);
    delay <= 7;
    reset;
    repeat(200) @(posedge clk);
  
    $finish;
  end
 

endmodule