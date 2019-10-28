`timescale 1 ns / 1 ps

module bit_width_reducer_tb;

  // ------ parameter function definition -------
  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth); begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction
  
  // ------ parameter definition ------
  // --- for DUT ---
  parameter integer DIN_WIDTH = 16;
  parameter integer DOUT_WIDTH = 8;
  parameter integer CONVERT_MARGIN = 2;

  // --- for test bench ---
  integer j;
  parameter integer CLK_PERIOD = 2E3;
  parameter integer RESET_TIME = 5;

  // ------ reg/wireの生成 -------
  reg clk = 1'b0;
  reg resetn = 1'b0;
  reg [DIN_WIDTH-1:0] din;

  wire [DOUT_WIDTH-1:0] dout;
  wire valid;
  wire ready;

  // ------ クロックの生成 ------
  initial begin
    clk = 1'b0;
  end

  always #( CLK_PERIOD/2 ) begin
      clk <= ~clk;
  end


  bit_width_reducer_tb # (
    .DIN_WIDTH(DIN_WIDTH),
    .DOUT_WIDTH(DOUT_WIDTH),
    // internal fifo depth = (DIN_WIDTH/DOUT_WIDTH)+CONVERT_MARGIN
    .CONVERT_MARGIN(CONVERT_MARGIN)
  ) DUT (
    .CLK(clk),
    .RESETN(resetn),
    .DIN(din),
    .DOUT(dout),
    .CONVERT_READY(ready),
    .CONVERT_VALID(valid)
  );

  // ------ reset task ------
  task reset;
    begin
      resetn <= 1'b0;
      repeat(RESET_TIME) @(posedge clk);
      resetn <= 1'b1;
      repeat(1) @(posedge clk);
    end
  endtask

  // ------ テストベンチ本体 ------
  initial
  begin
    $dumpfile("bit_width_reducer_tb.vcd");
    $dumpvars(0, bit_width_reducer_tb);
    
    reset;

    $finish;

  end
endmodule