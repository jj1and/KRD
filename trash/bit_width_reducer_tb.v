`timescale 1 ps / 1 ps

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
  parameter integer DIN_WIDTH = 64;
  parameter integer DOUT_WIDTH = 16;
  parameter integer CONVERT_MARGIN = 2 + DIN_WIDTH/DOUT_WIDTH;

  // --- for test bench ---
  integer j;
  parameter integer CLK_PERIOD = 2E3;
  parameter integer RESET_TIME = 5;

  // ------ reg/wire generation -------
  reg clk = 1'b0;
  reg resetn = 1'b0;
  reg [DIN_WIDTH-1:0] din = 0;
  reg din_valid;

  wire [DOUT_WIDTH-1:0] dout;
  wire valid;
  reg ready;

  wire fifo_we;
  wire fifo_re;
  wire fifo_not_empty;
  wire fifo_full;
  wire [DIN_WIDTH-1:0] fifo_din;
  wire [DIN_WIDTH-1:0] fifo_dout;

  // ------ clock generation ------
  initial begin
    clk = 1'b0;
  end

  always #( CLK_PERIOD/2 ) begin
      clk <= ~clk;
  end

  // ------ reset task ------
  task reset;
    begin
      #400
      resetn <= 1'b0;
      ready <= 1'b0;
      din_valid <= 1'b0;
      repeat(RESET_TIME) @(posedge clk);
      #400
      resetn <= 1'b1;
      repeat(10) @(posedge clk);
      #400
      ready <= 1'b1;
      repeat(1) @(posedge clk); 
    end
  endtask


  // ------- signal generation ------
  task gen_signal;
  begin
    #400
    din_valid <= 1'b1;
    din <= {{16{1'b1}}, {16{1'b0}}, {2{8'd50}}, {2{8'b100}}};
  end
  endtask


  // ------  instance ------
  Fifo # (
    .WIDTH(DIN_WIDTH),
    .DEPTH(CONVERT_MARGIN),
    .PROG_FULL_THRE(),
    .PROG_EMPTY_THRE(),
    .INIT_VALUE()
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

  async_bit_width_reducer_mod # (
  .DIN_WIDTH(DIN_WIDTH),
  .DOUT_WIDTH(DOUT_WIDTH)
  ) DUT (
    .WR_CLK(clk),
    .WR_RESETN(resetn),
    .RD_CLK(clk),
    .RD_RESETN(resetn),
    .DIN(din),
    .DIN_VALID(din_valid),
    .DOUT(),
    .FIFO_DIN(fifo_din),
    .FIFO_WE(fifo_we),
    .FIFO_RE(fifo_re),
    .FIFO_DOUT(fifo_dout),
    .FIFO_NOT_EMPTY(fifo_not_empty),
    .FIFO_FULL(fifo_full),
    .FIFO_WR_RST_BUSY(!ready),
    .FIFO_RD_RST_BUSY(!ready),
    .MODULE_READY(ready),
    .CONVERT_READY(),
    .CONVERT_VALID()
  );


  // ------ testbench ------
  initial
  begin
    $dumpfile("bit_width_reducer_tb.vcd");
    $dumpvars(0, bit_width_reducer_tb);
    
    reset;
    gen_signal;
    repeat(500) @(posedge clk);
    din_valid <= #400 1'b0;
    repeat(500) @(posedge clk);

    $finish;

  end
endmodule