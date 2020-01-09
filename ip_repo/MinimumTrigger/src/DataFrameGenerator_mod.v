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
  // DIN WIDTH = TIME_STAMP_WIDTH + (ADC_RESOLUTION_WIDTH+1) + ADC_RESOLUTION_WIDTH
  parameter integer DIN_WIDTH = TDATA_WIDTH + TIME_STAMP_WIDTH + ADC_RESOLUTION_WIDTH*2 + 1,
  parameter integer DOUT_WIDTH = 64,
  // INFO_WIDTH = HEADER_FOOTER_WIDTH*2
  parameter integer INFO_WIDTH = DOUT_WIDTH*2
)(
  input wire WR_CLK,
  input wire RD_CLK,
  input wire WR_RESET,
  input wire RD_RESET,

  input wire [MAX_DELAY_CNT_WIDTH-1:0] PRE_ACQUIASION_LEN, 

  output wire [TDATA_WIDTH-1:0] WRITTEN_DATA,
  input wire [DOUT_WIDTH-1:0] READ_DATA,
  output wire DATA_FIFO_WE,
  output wire DATA_FIFO_RE,
  input wire DATA_FIFO_FULL,
  input wire DATA_FIFO_EMPTY,
  input wire DATA_FIFO_WR_RST_BUSY,
  input wire DATA_FIFO_RD_RST_BUSY,

  output wire [INFO_WIDTH-1:0] WRITTEN_INFO,
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
  output wire [DOUT_WIDTH-1:0] DOUT

);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth);
      begin
      for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
          bit_depth = bit_depth >> 1;
      end
  endfunction

  localparam integer LEN_DIFF = TDATA_WIDTH/DOUT_WIDTH;
  localparam integer BIT_DIFF = clogb2(LEN_DIFF-1);
  localparam integer ONE_FILL_WIDTH = 16 -ADC_RESOLUTION_WIDTH;
  localparam integer HEAD_FOOT_ID_WIDTH = 8;
  localparam integer LATER_TIME_STAMP_WIDTH = TIME_STAMP_WIDTH-FIRST_TIME_STAMP_WIDTH;
  localparam integer CHANNEL_ID_WIDTH = 4;
  localparam integer MAX_FRAME_LENGTH_ROUND_DOWN = (MAX_FRAME_LENGTH/2);
  localparam integer ACTUAL_MAX_FRAME_LENGTH = MAX_FRAME_LENGTH_ROUND_DOWN*2;
  localparam integer FRAME_LEN_CNT_WIDTH = clogb2(ACTUAL_MAX_FRAME_LENGTH-1);
  localparam integer BIT_WIDTH_DIFF = TDATA_WIDTH/DOUT_WIDTH;
  localparam integer HEADER_ZERO_PAD_WIDTH = HEADER_FOOTER_WIDTH-CHANNEL_ID_WIDTH-FIRST_TIME_STAMP_WIDTH-HEAD_FOOT_ID_WIDTH;
  localparam integer FOOTER_ZERO_PAD_WIDTH = HEADER_FOOTER_WIDTH-ONE_FILL_WIDTH*2-ADC_RESOLUTION_WIDTH*2-HEAD_FOOT_ID_WIDTH-LATER_TIME_STAMP_WIDTH;  

  reg [MAX_DELAY_CNT_WIDTH-1:0] extend_len;
  wire extend_trigger;
  reg extend_trigger_delay;
  wire fast_extend_trigger_posedge = (extend_trigger == 1'b1)&(extend_trigger_delay == 1'b0);
  wire fast_extend_trigger_negedge = (extend_trigger == 1'b0)&(extend_trigger_delay == 1'b1);
  reg fast_extend_trigger_negedge_delay;
  reg [FRAME_LEN_CNT_WIDTH:0] frame_len_count;
  reg even_en;
  reg data_fifo_wen;
  
  reg [DIN_WIDTH-1:0] din;
  reg [TDATA_WIDTH-1:0] written_data;
  wire write_ready = ~|{WR_RESET, DATA_FIFO_FULL, INFO_FIFO_FULL, DATA_FIFO_WR_RST_BUSY, INFO_FIFO_WR_RST_BUSY};
  reg info_fifo_wen;

  reg [DOUT_WIDTH-1:0] data_frameD;
  reg [DOUT_WIDTH-1:0] data_frame;
  reg data_frame_validD;
  reg data_frame_valid;
  reg [FRAME_LEN_CNT_WIDTH+BIT_DIFF:0] frame_len;
  wire [FRAME_LEN_CNT_WIDTH+BIT_DIFF:0] actual_frame_len = LEN_DIFF*(frame_len_count+1);
  reg [FRAME_LEN_CNT_WIDTH+BIT_DIFF:0] frame_len_check_count;
  wire [FRAME_LEN_CNT_WIDTH+BIT_DIFF:0] frame_len_init_val = 2**(FRAME_LEN_CNT_WIDTH+BIT_DIFF+1)-1;
  reg data_fifo_ren;
  reg data_fifo_ren_delay;
  reg data_fifo_ren_2delay;
  wire fast_data_fifo_ren_posedge = (data_fifo_ren == 1'b1)&(data_fifo_ren_delay == 1'b0);  
  wire fast_data_fifo_ren_delay_posedge = (data_fifo_ren_delay == 1'b1)&(data_fifo_ren_2delay == 1'b0);  
  reg info_fifo_ren;
  reg info_fifo_ren_delay;
  reg info_fifo_ren_2delay;
  reg info_fifo_empty_delay;
  reg info_fifo_empty_2delay;
  wire read_ready = ~|{RD_RESET, DATA_FIFO_RD_RST_BUSY, INFO_FIFO_RD_RST_BUSY};
  wire fast_info_fifo_empty_negedge = (INFO_FIFO_EMPTY == 1'b0)&(info_fifo_empty_delay == 1'b1);
  wire data_fifo_read_wait = |{frame_len_check_count==frame_len, frame_len_check_count==frame_len+1};
  wire add_headerD = (frame_len_check_count==0);
  wire add_footerD = (frame_len_check_count == frame_len+1); 

  reg [TDATA_WIDTH-HEADER_FOOTER_WIDTH-1:0] dummy_header_footer;
  reg [HEAD_FOOT_ID_WIDTH-1:0] header_id;
  reg [HEAD_FOOT_ID_WIDTH-1:0] footer_id;
  reg [CHANNEL_ID_WIDTH-1:0] ch_id;

  reg [HEADER_FOOTER_WIDTH-1:0] header;
  reg [HEADER_FOOTER_WIDTH-1:0] footer;
  reg [HEADER_FOOTER_WIDTH-1:0] written_header;
  reg [HEADER_FOOTER_WIDTH-1:0] written_footer;  

  wire [HEADER_FOOTER_WIDTH-1:0] tmp_header;
  wire [HEADER_FOOTER_WIDTH-1:0] tmp_footer;
  reg [CHANNEL_ID_WIDTH+FIRST_TIME_STAMP_WIDTH-1:0] ch_id_fst_time_stamp_set;
  reg [LATER_TIME_STAMP_WIDTH-1:0] lat_time_stamp;
  reg [ONE_FILL_WIDTH+ADC_RESOLUTION_WIDTH-1:0] baseline_set;
  reg [ONE_FILL_WIDTH-1+ADC_RESOLUTION_WIDTH+1-1:0] threshold_set;

  assign oREADY = write_ready;
  assign DATA_FIFO_WE = data_fifo_wen;
  assign INFO_FIFO_WE = info_fifo_wen;
  // genvar i;
  // generate
  // begin
  //   for ( i=0 ; i<BIT_WIDTH_DIFF ; i=i+1 ) begin
  //     assign WRITTEN_DATA[DOUT_WIDTH*i +:DOUT_WIDTH] = written_data[TDATA_WIDTH-1-DOUT_WIDTH*i -:DOUT_WIDTH];
  //   end
  // end
  // endgenerate
  assign WRITTEN_DATA = written_data;
  assign WRITTEN_INFO = {written_footer, written_header};

  assign DATA_FIFO_RE = data_fifo_ren&(!data_fifo_read_wait);
  assign INFO_FIFO_RE = info_fifo_ren;
  assign DOUT = data_frame;
  assign oVALID = data_frame_valid;

  SignalExpansioner # (
    .MAX_EXTEND_LEN_WIDTH(MAX_DELAY_CNT_WIDTH)
  ) triggered_expansion (
    .CLK(WR_CLK),
    .RESET(WR_RESET),
    .EXTEND_LEN(extend_len),
    .SIG_IN(iVALID),
    .SIG_OUT(extend_trigger)
  );

  // initializing registers
  always @(posedge WR_CLK ) begin
    if (WR_RESET) begin
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
    if (WR_RESET) begin
      extend_len <= #400 PRE_ACQUIASION_LEN;
    end else begin
      extend_len <= #400 extend_len;
    end
  end

  always @(posedge WR_CLK ) begin
    if (WR_RESET) begin
      extend_trigger_delay <= #400 1'b0;
      fast_extend_trigger_negedge_delay <= #400 1'b0;
      din <= #400 {DIN_WIDTH{1'b1}};
      written_data <= #400 {TDATA_WIDTH{1'b1}};
    end else begin
      extend_trigger_delay <= #400 extend_trigger;
      fast_extend_trigger_negedge_delay <= #400 fast_extend_trigger_negedge;
      din <= #400 DIN;
      written_data <= #400 din[DIN_WIDTH-1 -:TDATA_WIDTH];
    end
  end

  always @(posedge WR_CLK ) begin
    if (~&{!WR_RESET, extend_trigger|extend_trigger_delay}) begin
      even_en <= #400 1'b1;
    end else begin
      if (frame_len_count==0) begin
        even_en <= #400 1'b1;
      end else begin
        even_en <= #400 even_en + 1;
      end 
    end
  end

  always @(posedge WR_CLK ) begin
    if (|{!write_ready, !(extend_trigger|extend_trigger_delay)}) begin
      frame_len_count <= #400 ACTUAL_MAX_FRAME_LENGTH;
    end else begin
      if (fast_extend_trigger_posedge) begin
        frame_len_count <= #400 0;
      end else begin
      if (frame_len_count==ACTUAL_MAX_FRAME_LENGTH-1) begin
        frame_len_count <= #400 0;
      end else begin
        frame_len_count <= #400 frame_len_count + 1;
      end      
      end
    end
  end

  always @(posedge WR_CLK ) begin
    if (!write_ready) begin
      data_fifo_wen <= #400 1'b0;
    end else begin
      if (extend_trigger) begin
        data_fifo_wen <= #400 1'b1;
      end else begin
        if (|{fast_extend_trigger_negedge&even_en, fast_extend_trigger_negedge_delay&even_en}) begin
          data_fifo_wen <= #400 1'b0;
        end else begin
          data_fifo_wen <= #400 data_fifo_wen;
        end
      end
    end
  end

  always @(posedge WR_CLK ) begin
    if (!write_ready) begin
      info_fifo_wen <= #400 1'b0;
    end else begin
      if (extend_trigger&(frame_len_count==ACTUAL_MAX_FRAME_LENGTH-1)) begin
        info_fifo_wen <= #400 1'b1;
      end else begin
        if (|{fast_extend_trigger_negedge&even_en, fast_extend_trigger_negedge_delay&even_en}) begin
          info_fifo_wen <= #400 1'b1;
        end else begin
          info_fifo_wen <= #400 1'b0;
        end
      end        
    end
  end

  always @(posedge WR_CLK ) begin
    if (WR_RESET) begin
      ch_id_fst_time_stamp_set <= #400 {CHANNEL_ID_WIDTH+FIRST_TIME_STAMP_WIDTH{1'b1}};
      lat_time_stamp <= #400 {LATER_TIME_STAMP_WIDTH{1'b1}};
      baseline_set <= #400 {{ONE_FILL_WIDTH{1'b1}}, {ADC_RESOLUTION_WIDTH{1'b1}}};
      threshold_set <= #400 {{ONE_FILL_WIDTH-1{1'b1}}, {ADC_RESOLUTION_WIDTH+1{1'b1}}};  
    end else begin
      ch_id_fst_time_stamp_set <= #400 {ch_id, din[DIN_WIDTH-TDATA_WIDTH-LATER_TIME_STAMP_WIDTH-1 -:FIRST_TIME_STAMP_WIDTH]};
      lat_time_stamp <= #400 din[DIN_WIDTH-TDATA_WIDTH-1 -:LATER_TIME_STAMP_WIDTH];
      baseline_set <= #400 {{ONE_FILL_WIDTH{1'b1}}, din[DIN_WIDTH-TDATA_WIDTH-TIME_STAMP_WIDTH-1 -:ADC_RESOLUTION_WIDTH]};
      threshold_set <= #400 {{ONE_FILL_WIDTH-1{1'b1}}, din[DIN_WIDTH-TDATA_WIDTH-TIME_STAMP_WIDTH-ADC_RESOLUTION_WIDTH-1 -:ADC_RESOLUTION_WIDTH+1]};        
    end
  end

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

  always @(posedge WR_CLK ) begin
    if (!write_ready) begin
      header <= #400 {INFO_WIDTH{1'b1}};
      footer <= #400 {INFO_WIDTH{1'b1}};    
    end else begin
      if (frame_len_count==0) begin
        header <= #400 tmp_header;
        footer <= #400 tmp_footer;
      end else begin
        header <= #400 header;
        footer <= #400 footer;
      end
    end
  end

  always @(posedge WR_CLK ) begin
    if (!write_ready) begin
      written_header <= #400 {INFO_WIDTH{1'b1}};
      written_footer <= #400 {INFO_WIDTH{1'b1}};
    end else begin
      if (|{frame_len_count==ACTUAL_MAX_FRAME_LENGTH-1, fast_extend_trigger_negedge&even_en, fast_extend_trigger_negedge_delay&even_en}) begin
        written_header <= #400 {header[HEADER_FOOTER_WIDTH-1:FRAME_LEN_CNT_WIDTH+BIT_DIFF+1], actual_frame_len};
        written_footer <= #400 footer;
      end else begin
        written_header <= #400 written_header;
        written_footer <= #400 written_footer;
      end
    end
  end

  always @(posedge RD_CLK ) begin
    if (!read_ready) begin
      data_fifo_ren_delay <= #400 1'b0;
      data_fifo_ren_2delay <= #400 1'b0;
    end else begin
      data_fifo_ren_delay <= #400 data_fifo_ren;
      data_fifo_ren_2delay <= #400 data_fifo_ren_delay;
    end
  end

  always @(posedge RD_CLK ) begin
    if (!read_ready) begin
      info_fifo_ren_delay <= #400 1'b0;
      info_fifo_ren_2delay <= #400 1'b0;
    end else begin
      info_fifo_ren_delay <= #400 info_fifo_ren;
      info_fifo_ren_2delay <= #400 info_fifo_ren_delay;
    end
  end

  always @(posedge RD_CLK ) begin
    if (!read_ready) begin
      info_fifo_empty_delay <= #400 1'b1;
      info_fifo_empty_2delay <= #400 1'b1;
    end else begin
      info_fifo_empty_delay <= #400 INFO_FIFO_EMPTY;
      info_fifo_empty_2delay <= #400 info_fifo_empty_delay;
    end
  end  

  always @(posedge RD_CLK) begin
    if (|{!read_ready, INFO_FIFO_EMPTY, DATA_FIFO_EMPTY}) begin
      info_fifo_ren <= #400 1'b0;
    end else begin
      if ((&{fast_info_fifo_empty_negedge, iREADY, !data_fifo_ren})|(frame_len_check_count==frame_len-2)) begin
        info_fifo_ren <= #400 1'b1;
      end else begin
        info_fifo_ren <= #400 1'b0;
      end
    end
  end

  always @(posedge RD_CLK ) begin
    if (!read_ready) begin
      frame_len <= #400 {MAX_DELAY_CNT_WIDTH{1'b1}};
    end else begin
      if (info_fifo_ren_2delay) begin
        frame_len <= #400 READ_INFO[0 +:FRAME_LEN_CNT_WIDTH+BIT_DIFF+1];
      end else begin
        frame_len <= #400 frame_len;
      end
    end
  end

  always @(posedge RD_CLK) begin
    if (|{!read_ready, DATA_FIFO_EMPTY}) begin
      data_fifo_ren <= #400 1'b0;
    end else begin
      if (&{info_fifo_ren_2delay, frame_len_check_count==frame_len_init_val}) begin
        data_fifo_ren <= #400 1'b1;
      end else begin
        if (&{info_fifo_empty_2delay, frame_len_check_count>=frame_len-1}) begin
          data_fifo_ren <= #400 1'b0;
        end else begin
          data_fifo_ren <= #400 data_fifo_ren;
        end
      end
    end
  end

  always @(posedge RD_CLK ) begin
    if (!read_ready) begin
      frame_len_check_count <= #400 frame_len_init_val;
    end else begin
      if (info_fifo_ren_2delay) begin
        frame_len_check_count <= #400 0; 
      end else begin
        if (data_fifo_ren|data_fifo_ren_2delay) begin
          frame_len_check_count <= #400 frame_len_check_count + 1;     
        end else begin
          frame_len_check_count <= #400 frame_len_init_val;
        end  
      end
    end
  end

  always @(*) begin
      if (add_headerD) begin
        data_frameD = READ_INFO[0 +:DOUT_WIDTH];
      end else begin
        if (add_footerD) begin
          data_frameD = READ_INFO[INFO_WIDTH-1 -:DOUT_WIDTH];
        end else begin
          data_frameD = READ_DATA;
        end
      end
  end

  always @(posedge RD_CLK) begin
    if (!read_ready) begin
      data_frame <= #400 {DOUT_WIDTH{1'b1}};
      data_frame_valid <= #400 {DOUT_WIDTH{1'b0}}; 
    end else begin
      data_frame <= #400 data_frameD;
      data_frame_valid <= #400 data_frame_validD;
    end
  end

  always @(posedge RD_CLK ) begin
    if (!read_ready) begin
      data_frame_validD <= #400 1'b0;
    end else begin
      if (info_fifo_ren_2delay) begin
        data_frame_validD <= #400 1'b1;
      end else begin
        if (&{add_footerD, !data_fifo_ren}) begin
          data_frame_validD <= #400 1'b0;
        end else begin
          data_frame_validD <= #400 data_frame_validD;
        end
      end
    end
  end

endmodule