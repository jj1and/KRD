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

  wire count_done;
  reg [MAX_EXTEND_LEN_WIDTH:0] count = 0;
  reg [MAX_EXTEND_LEN_WIDTH-1:0] extend_len;
  reg delayed_sig_in;
  reg post_sig = 1'b0;
  wire ex_sigD;
  reg ex_sig = 1'b0;
  reg [1:0] sig_edge;
  wire sig_in_negedge;

  assign sig_in_negedge = (sig_edge == 2'b10);
  assign ex_sigD = delayed_sig_in|post_sig;
  assign SIG_OUT = SIG_IN|ex_sig;
  assign count_done = (count == extend_len-1);

always @(negedge CLK) begin
  if (!RESETN) begin
    sig_edge <= 2'b00;
  end else begin
    sig_edge <= {sig_edge[0], SIG_IN}; 
  end
end

  always @(posedge CLK) begin
    if (!RESETN) begin
      extend_len <= EXTEND_LEN;
    end else begin
      extend_len <= extend_len;
    end
  end

  always @(negedge CLK ) begin
    if (!RESETN) begin
      delayed_sig_in <= 1'b0;
    end else begin
      delayed_sig_in <= SIG_IN;
    end
  end

  always @(posedge CLK or negedge sig_in_negedge ) begin
    if (sig_in_negedge) begin
      count <= 0;
    end else begin
      if (count >= extend_len) begin
        count <= extend_len + 1;
      end else begin
        count <= count + 1;
      end
    end
  end

  always @(posedge count_done or negedge SIG_IN) begin
    if (delayed_sig_in) begin
      post_sig <= 1'b1;
    end else begin
      if (count_done) begin
        post_sig <= 1'b0;
      end else begin
        post_sig <= 1'b0;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ex_sig <= 1'b0;
    end else begin
      ex_sig <= ex_sigD;
    end
  end

endmodule