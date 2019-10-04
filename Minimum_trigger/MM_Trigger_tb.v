`timescale 1 ps / 1 ps

module MM_Trigger_tb;

    // ------ パラメータの定義 ------
    
    // --- DUT用 ---
    // threshold ( percentage of max value = 2^12)
    parameter THRESHOLD = 20;
    // acquiasion length settings
    parameter integer PRE_ACQUI_LEN = 24/2;
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
    parameter signed FST_HEIGHT = (ADC_MAX_VAL-ADC_MIN_VAL)*80/100 + ADC_MIN_VAL;
    parameter signed SND_HEIGHT = (ADC_MAX_VAL-ADC_MIN_VAL)*10/100 + ADC_MIN_VAL;
    parameter FST_WIDTH = 10;
    parameter SND_WIDTH = 20;
    parameter SIGNAL_INTERVAL = 100; 
    parameter signed BL_MIN = 10 + ADC_MIN_VAL;
    parameter signed BL_MAX = 12 + ADC_MIN_VAL;
    parameter integer SAMPLE_PER_TDATA = S_AXIS_TDATA_WIDTH/16;
    integer i;
    
    // ------ reg/wireの生成 -------
    reg axis_aclk = 1'b0;
    reg axis_aresetn = 1'b0;

    wire s_axis_tready;
    reg [S_AXIS_TDATA_WIDTH-1:0] s_axis_tdata = 0;
    reg s_axis_tvalid = 1'b0;

    wire m_axis_tlast;
    wire m_axis_tuser;
    wire [M_AXIS_TDATA_WIDTH-1:0] m_axis_tdata;
    reg m_axis_treday = 1'b0;

    wire fifo_full;


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
    Minimum_trigger # (
        .THRESHOLD(THRESHOLD),
        .PRE_ACQUI_LEN(PRE_ACQUI_LEN),
        .POST_ACQUI_LEN(POST_ACQUI_LEN),
        .BASELINE_CALC_LEN(BASELINE_CALC_LEN),
        .ACQUI_LEN(ACQUI_LEN),
        .AXIS_ACLK_FREQ(AXIS_ACLK_FREQ),
        .TIMER_RESO_FREQ(TIMER_RESO_FREQ),
        .TIME_STAMP_WIDTH(TIME_STAMP_WIDTH),
        .ADC_RESOLUTION_WIDTH(ADC_RESOLUTION_WIDTH),
        .S_AXIS_TDATA_WIDTH(S_AXIS_TDATA_WIDTH),
        .M_AXIS_TDATA_WIDTH(M_AXIS_TDATA_WIDTH)
    ) DUT (    
        .O_INTERNAL_FIFO_FULL(fifo_full),
        .AXIS_ACLK(axis_aclk),
        .AXIS_ARESETN(axis_aresetn),
        .S_AXIS_TREADY(s_axis_tready),
        .S_AXIS_TDATA(s_axis_tdata),
        .S_AXIS_TVALID(s_axis_tvalid),
        .M_AXIS_TDATA(m_axis_tdata),
        .M_AXIS_TLAST(m_axis_tlast),
        .M_AXIS_TUSER(m_axis_tuser),
        .M_AXIS_TREADY(m_axis_treday)
    );

    // ------ リセットタスク ------
    task reset;
    begin
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
            s_axis_tdata[16*i +:ADC_RESOLUTION_WIDTH] <= BL_MIN;
        end
        for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 )
        begin
            s_axis_tdata[16*i +:ADC_RESOLUTION_WIDTH] <= BL_MAX;
        end
    end
    endtask

    // ------- 信号部生成タスク ------
    task gen_signal;
    begin
        // 最初の山
        for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 )
        begin
            s_axis_tdata[16*i +:ADC_RESOLUTION_WIDTH] <= BL_MIN+FST_HEIGHT;
        end
        for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 )
        begin
            s_axis_tdata[16*i +:ADC_RESOLUTION_WIDTH] <= BL_MAX+FST_HEIGHT;
        end
        repeat(FST_WIDTH) @(posedge axis_aclk);
        
        // 二段目の山 (最初より低い)
        for ( i=0 ; i<SAMPLE_PER_TDATA ; i=i+2 )
        begin
            s_axis_tdata[16*i +:ADC_RESOLUTION_WIDTH] <= BL_MIN+SND_HEIGHT;
        end
        for ( i=1 ; i<SAMPLE_PER_TDATA ; i=i+2 )
        begin
            s_axis_tdata[16*i +:ADC_RESOLUTION_WIDTH] <= BL_MAX+SND_HEIGHT;
        end
        repeat(SND_WIDTH) @(posedge axis_aclk);

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
        s_axis_tvalid <= 1'b0;
        m_axis_treday <= 1'b0;

        reset;

        s_axis_tvalid <= 1'b1;
        m_axis_treday <= 1'b1;

        gen_noise;
        repeat(BASELINE_CALC_LEN) @(posedge axis_aclk);

        gen_signal_set;
        gen_noise;
        repeat(SIGNAL_INTERVAL) @(posedge axis_aclk);
        gen_signal_set;
        repeat(SIGNAL_INTERVAL) @(posedge axis_aclk);

    end

endmodule