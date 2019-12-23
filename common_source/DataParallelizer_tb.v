`timescale 1 ps / 1 ps

module DataParallelizer_tb;
  
  // ------ definition of parameters ------
  
  // --- for DUT ---
  // CLK frequency
  parameter integer DIN_CLK_FREQ = 500E6;
  parameter integer DOUT_CLK_FREQ = DIN_CLK_FREQ/2;
  // TIME STAMP DATA WIDTH
  parameter integer TIME_STAMP_WIDTH = 32;
  // DATA WIDTH
  parameter integer WIDTH = TIME_STAMP_WIDTH;
  

  // --- for function/task ---
  parameter integer DIN_CLK_PERIOD = 1E12/DIN_CLK_FREQ;
  parameter integer DOUT_CLK_PERIOD = 1E12/DOUT_CLK_FREQ;
  parameter integer DIN_RESET_TIME = 10;
  integer i;
  
  // ------ reg/wire generation -------
  reg din_clk = 1'b0;
  reg din_resetn = 1'b0;
  reg valid;
  reg dout_clk = 1'b0;
  reg [TIME_STAMP_WIDTH-1:0] current_time;


  // ------ clock generation ------
  initial begin
    din_clk = 1'b0;
  end

  always #( DIN_CLK_PERIOD/2 ) begin
      din_clk <= ~din_clk;
  end

  initial begin
    dout_clk = 1'b0;
  end

  always #( DOUT_CLK_PERIOD/2 ) begin
      dout_clk <= ~dout_clk;
  end  

  // ------ time counter ------
  initial
  begin
    current_time = 0;
  end

  always @(posedge din_clk )
  begin
    current_time <= #400 current_time + 1;
  end  

  // ------ reset task ------
  task reset;
  begin
    #400
    valid <= 1'b0;
    din_resetn <= 1'b0;
    repeat(DIN_RESET_TIME) @(posedge din_clk);
    #400
    din_resetn <= 1'b1;
    repeat(1) @(posedge din_clk);
  end
  endtask

  // ------  instance ------
DataParallelizer # (
  .DIN_WIDTH(WIDTH)
) DUT (
  .CLK(din_clk),
  .RESETN(din_resetn),

  .iVALID(valid),
  .oREADY(),
  .DIN(current_time),

  .oVALID(),
  .DOUT()
);  

  // ------ testbench -------
  initial
  begin
    $dumpfile("DataParallelizer_tb.vcd");
    $dumpvars(0, DataParallelizer_tb);

    reset;
    #400 
    valid <= 1'b1;
    repeat(13) @(posedge din_clk);
    #400 
    valid <= 1'b0;
    repeat(34) @(posedge din_clk);
    #400
    valid <= 1'b1;
    repeat(53) @(posedge din_clk);
    reset;
    #400 
    valid <= 1'b1;
    repeat(45) @(posedge din_clk);
    #400
    valid <= 1'b0;
    repeat(30) @(posedge din_clk);
    #400
    valid <= 1'b1;
    repeat(200) @(posedge din_clk);

    $finish;
  end
 

endmodule