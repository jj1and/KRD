`timescale 1 ps / 1 ps

module SignalExpansioner # (
  parameter integer MAX_EXTEND_LEN_WIDTH = 5
)(
  input wire CLK,
  input wire RESET,
  input wire [MAX_EXTEND_LEN_WIDTH-1:0] EXTEND_LEN,
  input wire SIG_IN,
  output wire SIG_OUT
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth);
    begin
      for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
        bit_depth = bit_depth >> 1;
    end
  endfunction

  wire count_done;
  reg [MAX_EXTEND_LEN_WIDTH:0] count = 0;
  reg [MAX_EXTEND_LEN_WIDTH-1:0] extend_len;
  reg sig_in;
  reg post_sig = 1'b0;
  wire sig_outD;
  reg sig_out = 1'b0;
  wire fast_sig_in_negedge;

  assign fast_sig_in_negedge = (SIG_IN == 1'b0)&( sig_in == 1'b1);
  assign count_done = (count == extend_len-2);
  assign sig_outD = |{SIG_IN, fast_sig_in_negedge, post_sig};
  assign SIG_OUT = sig_out;

  always @(posedge CLK) begin
    if (RESET) begin
      extend_len <= #400 EXTEND_LEN;
    end else begin
      extend_len <= #400 extend_len;
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      sig_in <= #400 1'b0;
    end else begin
      sig_in <= #400 SIG_IN;
    end
  end

  always @(posedge CLK) begin
    if (RESET) begin
      count <= #400 0;
    end else begin
      if (fast_sig_in_negedge) begin
        count <= #400 0;
      end else begin
        if (count >= extend_len-2) begin
          count <= #400 extend_len-1;
        end else begin
          count <= #400 count + 1;
        end
      end  
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      post_sig <= #400 1'b0;
    end else begin
      if (fast_sig_in_negedge) begin
          post_sig <= #400 1'b1;
      end else begin
        if (count_done) begin
          post_sig <= #400 1'b0;
        end else begin
          post_sig <= #400 post_sig;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      sig_out <= #400 1'b0;
    end else begin
      sig_out <= #400 sig_outD;
    end
  end

endmodule