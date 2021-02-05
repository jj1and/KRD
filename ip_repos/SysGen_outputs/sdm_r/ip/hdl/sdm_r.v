`ifndef xlConvPkgIncluded
`include "conv_pkg.v"
`endif

`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/8sample_average /Vector_sum/Vector Reinterpret
module sdm_r_vector_reinterpret (
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
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net_x0;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  assign out_1 = reinterpret0_output_port_net;
  assign out_2 = reinterpret1_output_port_net;
  assign out_3 = reinterpret2_output_port_net;
  assign out_4 = reinterpret3_output_port_net;
  assign out_5 = reinterpret4_output_port_net;
  assign out_6 = reinterpret5_output_port_net;
  assign out_7 = reinterpret6_output_port_net;
  assign out_8 = reinterpret7_output_port_net;
  assign reinterpret0_output_port_net_x0 = in_1;
  assign reinterpret1_output_port_net_x0 = in_2;
  assign reinterpret2_output_port_net_x0 = in_3;
  assign reinterpret3_output_port_net_x0 = in_4;
  assign reinterpret4_output_port_net_x0 = in_5;
  assign reinterpret5_output_port_net_x0 = in_6;
  assign reinterpret6_output_port_net_x0 = in_7;
  assign reinterpret7_output_port_net_x0 = in_8;
  sysgen_reinterpret_f70795ad03 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret0_output_port_net_x0),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret1_output_port_net_x0),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret2_output_port_net_x0),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret3_output_port_net_x0),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret4_output_port_net_x0),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret5_output_port_net_x0),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret6_output_port_net_x0),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(reinterpret7_output_port_net_x0),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/8sample_average /Vector_sum/Vector2Scalar
