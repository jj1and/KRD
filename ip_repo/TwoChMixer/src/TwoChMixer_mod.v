`timescale 1 ps / 1 ps

module TwoChMixer_mod # (
  parameter integer DATA_WIDTH = 64

)(
  input wire CLK,
  input wire RESET,

  // channel 0 interface
  input wire [DATA_WIDTH-1:0] CH0_DIN,
  input wire CH0_READ_REQUEST,
  output wire CH0_RE,

  // channel 1 interface
  input wire [DATA_WIDTH-1:0] CH1_DIN,
  input wire CH1_READ_REQUEST,
  output wire CH1_RE,
  
  // handshake signals
  input wire  iREADY,
  output wire [DATA_WIDTH-1:0] DOUT,
  output wire oVALID
);

  localparam integer HEADER_FOOTER_ID_WIDTH = 16;
  localparam integer ID_WIDTH_HEX = HEADER_FOOTER_ID_WIDTH/4;
  
  reg [DATA_WIDTH-1:0] ch0_din;
  reg [DATA_WIDTH-1:0] ch0_header_checked;
  reg [DATA_WIDTH-1:0] ch0_footer_checked;
  reg [DATA_WIDTH-1:0] ch0_correct_data;
  reg ch0_re;
  wire CH0_DIN_header_foundD;
  wire CH0_DIN_footer_foundD;
  wire ch0_header_checked_pauseD;
  wire ch0_footer_checked_pauseD;  
  wire ch0_header_lostD;
  wire ch0_footer_lostD;
  wire ch0_footer_checked_header_foundD;
  wire ch0_correct_data_footer_foundD;
  reg [2:0] ch0_head_foot_id_hist;

  reg [DATA_WIDTH-1:0] ch1_din;
  reg [DATA_WIDTH-1:0] ch1_header_checked;
  reg [DATA_WIDTH-1:0] ch1_footer_checked;
  reg [DATA_WIDTH-1:0] ch1_correct_data;
  reg ch1_re;
  wire CH1_DIN_header_foundD;
  wire CH1_DIN_footer_foundD;
  wire ch1_header_checked_pauseD;
  wire ch1_footer_checked_pauseD;
  wire ch1_header_lostD;
  wire ch1_footer_lostD;
  wire ch1_footer_checked_header_foundD;
  wire ch1_correct_data_footer_foundD;  
  reg [2:0] ch1_head_foot_id_hist;

  wire [1:0] read_request;
  assign read_request = {CH1_READ_REQUEST, CH0_READ_REQUEST};

  reg ch0_sending;
  reg ch1_sending;
  reg sending;
  reg [DATA_WIDTH-1:0] dout;

  reg [15:0] HEADER_ID = 16'hAAAA;
  reg [15:0] FOOTER_ID = 16'h5555;
  reg [15:0] ERROR_HEADER_ID = 16'hAAEE;
  reg [15:0] ERROR_FOOTER_ID = 16'h55EE;

  // 8'hFE or 8'hFF = 7'b1111111
  assign CH0_DIN_header_foundD = (CH0_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==HEADER_ID);
  assign CH1_DIN_header_foundD = (CH1_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==HEADER_ID);
  assign ch0_footer_checked_header_foundD = (ch0_footer_checked[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==HEADER_ID);
  assign ch1_footer_checked_header_foundD = (ch1_footer_checked[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==HEADER_ID);

  // 8'hFE or 8'hFF = 7'b1111111
  assign ch0_header_lostD = (ch0_din[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]!=HEADER_ID)&(ch0_head_foot_id_hist==3'b110);
  assign ch1_header_lostD = (ch1_din[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]!=HEADER_ID)&(ch1_head_foot_id_hist==3'b110);  

  // 8'hEF or 8'h0F = 5'b01111
  assign CH0_DIN_footer_foundD = (CH0_DIN[HEADER_FOOTER_ID_WIDTH-1:0]==FOOTER_ID);
  assign CH1_DIN_footer_foundD = (CH1_DIN[HEADER_FOOTER_ID_WIDTH-1:0]==FOOTER_ID);
  assign ch0_correct_data_footer_foundD = (ch0_correct_data[HEADER_FOOTER_ID_WIDTH-1:0]==FOOTER_ID);
  assign ch1_correct_data_footer_foundD = (ch1_correct_data[HEADER_FOOTER_ID_WIDTH-1:0]==FOOTER_ID);  

  // 8'hFE or 8'hFF = 7'b1111111
  assign ch0_footer_lostD = (ch0_din[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH-1]==HEADER_ID)&((ch0_head_foot_id_hist & 3'b101)==3'b101);
  assign ch1_footer_lostD = (ch1_din[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH-1]==HEADER_ID)&((ch1_head_foot_id_hist & 3'b101)==3'b101);

  assign ch0_header_checked_pauseD = (ch0_header_checked[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH-1]==HEADER_ID)|(ch0_header_checked[HEADER_FOOTER_ID_WIDTH-1:0]==FOOTER_ID);
  assign ch1_header_checked_pauseD = (ch1_header_checked[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH-1]==HEADER_ID)|(ch1_header_checked[HEADER_FOOTER_ID_WIDTH-1:0]==FOOTER_ID);  
  assign ch0_footer_checked_pauseD = (ch0_footer_checked[HEADER_FOOTER_ID_WIDTH-1:0]==FOOTER_ID);
  assign ch1_footer_checked_pauseD = (ch1_footer_checked[HEADER_FOOTER_ID_WIDTH-1:0]==FOOTER_ID);      

  assign CH0_RE = ch0_re;
  assign CH1_RE = ch1_re;
  assign DOUT = dout;
  assign  oVALID = sending;

  always @(posedge CLK ) begin
    if (RESET) begin
      ch0_head_foot_id_hist <= #400 3'b000;
    end else begin
      if (ch0_re) begin
        if (ch0_din[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH-1]=={7{1'b1}}) begin
          ch0_head_foot_id_hist <= #400 {1'b1, ch0_head_foot_id_hist[0], 1'b1 };
        end else begin
          if ((ch0_din[HEADER_FOOTER_ID_WIDTH-4:0]==5'b01111)&(ch0_din[DATA_WIDTH-1 -:2]==2'b11)) begin
            ch0_head_foot_id_hist <= #400 {1'b1,ch0_head_foot_id_hist[0], 1'b0 };
          end else begin
            ch0_head_foot_id_hist <= #400 ch0_head_foot_id_hist;
          end
        end
      end else begin
        ch0_head_foot_id_hist <= #400 ch0_head_foot_id_hist;
      end
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      ch0_re <= #400 1'b0;
    end else begin
      if ((CH0_DIN_footer_foundD|ch0_footer_lostD)) begin
        ch0_re <= #400 1'b0;        
      end else begin
        if ((CH0_READ_REQUEST& iREADY)&(!ch1_re)) begin
          ch0_re <= #400 1'b1;
        end else begin
          ch0_re <= #400 ch0_re;
        end
      end        
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      ch0_din <= #400 {{HEADER_FOOTER_ID_WIDTH{1'b0}}, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
    end else begin
      if (ch0_re) begin
        if (ch0_header_lostD) begin
          ch0_din <= #400 {ERROR_HEADER_ID, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
        end else begin
          ch0_din <= #400 CH0_DIN;
        end
      end else begin
        ch0_din <= #400 ch0_din;
      end
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      ch0_header_checked <= #400 {{HEADER_FOOTER_ID_WIDTH{1'b0}}, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
    end else begin
      if ((ch0_re==1'b0)&ch0_header_checked_pauseD) begin
        ch0_header_checked <= #400 ch0_header_checked;
      end else begin
        ch0_header_checked <= #400 ch0_din;
      end
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      ch0_footer_checked <= #400 {{HEADER_FOOTER_ID_WIDTH{1'b0}}, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
    end else begin
      if ((ch0_re==1'b0)&ch0_footer_checked_pauseD) begin
        ch0_footer_checked <= #400 ch0_footer_checked;
      end else begin
        if (ch0_footer_lostD) begin
          ch0_footer_checked <= #400 {{DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}, ERROR_FOOTER_ID};
        end else begin
          ch0_footer_checked <= #400 ch0_header_checked;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      ch0_correct_data <= #400 {{HEADER_FOOTER_ID_WIDTH{1'b0}}, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
    end else begin
      ch0_correct_data <= #400 ch0_footer_checked;
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      ch0_sending <= #400 1'b0;
    end else begin
      if (ch0_footer_checked_header_foundD) begin
        ch0_sending <= #400 1'b1;
      end else begin
        if (ch0_correct_data_footer_foundD) begin
          ch0_sending <= #400 1'b0;
        end else begin
          ch0_sending <= #400 ch0_sending;
        end
      end
    end
  end


  always @(posedge CLK ) begin
    if (RESET) begin
      ch1_head_foot_id_hist <= #400 3'b000;
    end else begin
      if (ch1_re) begin
        if (ch1_din[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH-1]=={7{1'b1}}) begin
          ch1_head_foot_id_hist <= #400 {1'b1, ch1_head_foot_id_hist[0], 1'b1 };
        end else begin
          if ((ch1_din[HEADER_FOOTER_ID_WIDTH-4:0]==5'b01111)&(ch1_din[DATA_WIDTH-1 -:2]==2'b11)) begin
            ch1_head_foot_id_hist <= #400 {1'b1, ch1_head_foot_id_hist[0], 1'b0 };
          end else begin
            ch1_head_foot_id_hist <= #400 ch1_head_foot_id_hist;
          end
        end
      end else begin
        ch1_head_foot_id_hist <= #400 ch1_head_foot_id_hist;
      end
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      ch1_re <= #400 1'b0;
    end else begin
      if (CH1_DIN_footer_foundD|ch1_footer_lostD) begin
        ch1_re <= #400 1'b0;
      end else begin
        if (((read_request==2'b10)& iREADY)&(!ch0_re)) begin
          ch1_re <= #400 1'b1;
        end else begin
          ch1_re <= #400 ch1_re;
        end
      end        
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      ch1_din <= #400 {{HEADER_FOOTER_ID_WIDTH{1'b0}}, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
    end else begin
      if (ch1_re) begin
        if (ch1_header_lostD) begin
          ch1_din <= #400 {ERROR_HEADER_ID, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
        end else begin
            ch1_din <= #400 CH1_DIN;
        end
      end else begin
        ch1_din <= #400 ch1_din;
      end
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      ch1_header_checked <= #400 {{HEADER_FOOTER_ID_WIDTH{1'b0}}, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
    end else begin
      if ((ch1_re==1'b0)&ch1_header_checked_pauseD) begin
        ch1_header_checked <= #400 ch1_header_checked;
      end else begin
        ch1_header_checked <= #400 ch1_din;
      end
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      ch1_footer_checked <= #400 {{HEADER_FOOTER_ID_WIDTH{1'b0}}, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
    end else begin
      if ((ch1_re==1'b0)&ch1_footer_checked_pauseD) begin
        ch1_footer_checked <= #400 ch1_footer_checked;
      end else begin
        if (ch1_footer_lostD) begin
          ch1_footer_checked <= #400 {{DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}, ERROR_FOOTER_ID};
        end else begin
          ch1_footer_checked <= #400 ch1_header_checked;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      ch1_correct_data <= #400 {{HEADER_FOOTER_ID_WIDTH{1'b0}}, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
    end else begin
      ch1_correct_data <= #400 ch1_footer_checked;
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      ch1_sending <= #400 1'b0;
    end else begin
      if (ch1_footer_checked_header_foundD) begin
        ch1_sending <= #400 1'b1;
      end else begin
        if (ch1_correct_data_footer_foundD) begin
          ch1_sending <= #400 1'b0;
        end else begin
          ch1_sending <= #400 ch1_sending;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (RESET) begin
      dout <= #400 {{HEADER_FOOTER_ID_WIDTH{1'b0}}, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
    end else begin
      if (ch0_sending) begin
        dout <= #400 ch0_correct_data;
      end else begin
        if (ch1_sending) begin
          dout <= #400 ch1_correct_data;
        end else begin
          dout <= #400 dout;
        end
      end
    end
  end


  always @(posedge CLK ) begin
    if (RESET) begin
      sending <= #400 1'b0;
    end else begin
      if (ch0_sending) begin
        sending <= #400 ch0_sending;
      end else begin
        if (ch1_sending) begin
          sending <= #400 ch1_sending;
        end else begin
          sending <= #400 1'b0;
        end
      end
    end
  end

endmodule