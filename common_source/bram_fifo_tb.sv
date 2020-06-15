`timescale 1 ps / 1 ps

module bram_fifo_tb;

  // ------ parameter definition ------
  // --- for DUT ---
  parameter integer DATA_WIDTH = 32;
  parameter integer PTR_WIDTH = 8;

  localparam integer FIFO_DEPTH = 2**PTR_WIDTH;
  localparam integer MAX_VAL = 2**DATA_WIDTH -1;

  // --- for test bench ---
  parameter integer CLK_PERIOD = 10000;
  parameter integer RESET_TIME = 5;
  
  // ------ generating nets -------
  reg CLK = 1'b1;
  reg RESET = 1'b1;
  reg [DATA_WIDTH-1:0] DIN = MAX_VAL;
  reg WR_EN = 1'b0;
  reg RD_EN = 1'b0;

  wire [DATA_WIDTH-1:0] DOUT;
  wire ALMOST_EMPTY;
  wire EMPTY;
  wire ALMOST_FULL;
  wire FULL;

  int data_ary[FIFO_DEPTH];

  // ------ clock generation ------
  initial begin
    CLK = 1'b1;
  end

  always #( CLK_PERIOD/2 ) begin
    CLK <= ~CLK;
  end


  // ------ DUT ------
  bram_fifo # (
    .DATA_WIDTH(DATA_WIDTH),
    .PTR_WIDTH(PTR_WIDTH),
    .INIT_VALUE()
  ) DUT (
    .*
  );

  // ------ RESET task ------
  task reset_all;
    repeat(1) @(posedge CLK);
    RESET <= #100 1'b1;
    repeat(RESET_TIME) @(posedge CLK);
    RESET <= #100 1'b0;
  endtask

  task automatic initalize_data;
    for (int i=0 ; i<FIFO_DEPTH ; i++ ) begin
      data_ary[i] = i;
    end
  endtask

  task automatic total_write_read_check;
    // initialize state
    $display("TEST START: total write&read check ");
    WR_EN <= #100 1'b0;
    RD_EN <= #100 1'b0;
    reset_all;
  
    // write in section
    $display("TEST INFO: write in untill FULL ");
    for ( int i=0 ;i<=FIFO_DEPTH ;i++ ) begin
      repeat(1) @(posedge CLK);
      if (i<FIFO_DEPTH) begin
        WR_EN <= #100 1'b1;
        DIN <= #100 data_ary[i];        
      end else begin
        WR_EN <= #100 1'b0;   
        if (ALMOST_FULL!=1'b1) begin
          $display("TEST FAILED: ALMOST_FULL flag didn't rise");
          $finish;        
        end
      end
      $display("Current write pointer:%d  read poninter:%d", DUT.wp[PTR_WIDTH-1:0], DUT.rp[PTR_WIDTH-1:0]);
    end
    repeat(1) @(posedge CLK);
    #100
    if ( FULL!=1'b1 ) begin
      $display("TEST FAILED: Didn't reach FULL");
      $finish;
    end

    // read out section
    $display("TEST INFO: read out untill EMPTY ");
    for (int i=0 ; i<=FIFO_DEPTH ; i++ ) begin
      repeat(1) @(posedge CLK);
      if (i<FIFO_DEPTH ) begin
        RD_EN <= #100 1'b1;
        if (i>1) begin
          if ( DOUT != data_ary[i-2] ) begin
            $display("TEST FAILED:read_out data and write in data doesn't macth!, DOUT:%d data_ary[%d]:%d", DOUT, i-1, data_ary[i-1]);
            $finish;            
          end
        end
      end else begin
        RD_EN <= #100 1'b0;
        if (ALMOST_EMPTY!=1'b1) begin
          $display("TEST FAILED: ALMOST_EMPTY flag didn't rise");
          $finish;        
        end        
      end
      $display("Current write pointer:%d  read poninter:%d", DUT.wp[PTR_WIDTH-1:0], DUT.rp[PTR_WIDTH-1:0]);
    end
    repeat(1) @(posedge CLK);
    #100
    if ( EMPTY != 1'b1 ) begin
      $display("TEST FAILED: Didn't reach EMPTY");
      $finish;
    end

    $display("TEST PASSED: Total write&read check passed");
  endtask

  task automatic write_to_be_full;
    int i = 0;
    // write in section
    $display("TEST INFO: write in untill FULL ");
    while (FULL!=1'b1) begin
      repeat(1) @(posedge CLK);
      WR_EN <= #100 1'b1;
      if (i<FIFO_DEPTH ) begin
        DIN <= #100 data_ary[i];
      end else begin
        DIN <= #100 data_ary[i-FIFO_DEPTH];
      end
      if ( i>FIFO_DEPTH+1 ) begin
        $display("TEST FAILED: Didn't reach FULL");
        $finish;
      end
      i++;    
    end
    $display("TEST INFO: reached FULL");
  endtask:write_to_be_full

  task automatic read_to_be_empty;
    int i = 0;
    // write in section
    $display("TEST INFO: write in untill EMPTY ");
    while (EMPTY!=1'b1) begin
      repeat(1) @(posedge CLK);
      RD_EN <= #100 1'b1;
      if ( i>FIFO_DEPTH+1 ) begin
        $display("TEST FAILED: Didn't reach EMPTY");
        $finish;
      end
      i++;    
    end
    $display("TEST INFO: reached EMPTY ");    
  endtask:read_to_be_empty

  task automatic empty_readout;
    int rd_ptr;
    
    // initialize state
    $display("TEST START: read out at empty check");
    repeat(1) @(posedge CLK);
    WR_EN <= #100 1'b0;
    RD_EN <= #100 1'b0;
    reset_all;
    read_to_be_empty;

    // test start
    repeat(1) @(posedge CLK);
    rd_ptr = DUT.rp;
    RD_EN <= #100 1'b1;

    for (int i=0 ; i<FIFO_DEPTH ; i++) begin
      repeat(1) @(posedge CLK);
      RD_EN <= #100 1'b1;
      if ( rd_ptr != DUT.rp ) begin
        $display("TEST FAILED: read pointer incremented at empty read out");
        $finish;
      end
    end
    repeat(1) @(posedge CLK);
    RD_EN <= #100 1'b0;

    $display("TEST PASSED: read out at empty check");
  endtask

  task automatic full_writein;
    // initialize
    int wr_ptr;
    $display("TEST START: write in at full check");
    repeat(1) @(posedge CLK);
    WR_EN <= #100 1'b0;
    RD_EN <= #100 1'b0;
    reset_all;
    write_to_be_full;

    // test start
    repeat(1) @(posedge CLK);
    wr_ptr = DUT.wp;
    WR_EN <= #100 1'b1;
    DIN <= #100 data_ary[0];
    for (int i=1 ; i<FIFO_DEPTH ; i++) begin
      repeat(1) @(posedge CLK);
      WR_EN <= #100 1'b1;
      DIN <= #100 data_ary[i];
      if ( wr_ptr != DUT.wp ) begin
        $display("TEST FAILED: write pointer incremented at full write in");
        $finish;
      end
      wr_ptr = DUT.wp;
    end
    repeat(1) @(posedge CLK);
    WR_EN <= #100 1'b0;
    DIN <= #100 MAX_VAL;

    $display("TEST PASSED: write in at full check");
  endtask

  task automatic simultane_write_read;
    $display("TEST START: write&read at the same time check");
    repeat(1) @(posedge CLK);
    WR_EN <= #100 1'b0;
    RD_EN <= #100 1'b0;
    reset_all;

    for (int i=0 ; i<2*FIFO_DEPTH ; i++) begin
      repeat(1) @(posedge CLK);
      WR_EN <= #100 1'b1;
      RD_EN <= #100 1'b1;
      if ( i>=FIFO_DEPTH ) begin
        DIN <= #100 data_ary[i-FIFO_DEPTH];
      end else begin
        DIN <= #100 data_ary[i];
      end
      $display("Current write pointer:%d  read poninter:%d", DUT.wp[PTR_WIDTH-1:0], DUT.rp[PTR_WIDTH-1:0]);
      if (i>=3) begin
        if (DOUT!=data_ary[i-3]) begin
          $display("TEST FAILED: wrote in data and read out data doesn't match! DOUT: %d  Input data: %d", DOUT, data_ary[i-3]);
          $finish;          
        end
      end        
    end        




    $display("TEST PASSED: write&read at the same time check");
  endtask

  // ------ testbench ------
  initial
  begin
    $dumpfile("bram_fifo_tb.vcd");
    $dumpvars(0, bram_fifo_tb);
    for ( int i=0 ; i<2**PTR_WIDTH ; i++ ) begin
      $dumpvars(1, bram_fifo_tb.DUT.bram.ram[i]);
    end
    initalize_data;
    total_write_read_check;
    empty_readout;
    full_writein;
    simultane_write_read;

    $finish;

  end

endmodule