`timescale 1 ns / 1 ps

module m_axis_IF # (

    // threshold ( percentage of max value = 2^12)
    parameter integer THRESHOLD = 10,
    
    // acquiasion length settings
    parameter integer PRE_ACQUI_LEN = 24/2,
    parameter integer POST_ACQUI_LEN = 76/2,

    // FIFO depth setting
    parameter integer ACQUI_LEN = 200/2,

    // TIME STAMP DATA WIDTH
    parameter integer TIME_STAMP_WIDTH = 16,

    // RFSoC ADC resolution
    parameter integer ADC_RESOLUTION_WIDTH = 12,
    
    // RF Data Converter data stream bus width
    parameter integer S_AXIS_TDATA_WIDTH = 128,

    // AXI DMA S2MM bus width
    parameter integer M_AXIS_TDATA_WIDTH = 64

)
(    
    
    // triggered time stanp
	input wire [TIME_STAMP_WIDTH-1:0] TIME_STAMP,

    // start trigger flag
    input wire START_TRG,

    // finalize trigger flag
    input wire FINALIZE_TRG,

    // internal fifo full flag
    output wire O_FIFO_FULL,

    // Ports of Axi-stream Bus Interface
    input wire  AXIS_ACLK,
    input wire  AXIS_ARESETN,

    // Ports of Axi-stream Slave Bus Interface　
    output wire  S_AXIS_TREADY,
    input wire [S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
    input wire  S_AXIS_TVALID,

    // Ports of Axi-stream Master Bus Interface
    output wire [M_AXIS_TDATA_WIDTH-1:0] M_AXIS_TDATA,
    output wire M_AXIS_TLAST,
    output wire M_AXIS_TUSER,
    input wire M_AXIS_TREADY
);
   
   localparam integer BIT_DIFF = S_AXIS_TDATA_WIDTH/M_AXIS_TDATA_WIDTH;
   integer i;

    // pre acquiasion buffer
    reg [S_AXIS_TDATA_WIDTH-1:0] pre_acqui_buff[PRE_ACQUI_LEN-1:0];

    // pre acquiasion buffer write pointer
    reg [PRE_ACQUI_LEN-1:0] pre_wrp = 0;

    // pre acquiasion buffer read pointer
    reg [PRE_ACQUI_LEN-1:0] pre_rep = 0;

    // pre acquiasion buffer write enable
    wire pre_wren;
    assign pre_wren = S_AXIS_TVALID&S_AXIS_TREADY;

    // m_axis_tuser
    reg m_axis_tuser;
    assign M_AXIS_TUSER = m_axis_tuser;

    // m_axis_tlast
    reg m_axis_tlast;
    assign M_AXIS_TLAST = m_axis_tlast;
   
    // data to put into FIFO
    reg [S_AXIS_TDATA_WIDTH-1:0] fifo_input;

    // bit convert buffer
    reg [M_AXIS_TDATA_WIDTH-1:0] bit_convert_buff[BIT_DIFF-1:0];

    // fifo read out counter
    reg [ACQUI_LEN*BIT_DIFF-1:0] fifo_read_cnt;
    // finalize counter
    reg [ACQUI_LEN*BIT_DIFF-1:0] fin_read_cnt;

    // inputting fifo ready flag
    reg fifo_ready;

    // fifo read pointer
    reg fifo_reen;

    // fifo empty
    wire fifo_empty;

    // fifo full
    wire fifo_full;
    assign O_FIFO_FULL = fifo_full;

    // start_trg delay
    reg start_trg;
    reg start_trg_delay;

    Fifo # (
        .WIDTH(S_AXIS_TDATA_WIDTH),
        .DEPTH(ACQUI_LEN*BIT_DIFF)
    ) BUFF_FIFO_inst ( 
        .CLK(AXIS_ACLK),
        .RESET(AXIS_ARESETN),
        .DIN(fifo_input),
        .DOUT(M_AXIS_TDATA),
        .WE(fifo_ready),
        .RE(fifo_reen),
        .EMPTY(fifo_empty),
        .FULL(fifo_full)
    );
    
    always @(posedge AXIS_ACLK )
    begin
        if (!AXIS_ARESETN)
        begin
            start_trg <= 1'b0;
            start_trg_delay <= start_trg;
        end
        else
        begin
            start_trg_delay <= start_trg;
            start_trg <= START_TRG;
        end
    end

    // pre-acquiation buffer　にデータを一時保存
    always @(posedge AXIS_ACLK )
    begin
      if (!AXIS_ARESETN)
        begin
          for ( i=0 ; i<PRE_ACQUI_LEN ; i=i+1 )
            begin
              pre_acqui_buff[i] <= 0;
            end
        end
      else
        begin
          if (pre_wren)
            begin
              pre_acqui_buff[pre_wrp] <= S_AXIS_TDATA;
            end
          else
            begin
              pre_acqui_buff[pre_wrp] <= pre_acqui_buff[pre_wrp];
            end
        end
    end

   // pre-acquiasion buffer の write pointer の動作
   always @(posedge AXIS_ACLK )
    begin
      if (!AXIS_ARESETN)
        begin
          pre_wrp <= 0;
        end
      else
        begin
          if (pre_wren)
            begin
              if (pre_wrp == PRE_ACQUI_LEN-1 ) 
                begin
                  pre_wrp <= 0;
                end
              else
                begin
                  pre_wrp <= pre_wrp + 1;
                end
            end
          else
            begin
              pre_wrp <= pre_wrp;
            end
        end
    end


    // M_AXISの tuser flagの動作
    always @(posedge AXIS_ACLK )
    begin
      if (!AXIS_ARESETN)
        begin
          m_axis_tuser <= 1'b0;
        end
      else
        begin
          if (fifo_reen)
            begin
              if (fifo_read_cnt == 0)
                begin
                  m_axis_tuser <= 1'b1;
                end
              else
                begin
                  m_axis_tuser <= 1'b0;
                end
            end
          else
            begin
              m_axis_tuser <= 1'b0;
            end
        end
    end

    // M_AXISの tlast flagの動作
    always @(posedge AXIS_ACLK )
    begin
      if (!AXIS_ARESETN)
        begin
          m_axis_tlast <= 1'b0;
        end
      else
        begin
          if (fifo_reen)
            begin
              if ((fifo_read_cnt-fin_read_cnt) == POST_ACQUI_LEN-1)
                begin
                  m_axis_tlast <= 1'b1;
                end
              else
                begin
                  if (fifo_read_cnt == ACQUI_LEN-1)
                    begin
                      m_axis_tlast <= 1'b1;  
                    end
                  else
                    begin
                      m_axis_tlast <= 1'b0;
                    end
                end
            end
          else
            begin
              m_axis_tlast <= 1'b0;
            end
        end
    end

    // finalize trigger flag が立った時の fifo_read_cnt の記録
    always @(posedge AXIS_ACLK )
    begin
      if (!AXIS_ARESETN)
        begin
          fin_read_cnt <= 0;
        end
      else
        begin
          if (FINALIZE_TRG)
            begin
              fin_read_cnt <= fifo_read_cnt;
            end
          else
            begin
              fin_read_cnt <= 0;
            end
        end
    end    


    // FIFOの read out のカウント
    always @(posedge AXIS_ACLK )
    begin
      if (!AXIS_ARESETN)
        begin
          fifo_read_cnt <= 0;
        end
      else
        begin
          if (fifo_reen)
            begin
              if ( fifo_read_cnt < ACQUI_LEN )
                begin
                  fifo_read_cnt <= fifo_read_cnt + 1;  
                end
              else
                begin
                  fifo_read_cnt <= 0;
                end
            end
          else
            begin
              fifo_read_cnt <= 0;
            end
        end
    end

    // FIFOの read enableの動作
    always @(posedge AXIS_ACLK )
    begin
      if (!AXIS_ARESETN)
        begin
          fifo_reen <= 1'b0;
        end
      else
        begin
          if ((!fifo_empty)&M_AXIS_TREADY)
            begin
              fifo_reen <= 1'b1;
            end
          else
            begin
              fifo_reen <= 1'b0;
            end
        end
    end        

    // FIFOにデータを入れる動作
    always @(posedge AXIS_ACLK )
    begin
      if (!AXIS_ARESETN)
        begin
          fifo_input <= 0;
        end
      else
        begin
          if (START_TRG)
            begin
              if (!start_trg_delay)
                begin
                  fifo_input <= { {S_AXIS_TDATA_WIDTH-TIME_STAMP_WIDTH{1'b0}}, TIME_STAMP };
                end
              else
                begin
                  fifo_input <= S_AXIS_TDATA;
                end
            end
          else
            begin
              fifo_input <= fifo_input;
            end
        end
    end    
  
    // FIFOの write enable の動作
    always @(posedge AXIS_ACLK )
    begin
      if (!AXIS_ARESETN)
        begin
          fifo_ready <= 1'b0;
        end
      else
        begin
          if (START_TRG)
            begin
              if (fifo_full)
                begin
                  fifo_ready <= 1'b0;
                end
              else
                begin
                  fifo_ready <= 1'b1;
                end
            end
          else
            begin
              if (fifo_ready)
                begin
                  fifo_ready <= 1'b0;
                end
              else
                begin
                  fifo_ready <= fifo_ready;
                end
            end
        end
    end

endmodule