`ifndef xlConvPkgIncluded
`include "conv_pkg.v"
`endif

`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_InputOnly/DSP_Vector2Scalar/Vector Slice
module dsp_blr_inputonly_vector_slice (
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
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  assign out_1 = slice0_y_net;
  assign out_2 = slice1_y_net;
  assign out_3 = slice2_y_net;
  assign out_4 = slice3_y_net;
  assign out_5 = slice4_y_net;
  assign out_6 = slice5_y_net;
  assign out_7 = slice6_y_net;
  assign out_8 = slice7_y_net;
  assign reinterpret0_output_port_net = in_1;
  assign reinterpret1_output_port_net = in_2;
  assign reinterpret2_output_port_net = in_3;
  assign reinterpret3_output_port_net = in_4;
  assign reinterpret4_output_port_net = in_5;
  assign reinterpret5_output_port_net = in_6;
  assign reinterpret6_output_port_net = in_7;
  assign reinterpret7_output_port_net = in_8;
  dsp_blr_inputonly_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(16),
    .y_width(16)
  )
  slice0 (
    .x(reinterpret0_output_port_net),
    .y(slice0_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(16),
    .y_width(16)
  )
  slice1 (
    .x(reinterpret1_output_port_net),
    .y(slice1_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(16),
    .y_width(16)
  )
  slice2 (
    .x(reinterpret2_output_port_net),
    .y(slice2_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(16),
    .y_width(16)
  )
  slice3 (
    .x(reinterpret3_output_port_net),
    .y(slice3_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(16),
    .y_width(16)
  )
  slice4 (
    .x(reinterpret4_output_port_net),
    .y(slice4_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(16),
    .y_width(16)
  )
  slice5 (
    .x(reinterpret5_output_port_net),
    .y(slice5_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(16),
    .y_width(16)
  )
  slice6 (
    .x(reinterpret6_output_port_net),
    .y(slice6_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(16),
    .y_width(16)
  )
  slice7 (
    .x(reinterpret7_output_port_net),
    .y(slice7_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_InputOnly/DSP_Vector2Scalar/Vector2Scalar
module dsp_blr_inputonly_vector2scalar (
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
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice3_y_net;
  assign o = concat1_y_net;
  assign slice0_y_net = i_1;
  assign slice1_y_net = i_2;
  assign slice2_y_net = i_3;
  assign slice3_y_net = i_4;
  assign slice4_y_net = i_5;
  assign slice5_y_net = i_6;
  assign slice6_y_net = i_7;
  assign slice7_y_net = i_8;
  sysgen_concat_ffef464e00 concat1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .in0(slice7_y_net),
    .in1(slice6_y_net),
    .in2(slice5_y_net),
    .in3(slice4_y_net),
    .in4(slice3_y_net),
    .in5(slice2_y_net),
    .in6(slice1_y_net),
    .in7(slice0_y_net),
    .y(concat1_y_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_InputOnly/DSP_Vector2Scalar/Vector_reinterpret2unsigned
module dsp_blr_inputonly_vector_reinterpret2unsigned (
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
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] delay0_q_net;
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
  sysgen_reinterpret_65879cbbc3 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay0_q_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay1_q_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay2_q_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay3_q_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay4_q_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay5_q_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay6_q_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay7_q_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_InputOnly/DSP_Vector2Scalar
module dsp_blr_inputonly_dsp_vector2scalar (
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
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay1_q_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] reinterpret1_output_port_net;
  assign out1 = concat1_y_net;
  assign delay0_q_net = in1_1;
  assign delay1_q_net = in1_2;
  assign delay2_q_net = in1_3;
  assign delay3_q_net = in1_4;
  assign delay4_q_net = in1_5;
  assign delay5_q_net = in1_6;
  assign delay6_q_net = in1_7;
  assign delay7_q_net = in1_8;
  dsp_blr_inputonly_vector_slice vector_slice (
    .in_1(reinterpret0_output_port_net),
    .in_2(reinterpret1_output_port_net),
    .in_3(reinterpret2_output_port_net),
    .in_4(reinterpret3_output_port_net),
    .in_5(reinterpret4_output_port_net),
    .in_6(reinterpret5_output_port_net),
    .in_7(reinterpret6_output_port_net),
    .in_8(reinterpret7_output_port_net),
    .out_1(slice0_y_net),
    .out_2(slice1_y_net),
    .out_3(slice2_y_net),
    .out_4(slice3_y_net),
    .out_5(slice4_y_net),
    .out_6(slice5_y_net),
    .out_7(slice6_y_net),
    .out_8(slice7_y_net)
  );
  dsp_blr_inputonly_vector2scalar vector2scalar (
    .i_1(slice0_y_net),
    .i_2(slice1_y_net),
    .i_3(slice2_y_net),
    .i_4(slice3_y_net),
    .i_5(slice4_y_net),
    .i_6(slice5_y_net),
    .i_7(slice6_y_net),
    .i_8(slice7_y_net),
    .o(concat1_y_net)
  );
  dsp_blr_inputonly_vector_reinterpret2unsigned vector_reinterpret2unsigned (
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
// Generated from Simulink block dsp_blr_InputOnly/DSP_delay
module dsp_blr_inputonly_dsp_delay (
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
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire clk_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay4_q_net;
  wire ce_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
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
  dsp_blr_inputonly_xldelay #(
    .latency(2),
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
  dsp_blr_inputonly_xldelay #(
    .latency(2),
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
  dsp_blr_inputonly_xldelay #(
    .latency(2),
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
  dsp_blr_inputonly_xldelay #(
    .latency(2),
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
  dsp_blr_inputonly_xldelay #(
    .latency(2),
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
  dsp_blr_inputonly_xldelay #(
    .latency(2),
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
  dsp_blr_inputonly_xldelay #(
    .latency(2),
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
  dsp_blr_inputonly_xldelay #(
    .latency(2),
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
// Generated from Simulink block dsp_blr_InputOnly/HGAIN_Vector2Scalar/Vector2Scalar
module dsp_blr_inputonly_vector2scalar_x0 (
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
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
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
  sysgen_concat_ffef464e00 concat1 (
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
// Generated from Simulink block dsp_blr_InputOnly/HGAIN_Vector2Scalar/Vector_reinterpret2unsigned
module dsp_blr_inputonly_vector_reinterpret2unsigned_x0 (
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
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay3_q_net;
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
  sysgen_reinterpret_65879cbbc3 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay0_q_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay1_q_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay2_q_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay3_q_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay4_q_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay5_q_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay6_q_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_65879cbbc3 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay7_q_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_InputOnly/HGAIN_Vector2Scalar
module dsp_blr_inputonly_hgain_vector2scalar (
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
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  assign out1 = concat1_y_net;
  assign delay0_q_net = in1_1;
  assign delay1_q_net = in1_2;
  assign delay2_q_net = in1_3;
  assign delay3_q_net = in1_4;
  assign delay4_q_net = in1_5;
  assign delay5_q_net = in1_6;
  assign delay6_q_net = in1_7;
  assign delay7_q_net = in1_8;
  dsp_blr_inputonly_vector2scalar_x0 vector2scalar (
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
  dsp_blr_inputonly_vector_reinterpret2unsigned_x0 vector_reinterpret2unsigned (
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
// Generated from Simulink block dsp_blr_InputOnly/HGAIN_delay
module dsp_blr_inputonly_hgain_delay (
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
  wire [16-1:0] delay4_q_net_x0;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay3_q_net_x0;
  wire [16-1:0] delay5_q_net_x0;
  wire [16-1:0] delay6_q_net_x0;
  wire [16-1:0] delay7_q_net_x0;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay1_q_net_x0;
  wire [16-1:0] delay0_q_net_x0;
  wire clk_net;
  wire [16-1:0] delay6_q_net;
  wire ce_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay2_q_net_x0;
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
  dsp_blr_inputonly_xldelay #(
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
  dsp_blr_inputonly_xldelay #(
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
  dsp_blr_inputonly_xldelay #(
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
  dsp_blr_inputonly_xldelay #(
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
  dsp_blr_inputonly_xldelay #(
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
  dsp_blr_inputonly_xldelay #(
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
  dsp_blr_inputonly_xldelay #(
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
  dsp_blr_inputonly_xldelay #(
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
// Generated from Simulink block dsp_blr_InputOnly/Scalar2Vector
module dsp_blr_inputonly_scalar2vector (
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
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice1_y_net;
  wire [128-1:0] h_s_axis_tdata_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice6_y_net;
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
  dsp_blr_inputonly_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice0 (
    .x(h_s_axis_tdata_net),
    .y(slice0_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(h_s_axis_tdata_net),
    .y(slice1_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(h_s_axis_tdata_net),
    .y(slice2_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(h_s_axis_tdata_net),
    .y(slice3_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(h_s_axis_tdata_net),
    .y(slice4_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(h_s_axis_tdata_net),
    .y(slice5_y_net)
  );
  dsp_blr_inputonly_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(h_s_axis_tdata_net),
    .y(slice6_y_net)
  );
  dsp_blr_inputonly_xlslice #(
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
// Generated from Simulink block dsp_blr_InputOnly/Vector Reinterpret
module dsp_blr_inputonly_vector_reinterpret (
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
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] slice7_y_net;
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
  sysgen_reinterpret_39bde6c994 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice0_y_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_39bde6c994 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_39bde6c994 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_39bde6c994 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_39bde6c994 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_39bde6c994 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_39bde6c994 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_39bde6c994 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_InputOnly_struct
module dsp_blr_inputonly_struct (
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
  wire [128-1:0] concat1_y_net;
  wire [128-1:0] concat1_y_net_x0;
  wire [128-1:0] h_s_axis_tdata_net;
  wire [1-1:0] h_s_axis_tvalid_net;
  wire [32-1:0] l_gain_tdata_delay_q_net;
  wire [1-1:0] l_gain_tvalid_delay_q_net;
  wire [1-1:0] delay_q_net;
  wire [32-1:0] l_s_axis_tdata_net;
  wire [1-1:0] l_s_axis_tvalid_net;
  wire [16-1:0] delay1_q_net_x0;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] delay4_q_net_x0;
  wire [16-1:0] delay0_q_net_x0;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] delay2_q_net_x0;
  wire [16-1:0] delay6_q_net_x0;
  wire ce_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay5_q_net_x0;
  wire [16-1:0] slice2_y_net;
  wire clk_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] delay3_q_net_x0;
  wire [16-1:0] delay7_q_net_x0;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice4_y_net;
  assign dsp_m_axis_tdata = concat1_y_net;
  assign dsp_m_axis_tvalid = delay_q_net;
  assign h_m_axis_tdata = concat1_y_net_x0;
  assign h_m_axis_tvalid = delay_q_net;
  assign h_s_axis_tdata_net = h_s_axis_tdata;
  assign h_s_axis_tvalid_net = h_s_axis_tvalid;
  assign l_m_axis_tdata = l_gain_tdata_delay_q_net;
  assign l_m_axis_tvalid = l_gain_tvalid_delay_q_net;
  assign l_s_axis_tdata_net = l_s_axis_tdata;
  assign l_s_axis_tvalid_net = l_s_axis_tvalid;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_inputonly_dsp_vector2scalar dsp_vector2scalar (
    .in1_1(delay0_q_net_x0),
    .in1_2(delay1_q_net),
    .in1_3(delay2_q_net),
    .in1_4(delay3_q_net),
    .in1_5(delay4_q_net),
    .in1_6(delay5_q_net),
    .in1_7(delay6_q_net),
    .in1_8(delay7_q_net),
    .out1(concat1_y_net)
  );
  dsp_blr_inputonly_dsp_delay dsp_delay (
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
    .q_2(delay1_q_net),
    .q_3(delay2_q_net),
    .q_4(delay3_q_net),
    .q_5(delay4_q_net),
    .q_6(delay5_q_net),
    .q_7(delay6_q_net),
    .q_8(delay7_q_net)
  );
  dsp_blr_inputonly_hgain_vector2scalar hgain_vector2scalar (
    .in1_1(delay0_q_net),
    .in1_2(delay1_q_net_x0),
    .in1_3(delay2_q_net_x0),
    .in1_4(delay3_q_net_x0),
    .in1_5(delay4_q_net_x0),
    .in1_6(delay5_q_net_x0),
    .in1_7(delay6_q_net_x0),
    .in1_8(delay7_q_net_x0),
    .out1(concat1_y_net_x0)
  );
  dsp_blr_inputonly_hgain_delay hgain_delay (
    .d_1(delay0_q_net_x0),
    .d_2(delay1_q_net),
    .d_3(delay2_q_net),
    .d_4(delay3_q_net),
    .d_5(delay4_q_net),
    .d_6(delay5_q_net),
    .d_7(delay6_q_net),
    .d_8(delay7_q_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .q_1(delay0_q_net),
    .q_2(delay1_q_net_x0),
    .q_3(delay2_q_net_x0),
    .q_4(delay3_q_net_x0),
    .q_5(delay4_q_net_x0),
    .q_6(delay5_q_net_x0),
    .q_7(delay6_q_net_x0),
    .q_8(delay7_q_net_x0)
  );
  dsp_blr_inputonly_scalar2vector scalar2vector (
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
  dsp_blr_inputonly_vector_reinterpret vector_reinterpret (
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
  dsp_blr_inputonly_xldelay #(
    .latency(2),
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
  sysgen_delay_095bf5f7a2 l_gain_tdata_delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(l_s_axis_tdata_net),
    .q(l_gain_tdata_delay_q_net)
  );
  sysgen_delay_30a3655fd4 l_gain_tvalid_delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(l_s_axis_tvalid_net),
    .q(l_gain_tvalid_delay_q_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
module dsp_blr_inputonly_default_clock_driver (
  input dsp_blr_inputonly_sysclk,
  input dsp_blr_inputonly_sysce,
  input dsp_blr_inputonly_sysclr,
  output dsp_blr_inputonly_clk1,
  output dsp_blr_inputonly_ce1
);
  xlclockdriver #(
    .period(1),
    .log_2_period(1)
  )
  clockdriver (
    .sysclk(dsp_blr_inputonly_sysclk),
    .sysce(dsp_blr_inputonly_sysce),
    .sysclr(dsp_blr_inputonly_sysclr),
    .clk(dsp_blr_inputonly_clk1),
    .ce(dsp_blr_inputonly_ce1)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
(* core_generation_info = "dsp_blr_inputonly,sysgen_core_2019_1,{,compilation=IP Catalog,block_icon_display=Default,family=zynquplusRFSOC,part=xczu29dr,speed=-1-e,package=ffvf1760,synthesis_language=verilog,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=1,interface_doc=1,ce_clr=0,clock_period=8,system_simulink_period=8e-09,waveform_viewer=1,axilite_interface=0,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=0.0001,concat=2,delay=19,reinterpret=24,slice=16,}" *)
module dsp_blr_inputonly (
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
  dsp_blr_inputonly_default_clock_driver dsp_blr_inputonly_default_clock_driver (
    .dsp_blr_inputonly_sysclk(clk),
    .dsp_blr_inputonly_sysce(1'b1),
    .dsp_blr_inputonly_sysclr(1'b0),
    .dsp_blr_inputonly_clk1(clk_1_net),
    .dsp_blr_inputonly_ce1(ce_1_net)
  );
  dsp_blr_inputonly_struct dsp_blr_inputonly_struct (
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
