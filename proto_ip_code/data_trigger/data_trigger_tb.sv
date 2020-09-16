    `timescale 1 ps/1 ps
    `include "test_signal_gen_pkg.sv"
    import test_signal_gen_pkg::*;

    module data_trigger_tb;

    parameter integer RESET_CLK_NUM = 10;
    parameter integer ACLK_PERIOD = 8000;
    parameter integer SIGNAL_PERIOD = 8000/`SAMPLE_NUM_PER_CLK;

    // these parameter must be configured before logic synthesis
    parameter integer MAX_PRE_ACQUISITION_LENGTH = 2;
    parameter integer MAX_POST_ACQUISITION_LENGTH = 2;

    reg ACLK = 1'b1;
    reg ARESET = 1'b1;
    reg areset_delay;
    reg areset_2delay;
    reg areset_3delay;
    reg SET_CONFIG = 1'b0;
    reg set_config_delay;
    reg set_config_2delay;
    reg set_config_3delay;
    reg STOP = 1'b1;
    reg ACQUIRE_MODE = 1'b0;
    
    always @(posedge ACLK) begin
        areset_delay <= #100 ARESET;
        areset_2delay <= #100 areset_delay;
        areset_3delay <= #100 areset_2delay;
        set_config_delay <= #100 SET_CONFIG;
        set_config_2delay <= #100 set_config_delay;
        set_config_3delay <= #100 set_config_2delay;
    end

    // trigger settings
    reg signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRSHOLD = 1024;
    reg signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD = 1024;
    reg signed [`ADC_RESOLUTION_WIDTH:0] H_GAIN_BASELINE = -1024;
    reg signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE = 256;
    reg [$clog2(MAX_PRE_ACQUISITION_LENGTH):0] PRE_ACQUISITION_LENGTH = 1;
    reg [$clog2(MAX_POST_ACQUISITION_LENGTH):0] POST_ACQUISITION_LENGTH = 1;

    wire signed [`SAMPLE_WIDTH-1:0] MODE_SWITCH_UPPER_THRESOLD = 2047;
    wire signed [`SAMPLE_WIDTH-1:0] MODE_SWITCH_LOWER_THRESOLD = -2048;    
    
    wire [`RFDC_TDATA_WIDTH-1:0] h_gain_default = {`SAMPLE_NUM_PER_CLK{{{`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH-1{H_GAIN_BASELINE[`ADC_RESOLUTION_WIDTH]}}, H_GAIN_BASELINE}}};
    wire [`LGAIN_TDATA_WIDTH-1:0] l_gain_default = {`LGAIN_SAMPLE_NUM_PER_CLK{L_GAIN_BASELINE}};   

    // S_AXIS interface from RF Data Converter logic IP
    reg [`RFDC_TDATA_WIDTH-1:0] S_AXIS_TDATA = h_gain_default;
    reg S_AXIS_TVALID = 1'b0;

    // S_AXIS interface from RF Data Converter logic IP
    wire [`RFDC_TDATA_WIDTH-1:0] H_S_AXIS_TDATA;
    wire H_S_AXIS_TVALID;

    // S_AXIS interfrace from L-gain ADC
    wire [`LGAIN_TDATA_WIDTH-1:0] L_S_AXIS_TDATA;
    wire L_S_AXIS_TVALID;

    // S_AXIS interface from DSP module
    wire [`RFDC_TDATA_WIDTH-1:0] DSP_S_AXIS_TDATA;
    wire DSP_S_AXIS_TVALID;    

    // Timestamp
    reg [`TIMESTAMP_WIDTH-1:0] TIMESTAMP = 0;
    always @(posedge ACLK) begin
        if (ARESET) begin
            TIMESTAMP <= #100 {`TIMESTAMP_WIDTH{1'b1}};
        end else begin
            TIMESTAMP <= #100 TIMESTAMP + 1;
        end
    end     

    wire [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] M_AXIS_TDATA;
    wire M_AXIS_TVALID;

    // h-gain data for charge_sum. timing is syncronized width M_AXIS_TDATA
    wire [`RFDC_TDATA_WIDTH-1:0] H_GAIN_TDATA;

    reg SIG_CLK = 1'b1;
    reg HALF_SIG_CLK = 1'b1;
    reg L_GAIN_SIG_CLK = 1'b1;
    reg [$clog2(`SAMPLE_NUM_PER_CLK)-1:0] hGain_disp_ptr = 0;
    wire signed  [`ADC_RESOLUTION_WIDTH-1:0] hGain_disp_sample = H_S_AXIS_TDATA[hGain_disp_ptr*`SAMPLE_WIDTH+(`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH) +:`ADC_RESOLUTION_WIDTH];

    reg [$clog2(`SAMPLE_NUM_PER_CLK)-1:0] hGainOutput_disp_ptr = 0;
    wire signed [`SAMPLE_WIDTH-1:0] hGainOutput_disp_sample = H_GAIN_TDATA[hGainOutput_disp_ptr*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];   

    reg [$clog2(`SAMPLE_NUM_PER_CLK/2)-1:0] combinedOutput_hGain_disp_ptr = 0;
    wire signed [`SAMPLE_WIDTH-1:0] m_axis_combinedHGainSample[4];
    wire signed [`SAMPLE_WIDTH-1:0] combinedHGain_disp_sample = m_axis_combinedHGainSample[combinedOutput_hGain_disp_ptr];

    reg [$clog2(`LGAIN_SAMPLE_NUM_PER_CLK)-1:0] lGain_disp_ptr = 0;
    wire [`SAMPLE_WIDTH-1:0] lGain_disp_sample = L_S_AXIS_TDATA[lGain_disp_ptr*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
    wire signed [`SAMPLE_WIDTH-1:0] m_axis_combinedLGainSample[2];
    wire signed [`SAMPLE_WIDTH-1:0] combinedLGain_disp_sample = m_axis_combinedLGainSample[lGain_disp_ptr];


    wire [`RFDC_TDATA_WIDTH-1:0] m_axis_rfdcTDATA = M_AXIS_TDATA[`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1 -:`RFDC_TDATA_WIDTH];
    wire [`SAMPLE_WIDTH-1:0] m_axis_normalSample[`SAMPLE_NUM_PER_CLK];

    wire [`RFDC_TDATA_WIDTH-1:0] m_axis_expectedNormalTDATA = rawHGainTDATA_to_expectedNormalTDATA(H_S_AXIS_TDATA, DUT.h_gain_baseline);
    wire [`SAMPLE_WIDTH-1:0] m_axis_expectedNormalSample[`SAMPLE_NUM_PER_CLK]; 
    wire [`SAMPLE_WIDTH-1:0] expectedNormal_disp_sample = m_axis_expectedNormalSample[hGainOutput_disp_ptr];    

    wire [`RFDC_TDATA_WIDTH-1:0] m_axis_expectedCombinedTDATA = rawTDATA_to_expectedCombinedTDATA(H_S_AXIS_TDATA, DUT.h_gain_baseline, L_S_AXIS_TDATA, DUT.l_gain_baseline);
    wire signed [`SAMPLE_WIDTH-1:0] m_axis_expectedCombined_hGainSample[4];
    wire signed [`SAMPLE_WIDTH-1:0] expectedCombined_hGain_disp_sample = m_axis_expectedCombined_hGainSample[combinedOutput_hGain_disp_ptr];

    wire signed [`SAMPLE_WIDTH-1:0] m_axis_expectedCombined_LGainSample[2];
    wire signed [`SAMPLE_WIDTH-1:0] expectedCombined_lGain_disp_sample = m_axis_expectedCombined_LGainSample[lGain_disp_ptr];

    genvar i;
    generate
        for (i=0; i<`SAMPLE_NUM_PER_CLK; i++) begin
            assign m_axis_normalSample[i] = m_axis_rfdcTDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
            assign m_axis_expectedNormalSample[i] = m_axis_expectedNormalTDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
            if (i%4==0) begin
                assign m_axis_combinedLGainSample[i/4] = m_axis_rfdcTDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
                assign m_axis_expectedCombined_LGainSample[i/4] = m_axis_expectedCombinedTDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
            end else if ((i-1)%4==0) begin
                assign m_axis_combinedHGainSample[(i-1)/2] = m_axis_rfdcTDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
                assign m_axis_expectedCombined_hGainSample[(i-1)/2] = m_axis_expectedCombinedTDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
            end else if ((i-2)%4==0) begin
                assign m_axis_combinedHGainSample[(i-2)/2+1] = m_axis_rfdcTDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
                assign m_axis_expectedCombined_hGainSample[(i-2)/2+1] = m_axis_expectedCombinedTDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
            end
        end
    endgenerate
    
    wire [`TRIGGER_CONFIG_WIDTH-1:0] m_axis_triggerConfig = M_AXIS_TDATA[0 +:`TRIGGER_CONFIG_WIDTH];
    wire [`TIMESTAMP_WIDTH-1:0] m_axis_timestamp = M_AXIS_TDATA[`TRIGGER_CONFIG_WIDTH +:`TIMESTAMP_WIDTH];
    wire m_axis_gainType = M_AXIS_TDATA[`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH + 5-1];  

    reg signed [`SAMPLE_WIDTH-1:0] m_axis_outputSample;
    always @(*) begin
        if (m_axis_gainType==1'b0) begin
            m_axis_outputSample = combinedLGain_disp_sample;    
        end else begin
            m_axis_outputSample = hGainOutput_disp_sample;
        end
    end

    always @(posedge SIG_CLK) begin
        hGain_disp_ptr <= hGain_disp_ptr + 1;
        hGainOutput_disp_ptr <= hGainOutput_disp_ptr + 1;
    end

    always @(posedge HALF_SIG_CLK) begin
        combinedOutput_hGain_disp_ptr <= combinedOutput_hGain_disp_ptr + 1;
    end

    always @(posedge L_GAIN_SIG_CLK) begin
        lGain_disp_ptr <= lGain_disp_ptr + 1;
    end        


    reg [`SAMPLE_NUM_PER_CLK-1:0] saturation;
    wire saturation_trigger = |saturation; 
    always @(*) begin
        for (int i=0; i<`SAMPLE_NUM_PER_CLK; i++) begin
            if (|{iSample_in_rawHGainTDATA(H_S_AXIS_TDATA, i)==13'h07ff, iSample_in_rawHGainTDATA(H_S_AXIS_TDATA, i)==13'h1800}) begin
                saturation[i] = 1;
            end else begin
                saturation[i] = 0;
            end
        end
    end    

    reg normal_trigger = 1'b0;
    wire trigger = normal_trigger_delay|saturation_trigger;
    reg normal_trigger_delay;
    wire extend_trigger[MAX_POST_ACQUISITION_LENGTH-1:0];
    reg [MAX_POST_ACQUISITION_LENGTH-1:0] trigger_shift_reg;
    generate
        for (i=0; i<MAX_POST_ACQUISITION_LENGTH; i++) begin
            assign extend_trigger[i] = |{trigger_shift_reg[i:0], trigger};
            assign extend_trigger_posedge[i] = (extend_trigger[i])&(!extend_trigger_delay[i]);
        end
        for (i=0; i<`SAMPLE_NUM_PER_CLK; i++) begin
            assign m_axis_normalSample[i] = m_axis_rfdcTDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
            if (i%4==0) begin
                assign m_axis_combinedLGainSample[i/4] = m_axis_rfdcTDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
            end else if ((i-1)%4==0) begin
                assign m_axis_combinedHGainSample[(i-1)/2] = m_axis_rfdcTDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
            end else if ((i-2)%4==0) begin
                assign m_axis_combinedHGainSample[(i-2)/2+1] = m_axis_rfdcTDATA[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
            end
        end
    endgenerate

    reg  extend_trigger_delay[MAX_POST_ACQUISITION_LENGTH-1:0];
    wire extend_trigger_posedge[MAX_POST_ACQUISITION_LENGTH-1:0];
    always @(posedge ACLK) begin
        normal_trigger_delay <= #100 normal_trigger;
        trigger_shift_reg <= #100 {trigger_shift_reg[MAX_POST_ACQUISITION_LENGTH-1:0], trigger};
        for (int i=0; i<=MAX_POST_ACQUISITION_LENGTH; i++) begin
            extend_trigger_delay[i] <= #100 extend_trigger[i];
        end
    end

    reg [`RFDC_TDATA_WIDTH*MAX_PRE_ACQUISITION_LENGTH-1:0] h_s_axis_tdata_shiftreg;
    wire [`RFDC_TDATA_WIDTH-1:0] h_s_axis_tdata_nDelay[MAX_PRE_ACQUISITION_LENGTH];
    reg [`LGAIN_TDATA_WIDTH*MAX_PRE_ACQUISITION_LENGTH-1:0] l_s_axis_tdata_shiftreg;
    wire [`LGAIN_TDATA_WIDTH-1:0] l_s_axis_tdata_nDelay[MAX_PRE_ACQUISITION_LENGTH];
    reg [(`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH)*MAX_PRE_ACQUISITION_LENGTH-1:0] signal_info_shiftreg;
    wire [`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] signal_info_nDelay[MAX_PRE_ACQUISITION_LENGTH];
    reg [MAX_PRE_ACQUISITION_LENGTH-1:0] saturation_shiftreg;
    wire saturation_nDelay[MAX_PRE_ACQUISITION_LENGTH];
    always @(posedge ACLK ) begin
        h_s_axis_tdata_shiftreg <= #100 {h_s_axis_tdata_shiftreg[`RFDC_TDATA_WIDTH*(MAX_PRE_ACQUISITION_LENGTH-1)-1:0], H_S_AXIS_TDATA};
        l_s_axis_tdata_shiftreg <= #100 {l_s_axis_tdata_shiftreg[`LGAIN_TDATA_WIDTH*(MAX_PRE_ACQUISITION_LENGTH-1)-1:0], L_S_AXIS_TDATA};
        signal_info_shiftreg <= #100 {signal_info_shiftreg[(`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH)*(MAX_PRE_ACQUISITION_LENGTH-1)-1:0], TIMESTAMP, DUT.rising_edge_threshold, DUT.falling_edge_threshold};
        saturation_shiftreg <= #100 {saturation_shiftreg[MAX_PRE_ACQUISITION_LENGTH-2:0], saturation};
    end

    generate
        for (i=0; i<MAX_PRE_ACQUISITION_LENGTH; i++) begin
            assign h_s_axis_tdata_nDelay[i] = h_s_axis_tdata_shiftreg[i*`RFDC_TDATA_WIDTH +:`RFDC_TDATA_WIDTH];
            assign l_s_axis_tdata_nDelay[i] = l_s_axis_tdata_shiftreg[i*`LGAIN_TDATA_WIDTH +:`LGAIN_TDATA_WIDTH];
            assign signal_info_nDelay[i] = signal_info_shiftreg[i*(`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH) +:`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH];
            assign saturation_nDelay[i] = saturation_shiftreg[i];
        end
    endgenerate

    dummy_signal_generator # (
        .LGAIN_CORRECTION(8)
    ) data_converter_inst (
        .ACLK(ACLK),
        .ARESET(ARESET),
        .SET_CONFIG(SET_CONFIG),
        
        .H_GAIN_BASELINE(H_GAIN_BASELINE),
        .L_GAIN_BASELINE(L_GAIN_BASELINE),

        // S_AXIS interface from AXI DMA IP
        .S_AXIS_TDATA(S_AXIS_TDATA),
        .S_AXIS_TVALID(S_AXIS_TVALID),
        .S_AXIS_TREADY(),

        // M_AXIS interface of dummy RF Data Converter logic IP
        .H_M_AXIS_TDATA(H_S_AXIS_TDATA),
        .H_M_AXIS_TVALID(H_S_AXIS_TVALID),

        // M_AXIS interfrace of dummy L-gain ADC
        .L_M_AXIS_TDATA(L_S_AXIS_TDATA),
        .L_M_AXIS_TVALID(L_S_AXIS_TVALID),

        // M_AXIS interface of dummy DSP module
        .DSP_M_AXIS_TDATA(DSP_S_AXIS_TDATA),
        .DSP_M_AXIS_TVALID(DSP_S_AXIS_TVALID)           
    );

    data_trigger # (
        // these parameter must be configured before logic synthesis
        .MAX_PRE_ACQUISITION_LENGTH(MAX_PRE_ACQUISITION_LENGTH),
        .MAX_POST_ACQUISITION_LENGTH(MAX_POST_ACQUISITION_LENGTH)
    ) DUT (
        .*
    );

    task reset_all;
        test_status = RESET_ALL;
        
        ARESET <= #100 1'b1;
        repeat(RESET_CLK_NUM) @(posedge ACLK);
        ARESET <= #100 1'b0;
        
    endtask

    task config_module( 
        input bit acquire_mode,
        input int rise_edge_thre, 
        input int fall_edge_thre,
        input bit signed [`ADC_RESOLUTION_WIDTH:0] h_baseline,
        input bit signed [`SAMPLE_WIDTH-1:0] l_baseline, 
        input int pre_acqui_len, 
        input int post_acqui_len );
        
        test_status = CONFIGURING;
        // configuring DUT
        SET_CONFIG <= #100 1'b1;

        ACQUIRE_MODE <= #100 acquire_mode;
        RISING_EDGE_THRSHOLD <= #100 rise_edge_thre;
        FALLING_EDGE_THRESHOLD <= #100 fall_edge_thre;
        H_GAIN_BASELINE <= #100 h_baseline;
        L_GAIN_BASELINE <= #100 l_baseline;
        PRE_ACQUISITION_LENGTH <= #100 pre_acqui_len;
        POST_ACQUISITION_LENGTH <= #100 post_acqui_len;

        repeat(RESET_CLK_NUM) @(posedge ACLK);
        SET_CONFIG <= #100 1'b0;                   

    endtask        

    initial begin
        ACLK =1;
        forever #(ACLK_PERIOD/2)   ACLK = ~ ACLK;   
    end

    initial begin
        #100
        SIG_CLK =1;
        forever #(SIGNAL_PERIOD/2)   SIG_CLK = ~ SIG_CLK;   
    end

    initial begin
        #100
        HALF_SIG_CLK =1;
        forever #(SIGNAL_PERIOD)   HALF_SIG_CLK = ~ HALF_SIG_CLK;   
    end

    initial begin
        #100
        L_GAIN_SIG_CLK =1;
        forever #(SIGNAL_PERIOD*4/2)   L_GAIN_SIG_CLK = ~ L_GAIN_SIG_CLK;   
    end

    parameter integer TIME_OUT_THRE = 125;
    task data_trigger_monitor;
        int test_failed;
        bit [`RFDC_TDATA_WIDTH:0] acquired_hGainTDATA_queue[$];
        bit [`RFDC_TDATA_WIDTH-1:0] acquired_lGainTDATA_queue[$];
        bit [`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] acquired_signal_info[$];        
        bit [`RFDC_TDATA_WIDTH-1:0] expected_hGainTDATA;
        bit [`RFDC_TDATA_WIDTH-1:0] expected_lGainTDATA;
        bit [`TIMESTAMP_WIDTH-1:0] expected_timestamp;
        bit [`TRIGGER_CONFIG_WIDTH-1:0] expected_trigger_config;
        bit combined_flag;
        int timeout_counter;

        timeout_counter = 0;     
        
        while (timeout_counter<TIME_OUT_THRE) begin
            @(posedge ACLK);                                 
            test_failed = 0;
            if (&{extend_trigger[DUT.pre_acquisition_length-1], H_S_AXIS_TVALID, L_S_AXIS_TVALID, DSP_S_AXIS_TVALID}) begin
                if (|{extend_trigger_posedge[DUT.pre_acquisition_length-1], set_config_3delay&(!set_config_2delay), areset_3delay&(!areset_2delay)}) begin
                    for (int i=0; i<DUT.pre_acquisition_length; i++) begin
                        acquired_hGainTDATA_queue.push_back({
                            rawHGainTDATA_to_expectedNormalTDATA(h_s_axis_tdata_nDelay[DUT.pre_acquisition_length-i-1], DUT.h_gain_baseline), 
                            DUT.acquire_mode|saturation_nDelay[DUT.pre_acquisition_length-i-1]} );
                        
                        acquired_lGainTDATA_queue.push_back(rawTDATA_to_expectedCombinedTDATA(
                            h_s_axis_tdata_nDelay[DUT.pre_acquisition_length-i-1], DUT.h_gain_baseline,
                            l_s_axis_tdata_nDelay[DUT.pre_acquisition_length-i-1], DUT.l_gain_baseline) );
                        acquired_signal_info.push_back(signal_info_nDelay[DUT.pre_acquisition_length-i-1]);
                    end
                end            
                acquired_hGainTDATA_queue.push_back({rawHGainTDATA_to_expectedNormalTDATA(H_S_AXIS_TDATA, DUT.h_gain_baseline), (|saturation)|DUT.acquire_mode});
                acquired_lGainTDATA_queue.push_back(rawTDATA_to_expectedCombinedTDATA(H_S_AXIS_TDATA, DUT.h_gain_baseline, L_S_AXIS_TDATA, DUT.l_gain_baseline));
                acquired_signal_info.push_back({TIMESTAMP, DUT.rising_edge_threshold, DUT.falling_edge_threshold});
            end                        
                                    
            // macthing with data_trigger output
            if (M_AXIS_TVALID) begin
                timeout_counter = 0;
                // read out data from queue
                if (|{acquired_hGainTDATA_queue.size()==0, acquired_lGainTDATA_queue.size()==0}) begin
                    $display("TEST ERROR: acquired tdata queue is empty!");
                    $finish;
                end else begin
                    {expected_hGainTDATA, combined_flag} = acquired_hGainTDATA_queue.pop_front();
                    expected_lGainTDATA = acquired_lGainTDATA_queue.pop_front();
                    {expected_timestamp, expected_trigger_config} = acquired_signal_info.pop_front();                                 
                end
                                
                // macthing with data_trigger output
                if (combined_flag) begin
                    if (m_axis_rfdcTDATA!=expected_lGainTDATA) begin
                        $display("TEST FAILED: output data doesn't match with input; input:%0x output:%0x", expected_lGainTDATA, m_axis_rfdcTDATA); 
                        test_failed = 1;
                    end
                end else begin
                    if (m_axis_rfdcTDATA!=expected_hGainTDATA) begin
                        $display("TEST FAILED: output data doesn't match with input; input:%0x output:%0x", expected_hGainTDATA, m_axis_rfdcTDATA); 
                        test_failed = 1;
                    end                        
                end

                if (m_axis_timestamp!=expected_timestamp) begin
                    $display("TEST FAILED: output timestamp doesn't match with input; input:%0d output:%0d", expected_timestamp, m_axis_timestamp);
                    test_failed = 1;     
                end
                if (m_axis_triggerConfig!=expected_trigger_config) begin
                    $display("TEST FAILED: output trigger_config doesn't match with input; input:%0x output:%0x", expected_trigger_config, m_axis_triggerConfig);
                    test_failed = 1;       
                end
            end else begin
                timeout_counter++;
            end
            if ((|{set_config_delay, set_config_2delay})|(|{areset_delay, areset_2delay})) begin
                acquired_hGainTDATA_queue.delete();
                acquired_lGainTDATA_queue.delete();
                acquired_signal_info.delete();
            end            
            
            if (test_failed!=0) begin
                $finish;
            end
        end
        if (&{acquired_hGainTDATA_queue.size()>0, acquired_lGainTDATA_queue.size()>0}) begin
            $display("TEST FAILED: remains are in the queue"); 
            $finish;            
        end
    endtask

    parameter integer SAMPLE_NUM = 20;
    parameter integer TEST_SETUP_PERIOD = 10;
    signal_config_pack signal_config[SAMPLE_NUM];
    SignalGenerator sample_signal_set[SAMPLE_NUM];
    int trigger_start[SAMPLE_NUM][$];
    int trigger_end[SAMPLE_NUM][$];

    task signal_input(input SignalGenerator sample_signal[], input int sample_num);
        bit [`RFDC_TDATA_WIDTH-1:0] expectedNormalTDATA;
        bit signed [`SAMPLE_WIDTH-1:0] int16_sample_bl_subtracted;    
        bit [`SAMPLE_NUM_PER_CLK-1:0] rise_thre_over;
        bit [`SAMPLE_NUM_PER_CLK-1:0] fall_thre_under;

        @(posedge ACLK);
        S_AXIS_TVALID <= #100 1'b1;
        S_AXIS_TDATA <= #100 h_gain_default;   
        STOP <= #100 1'b0;        
        
        fork
            begin
                for (int i=0; i<TEST_SETUP_PERIOD; i++) begin
                    @(posedge ACLK);
                    S_AXIS_TVALID <= #100 1'b1;
                    S_AXIS_TDATA <= #100 h_gain_default;                       
                end            
            
                for (int i=0; i<sample_num; i++) begin
                    h_gain_signal_line_t h_gain_signal_set;

                    h_gain_signal_set =  sample_signal[i].getHGainSignalStream();                    
                    
                    trigger_start[i].delete();
                    trigger_end[i].delete();

                    // get triggered range in sample
                    for (int j=0; j<sample_signal[i].total_stream_len; j++) begin
                        expectedNormalTDATA = rawHGainTDATA_to_expectedNormalTDATA(h_gain_signal_set[j], DUT.h_gain_baseline);
                        for (int k=0; k<`SAMPLE_NUM_PER_CLK; k++) begin
                            int16_sample_bl_subtracted = iSample_in_expectedTDATA(expectedNormalTDATA, k);
                            
                            // get index trigger starts
                            if (int16_sample_bl_subtracted>DUT.rising_edge_threshold) begin
                                 $display("TEST INFO: sample[%0d][%0d][%0d] (%0d) is larger than rising threshold (%0d)", i, j, k, int16_sample_bl_subtracted, DUT.rising_edge_threshold);
                                rise_thre_over[k] = 1'b1;
                            end else begin
                                rise_thre_over[k] = 1'b0;
                            end
                            if (&rise_thre_over) begin
                                if (trigger_start[i].size()>0) begin
                                    if (trigger_start[i][trigger_start[i].size()-1]!=j) begin
                                        trigger_start[i].push_back(j);                                     
                                    end
                                end else begin
                                    trigger_start[i].push_back(j);                                                                       
                                end
                            end                                                    
                            // get index trigger ends
                            if (int16_sample_bl_subtracted<DUT.falling_edge_threshold) begin
                                 $display("TEST INFO: sample[%0d][%0d][%0d] (%0d) is smaller than falling threshold (%0d)", i, j, k, int16_sample_bl_subtracted, DUT.falling_edge_threshold);
                                fall_thre_under[k] = 1'b1;    
                            end else begin
                                fall_thre_under[k] = 1'b0; 
                            end                
                        end
                        if (&fall_thre_under) begin
                            trigger_end[i].push_back(j);
                        end                                
                    end
                 
                    for (int j=0; j<sample_signal[i].total_stream_len; j++) begin
                        @(posedge ACLK);                                                    
                        if (&{j==trigger_start[i][0], trigger_start[i].size()>0}) begin
                            normal_trigger <= #100 1'b1;
                            trigger_start[i].pop_front();
                        end
                        if (&{j==trigger_end[i][0], trigger_end[i].size()>0}) begin
                            normal_trigger <= #100 1'b0;
                            trigger_end[i].pop_front();
                        end
                        S_AXIS_TVALID <= #100 1'b1;
                        S_AXIS_TDATA <= #100 h_gain_signal_set[j];
                    end                                            
                end
                for (int i=0; i<TEST_SETUP_PERIOD; i++) begin
                    @(posedge ACLK);
                    normal_trigger <= #100 1'b0;
         
                    S_AXIS_TVALID <= #100 1'b1;
                    S_AXIS_TDATA <= #100 h_gain_default;                      
                end                
            end
            begin
                data_trigger_monitor;
            end
        join
    endtask

    enum integer {
        INTITIALIZE,
        RESET_ALL,
        CONFIGURING, 
        FIXED_NORMAL_SIGNAL_INPUT_NORMAL_OUTPUT,
        FIXED_SATURATED_SIGNAL_INPUT_NORMAL_OUTPUT,
        FIXED_NORMAL_SIGNAL_INPUT_COMBINED_OUTPUT,
        FIXED_SATURATED_SIGNAL_INPUT_COMBINED_OUTPUT,
        RANDOM_SIGNAL_INPUT_NORMAL_OUTPUT,
        RANDOM_SIGNAL_INPUT_COMBINED_OUTPUT,
        RANDOM_SIGNAL_INPUT_NORMAL_OUTPUT_SUDDEN_RESET_CONFIG       
    } test_status;    

    // knownn issue: testbench cannot simulate trigger behavior
    // e.x. signal like -2048 -> positive value larger than falling threshold in 1 clock
    // testbench ... stop trigger
    // data_trigger ...  continues trigger (trigger stop condition is falling_threshold > ADC for 8nsec)
    initial begin
        int random_h_gain_max_val;
        int random_h_gain_baseline;
        int random_l_gain_max_val;
        int random_l_gain_baseline;
        int random_total_sample_stream_len;
        int random_reset_timing;
        int random_config_timing;
        // sample_signal MUST NOT HAVE MORE THAN 1 TRIGGER PER SAMPLE. 
        // testbench cannot recognize  2 trigger in 1 sample
        test_status = INTITIALIZE;
        for (int i=0; i<10; i++) begin
            signal_config[i].rise_time = 5*(i+1);
            signal_config[i].high_time = 10*(i+1);
            signal_config[i].fall_time = 20*(i+1);
            sample_signal_set[i] = new(signal_config[i]);
            sample_signal_set[i].sampleFilling(i*200, H_GAIN_BASELINE, i*100, L_GAIN_BASELINE); // h_gain_height, h_gain_baseline, l_gain_height, l_gain_baseline
        end
        for (int i=10; i<15; i++) begin
            if (i%2==0) begin
                signal_config[i].rise_time = i-9;
                signal_config[i].high_time = 10*(i-9);
                signal_config[i].fall_time = 20*(i-9);
                sample_signal_set[i] = new(signal_config[i]);
                sample_signal_set[i].sampleFilling((i-9)*2047, (i-9)*2047, (i-9)*200, 512); // h_gain_height, h_gain_baseline, l_gain_height, l_gain_baseline            
            end else begin
                signal_config[i].rise_time = i-9;
                signal_config[i].high_time = 10*(i-9);
                signal_config[i].fall_time = 20*(i-9);
                sample_signal_set[i] = new(signal_config[i]);
                sample_signal_set[i].sampleFilling((i-9)*200, H_GAIN_BASELINE, (i-9)*100, L_GAIN_BASELINE); // h_gain_height, h_gain_baseline, l_gain_height, l_gain_baseline
            end
        end
        for (int i=15; i<20; i++) begin
            if (i%2==0) begin
                signal_config[i].rise_time = i-9;
                signal_config[i].high_time = 10*(i-9);
                signal_config[i].fall_time = 20*(i-9);
                sample_signal_set[i] = new(signal_config[i]);
                sample_signal_set[i].sampleFilling(1024, -2048, 512, -128); // h_gain_height, h_gain_baseline, l_gain_height, l_gain_baseline            
            end else begin
                signal_config[i].rise_time = i-9;
                signal_config[i].high_time = 10*(i-9);
                signal_config[i].fall_time = 20*(i-9);
                sample_signal_set[i] = new(signal_config[i]);
                sample_signal_set[i].sampleFilling((i-9)*200, H_GAIN_BASELINE, (i-9)*100, L_GAIN_BASELINE); // h_gain_height, h_gain_baseline, l_gain_height, l_gain_baseline
            end
        end        

        reset_all;
        config_module(0, 1024, 512, H_GAIN_BASELINE, L_GAIN_BASELINE, 2, 1); //acquire_mode rise_thre, fall_thre, h_gain_baseline, l_gain_baseline, pre_acqui_len, post_acqui_len
        $display("TEST INFO: Normal acquire mode enable");
        
        test_status = FIXED_NORMAL_SIGNAL_INPUT_NORMAL_OUTPUT;
        $display("TEST START: input non-satuated signal");        
        signal_input(sample_signal_set[0:9], 10);
        $display("TEST PASSED: non-satuated signal test passed!");
        
        test_status = FIXED_SATURATED_SIGNAL_INPUT_NORMAL_OUTPUT;
        $display("TEST START: input satuated signal");        
        signal_input(sample_signal_set[10:19], 10);
        $display("TEST PASSED: satuated signal test passed!");
        
        config_module(1, 1024, 512, H_GAIN_BASELINE, L_GAIN_BASELINE, 1, 1); //acquire_mode rise_thre, fall_thre, h_gain_baseline, l_gain_baseline, pre_acqui_len, post_acqui_len
        $display("TEST INFO: Combined acquire mode enable");
        
        test_status = FIXED_NORMAL_SIGNAL_INPUT_COMBINED_OUTPUT;
        $display("TEST START: input non-satuated signal");        
        signal_input(sample_signal_set[0:9], 10);
        $display("TEST PASSED: non-satuated signal test passed!");
        
        test_status = FIXED_SATURATED_SIGNAL_INPUT_COMBINED_OUTPUT;
        $display("TEST START: input satuated signal");        
        signal_input(sample_signal_set[10:19], 10);
        $display("TEST PASSED: satuated signal test passed!");

        for (int i=0; i<SAMPLE_NUM; i++) begin
            signal_config[i].rise_time = $urandom_range(1,1000);
            signal_config[i].high_time = $urandom_range(1,1000);
            signal_config[i].fall_time = $urandom_range(1,1000);
            sample_signal_set[i] = new(signal_config[i]);
            random_h_gain_max_val = $urandom_range(-4095, 4095);
            random_h_gain_baseline = $urandom_range(-4096, random_h_gain_max_val);
            random_l_gain_max_val = random_h_gain_max_val/20;
            random_l_gain_baseline = random_h_gain_baseline/20;
            sample_signal_set[i].sampleFilling(random_h_gain_max_val, random_h_gain_baseline, random_l_gain_max_val, random_l_gain_baseline); // h_gain_height, h_gain_baseline, l_gain_height, l_gain_baseline
        end

        config_module(0, 1024, 1024, H_GAIN_BASELINE, L_GAIN_BASELINE, 1, 1); //acquire_mode rise_thre, fall_thre, h_gain_baseline, l_gain_baseline, pre_acqui_len, post_acqui_len
        $display("TEST INFO: Normal acquire mode enable");

        test_status = RANDOM_SIGNAL_INPUT_NORMAL_OUTPUT;
        $display("TEST START: input random signal with normal mode");        
        signal_input(sample_signal_set, SAMPLE_NUM);
        $display("TEST PASSED: random signal with normal mode test passed!");

        config_module(1, 1024, 512, H_GAIN_BASELINE, L_GAIN_BASELINE, 1, 1); //acquire_mode rise_thre, fall_thre, h_gain_baseline, l_gain_baseline, pre_acqui_len, post_acqui_len
        $display("TEST INFO: Combined acquire mode enable");

        test_status = RANDOM_SIGNAL_INPUT_COMBINED_OUTPUT;
        $display("TEST START: input random signal with combined mode");        
        signal_input(sample_signal_set, SAMPLE_NUM);
        $display("TEST PASSED: random signal with combined mode test passed!");                                 


        // WARNING!!! Testbench cannot know trigger start/stop timing after reset/set_config when the configuration is changed before and after reset/set_config
        // So, it's need to set default configuration
        // this test's purpose is chencking the trigger is back to normal mode after reset/set_config
        config_module(0, 1024, 1024, H_GAIN_BASELINE, L_GAIN_BASELINE, 1, 1); //acquire_mode rise_thre, fall_thre, h_gain_baseline, l_gain_baseline, pre_acqui_len, post_acqui_len
        $display("TEST INFO: Normal acquire mode enable");

        test_status = RANDOM_SIGNAL_INPUT_NORMAL_OUTPUT_SUDDEN_RESET_CONFIG;
        $display("TEST START: input random signal with normal mode (with sudden reset/config)");            
        fork
            begin
                signal_input(sample_signal_set, SAMPLE_NUM);             
            end
            begin
                random_total_sample_stream_len = 0;
                for (int i=0; i<SAMPLE_NUM; i++) begin
                    random_total_sample_stream_len += sample_signal_set[i].total_stream_len;
                end
                random_reset_timing = $urandom_range(TEST_SETUP_PERIOD+1, random_total_sample_stream_len*$urandom_range(1,3)/10);
                repeat(random_reset_timing) @(posedge ACLK);
                $display("TEST INFO: SUDDEN RESET START");
                reset_all;
                $display("TEST INFO: SUDDEN RESET END");
                test_status = RANDOM_SIGNAL_INPUT_NORMAL_OUTPUT_SUDDEN_RESET_CONFIG;
                random_config_timing = $urandom_range(random_reset_timing, random_total_sample_stream_len*$urandom_range(4,9)/10);
                repeat(random_config_timing) @(posedge ACLK);
                $display("TEST INFO: SUDDEN CONFIG START");
                config_module(1, 1024, 1024, H_GAIN_BASELINE, L_GAIN_BASELINE, 1, 1); //acquire_mode rise_thre, fall_thre, h_gain_baseline, l_gain_baseline, pre_acqui_len, post_acqui_len                
                $display("TEST INFO: SUDDEN CONFIG END");
                test_status = RANDOM_SIGNAL_INPUT_NORMAL_OUTPUT_SUDDEN_RESET_CONFIG;
            end
        join

        $display("TEST PASSED: random signal with normal mode (with sudden reset/config) test passed!");

        $display("TEST INFO: All test passed!");
        $finish;

    end

    endmodule