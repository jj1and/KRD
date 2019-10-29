`timescale 1 ns / 1 ps

module add_header_footer #
(
  parameter integer DATA_WIDTH = 128,
  parameter integer HEADER_FOOTER_WIDTH = 64,
  parameter integer TIME_STAMP_WIDTH = 49,
  parameter integer FIRST_TIME_STAMP_WIDTH = 26,
  parameter integer ADC_RESOLUTION_WIDTH = 12,
  parameter integer CHANNEL_ID  = 0
)(
  input wire CLK,
  input wire RESETN,
  input wire DIN_VALID,
  input wire TRIGGERED,
  input wire [TIME_STAMP_WIDTH-1:0] TIME_STAMP,
  input wire [ADC_RESOLUTION_WIDTH+1-1:0] THRESHOLD_WHEN_HIT,
  input wire [ADC_RESOLUTION_WIDTH-1:0] BASELINE_WHEN_HIT,
  input wire [DATA_WIDTH-1:0] DIN,
  output wire [DATA_WIDTH-1:0] DOUT,
  output wire ADDING_VALID
);

  localparam integer ONE_FILL_WIDTH = 16 -ADC_RESOLUTION_WIDTH;
  localparam integer HEAD_FOOT_ID_WIDTH = 8;
  localparam integer LATER_TIME_STAMP_WIDTH = TIME_STAMP_WIDTH-FIRST_TIME_STAMP_WIDTH;
  localparam integer CHANNEL_ID_WIDTH = 4;
  localparam integer DATA_DELAY_CLK = 1;

  reg [HEADER_FOOTER_WIDTH-1:0] dummy_header_footer = {HEADER_FOOTER_WIDTH{1'b1}};
  reg [ONE_FILL_WIDTH-1:0] one_fill = {ONE_FILL_WIDTH{1'b1}};
  reg [HEAD_FOOT_ID_WIDTH-1:0] header_id = {HEAD_FOOT_ID_WIDTH{1'b1}};
  reg [HEAD_FOOT_ID_WIDTH-1:0] footer_id = {{HEAD_FOOT_ID_WIDTH-4{1'b0}}, {4{1'b1}}};
  reg [CHANNEL_ID_WIDTH-1:0] ch_id = CHANNEL_ID;
  reg [HEADER_FOOTER_WIDTH-CHANNEL_ID_WIDTH-FIRST_TIME_STAMP_WIDTH-HEAD_FOOT_ID_WIDTH-1:0] header_zero_pad = 0;
  reg [HEADER_FOOTER_WIDTH-ONE_FILL_WIDTH*2-ADC_RESOLUTION_WIDTH*2-HEAD_FOOT_ID_WIDTH-LATER_TIME_STAMP_WIDTH-1:0] footer_zero_pad = 0;

  wire [DATA_WIDTH-1:0] combined_header;
  wire [DATA_WIDTH-1:0] combined_footer;
  wire [HEADER_FOOTER_WIDTH-1:0] header;
  wire [HEADER_FOOTER_WIDTH-1:0] footer;
  wire [CHANNEL_ID_WIDTH+FIRST_TIME_STAMP_WIDTH-1:0] ch_id_fst_time_stamp_set;
  wire [LATER_TIME_STAMP_WIDTH-1:0] lat_time_stamp;
  wire [ONE_FILL_WIDTH+ADC_RESOLUTION_WIDTH-1:0] baseline_set;
  wire [ONE_FILL_WIDTH-1+ADC_RESOLUTION_WIDTH+1-1:0] threshold_set;

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

  assign ch_id_fst_time_stamp_set = {ch_id, TIME_STAMP[TIME_STAMP_WIDTH-1 -:FIRST_TIME_STAMP_WIDTH]};
  assign lat_time_stamp = TIME_STAMP[LATER_TIME_STAMP_WIDTH-1:0];
  assign baseline_set = {one_fill, BASELINE_WHEN_HIT};
  assign threshold_set = {{ONE_FILL_WIDTH-1{1'b1}}, THRESHOLD_WHEN_HIT};
  assign header = {header_id, ch_id_fst_time_stamp_set, header_zero_pad};
  assign footer = {baseline_set, threshold_set, footer_zero_pad, lat_time_stamp, footer_id};
  assign combined_header = {dummy_header_footer, header};
  assign combined_footer = {footer, dummy_header_footer};

  assign triggered_posedge = (delayed_triggered == 1'b0 )&&( TRIGGERED == 1'b1);
  assign triggered_negedge = (delayed_triggered == 1'b1 )&&( TRIGGERED == 1'b0);
  assign adding_validD = TRIGGERED||delayed_triggered;
  assign DOUT = dout;
  assign ADDING_VALID = adding_valid; 

  always @( posedge CLK or posedge triggered_posedge or posedge triggered_negedge) begin
    if (triggered_posedge) begin
      doutD <= combined_header;
    end else begin
      if (triggered_negedge) begin
        doutD <= combined_footer;
      end else begin
        doutD <= delayed_data;
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