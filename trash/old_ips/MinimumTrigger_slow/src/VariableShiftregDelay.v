`timescale 1 ps / 1 ps

module VariableShiftregDelay # (
  parameter integer MAX_DELAY_CNT_WIDTH = 5,
  parameter integer WIDTH = 128
)
(
  input wire CLK,
  input wire RESETN,
  input wire [MAX_DELAY_CNT_WIDTH-1:0] DELAY,

  /* data and valid signals */
  input wire iVALID,
  input wire [WIDTH-1:0] DIN,

  output wire [WIDTH-1:0] DOUT,
  output wire oVALID
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth); begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer SHIFTREG_DEPTH = 2**MAX_DELAY_CNT_WIDTH-1;

  wire delay_ready = &{RESETN, iVALID};

  reg [SHIFTREG_DEPTH*WIDTH-1:0] shiftreg;
  wire [WIDTH-1:0] shiftreg_initval = {WIDTH{1'b1}};

  reg [MAX_DELAY_CNT_WIDTH-1:0] delay_cnt;
  wire [MAX_DELAY_CNT_WIDTH-1:0] delay_cnt_initval = {MAX_DELAY_CNT_WIDTH{1'b1}};
  reg [MAX_DELAY_CNT_WIDTH-1:0] delay;

  reg valid;

  assign oVALID = valid;
  assign DOUT = shiftreg[(delay-1)*WIDTH +:WIDTH];
  
  always @(posedge CLK ) begin
    if (!RESETN) begin
      delay <= #400 DELAY;
    end else begin
      delay <= #400 delay;
    end
  end
  
  always @(posedge CLK ) begin
    if (~delay_ready) begin
      delay_cnt <= #400 {MAX_DELAY_CNT_WIDTH{1'b1}};
       valid <= #400 1'b0;
    end else begin
      if (delay_cnt==delay_cnt_initval) begin
        delay_cnt <= #400 0;
        valid <= #400 1'b0;
      end else begin
        if (delay_cnt>=delay-2) begin
          delay_cnt <= #400 delay-1;
           valid <= #400 1'b1;
        end else begin
          delay_cnt <= #400 delay_cnt + 1;
          valid <= #400 1'b0;
        end
      end
    end
  end

  integer i;
  always @(posedge CLK ) begin
    if (~delay_ready) begin
      shiftreg <= #400 {SHIFTREG_DEPTH{shiftreg_initval}};
    end else begin
      shiftreg <= #400 {shiftreg[(SHIFTREG_DEPTH-1)*WIDTH-1:0], DIN};
    end
  end

endmodule