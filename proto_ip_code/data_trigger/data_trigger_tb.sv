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
    parameter integer MAX_ADC_SELECTION_PERIOD_LENGTH = 4;

    reg ACLK = 1'b0;
    reg ARESET = 1'b0;
    reg SET_CONFIG = 1'b0;
    reg STOP = 1'b1;

    // S_AXIS interface from RF Data Converter logic IP
    reg [`RFDC_TDATA_WIDTH-1:0] H_S_AXIS_TDATA;
    reg H_S_AXIS_TVALID;

    // S_AXIS interfrace from L-gain ADC
    reg [`LGAIN_TDATA_WIDTH-1:0] L_S_AXIS_TDATA;
    reg L_S_AXIS_TVALID;

    // Timestamp
    reg [`TIMESTAMP_WIDTH-1:0] TIMESTAMP = 0;
    always @(posedge ACLK) begin
        if (ARESET) begin
            TIMESTAMP <= #100 {`TIMESTAMP_WIDTH{1'b1}};
        end else begin
            TIMESTAMP <= #100 TIMESTAMP + 1;
        end
    end    
        

    // trigger settings
    reg signed [`ADC_RESOLUTION_WIDTH:0] RISING_EDGE_THRSHOLD;
    reg signed [`ADC_RESOLUTION_WIDTH:0] FALLING_EDGE_THRESHOLD;
    reg [$clog2(MAX_PRE_ACQUISITION_LENGTH)-1:0] PRE_ACQUISITION_LENGTH;
    reg [$clog2(MAX_POST_ACQUISITION_LENGTH)-1:0] POST_ACQUISITION_LENGTH;
    reg [$clog2(MAX_ADC_SELECTION_PERIOD_LENGTH)-1:0] ADC_SELECTION_PERIOD_LENGTH;

    wire [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] M_AXIS_TDATA;
    wire M_AXIS_TVALID;

    // h-gain data for charge_sum. timing is syncronized width M_AXIS_TDATA
    wire [`RFDC_TDATA_WIDTH-1:0] H_GAIN_TDATA;

    reg SIG_CLK = 1'b0;
    reg [$clog2(`SAMPLE_NUM_PER_CLK)-1:0] h_disp_ptr = 0;
    reg [$clog2(`SAMPLE_NUM_PER_CLK)-1:0] h_out_disp_ptr = 0;
    reg [$clog2(`LGAIN_SAMPLE_NUM_PER_CLK)-1:0] l_disp_ptr = 0;
    wire [`SAMPLE_WIDTH-1:0] h_sample = H_S_AXIS_TDATA[h_disp_ptr*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
    wire [`SAMPLE_WIDTH-1:0] h_out_sample = H_GAIN_TDATA[h_out_disp_ptr*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
    wire [`SAMPLE_WIDTH-1:0] l_sample = L_S_AXIS_TDATA[l_disp_ptr*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
    
    always @(posedge SIG_CLK) begin
        h_disp_ptr <= #100 h_disp_ptr + 1;
        l_disp_ptr <= #100 l_disp_ptr + 1;
        h_out_disp_ptr <= #100 h_out_disp_ptr + 1;
    end
    
    data_trigger # (
        // these parameter must be configured before logic synthesis
        .MAX_PRE_ACQUISITION_LENGTH(MAX_PRE_ACQUISITION_LENGTH),
        .MAX_POST_ACQUISITION_LENGTH(MAX_POST_ACQUISITION_LENGTH),
        .MAX_ADC_SELECTION_PERIOD_LENGTH(MAX_ADC_SELECTION_PERIOD_LENGTH)
    ) DUT (
        .*
    );

    enum integer {
        INTITIALIZE,
        RESET_ALL,
        CONFIGURING, 
        NORMAL_SIGNAL_INPUT,
        SATURATED_SIGNAL_INPUT
    } test_status;

    task reset_all;
        test_status = RESET_ALL;

        repeat(RESET_CLK_NUM) @(posedge ACLK);
        ARESET <= #100 1'b1;
        @(posedge ACLK);
        ARESET <= #100 1'b0;
    endtask

    task config_module( 
        input int rise_edge_thre, 
        input int fall_edge_thre, 
        input int pre_acqui_len, 
        input int post_acqui_len, 
        input int adc_select_len );
        
        test_status = CONFIGURING;
        // configuring DUT
        @(posedge ACLK);
        SET_CONFIG <= #100 1'b1;
        RISING_EDGE_THRSHOLD <= #100 rise_edge_thre;
        FALLING_EDGE_THRESHOLD <= #100 fall_edge_thre;
        PRE_ACQUISITION_LENGTH <= #100 pre_acqui_len;
        POST_ACQUISITION_LENGTH <= #100 post_acqui_len;
        ADC_SELECTION_PERIOD_LENGTH <= #100 adc_select_len;

        @(posedge ACLK);
        SET_CONFIG <= #100 1'b0;       
    endtask        

    initial begin
        ACLK =0;
        forever #(ACLK_PERIOD/2)   ACLK = ~ ACLK;   
    end

    initial begin
        SIG_CLK =0;
        forever #(SIGNAL_PERIOD/2)   SIG_CLK = ~ SIG_CLK;   
    end

    task normal_signal_input(input SignalGenerator sample_signal[], input int sample_num);
        test_status = NORMAL_SIGNAL_INPUT;

        $display("TEST START: input non-satuated signal");
        @(posedge ACLK);
        H_S_AXIS_TVALID <= #100 1'b0;
        L_S_AXIS_TVALID <= #100 1'b0;
        STOP <= #100 1'b0;
        fork
            begin
                for (int i=0; i<sample_num; i++) begin
                    h_gain_signal_line_t h_gain_signal_set;
                    l_gain_signal_line_t l_gain_signal_set;
                    h_gain_signal_set =  sample_signal[i].getHGainSignalStream();
                    l_gain_signal_set =  sample_signal[i].getLGainSignalStream();                    
                    for (int j=0; j<sample_signal[i].total_stream_len; j++) begin
                        @(posedge ACLK);
                        H_S_AXIS_TVALID <= #100 1'b1;
                        H_S_AXIS_TDATA <= #100 h_gain_signal_set[j];
                        
                        L_S_AXIS_TVALID <= #100 1'b1;
                        L_S_AXIS_TDATA <= #100 l_gain_signal_set[j];
                    end                    
                end
            end
        join
        $display("TEST PASSED: non-satuated signal test passed!");
    endtask

    parameter integer SAMPLE_NUM = 10;
    signal_config_pack signal_config[SAMPLE_NUM];
    SignalGenerator sample_signal_set[SAMPLE_NUM];

    initial begin
        test_status = INTITIALIZE;
        for (int i=0; i<SAMPLE_NUM; i++) begin
            signal_config[i].rise_time = 5*(i+1);
            signal_config[i].high_time = 10*(i+1);
            signal_config[i].fall_time = 20*(i+1);
            sample_signal_set[i] = new(signal_config[i]);
            sample_signal_set[i].sampleFilling(2046, 0, 20); // max, baselibe, noise_amp
        end

        reset_all;
        config_module(1024, 512, 1, 1, 2); // rise_thre, fall_thre, dig_baseline, pre_acqui_len, post_acqui_len, adc_select_period
        normal_signal_input(sample_signal_set, SAMPLE_NUM);
    end
    
endmodule