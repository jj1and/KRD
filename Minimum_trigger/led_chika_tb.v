`timescale 1 ps / 1 ps

module led_chika_tb;

  parameter integer CLK_FREQ_MHz = 500;
  parameter integer INTERVAL_MSEC = 1;

  parameter integer CLK_PERIOD = (10**6)/CLK_FREQ_MHz;
  integer k;
  
  reg clk;
  reg resetn = 1'b0;
  wire led_out;

  // ------ clock generation ------
  initial
  begin
      clk = 1'b0;
  end

  always #( CLK_PERIOD/2 )
  begin
    clk <= ~clk;
  end

  // ------ DUT ------
  led_chika # (
    .CLOCK_FREQ_MHZ(CLK_FREQ_MHz),
    .INTERVAL_MSEC(INTERVAL_MSEC)
  ) DUT (
    .CLK(clk),
    .RESETN(resetn),
    .LED_OUT(led_out)
  );

  // ------ test-bench ------
  initial begin
    $dumpfile("led_chika_tb.vcd");
    $dumpvars(0, led_chika_tb);
    for ( k=0 ; k<led_chika_tb.DUT.NUM_OF_4BIT ; k=k+1 ) begin
      $dumpvars(1, led_chika_tb.DUT.lower_bits[k]);
    end

    resetn <= 1'b0;
    repeat(10) @(posedge clk);
    resetn <= 1'b1;
    repeat(1000) @(posedge clk);

    $finish;
  end

endmodule