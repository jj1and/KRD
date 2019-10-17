`timescale 1 ns / 1 ps

module Ring_buffer # (
    parameter integer DIN_WIDTH = 128,
    parameter integer DOUT_WIDTH = 64,
    parameter integer FIFO_DEPTH = 200,
    parameter integer PRE_ACQUI_LEN = 24/2
)
(
    input wire CLK,
    input wire RESET,
    input wire [DIN_WIDTH-1:0] DIN,
    output wire [DOUT_WIDTH-1:0] DOUT,
    input wire WE,
    input wire RE,
    input wire TRIGGERD_FLAG,
    output wire O_DOUT_DONE,
    output wire FIRST_DATA_FLAG,
    output wire LAST_DATA_FLAG,
    output wire EMPTY,
    output wire FULL
);

  // function called clogb2 that returns an integer which has the 
  // value of the ceiling of the log base 2.
  function integer clogb2 (input integer bit_depth);
    begin
      for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
        bit_depth = bit_depth >> 1;
    end
  endfunction

  localparam integer DEPTH_WIDTH = clogb2(FIFO_DEPTH-1);
  localparam integer BIT_DIFF = DIN_WIDTH/DOUT_WIDTH;
  localparam integer BIT_CONVERT_CNT_WIDTH = clogb2(BIT_DIFF-1);
  localparam integer PRE_CNT_BIT_WIDTH = clogb2(PRE_ACQUI_LEN);
  integer i;

  reg [DIN_WIDTH-1:0] sram[FIFO_DEPTH-1:0];
  reg [DEPTH_WIDTH-1:0] wp;
  wire [DEPTH_WIDTH-1:0] end_rp;
  wire [DEPTH_WIDTH-1:0] end_rp_delay;
  reg [DEPTH_WIDTH-1:0] next_end_rp;
  reg [DEPTH_WIDTH-1:0] last_end_rp;
  wire end_rp_ren;
  wire end_rp_wen;
  wire end_rp_empty;
  assign end_rp_wen = FULL ? 1'b0: (TRIGGERD_FLAG == 1'b0)&(triggerd_flag_delay == 1'b1);
  wire [1:0] read_end_en;
  assign read_end_en = end_rp_empty ? 1'b0: {(rp==end_rp), (bit_conv_cnt>=(BIT_DIFF-1))};
  assign end_rp_ren = &read_end_en;
  assign END_RP_FIFO_REN = end_rp_ren;

  reg [DEPTH_WIDTH-1:0] rp;
  reg [DEPTH_WIDTH-1:0] next_rp;
  reg [DEPTH_WIDTH-1:0] pre_next_start_rp;
  reg [DEPTH_WIDTH-1:0] next_start_rp;
  wire [DEPTH_WIDTH-1:0] start_rp;
  reg [PRE_CNT_BIT_WIDTH-1:0] pre_cnt;
  wire start_rp_ren;
  wire start_rp_wen;
  wire start_rp_empty;
  assign start_rp_wen = FULL ? 1'b0: (TRIGGERD_FLAG == 1'b1)&(triggerd_flag_delay == 1'b0);
  wire [2:0] read_start_en;
  assign read_start_en = {!start_rp_empty, (rp==last_end_rp), (bit_conv_cnt>=(BIT_DIFF-1))};
  assign start_rp_ren = &read_start_en;
  assign START_RP_FIFO_REN = start_rp_ren;

  wire write_en;
  assign write_en = (!FULL || ((TRIGGERD_FLAG==1'b0)&&(end_rp_empty)) );

  // bit width converting counter
  reg [BIT_CONVERT_CNT_WIDTH-1:0] bit_conv_cnt = 0;
  reg [DOUT_WIDTH-1:0] bit_conv_buff[BIT_DIFF-1:0];
  reg dout_done;
  wire triggerd_flag_delay;

  assign DOUT = bit_conv_buff[BIT_DIFF-1];
  assign EMPTY = (wp == rp);
  
  wire almost_full;
  assign almost_full = ( wp+BIT_DIFF == rp );

  reg full_flag;
  assign FULL = full_flag;


  Delay #(
    .DELAY_CLK(1),
    .WIDTH(1)
  ) trg_delay_inst (
    .CLK(CLK),
    .RESETn(RESET),
    .DIN(TRIGGERD_FLAG),
    .DOUT(triggerd_flag_delay)
  );

  Delay #(
    .DELAY_CLK(1),
    .WIDTH(DEPTH_WIDTH)
  ) end_rp_delay_inst (
    .CLK(CLK),
    .RESETn(RESET),
    .DIN(end_rp),
    .DOUT(end_rp_delay)
  );

  Delay #(
    .DELAY_CLK(1),
    .WIDTH(1)
  ) dout_done_delay_inst (
    .CLK(CLK),
    .RESETn(RESET),
    .DIN(dout_done),
    .DOUT(O_DOUT_DONE)
  );

  Delay #(
    .DELAY_CLK(2),
    .WIDTH(1)
  ) start_rp_ren_delay_inst (
    .CLK(CLK),
    .RESETn(RESET),
    .DIN(start_rp_ren),
    .DOUT(FIRST_DATA_FLAG)
  );

  Delay #(
    .DELAY_CLK(1),
    .WIDTH(1)
  ) end_rp_ren_delay_inst (
    .CLK(CLK),
    .RESETn(RESET),
    .DIN(end_rp_ren),
    .DOUT(LAST_DATA_FLAG)
  );

  Fifo # (
    .WIDTH(DEPTH_WIDTH),
    .DEPTH(FIFO_DEPTH)
  ) start_rp_fifo (
    .CLK(CLK),
    .RESET(RESET),
    .DIN(next_start_rp),
    .DOUT(start_rp),
    .WE(start_rp_wen),
    .RE(start_rp_ren),
    .EMPTY(start_rp_empty),
    .ALMOST_EMPTY(),
    .FULL()
  );

  Fifo # (
    .WIDTH(DEPTH_WIDTH),
    .DEPTH(FIFO_DEPTH)
  ) end_rp_fifo (
    .CLK(CLK),
    .RESET(RESET),
    .DIN(wp),
    .DOUT(end_rp),
    .WE(end_rp_wen),
    .RE(end_rp_ren),
    .EMPTY(end_rp_empty),
    .ALMOST_EMPTY(),
    .FULL()
  );

  always @(posedge CLK ) begin
    if (!RESET) begin
      full_flag <= 1'b0;
    end else begin
      if ((TRIGGERD_FLAG==1'b0)&&(end_rp_empty)) begin
        full_flag <= 1'b0;
      end else begin
        if (almost_full) begin
          full_flag <= 1'b1;
        end else begin
          full_flag <= full_flag;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESET) begin
      last_end_rp <= 0;      
    end else begin
      if (end_rp_wen || end_rp_ren) begin
        if (end_rp_empty) begin
          last_end_rp <= wp;
        end else begin
          last_end_rp <= end_rp_delay;
        end
      end else begin
        last_end_rp <= last_end_rp;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESET) begin
      pre_next_start_rp <= 0;
    end else begin
      if (wp < PRE_ACQUI_LEN) begin
        pre_next_start_rp <= wp + FIFO_DEPTH-PRE_ACQUI_LEN;
      end else begin
        pre_next_start_rp <= wp - PRE_ACQUI_LEN;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESET) begin
      pre_cnt <= 0;
      next_end_rp <= 0;
    end else begin
      if (end_rp_wen) begin
        pre_cnt <= 0;
        next_end_rp <= wp; 
      end else begin
        if (pre_cnt >= PRE_ACQUI_LEN) begin
          pre_cnt <= pre_cnt;
        end else begin
          pre_cnt <= pre_cnt + 1;
        end
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESET) begin
      next_start_rp <= 0;
    end else begin
      if (pre_cnt < PRE_ACQUI_LEN) begin
        next_start_rp <= next_end_rp;
      end else begin
        next_start_rp <= pre_next_start_rp;
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESET) begin
      for ( i=0 ; i<DIN_WIDTH ; i=i+1 ) begin
        sram[i] <= 0;
      end
    end else begin
      if ( WE && (!FULL) ) begin 
        sram[wp] <= DIN; 
      end else begin
        for ( i=0 ; i<DIN_WIDTH ; i=i+1 ) begin
          sram[i] <= sram[i];
        end 
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESET) begin
        wp <= 0;  
    end else begin
      if ( WE && write_en ) begin
          if (wp == FIFO_DEPTH-1) begin
              wp <= 0;
          end else begin
            wp <= wp + 1;
          end
      end else begin
        wp <= wp;
      end          
    end    
  end

  always @(posedge CLK ) begin
    if (!RESET) begin
      next_rp <= 0;
    end else begin
      if (start_rp_ren) begin
        next_rp <= start_rp;
      end else begin
        if (bit_conv_cnt >= BIT_DIFF-1) begin
          if (next_rp >= FIFO_DEPTH-1) begin
            next_rp <= 0;
          end else begin
            next_rp <= next_rp + 1;
          end
        end else begin
          next_rp <= next_rp;
        end 
      end
    end
  end

  always @(posedge CLK ) begin
    if (!RESET) begin
      rp <= 0;
    end else begin
      if (!dout_done) begin
        rp <= next_rp;
      end else begin
        rp <= rp;
      end
    end
  end

  // FIFOからのデータのbit長変換にかかるカウント
  always @(posedge CLK ) begin
    if (!RESET || start_rp_ren ) begin
      bit_conv_cnt <= 0;
    end else begin
      if ( bit_conv_cnt >= BIT_DIFF-1 ) begin
        bit_conv_cnt <= 0;
      end else begin
        bit_conv_cnt <= bit_conv_cnt + 1;  
      end      
    end
  end

  // FIFOからのデータのbit長変換
  always @(posedge CLK ) begin
    if (!RESET) begin
        for ( i=0 ; i<BIT_DIFF ; i=i+1 )
          begin
            bit_conv_buff[i] <= 0;  
          end
    end else begin
        for ( i=1 ; i<BIT_DIFF ; i=i+1 )
          begin
            bit_conv_buff[i] = bit_conv_buff[i-1];
          end
        bit_conv_buff[0] = sram[rp][DOUT_WIDTH*0 +:DOUT_WIDTH];
    end    
  end

  always @(posedge CLK ) begin
    if (!RESET) begin
      dout_done <= 1'b1;
    end else begin
      if ( start_rp_ren ) begin
        dout_done <= 1'b0;
      end else begin
        if ( end_rp_ren ) begin
          dout_done <= 1'b1;
        end else begin
          dout_done <= dout_done;
        end
      end
    end
  end

endmodule