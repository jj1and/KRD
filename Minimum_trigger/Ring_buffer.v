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
    integer i;

    reg [DIN_WIDTH-1:0] sram[FIFO_DEPTH-1:0];
    reg [DEPTH_WIDTH-1:0] wp;
    reg [DEPTH_WIDTH-1:0] fin_wp;
    reg [DEPTH_WIDTH-1:0] rp;
    reg [DEPTH_WIDTH-1:0] current_rp;
    reg [DEPTH_WIDTH-1:0] past_rp;
    // bit width converting counter
    reg [BIT_CONVERT_CNT_WIDTH-1:0] bit_conv_cnt;
    reg [DOUT_WIDTH-1:0] bit_conv_buff[BIT_DIFF-1:0];
    reg dout_done;
    reg triggerd_flag_delay;
    reg putout_flag;

    assign O_DOUT_DONE = dout_done;
    assign DOUT = bit_conv_buff[BIT_DIFF-1];
    assign EMPTY = (wp == current_rp);
    assign FULL = (wp+1 == current_rp);

    always @(posedge CLK )
    begin
        if (!RESET)
        begin
            triggerd_flag_delay <= TRIGGERD_FLAG;
        end
        else
        begin
            triggerd_flag_delay <= TRIGGERD_FLAG;
        end
    end

    always @(posedge CLK )
    begin
      if (!RESET)
        begin
          for ( i=0 ; i<DIN_WIDTH ; i=i+1 )
            begin
              sram[i] <= 0;
            end
        end
      else
        begin
          if ( WE & (wp+1 != current_rp) )
            begin 
              sram[wp] <= DIN; 
            end
          else
            begin
              for ( i=0 ; i<DIN_WIDTH ; i=i+1 )
                begin
                  sram[i] <= sram[i];
                end 
            end
        end
    end

    always @(posedge CLK )
    begin
      if (!RESET)
        begin
          wp <= 0;  
        end
      else
        begin
          if ( WE & (wp+1 != rp) )
            begin
              if (wp == FIFO_DEPTH-1)
                begin
                  wp <= 0;
                end 
              else
                begin
                  wp <= wp + 1;
                end
            end
          else
            begin
              wp <= wp;
            end          
        end    
    end

    always @(posedge CLK )
    begin
      if (!RESET)
        begin
          current_rp = 0;
          past_rp = 0;  
        end
      else
        begin
          if (TRIGGERD_FLAG&(!triggerd_flag_delay))
            begin
              if (wp<PRE_ACQUI_LEN)
                begin
                  if (past_rp<(wp+FIFO_DEPTH-PRE_ACQUI_LEN))
                    begin
                      past_rp = current_rp;
                      current_rp = wp+FIFO_DEPTH-PRE_ACQUI_LEN;
                    end
                  else
                    begin
                      past_rp = past_rp;
                      current_rp = past_rp;
                    end
                end
              else
                begin
                  if (past_rp<(wp-PRE_ACQUI_LEN))
                    begin
                      past_rp = current_rp;
                      current_rp = wp-PRE_ACQUI_LEN;
                    end
                  else
                    begin
                      past_rp = past_rp;
                      current_rp = past_rp;
                    end
                end
            end 
          else
            begin
              past_rp = past_rp;
              current_rp = current_rp;
            end          
        end    
    end

    // FIFOからのデータのbit長変換にかかるカウント
    always @(posedge CLK )
    begin
      if (!RESET)
        begin
          bit_conv_cnt <= 0;
        end
      else
        begin
          if (!dout_done)
            begin
              if ( bit_conv_cnt >= BIT_DIFF-1 )
                begin
                  bit_conv_cnt <= 0;
                end
              else
                begin
                  bit_conv_cnt <= bit_conv_cnt + 1;  
                end
            end
          else
            begin
              bit_conv_cnt <= 0;
            end
        end
    end 

    always @(posedge CLK )
    begin
      if (!RESET)
        begin
          dout_done <= 1'b1;
          rp <= 0;        
        end
      else
        begin
          if (RE & (rp != wp) )
            begin
              if (putout_flag)
                begin
                  dout_done <= 1'b0;
                  rp <= current_rp;
                end
              else
                begin
                  if (rp == fin_wp)
                    begin
                      dout_done <= 1'b1;
                      rp <= rp;
                    end
                  else
                    begin
                      if (rp == FIFO_DEPTH-1)
                        begin
                          dout_done <= 1'b0;
                          rp <= 0;
                        end
                      else
                        begin
                          if (bit_conv_cnt==0)
                            begin
                              dout_done <= 1'b0;
                              rp <= rp + 1;
                            end
                          else
                            begin
                              dout_done <= 1'b0;
                              rp <= rp;
                            end
                        end
                    end
                end
            end
          else
            begin
              dout_done <= 1'b1;
              rp <= rp;
            end
        end
    end

    // FIFOからのデータのbit長変換
    always @(posedge CLK )
    begin
      if (!RESET)
        begin
          for ( i=0 ; i<BIT_DIFF ; i=i+1 )
            begin
              bit_conv_buff[i] <= 0;  
            end
        end
      else
        begin
          for ( i=1 ; i<BIT_DIFF ; i=i+1 )
            begin
              bit_conv_buff[i] <= bit_conv_buff[i-1];
            end
          bit_conv_buff[0] <= sram[rp][DEPTH_WIDTH*0 +:DEPTH_WIDTH];
        end    
    end

    always @(posedge CLK )
    begin
      if (!RESET)
        begin
          fin_wp <= 0;
        end
      else
        begin
          if ((!TRIGGERD_FLAG)&triggerd_flag_delay)
            begin
              fin_wp <= wp;
            end
          else
            begin
              fin_wp <= fin_wp;
            end
        end 
    end

    always @(posedge CLK )
    begin
      if (!RESET) 
        begin
          putout_flag <= 1'b0;
        end
      else
        begin
          if (TRIGGERD_FLAG&(!triggerd_flag_delay))
            begin
              putout_flag <= 1'b1;
            end
          else
            begin
              putout_flag <= 1'b0;;
            end
        end  
    end

endmodule