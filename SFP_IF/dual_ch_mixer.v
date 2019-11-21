`timescale 1 ps / 1 ps

module dual_ch_mixer # (
  parameter integer DATA_WIDTH = 64

)(
  input wire CLK,
  input wire RESETN,

  // channel 0 interface
  input wire [DATA_WIDTH-1:0] CH0_DIN,
  input wire CH0_READ_REQUEST,
  output wire CH0_RE,

  // channel 1 interface
  input wire [DATA_WIDTH-1:0] CH1_DIN,
  input wire CH1_READ_REQUEST,
  output wire CH1_RE,
  
  // Interface of FIFO for serialized data
  input wire READY,
  output wire [DATA_WIDTH-1:0] DOUT,
  output wire SENDING
);

  localparam integer HEADER_FOOTER_ID_WIDTH = 8;
  
  reg [DATA_WIDTH-1:0] ch0_din;
  reg ch0_read_request_delay;
  wire ch0_request_fast_posedge;
  reg ch0_re;
  reg ch0_re_delay;
  wire dout_is_ch0;
  wire ch0_header_foundD;
  wire ch0_footer_foundD;
  reg ch0_header_found;
  reg ch0_footer_found;  
  wire ch0_header_lostD;
  wire ch0_footer_lostD;
  reg ch0_header_lost;
  reg ch0_footer_lost;  
  reg [2:0] ch0_head_foot_id_hist;

  reg [DATA_WIDTH-1:0] ch1_din;
  reg ch1_read_request_delay;
  wire ch1_request_fast_posedge;
  reg ch1_re;
  reg ch1_re_delay;
  wire dout_is_ch1;
  wire ch1_header_foundD;
  wire ch1_footer_foundD;
  reg ch1_header_found;
  reg ch1_footer_found;
  wire ch1_header_lostD;
  wire ch1_footer_lostD;
  reg ch1_header_lost;
  reg ch1_footer_lost;  
  reg [2:0] ch1_head_foot_id_hist;

  wire [1:0] read_request;
  assign read_request = {CH1_READ_REQUEST, CH0_READ_REQUEST};

  wire read_enables;
  reg read_enables_delay;
  reg read_enables_negedge;

  wire ch_send_readys;
  // "chX_head_foot_id_hist != 0XX & X10"
  assign ch_send_readys = (&{ch0_head_foot_id_hist[2], (ch0_head_foot_id_hist[1:0]!=2'b10)})|(&{ch1_head_foot_id_hist[2], (ch1_head_foot_id_hist[1:0]!=2'b10)});

  reg sending;
  reg [DATA_WIDTH-1:0] dout;

  // 8'hFE or 8'hFF = 7'b1111111
  assign ch0_header_foundD = (CH0_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH-1]=={7{1'b1}});
  assign ch1_header_foundD = (CH1_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH-1]=={7{1'b1}});

  // 8'hFE or 8'hFF = 7'b1111111
  assign ch0_header_lostD = (CH0_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH-1]!={7{1'b1}})&(ch0_head_foot_id_hist&3'b101==3'b100);
  assign ch1_header_lostD = (CH1_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH-1]!={7{1'b1}})&(ch1_head_foot_id_hist&3'b101==3'b100);  

  // 8'hEF or 8'h0F = 5'b01111
  assign ch0_footer_foundD = (CH0_DIN[HEADER_FOOTER_ID_WIDTH-4:0]==5'b01111)&(CH0_DIN[DATA_WIDTH-1 -:2]==2'b11);
  assign ch1_footer_foundD = (CH1_DIN[HEADER_FOOTER_ID_WIDTH-4:0]==5'b01111)&(CH1_DIN[DATA_WIDTH-1 -:2]==2'b11);

  // 8'hFE or 8'hFF = 7'b1111111
  assign ch0_footer_lostD = (CH0_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH-1]=={7{1'b1}})&(ch0_head_foot_id_hist&3'b101==3'b101);
  assign ch1_footer_lostD = (CH1_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH-1]=={7{1'b1}})&(ch1_head_foot_id_hist&3'b101==3'b101);

  assign ch0_request_fast_posedge = (CH0_READ_REQUEST == 1'b1)&(ch0_read_request_delay == 1'b0);
  assign ch1_request_fast_posedge = (CH1_READ_REQUEST == 1'b1)&(ch1_read_request_delay == 1'b0);

  assign dout_is_ch0 = (ch0_re|ch0_re_delay);
  assign dout_is_ch1 = (ch1_re|ch1_re_delay);

  assign read_enables = ch0_re|ch1_re;

  assign CH0_RE = ch0_re;
  assign CH1_RE = ch1_re;
  assign DOUT = dout;
  assign SENDING = sending;

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch0_read_request_delay <= #400 1'b0;
      ch1_read_request_delay <= #400 1'b0;
      ch0_re_delay <= #400 1'b0;
      ch1_re_delay <= #400 1'b0;
      read_enables_delay <= #400 1'b0;
    end else begin
      ch0_read_request_delay <= #400 CH0_READ_REQUEST;
      ch1_read_request_delay <= #400 CH1_READ_REQUEST;
      ch0_re_delay <= #400 ch0_re;
      ch1_re_delay <= #400 ch1_re;
      read_enables_delay <= #400 read_enables;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      read_enables_negedge <= #400 1'b0;
    end else begin
      if ((read_enables==1'b0)&(read_enables_delay==1'b1)) begin
        read_enables_negedge <= 1'b1;
      end else begin
        read_enables_negedge <= 1'b0;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch0_head_foot_id_hist <= #400 3'b000;
    end else begin
      if (ch0_re) begin
        if (ch0_header_foundD) begin
          ch0_head_foot_id_hist <= #400 {1'b1, ch0_head_foot_id_hist[0], 1'b1 };
        end else begin
          if (ch0_footer_foundD) begin
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
    if (!RESETN) begin
      ch1_head_foot_id_hist <= #400 3'b000;
    end else begin
      if (ch1_re) begin
        if (ch1_header_foundD) begin
          ch1_head_foot_id_hist <= #400 {1'b1, ch1_head_foot_id_hist[0], 1'b1 };
        end else begin
          if (ch1_footer_foundD) begin
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
    if (!RESETN) begin
      ch0_header_found <= #400 1'b0;
      ch0_header_lost <= #400 1'b0;
      ch0_footer_found <= #400 1'b0;
      ch0_footer_lost <= #400 1'b0;
    end else begin
      ch0_header_found <= #400 ch0_header_foundD;
      ch0_header_lost <= #400 ch0_header_lostD;
      ch0_footer_found <= #400 ch0_footer_foundD;
      ch0_footer_lost <= #400 ch0_footer_lostD;      
    end
  end  

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch1_header_found <= #400 1'b0;
      ch1_header_lost <= #400 1'b0;
      ch1_footer_found <= #400 1'b0;
      ch1_footer_lost <= #400 1'b0;
    end else begin
      ch1_header_found <= #400 ch1_header_foundD;
      ch1_header_lost <= #400 ch1_header_lostD;
      ch1_footer_found <= #400 ch1_footer_foundD;
      ch1_footer_lost <= #400 ch1_footer_lostD;      
    end
  end  

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch0_re <= #400 1'b0;
    end else begin
      if ((CH0_READ_REQUEST&READY)&(!sending)) begin
        ch0_re <= #400 1'b1;
      end else begin
        if ((ch0_footer_foundD|ch0_footer_lostD)) begin
          ch0_re <= #400 1'b0;
        end else begin
          ch0_re <= #400 ch0_re;
        end
      end        
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch1_re <= #400 1'b0;
    end else begin
      if (((read_request==2'b10)&READY)&(!sending)) begin
        ch1_re <= #400 1'b1;
      end else begin
        if ((!(CH1_READ_REQUEST&READY))&(ch1_footer_foundD|ch1_footer_lostD)) begin
          ch1_re <= #400 1'b0;
        end else begin
          ch1_re <= #400 ch1_re;
        end
      end        
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch0_din <= #400 {{HEADER_FOOTER_ID_WIDTH{1'b0}}, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
    end else begin
      if (ch0_re) begin
        if (ch0_header_lostD) begin
          ch0_din <= #400 {8'hFE, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
        end else begin
          if (ch0_footer_lostD) begin
            ch0_din <= #400 ch0_din;
          end else begin
            ch0_din <= #400 CH0_DIN;
          end 
        end
      end else begin
        ch0_din <= #400 ch0_din;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch1_din <= #400 {{HEADER_FOOTER_ID_WIDTH{1'b0}}, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
    end else begin
      if (ch1_re) begin
        if (ch1_header_lostD) begin
          ch1_din <= #400 {8'hFE, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
        end else begin
          if (ch1_footer_lostD) begin
            ch1_din <= #400 ch1_din;
          end else begin
            ch1_din <= #400 CH1_DIN;
          end
        end
      end else begin
        ch1_din <= #400 ch1_din;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      dout <= #400 {{HEADER_FOOTER_ID_WIDTH{1'b0}}, {DATA_WIDTH-HEADER_FOOTER_ID_WIDTH{1'b1}}};
    end else begin
      if (dout_is_ch0) begin
        if (ch0_footer_lost) begin
          dout <= #400 {{DATA_WIDTH-8{1'b1}}, 8'hEF};
        end else begin
          dout <= #400 ch0_din;
        end
      end else begin
        if (dout_is_ch1) begin
          if (ch1_footer_lost) begin
            dout <= #400 {{DATA_WIDTH-8{1'b1}}, 8'hEF};
          end else begin
            dout <= #400 ch1_din;
          end
        end else begin
          dout <= #400 dout;
        end
      end
    end
  end


  always @(posedge CLK ) begin
    if (!RESETN) begin
      sending <= #400 1'b0;
    end else begin
      if (read_enables_delay&ch_send_readys) begin
        sending <= #400 1'b1;
      end else begin
        if (read_enables_negedge) begin
          sending <= #400 1'b0;
        end else begin
          sending <= #400 sending;
        end
      end
    end
  end

endmodule