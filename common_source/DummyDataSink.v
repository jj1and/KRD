`timescale 1 ps / 1 ps

module DummyDataSink # (
  parameter integer TDATA_WIDTH = 128,
  parameter integer TDATA_WORD_WIDTH = 16,
  parameter integer ADC_RESOLUTION_WIDTH = 12
)(
  input wire CLK,
  input wire ARESETN,
  input wire signed [ADC_RESOLUTION_WIDTH:0] COUNT_MAX,
  input wire M_AXIS_TREADY,
  output wire [TDATA_WIDTH-1:0] M_AXIS_TDATA,
  output wire M_AXIS_TVALID
);
  
  localparam integer TDATA_WORD_NUM = TDATA_WIDTH/TDATA_WORD_WIDTH;

  reg [TDATA_WIDTH-1:0] tdata;
  wire [TDATA_WIDTH-1:0] tdataD;
  reg tvalid;
  reg signed [ADC_RESOLUTION_WIDTH:0] count_max;
  wire signed [ADC_RESOLUTION_WIDTH:0] count_thre = tdata[TDATA_WIDTH-1 -:ADC_RESOLUTION_WIDTH] - count_max;
  wire count_loop_en = (count_thre >= count_max);

  always @(posedge CLK ) begin
    if (!ARESETN) begin
      count_max <= #400 COUNT_MAX;
    end else begin
      count_max <= #400 count_max;
    end
  end

  always @(posedge CLK ) begin
    if (!ARESETN) begin
      tvalid <= #400 1'b0;
    end else begin
      tvalid <= #400 1'b1;
    end
  end

  integer i;
  always @(posedge CLK ) begin
    if (!ARESETN) begin
      for ( i=0 ; i<TDATA_WORD_NUM ; i=i+1 ) begin
        tdata[i*TDATA_WORD_WIDTH +:TDATA_WORD_WIDTH] <= #400 {{ADC_RESOLUTION_WIDTH{1'b0}}, {TDATA_WORD_WIDTH-ADC_RESOLUTION_WIDTH{1'b0}}};
      end
    end else begin
      if (M_AXIS_TREADY) begin
        if (count_loop_en) begin
          for ( i=0 ; i<TDATA_WORD_NUM ; i=i+1 ) begin
            tdata[i*TDATA_WORD_WIDTH +:TDATA_WORD_WIDTH] <= #400 {{ADC_RESOLUTION_WIDTH{1'b0}}, {TDATA_WORD_WIDTH-ADC_RESOLUTION_WIDTH{1'b0}}};
          end
        end else begin
          for ( i=0 ; i<TDATA_WORD_NUM ; i=i+2 ) begin
            tdata[i*TDATA_WORD_WIDTH +:TDATA_WORD_WIDTH] <= #400 {tdata[(i+1)*TDATA_WORD_WIDTH-ADC_RESOLUTION_WIDTH +:ADC_RESOLUTION_WIDTH] + {{ADC_RESOLUTION_WIDTH-1{1'b0}}, 1'b1}, {TDATA_WORD_WIDTH-ADC_RESOLUTION_WIDTH{1'b0}}};
          end
          for ( i=1 ; i<TDATA_WORD_NUM ; i=i+2 ) begin
            tdata[i*TDATA_WORD_WIDTH +:TDATA_WORD_WIDTH] <= #400 {tdata[(i+1)*TDATA_WORD_WIDTH-ADC_RESOLUTION_WIDTH +:ADC_RESOLUTION_WIDTH] + {{ADC_RESOLUTION_WIDTH-2{1'b0}}, 2'b10}, {TDATA_WORD_WIDTH-ADC_RESOLUTION_WIDTH{1'b0}}};
          end
        end
      end else begin
        tdata <= #400 tdata;
      end
    end
  end

  assign M_AXIS_TDATA = tdata;
  assign M_AXIS_TVALID = tvalid;

endmodule