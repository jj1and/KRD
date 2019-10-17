`timescale 1 ps / 1 ps

module Ring_buffer_tb;

    // ------ パラメータの定義 ------
    
    // --- DUT用 ---
    // threshold ( percentage of max value = 2^12)
    parameter THRESHOLD = 20;
    // acquiasion length settings
    parameter integer PRE_ACQUI_LEN = 48/2;
    parameter integer POST_ACQUI_LEN = 76/2;
    // Baselineの計算時間
    parameter BASELINE_CALC_LEN = 10;
    // FIFO depth setting
    parameter ACQUI_LEN = 200/2;
    // AXIS_ACLK frequency
    parameter AXIS_ACLK_FREQ = 500E6;
    // time counter resolution
    parameter TIMER_RESO_FREQ = 100E6;
    // TIME STAMP DATA WIDTH
    parameter TIME_STAMP_WIDTH = 16;
    // RFSoC ADC resolution
    parameter ADC_RESOLUTION_WIDTH = 12;
    // RF Data Converter data stream bus width
    parameter S_AXIS_TDATA_WIDTH	= 128;
    // AXI DMA S2MM bus width
    parameter M_AXIS_TDATA_WIDTH	= 64;

    // --- function/task用 ---
    parameter signed ADC_MAX_VAL = 2**(ADC_RESOLUTION_WIDTH-1)-1;
    parameter signed ADC_MIN_VAL = -2**(ADC_RESOLUTION_WIDTH-1);
    parameter integer ACLK_PERIOD = 1E12/AXIS_ACLK_FREQ;
    parameter RESET_TIME = 10;
    parameter PRE_SIG = 10;
    parameter POST_SIG = 10;
    parameter signed FST_HEIGHT = (ADC_MAX_VAL-ADC_MIN_VAL)*80/100;
    parameter signed SND_HEIGHT = (ADC_MAX_VAL-ADC_MIN_VAL)*10/100;
    parameter FST_WIDTH = 10;
    parameter SND_WIDTH = 20;
    parameter SIGNAL_INTERVAL = 100; 
    parameter AFTER_SIGNAL_INTERVAL = 300;
    parameter signed BL_MIN = 10 + ADC_MIN_VAL;
    parameter signed BL_MAX = 12 + ADC_MIN_VAL;
    parameter integer SAMPLE_PER_TDATA = S_AXIS_TDATA_WIDTH/16;
    integer i;
    
    // ------ reg/wireの生成 -------
    reg axis_aclk = 1'b0;
    reg axis_aresetn = 1'b0;

    reg [S_AXIS_TDATA_WIDTH-1:0] s_axis_tdata = 0;
    reg s_axis_tvalid = 1'b0;
    wire [M_AXIS_TDATA_WIDTH-1:0] m_axis_tdata;
    reg m_axis_treday = 1'b0;

    reg triggerd_flag;

    wire buffer_full;
    wire buffer_empty;
    wire o_dout_done;

    reg [ADC_RESOLUTION_WIDTH-1:0] bl_min = BL_MIN;
    reg [ADC_RESOLUTION_WIDTH-1:0] bl_max = BL_MAX;
    reg [ADC_RESOLUTION_WIDTH-1:0] fst_height = FST_HEIGHT;
    reg [ADC_RESOLUTION_WIDTH-1:0] snd_height = SND_HEIGHT;


    // ------ クロックの生成 ------
    initial
    begin
        axis_aclk = 1'b0;
    end

    always #( ACLK_PERIOD/2 )
    begin
        axis_aclk <= ~axis_aclk;
    end


    // ------ DUT ------
Ring_buffer # (
    .DIN_WIDTH(S_AXIS_TDATA_WIDTH),
    .DOUT_WIDTH(M_AXIS_TDATA_WIDTH),
    .FIFO_DEPTH(ACQUI_LEN*2),
    .PRE_ACQUI_LEN(PRE_ACQUI_LEN)
) DUT (
    .CLK(axis_aclk),
    .RESET(axis_aresetn),
    .DIN(s_axis_tdata),
    .DOUT(m_axis_tdata),
    .WE(s_axis_tvalid),
    .RE(m_axis_treday),
    .TRIGGERD_FLAG(triggerd_flag),
    .O_DOUT_DONE(o_dout_done),
    .FIRST_DATA_FLAG(),
    .LAST_DATA_FLAG(),
    .EMPTY(buffer_empty),
    .FULL(buffer_full)
);

    // ------ リセットタスク ------
    task reset;
    begin
        triggerd_flag <= 1'b0;
        axis_aresetn = 1'b0;
        repeat(RESET_TIME) @(posedge axis_aclk);
        axis_aresetn = 1'b1;
    end
    endtask

    // ------ ノイズ生成タスク -------
    task gen_noise;
    begin
        for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 )
        begin
            s_axis_tdata[16*i +:16] <= {bl_min, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
        end
        for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 )
        begin
            s_axis_tdata[16*i +:16] <= {bl_max, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
        end
    end
    endtask

    // ------- 信号部生成タスク ------
    task gen_signal;
    begin
        // 最初の山
        for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 )
        begin
            s_axis_tdata[16*i +:16] <= {bl_min+fst_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
        end
        for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 )
        begin
            s_axis_tdata[16*i +:16] <= {bl_max+fst_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
        end
        repeat(FST_WIDTH) @(posedge axis_aclk);

        // 二段目の山 (最初より低い)
        for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 )
        begin
            s_axis_tdata[16*i +:16] <= {bl_min+snd_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
        end
        for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 )
        begin
            s_axis_tdata[16*i +:16] <= {bl_max+snd_height, {16-ADC_RESOLUTION_WIDTH{1'b0}}};
        end
        repeat(SND_WIDTH) @(posedge axis_aclk);

    end
    endtask

    // triggerd flag 生成タスク
    task trg_flag_gen;
    begin
      triggerd_flag <= 1'b0;
      repeat(PRE_SIG) @(posedge axis_aclk);
      triggerd_flag <= 1'b1;
      repeat(POST_ACQUI_LEN+FST_WIDTH) @(posedge axis_aclk);
      triggerd_flag <= 1'b0;
    end
    endtask

    // ------ 信号セット生成タスク ------
    task gen_signal_set;
    begin
        gen_noise;
        repeat(PRE_SIG) @(posedge axis_aclk);
        gen_signal;
        gen_noise;
        repeat(POST_SIG) @(posedge axis_aclk);
    end
    endtask


    // ------ テストベンチ本体 ------
    initial
    begin
        $dumpfile("Ring_buffer_tb.vcd");
        $dumpvars(0, Ring_buffer_tb);
        s_axis_tvalid <= 1'b0;
        m_axis_treday <= 1'b0;

        reset;

        s_axis_tvalid <= 1'b1;
        m_axis_treday <= 1'b1;

        gen_noise;
        repeat(BASELINE_CALC_LEN) @(posedge axis_aclk);

        fork
          begin
            gen_signal_set;
          end
          begin
            trg_flag_gen;
          end
        join

        gen_noise;
        repeat(SIGNAL_INTERVAL) @(posedge axis_aclk);
        
        fork
          begin
            gen_signal_set;
          end
          begin
            trg_flag_gen;
          end
        join

        gen_noise;
        repeat(AFTER_SIGNAL_INTERVAL) @(posedge axis_aclk);
        $finish;
    end

endmodule