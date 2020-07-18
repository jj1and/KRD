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
    reg SET_CONFIG = 1'b0;
    reg STOP = 1'b1;
    reg ACQUIRE_MODE = 1'b0;   

    // trigger settings
    reg signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRSHOLD = 1024;
    reg signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD = 1024;
    reg signed [`ADC_RESOLUTION_WIDTH:0] H_GAIN_BASELINE = -1024;
    reg signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE = 256;
    reg [$clog2(MAX_PRE_ACQUISITION_LENGTH):0] PRE_ACQUISITION_LENGTH = 1;
    reg [$clog2(MAX_POST_ACQUISITION_LENGTH):0] POST_ACQUISITION_LENGTH = 1;
    
    // S_AXIS interface from RF Data Converter logic IP
    reg [`RFDC_TDATA_WIDTH-1:0] H_S_AXIS_TDATA;
    reg H_S_AXIS_TVALID = 1'b0;

    // S_AXIS interfrace from L-gain ADC
    reg [`LGAIN_TDATA_WIDTH-1:0] L_S_AXIS_TDATA;
    reg L_S_AXIS_TVALID = 1'b0;
    
    // S_AXIS interface from DSP module
    reg [`RFDC_TDATA_WIDTH-1:0] DSP_S_AXIS_TDATA = {`RFDC_TDATA_WIDTH{1'b1}};
    reg DSP_S_AXIS_TVALID = 1'b0;    

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
    reg [$clog2(`SAMPLE_NUM_PER_CLK)-1:0] h_disp_ptr = 0;
    reg [$clog2(`SAMPLE_NUM_PER_CLK)-1:0] h_out_disp_ptr = 0;
    reg [$clog2(`SAMPLE_NUM_PER_CLK/2)-1:0] h_comb_out_disp_ptr = 0;
    reg [$clog2(`LGAIN_SAMPLE_NUM_PER_CLK)-1:0] l_disp_ptr = 0;
    wire signed  [`ADC_RESOLUTION_WIDTH-1:0] h_sample = H_S_AXIS_TDATA[h_disp_ptr*`SAMPLE_WIDTH+(`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH) +:`ADC_RESOLUTION_WIDTH];
    wire signed [`SAMPLE_WIDTH-1:0] h_out_sample = H_GAIN_TDATA[h_out_disp_ptr*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
    wire [`SAMPLE_WIDTH-1:0] l_sample = L_S_AXIS_TDATA[l_disp_ptr*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
    wire [`RFDC_TDATA_WIDTH-1:0] m_axis_rfdc_tdata = M_AXIS_TDATA[`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1 -:`RFDC_TDATA_WIDTH];
    wire [`SAMPLE_WIDTH-1:0] m_axis_normal_sample[`SAMPLE_NUM_PER_CLK];
    wire signed [`SAMPLE_WIDTH-1:0] m_axis_combined_h_sample[4];
    wire signed [`SAMPLE_WIDTH-1:0] m_axis_combined_l_sample[2];
    wire signed [`SAMPLE_WIDTH-1:0] combined_h_sample = m_axis_combined_h_sample[h_comb_out_disp_ptr];
    wire signed [`SAMPLE_WIDTH-1:0] combined_l_sample = m_axis_combined_l_sample[l_disp_ptr];
    
    reg signed [`SAMPLE_WIDTH-1:0] m_axis_output_sample;
    wire [`TRIGGER_CONFIG_WIDTH-1:0] m_axis_trigger_config = M_AXIS_TDATA[0 +:`TRIGGER_CONFIG_WIDTH];
    wire [`TIMESTAMP_WIDTH-1:0] m_axis_timestamp = M_AXIS_TDATA[`TRIGGER_CONFIG_WIDTH +:`TIMESTAMP_WIDTH];
    wire m_axis_gain_type = M_AXIS_TDATA[`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH + 5-1];  
    
    always @(*) begin
        if (m_axis_gain_type==1'b0) begin
            m_axis_output_sample = combined_l_sample;    
        end else begin
            m_axis_output_sample = h_out_sample;
        end
    end
    
   reg [`SAMPLE_NUM_PER_CLK-1:0] satulation;
   wire saturation_trigger = |satulation; 
   always @(*) begin
        for (int i=0; i<`SAMPLE_NUM_PER_CLK; i++) begin
            if (|{H_S_AXIS_TDATA[i*`SAMPLE_WIDTH+(`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH) +:`ADC_RESOLUTION_WIDTH]==12'h400, H_S_AXIS_TDATA[i*`SAMPLE_WIDTH+(`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH) +:`ADC_RESOLUTION_WIDTH]==12'h800}) begin
                satulation[i] = 1;
            end else begin
                satulation[i] = 0;
            end
        end
    end    
    

    reg normal_trigger = 1'b0;
    wire trigger = normal_trigger|saturation_trigger;
    wire extend_trigger[$clog2(MAX_POST_ACQUISITION_LENGTH):0];
    reg [$clog2(MAX_POST_ACQUISITION_LENGTH):0] trigger_shift_reg;
    reg  extend_trigger_delay[$clog2(MAX_POST_ACQUISITION_LENGTH):0];
    wire extend_trigger_posedge[$clog2(MAX_POST_ACQUISITION_LENGTH):0];
    always @(posedge ACLK) begin
        trigger_shift_reg <= #100 {trigger_shift_reg[$clog2(MAX_POST_ACQUISITION_LENGTH)-1:0], trigger};
        for (int i=0; i<=$clog2(MAX_POST_ACQUISITION_LENGTH); i++) begin
            extend_trigger_delay[i] <= #100 extend_trigger[i];
        end
    end 
    
   genvar i;
   generate
       for (i=0; i<MAX_POST_ACQUISITION_LENGTH; i++) begin
           assign extend_trigger[i] = |{trigger_shift_reg[i:0], trigger};
           assign extend_trigger_posedge[i] = (extend_trigger[i])&(!extend_trigger_delay[i]);
       end
       for (i=0; i<`SAMPLE_NUM_PER_CLK; i++) begin
           assign m_axis_normal_sample[i] = m_axis_rfdc_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
           if (i%4==0) begin
                assign m_axis_combined_l_sample[i/4] = m_axis_rfdc_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
           end else if ((i-1)%4==0) begin
                assign m_axis_combined_h_sample[(i-1)/2] = m_axis_rfdc_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
           end else if ((i-2)%4==0) begin
                assign m_axis_combined_h_sample[(i-2)/2+1] = m_axis_rfdc_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
           end
       end
   endgenerate   

    always @(posedge SIG_CLK) begin
        h_disp_ptr <= h_disp_ptr + 1;
        h_out_disp_ptr <= h_out_disp_ptr + 1;
    end

    always @(posedge HALF_SIG_CLK) begin
        h_comb_out_disp_ptr <= h_comb_out_disp_ptr + 1;
    end
    
    always @(posedge L_GAIN_SIG_CLK) begin
        l_disp_ptr <= l_disp_ptr + 1;
    end    
    
    data_trigger # (
        // these parameter must be configured before logic synthesis
        .MAX_PRE_ACQUISITION_LENGTH(MAX_PRE_ACQUISITION_LENGTH),
        .MAX_POST_ACQUISITION_LENGTH(MAX_POST_ACQUISITION_LENGTH)
    ) DUT (
        .*
    );

    task reset_all;
        test_status = RESET_ALL;

        repeat(RESET_CLK_NUM) @(posedge ACLK);
        ARESET <= #100 1'b1;
        @(posedge ACLK);
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
        @(posedge ACLK);
        SET_CONFIG <= #100 1'b1;
        ACQUIRE_MODE <= #100 acquire_mode;
        RISING_EDGE_THRSHOLD <= #100 rise_edge_thre;
        FALLING_EDGE_THRESHOLD <= #100 fall_edge_thre;
        H_GAIN_BASELINE <= #100 h_baseline;
        L_GAIN_BASELINE <= #100 l_baseline;
        PRE_ACQUISITION_LENGTH <= #100 pre_acqui_len;
        POST_ACQUISITION_LENGTH <= #100 post_acqui_len;
        
        @(posedge ACLK);
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
    parameter integer BASELINE = 0;
    int saturation_flag;

    bit [`RFDC_TDATA_WIDTH-1:0] h_expected_tdata_pre_queue[$];
    bit [`RFDC_TDATA_WIDTH-1:0] l_expected_tdata_pre_queue[$];
    bit [`RFDC_TDATA_WIDTH-1:0] acquired_h_gain_tdata_queue[$];
    bit [`RFDC_TDATA_WIDTH-1:0] acquired_l_gain_tdata_queue[$];
    bit [`RFDC_TDATA_WIDTH-1:0] expected_out_h_tdata;
    bit [`RFDC_TDATA_WIDTH-1:0] expected_out_l_tdata;
    bit signed [`SAMPLE_WIDTH-1:0] input_h_sample[`SAMPLE_NUM_PER_CLK];
    bit signed [`SAMPLE_WIDTH:0] sum_input_h_sample[`SAMPLE_NUM_PER_CLK/2];
    bit signed [`SAMPLE_WIDTH-1:0] input_l_sample[`LGAIN_SAMPLE_NUM_PER_CLK];    

    bit [`RFDC_TDATA_WIDTH-1:0] h_expected_tdata_pre_queue_head;
    bit [`RFDC_TDATA_WIDTH-1:0] l_expected_tdata_pre_queue_head;

    task data_trigger_monitor;
        int test_failed;
        bit [`RFDC_TDATA_WIDTH-1:0] read_out_h_tdata;
        bit [`RFDC_TDATA_WIDTH-1:0] read_out_l_tdata;
        bit signed [`SAMPLE_WIDTH-1:0] read_out_h_sample[`SAMPLE_NUM_PER_CLK];
        bit signed [`SAMPLE_WIDTH-1:0] h_gain_base_line;
        int timeout_counter;

        timeout_counter = 0;
        h_expected_tdata_pre_queue.delete();
        l_expected_tdata_pre_queue.delete();        
        
        while (timeout_counter<TIME_OUT_THRE) begin
            @(posedge ACLK);
            
            // convert raw h-gain adc data to output data
            for (int i=0; i<`SAMPLE_NUM_PER_CLK; i++) begin
                input_h_sample[i] = { {`SAMPLE_WIDTH-(`ADC_RESOLUTION_WIDTH){H_S_AXIS_TDATA[(i+1)*`SAMPLE_WIDTH-1]}}, H_S_AXIS_TDATA[i*`SAMPLE_WIDTH+`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH +:`ADC_RESOLUTION_WIDTH] };
                expected_out_h_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] =  input_h_sample[i] - DUT.h_gain_baseline;
            end
            
            // convert raw l-gain and h-gain adc data to combined output data
            for (int i=0; i<`SAMPLE_NUM_PER_CLK; i++) begin
                if (i%4==0) begin
                    input_l_sample[i/4] = L_S_AXIS_TDATA[(i/4)*`SAMPLE_WIDTH +:`SAMPLE_WIDTH];
                    expected_out_l_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = input_l_sample[i/4] - DUT.l_gain_baseline;
                end else if ((i-1)%4==0) begin
                    sum_input_h_sample[(i-1)/4] = (input_h_sample[i] + input_h_sample[i-1] - 2*DUT.h_gain_baseline);
                    expected_out_l_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = sum_input_h_sample[(i-1)/4][`SAMPLE_WIDTH:1];
                end else if ((i-2)%4==0) begin
                    sum_input_h_sample[(i-2)/4+2] = (input_h_sample[i] + input_h_sample[i+1] - 2*DUT.h_gain_baseline);
                    expected_out_l_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] = sum_input_h_sample[(i-2)/4+2][`SAMPLE_WIDTH:1];
                end else if ((i-3)%4==0) begin
                    expected_out_l_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] =16'hCC00;
                end                      
            end
                                     
            if (&{!ARESET, !SET_CONFIG, extend_trigger[DUT.pre_acquisition_length-1]}) begin
                if (extend_trigger_posedge[DUT.pre_acquisition_length-1]) begin
                    for (int i=MAX_PRE_ACQUISITION_LENGTH+1-DUT.pre_acquisition_length;i<MAX_PRE_ACQUISITION_LENGTH+1; i++) begin
                        if (|{h_expected_tdata_pre_queue.size()==0, l_expected_tdata_pre_queue.size()==0}) begin
                            $display("TEST ERROR: pre acquire queue is empty!");
                            $finish;                            
                        end
