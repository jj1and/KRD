`timescale 1 ps / 1 ps

module read_requester (
  input wire CLK,
  input wire RESETN,
  input wire PROGRAMMABLE_FULL,
  input wire PROGRAMMABLE_EMPTY,
  output wire READ_REQUEST
);

  reg read_request;
  reg prog_full_delay;
  reg prog_empty_delay;

  wire fast_prog_full_posedge;
  wire fast_prog_empty_posedge;

  assign fast_prog_full_posedge = (PROGRAMMABLE_FULL==1'b1)&(prog_full_delay==1'b0);
  assign fast_prog_empty_posedge = (PROGRAMMABLE_EMPTY==1'b1)&(prog_empty_delay==1'b0);
  assign READ_REQUEST = read_request;

  always @(posedge CLK ) begin
    if (!RESETN) begin
      prog_full_delay <= #400 1'b0;
      prog_empty_delay <= #400 1'b1;
    end else begin
      prog_full_delay <= #400 PROGRAMMABLE_FULL;
      prog_empty_delay <= #400 PROGRAMMABLE_EMPTY;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      read_request <= #400 1'b0;
    end else begin
      if (fast_prog_full_posedge) begin
        read_request <= #400 1'b1;
      end else begin
        if (fast_prog_empty_posedge) begin
          read_request <= #400 1'b0;
        end else begin
          read_request <= #400 read_request;
        end
      end
    end
  end

endmodule