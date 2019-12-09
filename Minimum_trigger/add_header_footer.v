`timescale 1 ps / 1 ps

module add_header_footer #
(
  parameter integer MAX_DELAY_CNT_WIDTH = 5,
  parameter integer MAX_FRAME_LENGTH = 200, 
  parameter integer HEADER_FOOTER_WIDTH = 64,
  parameter integer TIME_STAMP_WIDTH = 48,
  parameter integer FIRST_TIME_STAMP_WIDTH = 24,
  parameter integer ADC_RESOLUTION_WIDTH = 12,
  parameter integer CHANNEL_ID  = 0,
  parameter integer TDATA_WIDTH = 256,
  // DOUT WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH*2 + (ADC_RESOLUTION_WIDTH+1) + ADC_RESOLUTION_WIDTH
  parameter integer DIN_WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH*2 + ADC_RESOLUTION_WIDTH*2 + 1
)(
  input wire CLK,
  input wire RESETN,
  input wire [MAX_DELAY_CNT_WIDTH-1:0] PRE_ACQUIASION_LEN, 
  
  input wire DIN_VALID,
  input wire TRIGGERED,
  input wire [DIN_WIDTH-1:0] DIN,

  output wire [DIN_WIDTH-1:0] FIFO_DIN,
  input wire [DIN_WIDTH-1:0] FIFO_DOUT,
  output wire FIFO_WE,
  output wire FIFO_RE,
  input wire FIFO_FULL,
  input wire FIFO_EMPTY,
  input wire FIFO_RST_BUSY,
  output wire ADD_READY,
  output wire VALID,
  output wire [TDATA_WIDTH-1:0] DOUT
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth);
    begin
      for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
        bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer ONE_FILL_WIDTH = 16 -ADC_RESOLUTION_WIDTH;
  localparam integer HEAD_FOOT_ID_WIDTH = 8;
  localparam integer LATER_TIME_STAMP_WIDTH = TIME_STAMP_WIDTH-FIRST_TIME_STAMP_WIDTH;
  localparam integer CHANNEL_ID_WIDTH = 4;
  localparam integer HEADER_ZERO_PAD_WIDTH = HEADER_FOOTER_WIDTH-CHANNEL_ID_WIDTH-FIRST_TIME_STAMP_WIDTH-HEAD_FOOT_ID_WIDTH;
  localparam integer FOOTER_ZERO_PAD_WIDTH = HEADER_FOOTER_WIDTH-ONE_FILL_WIDTH*2-ADC_RESOLUTION_WIDTH*2-HEAD_FOOT_ID_WIDTH-LATER_TIME_STAMP_WIDTH;
  localparam integer FRAME_LEN_CNT_WIDTH = clogb2(MAX_FRAME_LENGTH-1);

  reg [TDATA_WIDTH-HEADER_FOOTER_WIDTH-1:0] dummy_header_footer;
  reg [HEAD_FOOT_ID_WIDTH-1:0] header_id;
  reg [HEAD_FOOT_ID_WIDTH-1:0] footer_id;
  reg [CHANNEL_ID_WIDTH-1:0] ch_id;

  reg [HEADER_FOOTER_WIDTH-1:0] header;
  reg [HEADER_FOOTER_WIDTH-1:0] footer;

  wire [HEADER_FOOTER_WIDTH-1:0] tmp_header;
  wire [HEADER_FOOTER_WIDTH-1:0] tmp_footer;
  wire [CHANNEL_ID_WIDTH+FIRST_TIME_STAMP_WIDTH-1:0] ch_id_fst_time_stamp_set;
  wire [LATER_TIME_STAMP_WIDTH-1:0] lat_time_stamp;
  wire [ONE_FILL_WIDTH+ADC_RESOLUTION_WIDTH-1:0] baseline_set;
  wire [ONE_FILL_WIDTH-1+ADC_RESOLUTION_WIDTH+1-1:0] threshold_set;

  assign ch_id_fst_time_stamp_set = {ch_id, FIFO_DOUT[DIN_WIDTH-TDATA_WIDTH-1 -:FIRST_TIME_STAMP_WIDTH]};

  assign lat_time_stamp = fifo_dout_buff[DIN_WIDTH-TDATA_WIDTH-FIRST_TIME_STAMP_WIDTH-1 -:LATER_TIME_STAMP_WIDTH];
  assign baseline_set = {{ONE_FILL_WIDTH{1'b1}}, fifo_dout_buff[DIN_WIDTH-TDATA_WIDTH-TIME_STAMP_WIDTH-1 -:ADC_RESOLUTION_WIDTH]};
  assign threshold_set = {{ONE_FILL_WIDTH-1{1'b1}}, fifo_dout_buff[DIN_WIDTH-TDATA_WIDTH-TIME_STAMP_WIDTH-ADC_RESOLUTION_WIDTH-1 -:ADC_RESOLUTION_WIDTH+1]};
  
  generate begin
    if(HEADER_ZERO_PAD_WIDTH>0) begin
      assign tmp_header = {header_id, ch_id_fst_time_stamp_set, {HEADER_ZERO_PAD_WIDTH{1'b0}}};
    end else begin
      assign tmp_header = {header_id, ch_id_fst_time_stamp_set}; 
    end
  end
  endgenerate
  
  generate begin
    if(FOOTER_ZERO_PAD_WIDTH>0) begin
      assign tmp_footer = {baseline_set, threshold_set, {FOOTER_ZERO_PAD_WIDTH{1'b0}}, lat_time_stamp, footer_id};
    end else begin
      assign tmp_footer = {baseline_set, threshold_set, lat_time_stamp, footer_id};
    end
  end
  endgenerate

  reg [MAX_DELAY_CNT_WIDTH-1:0] extend_len;
  wire extend_triggered;
  reg [DIN_WIDTH-1:0] din;

  reg [DIN_WIDTH-1:0] fifo_dout_buff;
  wire [TDATA_WIDTH-1:0] fifo_dout_data;
  reg fifo_re;
  reg fifo_re_delay;
  wire fast_fifo_re_posedge;
  reg fifo_empty;
  reg fifo_empty_delay;
  wire fast_fifo_empty_posedge;
  wire fast_fifo_empty_negedge;
  wire fifo_empty_posedge;

  reg [TDATA_WIDTH-1:0] data_frame;
  reg [TDATA_WIDTH-1:0] dout;
  reg valid;

  reg [FRAME_LEN_CNT_WIDTH:0] frame_len_count;
  reg inital_flag;

  wire header_change;
  reg header_change_delay;
  wire fast_header_change_posedge; 

  wire read_stop;
  wire read_start;

  wire add_header;
  reg add_footer;

  assign FIFO_DIN = din;
  assign FIFO_WE = &{extend_triggered, ~FIFO_FULL, ~FIFO_RST_BUSY};
  assign FIFO_RE = fifo_re;

  assign fifo_dout_data = fifo_dout_buff[DIN_WIDTH-1 -:TDATA_WIDTH];
  assign fast_fifo_empty_negedge = (FIFO_EMPTY == 1'b0)&(fifo_empty == 1'b1);
  assign fast_fifo_empty_posedge = (FIFO_EMPTY == 1'b1)&(fifo_empty == 1'b0); 
  assign fifo_empty_posedge = (fifo_empty == 1'b1)&(fifo_empty_delay == 1'b0);
  assign fast_fifo_re_posedge = (fifo_re == 1'b1)&(fifo_re_delay == 1'b0);

  assign header_change = (header!=tmp_header);
  assign add_header = (frame_len_count == 0);
  assign read_start = |{fast_fifo_empty_negedge, add_header};
  assign read_stop = (~inital_flag)&(|{fast_fifo_empty_posedge, (frame_len_count == MAX_FRAME_LENGTH-2), header_change});

  assign DOUT = data_frame;
  assign VALID = valid;
  assign ADD_READY = &{~FIFO_FULL, ~FIFO_RST_BUSY};

  signal_expansioner # (
    .MAX_EXTEND_LEN_WIDTH(MAX_DELAY_CNT_WIDTH)
  ) triggered_expansion (
    .CLK(CLK),
    .RESETN(RESETN),
    .EXTEND_LEN(extend_len),
    .SIG_IN(TRIGGERED&DIN_VALID),
    .SIG_OUT(extend_triggered)
  );

  // initializing registers
  always @(posedge CLK ) begin
    if (!RESETN) begin
      dummy_header_footer <= #400 {TDATA_WIDTH-HEADER_FOOTER_WIDTH{1'b1}};
      header_id <= #400 {HEAD_FOOT_ID_WIDTH{1'b1}};
      footer_id <= #400 {{HEAD_FOOT_ID_WIDTH-4{1'b0}}, {4{1'b1}}};
      ch_id <= #400 CHANNEL_ID;      
    end else begin
      dummy_header_footer <= #400 {TDATA_WIDTH-HEADER_FOOTER_WIDTH{1'b1}};
      header_id <= #400 {HEAD_FOOT_ID_WIDTH{1'b1}};
      footer_id <= #400 {{HEAD_FOOT_ID_WIDTH-4{1'b0}}, {4{1'b1}}};
      ch_id <= #400 CHANNEL_ID;             
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      extend_len <= #400 PRE_ACQUIASION_LEN;
    end else begin
      extend_len <= #400 extend_len;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      din <= #400 {DIN_WIDTH{1'b1}};
    end else begin
      din <= #400 DIN;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      fifo_empty <= #400 1'b1;
      fifo_empty_delay <= #400 1'b1;
      fifo_re_delay <= #400 1'b0;
    end else begin
      fifo_empty <= #400 FIFO_EMPTY;
      fifo_empty_delay <= #400 fifo_empty;
      fifo_re_delay <= #400 fifo_re;
    end
  end

  always @(posedge CLK ) begin
    if (|{~RESETN, FIFO_EMPTY, read_stop}) begin
      fifo_re <= #400 1'b0;
    end else begin
      if (read_start) begin
        fifo_re <= #400 1'b1;
      end else begin
        fifo_re <= #400 fifo_re;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      inital_flag <= #400 1'b1;
    end else begin
      if (fifo_empty_posedge) begin
        inital_flag <= #400 1'b1;
      end else begin
        if (fast_fifo_re_posedge) begin
          inital_flag <= #400 1'b0;
        end else begin
          inital_flag <= #400 inital_flag;
        end        
      end
    end
  end

  always @(posedge CLK ) begin
    if (|{~RESETN, read_start}) begin
      add_footer <= #400 1'b0;
    end else begin
      if (read_stop&(frame_len_count!=MAX_FRAME_LENGTH)) begin
        add_footer <= #400 1'b1;
      end else begin
        add_footer <= #400 1'b0;
      end
    end
  end

  always @(posedge CLK ) begin
    if (|{FIFO_EMPTY, inital_flag}) begin
      frame_len_count <= #400 MAX_FRAME_LENGTH;
    end else begin
      if (frame_len_count>=MAX_FRAME_LENGTH-1) begin
        frame_len_count <= #400 0;
      end else begin
        frame_len_count <= #400 frame_len_count + 1;
      end
    end
  end

  always @(posedge CLK ) begin
    if (inital_flag) begin
      header <= #400 {HEADER_FOOTER_WIDTH{1'b1}};
    end else begin
      if (read_stop) begin
        header <= #400 tmp_header;
      end else begin
        header <= #400 header;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      footer <= #400 {HEADER_FOOTER_WIDTH{1'b1}};
    end else begin
      if (add_header) begin
        footer <= #400 tmp_footer;
      end else begin
        if (read_start) begin
          footer <= #400 {HEADER_FOOTER_WIDTH{1'b1}};
        end else begin
          footer <= #400 footer;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      fifo_dout_buff <= #400 {DIN_WIDTH{1'b1}};
    end else begin
      if (fifo_re) begin
        fifo_dout_buff <= #400 FIFO_DOUT;
      end else begin
        fifo_dout_buff <= #400 fifo_dout_buff;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      data_frame <= #400 {TDATA_WIDTH{1'b1}};
    end else begin
      if (add_footer) begin
        data_frame <= #400 {dummy_header_footer, footer};
      end else begin
        if (add_header) begin
          data_frame <= #400 {header, dummy_header_footer};
        end else begin
          data_frame <= #400 fifo_dout_data;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (inital_flag) begin
      valid <= #400 1'b0;
    end else begin
      if (read_start) begin
        valid <= #400 1'b1;
      end else begin
        valid <= #400 valid;
      end
    end
  end


endmodule 