`ifndef xlConvPkgIncluded
`include "conv_pkg.v"
`endif

`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/+cut
module dsp_blr_7_cut (
  input [17-1:0] in1,
  input clk_1,
  input ce_1,
  output [17-1:0] out1
);
  wire [17-1:0] shift7_op_net;
  wire [17-1:0] addsub15_s_net;
  wire [17-1:0] addsub7_s_net;
  wire ce_net;
  wire clk_net;
  wire [17-1:0] delay3_q_net;
  wire [19-1:0] p_e_n_p_net;
  wire [2-1:0] threshold_y_net;
  wire [17-1:0] delay2_q_net;
  assign out1 = shift7_op_net;
  assign addsub15_s_net = in1;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i0"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(20),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(17)
  )
  addsub7 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay3_q_net),
    .b(p_e_n_p_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub7_s_net)
  );
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(17)
  )
  delay2 (
    .en(1'b1),
    .rst(1'b0),
    .d(addsub15_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay2_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(3),
    .reg_retiming(0),
    .reset(0),
    .width(17)
  )
  delay3 (
    .en(1'b1),
    .rst(1'b0),
    .d(delay2_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay3_q_net)
  );
  dsp_blr_7_xlmult #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(0),
    .b_width(2),
    .c_a_type(0),
    .c_a_width(17),
    .c_b_type(0),
    .c_b_width(2),
    .c_baat(17),
    .c_output_width(19),
    .c_type(0),
    .core_name0("dsp_blr_7_mult_gen_v12_0_i0"),
    .extra_registers(0),
    .multsign(2),
    .overflow(1),
    .p_arith(`xlSigned),
    .p_bin_pt(4),
    .p_width(19),
    .quantization(1)
  )
  p_e_n (
    .clr(1'b0),
    .core_clr(1'b1),
    .en(1'b1),
    .rst(1'b0),
    .a(delay2_q_net),
    .b(threshold_y_net),
    .clk(clk_net),
    .ce(ce_net),
    .core_clk(clk_net),
    .core_ce(ce_net),
    .p(p_e_n_p_net)
  );
  sysgen_shift_473d519c68 shift7 (
    .clr(1'b0),
    .ip(addsub7_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift7_op_net)
  );
  sysgen_sgn_2d779b2a8b threshold (
    .clr(1'b0),
    .x(addsub15_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .y(threshold_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/Ave7
module dsp_blr_7_ave7 (
  input [128-1:0] tdata_in,
  input clk_1,
  input ce_1,
  output [17-1:0] sum_data_out
);
  wire [18-1:0] addsub5_s_net;
  wire [16-1:0] shift3_op_net;
  wire [16-1:0] delay6_q_net;
  wire [17-1:0] addsub2_s_net;
  wire [17-1:0] delay4_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] shift1_op_net;
  wire [16-1:0] shift5_op_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] slice_y_net;
  wire [16-1:0] reinterpret_output_port_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice2_y_net;
  wire [17-1:0] addsub3_s_net;
  wire [17-1:0] addsub14_s_net;
  wire [128-1:0] concat1_y_net;
  wire [18-1:0] addsub4_s_net;
  wire clk_net;
  wire [17-1:0] addsub1_s_net;
  wire [17-1:0] addsub15_s_net;
  wire [17-1:0] addsub12_s_net;
  wire [17-1:0] addsub13_s_net;
  wire [17-1:0] addsub_s_net;
  wire [16-1:0] delay1_q_net;
  wire [17-1:0] delay5_q_net;
  wire [17-1:0] delay8_q_net;
  wire [16-1:0] shift7_op_net;
  wire [17-1:0] delay7_q_net;
  wire [17-1:0] addsub8_s_net;
  wire ce_net;
  wire [19-1:0] addsub6_s_net;
  wire [17-1:0] delay12_q_net;
  assign sum_data_out = addsub15_s_net;
  assign concat1_y_net = tdata_in;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i1"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(17)
  )
  addsub (
    .clr(1'b0),
    .en(1'b1),
    .a(shift7_op_net),
    .b(delay1_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i2"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(18),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(17)
  )
  addsub1 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub_s_net),
    .b(delay7_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i2"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(18),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(17)
  )
  addsub12 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub8_s_net),
    .b(delay5_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub12_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i2"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(18),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(17)
  )
  addsub13 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub3_s_net),
    .b(delay8_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub13_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i3"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(20),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(17)
  )
  addsub14 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub4_s_net),
    .b(addsub6_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub14_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i2"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(18),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(17)
  )
  addsub15 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub14_s_net),
    .b(delay12_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub15_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i1"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(17)
  )
  addsub2 (
    .clr(1'b0),
    .en(1'b1),
    .a(shift3_op_net),
    .b(delay3_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub2_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i1"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(17)
  )
  addsub3 (
    .clr(1'b0),
    .en(1'b1),
    .a(shift1_op_net),
    .b(delay6_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i2"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(18),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(18)
  )
  addsub4 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub1_s_net),
    .b(addsub12_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub4_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i2"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(18),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(18)
  )
  addsub5 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub2_s_net),
    .b(delay4_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub5_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(19),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i4"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(19),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(19)
  )
  addsub6 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub5_s_net),
    .b(addsub13_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub6_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i1"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(17)
  )
  addsub8 (
    .clr(1'b0),
    .en(1'b1),
    .a(shift5_op_net),
    .b(delay2_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub8_s_net)
  );
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay1 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift7_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay1_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(4),
    .reg_retiming(0),
    .reset(0),
    .width(17)
  )
  delay12 (
    .en(1'b1),
    .rst(1'b0),
    .d(addsub14_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay12_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay2 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift5_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay2_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay3 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift3_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay3_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(2),
    .reg_retiming(0),
    .reset(0),
    .width(17)
  )
  delay4 (
    .en(1'b1),
    .rst(1'b0),
    .d(addsub2_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay4_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(2),
    .reg_retiming(0),
    .reset(0),
    .width(17)
  )
  delay5 (
    .en(1'b1),
    .rst(1'b0),
    .d(addsub8_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay5_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay6 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift1_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay6_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(2),
    .reg_retiming(0),
    .reset(0),
    .width(17)
  )
  delay7 (
    .en(1'b1),
    .rst(1'b0),
    .d(addsub_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay7_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(2),
    .reg_retiming(0),
    .reset(0),
    .width(17)
  )
  delay8 (
    .en(1'b1),
    .rst(1'b0),
    .d(addsub3_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay8_q_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice_y_net),
    .output_port(reinterpret_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_shift_139ed2ae46 shift1 (
    .clr(1'b0),
    .ip(reinterpret6_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift1_op_net)
  );
  sysgen_shift_139ed2ae46 shift3 (
    .clr(1'b0),
    .ip(reinterpret4_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift3_op_net)
  );
  sysgen_shift_139ed2ae46 shift5 (
    .clr(1'b0),
    .ip(reinterpret2_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift5_op_net)
  );
  sysgen_shift_139ed2ae46 shift7 (
    .clr(1'b0),
    .ip(reinterpret_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift7_op_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice (
    .x(concat1_y_net),
    .y(slice_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(concat1_y_net),
    .y(slice2_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(concat1_y_net),
    .y(slice4_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(concat1_y_net),
    .y(slice6_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/DBL_Scalar2Vector1/Scalar2Vector
module dsp_blr_7_scalar2vector (
  input [128-1:0] i,
  output [16-1:0] o_1,
  output [16-1:0] o_2,
  output [16-1:0] o_3,
  output [16-1:0] o_4,
  output [16-1:0] o_5,
  output [16-1:0] o_6,
  output [16-1:0] o_7,
  output [16-1:0] o_8
);
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice3_y_net;
  wire [128-1:0] concat_y_net;
  assign o_1 = slice0_y_net;
  assign o_2 = slice1_y_net;
  assign o_3 = slice2_y_net;
  assign o_4 = slice3_y_net;
  assign o_5 = slice4_y_net;
  assign o_6 = slice5_y_net;
  assign o_7 = slice6_y_net;
  assign o_8 = slice7_y_net;
  assign concat_y_net = i;
  dsp_blr_7_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice0 (
    .x(concat_y_net),
    .y(slice0_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(concat_y_net),
    .y(slice1_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(concat_y_net),
    .y(slice2_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(concat_y_net),
    .y(slice3_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(concat_y_net),
    .y(slice4_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(concat_y_net),
    .y(slice5_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(concat_y_net),
    .y(slice6_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(112),
    .new_msb(127),
    .x_width(128),
    .y_width(16)
  )
  slice7 (
    .x(concat_y_net),
    .y(slice7_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/DBL_Scalar2Vector1/Vector Reinterpret
module dsp_blr_7_vector_reinterpret (
  input [16-1:0] in_1,
  input [16-1:0] in_2,
  input [16-1:0] in_3,
  input [16-1:0] in_4,
  input [16-1:0] in_5,
  input [16-1:0] in_6,
  input [16-1:0] in_7,
  input [16-1:0] in_8,
  output [16-1:0] out_1,
  output [16-1:0] out_2,
  output [16-1:0] out_3,
  output [16-1:0] out_4,
  output [16-1:0] out_5,
  output [16-1:0] out_6,
  output [16-1:0] out_7,
  output [16-1:0] out_8
);
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice5_y_net;
  assign out_1 = reinterpret0_output_port_net;
  assign out_2 = reinterpret1_output_port_net;
  assign out_3 = reinterpret2_output_port_net;
  assign out_4 = reinterpret3_output_port_net;
  assign out_5 = reinterpret4_output_port_net;
  assign out_6 = reinterpret5_output_port_net;
  assign out_7 = reinterpret6_output_port_net;
  assign out_8 = reinterpret7_output_port_net;
  assign slice0_y_net = in_1;
  assign slice1_y_net = in_2;
  assign slice2_y_net = in_3;
  assign slice3_y_net = in_4;
  assign slice4_y_net = in_5;
  assign slice5_y_net = in_6;
  assign slice6_y_net = in_7;
  assign slice7_y_net = in_8;
  sysgen_reinterpret_84ad9a0c4c reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice0_y_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/DBL_Scalar2Vector1
module dsp_blr_7_dbl_scalar2vector1 (
  input [16-1:0] in1,
  output [16-1:0] out1_1,
  output [16-1:0] out1_2,
  output [16-1:0] out1_3,
  output [16-1:0] out1_4,
  output [16-1:0] out1_5,
  output [16-1:0] out1_6,
  output [16-1:0] out1_7,
  output [16-1:0] out1_8
);
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] dout_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice5_y_net;
  wire [128-1:0] concat_y_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret_output_port_net;
  assign out1_1 = reinterpret0_output_port_net;
  assign out1_2 = reinterpret1_output_port_net;
  assign out1_3 = reinterpret2_output_port_net;
  assign out1_4 = reinterpret3_output_port_net;
  assign out1_5 = reinterpret4_output_port_net;
  assign out1_6 = reinterpret5_output_port_net;
  assign out1_7 = reinterpret6_output_port_net;
  assign out1_8 = reinterpret7_output_port_net;
  assign dout_net = in1;
  dsp_blr_7_scalar2vector scalar2vector (
    .i(concat_y_net),
    .o_1(slice0_y_net),
    .o_2(slice1_y_net),
    .o_3(slice2_y_net),
    .o_4(slice3_y_net),
    .o_5(slice4_y_net),
    .o_6(slice5_y_net),
    .o_7(slice6_y_net),
    .o_8(slice7_y_net)
  );
  dsp_blr_7_vector_reinterpret vector_reinterpret (
    .in_1(slice0_y_net),
    .in_2(slice1_y_net),
    .in_3(slice2_y_net),
    .in_4(slice3_y_net),
    .in_5(slice4_y_net),
    .in_6(slice5_y_net),
    .in_7(slice6_y_net),
    .in_8(slice7_y_net),
    .out_1(reinterpret0_output_port_net),
    .out_2(reinterpret1_output_port_net),
    .out_3(reinterpret2_output_port_net),
    .out_4(reinterpret3_output_port_net),
    .out_5(reinterpret4_output_port_net),
    .out_6(reinterpret5_output_port_net),
    .out_7(reinterpret6_output_port_net),
    .out_8(reinterpret7_output_port_net)
  );
  sysgen_concat_32ac66d15d concat (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .in0(reinterpret_output_port_net),
    .in1(reinterpret_output_port_net),
    .in2(reinterpret_output_port_net),
    .in3(reinterpret_output_port_net),
    .in4(reinterpret_output_port_net),
    .in5(reinterpret_output_port_net),
    .in6(reinterpret_output_port_net),
    .in7(reinterpret_output_port_net),
    .y(concat_y_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(dout_net),
    .output_port(reinterpret_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/DSP_Vector2Scalar/Vector2Scalar
module dsp_blr_7_vector2scalar (
  input [16-1:0] i_1,
  input [16-1:0] i_2,
  input [16-1:0] i_3,
  input [16-1:0] i_4,
  input [16-1:0] i_5,
  input [16-1:0] i_6,
  input [16-1:0] i_7,
  input [16-1:0] i_8,
  output [128-1:0] o
);
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret6_output_port_net;
  assign o = concat1_y_net;
  assign reinterpret0_output_port_net = i_1;
  assign reinterpret1_output_port_net = i_2;
  assign reinterpret2_output_port_net = i_3;
  assign reinterpret3_output_port_net = i_4;
  assign reinterpret4_output_port_net = i_5;
  assign reinterpret5_output_port_net = i_6;
  assign reinterpret6_output_port_net = i_7;
  assign reinterpret7_output_port_net = i_8;
  sysgen_concat_32ac66d15d concat1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .in0(reinterpret7_output_port_net),
    .in1(reinterpret6_output_port_net),
    .in2(reinterpret5_output_port_net),
    .in3(reinterpret4_output_port_net),
    .in4(reinterpret3_output_port_net),
    .in5(reinterpret2_output_port_net),
    .in6(reinterpret1_output_port_net),
    .in7(reinterpret0_output_port_net),
    .y(concat1_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/DSP_Vector2Scalar/Vector_reinterpret2unsigned
module dsp_blr_7_vector_reinterpret2unsigned (
  input [16-1:0] in_1,
  input [16-1:0] in_2,
  input [16-1:0] in_3,
  input [16-1:0] in_4,
  input [16-1:0] in_5,
  input [16-1:0] in_6,
  input [16-1:0] in_7,
  input [16-1:0] in_8,
  output [16-1:0] out_1,
  output [16-1:0] out_2,
  output [16-1:0] out_3,
  output [16-1:0] out_4,
  output [16-1:0] out_5,
  output [16-1:0] out_6,
  output [16-1:0] out_7,
  output [16-1:0] out_8
);
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] addsub2_s_net;
  wire [16-1:0] addsub6_s_net;
  wire [16-1:0] addsub1_s_net;
  wire [16-1:0] addsub4_s_net;
  wire [16-1:0] addsub3_s_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] addsub5_s_net;
  wire [16-1:0] addsub7_s_net;
  wire [16-1:0] addsub0_s_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  assign out_1 = reinterpret0_output_port_net;
  assign out_2 = reinterpret1_output_port_net;
  assign out_3 = reinterpret2_output_port_net;
  assign out_4 = reinterpret3_output_port_net;
  assign out_5 = reinterpret4_output_port_net;
  assign out_6 = reinterpret5_output_port_net;
  assign out_7 = reinterpret6_output_port_net;
  assign out_8 = reinterpret7_output_port_net;
  assign addsub0_s_net = in_1;
  assign addsub1_s_net = in_2;
  assign addsub2_s_net = in_3;
  assign addsub3_s_net = in_4;
  assign addsub4_s_net = in_5;
  assign addsub5_s_net = in_6;
  assign addsub6_s_net = in_7;
  assign addsub7_s_net = in_8;
  sysgen_reinterpret_a71497b768 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub0_s_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub1_s_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub2_s_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub3_s_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub4_s_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub5_s_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub6_s_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub7_s_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/DSP_Vector2Scalar
module dsp_blr_7_dsp_vector2scalar (
  input [16-1:0] in1_1,
  input [16-1:0] in1_2,
  input [16-1:0] in1_3,
  input [16-1:0] in1_4,
  input [16-1:0] in1_5,
  input [16-1:0] in1_6,
  input [16-1:0] in1_7,
  input [16-1:0] in1_8,
  output [128-1:0] out1
);
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] addsub2_s_net;
  wire [16-1:0] addsub1_s_net;
  wire [16-1:0] addsub3_s_net;
  wire [16-1:0] addsub6_s_net;
  wire [16-1:0] addsub4_s_net;
  wire [16-1:0] addsub7_s_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] addsub5_s_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] addsub0_s_net;
  assign out1 = concat1_y_net;
  assign addsub0_s_net = in1_1;
  assign addsub1_s_net = in1_2;
  assign addsub2_s_net = in1_3;
  assign addsub3_s_net = in1_4;
  assign addsub4_s_net = in1_5;
  assign addsub5_s_net = in1_6;
  assign addsub6_s_net = in1_7;
  assign addsub7_s_net = in1_8;
  dsp_blr_7_vector2scalar vector2scalar (
    .i_1(reinterpret0_output_port_net),
    .i_2(reinterpret1_output_port_net),
    .i_3(reinterpret2_output_port_net),
    .i_4(reinterpret3_output_port_net),
    .i_5(reinterpret4_output_port_net),
    .i_6(reinterpret5_output_port_net),
    .i_7(reinterpret6_output_port_net),
    .i_8(reinterpret7_output_port_net),
    .o(concat1_y_net)
  );
  dsp_blr_7_vector_reinterpret2unsigned vector_reinterpret2unsigned (
    .in_1(addsub0_s_net),
    .in_2(addsub1_s_net),
    .in_3(addsub2_s_net),
    .in_4(addsub3_s_net),
    .in_5(addsub4_s_net),
    .in_6(addsub5_s_net),
    .in_7(addsub6_s_net),
    .in_8(addsub7_s_net),
    .out_1(reinterpret0_output_port_net),
    .out_2(reinterpret1_output_port_net),
    .out_3(reinterpret2_output_port_net),
    .out_4(reinterpret3_output_port_net),
    .out_5(reinterpret4_output_port_net),
    .out_6(reinterpret5_output_port_net),
    .out_7(reinterpret6_output_port_net),
    .out_8(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/DSP_delay
module dsp_blr_7_dsp_delay (
  input [16-1:0] d_1,
  input [16-1:0] d_2,
  input [16-1:0] d_3,
  input [16-1:0] d_4,
  input [16-1:0] d_5,
  input [16-1:0] d_6,
  input [16-1:0] d_7,
  input [16-1:0] d_8,
  input clk_1,
  input ce_1,
  output [16-1:0] q_1,
  output [16-1:0] q_2,
  output [16-1:0] q_3,
  output [16-1:0] q_4,
  output [16-1:0] q_5,
  output [16-1:0] q_6,
  output [16-1:0] q_7,
  output [16-1:0] q_8
);
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire clk_net;
  wire ce_net;
  wire [16-1:0] reinterpret6_output_port_net;
  assign q_1 = delay0_q_net;
  assign q_2 = delay1_q_net;
  assign q_3 = delay2_q_net;
  assign q_4 = delay3_q_net;
  assign q_5 = delay4_q_net;
  assign q_6 = delay5_q_net;
  assign q_7 = delay6_q_net;
  assign q_8 = delay7_q_net;
  assign reinterpret0_output_port_net = d_1;
  assign reinterpret1_output_port_net = d_2;
  assign reinterpret2_output_port_net = d_3;
  assign reinterpret3_output_port_net = d_4;
  assign reinterpret4_output_port_net = d_5;
  assign reinterpret5_output_port_net = d_6;
  assign reinterpret6_output_port_net = d_7;
  assign reinterpret7_output_port_net = d_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_7_xldelay #(
    .latency(7),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay0 (
    .en(1'b1),
    .rst(1'b0),
    .d(reinterpret0_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay0_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(7),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay1 (
    .en(1'b1),
    .rst(1'b0),
    .d(reinterpret1_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay1_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(7),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay2 (
    .en(1'b1),
    .rst(1'b0),
    .d(reinterpret2_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay2_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(7),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay3 (
    .en(1'b1),
    .rst(1'b0),
    .d(reinterpret3_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay3_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(7),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay4 (
    .en(1'b1),
    .rst(1'b0),
    .d(reinterpret4_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay4_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(7),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay5 (
    .en(1'b1),
    .rst(1'b0),
    .d(reinterpret5_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay5_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(7),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay6 (
    .en(1'b1),
    .rst(1'b0),
    .d(reinterpret6_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay6_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(7),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay7 (
    .en(1'b1),
    .rst(1'b0),
    .d(reinterpret7_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay7_q_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/HGAIN_Vector2Scalar/Vector2Scalar
module dsp_blr_7_vector2scalar_x0 (
  input [16-1:0] i_1,
  input [16-1:0] i_2,
  input [16-1:0] i_3,
  input [16-1:0] i_4,
  input [16-1:0] i_5,
  input [16-1:0] i_6,
  input [16-1:0] i_7,
  input [16-1:0] i_8,
  output [128-1:0] o
);
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  assign o = concat1_y_net;
  assign reinterpret0_output_port_net = i_1;
  assign reinterpret1_output_port_net = i_2;
  assign reinterpret2_output_port_net = i_3;
  assign reinterpret3_output_port_net = i_4;
  assign reinterpret4_output_port_net = i_5;
  assign reinterpret5_output_port_net = i_6;
  assign reinterpret6_output_port_net = i_7;
  assign reinterpret7_output_port_net = i_8;
  sysgen_concat_32ac66d15d concat1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .in0(reinterpret7_output_port_net),
    .in1(reinterpret6_output_port_net),
    .in2(reinterpret5_output_port_net),
    .in3(reinterpret4_output_port_net),
    .in4(reinterpret3_output_port_net),
    .in5(reinterpret2_output_port_net),
    .in6(reinterpret1_output_port_net),
    .in7(reinterpret0_output_port_net),
    .y(concat1_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/HGAIN_Vector2Scalar/Vector_reinterpret2unsigned
module dsp_blr_7_vector_reinterpret2unsigned_x0 (
  input [16-1:0] in_1,
  input [16-1:0] in_2,
  input [16-1:0] in_3,
  input [16-1:0] in_4,
  input [16-1:0] in_5,
  input [16-1:0] in_6,
  input [16-1:0] in_7,
  input [16-1:0] in_8,
  output [16-1:0] out_1,
  output [16-1:0] out_2,
  output [16-1:0] out_3,
  output [16-1:0] out_4,
  output [16-1:0] out_5,
  output [16-1:0] out_6,
  output [16-1:0] out_7,
  output [16-1:0] out_8
);
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] delay1_q_net;
  assign out_1 = reinterpret0_output_port_net;
  assign out_2 = reinterpret1_output_port_net;
  assign out_3 = reinterpret2_output_port_net;
  assign out_4 = reinterpret3_output_port_net;
  assign out_5 = reinterpret4_output_port_net;
  assign out_6 = reinterpret5_output_port_net;
  assign out_7 = reinterpret6_output_port_net;
  assign out_8 = reinterpret7_output_port_net;
  assign delay0_q_net = in_1;
  assign delay1_q_net = in_2;
  assign delay2_q_net = in_3;
  assign delay3_q_net = in_4;
  assign delay4_q_net = in_5;
  assign delay5_q_net = in_6;
  assign delay6_q_net = in_7;
  assign delay7_q_net = in_8;
  sysgen_reinterpret_a71497b768 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay0_q_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay1_q_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay2_q_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay3_q_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay4_q_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay5_q_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay6_q_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_a71497b768 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay7_q_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/HGAIN_Vector2Scalar
module dsp_blr_7_hgain_vector2scalar (
  input [16-1:0] in1_1,
  input [16-1:0] in1_2,
  input [16-1:0] in1_3,
  input [16-1:0] in1_4,
  input [16-1:0] in1_5,
  input [16-1:0] in1_6,
  input [16-1:0] in1_7,
  input [16-1:0] in1_8,
  output [128-1:0] out1
);
  wire [16-1:0] delay3_q_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  assign out1 = concat1_y_net;
  assign delay0_q_net = in1_1;
  assign delay1_q_net = in1_2;
  assign delay2_q_net = in1_3;
  assign delay3_q_net = in1_4;
  assign delay4_q_net = in1_5;
  assign delay5_q_net = in1_6;
  assign delay6_q_net = in1_7;
  assign delay7_q_net = in1_8;
  dsp_blr_7_vector2scalar_x0 vector2scalar (
    .i_1(reinterpret0_output_port_net),
    .i_2(reinterpret1_output_port_net),
    .i_3(reinterpret2_output_port_net),
    .i_4(reinterpret3_output_port_net),
    .i_5(reinterpret4_output_port_net),
    .i_6(reinterpret5_output_port_net),
    .i_7(reinterpret6_output_port_net),
    .i_8(reinterpret7_output_port_net),
    .o(concat1_y_net)
  );
  dsp_blr_7_vector_reinterpret2unsigned_x0 vector_reinterpret2unsigned (
    .in_1(delay0_q_net),
    .in_2(delay1_q_net),
    .in_3(delay2_q_net),
    .in_4(delay3_q_net),
    .in_5(delay4_q_net),
    .in_6(delay5_q_net),
    .in_7(delay6_q_net),
    .in_8(delay7_q_net),
    .out_1(reinterpret0_output_port_net),
    .out_2(reinterpret1_output_port_net),
    .out_3(reinterpret2_output_port_net),
    .out_4(reinterpret3_output_port_net),
    .out_5(reinterpret4_output_port_net),
    .out_6(reinterpret5_output_port_net),
    .out_7(reinterpret6_output_port_net),
    .out_8(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/HGAIN_delay
module dsp_blr_7_hgain_delay (
  input [16-1:0] d_1,
  input [16-1:0] d_2,
  input [16-1:0] d_3,
  input [16-1:0] d_4,
  input [16-1:0] d_5,
  input [16-1:0] d_6,
  input [16-1:0] d_7,
  input [16-1:0] d_8,
  input clk_1,
  input ce_1,
  output [16-1:0] q_1,
  output [16-1:0] q_2,
  output [16-1:0] q_3,
  output [16-1:0] q_4,
  output [16-1:0] q_5,
  output [16-1:0] q_6,
  output [16-1:0] q_7,
  output [16-1:0] q_8
);
  wire [16-1:0] delay0_q_net_x0;
  wire [16-1:0] delay4_q_net_x0;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay5_q_net_x0;
  wire [16-1:0] delay3_q_net_x0;
  wire [16-1:0] delay6_q_net_x0;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay7_q_net_x0;
  wire [16-1:0] delay1_q_net_x0;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay2_q_net_x0;
  wire [16-1:0] delay3_q_net;
  wire ce_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay7_q_net;
  wire clk_net;
  wire [16-1:0] delay4_q_net;
  assign q_1 = delay0_q_net;
  assign q_2 = delay1_q_net;
  assign q_3 = delay2_q_net;
  assign q_4 = delay3_q_net_x0;
  assign q_5 = delay4_q_net_x0;
  assign q_6 = delay5_q_net_x0;
  assign q_7 = delay6_q_net_x0;
  assign q_8 = delay7_q_net_x0;
  assign delay0_q_net_x0 = d_1;
  assign delay1_q_net_x0 = d_2;
  assign delay2_q_net_x0 = d_3;
  assign delay3_q_net = d_4;
  assign delay4_q_net = d_5;
  assign delay5_q_net = d_6;
  assign delay6_q_net = d_7;
  assign delay7_q_net = d_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay0 (
    .en(1'b1),
    .rst(1'b0),
    .d(delay0_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay0_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay1 (
    .en(1'b1),
    .rst(1'b0),
    .d(delay1_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay1_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay2 (
    .en(1'b1),
    .rst(1'b0),
    .d(delay2_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay2_q_net)
  );
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay3 (
    .en(1'b1),
    .rst(1'b0),
    .d(delay3_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay3_q_net_x0)
  );
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay4 (
    .en(1'b1),
    .rst(1'b0),
    .d(delay4_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay4_q_net_x0)
  );
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay5 (
    .en(1'b1),
    .rst(1'b0),
    .d(delay5_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay5_q_net_x0)
  );
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay6 (
    .en(1'b1),
    .rst(1'b0),
    .d(delay6_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay6_q_net_x0)
  );
  dsp_blr_7_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay7 (
    .en(1'b1),
    .rst(1'b0),
    .d(delay7_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay7_q_net_x0)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/Scalar2Vector
module dsp_blr_7_scalar2vector_x0 (
  input [128-1:0] i,
  output [16-1:0] o_1,
  output [16-1:0] o_2,
  output [16-1:0] o_3,
  output [16-1:0] o_4,
  output [16-1:0] o_5,
  output [16-1:0] o_6,
  output [16-1:0] o_7,
  output [16-1:0] o_8
);
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice4_y_net;
  wire [128-1:0] h_s_axis_tdata_net;
  wire [16-1:0] slice7_y_net;
  assign o_1 = slice0_y_net;
  assign o_2 = slice1_y_net;
  assign o_3 = slice2_y_net;
  assign o_4 = slice3_y_net;
  assign o_5 = slice4_y_net;
  assign o_6 = slice5_y_net;
  assign o_7 = slice6_y_net;
  assign o_8 = slice7_y_net;
  assign h_s_axis_tdata_net = i;
  dsp_blr_7_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice0 (
    .x(h_s_axis_tdata_net),
    .y(slice0_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(h_s_axis_tdata_net),
    .y(slice1_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(h_s_axis_tdata_net),
    .y(slice2_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(h_s_axis_tdata_net),
    .y(slice3_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(h_s_axis_tdata_net),
    .y(slice4_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(h_s_axis_tdata_net),
    .y(slice5_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(h_s_axis_tdata_net),
    .y(slice6_y_net)
  );
  dsp_blr_7_xlslice #(
    .new_lsb(112),
    .new_msb(127),
    .x_width(128),
    .y_width(16)
  )
  slice7 (
    .x(h_s_axis_tdata_net),
    .y(slice7_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/Vector AddSub Fabric2
module dsp_blr_7_vector_addsub_fabric2 (
  input [16-1:0] a_1,
  input [16-1:0] b_1,
  input [16-1:0] a_2,
  input [16-1:0] a_3,
  input [16-1:0] a_4,
  input [16-1:0] a_5,
  input [16-1:0] a_6,
  input [16-1:0] a_7,
  input [16-1:0] a_8,
  input [16-1:0] b_2,
  input [16-1:0] b_3,
  input [16-1:0] b_4,
  input [16-1:0] b_5,
  input [16-1:0] b_6,
  input [16-1:0] b_7,
  input [16-1:0] b_8,
  input clk_1,
  input ce_1,
  output [16-1:0] a_b_1,
  output [16-1:0] a_b_2,
  output [16-1:0] a_b_3,
  output [16-1:0] a_b_4,
  output [16-1:0] a_b_5,
  output [16-1:0] a_b_6,
  output [16-1:0] a_b_7,
  output [16-1:0] a_b_8
);
  wire [16-1:0] addsub1_s_net;
  wire [16-1:0] addsub2_s_net;
  wire [16-1:0] addsub0_s_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] addsub5_s_net;
  wire [16-1:0] addsub3_s_net;
  wire [16-1:0] addsub4_s_net;
  wire [16-1:0] addsub6_s_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] addsub7_s_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire clk_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire ce_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  assign a_b_1 = addsub0_s_net;
  assign a_b_2 = addsub1_s_net;
  assign a_b_3 = addsub2_s_net;
  assign a_b_4 = addsub3_s_net;
  assign a_b_5 = addsub4_s_net;
  assign a_b_6 = addsub5_s_net;
  assign a_b_7 = addsub6_s_net;
  assign a_b_8 = addsub7_s_net;
  assign delay0_q_net = a_1;
  assign reinterpret0_output_port_net = b_1;
  assign delay1_q_net = a_2;
  assign delay2_q_net = a_3;
  assign delay3_q_net = a_4;
  assign delay4_q_net = a_5;
  assign delay5_q_net = a_6;
  assign delay6_q_net = a_7;
  assign delay7_q_net = a_8;
  assign reinterpret1_output_port_net = b_2;
  assign reinterpret2_output_port_net = b_3;
  assign reinterpret3_output_port_net = b_4;
  assign reinterpret4_output_port_net = b_5;
  assign reinterpret5_output_port_net = b_6;
  assign reinterpret6_output_port_net = b_7;
  assign reinterpret7_output_port_net = b_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i5"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(0),
    .s_width(16)
  )
  addsub0 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay0_q_net),
    .b(reinterpret0_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub0_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i5"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(0),
    .s_width(16)
  )
  addsub1 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay1_q_net),
    .b(reinterpret1_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i5"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(0),
    .s_width(16)
  )
  addsub2 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay2_q_net),
    .b(reinterpret2_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub2_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i5"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(0),
    .s_width(16)
  )
  addsub3 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay3_q_net),
    .b(reinterpret3_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i5"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(0),
    .s_width(16)
  )
  addsub4 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay4_q_net),
    .b(reinterpret4_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub4_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i5"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(0),
    .s_width(16)
  )
  addsub5 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay5_q_net),
    .b(reinterpret5_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub5_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i5"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(0),
    .s_width(16)
  )
  addsub6 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay6_q_net),
    .b(reinterpret6_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub6_s_net)
  );
  dsp_blr_7_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dsp_blr_7_c_addsub_v12_0_i5"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(0),
    .s_width(16)
  )
  addsub7 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay7_q_net),
    .b(reinterpret7_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub7_s_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/Vector Reinterpret
module dsp_blr_7_vector_reinterpret_x0 (
  input [16-1:0] in_1,
  input [16-1:0] in_2,
  input [16-1:0] in_3,
  input [16-1:0] in_4,
  input [16-1:0] in_5,
  input [16-1:0] in_6,
  input [16-1:0] in_7,
  input [16-1:0] in_8,
  output [16-1:0] out_1,
  output [16-1:0] out_2,
  output [16-1:0] out_3,
  output [16-1:0] out_4,
  output [16-1:0] out_5,
  output [16-1:0] out_6,
  output [16-1:0] out_7,
  output [16-1:0] out_8
);
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  assign out_1 = reinterpret0_output_port_net;
  assign out_2 = reinterpret1_output_port_net;
  assign out_3 = reinterpret2_output_port_net;
  assign out_4 = reinterpret3_output_port_net;
  assign out_5 = reinterpret4_output_port_net;
  assign out_6 = reinterpret5_output_port_net;
  assign out_7 = reinterpret6_output_port_net;
  assign out_8 = reinterpret7_output_port_net;
  assign slice0_y_net = in_1;
  assign slice1_y_net = in_2;
  assign slice2_y_net = in_3;
  assign slice3_y_net = in_4;
  assign slice4_y_net = in_5;
  assign slice5_y_net = in_6;
  assign slice6_y_net = in_7;
  assign slice7_y_net = in_8;
  sysgen_reinterpret_84ad9a0c4c reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice0_y_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_84ad9a0c4c reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/Vector Reinterpret2
module dsp_blr_7_vector_reinterpret2 (
  input [16-1:0] in_1,
  input [16-1:0] in_2,
  input [16-1:0] in_3,
  input [16-1:0] in_4,
  input [16-1:0] in_5,
  input [16-1:0] in_6,
  input [16-1:0] in_7,
  input [16-1:0] in_8,
  output [16-1:0] out_1,
  output [16-1:0] out_2,
  output [16-1:0] out_3,
  output [16-1:0] out_4,
  output [16-1:0] out_5,
  output [16-1:0] out_6,
  output [16-1:0] out_7,
  output [16-1:0] out_8
);
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net_x0;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  assign out_1 = reinterpret0_output_port_net_x0;
  assign out_2 = reinterpret1_output_port_net_x0;
  assign out_3 = reinterpret2_output_port_net_x0;
  assign out_4 = reinterpret3_output_port_net_x0;
  assign out_5 = reinterpret4_output_port_net_x0;
  assign out_6 = reinterpret5_output_port_net_x0;
  assign out_7 = reinterpret6_output_port_net_x0;
  assign out_8 = reinterpret7_output_port_net_x0;
  assign reinterpret0_output_port_net = in_1;
  assign reinterpret1_output_port_net = in_2;
  assign reinterpret2_output_port_net = in_3;
  assign reinterpret3_output_port_net = in_4;
  assign reinterpret4_output_port_net = in_5;
  assign reinterpret5_output_port_net = in_6;
  assign reinterpret6_output_port_net = in_7;
  assign reinterpret7_output_port_net = in_8;
  sysgen_reinterpret_a71497b768 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret0_output_port_net),
    .output_port(reinterpret0_output_port_net_x0)
  );
  sysgen_reinterpret_a71497b768 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret1_output_port_net),
    .output_port(reinterpret1_output_port_net_x0)
  );
  sysgen_reinterpret_a71497b768 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret2_output_port_net),
    .output_port(reinterpret2_output_port_net_x0)
  );
  sysgen_reinterpret_a71497b768 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret3_output_port_net),
    .output_port(reinterpret3_output_port_net_x0)
  );
  sysgen_reinterpret_a71497b768 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret4_output_port_net),
    .output_port(reinterpret4_output_port_net_x0)
  );
  sysgen_reinterpret_a71497b768 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret5_output_port_net),
    .output_port(reinterpret5_output_port_net_x0)
  );
  sysgen_reinterpret_a71497b768 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret6_output_port_net),
    .output_port(reinterpret6_output_port_net_x0)
  );
  sysgen_reinterpret_a71497b768 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret7_output_port_net),
    .output_port(reinterpret7_output_port_net_x0)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7/Vector2Scalar1
module dsp_blr_7_vector2scalar1 (
  input [16-1:0] i_1,
  input [16-1:0] i_2,
  input [16-1:0] i_3,
  input [16-1:0] i_4,
  input [16-1:0] i_5,
  input [16-1:0] i_6,
  input [16-1:0] i_7,
  input [16-1:0] i_8,
  output [128-1:0] o
);
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  assign o = concat1_y_net;
  assign reinterpret0_output_port_net = i_1;
  assign reinterpret1_output_port_net = i_2;
  assign reinterpret2_output_port_net = i_3;
  assign reinterpret3_output_port_net = i_4;
  assign reinterpret4_output_port_net = i_5;
  assign reinterpret5_output_port_net = i_6;
  assign reinterpret6_output_port_net = i_7;
  assign reinterpret7_output_port_net = i_8;
  sysgen_concat_32ac66d15d concat1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .in0(reinterpret7_output_port_net),
    .in1(reinterpret6_output_port_net),
    .in2(reinterpret5_output_port_net),
    .in3(reinterpret4_output_port_net),
    .in4(reinterpret3_output_port_net),
    .in5(reinterpret2_output_port_net),
    .in6(reinterpret1_output_port_net),
    .in7(reinterpret0_output_port_net),
    .y(concat1_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_7_struct
module dsp_blr_7_struct (
  input [128-1:0] h_s_axis_tdata,
  input [1-1:0] h_s_axis_tvalid,
  input [32-1:0] l_s_axis_tdata,
  input [1-1:0] l_s_axis_tvalid,
  input clk_1,
  input ce_1,
  output [128-1:0] dsp_m_axis_tdata,
  output [1-1:0] dsp_m_axis_tvalid,
  output [128-1:0] h_m_axis_tdata,
  output [1-1:0] h_m_axis_tvalid,
  output [32-1:0] l_m_axis_tdata,
  output [1-1:0] l_m_axis_tvalid
);
  wire [32-1:0] l_s_axis_tdata_net;
  wire ce_net;
  wire [17-1:0] shift7_op_net;
  wire [17-1:0] addsub15_s_net;
  wire [1-1:0] h_s_axis_tvalid_net;
  wire [128-1:0] concat1_y_net;
  wire [1-1:0] delay_q_net;
  wire [128-1:0] concat1_y_net_x1;
  wire [128-1:0] concat1_y_net_x0;
  wire [128-1:0] h_s_axis_tdata_net;
  wire [32-1:0] l_gain_tdata_delay_q_net;
  wire [1-1:0] l_gain_tvalid_delay_q_net;
  wire clk_net;
  wire [1-1:0] l_s_axis_tvalid_net;
  wire [16-1:0] reinterpret7_output_port_net_x1;
  wire [16-1:0] addsub2_s_net;
  wire [16-1:0] reinterpret0_output_port_net_x1;
  wire [16-1:0] addsub3_s_net;
  wire [16-1:0] reinterpret3_output_port_net_x1;
  wire [16-1:0] reinterpret1_output_port_net_x1;
  wire [16-1:0] reinterpret2_output_port_net_x1;
  wire [16-1:0] reinterpret4_output_port_net_x1;
  wire [16-1:0] reinterpret5_output_port_net_x1;
  wire [16-1:0] dout_net;
  wire [16-1:0] addsub0_s_net;
  wire [16-1:0] addsub1_s_net;
  wire [16-1:0] reinterpret6_output_port_net_x1;
  wire [16-1:0] addsub4_s_net;
  wire [16-1:0] addsub7_s_net;
  wire [16-1:0] delay4_q_net_x0;
  wire [16-1:0] delay5_q_net_x0;
  wire [16-1:0] delay6_q_net_x0;
  wire [16-1:0] delay7_q_net_x0;
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] delay2_q_net_x0;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] addsub5_s_net;
  wire [16-1:0] addsub6_s_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay3_q_net_x0;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net_x0;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay1_q_net_x0;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] delay0_q_net_x0;
  assign dsp_m_axis_tdata = concat1_y_net_x0;
  assign dsp_m_axis_tvalid = delay_q_net;
  assign h_m_axis_tdata = concat1_y_net_x1;
  assign h_m_axis_tvalid = delay_q_net;
  assign h_s_axis_tdata_net = h_s_axis_tdata;
  assign h_s_axis_tvalid_net = h_s_axis_tvalid;
  assign l_m_axis_tdata = l_gain_tdata_delay_q_net;
  assign l_m_axis_tvalid = l_gain_tvalid_delay_q_net;
  assign l_s_axis_tdata_net = l_s_axis_tdata;
  assign l_s_axis_tvalid_net = l_s_axis_tvalid;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_7_cut cut (
    .in1(addsub15_s_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .out1(shift7_op_net)
  );
  dsp_blr_7_ave7 ave7 (
    .tdata_in(concat1_y_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .sum_data_out(addsub15_s_net)
  );
  dsp_blr_7_dbl_scalar2vector1 dbl_scalar2vector1 (
    .in1(dout_net),
    .out1_1(reinterpret0_output_port_net_x1),
    .out1_2(reinterpret1_output_port_net_x1),
    .out1_3(reinterpret2_output_port_net_x1),
    .out1_4(reinterpret3_output_port_net_x1),
    .out1_5(reinterpret4_output_port_net_x1),
    .out1_6(reinterpret5_output_port_net_x1),
    .out1_7(reinterpret6_output_port_net_x1),
    .out1_8(reinterpret7_output_port_net_x1)
  );
  dsp_blr_7_dsp_vector2scalar dsp_vector2scalar (
    .in1_1(addsub0_s_net),
    .in1_2(addsub1_s_net),
    .in1_3(addsub2_s_net),
    .in1_4(addsub3_s_net),
    .in1_5(addsub4_s_net),
    .in1_6(addsub5_s_net),
    .in1_7(addsub6_s_net),
    .in1_8(addsub7_s_net),
    .out1(concat1_y_net_x0)
  );
  dsp_blr_7_dsp_delay dsp_delay (
    .d_1(reinterpret0_output_port_net_x0),
    .d_2(reinterpret1_output_port_net_x0),
    .d_3(reinterpret2_output_port_net_x0),
    .d_4(reinterpret3_output_port_net_x0),
    .d_5(reinterpret4_output_port_net_x0),
    .d_6(reinterpret5_output_port_net_x0),
    .d_7(reinterpret6_output_port_net_x0),
    .d_8(reinterpret7_output_port_net_x0),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .q_1(delay0_q_net),
    .q_2(delay1_q_net),
    .q_3(delay2_q_net_x0),
    .q_4(delay3_q_net_x0),
    .q_5(delay4_q_net_x0),
    .q_6(delay5_q_net_x0),
    .q_7(delay6_q_net_x0),
    .q_8(delay7_q_net_x0)
  );
  dsp_blr_7_hgain_vector2scalar hgain_vector2scalar (
    .in1_1(delay0_q_net_x0),
    .in1_2(delay1_q_net_x0),
    .in1_3(delay2_q_net),
    .in1_4(delay3_q_net),
    .in1_5(delay4_q_net),
    .in1_6(delay5_q_net),
    .in1_7(delay6_q_net),
    .in1_8(delay7_q_net),
    .out1(concat1_y_net_x1)
  );
  dsp_blr_7_hgain_delay hgain_delay (
    .d_1(delay0_q_net),
    .d_2(delay1_q_net),
    .d_3(delay2_q_net_x0),
    .d_4(delay3_q_net_x0),
    .d_5(delay4_q_net_x0),
    .d_6(delay5_q_net_x0),
    .d_7(delay6_q_net_x0),
    .d_8(delay7_q_net_x0),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .q_1(delay0_q_net_x0),
    .q_2(delay1_q_net_x0),
    .q_3(delay2_q_net),
    .q_4(delay3_q_net),
    .q_5(delay4_q_net),
    .q_6(delay5_q_net),
    .q_7(delay6_q_net),
    .q_8(delay7_q_net)
  );
  dsp_blr_7_scalar2vector_x0 scalar2vector (
    .i(h_s_axis_tdata_net),
    .o_1(slice0_y_net),
    .o_2(slice1_y_net),
    .o_3(slice2_y_net),
    .o_4(slice3_y_net),
    .o_5(slice4_y_net),
    .o_6(slice5_y_net),
    .o_7(slice6_y_net),
    .o_8(slice7_y_net)
  );
  dsp_blr_7_vector_addsub_fabric2 vector_addsub_fabric2 (
    .a_1(delay0_q_net),
    .b_1(reinterpret0_output_port_net_x1),
    .a_2(delay1_q_net),
    .a_3(delay2_q_net_x0),
    .a_4(delay3_q_net_x0),
    .a_5(delay4_q_net_x0),
    .a_6(delay5_q_net_x0),
    .a_7(delay6_q_net_x0),
    .a_8(delay7_q_net_x0),
    .b_2(reinterpret1_output_port_net_x1),
    .b_3(reinterpret2_output_port_net_x1),
    .b_4(reinterpret3_output_port_net_x1),
    .b_5(reinterpret4_output_port_net_x1),
    .b_6(reinterpret5_output_port_net_x1),
    .b_7(reinterpret6_output_port_net_x1),
    .b_8(reinterpret7_output_port_net_x1),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .a_b_1(addsub0_s_net),
    .a_b_2(addsub1_s_net),
    .a_b_3(addsub2_s_net),
    .a_b_4(addsub3_s_net),
    .a_b_5(addsub4_s_net),
    .a_b_6(addsub5_s_net),
    .a_b_7(addsub6_s_net),
    .a_b_8(addsub7_s_net)
  );
  dsp_blr_7_vector_reinterpret_x0 vector_reinterpret (
    .in_1(slice0_y_net),
    .in_2(slice1_y_net),
    .in_3(slice2_y_net),
    .in_4(slice3_y_net),
    .in_5(slice4_y_net),
    .in_6(slice5_y_net),
    .in_7(slice6_y_net),
    .in_8(slice7_y_net),
    .out_1(reinterpret0_output_port_net_x0),
    .out_2(reinterpret1_output_port_net_x0),
    .out_3(reinterpret2_output_port_net_x0),
    .out_4(reinterpret3_output_port_net_x0),
    .out_5(reinterpret4_output_port_net_x0),
    .out_6(reinterpret5_output_port_net_x0),
    .out_7(reinterpret6_output_port_net_x0),
    .out_8(reinterpret7_output_port_net_x0)
  );
  dsp_blr_7_vector_reinterpret2 vector_reinterpret2 (
    .in_1(reinterpret0_output_port_net_x0),
    .in_2(reinterpret1_output_port_net_x0),
    .in_3(reinterpret2_output_port_net_x0),
    .in_4(reinterpret3_output_port_net_x0),
    .in_5(reinterpret4_output_port_net_x0),
    .in_6(reinterpret5_output_port_net_x0),
    .in_7(reinterpret6_output_port_net_x0),
    .in_8(reinterpret7_output_port_net_x0),
    .out_1(reinterpret0_output_port_net),
    .out_2(reinterpret1_output_port_net),
    .out_3(reinterpret2_output_port_net),
    .out_4(reinterpret3_output_port_net),
    .out_5(reinterpret4_output_port_net),
    .out_6(reinterpret5_output_port_net),
    .out_7(reinterpret6_output_port_net),
    .out_8(reinterpret7_output_port_net)
  );
  dsp_blr_7_vector2scalar1 vector2scalar1 (
    .i_1(reinterpret0_output_port_net),
    .i_2(reinterpret1_output_port_net),
    .i_3(reinterpret2_output_port_net),
    .i_4(reinterpret3_output_port_net),
    .i_5(reinterpret4_output_port_net),
    .i_6(reinterpret5_output_port_net),
    .i_7(reinterpret6_output_port_net),
    .i_8(reinterpret7_output_port_net),
    .o(concat1_y_net)
  );
  dsp_blr_7_xlconvert #(
    .bool_conversion(0),
    .din_arith(2),
    .din_bin_pt(4),
    .din_width(17),
    .dout_arith(2),
    .dout_bin_pt(4),
    .dout_width(16),
    .latency(1),
    .overflow(`xlSaturate),
    .quantization(`xlTruncate)
  )
  x (
    .clr(1'b0),
    .en(1'b1),
    .din(shift7_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .dout(dout_net)
  );
  dsp_blr_7_xldelay #(
    .latency(7),
    .reg_retiming(0),
    .reset(0),
    .width(1)
  )
  delay (
    .en(1'b1),
    .rst(1'b0),
    .d(h_s_axis_tvalid_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay_q_net)
  );
  sysgen_delay_5892d9ba68 l_gain_tdata_delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(l_s_axis_tdata_net),
    .q(l_gain_tdata_delay_q_net)
  );
  sysgen_delay_633c56551a l_gain_tvalid_delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(l_s_axis_tvalid_net),
    .q(l_gain_tvalid_delay_q_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
module dsp_blr_7_default_clock_driver (
  input dsp_blr_7_sysclk,
  input dsp_blr_7_sysce,
  input dsp_blr_7_sysclr,
  output dsp_blr_7_clk1,
  output dsp_blr_7_ce1
);
  xlclockdriver #(
    .period(1),
    .log_2_period(1)
  )
  clockdriver (
    .sysclk(dsp_blr_7_sysclk),
    .sysce(dsp_blr_7_sysce),
    .sysclr(dsp_blr_7_sysclr),
    .clk(dsp_blr_7_clk1),
    .ce(dsp_blr_7_ce1)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
(* core_generation_info = "dsp_blr_7,sysgen_core_2019_1,{,compilation=IP Catalog,block_icon_display=Default,family=zynquplusRFSOC,part=xczu29dr,speed=-1-e,package=ffvf1760,synthesis_language=verilog,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=1,interface_doc=1,ce_clr=0,clock_period=8,system_simulink_period=8e-09,waveform_viewer=1,axilite_interface=0,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=0.0001,addsub=21,concat=4,convert=1,delay=30,mult=1,reinterpret=45,sgn=1,shift=5,slice=20,}" *)
module dsp_blr_7 (
  input [128-1:0] h_s_axis_tdata,
  input [1-1:0] h_s_axis_tvalid,
  input [32-1:0] l_s_axis_tdata,
  input [1-1:0] l_s_axis_tvalid,
  input clk,
  output [128-1:0] dsp_m_axis_tdata,
  output [1-1:0] dsp_m_axis_tvalid,
  output [128-1:0] h_m_axis_tdata,
  output [1-1:0] h_m_axis_tvalid,
  output [32-1:0] l_m_axis_tdata,
  output [1-1:0] l_m_axis_tvalid
);
  wire clk_1_net;
  wire ce_1_net;
  dsp_blr_7_default_clock_driver dsp_blr_7_default_clock_driver (
    .dsp_blr_7_sysclk(clk),
    .dsp_blr_7_sysce(1'b1),
    .dsp_blr_7_sysclr(1'b0),
    .dsp_blr_7_clk1(clk_1_net),
    .dsp_blr_7_ce1(ce_1_net)
  );
  dsp_blr_7_struct dsp_blr_7_struct (
    .h_s_axis_tdata(h_s_axis_tdata),
    .h_s_axis_tvalid(h_s_axis_tvalid),
    .l_s_axis_tdata(l_s_axis_tdata),
    .l_s_axis_tvalid(l_s_axis_tvalid),
    .clk_1(clk_1_net),
    .ce_1(ce_1_net),
    .dsp_m_axis_tdata(dsp_m_axis_tdata),
    .dsp_m_axis_tvalid(dsp_m_axis_tvalid),
    .h_m_axis_tdata(h_m_axis_tdata),
    .h_m_axis_tvalid(h_m_axis_tvalid),
    .l_m_axis_tdata(l_m_axis_tdata),
    .l_m_axis_tvalid(l_m_axis_tvalid)
  );
endmodule
