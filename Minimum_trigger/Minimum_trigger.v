`timescale 1 ns / 1 ps

module Minimum_trigger # (
    // threshold ( percentage of max value = 2^12)
    parameter integer THRESHOLD = 10,

    // acquiasion length settings
    parameter integer PRE_ACQUI_LEN = 24/2,
    parameter integer POST_ACQUI_LEN = 76/24,

    // Baselineの計算時間
    parameter integer BASELINE_CALC_LEN = 5E8,

    // FIFO depth setting
    parameter integer ACQUI_LEN = 200/2,

    // AXIS_ACLK frequency
    parameter integer AXIS_ACLK_FREQ = 500E6,

    // time counter resolution
    parameter integer TIMER_RESO_FREQ = 100E6,

    // TIME STAMP DATA WIDTH
    parameter integer TIME_STAMP_WIDTH = 16,

    // RFSoC ADC resolution
    parameter integer ADC_RESOLUTION_WIDTH = 12,

    // RF Data Converter data stream bus width
    parameter integer S_AXIS_TDATA_WIDTH	= 128,

    // AXI DMA S2MM bus width
    parameter integer M_AXIS_TDATA_WIDTH	= 64
)
(    

    //  internal fifo full flag
    output wire O_INTERNAL_FIFO_FULL,

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

    // function called clogb2 that returns an integer which has the 
    // value of the ceiling of the log base 2.
    function integer clogb2 (input integer bit_depth);
      begin
        for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
          bit_depth = bit_depth >> 1;
      end
    endfunction

    //  exec state
    localparam [1:0] INIT = 2'b00, // ADC < THRESHOLD_VAL
                    TRG = 2'b11; // ADC > THRESHOLD_VAL
    reg [1:0]  exec_machine_state;

    // s_axis_tready (ステートマシンで決める)
    reg s_axis_tready;
    assign S_AXIS_TREADY = s_axis_tready;

    wire [ADC_RESOLUTION_WIDTH-1:0] base_line;
    wire [TIME_STAMP_WIDTH-1:0] curr_time;
    wire [TIME_STAMP_WIDTH-1:0] time_stamp;
    wire triggerd_flag;
    wire bl_calc_comp;


    // state machine の動作
    always @(posedge AXIS_ACLK) 
    begin  
      if (!AXIS_ARESETN) 
        begin
          exec_machine_state <= INIT;
        end
      else
        begin
          if (bl_calc_comp)
            begin
              exec_machine_state <= TRG;
            end
          else
            begin
              exec_machine_state <= INIT;
            end
        end
    end  

    // S_AXIS_TREADYの動作
    always @(posedge AXIS_ACLK) 
    begin  
      if (!AXIS_ARESETN) 
        begin
          s_axis_tready <= 1'b0;
        end
      else
        begin
          if (exec_machine_state==TRG)
            begin
              s_axis_tready <= 1'b1;
            end
          else
            begin
              s_axis_tready <= 1'b0;
            end
        end
    end

  
    MM_trg # (
        .THRESHOLD(THRESHOLD),
        .POST_ACQUI_LEN(POST_ACQUI_LEN),
        .ACQUI_LEN(ACQUI_LEN),
        .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
        .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),  
        .S_AXIS_TDATA_WIDTH(S_AXIS_TDATA_WIDTH)
      ) MM_trg_inst (
          .EXEC_STATE(exec_machine_state),    
          .BASELINE(base_line),
          .CURRENT_TIME(curr_time),
          .O_TIME_STAMP(time_stamp),
          .O_TRIGGERD_FLAG(triggerd_flag),
          .AXIS_ACLK(AXIS_ACLK),
          .AXIS_ARESETN(AXIS_ARESETN),
          .S_AXIS_TDATA(S_AXIS_TDATA)
      );

    base_calc # (
        .THRESHOLD(THRESHOLD),
        .BASELINE_CALC_LEN(BASELINE_CALC_LEN),
        .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
        .S_AXIS_TDATA_WIDTH(S_AXIS_TDATA_WIDTH)
      ) base_calc_inst (    
        .EXEC_STATE(exec_machine_state),
        .O_BASELINE(base_line),
        .O_CALC_COMPLETE(bl_calc_comp),
        .AXIS_ACLK(AXIS_ACLK),
        .AXIS_ARESETN(AXIS_ARESETN),
        .S_AXIS_TDATA(S_AXIS_TDATA),
        .S_AXIS_TVALID(S_AXIS_TVALID)
    );

    m_axis_IF # (
        .THRESHOLD(THRESHOLD),
        .PRE_ACQUI_LEN(PRE_ACQUI_LEN),
        .POST_ACQUI_LEN(POST_ACQUI_LEN),
        .ACQUI_LEN(ACQUI_LEN),
        .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
        .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
        .S_AXIS_TDATA_WIDTH(S_AXIS_TDATA_WIDTH),
        .M_AXIS_TDATA_WIDTH(M_AXIS_TDATA_WIDTH)
      ) m_axis_IF_inst (    
        .TIME_STAMP(time_stamp),
        .TRIGGERD_FLAG(triggerd_flag),
        .O_FIFO_FULL(O_INTERNAL_FIFO_FULL),
        .AXIS_ACLK(AXIS_ACLK),
        .AXIS_ARESETN(AXIS_ARESETN),
        .S_AXIS_TREADY(s_axis_tready),
        .S_AXIS_TDATA(S_AXIS_TDATA),
        .S_AXIS_TVALID(S_AXIS_TVALID),
        .M_AXIS_TDATA(M_AXIS_TDATA),
        .M_AXIS_TLAST(M_AXIS_TLAST),
        .M_AXIS_TUSER(M_AXIS_TUSER),
        .M_AXIS_TREADY(M_AXIS_TREADY)
    );

    time_counter # (
        .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
        .AXIS_ACLK_FREQ(AXIS_ACLK_FREQ),
        .TIMER_RESO_FREQ(TIMER_RESO_FREQ) 
    ) time_counter_inst (   
        .EXEC_STATE(exec_machine_state),
        .AXIS_ACLK(AXIS_ACLK),
        .AXIS_ARESETN(AXIS_ARESETN),
        .O_CURRENT_TIME(curr_time)
    );

endmodule