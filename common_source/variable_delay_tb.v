`timescale 1 ps / 1 ps

module variable_delay_tb;
  
  // ------ definition of parameters ------
  
  // --- for DUT ---
  // CLK frequency
  parameter integer CLK_FREQ = 500E6;
  // TIME STAMP DATA WIDTH
  parameter integer TIME_STAMP_WIDTH = 48;
  // DATA WIDTH
  parameter integer WIDTH = TIME_STAMP_WIDTH;
  // FIFO depth
  parameter integer DEPTH = 32;
  // programmable full 
  parameter integer PROG_FULL = 200;
  parameter integer PROG_EMPTY = 60;
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
  wire fifo_we;
  wire fifo_re;
  wire fifo_not_empty;
  wire fifo_full;
  wire [WIDTH-1:0] fifo_din;
  wire [WIDTH-1:0] fifo_dout;


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
  Fifo # (
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .PROG_FULL_THRE(PROG_FULL),
    .PROG_EMPTY_THRE(PROG_EMPTY),
    .INIT_VALUE({WIDTH{1'b0}})
  ) delay_fifo (
    .CLK(clk),
    .RESETN(resetn),
    .DIN(fifo_din),
    .DOUT(fifo_dout),
    .WE(fifo_we),
    .RE(fifo_re),
    .NOT_EMPTY(fifo_not_empty),
    .FULL(fifo_full),
    .PROGRAMMABLE_FULL(),
    .PROGRAMMABLE_EMPTY()
  );

  Variable_delay_mod # (
    .MAX_DELAY_CNT_WIDTH(MAX_DELAY_CNT_WIDTH),
    .WIDTH(WIDTH)
  ) DUT (
    .CLK(clk),
    .RESETN(resetn),
    .DELAY(delay),
    .DIN(current_time),
    .DOUT(),
    .FIFO_DIN(fifo_din),
    .FIFO_WE(fifo_we),
    .FIFO_RE(fifo_re),
    .FIFO_DOUT(fifo_dout),
    .FIFO_EMPTY(~fifo_not_empty),
    .FIFO_FULL(fifo_full),
    .FIFO_RST_BUSY(!resetn),
    .DELAY_READY(),
    .DELAY_VALID()
  );

  // ------ testbench -------
  initial
  begin
    $dumpfile("variable_delay_tb.vcd");
    $dumpvars(0, variable_delay_tb);     
  
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