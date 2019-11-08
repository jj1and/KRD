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

  // localparam integer COUNT_MAX = CLOCK_FREQ_MHZ*INTERVAL_MSEC*(10**3);
  // for test
  localparam integer COUNT_MAX = CLOCK_FREQ_MHZ*INTERVAL_MSEC;
  
  localparam integer COUNT_WIDTH = clogb2(COUNT_MAX-1);
  localparam integer TOP_BITS = COUNT_WIDTH%8;
  localparam integer NUM_OF_8BIT = (COUNT_WIDTH-TOP_BITS)/8;

  wire [NUM_OF_8BIT*8-1:0] lower_count;
  wire [COUNT_WIDTH-1:0] count;
  reg [7:0] lower_bits[NUM_OF_8BIT-1:0];
  reg [TOP_BITS-1:0] top_bits;
  reg [0:0] shift_up[NUM_OF_8BIT-1:0];
  wire [0:0] shift_upD[NUM_OF_8BIT-1:0];
  reg led_out;
  reg blink;
  wire blinkD;

  assign count = {top_bits, lower_count};
  assign blinkD = (count == COUNT_MAX-2);
  assign LED_OUT = led_out;

  genvar i;
  generate
    for ( i=0 ; i<NUM_OF_8BIT ; i=i+1 ) begin
      assign shift_upD[i] = (lower_bits[i] == {{7{1'b1}}, 1'b0});
      assign lower_count[8*i +:8] = lower_bits[i];
    end
  endgenerate

  generate
    for ( i=0 ; i<NUM_OF_8BIT ; i=i+1 ) begin
      always @(posedge CLK) begin
        if (!RESETN) begin
          shift_up[i] <= #10 0;
        end else begin
          shift_up[i] <= #10 shift_upD[i];
        end
      end
    end
  endgenerate

  generate
    for ( i=1 ; i<NUM_OF_8BIT ; i=i+1 ) begin
      always @(posedge CLK ) begin
        if ((!RESETN)|blink) begin
          lower_bits[i] <= #10 0;
        end else begin
          if (shift_up[i-1]) begin
            lower_bits[i] <= #10 lower_bits[i] + 1;
          end else begin
            lower_bits[i] <= #10 lower_bits[i];
          end
        end
      end
    end
  endgenerate

  always @(posedge CLK ) begin
    if ((!RESETN)|blink) begin
      lower_bits[0] <= #10 0;
    end else begin
      lower_bits[0] <= #10 lower_bits[0] + 1;
    end
  end

  always @(posedge CLK ) begin
    if ((!RESETN)|blink) begin
      top_bits <= #10 0;
    end else begin
      if (shift_up[NUM_OF_8BIT-1]) begin
        top_bits <= #10 top_bits + 1;
      end else begin
        top_bits <= #10 top_bits;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      blink <= #10 1'b1;
    end else begin
      blink <= #10 blinkD;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      led_out <= #10 1'b1;
    end else begin
      if (blink) begin
        led_out <= #10 ~led_out;
      end else begin
        led_out <= #10 led_out;
      end
    end
  end

endmodule