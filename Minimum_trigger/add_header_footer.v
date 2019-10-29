`timescale 1 ns / 1 ps

module add_header_footer #
(
  parameter integer DATA_WIDTH = 128,
  parameter integer HEADER_FOOTER_WIDTH = 64,
  parameter integer TIME_STAMP_WIDTH = 49,
  parameter integer ADC_RESOLUTION_WIDTH = 12,
  parameter integer CHANNEL_ID  = 0
)(
  input wire CLK,
  input wire RESETN,
  input wire DIN_VALID,
  input wire TRIGGERED,
  input wire [TIME_STAMP_WIDTH-1:0] TIME_STAMP,
  input wire [ADC_RESOLUTION_WIDTH-1:0] THRESHOLD_WHEN_HIT,
  input wire [ADC_RESOLUTION_WIDTH-1:0] BASELINE_WHEN_HIT,
  input wire [DATA_WIDTH-1:0] DIN,
  output wire [DATA_WIDTH-1:0] DOUT,
  output wire ADDING_VALID
);

  localparam integer ONE_FILL_WIDTH = 16 -ADC_RESOLUTION_WIDTH;
  localparam integer HEAD_FOOT_ID_WIDTH = 4;
  localparam integer CHANNEL_ID_WIDTH = 4;
  localparam integer DATA_DELAY_CLK = 1;

  reg [HEADER_FOOTER_WIDTH-1:0] dummy_header_footer = {HEADER_FOOTER_WIDTH{1'b1}};
  reg [ONE_FILL_WIDTH-1:0] one_fill = {ONE_FILL_WIDTH{1'b1}};
  reg [HEAD_FOOT_ID_WIDTH-1:0] header_id = {{2{1'b1}}, {HEAD_FOOT_ID_WIDTH-2{1'b0}}};
  reg [HEAD_FOOT_ID_WIDTH-1:0] footer_id = {{HEAD_FOOT_ID_WIDTH-2{1'b0}}, {2{1'b1}}};
  reg [CHANNEL_ID_WIDTH-1:0] ch_id = CHANNEL_ID;
  reg [HEADER_FOOTER_WIDTH-ONE_FILL_WIDTH*2-CHANNEL_ID_WIDTH-TIME_STAMP_WIDTH-HEAD_FOOT_ID_WIDTH-1:0] header_zero_pad = 0;
  reg [HEADER_FOOTER_WIDTH-ONE_FILL_WIDTH*2-ADC_RESOLUTION_WIDTH*2-HEAD_FOOT_ID_WIDTH-1:0] footer_zero_pad = 0;

  wire [DATA_WIDTH-1:0] combined_header;
  wire [DATA_WIDTH-1:0] combined_footer;
  wire [HEADER_FOOTER_WIDTH-1:0] header;
  wire [HEADER_FOOTER_WIDTH-1:0] footer;
  wire [ONE_FILL_WIDTH+CHANNEL_ID_WIDTH-1:0] ch_id_set = {one_fill, ch_id};
  wire [ONE_FILL_WIDTH+TIME_STAMP_WIDTH-1:0] time_stamp_set;
  wire [ONE_FILL_WIDTH+ADC_RESOLUTION_WIDTH-1:0] baseline_set;
  wire [ONE_FILL_WIDTH+ADC_RESOLUTION_WIDTH-1:0] threshold_set;

  wire trg_delay_ready;
  wire trg_delay_valid;
  reg delayed_triggered;

  wire data_delay_ready;
  wire data_delay_valid;
  reg [DATA_WIDTH-1:0] delayed_data;

  wire triggered_posedge;
  wire triggered_negedge;

  reg [DATA_WIDTH-1:0] doutD;
  reg [DATA_WIDTH-1:0] dout;
  wire adding_validD;
  reg adding_valid;

  assign time_stamp_set = {one_fill, TIME_STAMP};
  assign baseline_set = {one_fill, BASELINE_WHEN_HIT};
  assign threshold_set = {one_fill, THRESHOLD_WHEN_HIT};
  assign header = {ch_id_set, time_stamp_set, header_zero_pad, header_id};
  assign footer = {baseline_set, threshold_set, footer_zero_pad, footer_id};
  assign combined_header = {dummy_header_footer, header};
  assign combined_footer = {dummy_header_footer, footer};

  assign triggered_posedge = (delayed_triggered == 1'b0 )&&( TRIGGERED == 1'b1);
  assign triggered_negedge = (delayed_triggered == 1'b1 )&&( TRIGGERED == 1'b0);
  assign adding_validD = TRIGGERED||delayed_triggered;
  assign DOUT = dout;
  assign ADDING_VALID = adding_valid; 

  always @( triggered_posedge or triggered_negedge) begin
    if (triggered_posedge) begin
      doutD = combined_header;
    end else begin
      if (triggered_negedge) begin
        doutD = combined_footer;
      end else begin
        doutD = delayed_data;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      dout <= {DATA_WIDTH{1'b1}};
      adding_valid <= 1'b0;
    end else begin
      dout <= doutD;
      adding_valid <= adding_validD;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      delayed_triggered <= 1'b0;
      delayed_data <= {DATA_WIDTH{1'b1}};
    end else begin
      delayed_triggered <= TRIGGERED;
      delayed_data <= DIN;
    end
  end

endmodule 