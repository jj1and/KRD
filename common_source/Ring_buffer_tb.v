`timescale 1 ps / 1 ps

module Ring_buffer_tb;
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
  parameter integer WIDTH = 8;
  parameter integer FIFO_DEPTH = 80;
  parameter integer MAX_BACK_LEN = 10;
  

  localparam integer MAX_VAL = 2**WIDTH -1;
  localparam integer MAX_BACK_CNT_WIDTH = clogb2(MAX_BACK_LEN);


  // --- for test bench ---
  integer j;
  parameter integer CLK_PERIOD = 2E3;
  parameter integer RESET_TIME = 5;
  parameter integer BACK_LEN = 2;
  
  // ------ reg/wireの生成 -------
  reg clk = 1'b0;
  reg resetn = 1'b0;
  reg [MAX_BACK_CNT_WIDTH-1:0] back_len = BACK_LEN;
  reg [WIDTH-1:0] din;
  reg write_en;
  reg read_en;

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
  Ring_buffer # (
    .WIDTH(WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH),
    .MAX_BACK_LEN(MAX_BACK_LEN)
  ) DUT (
    .CLK(clk),
    .RESETN(resetn),
    .BACK_LEN(back_len),
    .DIN(din),
    .DOUT(dout),
    .WE(write_en),
    .RE(read_en),
    .BUFF_WRITE_READY(ready),
    .BUFF_READ_VALID(valid)
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

  // ------ read out task ------
  task read_out;
    begin
      read_en <= 1'b0;
      repeat(40) @(posedge clk);
      for ( j=1 ; j<9 ; j=j+1 ) begin
        read_en <=1'b0;
        repeat(20) @(posedge clk);
        read_en <=1'b1;
        repeat(20) @(posedge clk);        
      end
    end
  endtask

  // ------ generate normal signal -----
  task gen_normal_sig;
    begin
      din <= 20;
      write_en <= 1'b0;
      repeat(5) @(posedge clk);    
      din <= 100;
      write_en <= 1'b1;
      repeat(10) @(posedge clk);
      din <= 80;
      repeat(5) @(posedge clk);
    end
  endtask  

  // ------ generate busy signal -----
  task gen_busy_sig;
    begin
      din <= 200;
      write_en <= 1'b1;
      repeat(30) @(posedge clk);
      din <= 50;
      repeat(10) @(posedge clk);
    end
  endtask

  // ------ generate noise -----
  task gen_noise;
    begin
      din <= 10;
      write_en <= 1'b0;
      repeat(30) @(posedge clk);
    end
  endtask

  // ------- trigger task -------
  task gen_normal_trg;
    begin
      gen_noise;
      gen_normal_sig;
      gen_noise;
      gen_normal_sig;
      gen_noise;
      gen_normal_sig;              
    end
  endtask

  task gen_busy_trg;
    begin
      gen_noise;
      gen_busy_sig;
      gen_noise;
      gen_normal_sig;
    end
  endtask

  // ------ テストベンチ本体 ------
  initial
  begin
    $dumpfile("Ring_buffer_tb.vcd");
    $dumpvars(0, Ring_buffer_tb);
    
    reset;
    fork
      begin
        read_out;
      end
      begin
        gen_normal_trg;
        gen_busy_trg;
        gen_noise;        
      end
    join

    $finish;

  end

endmodule