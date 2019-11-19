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
  reg [1:0] ch0_head_foot_id_hist;
  wire ch0_read_start;

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
  reg [1:0] ch1_head_foot_id_hist;

  wire [1:0] read_request;
  assign read_request = {CH1_READ_REQUEST, CH0_READ_REQUEST};

  wire read_enables;
  reg read_enables_delay;
  reg read_enables_negedge;

  wire ch_send_readys;
  assign ch_send_readys = (ch0_head_foot_id_hist!=2'b01)|(ch1_head_foot_id_hist!=2'b01);

  reg sending;
  reg [DATA_WIDTH-1:0] dout;

  assign ch0_header_foundD = (CH0_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==8'hFF);
  assign ch1_header_foundD = (CH1_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==8'hFF);

  assign ch0_header_lostD = (CH0_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==8'hFF)&(ch0_head_foot_id_hist[0]==1'b0);
  assign ch1_header_lostD = (CH1_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==8'hFF)&(ch0_head_foot_id_hist[0]==1'b1);  

  assign ch0_footer_foundD = (CH0_DIN[HEADER_FOOTER_ID_WIDTH-1:0]==8'h0F)&(CH0_DIN[DATA_WIDTH-1 -:2]==2'b11);
  assign ch1_footer_foundD = (CH1_DIN[HEADER_FOOTER_ID_WIDTH-1:0]==8'h0F)&(CH1_DIN[DATA_WIDTH-1 -:2]==2'b11);

  assign ch0_footer_lostD = (CH0_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==8'hFF)&(ch0_head_foot_id_hist[0]==1'b1);
  assign ch1_footer_lostD = (CH1_DIN[DATA_WIDTH-1 -:HEADER_FOOTER_ID_WIDTH]==8'hFF)&(ch1_head_foot_id_hist[0]==1'b1);

  assign ch0_request_fast_posedge = (CH0_READ_REQUEST == 1'b1)&(ch0_read_request_delay == 1'b0);
  assign ch1_request_fast_posedge = (CH1_READ_REQUEST == 1'b1)&(ch1_read_request_delay == 1'b0);

  assign dout_is_ch0 = (ch0_re|ch0_re_delay);
  assign dout_is_ch1 = (ch1_re|ch1_re_delay);

  assign read_enables = ch0_re|ch1_re;

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch0_read_request_delay <= #100 1'b0;
      ch1_read_request_delay <= #100 1'b0;
      ch0_re_delay <= #100 1'b0;
      ch1_re_delay <= #100 1'b0;
      read_enables_delay <= #100 1'b0;
    end else begin
      ch0_read_request_delay <= #100 CH0_READ_REQUEST;
      ch1_read_request_delay <= #100 CH1_READ_REQUEST;
      ch0_re_delay <= #100 ch0_re;
      ch1_re_delay <= #100 ch1_re;
      read_enables_delay <= #100 read_enables;
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      read_enables_negedge <= #100 1'b0;
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
      ch0_head_foot_id_hist <= #100 2'b10;
    end else begin
      if (ch0_re) begin
        if (ch0_header_found) begin
          ch0_head_foot_id_hist <= #100 {ch0_head_foot_id_hist[0], 1'b1 };
        end else begin
          if (ch0_footer_found) begin
            ch0_head_foot_id_hist <= #100 {ch0_head_foot_id_hist[0], 1'b0 };
          end else begin
            ch0_head_foot_id_hist <= #100 ch0_head_foot_id_hist;
          end
        end
      end else begin
        ch0_head_foot_id_hist <= #100 ch0_head_foot_id_hist;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch1_head_foot_id_hist <= 2'b10;
    end else begin
      if (ch1_re) begin
        if (ch1_header_found) begin
          ch1_head_foot_id_hist <= #100 {ch1_head_foot_id_hist[0], 1'b1 };
        end else begin
          if (ch1_footer_found) begin
            ch1_head_foot_id_hist <= #100 {ch1_head_foot_id_hist[0], 1'b0 };
          end else begin
            ch1_head_foot_id_hist <= #100 ch1_head_foot_id_hist;
          end
        end
      end else begin
        ch1_head_foot_id_hist <= #100 ch1_head_foot_id_hist;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch0_header_found <= #100 1'b0;
      ch0_header_lost <= #100 1'b0;
      ch0_footer_found <= #100 1'b0;
      ch0_footer_lost <= #100 1'b0;
    end else begin
      ch0_header_found <= #100 ch0_header_foundD;
      ch0_header_lost <= #100 ch0_header_lostD;
      ch0_footer_found <= #100 ch0_footer_foundD;
      ch0_footer_lost <= #100 ch0_footer_lostD;      
    end
  end  

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch1_header_found <= #100 1'b0;
      ch1_header_lost <= #100 1'b0;
      ch1_footer_found <= #100 1'b0;
      ch1_footer_lost <= #100 1'b0;
    end else begin
      ch1_header_found <= #100 ch1_header_foundD;
      ch1_header_lost <= #100 ch1_header_lostD;
      ch1_footer_found <= #100 ch1_footer_foundD;
      ch1_footer_lost <= #100 ch1_footer_lostD;      
    end
  end  

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch0_re <= #100 1'b0;
    end else begin
      if (CH0_READ_REQUEST&(!sending)) begin
        ch0_re <= #100 1'b1;
      end else begin
        if ((!CH0_READ_REQUEST)&(ch0_footer_foundD|ch0_footer_lostD)) begin
          ch0_re <= #100 1'b0;
        end else begin
          ch0_re <= #100 ch0_re;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch1_re <= #100 1'b0;
    end else begin
      if ((read_request==2'b10)&(!sending)) begin
        ch1_re <= #100 1'b1;
      end else begin
        if ((!CH1_READ_REQUEST)&(ch1_footer_foundD|ch1_footer_lostD)) begin
          ch1_re <= #100 1'b0;
        end else begin
          ch1_re <= #100 ch1_re;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      
    end else begin
      
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch0_din <= #100 {DATA_WIDTH{1'b1}};
    end else begin
      if (ch0_re) begin
        if (ch0_header_lostD) begin
          ch0_din <= #100 {8'hFE, {DATA_WIDTH-8{1'b1}}};
        end else begin
          if (ch0_footer_lostD) begin
            ch0_din <= #100 ch0_din;
          end else begin
            ch0_din <= #100 CH0_DIN;
          end 
        end
      end else begin
        ch0_din <= #100 ch0_din;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      ch1_din <= #100 {DATA_WIDTH{1'b1}};
    end else begin
      if (ch1_re) begin
        if (ch1_header_lostD) begin
          ch1_din <= #100 {8'hFE, {DATA_WIDTH-8{1'b1}}};
        end else begin
          if (ch1_footer_lostD) begin
            ch1_din <= #100 ch1_din;
          end else begin
            ch1_din <= #100 CH1_DIN;
          end
        end
      end else begin
        ch1_din <= #100 ch1_din;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESETN) begin
      dout <= #100 {DATA_WIDTH{1'b1}};
    end else begin
      if (dout_is_ch0) begin
        if (ch0_footer_lost) begin
          dout <= #100 {{DATA_WIDTH-8{1'b1}}, 8'hEF};
        end else begin
          dout <= #100 ch0_din;
        end
      end else begin
        if (dout_is_ch1) begin
          if (ch1_footer_lost) begin
            dout <= #100 {{DATA_WIDTH-8{1'b1}}, 8'hEF};
          end else begin
            dout <= #100 ch1_din;
          end
        end else begin
          dout <= #100 dout;
        end
      end
    end
  end


  always @(posedge CLK ) begin
    if (!RESETN) begin
      sending <= 1'b0;
    end else begin
      if (read_enables&ch_send_readys) begin
        sending <= 1'b1;
      end else begin
        if (read_enables_negedge) begin
          sending <= 1'b0;
        end else begin
          sending <= sending;
        end
      end
    end
  end

endmodule