//                        $display("h gain pre acqire:[%0d]:%x", i, h_expected_tdata_pre_queue[i]);
//                        $display("l gain pre acqire:[%0d]:%x", i, l_expected_tdata_pre_queue[i]);
                        acquired_h_gain_tdata_queue.push_back(h_expected_tdata_pre_queue[i]);
                        acquired_l_gain_tdata_queue.push_back(l_expected_tdata_pre_queue[i]);
                        $display("TEST INFO: H-gain pre acqire: %x", expected_out_h_tdata);
                    end
                end            
                acquired_h_gain_tdata_queue.push_back(expected_out_h_tdata);
                acquired_l_gain_tdata_queue.push_back(expected_out_l_tdata);
                $display("TEST INFO: H-gain acqire:%x", expected_out_h_tdata);
            end
            
            if (h_expected_tdata_pre_queue.size()<MAX_PRE_ACQUISITION_LENGTH+1) begin
                h_expected_tdata_pre_queue.push_back(expected_out_h_tdata);
                l_expected_tdata_pre_queue.push_back(expected_out_l_tdata);
            end else begin
                h_expected_tdata_pre_queue.pop_front();
                l_expected_tdata_pre_queue.pop_front();
                h_expected_tdata_pre_queue.push_back(expected_out_h_tdata);
                l_expected_tdata_pre_queue.push_back(expected_out_l_tdata);
