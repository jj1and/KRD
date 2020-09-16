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

  wire [0:0]ACQUIRE_MODE_0;
  wire [15:0]FALLING_EDGE_THRESHOLD_0;
  wire [12:0]H_GAIN_BASELINE_0;
  wire [15:0]L_GAIN_BASELINE_0;
  wire [15:0]MAX_TRIGGER_LENGTH_0;
  wire [1:0]POST_ACQUISITION_LENGTH_0;
  wire [1:0]PRE_ACQUISITION_LENGTH_0;
  wire [15:0]RISING_EDGE_THRESHOLD_0;
  wire [0:0]SET_CONFIG_0;
  wire [0:0]STOP_0;

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
    parameter FEE_CONFIG_BASE_ADDR = 64'h04_0000_0000;
    parameter FEE_CONFIG_MODE_MAX_TRIGGER_LEN_REG = FEE_CONFIG_BASE_ADDR + 64'h0000;
    parameter FEE_CONFIG_THRESHOLD_REG = FEE_CONFIG_BASE_ADDR + 64'h0004;
    parameter FEE_CONFIG_ACQUISITION_LEN_REG = FEE_CONFIG_BASE_ADDR + 64'h0008;
    parameter FEE_CONFIG_BASELINE_REG = FEE_CONFIG_BASE_ADDR + 64'h000C;


    parameter CONFIG_MODE = 3'b110;
    parameter STOP_MODE = 3'b010;
    parameter NORMAL_RUN_MODE = 3'b000;
    parameter COMBINED_RUN_MODE = 3'b001;

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
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_MODE_MAX_TRIGGER_LEN_REG, 4'h0, 3'b011, 2'b01, 2'b00,  4'b0011, 3'b000, {13'b0, CONFIG_MODE, MAX_TRIGGER_LENGTH}, 4, resp);
        repeat(10) @(posedge CLK);

        $display("setting threshold");
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_THRESHOLD_REG, 4'h0, 3'b011, 2'b01, 2'b00,  4'b0011, 3'b000, {RISING_EDGE_THRESHOLD, FALLING_EDGE_THRESHOLD}, 4, resp);
        repeat(10) @(posedge CLK);
        $display("setting pre/post acquisition length");
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_ACQUISITION_LEN_REG, 4'h0, 3'b011, 2'b01, 2'b00,  4'b0011, 3'b000, {PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH}, 4, resp);
        repeat(10) @(posedge CLK);
        $display("setting baseline");
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_BASELINE_REG, 4'h0, 3'b010, 2'b01, 2'b00, 4'b0011, 3'b000, {3'b0, H_GAIN_BASELINE, L_GAIN_BASELINE}, 4, resp);
        repeat(10) @(posedge CLK);        

        $display("disable config mode & start normal run");
        fee_cfg_sim_tb.mpsoc_sys.fee_cfg_sim_i.zynq_ultra_ps_e_0.inst.write_burst(FEE_CONFIG_MODE_MAX_TRIGGER_LEN_REG, 4'h0, 3'b010, 2'b01, 2'b00,  4'b0011, 3'b000, {13'b0, NORMAL_RUN_MODE, MAX_TRIGGER_LENGTH}, 4, resp);
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
