`timescale 1ps/1ps


`include "test_dataframe_gen_pkg.sv"
import test_dataframe_gen_pkg::*;
import axi_vip_pkg::*;
import sim_design_axi_vip_0_0_pkg::*;

module async_pl_ddr_mmu_test_tb;

    parameter integer CLK_125MHZ_PERIOD = 8000;
    parameter integer CLK_333MHZ_PERIOD = 3000;
    parameter integer RESET_CLK_NUM = 10;
    parameter integer CHANNEL_ID_NUM = 0;

    reg CLK_125MHZ = 1'b1;
    reg EXT_RESET = 1'b1;

    reg CLK_333MHZ = 1'b1;

    // Data frame length configuration
    reg SET_CONFIG = 1'b0;
    reg [15:0] MAX_TRIGGER_LENGTH;

    // Input signals from trigger
    reg [`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH-1:0] S_AXIS_TDATA = {`RFDC_TDATA_WIDTH+`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH{1'b0}}; // TDATA from RF Data Converter logic IP
    reg S_AXIS_TVALID = 1'b0;
    wire [`RFDC_TDATA_WIDTH-1:0] s_axis_rfdc_tdata = S_AXIS_TDATA[`TRIGGER_INFO_WIDTH+`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH +:`RFDC_TDATA_WIDTH];
    wire [`TRIGGER_INFO_WIDTH-1:0] s_axis_trigger_info = S_AXIS_TDATA[`TIMESTAMP_WIDTH+`TRIGGER_CONFIG_WIDTH +:`TRIGGER_INFO_WIDTH];
    wire [`TIMESTAMP_WIDTH-1:0] s_axis_timestamp =  S_AXIS_TDATA[`TRIGGER_CONFIG_WIDTH +:`TIMESTAMP_WIDTH];
    wire [`TRIGGER_CONFIG_WIDTH-1:0] s_axis_trigger_config = S_AXIS_TDATA[0 +:`TRIGGER_CONFIG_WIDTH];
    wire [`RFDC_TDATA_WIDTH-1:0] H_GAIN_TDATA = s_axis_rfdc_tdata;

    reg M_AXIS_TREADY = 1'b1;
    wire M_AXIS_TVALID;
    reg tvalid_delay;
    always @(posedge CLK_333MHZ) begin
        tvalid_delay <= #100 M_AXIS_TVALID;
    end
    
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
    
    wire [`HEADER_ID_WIDTH-1:0] HEADER_ID = `HEADER_ID;
    wire [`FOOTER_ID_WIDTH-1:0] FOOTER_ID = `FOOTER_ID;

    wire [`CH_ID_WIDTH-1:0] ch_id = m_axis_tdata_dframe[0][`HEADER_TIMESTAMP_WIDTH+`TRIGGER_TYPE_WIDTH+`FRAME_INFO_WIDTH+`FRAME_LENGTH_WIDTH +:`CH_ID_WIDTH];
    wire [`FRAME_LENGTH_WIDTH-1:0] frame_len = m_axis_tdata_dframe[0][`HEADER_TIMESTAMP_WIDTH+`TRIGGER_TYPE_WIDTH+`FRAME_INFO_WIDTH +:`FRAME_LENGTH_WIDTH]; 
    wire [`FRAME_INFO_WIDTH-1:0] frame_info = m_axis_tdata_dframe[0][`HEADER_TIMESTAMP_WIDTH+`TRIGGER_TYPE_WIDTH +:`FRAME_INFO_WIDTH];
    wire [`TRIGGER_TYPE_WIDTH-1:0] trigger_type = m_axis_tdata_dframe[0][`HEADER_TIMESTAMP_WIDTH +:`TRIGGER_TYPE_WIDTH];
    wire [`HEADER_TIMESTAMP_WIDTH-1:0] header_timestamp = m_axis_tdata_dframe[0][0 +:`HEADER_TIMESTAMP_WIDTH];
    wire [`CHARGE_SUM-1:0] charge_sum = m_axis_tdata_dframe[1][`TRIGGER_CONFIG_WIDTH +:`CHARGE_SUM];
    wire [`TRIGGER_CONFIG_WIDTH-1:0] trigger_config = m_axis_tdata_dframe[1][0 +:`TRIGGER_CONFIG_WIDTH];
    wire [`FOOTER_TIMESTAMP_WIDTH-1:0] footer_timestamp = m_axis_tdata_dframe[0][`OBJECT_ID_WIDTH +:`FOOTER_TIMESTAMP_WIDTH];
    wire [`OBJECT_ID_WIDTH-1:0] object_id = m_axis_tdata_dframe[0][0 +:`OBJECT_ID_WIDTH];
    wire [`TIMESTAMP_WIDTH-1:0] timestamp = {footer_timestamp, header_timestamp};    
    wire DATAFRAME_GEN_ERROR;

    sim_design_wrapper DUT (
        .*
    );
    
    /*************************************************************************************************
    * Declare <component_name>_slv_mem_t for slave mem agent
    * <component_name> can be easily found in vivado bd design: click on the instance, 
    * then click CONFIG under Properties window and Component_Name will be shown
    * more details please refer PG267 for more details
    *************************************************************************************************/
    sim_design_axi_vip_0_0_slv_mem_t                          axi_slv_agent;

    /**********************************************************************************************************
    slv_random_backpressure_wready :
    1. create a ready class object rgen
    2. set ready policy of this rgen to be XIL_AXI_READY_GEN_RANDOM
    3. set low time range, high time range and event count range(low time, high time and events(ready/valid 
        handshake event) will be randomly picked inside these range) of rgen.
    4. put rgen into wready queue of write driver of Slave VIP, wready generation is randomized
        till the wready policy is being changed.
    **********************************************************************************************************/
    task automatic slv_random_backpressure_wready();
        axi_ready_gen rgen;
        $display("TEST INFO: %t,- Applying slv_random_backpressure_wready", $time);

        rgen = new("slv_random_backpressure_wready");
        rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
        rgen.set_low_time_range(0,12);
        rgen.set_high_time_range(1,12);
        rgen.set_event_count_range(3,3);
        axi_slv_agent.wr_driver.set_wready_gen(rgen);
    endtask : slv_random_backpressure_wready

    /**********************************************************************************************************
    slv_random_backpressure_awready :
    1. create a ready class object rgen
    2. set ready policy of this rgen to be XIL_AXI_READY_GEN_RANDOM
    3. set low time range, high time range and event count range(low time, high time and events(ready/valid 
        handshake event) will be randomly picked inside these range) of rgen.
    4. put rgen into awready queue of write driver of Slave VIP, awready generation is randomized
        till the awready policy is being changed.
    **********************************************************************************************************/
    task automatic slv_random_backpressure_awready();
        axi_ready_gen rgen;
        $display("TEST INFO: %t,- Applying slv_random_backpressure_awready", $time);

        rgen = new("slv_random_backpressure_awready");
        rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
        rgen.set_low_time_range(0,12);
        rgen.set_high_time_range(1,12);
        rgen.set_event_count_range(3,3);
        axi_slv_agent.wr_driver.set_awready_gen(rgen);
    endtask : slv_random_backpressure_awready

    /**********************************************************************************************************
    slv_random_backpressure_arready :
    1. create a ready class object rgen
    2. set ready policy of this rgen to be XIL_AXI_READY_GEN_RANDOM
    3. set low time range, high time range and event count range(low time, high time and events(ready/valid 
        handshake event) will be randomly picked inside these range) of rgen.
    4. put rgen into arready queue of read driver of Slave VIP, arready generation is randomized
        till the arready policy is being changed.
    **********************************************************************************************************/
    task automatic slv_random_backpressure_arready();
        axi_ready_gen rgen;
        $display("TEST INFO: %t,- Applying slv_random_backpressure_arready", $time);

        rgen = new("slv_random_backpressure_arready");
        rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
        rgen.set_low_time_range(0,12);
        rgen.set_high_time_range(1,12);
        rgen.set_event_count_range(3,3);
        axi_slv_agent.rd_driver.set_arready_gen(rgen);
    endtask : slv_random_backpressure_arready 

    /**********************************************************************************************************
    slv_random_backpressure_readies :
    set ready policy of awready, wready and arready all to be XIL_AXI_READY_GEN_RANDOM,set low time range
    high time range and event count range, then put ready class into ready queueof Slave VIP.
    **********************************************************************************************************/
    task automatic slv_random_backpressure_readies();
        slv_random_backpressure_wready();
        slv_random_backpressure_awready();
        slv_random_backpressure_arready();
    endtask  : slv_random_backpressure_readies


    task automatic slv_gen_after_valid_osc_wready();
        axi_ready_gen rgen;
        $display("TEST INFO: %t,- Applying slv_gen_after_valid_osc_wready", $time);

        rgen = new("slv_gen_after_valid_osc_wready");
        rgen.set_ready_policy(XIL_AXI_READY_GEN_AFTER_VALID_OSC);
        rgen.set_low_time(4);
        rgen.set_high_time(32);
        axi_slv_agent.wr_driver.set_wready_gen(rgen);
    endtask : slv_gen_after_valid_osc_wready

    task automatic slv_gen_after_valid_osc_awready();
        axi_ready_gen rgen;
        $display("TEST INFO: %t,- Applying slv_gen_after_valid_osc_awready", $time);

        rgen = new("slv_gen_after_valid_osc_awready");
        rgen.set_ready_policy(XIL_AXI_READY_GEN_AFTER_VALID_OSC);
        rgen.set_low_time(4);
        rgen.set_high_time(32);
        axi_slv_agent.wr_driver.set_awready_gen(rgen);
    endtask : slv_gen_after_valid_osc_awready    

    task automatic slv_gen_after_valid_osc_arready();
        axi_ready_gen rgen;
        $display("TEST INFO: %t,- Applying slv_gen_after_valid_osc_arready", $time);

        rgen = new("slv_gen_after_valid_osc_arready");
        rgen.set_ready_policy(XIL_AXI_READY_GEN_AFTER_VALID_OSC);
        rgen.set_low_time(512);
        rgen.set_high_time(4);
        axi_slv_agent.rd_driver.set_arready_gen(rgen);
    endtask : slv_gen_after_valid_osc_arready 

    task automatic slv_gen_after_valid_osc_readies();
        slv_gen_after_valid_osc_wready();
        slv_gen_after_valid_osc_awready();
        slv_gen_after_valid_osc_arready();
    endtask  : slv_gen_after_valid_osc_readies
    
    

    initial begin
        CLK_125MHZ =1;
        forever #(CLK_125MHZ_PERIOD/2)   CLK_125MHZ = ~ CLK_125MHZ;   
    end

    initial begin
        CLK_333MHZ =1;
        forever #(CLK_333MHZ_PERIOD/2)   CLK_333MHZ = ~ CLK_333MHZ;   
    end

    task reset_all;
        repeat(RESET_CLK_NUM) @(posedge CLK_125MHZ);
        EXT_RESET <= #100 1'b1;
        @(posedge CLK_125MHZ);
        EXT_RESET <= #100 1'b0;
    endtask

    task config_module(input int set_trigger_length);
        @(posedge CLK_125MHZ);
        SET_CONFIG <= #100 1'b1;
        MAX_TRIGGER_LENGTH <= #100 set_trigger_length;
        @(posedge CLK_125MHZ);
        SET_CONFIG <= #100 1'b0;       
    endtask

    frame_config_pack sample_config[];
    datastream_line_t s_axis_tdata_set;

    task write_in_wo_backpressure(input frame_config_pack frame_configs[]);
        automatic int given_sample_num = frame_configs.size();
        automatic DataFrame sample_frame[];
        sample_frame = new[given_sample_num];
        $display("TEST INFO: write in with out backpressure");
        fork         
            begin
                for (int i=0 ; i<given_sample_num; i++) begin
                    @(posedge CLK_125MHZ);                  
                    sample_frame[i] = new(frame_configs[i]);
                    sample_frame[i].sampleFilling();                                
                    s_axis_tdata_set = sample_frame[i].getDataStream(5);               
                    for (int j = 0; j<sample_frame[i].frame_len/2; j++) begin
                        @(posedge CLK_125MHZ);
                        S_AXIS_TVALID <= #100 1'b1;  
                        S_AXIS_TDATA <= #100 s_axis_tdata_set[j];
                    end
                    @(posedge CLK_125MHZ);
                    S_AXIS_TVALID <= #100 1'b0;                    
                end
            end
            begin
                @(posedge CLK_333MHZ);
                M_AXIS_TREADY <= #100 1'b1;
            end
        join
        wait(DUT.sim_design_i.df_gens.async_dataframe_gene_0.inst.dataframe_gen_inst.ADC_FIFO_EMPTY==1'b1)
        sample_frame.delete();
        $display("TEST INFO: write in with no-backpressure end");
    endtask  
    
    task write_in_full_backpressure(input frame_config_pack frame_configs[]);
        automatic int given_sample_num = frame_configs.size();
        automatic DataFrame sample_frame[];
        sample_frame = new[given_sample_num];
        $display("TEST INFO: write in with full backpressure");   
        for (int i=0 ; i<given_sample_num; i++) begin
            fork
                begin
                    @(posedge CLK_125MHZ);                  
                    sample_frame[i] = new(frame_configs[i]);
                    sample_frame[i].sampleFilling();                                
                    s_axis_tdata_set = sample_frame[i].getDataStream(5);               
                    for (int j = 0; j<sample_frame[i].frame_len/2; j++) begin
                        @(posedge CLK_125MHZ);
                        S_AXIS_TVALID <= #100 1'b1;  
                        S_AXIS_TDATA <= #100 s_axis_tdata_set[j];
                    end
                    @(posedge CLK_125MHZ);
                    S_AXIS_TVALID <= #100 1'b0;
                end
                begin
                    while (i<given_sample_num) begin
                        @(posedge CLK_333MHZ);
                        M_AXIS_TREADY <= #100 1'b0;
                    end
                end
            join_any              
        end
        while (DUT.sim_design_i.df_gens.async_dataframe_gene_0.inst.dataframe_gen_inst.ADC_FIFO_EMPTY==1'b0) begin
            @(posedge CLK_333MHZ);
            M_AXIS_TREADY <= #100 $urandom_range(0, 1);
        end
        sample_frame.delete();
        $display("TEST INFO: write in with full backpressure end");
    endtask          
    
    task write_in_random_backpressure(input frame_config_pack frame_configs[]);
        automatic int given_sample_num = frame_configs.size();
        automatic DataFrame sample_frame[];
        sample_frame = new[given_sample_num];
        $display("TEST INFO: write in with random backpressure");   
        for (int i=0 ; i<given_sample_num; i++) begin
            fork
                begin
                    @(posedge CLK_125MHZ);                  
                    sample_frame[i] = new(frame_configs[i]);
                    sample_frame[i].sampleFilling();                                
                    s_axis_tdata_set = sample_frame[i].getDataStream(5);               
                    for (int j = 0; j<sample_frame[i].frame_len/2; j++) begin
                        @(posedge CLK_125MHZ);
                        S_AXIS_TVALID <= #100 1'b1;  
                        S_AXIS_TDATA <= #100 s_axis_tdata_set[j];
                    end
                    @(posedge CLK_125MHZ);
                    S_AXIS_TVALID <= #100 1'b0;
                end
                begin
                    while (|{i<given_sample_num, DUT.sim_design_i.df_gens.async_dataframe_gene_0.inst.dataframe_gen_inst.ADC_FIFO_EMPTY==1'b0}) begin
                        @(posedge CLK_333MHZ);
                        M_AXIS_TREADY <= #100 $urandom_range(0, 1);
                    end
                end
            join_any                   
        end
        while (DUT.sim_design_i.df_gens.async_dataframe_gene_0.inst.dataframe_gen_inst.ADC_FIFO_EMPTY==1'b0) begin
            @(posedge CLK_333MHZ);
            M_AXIS_TREADY <= #100 $urandom_range(0, 1);
        end
        sample_frame.delete();
        $display("TEST INFO: write in with random backpressure end");
    endtask      

    int rcvd_frame_len;
    bit [`RFDC_TDATA_WIDTH-1:0] rcvd_data[$]; 
    task DUT_output_monitor();
        @(posedge CLK_333MHZ);
        if (M_AXIS_TVALID&M_AXIS_TREADY) begin
            if (m_axis_tdata_dframe[0][`DATAFRAME_WIDTH-1 -:`HEADER_ID_WIDTH]==HEADER_ID) begin
                $display("TEST INFO: new dataframe is recieved %16h", m_axis_tdata_dframe[0]);
                rcvd_data.delete();
                rcvd_frame_len = frame_len/2;
            end
            if (&{M_AXIS_TLAST, m_axis_tdata_dframe[0][`DATAFRAME_WIDTH-1 -:`FOOTER_ID_WIDTH]!=FOOTER_ID}) begin
                $display("ERROR: FOOTER ID mismatch (%16h)", m_axis_tdata_dframe[0]);
                $finish;                    
            end
            rcvd_data.push_back(M_AXIS_TDATA);
            
            if (rcvd_data.size()>(rcvd_frame_len+2)) begin
                $display("ERROR: recieved data size (%d) is larger than frame length on header (%d)", rcvd_data.size(), rcvd_frame_len);
                $finish;
            end
        end
    endtask





    initial begin
//        $dumpfile("async_df_gen_test_tb.vcd");
//        $dumpvars(0, async_df_gen_test_tb);

        /***********************************************************************************************
        * Before agent is newed, user has to run simulation with an empty testbench(disable below two
        * lines) to find the hierarchy path of the AXI VIP's instance.Message like
        * "Xilinx AXI VIP Found at Path: my_ip_exdes_tb.DUT.ex_design.axi_vip_mst.inst" will be printed 
        * out. Pass this path to the new function. 
        ***********************************************************************************************/
        axi_slv_agent = new("slave vip mem agent",DUT.sim_design_i.axi_vip_0.inst.IF); // agent is newed

        axi_slv_agent.start_slave(); 


        sample_config = new[1];
        for (int i=0; i<sample_config.size(); i++) begin
            sample_config[i].ch_id = CHANNEL_ID_NUM;
            sample_config[i].frame_len = 28;
            sample_config[i].gain_type = 0;
//            sample_config[i].frame_len = (16*(i+1)+1)*2;
//            sample_config[i].gain_type = i%2;
            sample_config[i].trigger_type = 4'h0;
            sample_config[i].baseline = 0;
            sample_config[i].threshold = 10;
            sample_config[i].timestamp = 0+2**i;                   
        end     
       
        $display("TEST INFO: start DUT monitor");
        fork
            forever begin
                DUT_output_monitor();
            end
        join_none

        reset_all;

        wait (DUT.sim_design_i.df_gens.async_dataframe_gene_0.inst.header_footer_gen_inst.ARESET==1'b0)        
        config_module(14);
        
        slv_gen_after_valid_osc_readies();
        $display("TEST INFO: --------------- Fixed length data test --------------- ");
        wait (~|{DUT.sim_design_i.df_gens.async_dataframe_gene_0.inst.header_footer_gen_inst.ARESET, DUT.sim_design_i.df_gens.async_dataframe_gene_0.inst.header_footer_gen_inst.HF_FIFO_RST_BUSY, DUT.sim_design_i.df_gens.async_dataframe_gene_0.inst.header_footer_gen_inst.ADC_FIFO_RST_BUSY})
        write_in_wo_backpressure(sample_config);
        write_in_full_backpressure(sample_config);    
        write_in_random_backpressure(sample_config);
        
        $display("TEST INFO: --------------- randomized length data test --------------- ");
        sample_config.delete();
        sample_config = new[100];
        for (int i=0; i<sample_config.size(); i++) begin
            sample_config[i].ch_id = CHANNEL_ID_NUM;
            sample_config[i].frame_len = 2*$urandom_range(1, 2**11-1);
            if (i==0) begin
                sample_config[i].gain_type = 0; 
            end else if (i==1) begin
                sample_config[i].gain_type = 1; 
            end else begin
                sample_config[i].gain_type = $urandom_range(0, 1);
            end
            sample_config[i].trigger_type =  $urandom_range(0, 15);
            sample_config[i].baseline = $urandom_range(0, 2**16-1);
            sample_config[i].threshold = $urandom_range(0, 2**16-1);
            if (i==0) begin
                sample_config[i].timestamp=0;
            end else begin
                sample_config[i].timestamp = sample_config[i-1].timestamp+sample_config[i-1].frame_len+1;  
            end                             
        end        
        write_in_random_backpressure(sample_config);
        $finish;
    end       

endmodule