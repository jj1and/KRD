`timescale 1 ns / 1 ps

module Ring_buffer # (
    parameter integer WIDTH = 128,
    parameter integer FIFO_DEPTH = 200/2,
    parameter integer PRE_ACQUI_LEN = 24/2
)
(
    input wire CLK,
    input wire RESETN,
    input wire [WIDTH-1:0] DIN,
    output wire [WIDTH-1:0] DOUT,
    input wire WE,
    input wire RE,
    output wire VALID,
    output wire BUFF_READY
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth);
    begin
      for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
        bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer DEPTH_WIDTH = clogb2(FIFO_DEPTH-1);
  localparam integer PRE_CNT_BIT_WIDTH = clogb2(PRE_ACQUI_LEN);

  reg [PRE_ACQUI_LEN:0] pre_acqui_len = PRE_ACQUI_LEN;

  


  

endmodule