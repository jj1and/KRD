`timescale 1 ns / 1 ps

module time_counter # (
  // TIME STAMP DATA WIDTH
  parameter integer TIME_STAMP_WIDTH = 48,
  // AXIS_ACLK frequency (Hz)
  parameter integer CLK_FREQ = 500E6,
  // timer resolution freq (HZ )(must be < AXIS_ACLK_FREQ )
  parameter integer TIMER_RESO_FREQ = 100E6   
)
(   
  // Ports of Axi-stream Bus Interface
  input wire CLK,
  input wire RESETN,
  // timer start
  input wire COUNT_ENABLE,  
  // current time
  output wire [TIME_STAMP_WIDTH-1:0] CURRENT_TIME
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth); begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer MAX_TIME_COUNT = 2**TIME_STAMP_WIDTH-1;
  localparam integer CLK_DIVIDE = CLK_FREQ/TIMER_RESO_FREQ;
  localparam integer CLK_DIVIDE_WIDTH = clogb2(CLK_DIVIDE-1);

  // enable counter
  reg [CLK_DIVIDE_WIDTH-1:0] divide_clk = 0;
  // timer enable
  wire counter_en;
  wire time_incr;
  // current time
  reg [TIME_STAMP_WIDTH-1:0] current_time = 0;
  wire [TIME_STAMP_WIDTH-1:0] current_timeD;
  
  assign time_incr = (divide_clk == CLK_DIVIDE-1);
  assign current_timeD = current_time + {{TIME_STAMP_WIDTH-1{1'b0}}, time_incr};
  assign counter_en = COUNT_ENABLE;
  assign CURRENT_TIME = current_time;

  // time counter
  always @(posedge CLK) begin
    if (!RESETN) begin
      current_time <= 0;
    end else begin
      if (!counter_en) begin
        current_time <= 1;
      end else begin
        current_time <= current_timeD;
      end
    end
  end

  // clock divide
  always @(posedge CLK or negedge counter_en) begin
    if ( (!RESETN) || (!counter_en)) begin
       divide_clk <= 0;
    end else begin
      if (divide_clk >= CLK_DIVIDE-1) begin
        divide_clk <= 0;
      end else begin
        divide_clk <= divide_clk + 1;
      end
    end
  end

endmodule