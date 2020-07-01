`timescale 1 ps / 1 ps

module delay_tb;

  // ------ parameter definition ------
  // --- for DUT ---
  parameter integer DELAY_CLK = 10;
  parameter integer WIDTH = 8;

  localparam integer MAX_VAL = 2**WIDTH -1;

  // --- for test bench ---
  integer i;
  parameter integer CLK_PERIOD = 2E3;
  parameter integer RESET_TIME = 5;
  
  // ------ reg/wireの生成 -------
  reg clk = 1'b0;
  reg resetn = 1'b0;
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
  Delay # (
    .DELAY_CLK(DELAY_CLK),
    .WIDTH(WIDTH)
  ) DUT (
    .CLK(clk),
    .RESETN(resetn),
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
    din <= 0;
    repeat(1) @(posedge clk);
    for ( i=1 ; i<=MAX_VAL ; i=i+1 ) begin
      repeat(1) @(posedge clk);
      din <= i;
    end
  end
  endtask

  // ------ テストベンチ本体 ------
  initial
  begin
      $dumpfile("delay_tb.vcd");
      $dumpvars(0, delay_tb);

      reset;
      gen_data;
      reset;
      gen_data;

      $finish;

  end

endmodule