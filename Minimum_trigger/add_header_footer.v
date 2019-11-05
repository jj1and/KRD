`timescale 1 ns / 1 ps

module add_header_footer #
(
  parameter integer DATA_WIDTH = 128,
  parameter integer MAX_DELAY_CNT_WIDTH = 5,
  parameter integer HEADER_FOOTER_WIDTH = 64,
  parameter integer TIME_STAMP_WIDTH = 48,
  parameter integer FIRST_TIME_STAMP_WIDTH = 24,
  parameter integer ADC_RESOLUTION_WIDTH = 12,
  parameter integer CHANNEL_ID  = 0
)(
  input wire CLK,
  input wire RESETN,
  input wire DIN_VALID,
  input wire TRIGGERED,
  input wire [MAX_DELAY_CNT_WIDTH-1:0] DELAY,
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
  localparam integer HEADER_ZERO_PAD_WIDTH = HEADER_FOOTER_WIDTH-CHANNEL_ID_WIDTH-FIRST_TIME_STAMP_WIDTH-HEAD_FOOT_ID_WIDTH;
  localparam integer FOOTER_ZERO_PAD_WIDTH = HEADER_FOOTER_WIDTH-ONE_FILL_WIDTH*2-ADC_RESOLUTION_WIDTH*2-HEAD_FOOT_ID_WIDTH-LATER_TIME_STAMP_WIDTH;

  reg [HEADER_FOOTER_WIDTH-1:0] dummy_header_footer = {HEADER_FOOTER_WIDTH{1'b1}};
  reg [ONE_FILL_WIDTH-1:0] one_fill = {ONE_FILL_WIDTH{1'b1}};
  reg [HEAD_FOOT_ID_WIDTH-1:0] header_id = {HEAD_FOOT_ID_WIDTH{1'b1}};
  reg [HEAD_FOOT_ID_WIDTH-1:0] footer_id = {{HEAD_FOOT_ID_WIDTH-4{1'b0}}, {4{1'b1}}};
  reg [CHANNEL_ID_WIDTH-1:0] ch_id = CHANNEL_ID;

  wire [DATA_WIDTH-1:0] combined_header;
  wire [DATA_WIDTH-1:0] combined_footer;
  wire [HEADER_FOOTER_WIDTH-1:0] header;
  wire [HEADER_FOOTER_WIDTH-1:0] footer;
  wire [CHANNEL_ID_WIDTH+FIRST_TIME_STAMP_WIDTH-1:0] ch_id_fst_time_stamp_set;
  wire [LATER_TIME_STAMP_WIDTH-1:0] lat_time_stamp;
  wire [ONE_FILL_WIDTH+ADC_RESOLUTION_WIDTH-1:0] baseline_set;
  wire [ONE_FILL_WIDTH-1+ADC_RESOLUTION_WIDTH+1-1:0] threshold_set;

  reg [MAX_DELAY_CNT_WIDTH-1:0] pre_extend_len = 12/2;
  reg [MAX_DELAY_CNT_WIDTH-1:0] extend_len = 12/2+{{MAX_DELAY_CNT_WIDTH-2{1'b0}}, 2'd2};
  reg triggered_delay = 1'b0;
  wire extend_triggered;
  wire pre_extend_triggered;
  reg pre_extend_triggered_delay = 1'b0;

  reg [DATA_WIDTH-1:0] din = {DATA_WIDTH{1'b1}};

  wire fast_triggered_posedge;
  wire fast_pre_extend_negedge;

  reg [DATA_WIDTH-1:0] dout = {DATA_WIDTH{1'b1}};

  assign ch_id_fst_time_stamp_set = {ch_id, TIME_STAMP[TIME_STAMP_WIDTH-1 -:FIRST_TIME_STAMP_WIDTH]};
  assign lat_time_stamp = TIME_STAMP[LATER_TIME_STAMP_WIDTH-1:0];
  assign baseline_set = {one_fill, BASELINE_WHEN_HIT};
  assign threshold_set = {{ONE_FILL_WIDTH-1{1'b1}}, THRESHOLD_WHEN_HIT};
  
  generate begin
    if(HEADER_ZERO_PAD_WIDTH>0) begin
      reg [HEADER_ZERO_PAD_WIDTH-1:0] header_zero_pad = 0;
      assign header = {header_id, ch_id_fst_time_stamp_set, header_zero_pad};
    end else begin
      assign header = {header_id, ch_id_fst_time_stamp_set}; 
    end
  end
  endgenerate
  
  generate begin
    if(FOOTER_ZERO_PAD_WIDTH>0) begin
      reg [FOOTER_ZERO_PAD_WIDTH-1:0] footer_zero_pad = 0;
      assign footer = {baseline_set, threshold_set, footer_zero_pad, lat_time_stamp, footer_id};
    end else begin
      assign footer = {baseline_set, threshold_set, lat_time_stamp, footer_id};
    end
  end
  endgenerate
  
  assign combined_header = {dummy_header_footer, header};
  assign combined_footer = {footer, dummy_header_footer};

  assign fast_triggered_posedge = (TRIGGERED == 1'b1)&(triggered_delay == 1'b0);
  assign fast_pre_extend_negedge = (pre_extend_triggered == 1'b0)&(pre_extend_triggered_delay == 1'b1);
  assign DOUT = dout;
  assign ADDING_VALID = extend_triggered;

  signal_expansioner # (
    .MAX_EXTEND_LEN_WIDTH(MAX_DELAY_CNT_WIDTH)
  ) triggered_expansion (
    .CLK(CLK),
    .RESETN(RESETN),
    .EXTEND_LEN(extend_len),
    .SIG_IN(TRIGGERED&DIN_VALID),
    .SIG_OUT(extend_triggered)
  );

  signal_expansioner # (
    .MAX_EXTEND_LEN_WIDTH(MAX_DELAY_CNT_WIDTH)
  ) pre_triggered_expansion (
    .CLK(CLK),
    .RESETN(RESETN),
    .EXTEND_LEN(pre_extend_len),
    .SIG_IN(TRIGGERED&DIN_VALID),
    .SIG_OUT(pre_extend_triggered)
  );

  always @(posedge CLK ) begin
    if (!RESETN) begin
      pre_extend_len <= DELAY;
      extend_len <= DELAY+{{MAX_DELAY_CNT_WIDTH-2{1'b0}}, 2'd2};
    end else begin
      pre_extend_len <= pre_extend_len;
      extend_len <= extend_len;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      pre_extend_triggered_delay <= 1'b0;
      triggered_delay <= 1'b0;
    end else begin
      pre_extend_triggered_delay <= pre_extend_triggered;
      triggered_delay <= TRIGGERED;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      din <= {DATA_WIDTH{1'b1}};
    end else begin
      din <= DIN;
    end
  end  

  always @( posedge CLK ) begin
    if (fast_triggered_posedge) begin
      dout <= combined_header;
    end else begin
      if (fast_pre_extend_negedge) begin
        dout <= combined_footer;
      end else begin
        dout <= din;
      end
    end
  end

endmodule 