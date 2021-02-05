`ifndef xlConvPkgIncluded
`include "conv_pkg.v"
`endif

`timescale 1 ns / 10 ps
// Generated from Simulink block +cut
module dspblr8_ave_cut (
  input [17-1:0] in1,
  input clk_1,
  input ce_1,
  output [17-1:0] out1
);
  wire clk_net;
  wire [17-1:0] delay2_q_net;
  wire [19-1:0] p_e_n_p_net;
  wire [17-1:0] addsub7_s_net;
  wire [17-1:0] delay3_q_net;
  wire [17-1:0] shift7_op_net;
  wire ce_net;
  wire [17-1:0] addsub14_s_net;
  wire [2-1:0] threshold_y_net;
  assign out1 = shift7_op_net;
  assign addsub14_s_net = in1;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i0"),
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
  dspblr8_ave_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(17)
  )
  delay2 (
    .en(1'b1),
    .rst(1'b0),
    .d(addsub14_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay2_q_net)
  );
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xlmult #(
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
    .core_name0("dspblr8_ave_mult_gen_v12_0_i0"),
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
  sysgen_shift_c335537401 shift7 (
    .clr(1'b0),
    .ip(addsub7_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift7_op_net)
  );
  sysgen_sgn_98f73fb3ff threshold (
    .clr(1'b0),
    .x(addsub14_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .y(threshold_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block Ave8
module dspblr8_ave_ave8 (
  input [128-1:0] tdata_in,
  input clk_1,
  input ce_1,
  output [17-1:0] sum_data_out
);
  wire [17-1:0] addsub2_s_net;
  wire [16-1:0] delay5_q_net;
  wire [17-1:0] addsub13_s_net;
  wire [18-1:0] addsub4_s_net;
  wire [16-1:0] delay14_q_net;
  wire [17-1:0] addsub12_s_net;
  wire [17-1:0] addsub11_s_net;
  wire [16-1:0] delay11_q_net;
  wire [17-1:0] addsub9_s_net;
  wire [16-1:0] shift3_op_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay2_q_net;
  wire [17-1:0] addsub8_s_net;
  wire [19-1:0] addsub6_s_net;
  wire [17-1:0] addsub7_s_net;
  wire [18-1:0] addsub5_s_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay9_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay10_q_net;
  wire [16-1:0] delay8_q_net;
  wire [16-1:0] delay1_q_net;
  wire ce_net;
  wire [128-1:0] concat1_y_net;
  wire [17-1:0] addsub1_s_net;
  wire [17-1:0] addsub_s_net;
  wire [17-1:0] addsub3_s_net;
  wire [16-1:0] delay12_q_net;
  wire [17-1:0] addsub14_s_net;
  wire [17-1:0] addsub10_s_net;
  wire [16-1:0] shift7_op_net;
  wire [16-1:0] delay13_q_net;
  wire clk_net;
  wire [16-1:0] slice_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] reinterpret_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  assign sum_data_out = addsub14_s_net;
  assign concat1_y_net = tdata_in;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i1"),
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
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i2"),
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
    .b(addsub3_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i1"),
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
  addsub10 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay12_q_net),
    .b(delay13_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub10_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i1"),
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
  addsub11 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay14_q_net),
    .b(delay11_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub11_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i2"),
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
    .b(addsub9_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub12_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i2"),
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
    .a(addsub10_s_net),
    .b(addsub11_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub13_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i3"),
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
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i1"),
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
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i1"),
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
    .a(delay2_q_net),
    .b(delay5_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i2"),
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
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i2"),
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
    .b(addsub7_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub5_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(19),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i4"),
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
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i1"),
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
  addsub7 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay4_q_net),
    .b(delay6_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub7_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i1"),
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
    .a(delay7_q_net),
    .b(delay8_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub8_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i1"),
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
  addsub9 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay9_q_net),
    .b(delay10_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub9_s_net)
  );
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
    .latency(7),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay10 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift7_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay10_q_net)
  );
  dspblr8_ave_xldelay #(
    .latency(7),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay11 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift3_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay11_q_net)
  );
  dspblr8_ave_xldelay #(
    .latency(4),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay12 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift3_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay12_q_net)
  );
  dspblr8_ave_xldelay #(
    .latency(5),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay13 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift3_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay13_q_net)
  );
  dspblr8_ave_xldelay #(
    .latency(6),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay14 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift3_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay14_q_net)
  );
  dspblr8_ave_xldelay #(
    .latency(2),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay2 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift7_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay2_q_net)
  );
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
    .latency(2),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay4 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift3_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay4_q_net)
  );
  dspblr8_ave_xldelay #(
    .latency(3),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay5 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift7_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay5_q_net)
  );
  dspblr8_ave_xldelay #(
    .latency(3),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay6 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift3_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay6_q_net)
  );
  dspblr8_ave_xldelay #(
    .latency(4),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay7 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift7_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay7_q_net)
  );
  dspblr8_ave_xldelay #(
    .latency(5),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay8 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift7_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay8_q_net)
  );
  dspblr8_ave_xldelay #(
    .latency(6),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay9 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift7_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay9_q_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice_y_net),
    .output_port(reinterpret_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_shift_818c262155 shift3 (
    .clr(1'b0),
    .ip(reinterpret4_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift3_op_net)
  );
  sysgen_shift_818c262155 shift7 (
    .clr(1'b0),
    .ip(reinterpret_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift7_op_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice (
    .x(concat1_y_net),
    .y(slice_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(concat1_y_net),
    .y(slice4_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block Scalar2Vector
module dspblr8_ave_scalar2vector (
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
  wire [16-1:0] slice7_y_net;
  wire [128-1:0] concat_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice6_y_net;
  assign o_1 = slice0_y_net;
  assign o_2 = slice1_y_net;
  assign o_3 = slice2_y_net;
  assign o_4 = slice3_y_net;
  assign o_5 = slice4_y_net;
  assign o_6 = slice5_y_net;
  assign o_7 = slice6_y_net;
  assign o_8 = slice7_y_net;
  assign concat_y_net = i;
  dspblr8_ave_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice0 (
    .x(concat_y_net),
    .y(slice0_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(concat_y_net),
    .y(slice1_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(concat_y_net),
    .y(slice2_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(concat_y_net),
    .y(slice3_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(concat_y_net),
    .y(slice4_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(concat_y_net),
    .y(slice5_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(concat_y_net),
    .y(slice6_y_net)
  );
  dspblr8_ave_xlslice #(
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
// Generated from Simulink block Vector Reinterpret
module dspblr8_ave_vector_reinterpret (
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
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
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
  sysgen_reinterpret_a1f4638ac2 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice0_y_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block DBL_Scalar2Vector1
module dspblr8_ave_dbl_scalar2vector1 (
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
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] dout_net;
  wire [128-1:0] concat_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] slice4_y_net;
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
  dspblr8_ave_scalar2vector scalar2vector (
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
  dspblr8_ave_vector_reinterpret vector_reinterpret (
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
  sysgen_concat_8bb1910f6e concat (
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
  sysgen_reinterpret_e4abc0f7d2 reinterpret (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(dout_net),
    .output_port(reinterpret_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block Scalar2Vector
module dspblr8_ave_scalar2vector_x0 (
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
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice5_y_net;
  wire [128-1:0] concat_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice7_y_net;
  assign o_1 = slice0_y_net;
  assign o_2 = slice1_y_net;
  assign o_3 = slice2_y_net;
  assign o_4 = slice3_y_net;
  assign o_5 = slice4_y_net;
  assign o_6 = slice5_y_net;
  assign o_7 = slice6_y_net;
  assign o_8 = slice7_y_net;
  assign concat_y_net = i;
  dspblr8_ave_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice0 (
    .x(concat_y_net),
    .y(slice0_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(concat_y_net),
    .y(slice1_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(concat_y_net),
    .y(slice2_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(concat_y_net),
    .y(slice3_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(concat_y_net),
    .y(slice4_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(concat_y_net),
    .y(slice5_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(concat_y_net),
    .y(slice6_y_net)
  );
  dspblr8_ave_xlslice #(
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
// Generated from Simulink block Vector Reinterpret
module dspblr8_ave_vector_reinterpret_x0 (
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
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice6_y_net;
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
  sysgen_reinterpret_a1f4638ac2 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice0_y_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block DBL_Scalar2Vector2
module dspblr8_ave_dbl_scalar2vector2 (
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
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] constant_op_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] reinterpret_output_port_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice3_y_net;
  wire [128-1:0] concat_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice5_y_net;
  assign out1_1 = reinterpret0_output_port_net;
  assign out1_2 = reinterpret1_output_port_net;
  assign out1_3 = reinterpret2_output_port_net;
  assign out1_4 = reinterpret3_output_port_net;
  assign out1_5 = reinterpret4_output_port_net;
  assign out1_6 = reinterpret5_output_port_net;
  assign out1_7 = reinterpret6_output_port_net;
  assign out1_8 = reinterpret7_output_port_net;
  assign constant_op_net = in1;
  dspblr8_ave_scalar2vector_x0 scalar2vector (
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
  dspblr8_ave_vector_reinterpret_x0 vector_reinterpret (
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
  sysgen_concat_8bb1910f6e concat (
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
  sysgen_reinterpret_e4abc0f7d2 reinterpret (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(constant_op_net),
    .output_port(reinterpret_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block Vector2Scalar
module dspblr8_ave_vector2scalar (
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
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [128-1:0] concat1_y_net;
  assign o = concat1_y_net;
  assign reinterpret0_output_port_net = i_1;
  assign reinterpret1_output_port_net = i_2;
  assign reinterpret2_output_port_net = i_3;
  assign reinterpret3_output_port_net = i_4;
  assign reinterpret4_output_port_net = i_5;
  assign reinterpret5_output_port_net = i_6;
  assign reinterpret6_output_port_net = i_7;
  assign reinterpret7_output_port_net = i_8;
  sysgen_concat_8bb1910f6e concat1 (
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
// Generated from Simulink block Vector_reinterpret2unsigned
module dspblr8_ave_vector_reinterpret2unsigned (
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
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] addsub6_s_net;
  wire [16-1:0] addsub7_s_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] addsub1_s_net;
  wire [16-1:0] addsub2_s_net;
  wire [16-1:0] addsub3_s_net;
  wire [16-1:0] addsub0_s_net;
  wire [16-1:0] addsub5_s_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] addsub4_s_net;
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
  sysgen_reinterpret_e4abc0f7d2 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub0_s_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub1_s_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub2_s_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub3_s_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub4_s_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub5_s_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub6_s_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub7_s_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block DSP_Vector2Scalar
module dspblr8_ave_dsp_vector2scalar (
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
  wire [16-1:0] addsub4_s_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] addsub3_s_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] addsub1_s_net;
  wire [16-1:0] addsub5_s_net;
  wire [16-1:0] addsub2_s_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] addsub7_s_net;
  wire [16-1:0] addsub6_s_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] addsub0_s_net;
  wire [16-1:0] reinterpret3_output_port_net;
  assign out1 = concat1_y_net;
  assign addsub0_s_net = in1_1;
  assign addsub1_s_net = in1_2;
  assign addsub2_s_net = in1_3;
  assign addsub3_s_net = in1_4;
  assign addsub4_s_net = in1_5;
  assign addsub5_s_net = in1_6;
  assign addsub6_s_net = in1_7;
  assign addsub7_s_net = in1_8;
  dspblr8_ave_vector2scalar vector2scalar (
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
  dspblr8_ave_vector_reinterpret2unsigned vector_reinterpret2unsigned (
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
// Generated from Simulink block DSP_delay
module dspblr8_ave_dsp_delay (
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
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire clk_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay7_q_net;
  wire ce_net;
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
// Generated from Simulink block Vector2Scalar
module dspblr8_ave_vector2scalar_x0 (
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
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
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
  sysgen_concat_8bb1910f6e concat1 (
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
// Generated from Simulink block Vector_reinterpret2unsigned
module dspblr8_ave_vector_reinterpret2unsigned_x0 (
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
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] reinterpret5_output_port_net;
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
  sysgen_reinterpret_e4abc0f7d2 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay0_q_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay1_q_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay2_q_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay3_q_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay4_q_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay5_q_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay6_q_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay7_q_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block HGAIN_Vector2Scalar
module dspblr8_ave_hgain_vector2scalar (
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
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [128-1:0] concat1_y_net;
  assign out1 = concat1_y_net;
  assign delay0_q_net = in1_1;
  assign delay1_q_net = in1_2;
  assign delay2_q_net = in1_3;
  assign delay3_q_net = in1_4;
  assign delay4_q_net = in1_5;
  assign delay5_q_net = in1_6;
  assign delay6_q_net = in1_7;
  assign delay7_q_net = in1_8;
  dspblr8_ave_vector2scalar_x0 vector2scalar (
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
  dspblr8_ave_vector_reinterpret2unsigned_x0 vector_reinterpret2unsigned (
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
// Generated from Simulink block HGAIN_delay
module dspblr8_ave_hgain_delay (
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
  wire [16-1:0] delay3_q_net;
  wire ce_net;
  wire [16-1:0] delay2_q_net_x0;
  wire [16-1:0] delay5_q_net_x0;
  wire [16-1:0] delay6_q_net_x0;
  wire [16-1:0] delay4_q_net_x0;
  wire clk_net;
  wire [16-1:0] delay7_q_net_x0;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay3_q_net_x0;
  wire [16-1:0] delay1_q_net_x0;
  wire [16-1:0] delay7_q_net;
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
  dspblr8_ave_xldelay #(
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
// Generated from Simulink block Scalar2Vector
module dspblr8_ave_scalar2vector_x1 (
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
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice3_y_net;
  wire [128-1:0] h_s_axis_tdata_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice0_y_net;
  assign o_1 = slice0_y_net;
  assign o_2 = slice1_y_net;
  assign o_3 = slice2_y_net;
  assign o_4 = slice3_y_net;
  assign o_5 = slice4_y_net;
  assign o_6 = slice5_y_net;
  assign o_7 = slice6_y_net;
  assign o_8 = slice7_y_net;
  assign h_s_axis_tdata_net = i;
  dspblr8_ave_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice0 (
    .x(h_s_axis_tdata_net),
    .y(slice0_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(h_s_axis_tdata_net),
    .y(slice1_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(h_s_axis_tdata_net),
    .y(slice2_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(h_s_axis_tdata_net),
    .y(slice3_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(h_s_axis_tdata_net),
    .y(slice4_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(h_s_axis_tdata_net),
    .y(slice5_y_net)
  );
  dspblr8_ave_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(h_s_axis_tdata_net),
    .y(slice6_y_net)
  );
  dspblr8_ave_xlslice #(
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
// Generated from Simulink block Vector AddSub Fabric2
module dspblr8_ave_vector_addsub_fabric2 (
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
  wire [16-1:0] addsub0_s_net;
  wire [16-1:0] addsub2_s_net;
  wire [16-1:0] addsub3_s_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] addsub4_s_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire clk_net;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  wire ce_net;
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net_x0;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] addsub7_s_net;
  wire [16-1:0] addsub5_s_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] addsub6_s_net;
  wire [16-1:0] reinterpret6_output_port_net;
  assign a_b_1 = addsub0_s_net;
  assign a_b_2 = addsub1_s_net;
  assign a_b_3 = addsub2_s_net;
  assign a_b_4 = addsub3_s_net;
  assign a_b_5 = addsub4_s_net;
  assign a_b_6 = addsub5_s_net;
  assign a_b_7 = addsub6_s_net;
  assign a_b_8 = addsub7_s_net;
  assign reinterpret0_output_port_net_x0 = a_1;
  assign reinterpret0_output_port_net = b_1;
  assign reinterpret1_output_port_net_x0 = a_2;
  assign reinterpret2_output_port_net_x0 = a_3;
  assign reinterpret3_output_port_net_x0 = a_4;
  assign reinterpret4_output_port_net_x0 = a_5;
  assign reinterpret5_output_port_net_x0 = a_6;
  assign reinterpret6_output_port_net_x0 = a_7;
  assign reinterpret7_output_port_net_x0 = a_8;
  assign reinterpret1_output_port_net = b_2;
  assign reinterpret2_output_port_net = b_3;
  assign reinterpret3_output_port_net = b_4;
  assign reinterpret4_output_port_net = b_5;
  assign reinterpret5_output_port_net = b_6;
  assign reinterpret6_output_port_net = b_7;
  assign reinterpret7_output_port_net = b_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i5"),
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
    .a(reinterpret0_output_port_net_x0),
    .b(reinterpret0_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub0_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i5"),
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
    .a(reinterpret1_output_port_net_x0),
    .b(reinterpret1_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i5"),
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
    .a(reinterpret2_output_port_net_x0),
    .b(reinterpret2_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub2_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i5"),
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
    .a(reinterpret3_output_port_net_x0),
    .b(reinterpret3_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i5"),
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
    .a(reinterpret4_output_port_net_x0),
    .b(reinterpret4_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub4_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i5"),
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
    .a(reinterpret5_output_port_net_x0),
    .b(reinterpret5_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub5_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i5"),
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
    .a(reinterpret6_output_port_net_x0),
    .b(reinterpret6_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub6_s_net)
  );
  dspblr8_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("dspblr8_ave_c_addsub_v12_0_i5"),
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
    .a(reinterpret7_output_port_net_x0),
    .b(reinterpret7_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub7_s_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block Vector Reinterpret
module dspblr8_ave_vector_reinterpret_x1 (
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
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice6_y_net;
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
  sysgen_reinterpret_a1f4638ac2 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice0_y_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_a1f4638ac2 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block Vector Reinterpret2
module dspblr8_ave_vector_reinterpret2 (
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
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net_x0;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
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
  sysgen_reinterpret_e4abc0f7d2 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret0_output_port_net),
    .output_port(reinterpret0_output_port_net_x0)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret1_output_port_net),
    .output_port(reinterpret1_output_port_net_x0)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret2_output_port_net),
    .output_port(reinterpret2_output_port_net_x0)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret3_output_port_net),
    .output_port(reinterpret3_output_port_net_x0)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret4_output_port_net),
    .output_port(reinterpret4_output_port_net_x0)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret5_output_port_net),
    .output_port(reinterpret5_output_port_net_x0)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret6_output_port_net),
    .output_port(reinterpret6_output_port_net_x0)
  );
  sysgen_reinterpret_e4abc0f7d2 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret7_output_port_net),
    .output_port(reinterpret7_output_port_net_x0)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block Vector2Scalar1
module dspblr8_ave_vector2scalar1 (
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
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  assign o = concat1_y_net;
  assign reinterpret0_output_port_net = i_1;
  assign reinterpret1_output_port_net = i_2;
  assign reinterpret2_output_port_net = i_3;
  assign reinterpret3_output_port_net = i_4;
  assign reinterpret4_output_port_net = i_5;
  assign reinterpret5_output_port_net = i_6;
  assign reinterpret6_output_port_net = i_7;
  assign reinterpret7_output_port_net = i_8;
  sysgen_concat_8bb1910f6e concat1 (
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
// Generated from Simulink block dspblr8_Ave_struct
module dspblr8_ave_struct (
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
  wire [32-1:0] l_gain_tdata_delay_q_net;
  wire [17-1:0] addsub14_s_net;
  wire [128-1:0] concat1_y_net_x1;
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire ce_net;
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net_x0;
  wire [16-1:0] reinterpret2_output_port_net_x2;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [128-1:0] concat1_y_net;
  wire [1-1:0] l_gain_tvalid_delay_q_net;
  wire [32-1:0] l_s_axis_tdata_net;
  wire [1-1:0] l_s_axis_tvalid_net;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] reinterpret7_output_port_net_x1;
  wire [16-1:0] dout_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [128-1:0] h_s_axis_tdata_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [1-1:0] delay_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [128-1:0] concat1_y_net_x0;
  wire [1-1:0] h_s_axis_tvalid_net;
  wire clk_net;
  wire [17-1:0] shift7_op_net;
  wire [16-1:0] addsub0_s_net;
  wire [16-1:0] reinterpret5_output_port_net_x2;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [16-1:0] addsub3_s_net;
  wire [16-1:0] delay4_q_net_x0;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] addsub5_s_net;
  wire [16-1:0] delay3_q_net_x0;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] delay0_q_net_x0;
  wire [16-1:0] reinterpret6_output_port_net_x1;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] reinterpret0_output_port_net_x2;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret2_output_port_net_x1;
  wire [16-1:0] reinterpret1_output_port_net_x1;
  wire [16-1:0] reinterpret3_output_port_net_x1;
  wire [16-1:0] delay2_q_net_x0;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] delay6_q_net_x0;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] reinterpret4_output_port_net_x1;
  wire [16-1:0] reinterpret5_output_port_net_x1;
  wire [16-1:0] addsub7_s_net;
  wire [16-1:0] addsub4_s_net;
  wire [16-1:0] addsub6_s_net;
  wire [16-1:0] addsub1_s_net;
  wire [16-1:0] reinterpret1_output_port_net_x2;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay7_q_net_x0;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret7_output_port_net_x2;
  wire [16-1:0] reinterpret0_output_port_net_x1;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] reinterpret4_output_port_net_x2;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret3_output_port_net_x2;
  wire [16-1:0] addsub2_s_net;
  wire [16-1:0] delay5_q_net_x0;
  wire [16-1:0] constant_op_net;
  wire [16-1:0] delay1_q_net_x0;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net_x2;
  assign dsp_m_axis_tdata = concat1_y_net_x0;
  assign dsp_m_axis_tvalid = delay_q_net;
  assign h_m_axis_tdata = concat1_y_net;
  assign h_m_axis_tvalid = delay_q_net;
  assign h_s_axis_tdata_net = h_s_axis_tdata;
  assign h_s_axis_tvalid_net = h_s_axis_tvalid;
  assign l_m_axis_tdata = l_gain_tdata_delay_q_net;
  assign l_m_axis_tvalid = l_gain_tvalid_delay_q_net;
  assign l_s_axis_tdata_net = l_s_axis_tdata;
  assign l_s_axis_tvalid_net = l_s_axis_tvalid;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dspblr8_ave_cut cut (
    .in1(addsub14_s_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .out1(shift7_op_net)
  );
  dspblr8_ave_ave8 ave8 (
    .tdata_in(concat1_y_net_x1),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .sum_data_out(addsub14_s_net)
  );
  dspblr8_ave_dbl_scalar2vector1 dbl_scalar2vector1 (
    .in1(dout_net),
    .out1_1(reinterpret0_output_port_net_x0),
    .out1_2(reinterpret1_output_port_net_x0),
    .out1_3(reinterpret2_output_port_net_x2),
    .out1_4(reinterpret3_output_port_net_x0),
    .out1_5(reinterpret4_output_port_net_x0),
    .out1_6(reinterpret5_output_port_net_x0),
    .out1_7(reinterpret6_output_port_net_x0),
    .out1_8(reinterpret7_output_port_net_x1)
  );
  dspblr8_ave_dbl_scalar2vector2 dbl_scalar2vector2 (
    .in1(constant_op_net),
    .out1_1(reinterpret0_output_port_net),
    .out1_2(reinterpret1_output_port_net),
    .out1_3(reinterpret2_output_port_net),
    .out1_4(reinterpret3_output_port_net),
    .out1_5(reinterpret4_output_port_net),
    .out1_6(reinterpret5_output_port_net),
    .out1_7(reinterpret6_output_port_net),
    .out1_8(reinterpret7_output_port_net_x0)
  );
  dspblr8_ave_dsp_vector2scalar dsp_vector2scalar (
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
  dspblr8_ave_dsp_delay dsp_delay (
    .d_1(reinterpret0_output_port_net_x2),
    .d_2(reinterpret1_output_port_net_x2),
    .d_3(reinterpret2_output_port_net_x1),
    .d_4(reinterpret3_output_port_net_x2),
    .d_5(reinterpret4_output_port_net_x2),
    .d_6(reinterpret5_output_port_net_x2),
    .d_7(reinterpret6_output_port_net_x2),
    .d_8(reinterpret7_output_port_net_x2),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .q_1(delay0_q_net_x0),
    .q_2(delay1_q_net_x0),
    .q_3(delay2_q_net_x0),
    .q_4(delay3_q_net),
    .q_5(delay4_q_net_x0),
    .q_6(delay5_q_net_x0),
    .q_7(delay6_q_net_x0),
    .q_8(delay7_q_net_x0)
  );
  dspblr8_ave_hgain_vector2scalar hgain_vector2scalar (
    .in1_1(delay0_q_net),
    .in1_2(delay1_q_net),
    .in1_3(delay2_q_net),
    .in1_4(delay3_q_net_x0),
    .in1_5(delay4_q_net),
    .in1_6(delay5_q_net),
    .in1_7(delay6_q_net),
    .in1_8(delay7_q_net),
    .out1(concat1_y_net)
  );
  dspblr8_ave_hgain_delay hgain_delay (
    .d_1(delay0_q_net_x0),
    .d_2(delay1_q_net_x0),
    .d_3(delay2_q_net_x0),
    .d_4(delay3_q_net),
    .d_5(delay4_q_net_x0),
    .d_6(delay5_q_net_x0),
    .d_7(delay6_q_net_x0),
    .d_8(delay7_q_net_x0),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .q_1(delay0_q_net),
    .q_2(delay1_q_net),
    .q_3(delay2_q_net),
    .q_4(delay3_q_net_x0),
    .q_5(delay4_q_net),
    .q_6(delay5_q_net),
    .q_7(delay6_q_net),
    .q_8(delay7_q_net)
  );
  dspblr8_ave_scalar2vector_x1 scalar2vector (
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
  dspblr8_ave_vector_addsub_fabric2 vector_addsub_fabric2 (
    .a_1(reinterpret0_output_port_net_x0),
    .b_1(reinterpret0_output_port_net),
    .a_2(reinterpret1_output_port_net_x0),
    .a_3(reinterpret2_output_port_net_x2),
    .a_4(reinterpret3_output_port_net_x0),
    .a_5(reinterpret4_output_port_net_x0),
    .a_6(reinterpret5_output_port_net_x0),
    .a_7(reinterpret6_output_port_net_x0),
    .a_8(reinterpret7_output_port_net_x1),
    .b_2(reinterpret1_output_port_net),
    .b_3(reinterpret2_output_port_net),
    .b_4(reinterpret3_output_port_net),
    .b_5(reinterpret4_output_port_net),
    .b_6(reinterpret5_output_port_net),
    .b_7(reinterpret6_output_port_net),
    .b_8(reinterpret7_output_port_net_x0),
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
  dspblr8_ave_vector_reinterpret_x1 vector_reinterpret (
    .in_1(slice0_y_net),
    .in_2(slice1_y_net),
    .in_3(slice2_y_net),
    .in_4(slice3_y_net),
    .in_5(slice4_y_net),
    .in_6(slice5_y_net),
    .in_7(slice6_y_net),
    .in_8(slice7_y_net),
    .out_1(reinterpret0_output_port_net_x2),
    .out_2(reinterpret1_output_port_net_x2),
    .out_3(reinterpret2_output_port_net_x1),
    .out_4(reinterpret3_output_port_net_x2),
    .out_5(reinterpret4_output_port_net_x2),
    .out_6(reinterpret5_output_port_net_x2),
    .out_7(reinterpret6_output_port_net_x2),
    .out_8(reinterpret7_output_port_net_x2)
  );
  dspblr8_ave_vector_reinterpret2 vector_reinterpret2 (
    .in_1(reinterpret0_output_port_net_x2),
    .in_2(reinterpret1_output_port_net_x2),
    .in_3(reinterpret2_output_port_net_x1),
    .in_4(reinterpret3_output_port_net_x2),
    .in_5(reinterpret4_output_port_net_x2),
    .in_6(reinterpret5_output_port_net_x2),
    .in_7(reinterpret6_output_port_net_x2),
    .in_8(reinterpret7_output_port_net_x2),
    .out_1(reinterpret0_output_port_net_x1),
    .out_2(reinterpret1_output_port_net_x1),
    .out_3(reinterpret2_output_port_net_x0),
    .out_4(reinterpret3_output_port_net_x1),
    .out_5(reinterpret4_output_port_net_x1),
    .out_6(reinterpret5_output_port_net_x1),
    .out_7(reinterpret6_output_port_net_x1),
    .out_8(reinterpret7_output_port_net)
  );
  dspblr8_ave_vector2scalar1 vector2scalar1 (
    .i_1(reinterpret0_output_port_net_x1),
    .i_2(reinterpret1_output_port_net_x1),
    .i_3(reinterpret2_output_port_net_x0),
    .i_4(reinterpret3_output_port_net_x1),
    .i_5(reinterpret4_output_port_net_x1),
    .i_6(reinterpret5_output_port_net_x1),
    .i_7(reinterpret6_output_port_net_x1),
    .i_8(reinterpret7_output_port_net),
    .o(concat1_y_net_x1)
  );
  dspblr8_ave_xlconvert #(
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
  sysgen_constant_2f98157aa5 constant (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(constant_op_net)
  );
  dspblr8_ave_xldelay #(
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
  sysgen_delay_ee760f3870 l_gain_tdata_delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(l_s_axis_tdata_net),
    .q(l_gain_tdata_delay_q_net)
  );
  sysgen_delay_6cd8c0a2f1 l_gain_tvalid_delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(l_s_axis_tvalid_net),
    .q(l_gain_tvalid_delay_q_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
module dspblr8_ave_default_clock_driver (
  input dspblr8_ave_sysclk,
  input dspblr8_ave_sysce,
  input dspblr8_ave_sysclr,
  output dspblr8_ave_clk1,
  output dspblr8_ave_ce1
);
  xlclockdriver #(
    .period(1),
    .log_2_period(1)
  )
  clockdriver (
    .sysclk(dspblr8_ave_sysclk),
    .sysce(dspblr8_ave_sysce),
    .sysclr(dspblr8_ave_sysclr),
    .clk(dspblr8_ave_clk1),
    .ce(dspblr8_ave_ce1)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
(* core_generation_info = "dspblr8_ave,sysgen_core_2019_1,{,compilation=IP Catalog,block_icon_display=Default,family=zynquplusRFSOC,part=xczu29dr,speed=-1-e,package=ffvf1760,synthesis_language=verilog,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=1,interface_doc=1,ce_clr=0,clock_period=8,system_simulink_period=8e-09,waveform_viewer=1,axilite_interface=0,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=0.0001,addsub=24,concat=5,constant=1,convert=1,delay=35,mult=1,reinterpret=52,sgn=1,shift=3,slice=26,}" *)
module dspblr8_ave (
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
  wire ce_1_net;
  wire clk_1_net;
  dspblr8_ave_default_clock_driver dspblr8_ave_default_clock_driver (
    .dspblr8_ave_sysclk(clk),
    .dspblr8_ave_sysce(1'b1),
    .dspblr8_ave_sysclr(1'b0),
    .dspblr8_ave_clk1(clk_1_net),
    .dspblr8_ave_ce1(ce_1_net)
  );
  dspblr8_ave_struct dspblr8_ave_struct (
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
