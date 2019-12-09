`timescale 1 ps / 1 ps

module sig_exp_tb;

  // ------ parameter definition ------
  // --- for DUT ---
  parameter integer EXTEND_LEN_WIDTH = 5;

  // --- for test bench ---
  integer i;
  parameter integer CLK_PERIOD = 2E3;
  parameter integer RESET_TIME = 5;
  
  // ------ reg/wireの生成 -------
  reg clk = 1'b0;
  reg resetn = 1'b0;
  reg [EXTEND_LEN_WIDTH-1:0] extend_len = 4;
  reg sig_in = 1'b0;

  wire sig_out;
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
  signal_expansioner # (
    .MAX_EXTEND_LEN_WIDTH(EXTEND_LEN_WIDTH)
  ) DUT (
    .CLK(clk),
    .RESETN(resetn),
    .EXTEND_LEN(extend_len),
    .SIG_IN(sig_in),
    .SIG_OUT(sig_out)
  );

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

  // ------ data generation task -------
  task gen_data;
  begin
    #400
    sig_in <= 1'b1;
    repeat(20) @(posedge clk);
    #400
    sig_in <= 1'b0;
    repeat(20) @(posedge clk);
  end
  endtask

  // ------ data generation task -------
  task gen_data_renzoku;
  begin
    #400
    sig_in <= 1'b1;
    repeat(2) @(posedge clk);
    #400
    sig_in <= 1'b0;
    repeat(2) @(posedge clk);
    #400
    sig_in <= 1'b1;
    repeat(20) @(posedge clk);
    #400
    sig_in <= 1'b0;
    repeat(20) @(posedge clk);    
  end
  endtask

  // ------ テストベンチ本体 ------
  initial
  begin
      $dumpfile("sig_exp_tb.vcd");
      $dumpvars(0, sig_exp_tb);

      reset;
      gen_data;
      gen_data_renzoku;
      reset;
      gen_data;

      $finish;

  end

endmodule