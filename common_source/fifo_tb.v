`timescale 1 ps / 1 ps

module fifo_tb;

  // ------ parameter definition ------
  // --- for DUT ---
  parameter integer WIDTH = 8;
  parameter integer DEPTH = 32;

  localparam integer MAX_VAL = 2**WIDTH -1;

  // --- for test bench ---
  integer i;
  parameter integer CLK_PERIOD = 2E3;
  parameter integer RESET_TIME = 5;
  
  // ------ reg/wireの生成 -------
  reg clk = 1'b0;
  reg resetn = 1'b0;
  reg [WIDTH-1:0] din;
  reg write_en;
  reg read_en;

  wire [WIDTH-1:0] dout;
  wire not_empty;
  wire full;

  // ------ クロックの生成 ------
  initial begin
    clk = 1'b0;
  end

  always #( CLK_PERIOD/2 ) begin
      clk <= ~clk;
  end


  // ------ DUT ------
  Fifo # (
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
  ) DUT (
    .CLK(clk),
    .RESETN(resetn),
    .DIN(din),
    .DOUT(dout),
    .WE(write_en),
    .RE(read_en),
    .NOT_EMPTY(not_empty),
    .FULL(full)
  );

  // ------ reset task ------
  task reset;
  begin
    resetn <= 1'b0;
    write_en <= 1'b0;
    read_en <= 1'b0;
    repeat(RESET_TIME) @(posedge clk);
    resetn <= 1'b1;
    repeat(1) @(posedge clk);
  end
  endtask

  // ------ data generation task -------
  task gen_data;
  begin
    read_en <= 1'b0;
    din <= 0;
    repeat(1) @(posedge clk);
    write_en <= 1'b1;
    for ( i=1 ; i<=MAX_VAL ; i=i+1 ) begin
      repeat(1) @(posedge clk);
      din <= i;
      if (full) begin
        read_en <= 1'b1;
      end else begin
        read_en <=read_en;
      end
    end
  end
  endtask

  // ------ テストベンチ本体 ------
  initial
  begin
      $dumpfile("fifo_tb.vcd");
      $dumpvars(0, fifo_tb);

      reset;
      gen_data;

      $finish;

  end

endmodule