`timescale 1 ps / 1 ps

module variable_delay_tb;
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
  parameter integer MAX_DELAY_CLK = 10;
  parameter integer WIDTH = 4;

  localparam integer MAX_VAL = 2**WIDTH -1;
  localparam integer MAX_DELAY_CNT_WIDTH = clogb2(MAX_DELAY_CLK);


  // --- for test bench ---
  integer i;
  integer j;
  parameter integer CLK_PERIOD = 2E3;
  parameter integer RESET_TIME = 5;
  
  // ------ reg/wireの生成 -------
  reg clk = 1'b0;
  reg resetn = 1'b0;
  reg [MAX_DELAY_CNT_WIDTH-1:0] delay_clk;
  reg [WIDTH-1:0] din;

  wire [WIDTH-1:0] dout;
  wire valid;
  wire ready;

  // ------ クロックの生成 ------
  initial begin
    clk = 1'b0;
  end

  always #( CLK_PERIOD/2 ) begin
      clk <= ~clk;
  end


  // ------ DUT ------
  Variable_delay # (
    .MAX_DELAY_CNT_WIDTH(MAX_DELAY_CNT_WIDTH),
    .WIDTH(WIDTH)
  ) DUT (
    .CLK(clk),
    .RESETN(resetn),
    .DELAY(delay_clk),
    .DIN(din),
    .DOUT(dout),
    .DELAY_READY(ready),
    .DELAY_VALID(valid)
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

  // ------ data generation task -------
  task gen_data;
  begin
    for ( i=2 ; i<=MAX_DELAY_CLK ; i=i+1 ) begin
      delay_clk <= i;
      reset;
      for ( j=0 ; j<MAX_VAL ; j=j+1 ) begin
        repeat(1) @(posedge clk);
        din <= j;
      end
    end
  end
  endtask

  // ------ テストベンチ本体 ------
  initial
  begin
      $dumpfile("variable_delay_tb.vcd");
      $dumpvars(0, variable_delay_tb);
      
      gen_data;

      $finish;

  end

endmodule