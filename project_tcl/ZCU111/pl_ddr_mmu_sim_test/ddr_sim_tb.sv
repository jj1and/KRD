`timescale 1 ps / 1 ps
import axi_vip_pkg::*;
import ddr_sim_axi_vip_0_0_pkg::*;

module ddr_sim_tb;
    typedef struct packed {
        reg [127:0] tdata;
        reg tvalid;
        reg [15:0] tkeep;
        reg tlast;
    } axis_data;
    typedef axis_data dataframe_line_t[];

    parameter integer CLK_PERIOD = 8000; // ps, 125MHz
    parameter integer RESET_CLK_NUM = 10;

    wire [7:0] HEADER_ID = 8'hAA;
    wire [7:0] FOOTER_ID = 8'h55;

    reg CLK = 1'b1;
    reg EXT_RESET = 1'b1;
    reg SET_CONFIG_0 = 1'b1;    
    
    reg [15:0] MAX_TRIGGER_LENGTH_0 = 16'd16;
    
    reg [127:0] S_AXIS_0_tdata;
    reg S_AXIS_0_tlast = 1'b0;
    wire S_AXIS_0_tready;
    reg S_AXIS_0_tvalid = 1'b0;
    reg [15:0] S_AXIS_0_tkeep = 16'hFFFF;

    wire [127:0] M_AXIS_0_tdata;
    wire M_AXIS_0_tlast;
    reg M_AXIS_0_tready = 1'b0;
    wire M_AXIS_0_tvalid;
    wire [15:0] M_AXIS_0_tkeep;

    ddr_sim_wrapper DUT (
        .*
    );

    enum integer {
        INTITIALIZE,
        RESET_ALL,
        CONFIGURING,
        SEQUENCIAL_SENDING_TEST   
    } test_status;    


    task reset_all;
        test_status = RESET_ALL;
        
        EXT_RESET <= #100 1'b1;
        repeat(RESET_CLK_NUM) @(posedge CLK);
        EXT_RESET <= #100 1'b0;
    endtask

    task config_module(input reg [15:0] max_trigger_len);
        
        test_status = CONFIGURING;
        // configuring DUT
        SET_CONFIG_0 <= #100 1'b1;
        MAX_TRIGGER_LENGTH_0 <= #100 max_trigger_len;

        repeat(RESET_CLK_NUM) @(posedge CLK);
        SET_CONFIG_0 <= #100 1'b0;                   

    endtask

    function dataframe_line_t generateFrame(input int frame_length);
        reg [15:0] tmp_sample[8];
        dataframe_line_t result;
        if (frame_length/2 > MAX_TRIGGER_LENGTH_0) begin
            $display("TEST ERROR: frame_length*2 must be smaller than max trigger length");
            $finish;
        end

        result = new[frame_length/2+2];
        
        result[0].tdata = {HEADER_ID, {128-8{1'b0}}};
        result[0].tvalid = 1'b1;
        result[0].tkeep = 16'hFFFF;
        result[0].tlast = 1'b0;

        for (int i=1; i<frame_length/2+1; i++) begin
            for (int j=0; j<8; j++) begin
                tmp_sample[j] = i+j;
                result[i].tdata[j*16 +:16] = tmp_sample[j];
            end
            result[i].tvalid = 1'b1;
            result[i].tkeep = 16'hFFFF;
            result[i].tlast = 1'b0;
        end

        result[frame_length/2+1].tdata = {FOOTER_ID, {128-8{1'b1}}};
        result[frame_length/2+1].tvalid = 1'b1;
        result[frame_length/2+1].tkeep = 16'hFF00;
        result[frame_length/2+1].tlast = 1'b1;        
        return result;
    endfunction

    parameter integer SAMPLE_NUM = 10;
    int sample_frame_length[SAMPLE_NUM];
    dataframe_line_t sample_frame[SAMPLE_NUM];

    task mmu_output_monitor(input dataframe_line_t sample_frame[], input int sample_num);
        int test_failed;
        int sample_index;
        int line_index;
        
        sample_index = 0;
        test_failed = 0;
        while (sample_index < sample_num) begin
            @(posedge CLK);
            if (M_AXIS_0_tvalid&M_AXIS_0_tready) begin
                if (sample_frame[sample_index][line_index].tdata != M_AXIS_0_tdata) begin
                    $display("TEST FAILED: TDATA doesn't match Input:%0x  Output:%0x", sample_frame[sample_index][line_index].tdata, M_AXIS_0_tdata);
                    test_failed = 1;
                end else if (sample_frame[sample_index][line_index].tvalid != M_AXIS_0_tvalid) begin
                    $display("TEST FAILED: TVALID doesn't match Input:%0d  Output:%0d", sample_frame[sample_index][line_index].tvalid, M_AXIS_0_tvalid);
                    test_failed = 1;                    
                end else if (sample_frame[sample_index][line_index].tlast != M_AXIS_0_tlast) begin
                     $display("TEST FAILED: TLAST doesn't match Input:%0x  Output:%0x", sample_frame[sample_index][line_index].tlast, M_AXIS_0_tlast);
                    test_failed = 1;                   
                end else if (sample_frame[sample_index][line_index].tkeep != M_AXIS_0_tkeep) begin
                    $display("TEST FAILED: TKEEP doesn't match Input:%0x  Output:%0x", sample_frame[sample_index][line_index].tkeep, M_AXIS_0_tkeep);
                    test_failed = 1;                    
                end

                if (test_failed!=0) begin
                    $finish;
                end

                if (M_AXIS_0_tdata[127 -:8]==FOOTER_ID) begin
                    $display("TEST INFO: sample[%0d] is acquired", sample_index);
                    sample_index++;
                end
            end
        end
    endtask 

    task sequencial_sending_test(input dataframe_line_t sample_frame[], input int sample_num, input int sample_frame_length[]);
        int line_index;
        test_status = SEQUENCIAL_SENDING_TEST;
        $display("TEST START: sequencial sending test start");

        @(posedge CLK);
        S_AXIS_0_tvalid <= #100 1'b0;
        S_AXIS_0_tlast <= #100 1'b0;
        S_AXIS_0_tkeep <= #100 16'hFFFF;
        S_AXIS_0_tdata <= #100 {128{1'b1}};
        
        M_AXIS_0_tready <= #100 1'b1;
        fork
            begin
                for (int i=0; i<sample_num; i++) begin
                    line_index = 0;

                    while(line_index < sample_frame_length[i]/2+1) begin
                        @(posedge CLK);
                        if (S_AXIS_0_tready&S_AXIS_0_tvalid) begin
                            line_index++;
                        end                        
                        
                        S_AXIS_0_tdata <= #100 sample_frame[i][line_index].tdata;
                        S_AXIS_0_tvalid <= #100 sample_frame[i][line_index].tvalid;
                        S_AXIS_0_tkeep <= #100 sample_frame[i][line_index].tkeep;
                        S_AXIS_0_tlast <= #100 sample_frame[i][line_index].tlast;
                    end

                    @(posedge CLK);
                    S_AXIS_0_tvalid <= #100 1'b0;
                    S_AXIS_0_tlast <= #100 1'b0;
                    S_AXIS_0_tkeep <= #100 16'hFFFF;
                    S_AXIS_0_tdata <= #100 {128{1'b1}};
                end
            end
            begin
                mmu_output_monitor(sample_frame, sample_num);
            end
        join

        $display("TEST PASSED: sequencial sending test passed!");
    endtask

    initial begin
        CLK =1;
        forever #(CLK_PERIOD/2)   CLK = ~ CLK;   
    end

    /*************************************************************************************************
    * Declare <component_name>_slv_mem_t for slave mem agent
    * <component_name> can be easily found in vivado bd design: click on the instance, 
    * then click CONFIG under Properties window and Component_Name will be shown
    * more details please refer PG267 for more details
    *************************************************************************************************/
    ddr_sim_axi_vip_0_0_slv_mem_t                          axi_slv_agent;


    initial begin
        test_status = INTITIALIZE;
        /***********************************************************************************************
        * Before agent is newed, user has to run simulation with an empty testbench(disable below two
        * lines) to find the hierarchy path of the AXI VIP's instance.Message like
        * "Xilinx AXI VIP Found at Path: my_ip_exdes_tb.DUT.ex_design.axi_vip_mst.inst" will be printed 
        * out. Pass this path to the new function. 
        ***********************************************************************************************/
        axi_slv_agent = new("slave vip mem agent",DUT.ddr_sim_i.axi_vip_0.inst.IF); // agent is newed

        axi_slv_agent.start_slave(); 


        for (int i=0; i<SAMPLE_NUM; i++) begin
            sample_frame[i] = generateFrame(8);
            sample_frame_length[i] = 8;
        end

        reset_all;
        config_module(16);

        sequencial_sending_test(sample_frame, SAMPLE_NUM, sample_frame_length);

        $display("TEST PASSED: All test passed!");
        $finish;
    end

endmodule