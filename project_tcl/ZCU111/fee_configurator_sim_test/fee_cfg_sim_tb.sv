`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/26 17:50:00
// Design Name: 
// Module Name: fee_cfg_sim_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fee_cfg_sim_tb;
    parameter CLK_PERIOD = 8000;
    parameter RESET_CLK_NUM = 32;

    reg CLK;
    reg EXT_RESET;

    wire [1:0]CH0_CONTROL_0_acquire_mode;
    wire [15:0]CH0_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH0_CONTROL_0_h_gain_baseline;
    wire [15:0]CH0_CONTROL_0_l_gain_baseline;
    wire [15:0]CH0_CONTROL_0_max_trigger_length;
    wire [1:0]CH0_CONTROL_0_post_acquisition_length;
    wire [1:0]CH0_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH0_CONTROL_0_rising_edge_threshold;
    wire CH0_CONTROL_0_set_config;
    wire CH0_CONTROL_0_stop;
    wire [3:0]CH0_CONTROL_0_trigger_type;
    wire [1:0]CH10_CONTROL_0_acquire_mode;
    wire [15:0]CH10_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH10_CONTROL_0_h_gain_baseline;
    wire [15:0]CH10_CONTROL_0_l_gain_baseline;
    wire [15:0]CH10_CONTROL_0_max_trigger_length;
    wire [1:0]CH10_CONTROL_0_post_acquisition_length;
    wire [1:0]CH10_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH10_CONTROL_0_rising_edge_threshold;
    wire CH10_CONTROL_0_set_config;
    wire CH10_CONTROL_0_stop;
    wire [3:0]CH10_CONTROL_0_trigger_type;
    wire [1:0]CH11_CONTROL_0_acquire_mode;
    wire [15:0]CH11_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH11_CONTROL_0_h_gain_baseline;
    wire [15:0]CH11_CONTROL_0_l_gain_baseline;
    wire [15:0]CH11_CONTROL_0_max_trigger_length;
    wire [1:0]CH11_CONTROL_0_post_acquisition_length;
    wire [1:0]CH11_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH11_CONTROL_0_rising_edge_threshold;
    wire CH11_CONTROL_0_set_config;
    wire CH11_CONTROL_0_stop;
    wire [3:0]CH11_CONTROL_0_trigger_type;
    wire [1:0]CH12_CONTROL_0_acquire_mode;
    wire [15:0]CH12_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH12_CONTROL_0_h_gain_baseline;
    wire [15:0]CH12_CONTROL_0_l_gain_baseline;
    wire [15:0]CH12_CONTROL_0_max_trigger_length;
    wire [1:0]CH12_CONTROL_0_post_acquisition_length;
    wire [1:0]CH12_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH12_CONTROL_0_rising_edge_threshold;
    wire CH12_CONTROL_0_set_config;
    wire CH12_CONTROL_0_stop;
    wire [3:0]CH12_CONTROL_0_trigger_type;
    wire [1:0]CH13_CONTROL_0_acquire_mode;
    wire [15:0]CH13_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH13_CONTROL_0_h_gain_baseline;
    wire [15:0]CH13_CONTROL_0_l_gain_baseline;
    wire [15:0]CH13_CONTROL_0_max_trigger_length;
    wire [1:0]CH13_CONTROL_0_post_acquisition_length;
    wire [1:0]CH13_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH13_CONTROL_0_rising_edge_threshold;
    wire CH13_CONTROL_0_set_config;
    wire CH13_CONTROL_0_stop;
    wire [3:0]CH13_CONTROL_0_trigger_type;
    wire [1:0]CH14_CONTROL_0_acquire_mode;
    wire [15:0]CH14_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH14_CONTROL_0_h_gain_baseline;
    wire [15:0]CH14_CONTROL_0_l_gain_baseline;
    wire [15:0]CH14_CONTROL_0_max_trigger_length;
    wire [1:0]CH14_CONTROL_0_post_acquisition_length;
    wire [1:0]CH14_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH14_CONTROL_0_rising_edge_threshold;
    wire CH14_CONTROL_0_set_config;
    wire CH14_CONTROL_0_stop;
    wire [3:0]CH14_CONTROL_0_trigger_type;
    wire [1:0]CH15_CONTROL_0_acquire_mode;
    wire [15:0]CH15_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH15_CONTROL_0_h_gain_baseline;
    wire [15:0]CH15_CONTROL_0_l_gain_baseline;
    wire [15:0]CH15_CONTROL_0_max_trigger_length;
    wire [1:0]CH15_CONTROL_0_post_acquisition_length;
    wire [1:0]CH15_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH15_CONTROL_0_rising_edge_threshold;
    wire CH15_CONTROL_0_set_config;
    wire CH15_CONTROL_0_stop;
    wire [3:0]CH15_CONTROL_0_trigger_type;
    wire [1:0]CH1_CONTROL_0_acquire_mode;
    wire [15:0]CH1_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH1_CONTROL_0_h_gain_baseline;
    wire [15:0]CH1_CONTROL_0_l_gain_baseline;
    wire [15:0]CH1_CONTROL_0_max_trigger_length;
    wire [1:0]CH1_CONTROL_0_post_acquisition_length;
    wire [1:0]CH1_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH1_CONTROL_0_rising_edge_threshold;
    wire CH1_CONTROL_0_set_config;
    wire CH1_CONTROL_0_stop;
    wire [3:0]CH1_CONTROL_0_trigger_type;
    wire [1:0]CH2_CONTROL_0_acquire_mode;
    wire [15:0]CH2_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH2_CONTROL_0_h_gain_baseline;
    wire [15:0]CH2_CONTROL_0_l_gain_baseline;
    wire [15:0]CH2_CONTROL_0_max_trigger_length;
    wire [1:0]CH2_CONTROL_0_post_acquisition_length;
    wire [1:0]CH2_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH2_CONTROL_0_rising_edge_threshold;
    wire CH2_CONTROL_0_set_config;
    wire CH2_CONTROL_0_stop;
    wire [3:0]CH2_CONTROL_0_trigger_type;
    wire [1:0]CH3_CONTROL_0_acquire_mode;
    wire [15:0]CH3_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH3_CONTROL_0_h_gain_baseline;
    wire [15:0]CH3_CONTROL_0_l_gain_baseline;
    wire [15:0]CH3_CONTROL_0_max_trigger_length;
    wire [1:0]CH3_CONTROL_0_post_acquisition_length;
    wire [1:0]CH3_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH3_CONTROL_0_rising_edge_threshold;
    wire CH3_CONTROL_0_set_config;
    wire CH3_CONTROL_0_stop;
    wire [3:0]CH3_CONTROL_0_trigger_type;
    wire [1:0]CH4_CONTROL_0_acquire_mode;
    wire [15:0]CH4_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH4_CONTROL_0_h_gain_baseline;
    wire [15:0]CH4_CONTROL_0_l_gain_baseline;
    wire [15:0]CH4_CONTROL_0_max_trigger_length;
    wire [1:0]CH4_CONTROL_0_post_acquisition_length;
    wire [1:0]CH4_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH4_CONTROL_0_rising_edge_threshold;
    wire CH4_CONTROL_0_set_config;
    wire CH4_CONTROL_0_stop;
    wire [3:0]CH4_CONTROL_0_trigger_type;
    wire [1:0]CH5_CONTROL_0_acquire_mode;
    wire [15:0]CH5_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH5_CONTROL_0_h_gain_baseline;
    wire [15:0]CH5_CONTROL_0_l_gain_baseline;
    wire [15:0]CH5_CONTROL_0_max_trigger_length;
    wire [1:0]CH5_CONTROL_0_post_acquisition_length;
    wire [1:0]CH5_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH5_CONTROL_0_rising_edge_threshold;
    wire CH5_CONTROL_0_set_config;
    wire CH5_CONTROL_0_stop;
    wire [3:0]CH5_CONTROL_0_trigger_type;
    wire [1:0]CH6_CONTROL_0_acquire_mode;
    wire [15:0]CH6_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH6_CONTROL_0_h_gain_baseline;
    wire [15:0]CH6_CONTROL_0_l_gain_baseline;
    wire [15:0]CH6_CONTROL_0_max_trigger_length;
    wire [1:0]CH6_CONTROL_0_post_acquisition_length;
    wire [1:0]CH6_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH6_CONTROL_0_rising_edge_threshold;
    wire CH6_CONTROL_0_set_config;
    wire CH6_CONTROL_0_stop;
    wire [3:0]CH6_CONTROL_0_trigger_type;
    wire [1:0]CH7_CONTROL_0_acquire_mode;
    wire [15:0]CH7_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH7_CONTROL_0_h_gain_baseline;
    wire [15:0]CH7_CONTROL_0_l_gain_baseline;
    wire [15:0]CH7_CONTROL_0_max_trigger_length;
    wire [1:0]CH7_CONTROL_0_post_acquisition_length;
    wire [1:0]CH7_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH7_CONTROL_0_rising_edge_threshold;
    wire CH7_CONTROL_0_set_config;
    wire CH7_CONTROL_0_stop;
    wire [3:0]CH7_CONTROL_0_trigger_type;
    wire [1:0]CH8_CONTROL_0_acquire_mode;
    wire [15:0]CH8_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH8_CONTROL_0_h_gain_baseline;
    wire [15:0]CH8_CONTROL_0_l_gain_baseline;
    wire [15:0]CH8_CONTROL_0_max_trigger_length;
    wire [1:0]CH8_CONTROL_0_post_acquisition_length;
    wire [1:0]CH8_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH8_CONTROL_0_rising_edge_threshold;
    wire CH8_CONTROL_0_set_config;
    wire CH8_CONTROL_0_stop;
    wire [3:0]CH8_CONTROL_0_trigger_type;
    wire [1:0]CH9_CONTROL_0_acquire_mode;
    wire [15:0]CH9_CONTROL_0_falling_edge_threshold;
    wire [12:0]CH9_CONTROL_0_h_gain_baseline;
    wire [15:0]CH9_CONTROL_0_l_gain_baseline;
    wire [15:0]CH9_CONTROL_0_max_trigger_length;
    wire [1:0]CH9_CONTROL_0_post_acquisition_length;
    wire [1:0]CH9_CONTROL_0_pre_acquisition_length;
    wire [15:0]CH9_CONTROL_0_rising_edge_threshold;
    wire CH9_CONTROL_0_set_config;
    wire CH9_CONTROL_0_stop;
    wire [3:0]CH9_CONTROL_0_trigger_type;

    // response from data_write/read = [OKAY, EXOKAY, SLVERR, DECERR]
    reg [1:0] resp;
    // wire [1:0] DECODE_ERR = 2'b11;
    // wire [1:0] SLAVE_ERR = 2'b10;
    // wire [1:0] EXOKAY = 2'b01;
    // wire [1:0] OKAY = 2'b00;

    initial begin
        // Zynq MPSoC VIP initializing & Reset PL
        $display("Initializing Zynq MPSoC VIP & Reset PL from PS");
        fpga_soft_reset;
        $display("Reset PL from external");
        sys_reset; // Reset via external button
        repeat(32) @(posedge CLK);

        config_fee;

        $finish;
    end

    fee_cfg_sim_wrapper mpsoc_sys (
        .*
    );

    /////////////////////////////////////////////////////////////////
    //                  Ethernet config task definitions           //
    /////////////////////////////////////////////////////////////////
    parameter CHANNEL_OFFSET = 64'h0010;
    
    parameter FEE_CONFIG_BASE_ADDR = 64'h04_0000_0000;
    parameter FEE_CONFIG_MODE_MAX_TRIGGER_LEN_REG = FEE_CONFIG_BASE_ADDR + 64'h0000;
    parameter FEE_CONFIG_THRESHOLD_REG = FEE_CONFIG_BASE_ADDR + 64'h0004;
    parameter FEE_CONFIG_ACQUISITION_LEN_REG = FEE_CONFIG_BASE_ADDR + 64'h0008;
    parameter FEE_CONFIG_BASELINE_REG = FEE_CONFIG_BASE_ADDR + 64'h000C;

    parameter FEE_CONFIG_MODE_MAX_TRIGGER_LEN_REG_1 = FEE_CONFIG_BASE_ADDR + 64'h0000 + CHANNEL_OFFSET;
    parameter FEE_CONFIG_THRESHOLD_REG_1 = FEE_CONFIG_BASE_ADDR + 64'h0004+ CHANNEL_OFFSET;
    parameter FEE_CONFIG_ACQUISITION_LEN_REG_1 = FEE_CONFIG_BASE_ADDR + 64'h0008+ CHANNEL_OFFSET;
    parameter FEE_CONFIG_BASELINE_REG_1 = FEE_CONFIG_BASE_ADDR + 64'h000C+ CHANNEL_OFFSET;
    
    parameter FEE_CONFIG_MODE_MAX_TRIGGER_LEN_REG_2 = FEE_CONFIG_BASE_ADDR + 64'h0000 + CHANNEL_OFFSET*2;
    parameter FEE_CONFIG_THRESHOLD_REG_2 = FEE_CONFIG_BASE_ADDR + 64'h0004+ CHANNEL_OFFSET*2;
    parameter FEE_CONFIG_ACQUISITION_LEN_REG_2 = FEE_CONFIG_BASE_ADDR + 64'h0008+ CHANNEL_OFFSET*2;
    parameter FEE_CONFIG_BASELINE_REG_2 = FEE_CONFIG_BASE_ADDR + 64'h000C+ CHANNEL_OFFSET*2;


    parameter CONFIG_MODE = 4'b1100;
    parameter STOP_MODE = 4'b1000;
    parameter NORMAL_RUN_MODE = 4'b0000;
    parameter COMBINED_RUN_MODE = 4'b0001;
    
    parameter HARDWARE_TRIGGER = 4'b0000;
    parameter EXTERNAL_TRIGGER = 4'b0001;

    parameter MAX_TRIGGER_LENGTH = 16'd32;

    parameter RISING_EDGE_THRESHOLD = 16'd1024;
    parameter FALLING_EDGE_THRESHOLD = 16'd512;

    parameter PRE_ACQUISITION_LENGTH = 2'b1;
    parameter POST_ACQUISITION_LENGTH = 2'b1;

    parameter H_GAIN_BASELINE = 13'd1024;
    parameter L_GAIN_BASELINE = 16'd128;

    task config_fee;
        $display("Configuring FEE.");
        $display("enable config mode & max trigger length");
        // write_burst(addr, len, size, burst, lock, cache, prot, data, datasize, resp);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_MODE_MAX_TRIGGER_LEN_REG, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {8'b0, CONFIG_MODE, HARDWARE_TRIGGER, MAX_TRIGGER_LENGTH}, 4, resp);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_MODE_MAX_TRIGGER_LEN_REG_1, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {8'b0, CONFIG_MODE, EXTERNAL_TRIGGER, MAX_TRIGGER_LENGTH+16'd16}, 4, resp);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_MODE_MAX_TRIGGER_LEN_REG_2, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {8'b0, CONFIG_MODE, HARDWARE_TRIGGER, MAX_TRIGGER_LENGTH+16'd32}, 4, resp);
        repeat(10) @(posedge CLK);

        $display("setting threshold");
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_THRESHOLD_REG, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {RISING_EDGE_THRESHOLD, FALLING_EDGE_THRESHOLD}, 4, resp);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_THRESHOLD_REG_1, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {RISING_EDGE_THRESHOLD-16'd512, FALLING_EDGE_THRESHOLD-16'd512}, 4, resp);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_THRESHOLD_REG_2, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {RISING_EDGE_THRESHOLD-16'd1024, FALLING_EDGE_THRESHOLD-16'd1024}, 4, resp);
        repeat(10) @(posedge CLK);
        $display("setting pre/post acquisition length");
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_ACQUISITION_LEN_REG, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH}, 4, resp);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_ACQUISITION_LEN_REG_1, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH}, 4, resp);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_ACQUISITION_LEN_REG_2, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH}, 4, resp);
        repeat(10) @(posedge CLK);
        $display("setting baseline");
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_BASELINE_REG, 4'h0, 3'b010, 2'b01, 2'b00, 4'b0011, 3'b000, {3'b0, H_GAIN_BASELINE, L_GAIN_BASELINE}, 4, resp);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_BASELINE_REG_1, 4'h0, 3'b010, 2'b01, 2'b00, 4'b0011, 3'b000, {3'b0, H_GAIN_BASELINE-13'd1, L_GAIN_BASELINE-16'd1}, 4, resp);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_BASELINE_REG_2, 4'h0, 3'b010, 2'b01, 2'b00, 4'b0011, 3'b000, {3'b0, H_GAIN_BASELINE-13'd2, L_GAIN_BASELINE-16'd2}, 4, resp);
        repeat(10) @(posedge CLK);        

        $display("disable config mode & start normal run");
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_MODE_MAX_TRIGGER_LEN_REG, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {8'b0, NORMAL_RUN_MODE, HARDWARE_TRIGGER, MAX_TRIGGER_LENGTH}, 4, resp);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_MODE_MAX_TRIGGER_LEN_REG_1, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {8'b0, COMBINED_RUN_MODE, EXTERNAL_TRIGGER, MAX_TRIGGER_LENGTH+16'd16}, 4, resp);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_MODE_MAX_TRIGGER_LEN_REG_2, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {8'b0, NORMAL_RUN_MODE, HARDWARE_TRIGGER, MAX_TRIGGER_LENGTH+16'd32}, 4, resp);
        repeat(10) @(posedge CLK);
        $display("Configuring FEE done!");
    endtask :config_fee



    /////////////////////////////////////////////////////////////////
    //                      utility tasks                          //
    /////////////////////////////////////////////////////////////////
    task sys_reset;
        EXT_RESET <= 1'b1;
        repeat(RESET_CLK_NUM) @(posedge CLK);
        EXT_RESET <= 1'b0;
    endtask :sys_reset

    task fpga_soft_reset;
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.por_srstb_reset(1'b1);
        repeat(RESET_CLK_NUM) @(posedge CLK);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.por_srstb_reset(1'b0);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.fpga_soft_reset(4'hF);
        repeat(RESET_CLK_NUM) @(posedge CLK);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.por_srstb_reset(1'b1);
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.fpga_soft_reset(4'h0);
        repeat(RESET_CLK_NUM) @(posedge CLK);
    endtask :fpga_soft_reset

    initial begin
        CLK =0;
        forever #(CLK_PERIOD/2)   CLK = ~ CLK;
    end

endmodule
