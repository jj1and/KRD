`timescale 1 ns / 1 ps

module Ring_buffer # (
    parameter integer WIDTH = 128,
    parameter integer DEPTH = 200,
    parameter integer PRE_ACQUI_LEN = 24/2
)
(
    input wire CLK,
    input wire RESET,
    input wire [WIDTH-1:0] DIN,
    output wire [WIDTH-1:0] DOUT,
    input wire WE,
    input wire RE,
    input wire TRIGGERD_FLAG,
    output wire EMPTY,
    output wire FULL
);

    integer i;

    reg [WIDTH-1:0] sram[DEPTH-1:0];
    reg [DEPTH-1:0] wp;
    reg [DEPTH-1:0] current_rp;
    reg [DEPTH-1:0] past_rp;
    reg triggerd_flag;
    reg triggerd_flag_delay;

    assign DOUT = sram[current_rp];
    assign EMPTY = (wp == current_rp);
    assign FULL = (wp+1 == current_rp);

    always @(posedge CLK )
    begin
        if (!RESET)
        begin
            triggerd_flag <= 1'b0;
            triggerd_flag_delay <= triggerd_flag;
        end
        else
        begin
            triggerd_flag_delay <= triggerd_flag;
            triggerd_flag <= TRIGGERD_FLAG;    
        end
    end

    always @(posedge CLK )
    begin
      if (!RESET)
        begin
          for ( i=0 ; i<WIDTH ; i=i+1 )
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
              for ( i=0 ; i<WIDTH ; i=i+1 )
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
          if ( WE & (wp+1 != current_rp) )
            begin
              if (wp == DEPTH-1)
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
          current_rp <= 0;  
        end
      else
        begin
          if ( RE & (current_rp != wp) )
            begin
              if (triggerd_flag&(!triggerd_flag_delay))
                begin
                  if (wp<PRE_ACQUI_LEN)
                    begin
                      if (past_rp<current_rp)
                        begin
                          past_rp <= past_rp;
                          current_rp <= past_rp;
                        end
                      else
                        begin
                          past_rp <= current_rp;
                          current_rp <= wp+DEPTH-PRE_ACQUI_LEN;
                        end
                    end
                  else
                    begin
                      if (past_rp>current_rp)
                        begin
                          past_rp <= past_rp;
                          current_rp <= past_rp;
                        end
                      else
                        begin
                          past_rp <= current_rp;
                          current_rp <= wp+DEPTH-PRE_ACQUI_LEN;
                        end
                    end
                end 
              else
                begin
                  current_rp <= current_rp + 1;
                end
            end
          else
            begin
              past_rp <= past_rp;
              current_rp <= current_rp;
            end          
        end    
    end

endmodule