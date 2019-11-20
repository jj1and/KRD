`timescale 1 ps / 1 ps

module fifo_tb;

  // ------ parameter definition ------
  // --- for DUT ---
  parameter integer WIDTH = 8;
  parameter integer DEPTH = 32;

  localparam integer MAX_VAL = 2**WIDTH -1;

  // --- for test bench ---
  integer i;
  integer j;
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
    .DEPTH(DEPTH),
    .PROG_FULL_THRE(30),
    .PROG_EMPTY_THRE(2),
    .INIT_VALUE(8'h0F)
  ) DUT (
    .CLK(clk),
    .RESETN(resetn),
    .DIN(din),
    .DOUT(dout),
    .WE(write_en),
    .RE(read_en),
    .NOT_EMPTY(not_empty),
    .FULL(full),
    .PROGRAMMABLE_FULL(),
    .PROGRAMMABLE_EMPTY()
  );

  // ------ reset task ------
  task reset;
  begin
    resetn <= #400 1'b0;
    write_en <= #400 1'b0;
    read_en <= #400 1'b0;
    repeat(RESET_TIME) @(posedge clk);
    resetn <= #400 1'b1;
    repeat(1) @(posedge clk);
  end
  endtask

  // ------ data generation task -------
  task gen_data;
  begin
    din <= #400 0;
    repeat(1) @(posedge clk);
    write_en <= #400 1'b1;
    for ( i=1 ; i<=MAX_VAL ; i=i+1 ) begin
      repeat(1) @(posedge clk);
      din <= #400 i;
    end
  end
  endtask

  // read out task
  task readout;
  begin
    read_en <= 1'b0;
    repeat(10) @(posedge clk);
    read_en <= #400 1'b1;
    repeat(25) @(posedge clk);
    read_en <= #400 1'b0;
    repeat(3) @(posedge clk);
    read_en <= #400 1'b1;
  end
  endtask

  task writein;
  begin
    write_en <= 1'b1;
    repeat(30) @(posedge clk);
    write_en <= #400 1'b0;
    repeat(10) @(posedge clk);
    write_en <= #400 1'b1;
    repeat(5) @(posedge clk);
    write_en <= #400 1'b0;   
  end
  endtask

  // ------ テストベンチ本体 ------
  initial
  begin
      $dumpfile("fifo_tb.vcd");
      $dumpvars(0, fifo_tb);
      for ( j=0 ; j<DEPTH ; j=j+1 ) begin
        $dumpvars(1, fifo_tb.DUT.sram[j]);
      end

      reset;
      fork
      begin
        gen_data;
      end
      begin
        readout;
      end
      begin
        writein;
      end
      join

      $finish;

  end

endmodule