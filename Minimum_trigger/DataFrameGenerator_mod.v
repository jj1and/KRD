`timescale 1 ps / 1 ps
module DataFrameGenerator_mod # (

  parameter integer MAX_DELAY_CNT_WIDTH = 5,
  parameter integer MAX_FRAME_LENGTH = 200, 
  parameter integer HEADER_FOOTER_WIDTH = 64,
  parameter integer TIME_STAMP_WIDTH = 48,
  parameter integer FIRST_TIME_STAMP_WIDTH = 24,
  parameter integer ADC_RESOLUTION_WIDTH = 12,
  parameter integer CHANNEL_ID  = 0,
  parameter integer TDATA_WIDTH = 128,
  // INFO_WIDTH = HEADER_FOOTER_WIDTH*2
  parameter integer INFO_WIDTH = 128,
  // DIN WIDTH = TIME_STAMP_WIDTH + (ADC_RESOLUTION_WIDTH+1) + ADC_RESOLUTION_WIDTH
  parameter integer DIN_WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH*2 + ADC_RESOLUTION_WIDTH*2 + 1,
  parameter integer DOUT_WIDTH = 64

)(
  input wire WR_CLK,
  input wire RD_CLK,
  input wire WR_RESETN,
  input wire RD_RESETN,

  input wire [MAX_DELAY_CNT_WIDTH-1:0] PRE_ACQUIASION_LEN, 

  output wire [TDATA_WIDTH-1:0] WRITE_DATA,
  input wire [DOUT_WIDTH-1:0] READ_DATA,
  output wire DATA_FIFO_WE,
  output wire DATA_FIFO_RE,
  input wire DATA_FIFO_FULL,
  input wire DATA_FIFO_EMPTY,
  input wire DATA_FIFO_WR_RST_BUSY,
  input wire DATA_FIFO_RD_RST_BUSY,

  output wire [INFO_WIDTH-1:0] WRITE_INFO,
  input wire [INFO_WIDTH-1:0] READ_INFO,
  output wire INFO_FIFO_WE,
  output wire INFO_FIFO_RE,
  input wire INFO_FIFO_FULL,
  input wire INFO_FIFO_EMPTY,
  input wire INFO_FIFO_WR_RST_BUSY,
  input wire INFO_FIFO_RD_RST_BUSY,

  // handshake signals
  input wire iREADY,
  input wire iVALID,
  input wire [DIN_WIDTH-1:0] DIN,

  output wire oREADY,
  output wire oVALID,
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
  localparam integer HEADER_ZERO_PAD_WIDTH = HEADER_FOOTER_WIDTH-CHANNEL_ID_WIDTH-FIRST_TIME_STAMP_WIDTH-HEAD_FOOT_ID_WIDTH-FRAME_LEN_CNT_WIDTH;
  localparam integer FOOTER_ZERO_PAD_WIDTH = HEADER_FOOTER_WIDTH-ONE_FILL_WIDTH*2-ADC_RESOLUTION_WIDTH*2-HEAD_FOOT_ID_WIDTH-LATER_TIME_STAMP_WIDTH;
  localparam integer FRAME_LEN_CNT_WIDTH = clogb2(MAX_FRAME_LENGTH-1);

  reg [MAX_DELAY_CNT_WIDTH-1:0] extend_len;
  reg extend_trigger;
  reg extend_trigger_delay;
  wire fast_extend_trigger_posedge = (extend_trigger == 1'b1)&(extend_trigger_delay == 1'b0);
  wire fast_extend_trigger_negedge = (extend_trigger == 1'b0)&(extend_trigger_delay == 1'b1);
  reg [FRAME_LEN_CNT_WIDTH:0] frame_len_count;
  
  reg [TDATA_WIDTH-1:0] din;
  reg [TDATA_WIDTH-1:0] write_data;
  reg write_ready;
  reg data_fifo_wen;
  reg info_fifo_wen;

  reg [DOUT_WIDTH-1:0] data_frame;
  reg [FRAME_LEN_CNT_WIDTH:0] frame_len;
  reg [FRAME_LEN_CNT_WIDTH+1:0] frame_len_check_count;
  reg data_fifo_ren;
  reg data_fifo_ren_delay;
  wire fast_data_fifo_ren_posedge = (data_fifo_ren == 1'b1)&(data_fifo_ren_delay == 1'b0);  
  wire fast_data_fifo_ren_negedge = (data_fifo_ren == 1'b0)&(data_fifo_ren_delay == 1'b1);
  reg info_fifo_ren;
  reg info_fifo_ren_delay;
  reg info_fifo_ren_2delay;
  reg info_fifo_empty;
  wire read_ready;
  wire fast_info_fifo_negedge = (INFO_FIFO_EMPTY == 1'b0)&(info_fifo_empty == 1'b1);
  wire data_fifo_read_wait = |{(frame_len_check_count>=frame_len-2)&(frame_len_check_count<=frame_len-1), DATA_FIFO_EMPTY};

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

  assign ch_id_fst_time_stamp_set = {ch_id, din[DIN_WIDTH-TDATA_WIDTH-1 -:FIRST_TIME_STAMP_WIDTH]};

  assign lat_time_stamp = din[DIN_WIDTH-TDATA_WIDTH-FIRST_TIME_STAMP_WIDTH-1 -:LATER_TIME_STAMP_WIDTH];
  assign baseline_set = {{ONE_FILL_WIDTH{1'b1}}, din[DIN_WIDTH-TDATA_WIDTH-TIME_STAMP_WIDTH-1 -:ADC_RESOLUTION_WIDTH]};
  assign threshold_set = {{ONE_FILL_WIDTH-1{1'b1}}, din[DIN_WIDTH-TDATA_WIDTH-TIME_STAMP_WIDTH-ADC_RESOLUTION_WIDTH-1 -:ADC_RESOLUTION_WIDTH+1]};

  generate begin
  if(HEADER_ZERO_PAD_WIDTH>0) begin
      assign tmp_header = {header_id, ch_id_fst_time_stamp_set, {HEADER_ZERO_PAD_WIDTH{1'b0}}, frame_len_count};
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

  assign DATA_FIFO_WE = data_fifo_wen;
  assign INFO_FIFO_WE = info_fifo_wen;
  assign WRITE_DATA = write_data;
  assign WRITE_INFO = {footer, header};

  signal_expansioner # (
    .MAX_EXTEND_LEN_WIDTH(MAX_DELAY_CNT_WIDTH)
  ) triggered_expansion (
    .CLK(WR_CLK),
    .RESETN(WR_RESETN),
    .EXTEND_LEN(extend_len),
    .SIG_IN(iVALID),
    .SIG_OUT(extend_triggered)
  );

  // initializing registers
  always @(posedge WR_CLK ) begin
    if (!WR_RESETN) begin
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

  always @(posedge WR_CLK ) begin
    if (!WR_RESETN) begin
      extend_len <= #400 PRE_ACQUIASION_LEN;
    end else begin
      extend_len <= #400 extend_len;
    end
  end

  always @(posedge WR_CLK ) begin
    if (!write_ready) begin
      extend_trigger_delay <= #400 1'b0;
      din <= #400 {DIN_WIDTH{1'b1}};
      write_data <= #400 {TDATA_WIDTH{1'b1}};
    end else begin
      extend_trigger_delay <= #400 extend_trigger;
      din <= #400 DIN;
      write_data <= #400 din[DIN_WIDTH-1 -:TDATA_WIDTH];
    end
  end

  always @(posedge WR_CLK ) begin
    if (|{~write_ready, ~extend_trigger}) begin
      frame_len_count <= #400 MAX_FRAME_LENGTH;
    end else begin
      if (frame_len_count==MAX_FRAME_LENGTH-1) begin
        frame_len_count <= #400 0;
      end else begin
        frame_len_count <= #400 frame_len_count + 1;
      end
    end
  end

  always @(posedge WR_CLK ) begin
    if (!write_ready) begin
      info_fifo_wen <= #400 1'b0;
    end else begin
      if (|{frame_len_count==MAX_FRAME_LENGTH-1, fast_extend_trigger_negedge}) begin
        info_fifo_wen <= #400 1'b1;
      end else begin
        info_fifo_wen <= #400 1'b0;
      end
    end
  end

  always @(posedge WR_CLK ) begin
    if (!write_ready) begin
      header <= #400 {INFO_WIDTH{1'b1}};
      footer <= #400 {INFO_WIDTH{1'b1}};
    end else begin
      if (|{frame_len_count==MAX_FRAME_LENGTH-1, fast_extend_trigger_negedge}) begin
        header <= #400 tmp_header;
        footer <= #400 tmp_footer;
      end else begin
        header <= #400 header;
        footer <= #400 footer;
      end
    end
  end

  always @(posedge RD_CLK ) begin
    if (~read_ready) begin
      data_fifo_ren_delay <= #400 1'b0;
    end else begin
      data_fifo_ren_delay <= #400 data_fifo_ren;
    end
  end


  always @(posedge RD_CLK ) begin
    if (~read_ready) begin
      frame_len <= #400 0;
    end else begin
      if (info_fifo_ren_2delay) begin
        frame_len <= #400 READ_INFO[0 +:FRAME_LEN_CNT_WIDTH+1] + 1;
      end else begin
        frame_len <= #400 0;
      end
    end
  end

  always @(posedge RD_CLK) begin
    if ({~read_ready, INFO_FIFO_EMPTY}) begin
      info_fifo_ren <= #400 1'b0;
    end else begin
      if (|{fast_info_fifo_negedge, frame_len_check_count==frame_len}) begin
        info_fifo_ren <= #400 1'b1;
      end else begin
        info_fifo_ren <= #400 1'b0;
      end
    end
  end

  always @(posedge RD_CLK ) begin
    if (|{~read_ready, ~data_fifo_ren}) begin
      frame_len_check_count <= #400 frame_len + 2;
    end else begin
      if (frame_len_check_count>=frame_len+1) begin
        frame_len_check_count <= #400 0;
      end else begin
        frame_len_check_count <= #400 + 1;
      end
    end
  end

endmodule