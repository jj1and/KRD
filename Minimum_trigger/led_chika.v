`timescale 1 ps / 1 ps

module led_chika # (
  parameter integer CLOCK_FREQ_MHZ = 250,
  parameter integer INTERVAL_MSEC = 500
)(
  input wire CLK,
  input wire RESETN,
  output wire LED_OUT
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth); begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer COUNT_MAX = CLOCK_FREQ_MHZ*INTERVAL_MSEC*(10**3);
  localparam integer COUNT_WIDTH = clogb2(COUNT_MAX-1);

  reg [COUNT_WIDTH-1:0] count;
  reg led_out;
  reg blink;
  wire blinkD;

  assign blinkD = (count == COUNT_MAX-2);
  assign LED_OUT = led_out;

  always @(posedge CLK ) begin
    if (!RESETN) begin
      count <= 0;
    end else begin
      if (count == COUNT_MAX-1) begin
        count <= 0;
      end else begin
        count <= count + 1;
      end
    end
  end

  always @( CLK ) begin
    if (!RESETN) begin
      blink <= 1'b1;
    end else begin
      blink <= blinkD;
    end
  end

  always @( CLK ) begin
    if (!RESETN) begin
      led_out <= 1'b1;
    end else begin
      if (blink) begin
        led_out <= 1'b1;
      end else begin
        led_out <= 1'b0;
      end
    end
  end

endmodule