module sdm_r_vector2scalar (
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
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret4_output_port_net;
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
  sysgen_concat_7effe9f9e9 concat1 (
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
// Generated from Simulink block sdm_r/8sample_average /Vector_sum
module sdm_r_vector_sum (
  input [16-1:0] tdata_in_1,
  input [16-1:0] tdata_in_2,
  input [16-1:0] tdata_in_3,
  input [16-1:0] tdata_in_4,
  input [16-1:0] tdata_in_5,
  input [16-1:0] tdata_in_6,
  input [16-1:0] tdata_in_7,
  input [16-1:0] tdata_in_8,
  input clk_1,
  input ce_1,
  output [19-1:0] sum_data_out
);
  wire [19-1:0] addsub6_s_net;
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] reinterpret1_output_port_net_x1;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net_x1;
  wire clk_net;
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] reinterpret0_output_port_net;
  wire ce_net;
  wire [16-1:0] reinterpret2_output_port_net_x1;
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net_x1;
  wire [16-1:0] reinterpret5_output_port_net_x1;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice3_y_net;
  wire [17-1:0] addsub3_s_net;
  wire [16-1:0] reinterpret3_output_port_net_x0;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  wire [17-1:0] addsub_s_net;
  wire [17-1:0] addsub1_s_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [16-1:0] reinterpret6_output_port_net_x1;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [17-1:0] addsub2_s_net;
  wire [16-1:0] reinterpret7_output_port_net_x1;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [18-1:0] addsub4_s_net;
  wire [18-1:0] addsub5_s_net;
  assign sum_data_out = addsub6_s_net;
  assign reinterpret0_output_port_net_x0 = tdata_in_1;
  assign reinterpret1_output_port_net_x1 = tdata_in_2;
  assign reinterpret2_output_port_net_x1 = tdata_in_3;
  assign reinterpret3_output_port_net_x1 = tdata_in_4;
  assign reinterpret4_output_port_net_x1 = tdata_in_5;
  assign reinterpret5_output_port_net_x1 = tdata_in_6;
  assign reinterpret6_output_port_net = tdata_in_7;
  assign reinterpret7_output_port_net = tdata_in_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  sdm_r_vector_reinterpret vector_reinterpret (
    .in_1(reinterpret0_output_port_net_x0),
    .in_2(reinterpret1_output_port_net_x1),
    .in_3(reinterpret2_output_port_net_x1),
    .in_4(reinterpret3_output_port_net_x1),
    .in_5(reinterpret4_output_port_net_x1),
    .in_6(reinterpret5_output_port_net_x1),
    .in_7(reinterpret6_output_port_net),
    .in_8(reinterpret7_output_port_net),
    .out_1(reinterpret0_output_port_net),
    .out_2(reinterpret1_output_port_net_x0),
    .out_3(reinterpret2_output_port_net_x0),
    .out_4(reinterpret3_output_port_net_x0),
    .out_5(reinterpret4_output_port_net_x0),
    .out_6(reinterpret5_output_port_net_x0),
    .out_7(reinterpret6_output_port_net_x1),
    .out_8(reinterpret7_output_port_net_x1)
  );
  sdm_r_vector2scalar vector2scalar (
    .i_1(reinterpret0_output_port_net),
    .i_2(reinterpret1_output_port_net_x0),
    .i_3(reinterpret2_output_port_net_x0),
    .i_4(reinterpret3_output_port_net_x0),
    .i_5(reinterpret4_output_port_net_x0),
    .i_6(reinterpret5_output_port_net_x0),
    .i_7(reinterpret6_output_port_net_x1),
    .i_8(reinterpret7_output_port_net_x1),
    .o(concat1_y_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("sdm_r_c_addsub_v12_0_i0"),
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
    .a(reinterpret_output_port_net),
    .b(reinterpret1_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub_s_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("sdm_r_c_addsub_v12_0_i0"),
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
  addsub1 (
    .clr(1'b0),
    .en(1'b1),
    .a(reinterpret2_output_port_net),
    .b(reinterpret3_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("sdm_r_c_addsub_v12_0_i0"),
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
    .a(reinterpret4_output_port_net),
    .b(reinterpret5_output_port_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub2_s_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("sdm_r_c_addsub_v12_0_i0"),
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
    .a(reinterpret6_output_port_net_x0),
    .b(reinterpret7_output_port_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("sdm_r_c_addsub_v12_0_i1"),
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
    .a(addsub_s_net),
    .b(addsub1_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub4_s_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("sdm_r_c_addsub_v12_0_i1"),
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
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(18),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(19),
    .core_name0("sdm_r_c_addsub_v12_0_i2"),
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
    .a(addsub4_s_net),
    .b(addsub5_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub6_s_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice_y_net),
    .output_port(reinterpret_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net_x0)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net_x0)
  );
  sdm_r_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice (
    .x(concat1_y_net),
    .y(slice_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(concat1_y_net),
    .y(slice1_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(concat1_y_net),
    .y(slice2_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(concat1_y_net),
    .y(slice3_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(concat1_y_net),
    .y(slice4_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(concat1_y_net),
    .y(slice5_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(concat1_y_net),
    .y(slice6_y_net)
  );
  sdm_r_xlslice #(
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
// Generated from Simulink block sdm_r/8sample_average /scaling
module sdm_r_scaling (
  input [1-1:0] valid_in,
  input [19-1:0] data_in,
  input clk_1,
  input ce_1,
  output [1-1:0] valid_out,
  output [19-1:0] data_out
);
  wire [1-1:0] tvalid_delay_q_net;
  wire [19-1:0] addsub6_s_net;
  wire clk_net;
  wire [19-1:0] shift_op_net;
  wire [1-1:0] h_s_axis_tvalid_net;
  wire ce_net;
  assign valid_out = tvalid_delay_q_net;
  assign data_out = shift_op_net;
  assign h_s_axis_tvalid_net = valid_in;
  assign addsub6_s_net = data_in;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  sysgen_shift_56c97bdca1 shift (
    .clr(1'b0),
    .ip(addsub6_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(shift_op_net)
  );
  sdm_r_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(1)
  )
  tvalid_delay (
    .en(1'b1),
    .rst(1'b0),
    .d(h_s_axis_tvalid_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(tvalid_delay_q_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/8sample_average 
module sdm_r_8sample_average (
  input [1-1:0] valid_in,
  input [16-1:0] data_in_1,
  input [16-1:0] data_in_2,
  input [16-1:0] data_in_3,
  input [16-1:0] data_in_4,
  input [16-1:0] data_in_5,
  input [16-1:0] data_in_6,
  input [16-1:0] data_in_7,
  input [16-1:0] data_in_8,
  input clk_1,
  input ce_1,
  output [1-1:0] ave_valid_out,
  output [19-1:0] ave_data_out
);
  wire [19-1:0] shift_op_net;
  wire [1-1:0] tvalid_delay_q_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [1-1:0] h_s_axis_tvalid_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire ce_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [19-1:0] addsub6_s_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire clk_net;
  assign ave_valid_out = tvalid_delay_q_net;
  assign ave_data_out = shift_op_net;
  assign h_s_axis_tvalid_net = valid_in;
  assign reinterpret0_output_port_net = data_in_1;
  assign reinterpret1_output_port_net = data_in_2;
  assign reinterpret2_output_port_net = data_in_3;
  assign reinterpret3_output_port_net = data_in_4;
  assign reinterpret4_output_port_net = data_in_5;
  assign reinterpret5_output_port_net = data_in_6;
  assign reinterpret6_output_port_net = data_in_7;
  assign reinterpret7_output_port_net = data_in_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  sdm_r_vector_sum vector_sum (
    .tdata_in_1(reinterpret0_output_port_net),
    .tdata_in_2(reinterpret1_output_port_net),
    .tdata_in_3(reinterpret2_output_port_net),
    .tdata_in_4(reinterpret3_output_port_net),
    .tdata_in_5(reinterpret4_output_port_net),
    .tdata_in_6(reinterpret5_output_port_net),
    .tdata_in_7(reinterpret6_output_port_net),
    .tdata_in_8(reinterpret7_output_port_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .sum_data_out(addsub6_s_net)
  );
  sdm_r_scaling scaling (
    .valid_in(h_s_axis_tvalid_net),
    .data_in(addsub6_s_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .valid_out(tvalid_delay_q_net),
    .data_out(shift_op_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/DBL_Scalar2Vector/Scalar2Vector
module sdm_r_scalar2vector (
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
  wire [128-1:0] concat_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice2_y_net;
  assign o_1 = slice0_y_net;
  assign o_2 = slice1_y_net;
  assign o_3 = slice2_y_net;
  assign o_4 = slice3_y_net;
  assign o_5 = slice4_y_net;
  assign o_6 = slice5_y_net;
  assign o_7 = slice6_y_net;
  assign o_8 = slice7_y_net;
  assign concat_y_net = i;
  sdm_r_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice0 (
    .x(concat_y_net),
    .y(slice0_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(concat_y_net),
    .y(slice1_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(concat_y_net),
    .y(slice2_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(concat_y_net),
    .y(slice3_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(concat_y_net),
    .y(slice4_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(concat_y_net),
    .y(slice5_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(concat_y_net),
    .y(slice6_y_net)
  );
  sdm_r_xlslice #(
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
// Generated from Simulink block sdm_r/DBL_Scalar2Vector/Vector Reinterpret
module sdm_r_vector_reinterpret_x0 (
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
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
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
  sysgen_reinterpret_621e2d1c70 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice0_y_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/DBL_Scalar2Vector
module sdm_r_dbl_scalar2vector (
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
  wire [128-1:0] concat_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] convert_to_dac_data_dout_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] reinterpret_output_port_net;
  assign out1_1 = reinterpret0_output_port_net;
  assign out1_2 = reinterpret1_output_port_net;
  assign out1_3 = reinterpret2_output_port_net;
  assign out1_4 = reinterpret3_output_port_net;
  assign out1_5 = reinterpret4_output_port_net;
  assign out1_6 = reinterpret5_output_port_net;
  assign out1_7 = reinterpret6_output_port_net;
  assign out1_8 = reinterpret7_output_port_net;
  assign convert_to_dac_data_dout_net = in1;
  sdm_r_scalar2vector scalar2vector (
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
  sdm_r_vector_reinterpret_x0 vector_reinterpret (
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
  sysgen_concat_7effe9f9e9 concat (
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
  sysgen_reinterpret_f70795ad03 reinterpret (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(convert_to_dac_data_dout_net),
    .output_port(reinterpret_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/DSP_Vector2Scalar/Vector2Scalar
module sdm_r_vector2scalar_x0 (
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
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
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
  sysgen_concat_7effe9f9e9 concat1 (
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
// Generated from Simulink block sdm_r/DSP_Vector2Scalar/Vector_reinterpret2unsigned
module sdm_r_vector_reinterpret2unsigned (
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
  wire [16-1:0] addsub4_s_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] addsub1_s_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] addsub0_s_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] addsub2_s_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] addsub3_s_net;
  wire [16-1:0] addsub6_s_net;
  wire [16-1:0] addsub7_s_net;
  wire [16-1:0] addsub5_s_net;
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
  sysgen_reinterpret_f70795ad03 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub0_s_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub1_s_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub2_s_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub3_s_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub4_s_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub5_s_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub6_s_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub7_s_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/DSP_Vector2Scalar
module sdm_r_dsp_vector2scalar (
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
  wire [16-1:0] addsub4_s_net;
  wire [16-1:0] addsub5_s_net;
  wire [16-1:0] addsub1_s_net;
  wire [16-1:0] addsub6_s_net;
  wire [16-1:0] addsub2_s_net;
  wire [16-1:0] addsub3_s_net;
  wire [16-1:0] addsub0_s_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] addsub7_s_net;
  wire [16-1:0] reinterpret6_output_port_net;
  assign out1 = concat1_y_net;
  assign addsub0_s_net = in1_1;
  assign addsub1_s_net = in1_2;
  assign addsub2_s_net = in1_3;
  assign addsub3_s_net = in1_4;
  assign addsub4_s_net = in1_5;
  assign addsub5_s_net = in1_6;
  assign addsub6_s_net = in1_7;
  assign addsub7_s_net = in1_8;
  sdm_r_vector2scalar_x0 vector2scalar (
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
  sdm_r_vector_reinterpret2unsigned vector_reinterpret2unsigned (
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
// Generated from Simulink block sdm_r/DSP_delay
module sdm_r_dsp_delay (
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
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire ce_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire clk_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
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
  sdm_r_xldelay #(
    .latency(6),
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
  sdm_r_xldelay #(
    .latency(6),
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
  sdm_r_xldelay #(
    .latency(6),
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
  sdm_r_xldelay #(
    .latency(6),
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
  sdm_r_xldelay #(
    .latency(6),
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
  sdm_r_xldelay #(
    .latency(6),
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
  sdm_r_xldelay #(
    .latency(6),
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
  sdm_r_xldelay #(
    .latency(6),
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
// Generated from Simulink block sdm_r/HGAIN_Vector2Scalar/Vector2Scalar
module sdm_r_vector2scalar_x1 (
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
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  assign o = concat1_y_net;
  assign reinterpret0_output_port_net = i_1;
  assign reinterpret1_output_port_net = i_2;
  assign reinterpret2_output_port_net = i_3;
  assign reinterpret3_output_port_net = i_4;
  assign reinterpret4_output_port_net = i_5;
  assign reinterpret5_output_port_net = i_6;
  assign reinterpret6_output_port_net = i_7;
  assign reinterpret7_output_port_net = i_8;
  sysgen_concat_7effe9f9e9 concat1 (
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
// Generated from Simulink block sdm_r/HGAIN_Vector2Scalar/Vector_reinterpret2unsigned
module sdm_r_vector_reinterpret2unsigned_x0 (
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
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
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
  sysgen_reinterpret_f70795ad03 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay0_q_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay1_q_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay2_q_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay3_q_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay4_q_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay5_q_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay6_q_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_f70795ad03 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay7_q_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/HGAIN_Vector2Scalar
module sdm_r_hgain_vector2scalar (
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
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay4_q_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret4_output_port_net;
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
  sdm_r_vector2scalar_x1 vector2scalar (
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
  sdm_r_vector_reinterpret2unsigned_x0 vector_reinterpret2unsigned (
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
// Generated from Simulink block sdm_r/HGAIN_delay
module sdm_r_hgain_delay (
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
  wire [16-1:0] delay7_q_net_x0;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay3_q_net_x0;
  wire [16-1:0] delay4_q_net_x0;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay5_q_net_x0;
  wire [16-1:0] delay6_q_net_x0;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay1_q_net_x0;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay2_q_net_x0;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay7_q_net;
  wire clk_net;
  wire ce_net;
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
  sdm_r_xldelay #(
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
  sdm_r_xldelay #(
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
  sdm_r_xldelay #(
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
  sdm_r_xldelay #(
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
  sdm_r_xldelay #(
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
  sdm_r_xldelay #(
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
  sdm_r_xldelay #(
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
  sdm_r_xldelay #(
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
// Generated from Simulink block sdm_r/Scalar2Vector
module sdm_r_scalar2vector_x0 (
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
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice6_y_net;
  wire [128-1:0] h_s_axis_tdata_net;
  wire [16-1:0] slice5_y_net;
  assign o_1 = slice0_y_net;
  assign o_2 = slice1_y_net;
  assign o_3 = slice2_y_net;
  assign o_4 = slice3_y_net;
  assign o_5 = slice4_y_net;
  assign o_6 = slice5_y_net;
  assign o_7 = slice6_y_net;
  assign o_8 = slice7_y_net;
  assign h_s_axis_tdata_net = i;
  sdm_r_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice0 (
    .x(h_s_axis_tdata_net),
    .y(slice0_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(h_s_axis_tdata_net),
    .y(slice1_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(h_s_axis_tdata_net),
    .y(slice2_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(h_s_axis_tdata_net),
    .y(slice3_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(h_s_axis_tdata_net),
    .y(slice4_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(h_s_axis_tdata_net),
    .y(slice5_y_net)
  );
  sdm_r_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(h_s_axis_tdata_net),
    .y(slice6_y_net)
  );
  sdm_r_xlslice #(
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
// Generated from Simulink block sdm_r/Vector AddSub Fabric
module sdm_r_vector_addsub_fabric (
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
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] addsub1_s_net;
  wire [16-1:0] addsub6_s_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] addsub0_s_net;
  wire [16-1:0] addsub4_s_net;
  wire [16-1:0] addsub5_s_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] addsub2_s_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] addsub3_s_net;
  wire [16-1:0] addsub7_s_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire clk_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire ce_net;
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
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("sdm_r_c_addsub_v12_0_i3"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(2),
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
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("sdm_r_c_addsub_v12_0_i3"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(2),
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
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("sdm_r_c_addsub_v12_0_i3"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(2),
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
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("sdm_r_c_addsub_v12_0_i3"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(2),
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
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("sdm_r_c_addsub_v12_0_i3"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(2),
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
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("sdm_r_c_addsub_v12_0_i3"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(2),
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
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("sdm_r_c_addsub_v12_0_i3"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(2),
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
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(17),
    .core_name0("sdm_r_c_addsub_v12_0_i3"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(17),
    .latency(1),
    .overflow(1),
    .quantization(2),
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
// Generated from Simulink block sdm_r/Vector Reinterpret
module sdm_r_vector_reinterpret_x1 (
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
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice1_y_net;
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
  sysgen_reinterpret_621e2d1c70 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice0_y_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_621e2d1c70 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/xil_dac_PID
module sdm_r_xil_dac_pid (
  input [1-1:0] valid_in,
  input [20-1:0] data_in,
  input [1-1:0] init_in,
  input clk_1,
  input ce_1,
  output [1-1:0] valid_out,
  output [49-1:0] pid_data_out
);
  wire [16-1:0] i_dt_op_net;
  wire [48-1:0] i_n_1_e_n_i_dt_p_net;
  wire [1-1:0] tvalid_delay_q_net;
  wire [1-1:0] logical_y_net;
  wire [32-1:0] accumulator_q_net;
  wire [1-1:0] logical_y_net_x0;
  wire [49-1:0] p_comp_i_comp_s_net;
  wire [20-1:0] delta_from_baseline_s_net;
  wire ce_net;
  wire clk_net;
  wire [1-1:0] delay_q_net;
  wire [1-1:0] inverter_op_net;
  wire [36-1:0] p_e_n_p_net;
  wire [16-1:0] p_op_net;
  assign valid_out = delay_q_net;
  assign pid_data_out = p_comp_i_comp_s_net;
  assign tvalid_delay_q_net = valid_in;
  assign delta_from_baseline_s_net = data_in;
  assign logical_y_net = init_in;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  sdm_r_xlmult #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(32),
    .b_arith(`xlSigned),
    .b_bin_pt(16),
    .b_width(16),
    .c_a_type(0),
    .c_a_width(32),
    .c_b_type(0),
    .c_b_width(16),
    .c_baat(32),
    .c_output_width(48),
    .c_type(0),
    .core_name0("sdm_r_mult_gen_v12_0_i0"),
    .extra_registers(0),
    .multsign(2),
    .overflow(1),
    .p_arith(`xlSigned),
    .p_bin_pt(20),
    .p_width(48),
    .quantization(1)
  )
  i_n_1_e_n_i_dt (
    .clr(1'b0),
    .core_clr(1'b1),
    .en(1'b1),
    .rst(1'b0),
    .a(accumulator_q_net),
    .b(i_dt_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .core_clk(clk_net),
    .core_ce(ce_net),
    .p(i_n_1_e_n_i_dt_p_net)
  );
  sysgen_accum_d6859c0410 accumulator (
    .clr(1'b0),
    .b(delta_from_baseline_s_net),
    .rst(logical_y_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .q(accumulator_q_net)
  );
  sdm_r_xldelay #(
    .latency(4),
    .reg_retiming(0),
    .reset(0),
    .width(1)
  )
  delay (
    .en(1'b1),
    .rst(1'b0),
    .d(tvalid_delay_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay_q_net)
  );
  sysgen_constant_1bbc8f5d8c i_dt (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(i_dt_op_net)
  );
  sysgen_inverter_1aa041e064 inverter (
    .clr(1'b0),
    .ip(tvalid_delay_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(inverter_op_net)
  );
  sysgen_logical_4420769c0d logical (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d0(inverter_op_net),
    .d1(logical_y_net),
    .y(logical_y_net_x0)
  );
  sysgen_constant_8875d96f2c p (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(p_op_net)
  );
  sdm_r_xlmult #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(20),
    .b_arith(`xlSigned),
    .b_bin_pt(16),
    .b_width(16),
    .c_a_type(0),
    .c_a_width(20),
    .c_b_type(0),
    .c_b_width(16),
    .c_baat(20),
    .c_output_width(36),
    .c_type(0),
    .core_name0("sdm_r_mult_gen_v12_0_i1"),
    .extra_registers(0),
    .multsign(2),
    .overflow(1),
    .p_arith(`xlSigned),
    .p_bin_pt(20),
    .p_width(36),
    .quantization(1)
  )
  p_e_n (
    .clr(1'b0),
    .core_clr(1'b1),
    .en(1'b1),
    .rst(1'b0),
    .a(delta_from_baseline_s_net),
    .b(p_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .core_clk(clk_net),
    .core_ce(ce_net),
    .p(p_e_n_p_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(20),
    .a_width(36),
    .b_arith(`xlSigned),
    .b_bin_pt(20),
    .b_width(48),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(49),
    .core_name0("sdm_r_c_addsub_v12_0_i4"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(49),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(20),
    .s_width(49)
  )
  p_comp_i_comp (
    .clr(1'b0),
    .en(1'b1),
    .a(p_e_n_p_net),
    .b(i_n_1_e_n_i_dt_p_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(p_comp_i_comp_s_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/xil_dac_delta_calc
module sdm_r_xil_dac_delta_calc (
  input [1-1:0] valid_in,
  input [19-1:0] data_in,
  input [16-1:0] dac_data_in,
  input [16-1:0] baseline_in,
  input clk_1,
  input ce_1,
  output [20-1:0] delta_data_out,
  output [1-1:0] init_pid
);
  wire ce_net;
  wire [20-1:0] delta_from_baseline_s_net;
  wire [19-1:0] shift_op_net;
  wire clk_net;
  wire [16-1:0] constant_op_net;
  wire [16-1:0] convert_to_dac_input_dout_net;
  wire [1-1:0] isnot_undershoot_op_net;
  wire [1-1:0] no_operation_op_net;
  wire [16-1:0] convert_dout_net;
  wire [1-1:0] tvalid_delay_q_net;
  wire [1-1:0] logical_y_net;
  assign delta_data_out = delta_from_baseline_s_net;
  assign init_pid = logical_y_net;
  assign tvalid_delay_q_net = valid_in;
  assign shift_op_net = data_in;
  assign convert_to_dac_input_dout_net = dac_data_in;
  assign convert_dout_net = baseline_in;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  sysgen_constant_ebb10e85a8 constant (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(constant_op_net)
  );
  sysgen_logical_f82093c987 logical (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d0(isnot_undershoot_op_net),
    .d1(no_operation_op_net),
    .y(logical_y_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(19),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("sdm_r_c_addsub_v12_0_i5"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(20),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(20)
  )
  delta_from_baseline (
    .clr(1'b0),
    .en(1'b1),
    .a(shift_op_net),
    .b(convert_dout_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(delta_from_baseline_s_net)
  );
  sysgen_relational_412275f39b isnot_undershoot (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .a(shift_op_net),
    .b(convert_dout_net),
    .op(isnot_undershoot_op_net)
  );
  sysgen_relational_84667b153d no_operation (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .a(convert_to_dac_input_dout_net),
    .b(constant_op_net),
    .op(no_operation_op_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/xil_dac_smoothing
module sdm_r_xil_dac_smoothing (
  input [49-1:0] data_in,
  input clk_1,
  input ce_1,
  output [50-1:0] data_out
);
  wire [49-1:0] last_sample_q_net;
  wire [49-1:0] p_comp_i_comp_s_net;
  wire ce_net;
  wire [50-1:0] x2sample_ave_op_net;
  wire clk_net;
  wire [50-1:0] x2sample_sum_s_net;
  assign data_out = x2sample_ave_op_net;
  assign p_comp_i_comp_s_net = data_in;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  sysgen_shift_3a84be4a76 x2sample_ave (
    .clr(1'b0),
    .ip(x2sample_sum_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(x2sample_ave_op_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(20),
    .a_width(49),
    .b_arith(`xlSigned),
    .b_bin_pt(20),
    .b_width(49),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(50),
    .core_name0("sdm_r_c_addsub_v12_0_i6"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(50),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(20),
    .s_width(50)
  )
  x2sample_sum (
    .clr(1'b0),
    .en(1'b1),
    .a(p_comp_i_comp_s_net),
    .b(last_sample_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(x2sample_sum_s_net)
  );
  sdm_r_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(49)
  )
  last_sample (
    .en(1'b1),
    .rst(1'b0),
    .d(p_comp_i_comp_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(last_sample_q_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/xil_dblc_PID
module sdm_r_xil_dblc_pid (
  input [1-1:0] valid_in,
  input [21-1:0] data_in,
  input [1-1:0] init_in,
  input clk_1,
  input ce_1,
  output [49-1:0] pid_data_out
);
  wire clk_net;
  wire ce_net;
  wire [1-1:0] tvalid_delay_q_net;
  wire [21-1:0] delta_from_baseline_s_net;
  wire [49-1:0] p_comp_i_comp_s_net;
  wire [1-1:0] logical_y_net;
  wire [32-1:0] accumulator_q_net;
  wire [48-1:0] i_n_1_e_n_i_dt_p_net;
  wire [16-1:0] i_dt_op_net;
  wire [1-1:0] logical_y_net_x0;
  wire [1-1:0] inverter_op_net;
  wire [16-1:0] p_op_net;
  wire [37-1:0] p_e_n_p_net;
  assign pid_data_out = p_comp_i_comp_s_net;
  assign tvalid_delay_q_net = valid_in;
  assign delta_from_baseline_s_net = data_in;
  assign logical_y_net = init_in;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  sdm_r_xlmult #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(32),
    .b_arith(`xlSigned),
    .b_bin_pt(16),
    .b_width(16),
    .c_a_type(0),
    .c_a_width(32),
    .c_b_type(0),
    .c_b_width(16),
    .c_baat(32),
    .c_output_width(48),
    .c_type(0),
    .core_name0("sdm_r_mult_gen_v12_0_i0"),
    .extra_registers(0),
    .multsign(2),
    .overflow(1),
    .p_arith(`xlSigned),
    .p_bin_pt(20),
    .p_width(48),
    .quantization(1)
  )
  i_n_1_e_n_i_dt (
    .clr(1'b0),
    .core_clr(1'b1),
    .en(1'b1),
    .rst(1'b0),
    .a(accumulator_q_net),
    .b(i_dt_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .core_clk(clk_net),
    .core_ce(ce_net),
    .p(i_n_1_e_n_i_dt_p_net)
  );
  sysgen_accum_07f206b782 accumulator (
    .clr(1'b0),
    .b(delta_from_baseline_s_net),
    .rst(logical_y_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .q(accumulator_q_net)
  );
  sysgen_constant_1bbc8f5d8c i_dt (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(i_dt_op_net)
  );
  sysgen_inverter_1aa041e064 inverter (
    .clr(1'b0),
    .ip(tvalid_delay_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(inverter_op_net)
  );
  sysgen_logical_4420769c0d logical (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d0(inverter_op_net),
    .d1(logical_y_net),
    .y(logical_y_net_x0)
  );
  sysgen_constant_8875d96f2c p (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(p_op_net)
  );
  sdm_r_xlmult #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(21),
    .b_arith(`xlSigned),
    .b_bin_pt(16),
    .b_width(16),
    .c_a_type(0),
    .c_a_width(21),
    .c_b_type(0),
    .c_b_width(16),
    .c_baat(21),
    .c_output_width(37),
    .c_type(0),
    .core_name0("sdm_r_mult_gen_v12_0_i2"),
    .extra_registers(0),
    .multsign(2),
    .overflow(1),
    .p_arith(`xlSigned),
    .p_bin_pt(20),
    .p_width(37),
    .quantization(1)
  )
  p_e_n (
    .clr(1'b0),
    .core_clr(1'b1),
    .en(1'b1),
    .rst(1'b0),
    .a(delta_from_baseline_s_net),
    .b(p_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .core_clk(clk_net),
    .core_ce(ce_net),
    .p(p_e_n_p_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(20),
    .a_width(37),
    .b_arith(`xlSigned),
    .b_bin_pt(20),
    .b_width(48),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(49),
    .core_name0("sdm_r_c_addsub_v12_0_i4"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(49),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(20),
    .s_width(49)
  )
  p_comp_i_comp (
    .clr(1'b0),
    .en(1'b1),
    .a(p_e_n_p_net),
    .b(i_n_1_e_n_i_dt_p_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(p_comp_i_comp_s_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/xil_dblc_delta_calc
module sdm_r_xil_dblc_delta_calc (
  input [1-1:0] valid_in,
  input [19-1:0] data_in,
  input [16-1:0] blc_data_in,
  input [16-1:0] baseline_in,
  input clk_1,
  input ce_1,
  output [21-1:0] delta_data_out,
  output [1-1:0] init_pid
);
  wire [21-1:0] delta_from_baseline_s_net;
  wire [1-1:0] logical_y_net;
  wire [1-1:0] tvalid_delay_q_net;
  wire [16-1:0] constant_op_net;
  wire [16-1:0] convert_to_dac_data_dout_net;
  wire [1-1:0] isnot_undershoot_op_net;
  wire [1-1:0] no_operation_op_net;
  wire [20-1:0] digital_blc_s_net;
  wire [16-1:0] convert_dout_net;
  wire [19-1:0] shift_op_net;
  wire clk_net;
  wire ce_net;
  assign delta_data_out = delta_from_baseline_s_net;
  assign init_pid = logical_y_net;
  assign tvalid_delay_q_net = valid_in;
  assign shift_op_net = data_in;
  assign convert_to_dac_data_dout_net = blc_data_in;
  assign convert_dout_net = baseline_in;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  sysgen_constant_ebb10e85a8 constant (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(constant_op_net)
  );
  sysgen_logical_ccb50d6caa logical (
    .clr(1'b0),
    .d0(isnot_undershoot_op_net),
    .d1(no_operation_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .y(logical_y_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(20),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(21),
    .core_name0("sdm_r_c_addsub_v12_0_i7"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(21),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(21)
  )
  delta_from_baseline (
    .clr(1'b0),
    .en(1'b1),
    .a(digital_blc_s_net),
    .b(convert_dout_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(delta_from_baseline_s_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(19),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(1),
    .c_output_width(20),
    .core_name0("sdm_r_c_addsub_v12_0_i8"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(20),
    .latency(1),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(4),
    .s_width(20)
  )
  digital_blc (
    .clr(1'b0),
    .en(1'b1),
    .a(shift_op_net),
    .b(convert_to_dac_data_dout_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(digital_blc_s_net)
  );
  sysgen_relational_412275f39b isnot_undershoot (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .a(shift_op_net),
    .b(convert_dout_net),
    .op(isnot_undershoot_op_net)
  );
  sysgen_relational_40dc4aaf40 no_operation (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .a(convert_to_dac_data_dout_net),
    .b(constant_op_net),
    .op(no_operation_op_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r/xil_dblc_smoothing
module sdm_r_xil_dblc_smoothing (
  input [49-1:0] data_in,
  input clk_1,
  input ce_1,
  output [50-1:0] data_out
);
  wire clk_net;
  wire [49-1:0] p_comp_i_comp_s_net;
  wire ce_net;
  wire [50-1:0] x2sample_ave_op_net;
  wire [49-1:0] last_sample_q_net;
  wire [50-1:0] x2sample_sum_s_net;
  assign data_out = x2sample_ave_op_net;
  assign p_comp_i_comp_s_net = data_in;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  sysgen_shift_3a84be4a76 x2sample_ave (
    .clr(1'b0),
    .ip(x2sample_sum_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(x2sample_ave_op_net)
  );
  sdm_r_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(20),
    .a_width(49),
    .b_arith(`xlSigned),
    .b_bin_pt(20),
    .b_width(49),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(50),
    .core_name0("sdm_r_c_addsub_v12_0_i6"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(50),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(20),
    .s_width(50)
  )
  x2sample_sum (
    .clr(1'b0),
    .en(1'b1),
    .a(p_comp_i_comp_s_net),
    .b(last_sample_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(x2sample_sum_s_net)
  );
  sdm_r_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(49)
  )
  last_sample (
    .en(1'b1),
    .rst(1'b0),
    .d(p_comp_i_comp_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(last_sample_q_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block sdm_r_struct
module sdm_r_struct (
  input [13-1:0] h_gain_baseline,
  input [128-1:0] h_s_axis_tdata,
  input [1-1:0] h_s_axis_tvalid,
  input [32-1:0] l_s_axis_tdata,
  input [1-1:0] l_s_axis_tvalid,
  input clk_1,
  input ce_1,
  output [16-1:0] dac_m_axis_tdata,
  output [1-1:0] dac_m_axis_tvalid,
  output [16-1:0] digital_baseline,
  output [128-1:0] dsp_m_axis_tdata,
  output [1-1:0] dsp_m_axis_tvalid,
  output [128-1:0] h_m_axis_tdata,
  output [1-1:0] h_m_axis_tvalid,
  output [32-1:0] l_m_axis_tdata,
  output [1-1:0] l_m_axis_tvalid
);
  wire [32-1:0] l_s_axis_tdata_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire clk_net;
  wire [1-1:0] l_gain_tvalid_delay_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net_x0;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [128-1:0] concat1_y_net_x0;
  wire ce_net;
  wire [1-1:0] l_s_axis_tvalid_net;
  wire [128-1:0] h_s_axis_tdata_net;
  wire [1-1:0] delay_q_net_x0;
  wire [1-1:0] h_s_axis_tvalid_net;
  wire [16-1:0] convert_to_dac_input_dout_net;
  wire [32-1:0] l_gain_tdata_delay_q_net;
  wire [1-1:0] tvalid_delay_q_net;
  wire [1-1:0] valid_delay_q_net;
  wire [13-1:0] h_gain_baseline_net;
  wire [128-1:0] concat1_y_net;
  wire [19-1:0] shift_op_net;
  wire [16-1:0] cast_dbl_out_dout_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] addsub2_s_net;
  wire [1-1:0] delay_q_net;
  wire [16-1:0] addsub5_s_net;
  wire [16-1:0] delay4_q_net_x0;
  wire [16-1:0] slice5_y_net;
  wire [50-1:0] x2sample_ave_op_net;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] delay5_q_net_x0;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice7_y_net;
  wire [49-1:0] p_comp_i_comp_s_net;
  wire [16-1:0] convert_to_dac_data_dout_net;
  wire [16-1:0] delay2_q_net_x0;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] addsub7_s_net;
  wire [21-1:0] delta_from_baseline_s_net;
  wire [16-1:0] delay1_q_net_x0;
  wire [16-1:0] addsub1_s_net;
  wire [16-1:0] delay3_q_net_x0;
  wire [16-1:0] convert_dout_net;
  wire [16-1:0] delay5_q_net;
  wire [49-1:0] p_comp_i_comp_s_net_x0;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] addsub3_s_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  wire [50-1:0] x2sample_ave_op_net_x0;
  wire [1-1:0] logical_y_net;
  wire [16-1:0] addsub6_s_net;
  wire [16-1:0] addsub0_s_net;
  wire [16-1:0] delay6_q_net_x0;
  wire [16-1:0] delay0_q_net_x0;
  wire [16-1:0] addsub4_s_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] delay0_q_net;
  wire [20-1:0] delta_from_baseline_s_net_x0;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay7_q_net_x0;
  wire [1-1:0] logical_y_net_x0;
  assign dac_m_axis_tdata = convert_to_dac_input_dout_net;
  assign dac_m_axis_tvalid = valid_delay_q_net;
  assign digital_baseline = cast_dbl_out_dout_net;
  assign dsp_m_axis_tdata = concat1_y_net_x0;
  assign dsp_m_axis_tvalid = delay_q_net_x0;
  assign h_gain_baseline_net = h_gain_baseline;
  assign h_m_axis_tdata = concat1_y_net;
  assign h_m_axis_tvalid = delay_q_net_x0;
  assign h_s_axis_tdata_net = h_s_axis_tdata;
  assign h_s_axis_tvalid_net = h_s_axis_tvalid;
  assign l_m_axis_tdata = l_gain_tdata_delay_q_net;
  assign l_m_axis_tvalid = l_gain_tvalid_delay_q_net;
  assign l_s_axis_tdata_net = l_s_axis_tdata;
  assign l_s_axis_tvalid_net = l_s_axis_tvalid;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  sdm_r_8sample_average x8sample_average (
    .valid_in(h_s_axis_tvalid_net),
    .data_in_1(reinterpret0_output_port_net),
    .data_in_2(reinterpret1_output_port_net),
    .data_in_3(reinterpret2_output_port_net),
    .data_in_4(reinterpret3_output_port_net),
    .data_in_5(reinterpret4_output_port_net),
    .data_in_6(reinterpret5_output_port_net),
    .data_in_7(reinterpret6_output_port_net),
    .data_in_8(reinterpret7_output_port_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .ave_valid_out(tvalid_delay_q_net),
    .ave_data_out(shift_op_net)
  );
  sdm_r_dbl_scalar2vector dbl_scalar2vector (
    .in1(convert_to_dac_data_dout_net),
    .out1_1(reinterpret0_output_port_net_x0),
    .out1_2(reinterpret1_output_port_net_x0),
    .out1_3(reinterpret2_output_port_net_x0),
    .out1_4(reinterpret3_output_port_net_x0),
    .out1_5(reinterpret4_output_port_net_x0),
    .out1_6(reinterpret5_output_port_net_x0),
    .out1_7(reinterpret6_output_port_net_x0),
    .out1_8(reinterpret7_output_port_net_x0)
  );
  sdm_r_dsp_vector2scalar dsp_vector2scalar (
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
  sdm_r_dsp_delay dsp_delay (
    .d_1(reinterpret0_output_port_net),
    .d_2(reinterpret1_output_port_net),
    .d_3(reinterpret2_output_port_net),
    .d_4(reinterpret3_output_port_net),
    .d_5(reinterpret4_output_port_net),
    .d_6(reinterpret5_output_port_net),
    .d_7(reinterpret6_output_port_net),
    .d_8(reinterpret7_output_port_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .q_1(delay0_q_net_x0),
    .q_2(delay1_q_net_x0),
    .q_3(delay2_q_net_x0),
    .q_4(delay3_q_net_x0),
    .q_5(delay4_q_net_x0),
    .q_6(delay5_q_net),
    .q_7(delay6_q_net_x0),
    .q_8(delay7_q_net)
  );
  sdm_r_hgain_vector2scalar hgain_vector2scalar (
    .in1_1(delay0_q_net),
    .in1_2(delay1_q_net),
    .in1_3(delay2_q_net),
    .in1_4(delay3_q_net),
    .in1_5(delay4_q_net),
    .in1_6(delay5_q_net_x0),
    .in1_7(delay6_q_net),
    .in1_8(delay7_q_net_x0),
    .out1(concat1_y_net)
  );
  sdm_r_hgain_delay hgain_delay (
    .d_1(delay0_q_net_x0),
    .d_2(delay1_q_net_x0),
    .d_3(delay2_q_net_x0),
    .d_4(delay3_q_net_x0),
    .d_5(delay4_q_net_x0),
    .d_6(delay5_q_net),
    .d_7(delay6_q_net_x0),
    .d_8(delay7_q_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .q_1(delay0_q_net),
    .q_2(delay1_q_net),
    .q_3(delay2_q_net),
    .q_4(delay3_q_net),
    .q_5(delay4_q_net),
    .q_6(delay5_q_net_x0),
    .q_7(delay6_q_net),
    .q_8(delay7_q_net_x0)
  );
  sdm_r_scalar2vector_x0 scalar2vector (
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
  sdm_r_vector_addsub_fabric vector_addsub_fabric (
    .a_1(delay0_q_net_x0),
    .b_1(reinterpret0_output_port_net_x0),
    .a_2(delay1_q_net_x0),
    .a_3(delay2_q_net_x0),
    .a_4(delay3_q_net_x0),
    .a_5(delay4_q_net_x0),
    .a_6(delay5_q_net),
    .a_7(delay6_q_net_x0),
    .a_8(delay7_q_net),
    .b_2(reinterpret1_output_port_net_x0),
    .b_3(reinterpret2_output_port_net_x0),
    .b_4(reinterpret3_output_port_net_x0),
    .b_5(reinterpret4_output_port_net_x0),
    .b_6(reinterpret5_output_port_net_x0),
    .b_7(reinterpret6_output_port_net_x0),
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
  sdm_r_vector_reinterpret_x1 vector_reinterpret (
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
  sdm_r_xil_dac_pid xil_dac_pid (
    .valid_in(tvalid_delay_q_net),
    .data_in(delta_from_baseline_s_net_x0),
    .init_in(logical_y_net_x0),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .valid_out(delay_q_net),
    .pid_data_out(p_comp_i_comp_s_net_x0)
  );
  sdm_r_xil_dac_delta_calc xil_dac_delta_calc (
    .valid_in(tvalid_delay_q_net),
    .data_in(shift_op_net),
    .dac_data_in(convert_to_dac_input_dout_net),
    .baseline_in(convert_dout_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .delta_data_out(delta_from_baseline_s_net_x0),
    .init_pid(logical_y_net_x0)
  );
  sdm_r_xil_dac_smoothing xil_dac_smoothing (
    .data_in(p_comp_i_comp_s_net_x0),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .data_out(x2sample_ave_op_net_x0)
  );
  sdm_r_xil_dblc_pid xil_dblc_pid (
    .valid_in(tvalid_delay_q_net),
    .data_in(delta_from_baseline_s_net),
    .init_in(logical_y_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .pid_data_out(p_comp_i_comp_s_net)
  );
  sdm_r_xil_dblc_delta_calc xil_dblc_delta_calc (
    .valid_in(tvalid_delay_q_net),
    .data_in(shift_op_net),
    .blc_data_in(convert_to_dac_data_dout_net),
    .baseline_in(convert_dout_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .delta_data_out(delta_from_baseline_s_net),
    .init_pid(logical_y_net)
  );
  sdm_r_xil_dblc_smoothing xil_dblc_smoothing (
    .data_in(p_comp_i_comp_s_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .data_out(x2sample_ave_op_net)
  );
  sdm_r_xlconvert #(
    .bool_conversion(0),
    .din_arith(2),
    .din_bin_pt(0),
    .din_width(13),
    .dout_arith(2),
    .dout_bin_pt(4),
    .dout_width(16),
    .latency(0),
    .overflow(`xlWrap),
    .quantization(`xlTruncate)
  )
  convert (
    .clr(1'b0),
    .en(1'b1),
    .din(h_gain_baseline_net),
    .clk(clk_net),
    .ce(ce_net),
    .dout(convert_dout_net)
  );
  sdm_r_xldelay #(
    .latency(6),
    .reg_retiming(0),
    .reset(0),
    .width(1)
  )
  delay (
    .en(1'b1),
    .rst(1'b0),
    .d(tvalid_delay_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay_q_net_x0)
  );
  sdm_r_xldelay #(
    .latency(6),
    .reg_retiming(0),
    .reset(0),
    .width(32)
  )
  l_gain_tdata_delay (
    .en(1'b1),
    .rst(1'b0),
    .d(l_s_axis_tdata_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(l_gain_tdata_delay_q_net)
  );
  sdm_r_xldelay #(
    .latency(6),
    .reg_retiming(0),
    .reset(0),
    .width(1)
  )
  l_gain_tvalid_delay (
    .en(1'b1),
    .rst(1'b0),
    .d(l_s_axis_tvalid_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(l_gain_tvalid_delay_q_net)
  );
  sdm_r_xlconvert #(
    .bool_conversion(0),
    .din_arith(2),
    .din_bin_pt(4),
    .din_width(16),
    .dout_arith(2),
    .dout_bin_pt(0),
    .dout_width(16),
    .latency(1),
    .overflow(`xlWrap),
    .quantization(`xlTruncate)
  )
  cast_dbl_out (
    .clr(1'b0),
    .en(1'b1),
    .din(convert_to_dac_data_dout_net),
    .clk(clk_net),
    .ce(ce_net),
    .dout(cast_dbl_out_dout_net)
  );
  sdm_r_xlconvert #(
    .bool_conversion(0),
    .din_arith(2),
    .din_bin_pt(20),
    .din_width(50),
    .dout_arith(2),
    .dout_bin_pt(4),
    .dout_width(16),
    .latency(1),
    .overflow(`xlSaturate),
    .quantization(`xlTruncate)
  )
  convert_to_dac_data (
    .clr(1'b0),
    .en(1'b1),
    .din(x2sample_ave_op_net),
    .clk(clk_net),
    .ce(ce_net),
    .dout(convert_to_dac_data_dout_net)
  );
  sdm_r_xlconvert #(
    .bool_conversion(0),
    .din_arith(2),
    .din_bin_pt(20),
    .din_width(50),
    .dout_arith(2),
    .dout_bin_pt(2),
    .dout_width(16),
    .latency(1),
    .overflow(`xlSaturate),
    .quantization(`xlTruncate)
  )
  convert_to_dac_input (
    .clr(1'b0),
    .en(1'b1),
    .din(x2sample_ave_op_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .dout(convert_to_dac_input_dout_net)
  );
  sdm_r_xldelay #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(1)
  )
  valid_delay (
    .en(1'b1),
    .rst(1'b0),
    .d(delay_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(valid_delay_q_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
module sdm_r_default_clock_driver (
  input sdm_r_sysclk,
  input sdm_r_sysce,
  input sdm_r_sysclr,
  output sdm_r_clk1,
  output sdm_r_ce1
);
  xlclockdriver #(
    .period(1),
    .log_2_period(1)
  )
  clockdriver (
    .sysclk(sdm_r_sysclk),
    .sysce(sdm_r_sysce),
    .sysclr(sdm_r_sysclr),
    .clk(sdm_r_clk1),
    .ce(sdm_r_ce1)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
(* core_generation_info = "sdm_r,sysgen_core_2019_1,{,compilation=IP Catalog,block_icon_display=Default,family=zynquplusRFSOC,part=xczu29dr,speed=-1-e,package=ffvf1760,synthesis_language=verilog,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=1,interface_doc=1,ce_clr=0,clock_period=8,system_simulink_period=8e-09,waveform_viewer=0,axilite_interface=0,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=0.0001,accum=2,addsub=22,concat=4,constant=6,convert=4,delay=24,inv=2,logical=4,mult=4,reinterpret=49,relational=4,shift=3,slice=24,}" *)
module sdm_r (
  input [13-1:0] h_gain_baseline,
  input [128-1:0] h_s_axis_tdata,
  input [1-1:0] h_s_axis_tvalid,
  input [32-1:0] l_s_axis_tdata,
  input [1-1:0] l_s_axis_tvalid,
  input clk,
  output [16-1:0] dac_m_axis_tdata,
  output [1-1:0] dac_m_axis_tvalid,
  output [16-1:0] digital_baseline,
  output [128-1:0] dsp_m_axis_tdata,
  output [1-1:0] dsp_m_axis_tvalid,
  output [128-1:0] h_m_axis_tdata,
  output [1-1:0] h_m_axis_tvalid,
  output [32-1:0] l_m_axis_tdata,
  output [1-1:0] l_m_axis_tvalid
);
  wire clk_1_net;
  wire ce_1_net;
  sdm_r_default_clock_driver sdm_r_default_clock_driver (
    .sdm_r_sysclk(clk),
    .sdm_r_sysce(1'b1),
    .sdm_r_sysclr(1'b0),
    .sdm_r_clk1(clk_1_net),
    .sdm_r_ce1(ce_1_net)
  );
  sdm_r_struct sdm_r_struct (
    .h_gain_baseline(h_gain_baseline),
    .h_s_axis_tdata(h_s_axis_tdata),
    .h_s_axis_tvalid(h_s_axis_tvalid),
    .l_s_axis_tdata(l_s_axis_tdata),
    .l_s_axis_tvalid(l_s_axis_tvalid),
    .clk_1(clk_1_net),
    .ce_1(ce_1_net),
    .dac_m_axis_tdata(dac_m_axis_tdata),
    .dac_m_axis_tvalid(dac_m_axis_tvalid),
    .digital_baseline(digital_baseline),
    .dsp_m_axis_tdata(dsp_m_axis_tdata),
    .dsp_m_axis_tvalid(dsp_m_axis_tvalid),
    .h_m_axis_tdata(h_m_axis_tdata),
    .h_m_axis_tvalid(h_m_axis_tvalid),
    .l_m_axis_tdata(l_m_axis_tdata),
    .l_m_axis_tvalid(l_m_axis_tvalid)
  );
endmodule
