`timescale 1 ns / 1ps

module gen_write_en 
(

  input wire TX_ACLK,
  input wire TX_ARESETN,

  input wire SIGNAL_BEGIN,
  input wire SIGNAL_END,

  output wire SIGNAL_RECIEVE

);

  reg sig_rev;
  assign SIGNAL_RECIEVE = sig_rev;
  
  always @(posedge TX_ACLK ) begin
    if (!TX_ARESETN) begin
      sig_rev<= 1'b0;
    end else begin
      if (SIGNAL_BEGIN) begin
        sig_rev <= 1'b1;  
      end else begin
        if (SIGNAL_END) begin
          sig_rev <= 1'b0;
        end else begin
          sig_rev <= sig_rev;
        end
      end
    end
  end

endmodule