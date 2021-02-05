`ifndef xlConvPkgIncluded
`include "conv_pkg.v"
`endif

`timescale 1 ns / 10 ps
// Generated from Simulink block dspblr5_Ave/+cut
module dspblr5_ave_cut (
  input [17-1:0] in1,
  input clk_1,
  input ce_1,
  output [17-1:0] out1
);
  wire [19-1:0] p_e_n_p_net;
  wire [17-1:0] delay2_q_net;
  wire [17-1:0] delay3_q_net;
  wire [17-1:0] addsub7_s_net;
  wire [2-1:0] threshold_y_net;
  wire [17-1:0] shift7_op_net;
  wire [17-1:0] addsub14_s_net;
  wire clk_net;
  wire ce_net;
  assign out1 = shift7_op_net;
  assign addsub14_s_net = in1;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i0"),
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
  dspblr5_ave_xldelay #(
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
  dspblr5_ave_xldelay #(
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
  dspblr5_ave_xlmult #(
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
    .core_name0("dspblr5_ave_mult_gen_v12_0_i0"),
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
  sysgen_shift_23f59056e1 shift7 (
    .clr(1'b0),
    .ip(addsub7_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift7_op_net)
  );
  sysgen_sgn_af2103bc3e threshold (
    .clr(1'b0),
    .x(addsub14_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .y(threshold_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dspblr5_Ave/DBL_Scalar2Vector1/Scalar2Vector
module dspblr5_ave_scalar2vector (
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
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice7_y_net;
  wire [128-1:0] concat_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice5_y_net;
  assign o_1 = slice0_y_net;
  assign o_2 = slice1_y_net;
  assign o_3 = slice2_y_net;
  assign o_4 = slice3_y_net;
  assign o_5 = slice4_y_net;
  assign o_6 = slice5_y_net;
  assign o_7 = slice6_y_net;
  assign o_8 = slice7_y_net;
  assign concat_y_net = i;
  dspblr5_ave_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice0 (
    .x(concat_y_net),
    .y(slice0_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(concat_y_net),
    .y(slice1_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(concat_y_net),
    .y(slice2_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(concat_y_net),
    .y(slice3_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(concat_y_net),
    .y(slice4_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(concat_y_net),
    .y(slice5_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(concat_y_net),
    .y(slice6_y_net)
  );
  dspblr5_ave_xlslice #(
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
// Generated from Simulink block dspblr5_Ave/DBL_Scalar2Vector1/Vector Reinterpret
module dspblr5_ave_vector_reinterpret_x0 (
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
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] slice2_y_net;
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
  sysgen_reinterpret_bc37672086 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice0_y_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dspblr5_Ave/DBL_Scalar2Vector1
module dspblr5_ave_dbl_scalar2vector1 (
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
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] reinterpret_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] dout_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice7_y_net;
  wire [128-1:0] concat_y_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  assign out1_1 = reinterpret0_output_port_net;
  assign out1_2 = reinterpret1_output_port_net;
  assign out1_3 = reinterpret2_output_port_net;
  assign out1_4 = reinterpret3_output_port_net;
  assign out1_5 = reinterpret4_output_port_net;
  assign out1_6 = reinterpret5_output_port_net;
  assign out1_7 = reinterpret6_output_port_net;
  assign out1_8 = reinterpret7_output_port_net;
  assign dout_net = in1;
  dspblr5_ave_scalar2vector scalar2vector (
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
  dspblr5_ave_vector_reinterpret_x0 vector_reinterpret (
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
  sysgen_concat_1cb1ca860f concat (
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
  sysgen_reinterpret_c82fb7b271 reinterpret (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(dout_net),
    .output_port(reinterpret_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dspblr5_Ave/DSP_Vector2Scalar/Vector2Scalar
module dspblr5_ave_vector2scalar (
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
  wire [16-1:0] reinterpret0_output_port_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
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
  sysgen_concat_1cb1ca860f concat1 (
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
// Generated from Simulink block dspblr5_Ave/DSP_Vector2Scalar/Vector_reinterpret2unsigned
module dspblr5_ave_vector_reinterpret2unsigned (
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
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net_x0;
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
  sysgen_reinterpret_c82fb7b271 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret0_output_port_net),
    .output_port(reinterpret0_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret1_output_port_net),
    .output_port(reinterpret1_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret2_output_port_net),
    .output_port(reinterpret2_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret3_output_port_net),
    .output_port(reinterpret3_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret4_output_port_net),
    .output_port(reinterpret4_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret5_output_port_net),
    .output_port(reinterpret5_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret6_output_port_net),
    .output_port(reinterpret6_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret7_output_port_net),
    .output_port(reinterpret7_output_port_net_x0)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dspblr5_Ave/DSP_Vector2Scalar
module dspblr5_ave_dsp_vector2scalar (
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
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net_x0;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [16-1:0] reinterpret5_output_port_net;
  assign out1 = concat1_y_net;
  assign reinterpret0_output_port_net_x0 = in1_1;
  assign reinterpret1_output_port_net_x0 = in1_2;
  assign reinterpret2_output_port_net_x0 = in1_3;
  assign reinterpret3_output_port_net_x0 = in1_4;
  assign reinterpret4_output_port_net_x0 = in1_5;
  assign reinterpret5_output_port_net_x0 = in1_6;
  assign reinterpret6_output_port_net_x0 = in1_7;
  assign reinterpret7_output_port_net_x0 = in1_8;
  dspblr5_ave_vector2scalar vector2scalar (
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
  dspblr5_ave_vector_reinterpret2unsigned vector_reinterpret2unsigned (
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
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dspblr5_Ave/DSP_delay
module dspblr5_ave_dsp_delay (
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
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire ce_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire clk_net;
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
  dspblr5_ave_xldelay #(
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
  dspblr5_ave_xldelay #(
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
  dspblr5_ave_xldelay #(
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
  dspblr5_ave_xldelay #(
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
  dspblr5_ave_xldelay #(
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
  dspblr5_ave_xldelay #(
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
  dspblr5_ave_xldelay #(
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
  dspblr5_ave_xldelay #(
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
// Generated from Simulink block dspblr5_Ave/HGAIN_Vector2Scalar/Vector2Scalar
module dspblr5_ave_vector2scalar_x0 (
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
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  assign o = concat1_y_net;
  assign reinterpret0_output_port_net = i_1;
  assign reinterpret1_output_port_net = i_2;
  assign reinterpret2_output_port_net = i_3;
  assign reinterpret3_output_port_net = i_4;
  assign reinterpret4_output_port_net = i_5;
  assign reinterpret5_output_port_net = i_6;
  assign reinterpret6_output_port_net = i_7;
  assign reinterpret7_output_port_net = i_8;
  sysgen_concat_1cb1ca860f concat1 (
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
// Generated from Simulink block dspblr5_Ave/HGAIN_Vector2Scalar/Vector_reinterpret2unsigned
module dspblr5_ave_vector_reinterpret2unsigned_x0 (
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
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
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
  sysgen_reinterpret_c82fb7b271 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay0_q_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay1_q_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay2_q_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay3_q_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay4_q_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay5_q_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay6_q_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay7_q_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dspblr5_Ave/HGAIN_Vector2Scalar
module dspblr5_ave_hgain_vector2scalar (
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
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  assign out1 = concat1_y_net;
  assign delay0_q_net = in1_1;
  assign delay1_q_net = in1_2;
  assign delay2_q_net = in1_3;
  assign delay3_q_net = in1_4;
  assign delay4_q_net = in1_5;
  assign delay5_q_net = in1_6;
  assign delay6_q_net = in1_7;
  assign delay7_q_net = in1_8;
  dspblr5_ave_vector2scalar_x0 vector2scalar (
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
  dspblr5_ave_vector_reinterpret2unsigned_x0 vector_reinterpret2unsigned (
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
// Generated from Simulink block dspblr5_Ave/Moving Average1
module dspblr5_ave_moving_average1 (
  input [128-1:0] tdata_in,
  input clk_1,
  input ce_1,
  output [17-1:0] sum_data_out,
  output [17-1:0] gateway_out,
  output [19-1:0] gateway_out1
);
  wire [16-1:0] shift4_op_net;
  wire [16-1:0] delay_q_net;
  wire [16-1:0] shift6_op_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] shift5_op_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret_output_port_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] slice_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] shift1_op_net;
  wire [17-1:0] addsub7_s_net;
  wire [16-1:0] delay1_q_net;
  wire [17-1:0] addsub10_s_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] shift7_op_net;
  wire [17-1:0] addsub14_s_net;
  wire [16-1:0] shift_op_net;
  wire [16-1:0] delay8_q_net;
  wire [19-1:0] addsub6_s_net;
  wire ce_net;
  wire [17-1:0] addsub12_s_net;
  wire [17-1:0] addsub8_s_net;
  wire [17-1:0] addsub_s_net;
  wire [17-1:0] addsub1_s_net;
  wire clk_net;
  wire [17-1:0] addsub11_s_net;
  wire [17-1:0] addsub9_s_net;
  wire [16-1:0] shift2_op_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay5_q_net;
  wire [17-1:0] addsub13_s_net;
  wire [17-1:0] addsub2_s_net;
  wire [18-1:0] addsub4_s_net;
  wire [18-1:0] addsub5_s_net;
  wire [17-1:0] addsub3_s_net;
  wire [16-1:0] shift3_op_net;
  assign sum_data_out = addsub14_s_net;
  assign concat1_y_net = tdata_in;
  assign gateway_out = addsub14_s_net;
  assign gateway_out1 = addsub6_s_net;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i1"),
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
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i2"),
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
    .b(addsub7_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i1"),
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
    .a(shift1_op_net),
    .b(delay6_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub10_s_net)
  );
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i1"),
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
    .a(shift_op_net),
    .b(delay8_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub11_s_net)
  );
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i2"),
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
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i2"),
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
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i3"),
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
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i1"),
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
    .b(delay4_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub2_s_net)
  );
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i1"),
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
    .a(shift2_op_net),
    .b(delay5_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net)
  );
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i2"),
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
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i2"),
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
    .b(addsub3_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub5_s_net)
  );
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(19),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i4"),
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
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i1"),
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
    .a(shift6_op_net),
    .b(delay_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub7_s_net)
  );
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i1"),
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
  dspblr5_ave_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dspblr5_ave_c_addsub_v12_0_i1"),
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
    .a(shift4_op_net),
    .b(delay3_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub9_s_net)
  );
  dspblr5_ave_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay (
    .en(1'b1),
    .rst(1'b0),
    .d(shift6_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay_q_net)
  );
  dspblr5_ave_xldelay #(
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
  dspblr5_ave_xldelay #(
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
  dspblr5_ave_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay3 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift4_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay3_q_net)
  );
  dspblr5_ave_xldelay #(
    .latency(1),
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
  dspblr5_ave_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay5 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift2_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay5_q_net)
  );
  dspblr5_ave_xldelay #(
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
  dspblr5_ave_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(16)
  )
  delay8 (
    .en(1'b1),
    .rst(1'b0),
    .d(shift_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay8_q_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice_y_net),
    .output_port(reinterpret_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net)
  );
  sysgen_shift_0c9ce6a440 shift (
    .clr(1'b0),
    .ip(reinterpret7_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift_op_net)
  );
  sysgen_shift_0c9ce6a440 shift1 (
    .clr(1'b0),
    .ip(reinterpret6_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift1_op_net)
  );
  sysgen_shift_0c9ce6a440 shift2 (
    .clr(1'b0),
    .ip(reinterpret5_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift2_op_net)
  );
  sysgen_shift_0c9ce6a440 shift3 (
    .clr(1'b0),
    .ip(reinterpret4_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift3_op_net)
  );
  sysgen_shift_0c9ce6a440 shift4 (
    .clr(1'b0),
    .ip(reinterpret3_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift4_op_net)
  );
  sysgen_shift_0c9ce6a440 shift5 (
    .clr(1'b0),
    .ip(reinterpret2_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift5_op_net)
  );
  sysgen_shift_0c9ce6a440 shift6 (
    .clr(1'b0),
    .ip(reinterpret1_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift6_op_net)
  );
  sysgen_shift_0c9ce6a440 shift7 (
    .clr(1'b0),
    .ip(reinterpret_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift7_op_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice (
    .x(concat1_y_net),
    .y(slice_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(concat1_y_net),
    .y(slice1_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(concat1_y_net),
    .y(slice2_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(concat1_y_net),
    .y(slice3_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(concat1_y_net),
    .y(slice4_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(concat1_y_net),
    .y(slice5_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(concat1_y_net),
    .y(slice6_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(112),
    .new_msb(127),
    .x_width(128),
    .y_width(16)
  )
  slice7 (
    .x(concat1_y_net),
    .y(slice7_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dspblr5_Ave/Scalar2Vector
module dspblr5_ave_scalar2vector_x0 (
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
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice5_y_net;
  wire [128-1:0] h_s_axis_tdata_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice6_y_net;
  assign o_1 = slice0_y_net;
  assign o_2 = slice1_y_net;
  assign o_3 = slice2_y_net;
  assign o_4 = slice3_y_net;
  assign o_5 = slice4_y_net;
  assign o_6 = slice5_y_net;
  assign o_7 = slice6_y_net;
  assign o_8 = slice7_y_net;
  assign h_s_axis_tdata_net = i;
  dspblr5_ave_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice0 (
    .x(h_s_axis_tdata_net),
    .y(slice0_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(h_s_axis_tdata_net),
    .y(slice1_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(h_s_axis_tdata_net),
    .y(slice2_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(h_s_axis_tdata_net),
    .y(slice3_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(h_s_axis_tdata_net),
    .y(slice4_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(h_s_axis_tdata_net),
    .y(slice5_y_net)
  );
  dspblr5_ave_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(h_s_axis_tdata_net),
    .y(slice6_y_net)
  );
  dspblr5_ave_xlslice #(
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
// Generated from Simulink block dspblr5_Ave/Vector Reinterpret
module dspblr5_ave_vector_reinterpret (
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
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] reinterpret0_output_port_net;
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
  sysgen_reinterpret_bc37672086 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice0_y_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_bc37672086 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dspblr5_Ave/Vector Reinterpret2
module dspblr5_ave_vector_reinterpret2 (
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
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net_x0;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
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
  sysgen_reinterpret_c82fb7b271 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret0_output_port_net),
    .output_port(reinterpret0_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret1_output_port_net),
    .output_port(reinterpret1_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret2_output_port_net),
    .output_port(reinterpret2_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret3_output_port_net),
    .output_port(reinterpret3_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret4_output_port_net),
    .output_port(reinterpret4_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret5_output_port_net),
    .output_port(reinterpret5_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret6_output_port_net),
    .output_port(reinterpret6_output_port_net_x0)
  );
  sysgen_reinterpret_c82fb7b271 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret7_output_port_net),
    .output_port(reinterpret7_output_port_net_x0)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dspblr5_Ave/Vector2Scalar1
module dspblr5_ave_vector2scalar1 (
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
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  assign o = concat1_y_net;
  assign reinterpret0_output_port_net = i_1;
  assign reinterpret1_output_port_net = i_2;
  assign reinterpret2_output_port_net = i_3;
  assign reinterpret3_output_port_net = i_4;
  assign reinterpret4_output_port_net = i_5;
  assign reinterpret5_output_port_net = i_6;
  assign reinterpret6_output_port_net = i_7;
  assign reinterpret7_output_port_net = i_8;
  sysgen_concat_1cb1ca860f concat1 (
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
// Generated from Simulink block dspblr5_Ave_struct
module dspblr5_ave_struct (
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
  output [1-1:0] l_m_axis_tvalid,
  output [17-1:0] gateway_out,
  output [19-1:0] gateway_out1
);
  wire [32-1:0] l_gain_tdata_delay_q_net;
  wire [1-1:0] l_gain_tvalid_delay_q_net;
  wire [128-1:0] concat1_y_net_x1;
  wire [19-1:0] addsub6_s_net;
  wire clk_net;
  wire [128-1:0] h_s_axis_tdata_net;
  wire [1-1:0] h_s_axis_tvalid_net;
  wire [32-1:0] l_s_axis_tdata_net;
  wire ce_net;
  wire [17-1:0] shift7_op_net;
  wire [17-1:0] addsub14_s_net;
  wire [16-1:0] reinterpret0_output_port_net_x1;
  wire [16-1:0] reinterpret1_output_port_net_x1;
  wire [16-1:0] reinterpret2_output_port_net_x1;
  wire [16-1:0] reinterpret3_output_port_net_x1;
  wire [16-1:0] reinterpret4_output_port_net_x1;
  wire [1-1:0] l_s_axis_tvalid_net;
  wire [16-1:0] reinterpret5_output_port_net_x1;
  wire [16-1:0] reinterpret6_output_port_net_x1;
  wire [16-1:0] reinterpret7_output_port_net_x1;
  wire [1-1:0] delay_q_net;
  wire [128-1:0] concat1_y_net_x0;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net_x0;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice2_y_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] dout_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] delay3_q_net;
  assign dsp_m_axis_tdata = concat1_y_net_x1;
  assign dsp_m_axis_tvalid = delay_q_net;
  assign h_m_axis_tdata = concat1_y_net_x0;
  assign h_m_axis_tvalid = delay_q_net;
  assign h_s_axis_tdata_net = h_s_axis_tdata;
  assign h_s_axis_tvalid_net = h_s_axis_tvalid;
  assign l_m_axis_tdata = l_gain_tdata_delay_q_net;
  assign l_m_axis_tvalid = l_gain_tvalid_delay_q_net;
  assign l_s_axis_tdata_net = l_s_axis_tdata;
  assign l_s_axis_tvalid_net = l_s_axis_tvalid;
  assign gateway_out = addsub14_s_net;
  assign gateway_out1 = addsub6_s_net;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dspblr5_ave_cut cut (
    .in1(addsub14_s_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .out1(shift7_op_net)
  );
  dspblr5_ave_dbl_scalar2vector1 dbl_scalar2vector1 (
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
  dspblr5_ave_dsp_vector2scalar dsp_vector2scalar (
    .in1_1(reinterpret0_output_port_net_x1),
    .in1_2(reinterpret1_output_port_net_x1),
    .in1_3(reinterpret2_output_port_net_x1),
    .in1_4(reinterpret3_output_port_net_x1),
    .in1_5(reinterpret4_output_port_net_x1),
    .in1_6(reinterpret5_output_port_net_x1),
    .in1_7(reinterpret6_output_port_net_x1),
    .in1_8(reinterpret7_output_port_net_x1),
    .out1(concat1_y_net_x1)
  );
  dspblr5_ave_dsp_delay dsp_delay (
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
    .q_3(delay2_q_net),
    .q_4(delay3_q_net),
    .q_5(delay4_q_net),
    .q_6(delay5_q_net),
    .q_7(delay6_q_net),
    .q_8(delay7_q_net)
  );
  dspblr5_ave_hgain_vector2scalar hgain_vector2scalar (
    .in1_1(delay0_q_net),
    .in1_2(delay1_q_net),
    .in1_3(delay2_q_net),
    .in1_4(delay3_q_net),
    .in1_5(delay4_q_net),
    .in1_6(delay5_q_net),
    .in1_7(delay6_q_net),
    .in1_8(delay7_q_net),
    .out1(concat1_y_net_x0)
  );
  dspblr5_ave_moving_average1 moving_average1 (
    .tdata_in(concat1_y_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .sum_data_out(addsub14_s_net),
    .gateway_out(addsub14_s_net),
    .gateway_out1(addsub6_s_net)
  );
  dspblr5_ave_scalar2vector_x0 scalar2vector (
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
  dspblr5_ave_vector_reinterpret vector_reinterpret (
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
  dspblr5_ave_vector_reinterpret2 vector_reinterpret2 (
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
  dspblr5_ave_vector2scalar1 vector2scalar1 (
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
  dspblr5_ave_xlconvert #(
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
  dspblr5_ave_xldelay #(
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
  sysgen_delay_0ddbe5b246 l_gain_tdata_delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(l_s_axis_tdata_net),
    .q(l_gain_tdata_delay_q_net)
  );
  sysgen_delay_b419f9f748 l_gain_tvalid_delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(l_s_axis_tvalid_net),
    .q(l_gain_tvalid_delay_q_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
module dspblr5_ave_default_clock_driver (
  input dspblr5_ave_sysclk,
  input dspblr5_ave_sysce,
  input dspblr5_ave_sysclr,
  output dspblr5_ave_clk1,
  output dspblr5_ave_ce1
);
  xlclockdriver #(
    .period(1),
    .log_2_period(1)
  )
  clockdriver (
    .sysclk(dspblr5_ave_sysclk),
    .sysce(dspblr5_ave_sysce),
    .sysclr(dspblr5_ave_sysclr),
    .clk(dspblr5_ave_clk1),
    .ce(dspblr5_ave_ce1)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
(* core_generation_info = "dspblr5_ave,sysgen_core_2019_1,{,compilation=IP Catalog,block_icon_display=Default,family=zynquplusRFSOC,part=xczu29dr,speed=-1-e,package=ffvf1760,synthesis_language=verilog,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=1,interface_doc=1,ce_clr=0,clock_period=8,system_simulink_period=8e-09,waveform_viewer=1,axilite_interface=0,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=0.0001,addsub=16,concat=4,convert=1,delay=21,mult=1,reinterpret=49,sgn=1,shift=9,slice=24,}" *)
module dspblr5_ave (
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
  output [1-1:0] l_m_axis_tvalid,
  output [17-1:0] gateway_out,
  output [19-1:0] gateway_out1
);
  wire ce_1_net;
  wire clk_1_net;
  dspblr5_ave_default_clock_driver dspblr5_ave_default_clock_driver (
    .dspblr5_ave_sysclk(clk),
    .dspblr5_ave_sysce(1'b1),
    .dspblr5_ave_sysclr(1'b0),
    .dspblr5_ave_clk1(clk_1_net),
    .dspblr5_ave_ce1(ce_1_net)
  );
  dspblr5_ave_struct dspblr5_ave_struct (
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
    .l_m_axis_tvalid(l_m_axis_tvalid),
    .gateway_out(gateway_out),
    .gateway_out1(gateway_out1)
  );
endmodule