//                $display("h gain pre acqire:%x", expected_out_h_tdata);
//                $display("l gain pre acqire:%x", expected_out_l_tdata);                            
            end
            h_expected_tdata_pre_queue_head = h_expected_tdata_pre_queue[DUT.pre_acquisition_length];
            l_expected_tdata_pre_queue_head = l_expected_tdata_pre_queue[DUT.pre_acquisition_length];                                  
                                  
            // macthing with data_trigger output
            if (M_AXIS_TVALID) begin
                timeout_counter = 0;
                // read out data from queue
                if (|{acquired_h_gain_tdata_queue.size()==0, acquired_l_gain_tdata_queue.size()==0}) begin
                    $display("TEST FAILED: acquired tdata queue is empty!");
                    $finish;
                end else begin
                    read_out_h_tdata = acquired_h_gain_tdata_queue.pop_front();
                    read_out_l_tdata = acquired_l_gain_tdata_queue.pop_front();                                 
                end
                
                // check saturation
                saturation_flag = 0;
                for (int i=0; i<`SAMPLE_NUM_PER_CLK; i++) begin
                    read_out_h_sample[i] = read_out_h_tdata[i*`SAMPLE_WIDTH +:`SAMPLE_WIDTH]+{ {`SAMPLE_WIDTH-(`ADC_RESOLUTION_WIDTH+1){DUT.h_gain_baseline[`ADC_RESOLUTION_WIDTH]}}, DUT.h_gain_baseline};
                    if (|{read_out_h_sample[i]==2047, read_out_h_sample[i]==-2048}) begin
                        saturation_flag = 1;
                    end
                end
                              
                // macthing with data_trigger output
                if (|{saturation_flag, DUT.acquire_mode==1'b1}) begin
                    if (m_axis_rfdc_tdata!=read_out_l_tdata) begin
                        $display("TEST FAILED: output data doesn't match with input; input:%0x output:%0x", read_out_l_tdata, m_axis_rfdc_tdata); 
                        $finish;
                    end
                end else begin
                    if (m_axis_rfdc_tdata!=read_out_h_tdata) begin
                        $display("TEST FAILED: output data doesn't match with input; input:%0x output:%0x", read_out_h_tdata, m_axis_rfdc_tdata); 
                        $finish;
                    end                        
                end                         
            end else begin
                timeout_counter++;
            end
        end
        if (&{acquired_h_gain_tdata_queue.size()>0, acquired_l_gain_tdata_queue.size()>0}) begin
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
    int saturation;
    
    wire [`RFDC_TDATA_WIDTH-1:0] h_gain_default = {`SAMPLE_NUM_PER_CLK{{{`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH-1{H_GAIN_BASELINE[`ADC_RESOLUTION_WIDTH]}}, H_GAIN_BASELINE}}};
    wire [`LGAIN_TDATA_WIDTH-1:0] l_gain_default = {`LGAIN_SAMPLE_NUM_PER_CLK{L_GAIN_BASELINE}};
    wire signed [`ADC_RESOLUTION_WIDTH:0] h_positive_overflow = 13'h07FF;
    wire signed [`ADC_RESOLUTION_WIDTH:0] h_negative_overflow = 13'h1800;             

    task signal_input(input SignalGenerator sample_signal[], input int sample_num);
        bit signed [`ADC_RESOLUTION_WIDTH:0] sample_val;
        bit signed [`ADC_RESOLUTION_WIDTH-1:0] sample_bl_subtracted_val;
        bit signed [`SAMPLE_WIDTH-1:0] sample_bl_subtracted_val_sign_extended;    
        bit [`SAMPLE_NUM_PER_CLK-1:0] rise_thre_over;
        bit [`SAMPLE_NUM_PER_CLK-1:0] fall_thre_under;
        bit signed [`ADC_RESOLUTION_WIDTH:0] h_tdata_sample[`SAMPLE_NUM_PER_CLK];   
        bit signed [`ADC_RESOLUTION_WIDTH:0] dsp_tdata_sample[`SAMPLE_NUM_PER_CLK];  
        
        @(posedge ACLK);
        H_S_AXIS_TVALID <= #100 1'b1;
        L_S_AXIS_TVALID <= #100 1'b1;
        STOP <= #100 1'b0;        
        
        fork
            begin
                for (int i=0; i<TEST_SETUP_PERIOD; i++) begin
                    @(posedge ACLK);
                    H_S_AXIS_TVALID <= #100 1'b1;
                    H_S_AXIS_TDATA <= #100 h_gain_default;
                    
                    L_S_AXIS_TVALID <= #100 1'b1;
                    L_S_AXIS_TDATA <= #100 l_gain_default;
                    
                    DSP_S_AXIS_TVALID <= #100 1'b1;
                    for (int k=0; k<`SAMPLE_NUM_PER_CLK; k++) begin
                        h_tdata_sample[k] = {h_gain_default[(k+1)*`SAMPLE_WIDTH-1], h_gain_default[k*`SAMPLE_WIDTH+`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH +:`ADC_RESOLUTION_WIDTH] };
                        dsp_tdata_sample[k] = h_tdata_sample[k] - H_GAIN_BASELINE;
                        DSP_S_AXIS_TDATA[k*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] <= #100 { {`SAMPLE_WIDTH-(`ADC_RESOLUTION_WIDTH+1){dsp_tdata_sample[k][`ADC_RESOLUTION_WIDTH]}},  dsp_tdata_sample[k] };
                    end                           
                end            
            
                for (int i=0; i<sample_num; i++) begin
                    h_gain_signal_line_t h_gain_signal_set;
                    l_gain_signal_line_t l_gain_signal_set;
                    
                    trigger_start[i].delete();
                    trigger_end[i].delete();

                    // get triggered range in sample
                    for (int j=0; j<sample_signal[i].total_stream_len; j++) begin
                        saturation = 0;
                        for (int k=0; k<`SAMPLE_NUM_PER_CLK; k++) begin
                            sample_val = {sample_signal[i].sample_ary[j*`SAMPLE_NUM_PER_CLK+k][`SAMPLE_WIDTH-1], sample_signal[i].sample_ary[j*`SAMPLE_NUM_PER_CLK+k][`SAMPLE_WIDTH-1 :`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH]};
                            sample_bl_subtracted_val = sample_val - DUT.h_gain_baseline;
                            sample_bl_subtracted_val_sign_extended = { {`SAMPLE_WIDTH-(`ADC_RESOLUTION_WIDTH+1){sample_bl_subtracted_val[`ADC_RESOLUTION_WIDTH]}}, sample_bl_subtracted_val};
//                            $display("%d", sample_bl_subtracted_val_sign_extended);
                            
                            // get index trigger starts
                            if (sample_bl_subtracted_val_sign_extended>DUT.rising_edge_threshold) begin
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
                            if (&{sample_bl_subtracted_val_sign_extended<DUT.falling_edge_threshold, sample_val!=-2048}) begin
                                fall_thre_under[k] = 1'b1;    
                            end else begin
                                fall_thre_under[k] = 1'b0; 
                            end                
                        end
                        if (&{trigger_start[i].size()>0, &fall_thre_under}) begin
                            trigger_end[i].push_back(j);
                        end                                
                    end
                    
                    if (trigger_start[i].size()==0) begin
                        trigger_start[i].push_back(0);
                    end else if (trigger_end[i].size()==0) begin
                         trigger_end[i].push_back(sample_signal[i].total_stream_len-1);
                    end

                    h_gain_signal_set =  sample_signal[i].getHGainSignalStream();
                    l_gain_signal_set =  sample_signal[i].getLGainSignalStream();                    
                    for (int j=0; j<sample_signal[i].total_stream_len; j++) begin
                        @(posedge ACLK);                                                    
                        if (j==trigger_start[i][0]) begin
                            normal_trigger <= #100 1'b1;
                            trigger_start[i].pop_front();
                        end
                        if (j==trigger_end[i][0]) begin
                            normal_trigger <= #100 1'b0;
                            trigger_end[i].pop_front();
                        end
                        H_S_AXIS_TVALID <= #100 1'b1;
                        H_S_AXIS_TDATA <= #100 h_gain_signal_set[j];
                        
                        L_S_AXIS_TVALID <= #100 1'b1;
                        L_S_AXIS_TDATA <= #100 l_gain_signal_set[j];
                        
                        DSP_S_AXIS_TVALID <= #100 1'b1;
                        for (int k=0; k<`SAMPLE_NUM_PER_CLK; k++) begin
                            h_tdata_sample[k] = {h_gain_signal_set[j][(k+1)*`SAMPLE_WIDTH-1], h_gain_signal_set[j][k*`SAMPLE_WIDTH+`SAMPLE_WIDTH-`ADC_RESOLUTION_WIDTH +:`ADC_RESOLUTION_WIDTH] };
                            dsp_tdata_sample[k] = h_tdata_sample[k] - DUT.h_gain_baseline;
                            DSP_S_AXIS_TDATA[k*`SAMPLE_WIDTH +:`SAMPLE_WIDTH] <= #100 { {`SAMPLE_WIDTH-(`ADC_RESOLUTION_WIDTH+1){dsp_tdata_sample[k][`ADC_RESOLUTION_WIDTH]}},  dsp_tdata_sample[k] };
                        end                                                  
                    end                    
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
        FIXED_SATURATED_SIGNAL_INPUT_COMBINED_OUTPUT        
    } test_status;    

    initial begin
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
//        $display("TEST INFO: Trigger config: ACQUIRE_MODE:%0d, RISING_THRESHOLD:%0d, FALLING_THRESHOLD:%0d, H_GAIN_BASELINE:%d, L_GAIN_BASELINE:%d, PRE_ACQUI_LEN:%d, POST_ACQUI_LEN:%d ", 0, 1024, 512, H_GAIN_BASELINE, L_GAIN_BASELINE, 1, 1); 
        config_module(0, 1024, 512, H_GAIN_BASELINE, L_GAIN_BASELINE, 1, 1); //acquire_mode rise_thre, fall_thre, h_gain_baseline, l_gain_baseline, pre_acqui_len, post_acqui_len
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
        
        $display("TEST INFO: All test passed!");
        $finish;
    end
    
endmodule