`timescale 1ps/1ps


`include "test_dataframe_gen_pkg.sv"
import test_dataframe_gen_pkg::*;

module dataframe_generator_tb;

    parameter integer ACLK_PERIOD = 8000;
    parameter integer RESET_CLK_NUM = 10;
    parameter integer CHANNEL_ID_NUM = 0;

    reg ACLK = 1'b1;
    reg ARESET = 1'b1;

    // Data frame length configuration
    reg SET_CONFIG = 1'b0;
    reg [15:0] MAX_TRIGGER_LENGTH = 256;

    // Input signals from trigger
    reg [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] S_AXIS_TDATA; // TDATA from RF Data Converter logic IP
    reg S_AXIS_TVALID = 1'b0;
    wire [`RFDC_TDATA_WIDTH-1:0] s_axis_rfdc_tdata = S_AXIS_TDATA[`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH +:`RFDC_TDATA_WIDTH];
    wire [`TRIGGER_INFO_WIDTH-1:0] s_axis_trigger_info = S_AXIS_TDATA[`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH +:`TRIGGER_INFO_WIDTH];
    wire [`TIMESTAMP_WIDTH-1:0] s_axis_timestamp =  S_AXIS_TDATA[`TRIGGER_CONFIG_WIDTH +:`TIMESTAMP_WIDTH];
    wire [`TRIGGER_CONFIG_WIDTH-1:0] s_axis_trigger_config = S_AXIS_TDATA[0 +:`TRIGGER_CONFIG_WIDTH];
    
    wire S_AXIS_TREADY;

    reg M_AXIS_TREADY;
    wire M_AXIS_TVALID;
    wire [`RFDC_TDATA_WIDTH-1:0] M_AXIS_TDATA;
    wire [`RFDC_TDATA_WIDTH/8-1:0] M_AXIS_TKEEP;
    wire M_AXIS_TLAST;

    wire [`DATAFRAME_WIDTH-1:0] m_axis_tdata_dframe[`RFDC_TDATA_WIDTH/`DATAFRAME_WIDTH-1:0];
    genvar i;
    generate
    for (i=0; i<`RFDC_TDATA_WIDTH/`DATAFRAME_WIDTH; i++) begin
        assign m_axis_tdata_dframe[i] = M_AXIS_TDATA[i*`DATAFRAME_WIDTH +:`DATAFRAME_WIDTH];
    end
    endgenerate    

    wire [`CH_ID_WIDTH-1:0] ch_id = m_axis_tdata_dframe[0][`HEADER_TIMESTAMP_WIDTH+`TRIGGER_TYPE_WIDTH+`FRAME_INFO_WIDTH+`FRAME_LENGTH_WIDTH +:`CH_ID_WIDTH];
    wire [`FRAME_LENGTH_WIDTH-1:0] frame_len = m_axis_tdata_dframe[0][`HEADER_TIMESTAMP_WIDTH+`TRIGGER_TYPE_WIDTH+`FRAME_INFO_WIDTH +:`FRAME_LENGTH_WIDTH]; 
    wire [`FRAME_INFO_WIDTH-1:0] frame_info = m_axis_tdata_dframe[0][`HEADER_TIMESTAMP_WIDTH+`TRIGGER_TYPE_WIDTH +:`FRAME_INFO_WIDTH];
    wire [`TRIGGER_TYPE_WIDTH-1:0] trigger_type = m_axis_tdata_dframe[0][`HEADER_TIMESTAMP_WIDTH +:`TRIGGER_TYPE_WIDTH];
    wire [`HEADER_TIMESTAMP_WIDTH-1:0] header_timestamp = m_axis_tdata_dframe[0][0 +:`HEADER_TIMESTAMP_WIDTH];
    wire [`CHARGE_SUM-1:0] charge_sum = m_axis_tdata_dframe[1][`TRIGGER_CONFIG_WIDTH +:`CHARGE_SUM];
    wire [`TRIGGER_CONFIG_WIDTH-1:0] trigger_config = m_axis_tdata_dframe[1][0 +:`TRIGGER_CONFIG_WIDTH];
    wire [`FOOTER_TIMESTAMP_WIDTH-1:0] footer_timestamp = m_axis_tdata_dframe[0][`FOOTER_ID_WIDTH+`OBJECT_ID_WIDTH +:`FOOTER_TIMESTAMP_WIDTH];
    wire [`OBJECT_ID_WIDTH-1:0] object_id = m_axis_tdata_dframe[0][`FOOTER_ID_WIDTH +:`OBJECT_ID_WIDTH];
    wire [`TIMESTAMP_WIDTH-1:0] timestamp = {footer_timestamp, header_timestamp};    
    wire DATAFRAME_GEN_ERROR;

    dataframe_generator_top # (
        .CHANNEL_ID(CHANNEL_ID_NUM),
        .ADC_FIFO_DEPTH(2**5),
        .HF_FIFO_DEPTH(2**3)
    ) DUT (
        .*
    );

    enum integer {
        INTITIALIZE,
        RESET_ALL,
        CONFIGURING, 
        WRITE_IN_WO_BACKPRESSURE,
        WRITE_IN_WITH_ADC_FIFO_BACKPRESSURE,
        WRITE_IN_WITH_HF_FIFO_BACKPRESSURE
    } test_status;

    enum int { 
            FIXED_RESET_CONFIG_TIMING,
            RANDOM_RESET_CONFIG_TIMING         
    } rst_cfg_timing;

    enum bit [1:0] {
        IDLE = 2'b00,
        START = 2'b01,
        RUNNING = 2'b11,
        STOP = 2'b10
    } trigger_state;    

    task reset_all;
        test_status = RESET_ALL;
        repeat(RESET_CLK_NUM) @(posedge ACLK);
        ARESET <= #100 1'b1;
        @(posedge ACLK);
        ARESET <= #100 1'b0;
    endtask

    task config_module;
        test_status = CONFIGURING;
        // configuring DUT
        @(posedge ACLK);
        SET_CONFIG <= #100 1'b1;
        MAX_TRIGGER_LENGTH <= #100 64;
        @(posedge ACLK);
        SET_CONFIG <= #100 1'b0;       
    endtask    

    initial begin
        ACLK =0;
        forever #(ACLK_PERIOD/2)   ACLK = ~ ACLK;   
    end

    parameter integer SAMPLE_FRAME_NUM = 10;
    frame_config_pack sample_config[SAMPLE_FRAME_NUM];
    DataFrame sample_frame[SAMPLE_FRAME_NUM];
    datastream_line_t sample_tdata_set[SAMPLE_FRAME_NUM];
    dataframe_line_t sample_dframe_set[SAMPLE_FRAME_NUM];

    parameter integer RAND_SAMPLE_FRAME_NUM = 20;
    frame_config_pack rand_sample_config[RAND_SAMPLE_FRAME_NUM];
    DataFrame rand_sample_frame[RAND_SAMPLE_FRAME_NUM];
    datastream_line_t rand_sample_tdata_set[RAND_SAMPLE_FRAME_NUM];
    dataframe_line_t rand_sample_dframe_set[RAND_SAMPLE_FRAME_NUM];

    task dataframe_generator_output_monitor(input DataFrame dframe[], input datastream_line_t tdata_set[], input int dframe_num);
        integer dframe_index;
        integer frame_len_cnt;
        integer divide_frame_len;
        integer divide_charge_sum;
        bit [`TIMESTAMP_WIDTH-1:0] expected_timestamp;        
        dframe_index = -1;
        frame_len_cnt = -1;
        divide_frame_len = 0;
        divide_charge_sum = 0;                        
        while (dframe_index<dframe_num) begin
            @(posedge ACLK);
            if (DUT.header_footer_gen_inst.s_axis_tvalid_posedge==1'b1) begin
                dframe_index++;
                if (~|{DUT.ADC_FIFO_FULL, DUT.HF_FIFO_FULL, ARESET, SET_CONFIG}) begin                    
                    frame_len_cnt = 0;
                    divide_frame_len = 0;
                    divide_charge_sum = 0;                      
                end else begin
                    $display("TEST INFO: trigger is halted. Skip sample_frame[%d]", dframe_index);
                    frame_len_cnt = -1;
                    divide_frame_len = -1;
                    divide_charge_sum = -1;                    
                end
            end else begin
                if (DUT.ADC_FIFO_RD_EN&&(frame_len_cnt>=0)) begin
                    frame_len_cnt++;
                end else if (DUT.header_footer_gen_inst.s_axis_tvalid_negedge==1'b1) begin
                    frame_len_cnt=-1;                            
                end
            end

            if ((DUT.ADC_FIFO_RD_EN==1'b1)&&(frame_len_cnt>=3)) begin
                $display("TEST INFO: Currently sample_frame[%d] line:%d", dframe_index, frame_len_cnt);
                if (tdata_set[dframe_index][frame_len_cnt-3][`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH +:`RFDC_TDATA_WIDTH]!=M_AXIS_TDATA) begin
                    $display("TEST FAILED: input ADC data and output ADC data doesn't match; input:%h output:%h", tdata_set[dframe_index][frame_len_cnt-3][`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH +:`RFDC_TDATA_WIDTH], M_AXIS_TDATA);
                    $finish;
                end
            end              


            if (M_AXIS_TVALID&M_AXIS_TREADY) begin
                if (M_AXIS_TDATA[`RFDC_TDATA_WIDTH-1 -:`HEADER_ID_WIDTH]==`HEADER_ID) begin
                    $cast(trigger_state, frame_info[3:2]);
                    $display("TEST INFO: Trigger State:     %p", trigger_state);
                    if (dframe[dframe_index].ch_id!=ch_id) begin
                        $display("TEST FAILED: ch_id doesn't match; input:%d output:%d", dframe[dframe_index].ch_id, ch_id);
                        $finish;
                    end
                    if (dframe[dframe_index].gain_type!=frame_info[0]) begin
                        $display("TEST FAILED: gain_type doesn't match; input:%b output:%b", dframe[dframe_index].gain_type, frame_info[0]);
                        $finish;
                    end
                    if (dframe[dframe_index].trigger_type!=trigger_type) begin
                        $display("TEST FAILED: trigger_type doesn't match; input:d output:%d", dframe[dframe_index].trigger_type, trigger_type);
                        $finish;
                    end
                    if ({dframe[dframe_index].baseline, dframe[dframe_index].threshold}!=trigger_config) begin
                        $display("TEST FAILED: trigger_config doesn't match; input:%h output:%h", {dframe[dframe_index].baseline, dframe[dframe_index].threshold}, trigger_config);
                        $finish;
                    end

                    if (dframe[dframe_index].frame_len>(MAX_TRIGGER_LENGTH*2)) begin
                        $display("TEST INFO: dframe[%d].frame_len(%d) is larger than maximum dataframe length(%d)", dframe_index, dframe[dframe_index].frame_len, MAX_TRIGGER_LENGTH*2);
                        expected_timestamp = dframe[dframe_index].timestamp+(divide_frame_len/2);
                        if (expected_timestamp[`HEADER_TIMESTAMP_WIDTH-1:0]!=header_timestamp) begin
                            $display("TEST FAILED: timestamp doesn't match; input:%d output:%d", expected_timestamp[`HEADER_TIMESTAMP_WIDTH-1:0], header_timestamp);
                            $finish;
                        end

                        if (trigger_state==STOP) begin
                            $display("TEST INFO: frame_len&charge_sum is smaller than expected because ADC_FIFO is full; sample_frame[%d]", dframe_index);                                      
                        end else if(dframe[dframe_index].frame_len==divide_frame_len+frame_len) begin
                            if (dframe[dframe_index].charge_sum>((2**(`CHARGE_SUM-3)-1)*8)) begin
                                $display("TEST INFO: charge sum is too large. output will be overflow; input:%d", dframe[dframe_index].charge_sum);
                            end else if (dframe[dframe_index].charge_sum!=divide_charge_sum+charge_sum) begin
                                $display("TEST FAILED: charge sum doesn't match; input:%d output:%d", dframe[dframe_index].charge_sum, divide_charge_sum+charge_sum);
                                $finish;
                            end                                                  
                            $display("TEST INFO: Acquired all big frame; sample_frame[%d]", dframe_index);
                            if (frame_info[1]!=1'b0) begin
                                $display("TEST FAILED: 'frame_continue' flag doesn't indicate correct infomation; correct:%b output:%b", 1'b0, frame_info[1]);
                                $finish;
                            end                        
                            divide_frame_len=0;
                            divide_charge_sum=0;
                        end else begin                    
                            if (frame_len!=(DUT.header_footer_gen_inst.max_trigger_len*2)) begin
                                $display("TEST FAILED: divided frame_len doesn't match; MAX_FRAME_LENGTH:%d output:%d",MAX_TRIGGER_LENGTH*2, frame_len);
                                $finish;
                            end else begin
                                if (frame_info[1]!=1'b1) begin
                                    $display("TEST FAILED: 'frame_continue' flag doesn't indicate correct infomation; correct:%b output:%b", 1'b1, frame_info[1]);
                                    $finish;
                                end
                                if (charge_sum==((2**(`CHARGE_SUM-3)-1)*8)) begin
                                    $display("TEST INFO: charge sum is too large. output will be overflow");
                                end                                                     
                                divide_frame_len += frame_len;
                                divide_charge_sum += charge_sum;
                            end                        
                        end                                         
                    end else begin
                        if (dframe[dframe_index].timestamp[`HEADER_TIMESTAMP_WIDTH-1:0]!=header_timestamp) begin
                            $display("TEST FAILED: timestamp doesn't match; input:%d output:%d", dframe[dframe_index].timestamp[`HEADER_TIMESTAMP_WIDTH-1:0], header_timestamp);
                            $finish;
                        end       
                        if (trigger_state==STOP) begin
                            $display("TEST INFO: frame_len&charge_sum is smaller than expected because ADC_FIFO is full; sample_frame[%d]", dframe_index);                                      
                        end else begin
                            if (dframe[dframe_index].frame_len!=frame_len) begin
                                $display("TEST FAILED: frame_len doesn't match; input:%d output:%d", dframe[dframe_index].frame_len, frame_len);
                                $finish;
                            end                        
                            if (dframe[dframe_index].charge_sum!=charge_sum) begin
                                $display("TEST FAILED: charge sum doesn't match; input:%d output:%d", dframe[dframe_index].charge_sum, charge_sum);
                                $finish;
                            end                                                                    
                        end
                    end

                end

                if (M_AXIS_TDATA[0 +:`FOOTER_ID_WIDTH]==`FOOTER_ID) begin
                    if (dframe[dframe_index].frame_len>(MAX_TRIGGER_LENGTH*2)) begin
                        if (expected_timestamp[`HEADER_TIMESTAMP_WIDTH +:`FOOTER_TIMESTAMP_WIDTH]!=footer_timestamp) begin
                            $display("TEST FAILED: timestamp doesn't match; input:%d output:%d", expected_timestamp[`HEADER_TIMESTAMP_WIDTH +:`FOOTER_TIMESTAMP_WIDTH], footer_timestamp);
                            $finish;
                        end                                                                                         
                    end else begin
                        if (dframe[dframe_index].timestamp[`HEADER_TIMESTAMP_WIDTH +:`FOOTER_TIMESTAMP_WIDTH]!=footer_timestamp) begin
                            $display("TEST FAILED: timestamp doesn't match; input:%d output:%d", dframe[dframe_index].timestamp[`HEADER_TIMESTAMP_WIDTH +:`FOOTER_TIMESTAMP_WIDTH], footer_timestamp);
                            $finish;
                        end
                    end

                    if (dframe_index==dframe_num-1) begin
                        $display("TEST INFO: last sample_frame[%d] is Acquired", dframe_index);
                        dframe_index++;
                    end                    
                end
            end
        end       
    endtask    

    task write_in_wo_nobackpressure(input DataFrame dframe[], input datastream_line_t s_axis_tdata_set[], input int dframe_num, input int rst_cfg_timing);
        int SUDDEN_RESET_START[2];
        int SUDDEN_RESET_END[2];        
        int SUDDEN_CONFIG_START[2];
        int SUDDEN_CONFIG_END[2];
        if (rst_cfg_timing==RANDOM_RESET_CONFIG_TIMING) begin
            SUDDEN_RESET_START[0] = $urandom_range(0, dframe_num-1);
            SUDDEN_RESET_START[1] = $urandom_range(0, dframe[SUDDEN_RESET_START[0]].raw_stream_len);
            SUDDEN_RESET_END[0] = $urandom_range(SUDDEN_RESET_START[0], dframe_num-1);
            if (SUDDEN_RESET_END[0]==SUDDEN_RESET_START[0]) begin
                SUDDEN_RESET_END[1] = $urandom_range(SUDDEN_RESET_START[1]+1, dframe[SUDDEN_RESET_START[0]].raw_stream_len);    
            end else begin
                SUDDEN_RESET_END[1] = $urandom_range(0, dframe[SUDDEN_RESET_END[0]].raw_stream_len);
            end

            SUDDEN_CONFIG_START[0] = $urandom_range(0, dframe_num-1);
            SUDDEN_CONFIG_START[1] = $urandom_range(0, dframe[SUDDEN_CONFIG_START[0]].raw_stream_len);
            SUDDEN_CONFIG_END[0] = $urandom_range(SUDDEN_CONFIG_START[0], dframe_num-1);
            if (SUDDEN_CONFIG_END[0]==SUDDEN_CONFIG_START[0]) begin
                SUDDEN_CONFIG_END[1] = $urandom_range(SUDDEN_CONFIG_START[1]+1, dframe[SUDDEN_CONFIG_START[0]].raw_stream_len);    
            end else begin
                SUDDEN_CONFIG_END[1] = $urandom_range(0, dframe[SUDDEN_CONFIG_END[0]].raw_stream_len);
            end            
        end else begin
            SUDDEN_RESET_START[0] = dframe_num/2;
            SUDDEN_RESET_START[1] = dframe[SUDDEN_RESET_START[0]].raw_stream_len/2;
            SUDDEN_RESET_END[0] = dframe_num/2;
            SUDDEN_RESET_START[1] = dframe[SUDDEN_RESET_START[0]].raw_stream_len;

            SUDDEN_CONFIG_START[0] = dframe_num/2;
            SUDDEN_CONFIG_START[1] = dframe[SUDDEN_CONFIG_START[0]].raw_stream_len/2;
            SUDDEN_CONFIG_END[0] = dframe_num/2+1;
            SUDDEN_CONFIG_END[1] = 0;          
        end

        test_status = WRITE_IN_WO_BACKPRESSURE;
        $display("TEST START: write in data with no-backpressure");
        @(posedge ACLK);
        S_AXIS_TVALID <= #100 1'b0;
        M_AXIS_TREADY <= #100 1'b1;
        fork         
            begin          
                for (int i=0; i<dframe_num; i++) begin
                    for (int j=0; j<dframe[i].raw_stream_len; j++) begin
                        @(posedge ACLK);
                        S_AXIS_TDATA <= #100 s_axis_tdata_set[i][j];
                        S_AXIS_TVALID <= #100 1'b1;
                        if ((i==SUDDEN_RESET_START[0])&&(j==SUDDEN_RESET_START[1])) begin
                            $display("TEST INFO: SUDDENLY RESET");
                            ARESET <= #100 1'b1;
                        end else if ((i==SUDDEN_RESET_END[0])&&(j==SUDDEN_RESET_END[1])) begin
                            $display("TEST INFO: Release RESET");
                            ARESET <= #100 1'b0;
                        end
                        if ((i==SUDDEN_CONFIG_START[0])&&(j==SUDDEN_CONFIG_START[1])) begin
                            $display("TEST INFO: SUDDENLY CONFIG");
                            SET_CONFIG <= #100 1'b1;
                        end else if ((i==SUDDEN_CONFIG_END[0])&&(j==SUDDEN_CONFIG_END[1])) begin
                            $display("TEST INFO: Release CONFIG");
                            SET_CONFIG <= #100 1'b0;
                        end                                     
                    end
                    @(posedge ACLK);
                    S_AXIS_TVALID <= #100 1'b0;                     
                end                
            end
            begin
                // header_footer_gen_output_monitor(dframe, s_axis_tdata_set, dframe_num);
            end
        join
        $display("TEST PASSED: write in data with no-backpressure test passed!");
    endtask

    task write_in_with_adc_backpressure(input DataFrame dframe[], input datastream_line_t s_axis_tdata_set[], input int dframe_num, input int rst_cfg_timing);
        localparam integer FULL_WAIT_CLK_NUM= 256;
        int SUDDEN_RESET_START[2];
        int SUDDEN_RESET_END[2];        
        int SUDDEN_CONFIG_START[2];
        int SUDDEN_CONFIG_END[2];
        if (rst_cfg_timing==RANDOM_RESET_CONFIG_TIMING) begin
            SUDDEN_RESET_START[0] = $urandom_range(0, dframe_num-1);
            SUDDEN_RESET_START[1] = $urandom_range(0, dframe[SUDDEN_RESET_START[0]].raw_stream_len);
            SUDDEN_RESET_END[0] = $urandom_range(SUDDEN_RESET_START[0], dframe_num-1);
            if (SUDDEN_RESET_END[0]==SUDDEN_RESET_START[0]) begin
                SUDDEN_RESET_END[1] = $urandom_range(SUDDEN_RESET_START[1]+1, dframe[SUDDEN_RESET_START[0]].raw_stream_len);    
            end else begin
                SUDDEN_RESET_END[1] = $urandom_range(0, dframe[SUDDEN_RESET_END[0]].raw_stream_len);
            end

            SUDDEN_CONFIG_START[0] = $urandom_range(0, dframe_num-1);
            SUDDEN_CONFIG_START[1] = $urandom_range(0, dframe[SUDDEN_CONFIG_START[0]].raw_stream_len);
            SUDDEN_CONFIG_END[0] = $urandom_range(SUDDEN_CONFIG_START[0], dframe_num-1);
            if (SUDDEN_CONFIG_END[0]==SUDDEN_CONFIG_START[0]) begin
                SUDDEN_CONFIG_END[1] = $urandom_range(SUDDEN_CONFIG_START[1]+1, dframe[SUDDEN_CONFIG_START[0]].raw_stream_len);    
            end else begin
                SUDDEN_CONFIG_END[1] = $urandom_range(0, dframe[SUDDEN_CONFIG_END[0]].raw_stream_len);
            end            
        end else begin
            SUDDEN_RESET_START[0] = dframe_num/2;
            SUDDEN_RESET_START[1] = dframe[SUDDEN_RESET_START[0]].raw_stream_len/2;
            SUDDEN_RESET_END[0] = dframe_num/2;
            SUDDEN_RESET_START[1] = dframe[SUDDEN_RESET_START[0]].raw_stream_len;

            SUDDEN_CONFIG_START[0] = dframe_num/2;
            SUDDEN_CONFIG_START[1] = dframe[SUDDEN_CONFIG_START[0]].raw_stream_len/2;
            SUDDEN_CONFIG_END[0] = dframe_num/2+1;
            SUDDEN_CONFIG_END[1] = 0;          
        end

        test_status = WRITE_IN_WITH_ADC_FIFO_BACKPRESSURE;
        $display("TEST START: write in data with backpressure");
        @(posedge ACLK);
        S_AXIS_TVALID <= #100 1'b0;
        M_AXIS_TREADY <= #100 1'b0;
        fork
            begin
                wait(DUT.ADC_FIFO_FULL==1'b1) begin
                    repeat(FULL_WAIT_CLK_NUM) @(posedge ACLK);
                    $display("TEST INFO: release adc_fifo backpressure");
                    M_AXIS_TREADY <= #100 1'b1;              
                end
            end                  
            begin          
                for (int i=0; i<dframe_num; i++) begin
                    for (int j=0; j<dframe[i].raw_stream_len; j++) begin
                        @(posedge ACLK);
                        S_AXIS_TDATA <= #100 s_axis_tdata_set[i][j];
                        S_AXIS_TVALID <= #100 1'b1;
                        if ((i==SUDDEN_RESET_START[0])&&(j==SUDDEN_RESET_START[1])) begin
                            $display("TEST INFO: SUDDENLY RESET");
                            ARESET <= #100 1'b1;
                        end else if ((i==SUDDEN_RESET_END[0])&&(j==SUDDEN_RESET_END[1])) begin
                            $display("TEST INFO: Release RESET");
                            ARESET <= #100 1'b0;
                        end
                        if ((i==SUDDEN_CONFIG_START[0])&&(j==SUDDEN_CONFIG_START[1])) begin
                            $display("TEST INFO: SUDDENLY CONFIG");
                            SET_CONFIG <= #100 1'b1;
                        end else if ((i==SUDDEN_CONFIG_END[0])&&(j==SUDDEN_CONFIG_END[1])) begin
                            $display("TEST INFO: Release CONFIG");
                            SET_CONFIG <= #100 1'b0;
                        end                                                             
                    end
                    @(posedge ACLK);
                    S_AXIS_TVALID <= #100 1'b0;                     
                end                
            end
            begin
                // header_footer_gen_output_monitor(dframe, s_axis_tdata_set, dframe_num);
            end
        join
        $display("TEST PADSSED: write in data with adc_fifo backpressure test passed!");
    endtask

    task write_in_with_hf_backpressure(input DataFrame dframe[], input datastream_line_t s_axis_tdata_set[], input int dframe_num, input int rst_cfg_timing);
        localparam integer FULL_WAIT_CLK_NUM= 256;
        int SUDDEN_RESET_START[2];
        int SUDDEN_RESET_END[2];        
        int SUDDEN_CONFIG_START[2];
        int SUDDEN_CONFIG_END[2];
        if (rst_cfg_timing==RANDOM_RESET_CONFIG_TIMING) begin
            SUDDEN_RESET_START[0] = $urandom_range(0, dframe_num-1);
            SUDDEN_RESET_START[1] = $urandom_range(0, dframe[SUDDEN_RESET_START[0]].raw_stream_len);
            SUDDEN_RESET_END[0] = $urandom_range(SUDDEN_RESET_START[0], dframe_num-1);
            if (SUDDEN_RESET_END[0]==SUDDEN_RESET_START[0]) begin
                SUDDEN_RESET_END[1] = $urandom_range(SUDDEN_RESET_START[1]+1, dframe[SUDDEN_RESET_START[0]].raw_stream_len);    
            end else begin
                SUDDEN_RESET_END[1] = $urandom_range(0, dframe[SUDDEN_RESET_END[0]].raw_stream_len);
            end

            SUDDEN_CONFIG_START[0] = $urandom_range(0, dframe_num-1);
            SUDDEN_CONFIG_START[1] = $urandom_range(0, dframe[SUDDEN_CONFIG_START[0]].raw_stream_len);
            SUDDEN_CONFIG_END[0] = $urandom_range(SUDDEN_CONFIG_START[0], dframe_num-1);
            if (SUDDEN_CONFIG_END[0]==SUDDEN_CONFIG_START[0]) begin
                SUDDEN_CONFIG_END[1] = $urandom_range(SUDDEN_CONFIG_START[1]+1, dframe[SUDDEN_CONFIG_START[0]].raw_stream_len);    
            end else begin
                SUDDEN_CONFIG_END[1] = $urandom_range(0, dframe[SUDDEN_CONFIG_END[0]].raw_stream_len);
            end            
        end else begin
            SUDDEN_RESET_START[0] = dframe_num/2;
            SUDDEN_RESET_START[1] = dframe[SUDDEN_RESET_START[0]].raw_stream_len/2;
            SUDDEN_RESET_END[0] = dframe_num/2;
            SUDDEN_RESET_START[1] = dframe[SUDDEN_RESET_START[0]].raw_stream_len;

            SUDDEN_CONFIG_START[0] = dframe_num/2;
            SUDDEN_CONFIG_START[1] = dframe[SUDDEN_CONFIG_START[0]].raw_stream_len/2;
            SUDDEN_CONFIG_END[0] = dframe_num/2+1;
            SUDDEN_CONFIG_END[1] = 0;          
        end
        test_status = WRITE_IN_WITH_HF_FIFO_BACKPRESSURE;
        $display("TEST START: write in data with backpressure");
        @(posedge ACLK);
        S_AXIS_TVALID <= #100 1'b0;
        M_AXIS_TREADY <= #100 1'b1;
        fork
            begin
                wait(DUT.HF_FIFO_FULL==1'b1) begin
                    repeat(FULL_WAIT_CLK_NUM) @(posedge ACLK);
                    $display("TEST INFO: release hf_fifo backpressure");
                    M_AXIS_TREADY <= #100 1'b1;                  
                end
            end
            begin          
                for (int i=0; i<dframe_num; i++) begin
                    for (int j=0; j<dframe[i].raw_stream_len; j++) begin
                        @(posedge ACLK);
                        S_AXIS_TDATA <= #100 s_axis_tdata_set[i][j];
                        S_AXIS_TVALID <= #100 1'b1;
                        if ((i==SUDDEN_RESET_START[0])&&(j==SUDDEN_RESET_START[1])) begin
                            $display("TEST INFO: SUDDENLY RESET");
                            ARESET <= #100 1'b1;
                        end else if ((i==SUDDEN_RESET_END[0])&&(j==SUDDEN_RESET_END[1])) begin
                            $display("TEST INFO: Release RESET");
                            ARESET <= #100 1'b0;
                        end
                        if ((i==SUDDEN_CONFIG_START[0])&&(j==SUDDEN_CONFIG_START[1])) begin
                            $display("TEST INFO: SUDDENLY CONFIG");
                            SET_CONFIG <= #100 1'b1;
                        end else if ((i==SUDDEN_CONFIG_END[0])&&(j==SUDDEN_CONFIG_END[1])) begin
                            $display("TEST INFO: Release CONFIG");
                            SET_CONFIG <= #100 1'b0;
                        end                                                                 
                    end
                    @(posedge ACLK);
                    S_AXIS_TVALID <= #100 1'b0;                     
                end                
            end
            begin
                // header_footer_gen_output_monitor(dframe, s_axis_tdata_set, dframe_num);
            end
        join
        $display("TEST PADSSED: write in data with hf_fifo backpressure test passed!");
    endtask   

    initial begin
        $dumpfile("dataframe_generator_tb.vcd");
        $dumpvars(0, dataframe_generator_tb);
        test_status = INTITIALIZE;
        for (int i=0; i<SAMPLE_FRAME_NUM; i++) begin
            sample_config[i].ch_id = CHANNEL_ID_NUM;
            sample_config[i].frame_len = 2**(i+1);
            sample_config[i].gain_type = 1'b1;
            sample_config[i].trigger_type = 4'h0;
            sample_config[i].baseline = 0;
            sample_config[i].threshold = 10;
            sample_config[i].timestamp = 0+2**i;            

            sample_frame[i] = new(sample_config[i]);
            sample_frame[i].sampleFilling();            
        end
        for (int i=0; i<SAMPLE_FRAME_NUM; i++) begin
            sample_tdata_set[i] = sample_frame[i].getDataStream();
        end             


        for (int i=0; i<RAND_SAMPLE_FRAME_NUM; i++) begin
            rand_sample_config[i].ch_id = CHANNEL_ID_NUM;
            rand_sample_config[i].frame_len = 2*$urandom_range(1, 2**11-1);
            rand_sample_config[i].gain_type = $urandom_range(0, 1);
            rand_sample_config[i].trigger_type =  $urandom_range(0, 15);
            rand_sample_config[i].baseline = $urandom_range(0, 2**16-1);
            rand_sample_config[i].threshold = $urandom_range(0, 2**16-1);
            if (i==0) begin
                rand_sample_config[i].timestamp=0;
            end else begin
                rand_sample_config[i].timestamp = rand_sample_config[i-1].timestamp+rand_sample_config[i-1].frame_len+1;  
            end                    
            rand_sample_frame[i] = new(rand_sample_config[i]);
            rand_sample_frame[i].sampleFilling();            
        end
        for (int i=0; i<RAND_SAMPLE_FRAME_NUM; i++) begin
            rand_sample_tdata_set[i] = rand_sample_frame[i].getDataStream();
        end        

        reset_all;
        config_module;
        
        $display("TEST INFO: FIXED FRAME LENGTH TEST");
        write_in_wo_nobackpressure(sample_frame, sample_tdata_set, SAMPLE_FRAME_NUM, FIXED_RESET_CONFIG_TIMING);
        write_in_with_adc_backpressure(sample_frame, sample_tdata_set, SAMPLE_FRAME_NUM, FIXED_RESET_CONFIG_TIMING);
        write_in_with_hf_backpressure(sample_frame, sample_tdata_set, SAMPLE_FRAME_NUM, FIXED_RESET_CONFIG_TIMING);

        $display("TEST INFO: RANDOM FRAME LENGTH TEST");
        write_in_wo_nobackpressure(rand_sample_frame, rand_sample_tdata_set, RAND_SAMPLE_FRAME_NUM, RANDOM_RESET_CONFIG_TIMING);
        write_in_with_adc_backpressure(rand_sample_frame, rand_sample_tdata_set, RAND_SAMPLE_FRAME_NUM, RANDOM_RESET_CONFIG_TIMING);
        write_in_with_hf_backpressure(rand_sample_frame, rand_sample_tdata_set, RAND_SAMPLE_FRAME_NUM, RANDOM_RESET_CONFIG_TIMING);        

        $display("ALL TEST PASSED!");
        $finish;
    end                  
    
endmodule