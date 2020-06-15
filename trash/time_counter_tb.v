`timescale 1 ns / 1 ps

module time_counter_tb;

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth); begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction

  // ------ parameter definition ------
  // TIME STAMP DATA WIDTH
  parameter integer TIME_STAMP_WIDTH = 16;
  // AXIS_ACLK frequency (Hz)
  parameter integer CLK_FREQ = 500E6;
  // timer resolution freq (HZ)(must be < AXIS_ACLK_FREQ )
  parameter integer TIMER_RESO_FREQ = 100E6;

  // --- for test bench ---
  integer j;
  parameter integer CLK_PERIOD = 1E9/CLK_FREQ;
  parameter integer RESET_TIME = 5;
     
  // ------ reg/wireの生成 -------
  reg clk = 1'b0;
  reg resetn = 1'b0;

  wire [TIME_STAMP_WIDTH-1:0] curr_time;
  reg start;

  // ------ クロックの生成 ------
  initial begin
    clk = 1'b0;
  end

  always #( CLK_PERIOD/2 ) begin
      clk <= ~clk;
  end

  localparam integer MAX_TIME_COUNT = 2**TIME_STAMP_WIDTH-1;
  localparam integer CLK_DIVIDE = CLK_FREQ/TIMER_RESO_FREQ;
  localparam integer CLK_DIVIDE_WIDTH = clogb2(CLK_DIVIDE-1);

  time_counter # (
    .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
    .CLK_FREQ(CLK_FREQ),
    .TIMER_RESO_FREQ(TIMER_RESO_FREQ)   
  ) DUT (   
    .CLK(clk),
    .RESETN(resetn),
    .COUNT_ENABLE(start),  
    .CURRENT_TIME(curr_time)
  );

  // ------ reset task ------
  task reset;
    begin
      resetn <= 1'b0;
      start <= 1'b0;
      repeat(RESET_TIME) @(posedge clk);
      resetn <= 1'b1;
      repeat(1) @(posedge clk);
    end
  endtask

  // ------ テストベンチ本体 ------
  initial
  begin
    $dumpfile("time_counter_tb.vcd");
    $dumpvars(0, time_counter_tb);
    
    reset;
    start <= 1'b1;
    repeat(500) @(posedge clk);

    $finish;

  end

endmodule