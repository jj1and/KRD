`timescale 1 ps / 1 ps

module signal_expansioner # (
  parameter integer MAX_EXTEND_LEN_WIDTH = 5
)(
  input wire CLK,
  input wire RESETN,
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

  reg [MAX_EXTEND_LEN_WIDTH:0] count = 0;
  reg [MAX_EXTEND_LEN_WIDTH-1:0] extend_len;
  reg delayed_sig_in;
  wire sig_outD;
  reg sig_out;
  wire sig_in_negedge;

  assign sig_in_negedge = (delayed_sig_in == 1'b1)&&(SIG_IN == 1'b0);
  assign SIG_OUT = |{sig_out, SIG_IN};

  always @(posedge CLK ) begin
    if (!RESETN) begin
      extend_len <= EXTEND_LEN;
      delayed_sig_in <= 1'b0;
    end else begin
      delayed_sig_in <= SIG_IN;
      extend_len <= extend_len;
    end
  end

  always @(posedge CLK or negedge sig_in_negedge) begin
    if (sig_in_negedge) begin
      count <=0;
      sig_out <= !SIG_IN;
    end else begin
      if ( (count >= extend_len-1) || !RESETN ) begin
        count <= extend_len;
        sig_out <= SIG_IN;
      end else begin
        count <= count + 1;
        sig_out <= !SIG_IN;
      end
    end
  end

endmodule