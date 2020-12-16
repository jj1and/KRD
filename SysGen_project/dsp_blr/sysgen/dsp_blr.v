`ifndef xlConvPkgIncluded
`include "conv_pkg.v"
`endif

`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/DSP_Vector2Scalar/Vector2Scalar
module dsp_blr_vector2scalar (
  input [20-1:0] i_1,
  input [20-1:0] i_2,
  input [20-1:0] i_3,
  input [20-1:0] i_4,
  input [20-1:0] i_5,
  input [20-1:0] i_6,
  input [20-1:0] i_7,
  input [20-1:0] i_8,
  output [160-1:0] o
);
  wire [160-1:0] concat1_y_net;
  wire [20-1:0] reinterpret0_output_port_net;
  wire [20-1:0] reinterpret2_output_port_net;
  wire [20-1:0] reinterpret7_output_port_net;
  wire [20-1:0] reinterpret5_output_port_net;
  wire [20-1:0] reinterpret6_output_port_net;
  wire [20-1:0] reinterpret4_output_port_net;
  wire [20-1:0] reinterpret3_output_port_net;
  wire [20-1:0] reinterpret1_output_port_net;
  assign o = concat1_y_net;
  assign reinterpret0_output_port_net = i_1;
  assign reinterpret1_output_port_net = i_2;
  assign reinterpret2_output_port_net = i_3;
  assign reinterpret3_output_port_net = i_4;
  assign reinterpret4_output_port_net = i_5;
  assign reinterpret5_output_port_net = i_6;
  assign reinterpret6_output_port_net = i_7;
  assign reinterpret7_output_port_net = i_8;
  sysgen_concat_f7ce000933 concat1 (
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
// Generated from Simulink block dsp_blr/DSP_Vector2Scalar/Vector_reinterpret2unsigned
module dsp_blr_vector_reinterpret2unsigned_x0 (
  input [20-1:0] in_1,
  input [20-1:0] in_2,
  input [20-1:0] in_3,
  input [20-1:0] in_4,
  input [20-1:0] in_5,
  input [20-1:0] in_6,
  input [20-1:0] in_7,
  input [20-1:0] in_8,
  output [20-1:0] out_1,
  output [20-1:0] out_2,
  output [20-1:0] out_3,
  output [20-1:0] out_4,
  output [20-1:0] out_5,
  output [20-1:0] out_6,
  output [20-1:0] out_7,
  output [20-1:0] out_8
);
  wire [20-1:0] reinterpret1_output_port_net;
  wire [20-1:0] reinterpret2_output_port_net;
  wire [20-1:0] reinterpret3_output_port_net;
  wire [20-1:0] addsub2_s_net;
  wire [20-1:0] reinterpret5_output_port_net;
  wire [20-1:0] addsub4_s_net;
  wire [20-1:0] reinterpret6_output_port_net;
  wire [20-1:0] reinterpret7_output_port_net;
  wire [20-1:0] addsub0_s_net;
  wire [20-1:0] addsub3_s_net;
  wire [20-1:0] addsub7_s_net;
  wire [20-1:0] reinterpret4_output_port_net;
  wire [20-1:0] addsub1_s_net;
  wire [20-1:0] addsub6_s_net;
  wire [20-1:0] addsub5_s_net;
  wire [20-1:0] reinterpret0_output_port_net;
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
  sysgen_reinterpret_ca9e5fad1e reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub0_s_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_ca9e5fad1e reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub1_s_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_ca9e5fad1e reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub2_s_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_ca9e5fad1e reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub3_s_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_ca9e5fad1e reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub4_s_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_ca9e5fad1e reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub5_s_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_ca9e5fad1e reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub6_s_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_ca9e5fad1e reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub7_s_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/DSP_Vector2Scalar
module dsp_blr_dsp_vector2scalar (
  input [20-1:0] in1_1,
  input [20-1:0] in1_2,
  input [20-1:0] in1_3,
  input [20-1:0] in1_4,
  input [20-1:0] in1_5,
  input [20-1:0] in1_6,
  input [20-1:0] in1_7,
  input [20-1:0] in1_8,
  output [160-1:0] out1
);
  wire [20-1:0] reinterpret7_output_port_net;
  wire [20-1:0] reinterpret5_output_port_net;
  wire [20-1:0] reinterpret6_output_port_net;
  wire [160-1:0] concat1_y_net;
  wire [20-1:0] addsub0_s_net;
  wire [20-1:0] addsub2_s_net;
  wire [20-1:0] addsub3_s_net;
  wire [20-1:0] addsub4_s_net;
  wire [20-1:0] addsub5_s_net;
  wire [20-1:0] addsub6_s_net;
  wire [20-1:0] reinterpret1_output_port_net;
  wire [20-1:0] addsub7_s_net;
  wire [20-1:0] reinterpret2_output_port_net;
  wire [20-1:0] reinterpret4_output_port_net;
  wire [20-1:0] addsub1_s_net;
  wire [20-1:0] reinterpret0_output_port_net;
  wire [20-1:0] reinterpret3_output_port_net;
  assign out1 = concat1_y_net;
  assign addsub0_s_net = in1_1;
  assign addsub1_s_net = in1_2;
  assign addsub2_s_net = in1_3;
  assign addsub3_s_net = in1_4;
  assign addsub4_s_net = in1_5;
  assign addsub5_s_net = in1_6;
  assign addsub6_s_net = in1_7;
  assign addsub7_s_net = in1_8;
  dsp_blr_vector2scalar vector2scalar (
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
  dsp_blr_vector_reinterpret2unsigned_x0 vector_reinterpret2unsigned (
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
// Generated from Simulink block dsp_blr/DSP_delay
module dsp_blr_dsp_delay (
  input [16-1:0] d_1,
  input [16-1:0] d_2,
  input [16-1:0] d_3,
  input [16-1:0] d_4,
  input [16-1:0] d_5,
  input [16-1:0] d_6,
  input [16-1:0] d_7,
  input [16-1:0] d_8,
  output [16-1:0] q_1,
  output [16-1:0] q_2,
  output [16-1:0] q_3,
  output [16-1:0] q_4,
  output [16-1:0] q_5,
  output [16-1:0] q_6,
  output [16-1:0] q_7,
  output [16-1:0] q_8
);
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay3_q_net;
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
  sysgen_delay_57402732a5 delay0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(reinterpret0_output_port_net),
    .q(delay0_q_net)
  );
  sysgen_delay_57402732a5 delay1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(reinterpret1_output_port_net),
    .q(delay1_q_net)
  );
  sysgen_delay_57402732a5 delay2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(reinterpret2_output_port_net),
    .q(delay2_q_net)
  );
  sysgen_delay_57402732a5 delay3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(reinterpret3_output_port_net),
    .q(delay3_q_net)
  );
  sysgen_delay_57402732a5 delay4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(reinterpret4_output_port_net),
    .q(delay4_q_net)
  );
  sysgen_delay_57402732a5 delay5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(reinterpret5_output_port_net),
    .q(delay5_q_net)
  );
  sysgen_delay_57402732a5 delay6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(reinterpret6_output_port_net),
    .q(delay6_q_net)
  );
  sysgen_delay_57402732a5 delay7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(reinterpret7_output_port_net),
    .q(delay7_q_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/HGAIN_Vector2Scalar/Vector2Scalar
module dsp_blr_vector2scalar_x0 (
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
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
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
  sysgen_concat_b7528356df concat1 (
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
// Generated from Simulink block dsp_blr/HGAIN_Vector2Scalar/Vector_reinterpret2unsigned
module dsp_blr_vector_reinterpret2unsigned (
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
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay5_q_net;
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
  sysgen_reinterpret_30c4f27b83 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay0_q_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_30c4f27b83 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay1_q_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_30c4f27b83 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay2_q_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_30c4f27b83 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay3_q_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_30c4f27b83 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay4_q_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_30c4f27b83 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay5_q_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_30c4f27b83 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay6_q_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_30c4f27b83 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(delay7_q_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/HGAIN_Vector2Scalar
module dsp_blr_hgain_vector2scalar (
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
  wire [128-1:0] concat1_y_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  assign out1 = concat1_y_net;
  assign delay0_q_net = in1_1;
  assign delay1_q_net = in1_2;
  assign delay2_q_net = in1_3;
  assign delay3_q_net = in1_4;
  assign delay4_q_net = in1_5;
  assign delay5_q_net = in1_6;
  assign delay6_q_net = in1_7;
  assign delay7_q_net = in1_8;
  dsp_blr_vector2scalar_x0 vector2scalar (
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
  dsp_blr_vector_reinterpret2unsigned vector_reinterpret2unsigned (
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
// Generated from Simulink block dsp_blr/HGAIN_delay
module dsp_blr_hgain_delay (
  input [16-1:0] d_1,
  input [16-1:0] d_2,
  input [16-1:0] d_3,
  input [16-1:0] d_4,
  input [16-1:0] d_5,
  input [16-1:0] d_6,
  input [16-1:0] d_7,
  input [16-1:0] d_8,
  output [16-1:0] q_1,
  output [16-1:0] q_2,
  output [16-1:0] q_3,
  output [16-1:0] q_4,
  output [16-1:0] q_5,
  output [16-1:0] q_6,
  output [16-1:0] q_7,
  output [16-1:0] q_8
);
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay1_q_net_x0;
  wire [16-1:0] delay0_q_net_x0;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay6_q_net_x0;
  wire [16-1:0] delay4_q_net_x0;
  wire [16-1:0] delay5_q_net_x0;
  wire [16-1:0] delay7_q_net_x0;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay2_q_net_x0;
  wire [16-1:0] delay3_q_net_x0;
  assign q_1 = delay0_q_net_x0;
  assign q_2 = delay1_q_net_x0;
  assign q_3 = delay2_q_net_x0;
  assign q_4 = delay3_q_net_x0;
  assign q_5 = delay4_q_net_x0;
  assign q_6 = delay5_q_net_x0;
  assign q_7 = delay6_q_net_x0;
  assign q_8 = delay7_q_net_x0;
  assign delay0_q_net = d_1;
  assign delay1_q_net = d_2;
  assign delay2_q_net = d_3;
  assign delay3_q_net = d_4;
  assign delay4_q_net = d_5;
  assign delay5_q_net = d_6;
  assign delay6_q_net = d_7;
  assign delay7_q_net = d_8;
  sysgen_delay_57402732a5 delay0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(delay0_q_net),
    .q(delay0_q_net_x0)
  );
  sysgen_delay_57402732a5 delay1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(delay1_q_net),
    .q(delay1_q_net_x0)
  );
  sysgen_delay_57402732a5 delay2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(delay2_q_net),
    .q(delay2_q_net_x0)
  );
  sysgen_delay_57402732a5 delay3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(delay3_q_net),
    .q(delay3_q_net_x0)
  );
  sysgen_delay_57402732a5 delay4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(delay4_q_net),
    .q(delay4_q_net_x0)
  );
  sysgen_delay_57402732a5 delay5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(delay5_q_net),
    .q(delay5_q_net_x0)
  );
  sysgen_delay_57402732a5 delay6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(delay6_q_net),
    .q(delay6_q_net_x0)
  );
  sysgen_delay_57402732a5 delay7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(delay7_q_net),
    .q(delay7_q_net_x0)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/Scalar2Vector
module dsp_blr_scalar2vector (
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
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] slice6_y_net;
  wire [128-1:0] h_s_axis_tdata_net;
  wire [16-1:0] slice4_y_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice3_y_net;
  assign o_1 = slice0_y_net;
  assign o_2 = slice1_y_net;
  assign o_3 = slice2_y_net;
  assign o_4 = slice3_y_net;
  assign o_5 = slice4_y_net;
  assign o_6 = slice5_y_net;
  assign o_7 = slice6_y_net;
  assign o_8 = slice7_y_net;
  assign h_s_axis_tdata_net = i;
  dsp_blr_xlslice #(
    .new_lsb(0),
    .new_msb(15),
    .x_width(128),
    .y_width(16)
  )
  slice0 (
    .x(h_s_axis_tdata_net),
    .y(slice0_y_net)
  );
  dsp_blr_xlslice #(
    .new_lsb(16),
    .new_msb(31),
    .x_width(128),
    .y_width(16)
  )
  slice1 (
    .x(h_s_axis_tdata_net),
    .y(slice1_y_net)
  );
  dsp_blr_xlslice #(
    .new_lsb(32),
    .new_msb(47),
    .x_width(128),
    .y_width(16)
  )
  slice2 (
    .x(h_s_axis_tdata_net),
    .y(slice2_y_net)
  );
  dsp_blr_xlslice #(
    .new_lsb(48),
    .new_msb(63),
    .x_width(128),
    .y_width(16)
  )
  slice3 (
    .x(h_s_axis_tdata_net),
    .y(slice3_y_net)
  );
  dsp_blr_xlslice #(
    .new_lsb(64),
    .new_msb(79),
    .x_width(128),
    .y_width(16)
  )
  slice4 (
    .x(h_s_axis_tdata_net),
    .y(slice4_y_net)
  );
  dsp_blr_xlslice #(
    .new_lsb(80),
    .new_msb(95),
    .x_width(128),
    .y_width(16)
  )
  slice5 (
    .x(h_s_axis_tdata_net),
    .y(slice5_y_net)
  );
  dsp_blr_xlslice #(
    .new_lsb(96),
    .new_msb(111),
    .x_width(128),
    .y_width(16)
  )
  slice6 (
    .x(h_s_axis_tdata_net),
    .y(slice6_y_net)
  );
  dsp_blr_xlslice #(
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
// Generated from Simulink block dsp_blr/Subsystem/Vector AddSub Fabric1
module dsp_blr_vector_addsub_fabric1 (
  input [16-1:0] a_1,
  input [19-1:0] b_1,
  input [16-1:0] a_2,
  input [16-1:0] a_3,
  input [16-1:0] a_4,
  input [16-1:0] a_5,
  input [16-1:0] a_6,
  input [16-1:0] a_7,
  input [16-1:0] a_8,
  input [19-1:0] b_2,
  input [19-1:0] b_3,
  input [19-1:0] b_4,
  input [19-1:0] b_5,
  input [19-1:0] b_6,
  input [19-1:0] b_7,
  input [19-1:0] b_8,
  input clk_1,
  input ce_1,
  output [20-1:0] a_b_1,
  output [20-1:0] a_b_2,
  output [20-1:0] a_b_3,
  output [20-1:0] a_b_4,
  output [20-1:0] a_b_5,
  output [20-1:0] a_b_6,
  output [20-1:0] a_b_7,
  output [20-1:0] a_b_8
);
  wire [20-1:0] addsub1_s_net;
  wire [20-1:0] addsub0_s_net;
  wire [19-1:0] reinterpret7_output_port_net;
  wire [19-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [20-1:0] addsub7_s_net;
  wire [20-1:0] addsub5_s_net;
  wire [16-1:0] reinterpret6_output_port_net_x0;
  wire [16-1:0] reinterpret3_output_port_net_x0;
  wire clk_net;
  wire [19-1:0] reinterpret5_output_port_net;
  wire [20-1:0] addsub3_s_net;
  wire [16-1:0] reinterpret7_output_port_net_x0;
  wire [16-1:0] reinterpret2_output_port_net_x0;
  wire [20-1:0] addsub2_s_net;
  wire [16-1:0] reinterpret4_output_port_net_x0;
  wire [19-1:0] reinterpret3_output_port_net;
  wire [20-1:0] addsub6_s_net;
  wire [20-1:0] addsub4_s_net;
  wire [19-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net_x0;
  wire [19-1:0] reinterpret6_output_port_net;
  wire ce_net;
  wire [19-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [19-1:0] reinterpret1_output_port_net_x0;
  assign a_b_1 = addsub0_s_net;
  assign a_b_2 = addsub1_s_net;
  assign a_b_3 = addsub2_s_net;
  assign a_b_4 = addsub3_s_net;
  assign a_b_5 = addsub4_s_net;
  assign a_b_6 = addsub5_s_net;
  assign a_b_7 = addsub6_s_net;
  assign a_b_8 = addsub7_s_net;
  assign reinterpret0_output_port_net = a_1;
  assign reinterpret0_output_port_net_x0 = b_1;
  assign reinterpret1_output_port_net = a_2;
  assign reinterpret2_output_port_net_x0 = a_3;
  assign reinterpret3_output_port_net_x0 = a_4;
  assign reinterpret4_output_port_net_x0 = a_5;
  assign reinterpret5_output_port_net_x0 = a_6;
  assign reinterpret6_output_port_net_x0 = a_7;
  assign reinterpret7_output_port_net_x0 = a_8;
  assign reinterpret1_output_port_net_x0 = b_2;
  assign reinterpret2_output_port_net = b_3;
  assign reinterpret3_output_port_net = b_4;
  assign reinterpret4_output_port_net = b_5;
  assign reinterpret5_output_port_net = b_6;
  assign reinterpret6_output_port_net = b_7;
  assign reinterpret7_output_port_net = b_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(7),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dsp_blr_c_addsub_v12_0_i0"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(20),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(7),
    .s_width(20)
  )
  addsub0 (
    .clr(1'b0),
    .en(1'b1),
    .a(reinterpret0_output_port_net),
    .b(reinterpret0_output_port_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub0_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(7),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dsp_blr_c_addsub_v12_0_i0"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(20),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(7),
    .s_width(20)
  )
  addsub1 (
    .clr(1'b0),
    .en(1'b1),
    .a(reinterpret1_output_port_net),
    .b(reinterpret1_output_port_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(7),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dsp_blr_c_addsub_v12_0_i0"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(20),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(7),
    .s_width(20)
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
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(7),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dsp_blr_c_addsub_v12_0_i0"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(20),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(7),
    .s_width(20)
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
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(7),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dsp_blr_c_addsub_v12_0_i0"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(20),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(7),
    .s_width(20)
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
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(7),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dsp_blr_c_addsub_v12_0_i0"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(20),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(7),
    .s_width(20)
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
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(7),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dsp_blr_c_addsub_v12_0_i0"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(20),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(7),
    .s_width(20)
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
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(7),
    .b_width(19),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(20),
    .core_name0("dsp_blr_c_addsub_v12_0_i0"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(20),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(7),
    .s_width(20)
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
// Generated from Simulink block dsp_blr/Subsystem/Vector AddSub Fabric2
module dsp_blr_vector_addsub_fabric2 (
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
  output [17-1:0] a_b_1,
  output [17-1:0] a_b_2,
  output [17-1:0] a_b_3,
  output [17-1:0] a_b_4,
  output [17-1:0] a_b_5,
  output [17-1:0] a_b_6,
  output [17-1:0] a_b_7,
  output [17-1:0] a_b_8
);
  wire [17-1:0] addsub0_s_net;
  wire [17-1:0] addsub4_s_net;
  wire [17-1:0] addsub6_s_net;
  wire [17-1:0] addsub1_s_net;
  wire [17-1:0] addsub2_s_net;
  wire [17-1:0] addsub3_s_net;
  wire [17-1:0] addsub5_s_net;
  wire [17-1:0] addsub7_s_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] delay3_q_net;
  wire ce_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire clk_net;
  wire [16-1:0] reinterpret5_output_port_net;
  assign a_b_1 = addsub0_s_net;
  assign a_b_2 = addsub1_s_net;
  assign a_b_3 = addsub2_s_net;
  assign a_b_4 = addsub3_s_net;
  assign a_b_5 = addsub4_s_net;
  assign a_b_6 = addsub5_s_net;
  assign a_b_7 = addsub6_s_net;
  assign a_b_8 = addsub7_s_net;
  assign reinterpret0_output_port_net = a_1;
  assign delay0_q_net = b_1;
  assign reinterpret1_output_port_net = a_2;
  assign reinterpret2_output_port_net = a_3;
  assign reinterpret3_output_port_net = a_4;
  assign reinterpret4_output_port_net = a_5;
  assign reinterpret5_output_port_net = a_6;
  assign reinterpret6_output_port_net = a_7;
  assign reinterpret7_output_port_net = a_8;
  assign delay1_q_net = b_2;
  assign delay2_q_net = b_3;
  assign delay3_q_net = b_4;
  assign delay4_q_net = b_5;
  assign delay5_q_net = b_6;
  assign delay6_q_net = b_7;
  assign delay7_q_net = b_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub0 (
    .clr(1'b0),
    .en(1'b1),
    .a(reinterpret0_output_port_net),
    .b(delay0_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub0_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(reinterpret1_output_port_net),
    .b(delay1_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(reinterpret2_output_port_net),
    .b(delay2_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub2_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(reinterpret3_output_port_net),
    .b(delay3_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub4 (
    .clr(1'b0),
    .en(1'b1),
    .a(reinterpret4_output_port_net),
    .b(delay4_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub4_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub5 (
    .clr(1'b0),
    .en(1'b1),
    .a(reinterpret5_output_port_net),
    .b(delay5_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub5_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub6 (
    .clr(1'b0),
    .en(1'b1),
    .a(reinterpret6_output_port_net),
    .b(delay6_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub6_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(reinterpret7_output_port_net),
    .b(delay7_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub7_s_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/Subsystem/Vector AddSub Fabric3
module dsp_blr_vector_addsub_fabric3 (
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
  output [17-1:0] a_b_1,
  output [17-1:0] a_b_2,
  output [17-1:0] a_b_3,
  output [17-1:0] a_b_4,
  output [17-1:0] a_b_5,
  output [17-1:0] a_b_6,
  output [17-1:0] a_b_7,
  output [17-1:0] a_b_8
);
  wire [17-1:0] addsub5_s_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay1_q_net_x0;
  wire [17-1:0] addsub0_s_net;
  wire [17-1:0] addsub1_s_net;
  wire [17-1:0] addsub4_s_net;
  wire [17-1:0] addsub6_s_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay0_q_net_x0;
  wire [16-1:0] delay2_q_net;
  wire [17-1:0] addsub7_s_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay4_q_net;
  wire [17-1:0] addsub2_s_net;
  wire [17-1:0] addsub3_s_net;
  wire [16-1:0] delay2_q_net_x0;
  wire [16-1:0] delay7_q_net_x0;
  wire ce_net;
  wire [16-1:0] delay6_q_net_x0;
  wire [16-1:0] delay4_q_net_x0;
  wire [16-1:0] delay3_q_net_x0;
  wire clk_net;
  wire [16-1:0] delay5_q_net_x0;
  assign a_b_1 = addsub0_s_net;
  assign a_b_2 = addsub1_s_net;
  assign a_b_3 = addsub2_s_net;
  assign a_b_4 = addsub3_s_net;
  assign a_b_5 = addsub4_s_net;
  assign a_b_6 = addsub5_s_net;
  assign a_b_7 = addsub6_s_net;
  assign a_b_8 = addsub7_s_net;
  assign delay0_q_net_x0 = a_1;
  assign delay0_q_net = b_1;
  assign delay1_q_net_x0 = a_2;
  assign delay2_q_net = a_3;
  assign delay3_q_net = a_4;
  assign delay4_q_net = a_5;
  assign delay5_q_net = a_6;
  assign delay6_q_net = a_7;
  assign delay7_q_net = a_8;
  assign delay1_q_net = b_2;
  assign delay2_q_net_x0 = b_3;
  assign delay3_q_net_x0 = b_4;
  assign delay4_q_net_x0 = b_5;
  assign delay5_q_net_x0 = b_6;
  assign delay6_q_net_x0 = b_7;
  assign delay7_q_net_x0 = b_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub0 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay0_q_net_x0),
    .b(delay0_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub0_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(delay1_q_net_x0),
    .b(delay1_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(delay2_q_net),
    .b(delay2_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub2_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(delay3_q_net),
    .b(delay3_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub4 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay4_q_net),
    .b(delay4_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub4_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub5 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay5_q_net),
    .b(delay5_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub5_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub6 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay6_q_net),
    .b(delay6_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub6_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(delay7_q_net),
    .b(delay7_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub7_s_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/Subsystem/Vector AddSub Fabric4
module dsp_blr_vector_addsub_fabric4 (
  input [17-1:0] a_1,
  input [17-1:0] b_1,
  input [17-1:0] a_2,
  input [17-1:0] a_3,
  input [17-1:0] a_4,
  input [17-1:0] a_5,
  input [17-1:0] a_6,
  input [17-1:0] a_7,
  input [17-1:0] a_8,
  input [17-1:0] b_2,
  input [17-1:0] b_3,
  input [17-1:0] b_4,
  input [17-1:0] b_5,
  input [17-1:0] b_6,
  input [17-1:0] b_7,
  input [17-1:0] b_8,
  input clk_1,
  input ce_1,
  output [18-1:0] a_b_1,
  output [18-1:0] a_b_2,
  output [18-1:0] a_b_3,
  output [18-1:0] a_b_4,
  output [18-1:0] a_b_5,
  output [18-1:0] a_b_6,
  output [18-1:0] a_b_7,
  output [18-1:0] a_b_8
);
  wire [17-1:0] addsub1_s_net_x1;
  wire [17-1:0] addsub0_s_net_x0;
  wire [18-1:0] addsub1_s_net;
  wire [18-1:0] addsub6_s_net_x0;
  wire [17-1:0] addsub4_s_net_x0;
  wire [17-1:0] addsub0_s_net_x1;
  wire [17-1:0] addsub4_s_net;
  wire [17-1:0] addsub6_s_net_x1;
  wire [17-1:0] addsub5_s_net;
  wire [18-1:0] addsub0_s_net;
  wire [17-1:0] addsub7_s_net;
  wire clk_net;
  wire ce_net;
  wire [18-1:0] addsub7_s_net_x1;
  wire [17-1:0] addsub1_s_net_x0;
  wire [18-1:0] addsub3_s_net_x1;
  wire [17-1:0] addsub3_s_net;
  wire [18-1:0] addsub5_s_net_x1;
  wire [17-1:0] addsub3_s_net_x0;
  wire [18-1:0] addsub4_s_net_x1;
  wire [17-1:0] addsub2_s_net_x0;
  wire [18-1:0] addsub2_s_net_x1;
  wire [17-1:0] addsub5_s_net_x0;
  wire [17-1:0] addsub7_s_net_x0;
  wire [17-1:0] addsub2_s_net;
  wire [17-1:0] addsub6_s_net;
  assign a_b_1 = addsub0_s_net;
  assign a_b_2 = addsub1_s_net;
  assign a_b_3 = addsub2_s_net_x1;
  assign a_b_4 = addsub3_s_net_x1;
  assign a_b_5 = addsub4_s_net_x1;
  assign a_b_6 = addsub5_s_net_x1;
  assign a_b_7 = addsub6_s_net_x0;
  assign a_b_8 = addsub7_s_net_x1;
  assign addsub0_s_net_x1 = a_1;
  assign addsub0_s_net_x0 = b_1;
  assign addsub1_s_net_x1 = a_2;
  assign addsub2_s_net_x0 = a_3;
  assign addsub3_s_net_x0 = a_4;
  assign addsub4_s_net_x0 = a_5;
  assign addsub5_s_net_x0 = a_6;
  assign addsub6_s_net_x1 = a_7;
  assign addsub7_s_net_x0 = a_8;
  assign addsub1_s_net_x0 = b_2;
  assign addsub2_s_net = b_3;
  assign addsub3_s_net = b_4;
  assign addsub4_s_net = b_5;
  assign addsub5_s_net = b_6;
  assign addsub6_s_net = b_7;
  assign addsub7_s_net = b_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
  addsub0 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub0_s_net_x1),
    .b(addsub0_s_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub0_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
  addsub1 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub1_s_net_x1),
    .b(addsub1_s_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
  addsub2 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub2_s_net_x0),
    .b(addsub2_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub2_s_net_x1)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
  addsub3 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub3_s_net_x0),
    .b(addsub3_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net_x1)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
    .a(addsub4_s_net_x0),
    .b(addsub4_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub4_s_net_x1)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
    .a(addsub5_s_net_x0),
    .b(addsub5_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub5_s_net_x1)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
  addsub6 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub6_s_net_x1),
    .b(addsub6_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub6_s_net_x0)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
  addsub7 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub7_s_net_x0),
    .b(addsub7_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub7_s_net_x1)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/Subsystem/Vector AddSub Fabric5
module dsp_blr_vector_addsub_fabric5 (
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
  output [17-1:0] a_b_1,
  output [17-1:0] a_b_2,
  output [17-1:0] a_b_3,
  output [17-1:0] a_b_4,
  output [17-1:0] a_b_5,
  output [17-1:0] a_b_6,
  output [17-1:0] a_b_7,
  output [17-1:0] a_b_8
);
  wire [17-1:0] addsub0_s_net;
  wire [17-1:0] addsub1_s_net;
  wire [17-1:0] addsub2_s_net;
  wire [17-1:0] addsub3_s_net;
  wire [17-1:0] addsub4_s_net;
  wire [16-1:0] delay2_q_net_x0;
  wire [17-1:0] addsub6_s_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay6_q_net_x0;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay3_q_net_x0;
  wire [16-1:0] delay5_q_net_x0;
  wire [17-1:0] addsub7_s_net;
  wire [16-1:0] delay0_q_net_x0;
  wire [17-1:0] addsub5_s_net;
  wire [16-1:0] delay4_q_net_x0;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay7_q_net_x0;
  wire ce_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay3_q_net;
  wire clk_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay1_q_net_x0;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay5_q_net;
  assign a_b_1 = addsub0_s_net;
  assign a_b_2 = addsub1_s_net;
  assign a_b_3 = addsub2_s_net;
  assign a_b_4 = addsub3_s_net;
  assign a_b_5 = addsub4_s_net;
  assign a_b_6 = addsub5_s_net;
  assign a_b_7 = addsub6_s_net;
  assign a_b_8 = addsub7_s_net;
  assign delay0_q_net_x0 = a_1;
  assign delay0_q_net = b_1;
  assign delay1_q_net_x0 = a_2;
  assign delay2_q_net = a_3;
  assign delay3_q_net = a_4;
  assign delay4_q_net = a_5;
  assign delay5_q_net = a_6;
  assign delay6_q_net = a_7;
  assign delay7_q_net = a_8;
  assign delay1_q_net = b_2;
  assign delay2_q_net_x0 = b_3;
  assign delay3_q_net_x0 = b_4;
  assign delay4_q_net_x0 = b_5;
  assign delay5_q_net_x0 = b_6;
  assign delay6_q_net_x0 = b_7;
  assign delay7_q_net_x0 = b_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub0 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay0_q_net_x0),
    .b(delay0_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub0_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(delay1_q_net_x0),
    .b(delay1_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(delay2_q_net),
    .b(delay2_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub2_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(delay3_q_net),
    .b(delay3_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub4 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay4_q_net),
    .b(delay4_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub4_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub5 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay5_q_net),
    .b(delay5_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub5_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub6 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay6_q_net),
    .b(delay6_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub6_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(delay7_q_net),
    .b(delay7_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub7_s_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/Subsystem/Vector AddSub Fabric6
module dsp_blr_vector_addsub_fabric6 (
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
  output [17-1:0] a_b_1,
  output [17-1:0] a_b_2,
  output [17-1:0] a_b_3,
  output [17-1:0] a_b_4,
  output [17-1:0] a_b_5,
  output [17-1:0] a_b_6,
  output [17-1:0] a_b_7,
  output [17-1:0] a_b_8
);
  wire [16-1:0] delay0_q_net_x0;
  wire [16-1:0] delay2_q_net;
  wire [17-1:0] addsub3_s_net;
  wire [17-1:0] addsub7_s_net;
  wire [16-1:0] delay3_q_net;
  wire [17-1:0] addsub5_s_net;
  wire [16-1:0] delay0_q_net;
  wire [17-1:0] addsub2_s_net;
  wire [16-1:0] delay1_q_net_x0;
  wire [16-1:0] delay4_q_net;
  wire [17-1:0] addsub1_s_net;
  wire [17-1:0] addsub0_s_net;
  wire [17-1:0] addsub4_s_net;
  wire [17-1:0] addsub6_s_net;
  wire [16-1:0] delay3_q_net_x0;
  wire [16-1:0] delay5_q_net_x0;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay4_q_net_x0;
  wire ce_net;
  wire [16-1:0] delay2_q_net_x0;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay7_q_net_x0;
  wire [16-1:0] delay6_q_net;
  wire clk_net;
  wire [16-1:0] delay6_q_net_x0;
  assign a_b_1 = addsub0_s_net;
  assign a_b_2 = addsub1_s_net;
  assign a_b_3 = addsub2_s_net;
  assign a_b_4 = addsub3_s_net;
  assign a_b_5 = addsub4_s_net;
  assign a_b_6 = addsub5_s_net;
  assign a_b_7 = addsub6_s_net;
  assign a_b_8 = addsub7_s_net;
  assign delay0_q_net_x0 = a_1;
  assign delay0_q_net = b_1;
  assign delay1_q_net_x0 = a_2;
  assign delay2_q_net = a_3;
  assign delay3_q_net = a_4;
  assign delay4_q_net = a_5;
  assign delay5_q_net = a_6;
  assign delay6_q_net = a_7;
  assign delay7_q_net = a_8;
  assign delay1_q_net = b_2;
  assign delay2_q_net_x0 = b_3;
  assign delay3_q_net_x0 = b_4;
  assign delay4_q_net_x0 = b_5;
  assign delay5_q_net_x0 = b_6;
  assign delay6_q_net_x0 = b_7;
  assign delay7_q_net_x0 = b_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub0 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay0_q_net_x0),
    .b(delay0_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub0_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(delay1_q_net_x0),
    .b(delay1_q_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(delay2_q_net),
    .b(delay2_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub2_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(delay3_q_net),
    .b(delay3_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub4 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay4_q_net),
    .b(delay4_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub4_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub5 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay5_q_net),
    .b(delay5_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub5_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
  addsub6 (
    .clr(1'b0),
    .en(1'b1),
    .a(delay6_q_net),
    .b(delay6_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub6_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(16),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(16),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(17),
    .core_name0("dsp_blr_c_addsub_v12_0_i1"),
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
    .a(delay7_q_net),
    .b(delay7_q_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub7_s_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/Subsystem/Vector AddSub Fabric7
module dsp_blr_vector_addsub_fabric7 (
  input [17-1:0] a_1,
  input [17-1:0] b_1,
  input [17-1:0] a_2,
  input [17-1:0] a_3,
  input [17-1:0] a_4,
  input [17-1:0] a_5,
  input [17-1:0] a_6,
  input [17-1:0] a_7,
  input [17-1:0] a_8,
  input [17-1:0] b_2,
  input [17-1:0] b_3,
  input [17-1:0] b_4,
  input [17-1:0] b_5,
  input [17-1:0] b_6,
  input [17-1:0] b_7,
  input [17-1:0] b_8,
  input clk_1,
  input ce_1,
  output [18-1:0] a_b_1,
  output [18-1:0] a_b_2,
  output [18-1:0] a_b_3,
  output [18-1:0] a_b_4,
  output [18-1:0] a_b_5,
  output [18-1:0] a_b_6,
  output [18-1:0] a_b_7,
  output [18-1:0] a_b_8
);
  wire [17-1:0] addsub3_s_net_x0;
  wire [17-1:0] addsub2_s_net_x0;
  wire [17-1:0] addsub5_s_net_x0;
  wire [17-1:0] addsub6_s_net_x1;
  wire [18-1:0] addsub3_s_net_x1;
  wire [17-1:0] addsub0_s_net_x0;
  wire [18-1:0] addsub2_s_net_x1;
  wire [17-1:0] addsub7_s_net_x0;
  wire [17-1:0] addsub1_s_net_x0;
  wire [18-1:0] addsub7_s_net_x1;
  wire [18-1:0] addsub5_s_net_x1;
  wire [18-1:0] addsub1_s_net;
  wire [18-1:0] addsub4_s_net_x1;
  wire [17-1:0] addsub1_s_net_x1;
  wire [18-1:0] addsub6_s_net_x0;
  wire [18-1:0] addsub0_s_net;
  wire [17-1:0] addsub0_s_net_x1;
  wire [17-1:0] addsub4_s_net_x0;
  wire [17-1:0] addsub2_s_net;
  wire [17-1:0] addsub7_s_net;
  wire ce_net;
  wire [17-1:0] addsub4_s_net;
  wire [17-1:0] addsub5_s_net;
  wire clk_net;
  wire [17-1:0] addsub6_s_net;
  wire [17-1:0] addsub3_s_net;
  assign a_b_1 = addsub0_s_net;
  assign a_b_2 = addsub1_s_net;
  assign a_b_3 = addsub2_s_net_x1;
  assign a_b_4 = addsub3_s_net_x1;
  assign a_b_5 = addsub4_s_net_x1;
  assign a_b_6 = addsub5_s_net_x1;
  assign a_b_7 = addsub6_s_net_x0;
  assign a_b_8 = addsub7_s_net_x1;
  assign addsub0_s_net_x1 = a_1;
  assign addsub0_s_net_x0 = b_1;
  assign addsub1_s_net_x1 = a_2;
  assign addsub2_s_net_x0 = a_3;
  assign addsub3_s_net_x0 = a_4;
  assign addsub4_s_net_x0 = a_5;
  assign addsub5_s_net_x0 = a_6;
  assign addsub6_s_net_x1 = a_7;
  assign addsub7_s_net_x0 = a_8;
  assign addsub1_s_net_x0 = b_2;
  assign addsub2_s_net = b_3;
  assign addsub3_s_net = b_4;
  assign addsub4_s_net = b_5;
  assign addsub5_s_net = b_6;
  assign addsub6_s_net = b_7;
  assign addsub7_s_net = b_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
  addsub0 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub0_s_net_x1),
    .b(addsub0_s_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub0_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
  addsub1 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub1_s_net_x1),
    .b(addsub1_s_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
  addsub2 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub2_s_net_x0),
    .b(addsub2_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub2_s_net_x1)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
  addsub3 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub3_s_net_x0),
    .b(addsub3_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net_x1)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
    .a(addsub4_s_net_x0),
    .b(addsub4_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub4_s_net_x1)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
    .a(addsub5_s_net_x0),
    .b(addsub5_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub5_s_net_x1)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
  addsub6 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub6_s_net_x1),
    .b(addsub6_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub6_s_net_x0)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(17),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(17),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(18),
    .core_name0("dsp_blr_c_addsub_v12_0_i2"),
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
  addsub7 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub7_s_net_x0),
    .b(addsub7_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub7_s_net_x1)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/Subsystem/Vector AddSub Fabric8
module dsp_blr_vector_addsub_fabric8 (
  input [18-1:0] a_1,
  input [18-1:0] b_1,
  input [18-1:0] a_2,
  input [18-1:0] a_3,
  input [18-1:0] a_4,
  input [18-1:0] a_5,
  input [18-1:0] a_6,
  input [18-1:0] a_7,
  input [18-1:0] a_8,
  input [18-1:0] b_2,
  input [18-1:0] b_3,
  input [18-1:0] b_4,
  input [18-1:0] b_5,
  input [18-1:0] b_6,
  input [18-1:0] b_7,
  input [18-1:0] b_8,
  input clk_1,
  input ce_1,
  output [19-1:0] a_b_1,
  output [19-1:0] a_b_2,
  output [19-1:0] a_b_3,
  output [19-1:0] a_b_4,
  output [19-1:0] a_b_5,
  output [19-1:0] a_b_6,
  output [19-1:0] a_b_7,
  output [19-1:0] a_b_8
);
  wire [18-1:0] addsub0_s_net_x1;
  wire [18-1:0] addsub2_s_net_x0;
  wire [18-1:0] addsub6_s_net;
  wire [18-1:0] addsub1_s_net_x1;
  wire [18-1:0] addsub3_s_net;
  wire clk_net;
  wire [18-1:0] addsub3_s_net_x0;
  wire ce_net;
  wire [19-1:0] addsub1_s_net;
  wire [19-1:0] addsub4_s_net_x1;
  wire [19-1:0] addsub7_s_net_x1;
  wire [18-1:0] addsub0_s_net_x0;
  wire [18-1:0] addsub1_s_net_x0;
  wire [18-1:0] addsub2_s_net;
  wire [18-1:0] addsub7_s_net;
  wire [19-1:0] addsub5_s_net_x1;
  wire [18-1:0] addsub4_s_net_x0;
  wire [18-1:0] addsub6_s_net_x1;
  wire [19-1:0] addsub3_s_net_x1;
  wire [19-1:0] addsub6_s_net_x0;
  wire [19-1:0] addsub0_s_net;
  wire [18-1:0] addsub7_s_net_x0;
  wire [18-1:0] addsub5_s_net_x0;
  wire [19-1:0] addsub2_s_net_x1;
  wire [18-1:0] addsub4_s_net;
  wire [18-1:0] addsub5_s_net;
  assign a_b_1 = addsub0_s_net;
  assign a_b_2 = addsub1_s_net;
  assign a_b_3 = addsub2_s_net_x1;
  assign a_b_4 = addsub3_s_net_x1;
  assign a_b_5 = addsub4_s_net_x1;
  assign a_b_6 = addsub5_s_net_x1;
  assign a_b_7 = addsub6_s_net_x0;
  assign a_b_8 = addsub7_s_net_x1;
  assign addsub0_s_net_x1 = a_1;
  assign addsub0_s_net_x0 = b_1;
  assign addsub1_s_net_x1 = a_2;
  assign addsub2_s_net_x0 = a_3;
  assign addsub3_s_net_x0 = a_4;
  assign addsub4_s_net_x0 = a_5;
  assign addsub5_s_net_x0 = a_6;
  assign addsub6_s_net_x1 = a_7;
  assign addsub7_s_net_x0 = a_8;
  assign addsub1_s_net_x0 = b_2;
  assign addsub2_s_net = b_3;
  assign addsub3_s_net = b_4;
  assign addsub4_s_net = b_5;
  assign addsub5_s_net = b_6;
  assign addsub6_s_net = b_7;
  assign addsub7_s_net = b_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(18),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(19),
    .core_name0("dsp_blr_c_addsub_v12_0_i3"),
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
  addsub0 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub0_s_net_x1),
    .b(addsub0_s_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub0_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(18),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(19),
    .core_name0("dsp_blr_c_addsub_v12_0_i3"),
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
  addsub1 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub1_s_net_x1),
    .b(addsub1_s_net_x0),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub1_s_net)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(18),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(19),
    .core_name0("dsp_blr_c_addsub_v12_0_i3"),
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
  addsub2 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub2_s_net_x0),
    .b(addsub2_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub2_s_net_x1)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(18),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(19),
    .core_name0("dsp_blr_c_addsub_v12_0_i3"),
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
  addsub3 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub3_s_net_x0),
    .b(addsub3_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub3_s_net_x1)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(18),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(19),
    .core_name0("dsp_blr_c_addsub_v12_0_i3"),
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
  addsub4 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub4_s_net_x0),
    .b(addsub4_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub4_s_net_x1)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(18),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(19),
    .core_name0("dsp_blr_c_addsub_v12_0_i3"),
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
  addsub5 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub5_s_net_x0),
    .b(addsub5_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub5_s_net_x1)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(18),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(19),
    .core_name0("dsp_blr_c_addsub_v12_0_i3"),
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
    .a(addsub6_s_net_x1),
    .b(addsub6_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub6_s_net_x0)
  );
  dsp_blr_xladdsub #(
    .a_arith(`xlSigned),
    .a_bin_pt(4),
    .a_width(18),
    .b_arith(`xlSigned),
    .b_bin_pt(4),
    .b_width(18),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(19),
    .core_name0("dsp_blr_c_addsub_v12_0_i3"),
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
  addsub7 (
    .clr(1'b0),
    .en(1'b1),
    .a(addsub7_s_net_x0),
    .b(addsub7_s_net),
    .clk(clk_net),
    .ce(ce_net),
    .s(addsub7_s_net_x1)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/Subsystem/Vector Delay
module dsp_blr_vector_delay (
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
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay4_q_net;
  wire clk_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] delay7_q_net;
  wire ce_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
// Generated from Simulink block dsp_blr/Subsystem/Vector Delay1
module dsp_blr_vector_delay1 (
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
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire clk_net;
  wire [16-1:0] reinterpret5_output_port_net;
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
  dsp_blr_xldelay #(
    .latency(4),
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
  dsp_blr_xldelay #(
    .latency(4),
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
  dsp_blr_xldelay #(
    .latency(4),
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
  dsp_blr_xldelay #(
    .latency(4),
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
  dsp_blr_xldelay #(
    .latency(4),
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
  dsp_blr_xldelay #(
    .latency(4),
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
  dsp_blr_xldelay #(
    .latency(4),
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
  dsp_blr_xldelay #(
    .latency(4),
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
// Generated from Simulink block dsp_blr/Subsystem/Vector Delay2
module dsp_blr_vector_delay2 (
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
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire ce_net;
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
  dsp_blr_xldelay #(
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
// Generated from Simulink block dsp_blr/Subsystem/Vector Delay3
module dsp_blr_vector_delay3 (
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
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire clk_net;
  wire [16-1:0] reinterpret0_output_port_net;
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
  dsp_blr_xldelay #(
    .latency(8),
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
  dsp_blr_xldelay #(
    .latency(8),
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
  dsp_blr_xldelay #(
    .latency(8),
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
  dsp_blr_xldelay #(
    .latency(8),
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
  dsp_blr_xldelay #(
    .latency(8),
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
  dsp_blr_xldelay #(
    .latency(8),
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
  dsp_blr_xldelay #(
    .latency(8),
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
  dsp_blr_xldelay #(
    .latency(8),
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
// Generated from Simulink block dsp_blr/Subsystem/Vector Delay4
module dsp_blr_vector_delay4 (
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
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] delay0_q_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire ce_net;
  wire clk_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay6_q_net;
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
  dsp_blr_xldelay #(
    .latency(12),
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
  dsp_blr_xldelay #(
    .latency(12),
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
  dsp_blr_xldelay #(
    .latency(12),
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
  dsp_blr_xldelay #(
    .latency(12),
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
  dsp_blr_xldelay #(
    .latency(12),
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
  dsp_blr_xldelay #(
    .latency(12),
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
  dsp_blr_xldelay #(
    .latency(12),
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
  dsp_blr_xldelay #(
    .latency(12),
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
// Generated from Simulink block dsp_blr/Subsystem/Vector Delay5
module dsp_blr_vector_delay5 (
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
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire ce_net;
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
  dsp_blr_xldelay #(
    .latency(10),
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
  dsp_blr_xldelay #(
    .latency(10),
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
  dsp_blr_xldelay #(
    .latency(10),
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
  dsp_blr_xldelay #(
    .latency(10),
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
  dsp_blr_xldelay #(
    .latency(10),
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
  dsp_blr_xldelay #(
    .latency(10),
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
  dsp_blr_xldelay #(
    .latency(10),
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
  dsp_blr_xldelay #(
    .latency(10),
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
// Generated from Simulink block dsp_blr/Subsystem/Vector Delay6
module dsp_blr_vector_delay6 (
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
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay3_q_net;
  wire ce_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] delay5_q_net;
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
  dsp_blr_xldelay #(
    .latency(14),
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
  dsp_blr_xldelay #(
    .latency(14),
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
  dsp_blr_xldelay #(
    .latency(14),
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
  dsp_blr_xldelay #(
    .latency(14),
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
  dsp_blr_xldelay #(
    .latency(14),
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
  dsp_blr_xldelay #(
    .latency(14),
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
  dsp_blr_xldelay #(
    .latency(14),
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
  dsp_blr_xldelay #(
    .latency(14),
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
// Generated from Simulink block dsp_blr/Subsystem/Vector Reinterpret1
module dsp_blr_vector_reinterpret1 (
  input [19-1:0] in_1,
  input [19-1:0] in_2,
  input [19-1:0] in_3,
  input [19-1:0] in_4,
  input [19-1:0] in_5,
  input [19-1:0] in_6,
  input [19-1:0] in_7,
  input [19-1:0] in_8,
  output [19-1:0] out_1,
  output [19-1:0] out_2,
  output [19-1:0] out_3,
  output [19-1:0] out_4,
  output [19-1:0] out_5,
  output [19-1:0] out_6,
  output [19-1:0] out_7,
  output [19-1:0] out_8
);
  wire [19-1:0] addsub7_s_net;
  wire [19-1:0] reinterpret6_output_port_net;
  wire [19-1:0] addsub0_s_net;
  wire [19-1:0] reinterpret7_output_port_net;
  wire [19-1:0] reinterpret5_output_port_net;
  wire [19-1:0] addsub5_s_net;
  wire [19-1:0] reinterpret3_output_port_net;
  wire [19-1:0] reinterpret1_output_port_net;
  wire [19-1:0] addsub6_s_net;
  wire [19-1:0] addsub2_s_net;
  wire [19-1:0] reinterpret4_output_port_net;
  wire [19-1:0] addsub4_s_net;
  wire [19-1:0] reinterpret0_output_port_net;
  wire [19-1:0] reinterpret2_output_port_net;
  wire [19-1:0] addsub1_s_net;
  wire [19-1:0] addsub3_s_net;
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
  sysgen_reinterpret_77970159c7 reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub0_s_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_77970159c7 reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub1_s_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_77970159c7 reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub2_s_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_77970159c7 reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub3_s_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_77970159c7 reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub4_s_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_77970159c7 reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub5_s_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_77970159c7 reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub6_s_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_77970159c7 reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(addsub7_s_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/Subsystem
module dsp_blr_subsystem (
  input [16-1:0] in1_1,
  input [16-1:0] in1_2,
  input [16-1:0] in1_3,
  input [16-1:0] in1_4,
  input [16-1:0] in1_5,
  input [16-1:0] in1_6,
  input [16-1:0] in1_7,
  input [16-1:0] in1_8,
  input clk_1,
  input ce_1,
  output [20-1:0] out1_1,
  output [20-1:0] out1_2,
  output [20-1:0] out1_3,
  output [20-1:0] out1_4,
  output [20-1:0] out1_5,
  output [20-1:0] out1_6,
  output [20-1:0] out1_7,
  output [20-1:0] out1_8
);
  wire [20-1:0] addsub3_s_net_x6;
  wire [20-1:0] addsub0_s_net_x6;
  wire [16-1:0] reinterpret0_output_port_net_x0;
  wire [16-1:0] reinterpret1_output_port_net_x0;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [20-1:0] addsub6_s_net_x6;
  wire [20-1:0] addsub4_s_net_x6;
  wire [20-1:0] addsub7_s_net_x6;
  wire [20-1:0] addsub1_s_net_x6;
  wire [20-1:0] addsub5_s_net_x6;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire clk_net;
  wire [20-1:0] addsub2_s_net_x6;
  wire ce_net;
  wire [18-1:0] addsub4_s_net_x3;
  wire [17-1:0] addsub5_s_net_x2;
  wire [19-1:0] reinterpret4_output_port_net_x0;
  wire [17-1:0] addsub7_s_net_x2;
  wire [17-1:0] addsub1_s_net_x5;
  wire [16-1:0] delay0_q_net_x5;
  wire [16-1:0] delay3_q_net_x5;
  wire [17-1:0] addsub2_s_net_x3;
  wire [16-1:0] delay7_q_net_x4;
  wire [16-1:0] delay5_q_net_x3;
  wire [16-1:0] delay7_q_net_x3;
  wire [16-1:0] delay2_q_net_x5;
  wire [16-1:0] delay4_q_net_x5;
  wire [17-1:0] addsub1_s_net_x4;
  wire [17-1:0] addsub3_s_net_x4;
  wire [16-1:0] delay3_q_net_x4;
  wire [17-1:0] addsub1_s_net_x2;
  wire [19-1:0] reinterpret6_output_port_net_x0;
  wire [17-1:0] addsub2_s_net_x4;
  wire [16-1:0] delay1_q_net_x5;
  wire [17-1:0] addsub6_s_net_x4;
  wire [19-1:0] reinterpret0_output_port_net;
  wire [17-1:0] addsub7_s_net_x4;
  wire [16-1:0] delay1_q_net_x4;
  wire [16-1:0] delay4_q_net_x4;
  wire [18-1:0] addsub6_s_net_x3;
  wire [17-1:0] addsub0_s_net_x2;
  wire [16-1:0] delay0_q_net_x4;
  wire [18-1:0] addsub7_s_net_x3;
  wire [18-1:0] addsub1_s_net_x3;
  wire [17-1:0] addsub2_s_net_x2;
  wire [17-1:0] addsub3_s_net_x2;
  wire [17-1:0] addsub4_s_net_x2;
  wire [17-1:0] addsub6_s_net_x2;
  wire [16-1:0] delay5_q_net_x5;
  wire [17-1:0] addsub0_s_net_x4;
  wire [19-1:0] reinterpret3_output_port_net_x0;
  wire [16-1:0] delay6_q_net_x5;
  wire [17-1:0] addsub4_s_net_x4;
  wire [16-1:0] delay2_q_net_x4;
  wire [16-1:0] delay5_q_net_x4;
  wire [17-1:0] addsub0_s_net_x5;
  wire [17-1:0] addsub5_s_net_x5;
  wire [16-1:0] delay6_q_net_x4;
  wire [17-1:0] addsub7_s_net_x5;
  wire [16-1:0] delay1_q_net_x3;
  wire [16-1:0] delay3_q_net_x3;
  wire [16-1:0] delay4_q_net_x3;
  wire [16-1:0] delay6_q_net_x3;
  wire [18-1:0] addsub3_s_net_x3;
  wire [17-1:0] addsub4_s_net_x5;
  wire [18-1:0] addsub5_s_net_x3;
  wire [19-1:0] reinterpret7_output_port_net_x0;
  wire [17-1:0] addsub3_s_net_x5;
  wire [16-1:0] delay7_q_net_x5;
  wire [18-1:0] addsub0_s_net_x3;
  wire [19-1:0] reinterpret2_output_port_net_x0;
  wire [17-1:0] addsub6_s_net_x5;
  wire [16-1:0] delay2_q_net_x3;
  wire [18-1:0] addsub2_s_net_x5;
  wire [19-1:0] reinterpret1_output_port_net;
  wire [19-1:0] reinterpret5_output_port_net_x0;
  wire [17-1:0] addsub5_s_net_x4;
  wire [16-1:0] delay0_q_net_x3;
  wire [17-1:0] addsub7_s_net_x1;
  wire [16-1:0] delay3_q_net_x1;
  wire [16-1:0] delay0_q_net_x1;
  wire [16-1:0] delay5_q_net_x0;
  wire [16-1:0] delay4_q_net_x1;
  wire [17-1:0] addsub3_s_net_x1;
  wire [16-1:0] delay5_q_net_x1;
  wire [16-1:0] delay5_q_net;
  wire [17-1:0] addsub2_s_net_x1;
  wire [18-1:0] addsub7_s_net_x0;
  wire [16-1:0] delay7_q_net_x1;
  wire [17-1:0] addsub4_s_net_x1;
  wire [16-1:0] delay5_q_net_x2;
  wire [16-1:0] delay6_q_net_x0;
  wire [17-1:0] addsub5_s_net_x1;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] delay4_q_net_x2;
  wire [16-1:0] delay2_q_net_x2;
  wire [18-1:0] addsub4_s_net_x0;
  wire [16-1:0] delay0_q_net;
  wire [18-1:0] addsub6_s_net_x0;
  wire [16-1:0] delay3_q_net;
  wire [16-1:0] delay7_q_net_x0;
  wire [17-1:0] addsub6_s_net_x1;
  wire [16-1:0] delay1_q_net_x0;
  wire [16-1:0] delay4_q_net_x0;
  wire [16-1:0] delay0_q_net_x2;
  wire [17-1:0] addsub1_s_net_x1;
  wire [19-1:0] addsub5_s_net;
  wire [16-1:0] delay1_q_net_x2;
  wire [16-1:0] delay3_q_net_x0;
  wire [16-1:0] delay2_q_net_x1;
  wire [18-1:0] addsub1_s_net_x0;
  wire [19-1:0] addsub7_s_net;
  wire [16-1:0] delay1_q_net_x1;
  wire [16-1:0] delay6_q_net_x1;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] delay6_q_net_x2;
  wire [16-1:0] delay3_q_net_x2;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay6_q_net;
  wire [18-1:0] addsub0_s_net_x0;
  wire [18-1:0] addsub5_s_net_x0;
  wire [19-1:0] addsub1_s_net;
  wire [19-1:0] addsub3_s_net;
  wire [19-1:0] addsub4_s_net;
  wire [17-1:0] addsub0_s_net_x1;
  wire [18-1:0] addsub2_s_net_x0;
  wire [16-1:0] delay2_q_net_x0;
  wire [19-1:0] addsub2_s_net;
  wire [18-1:0] addsub3_s_net_x0;
  wire [19-1:0] addsub0_s_net;
  wire [16-1:0] delay7_q_net_x2;
  wire [19-1:0] addsub6_s_net;
  wire [16-1:0] delay0_q_net_x0;
  assign out1_1 = addsub0_s_net_x6;
  assign out1_2 = addsub1_s_net_x6;
  assign out1_3 = addsub2_s_net_x6;
  assign out1_4 = addsub3_s_net_x6;
  assign out1_5 = addsub4_s_net_x6;
  assign out1_6 = addsub5_s_net_x6;
  assign out1_7 = addsub6_s_net_x6;
  assign out1_8 = addsub7_s_net_x6;
  assign reinterpret0_output_port_net_x0 = in1_1;
  assign reinterpret1_output_port_net_x0 = in1_2;
  assign reinterpret2_output_port_net = in1_3;
  assign reinterpret3_output_port_net = in1_4;
  assign reinterpret4_output_port_net = in1_5;
  assign reinterpret5_output_port_net = in1_6;
  assign reinterpret6_output_port_net = in1_7;
  assign reinterpret7_output_port_net = in1_8;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_vector_addsub_fabric1 vector_addsub_fabric1 (
    .a_1(reinterpret0_output_port_net_x0),
    .b_1(reinterpret0_output_port_net),
    .a_2(reinterpret1_output_port_net_x0),
    .a_3(reinterpret2_output_port_net),
    .a_4(reinterpret3_output_port_net),
    .a_5(reinterpret4_output_port_net),
    .a_6(reinterpret5_output_port_net),
    .a_7(reinterpret6_output_port_net),
    .a_8(reinterpret7_output_port_net),
    .b_2(reinterpret1_output_port_net),
    .b_3(reinterpret2_output_port_net_x0),
    .b_4(reinterpret3_output_port_net_x0),
    .b_5(reinterpret4_output_port_net_x0),
    .b_6(reinterpret5_output_port_net_x0),
    .b_7(reinterpret6_output_port_net_x0),
    .b_8(reinterpret7_output_port_net_x0),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .a_b_1(addsub0_s_net_x6),
    .a_b_2(addsub1_s_net_x6),
    .a_b_3(addsub2_s_net_x6),
    .a_b_4(addsub3_s_net_x6),
    .a_b_5(addsub4_s_net_x6),
    .a_b_6(addsub5_s_net_x6),
    .a_b_7(addsub6_s_net_x6),
    .a_b_8(addsub7_s_net_x6)
  );
  dsp_blr_vector_addsub_fabric2 vector_addsub_fabric2 (
    .a_1(reinterpret0_output_port_net_x0),
    .b_1(delay0_q_net_x5),
    .a_2(reinterpret1_output_port_net_x0),
    .a_3(reinterpret2_output_port_net),
    .a_4(reinterpret3_output_port_net),
    .a_5(reinterpret4_output_port_net),
    .a_6(reinterpret5_output_port_net),
    .a_7(reinterpret6_output_port_net),
    .a_8(reinterpret7_output_port_net),
    .b_2(delay1_q_net_x5),
    .b_3(delay2_q_net_x5),
    .b_4(delay3_q_net_x5),
    .b_5(delay4_q_net_x5),
    .b_6(delay5_q_net_x5),
    .b_7(delay6_q_net_x5),
    .b_8(delay7_q_net_x5),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .a_b_1(addsub0_s_net_x5),
    .a_b_2(addsub1_s_net_x5),
    .a_b_3(addsub2_s_net_x4),
    .a_b_4(addsub3_s_net_x5),
    .a_b_5(addsub4_s_net_x5),
    .a_b_6(addsub5_s_net_x5),
    .a_b_7(addsub6_s_net_x5),
    .a_b_8(addsub7_s_net_x5)
  );
  dsp_blr_vector_addsub_fabric3 vector_addsub_fabric3 (
    .a_1(delay0_q_net_x4),
    .b_1(delay0_q_net_x3),
    .a_2(delay1_q_net_x4),
    .a_3(delay2_q_net_x4),
    .a_4(delay3_q_net_x4),
    .a_5(delay4_q_net_x4),
    .a_6(delay5_q_net_x4),
    .a_7(delay6_q_net_x4),
    .a_8(delay7_q_net_x4),
    .b_2(delay1_q_net_x3),
    .b_3(delay2_q_net_x3),
    .b_4(delay3_q_net_x3),
    .b_5(delay4_q_net_x3),
    .b_6(delay5_q_net_x3),
    .b_7(delay6_q_net_x3),
    .b_8(delay7_q_net_x3),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .a_b_1(addsub0_s_net_x4),
    .a_b_2(addsub1_s_net_x4),
    .a_b_3(addsub2_s_net_x3),
    .a_b_4(addsub3_s_net_x4),
    .a_b_5(addsub4_s_net_x4),
    .a_b_6(addsub5_s_net_x4),
    .a_b_7(addsub6_s_net_x4),
    .a_b_8(addsub7_s_net_x4)
  );
  dsp_blr_vector_addsub_fabric4 vector_addsub_fabric4 (
    .a_1(addsub0_s_net_x5),
    .b_1(addsub0_s_net_x4),
    .a_2(addsub1_s_net_x5),
    .a_3(addsub2_s_net_x4),
    .a_4(addsub3_s_net_x5),
    .a_5(addsub4_s_net_x5),
    .a_6(addsub5_s_net_x5),
    .a_7(addsub6_s_net_x5),
    .a_8(addsub7_s_net_x5),
    .b_2(addsub1_s_net_x4),
    .b_3(addsub2_s_net_x3),
    .b_4(addsub3_s_net_x4),
    .b_5(addsub4_s_net_x4),
    .b_6(addsub5_s_net_x4),
    .b_7(addsub6_s_net_x4),
    .b_8(addsub7_s_net_x4),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .a_b_1(addsub0_s_net_x3),
    .a_b_2(addsub1_s_net_x3),
    .a_b_3(addsub2_s_net_x5),
    .a_b_4(addsub3_s_net_x3),
    .a_b_5(addsub4_s_net_x3),
    .a_b_6(addsub5_s_net_x3),
    .a_b_7(addsub6_s_net_x3),
    .a_b_8(addsub7_s_net_x3)
  );
  dsp_blr_vector_addsub_fabric5 vector_addsub_fabric5 (
    .a_1(delay0_q_net_x2),
    .b_1(delay0_q_net_x0),
    .a_2(delay1_q_net_x2),
    .a_3(delay2_q_net_x2),
    .a_4(delay3_q_net_x2),
    .a_5(delay4_q_net_x2),
    .a_6(delay5_q_net_x2),
    .a_7(delay6_q_net_x2),
    .a_8(delay7_q_net_x2),
    .b_2(delay1_q_net_x0),
    .b_3(delay2_q_net_x0),
    .b_4(delay3_q_net_x0),
    .b_5(delay4_q_net_x0),
    .b_6(delay5_q_net_x0),
    .b_7(delay6_q_net_x0),
    .b_8(delay7_q_net_x0),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .a_b_1(addsub0_s_net_x2),
    .a_b_2(addsub1_s_net_x2),
    .a_b_3(addsub2_s_net_x2),
    .a_b_4(addsub3_s_net_x2),
    .a_b_5(addsub4_s_net_x2),
    .a_b_6(addsub5_s_net_x2),
    .a_b_7(addsub6_s_net_x2),
    .a_b_8(addsub7_s_net_x2)
  );
  dsp_blr_vector_addsub_fabric6 vector_addsub_fabric6 (
    .a_1(delay0_q_net_x1),
    .b_1(delay0_q_net),
    .a_2(delay1_q_net_x1),
    .a_3(delay2_q_net_x1),
    .a_4(delay3_q_net_x1),
    .a_5(delay4_q_net_x1),
    .a_6(delay5_q_net_x1),
    .a_7(delay6_q_net_x1),
    .a_8(delay7_q_net_x1),
    .b_2(delay1_q_net),
    .b_3(delay2_q_net),
    .b_4(delay3_q_net),
    .b_5(delay4_q_net),
    .b_6(delay5_q_net),
    .b_7(delay6_q_net),
    .b_8(delay7_q_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .a_b_1(addsub0_s_net_x1),
    .a_b_2(addsub1_s_net_x1),
    .a_b_3(addsub2_s_net_x1),
    .a_b_4(addsub3_s_net_x1),
    .a_b_5(addsub4_s_net_x1),
    .a_b_6(addsub5_s_net_x1),
    .a_b_7(addsub6_s_net_x1),
    .a_b_8(addsub7_s_net_x1)
  );
  dsp_blr_vector_addsub_fabric7 vector_addsub_fabric7 (
    .a_1(addsub0_s_net_x2),
    .b_1(addsub0_s_net_x1),
    .a_2(addsub1_s_net_x2),
    .a_3(addsub2_s_net_x2),
    .a_4(addsub3_s_net_x2),
    .a_5(addsub4_s_net_x2),
    .a_6(addsub5_s_net_x2),
    .a_7(addsub6_s_net_x2),
    .a_8(addsub7_s_net_x2),
    .b_2(addsub1_s_net_x1),
    .b_3(addsub2_s_net_x1),
    .b_4(addsub3_s_net_x1),
    .b_5(addsub4_s_net_x1),
    .b_6(addsub5_s_net_x1),
    .b_7(addsub6_s_net_x1),
    .b_8(addsub7_s_net_x1),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .a_b_1(addsub0_s_net_x0),
    .a_b_2(addsub1_s_net_x0),
    .a_b_3(addsub2_s_net_x0),
    .a_b_4(addsub3_s_net_x0),
    .a_b_5(addsub4_s_net_x0),
    .a_b_6(addsub5_s_net_x0),
    .a_b_7(addsub6_s_net_x0),
    .a_b_8(addsub7_s_net_x0)
  );
  dsp_blr_vector_addsub_fabric8 vector_addsub_fabric8 (
    .a_1(addsub0_s_net_x3),
    .b_1(addsub0_s_net_x0),
    .a_2(addsub1_s_net_x3),
    .a_3(addsub2_s_net_x5),
    .a_4(addsub3_s_net_x3),
    .a_5(addsub4_s_net_x3),
    .a_6(addsub5_s_net_x3),
    .a_7(addsub6_s_net_x3),
    .a_8(addsub7_s_net_x3),
    .b_2(addsub1_s_net_x0),
    .b_3(addsub2_s_net_x0),
    .b_4(addsub3_s_net_x0),
    .b_5(addsub4_s_net_x0),
    .b_6(addsub5_s_net_x0),
    .b_7(addsub6_s_net_x0),
    .b_8(addsub7_s_net_x0),
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
  dsp_blr_vector_delay vector_delay (
    .d_1(reinterpret0_output_port_net_x0),
    .d_2(reinterpret1_output_port_net_x0),
    .d_3(reinterpret2_output_port_net),
    .d_4(reinterpret3_output_port_net),
    .d_5(reinterpret4_output_port_net),
    .d_6(reinterpret5_output_port_net),
    .d_7(reinterpret6_output_port_net),
    .d_8(reinterpret7_output_port_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .q_1(delay0_q_net_x5),
    .q_2(delay1_q_net_x5),
    .q_3(delay2_q_net_x5),
    .q_4(delay3_q_net_x5),
    .q_5(delay4_q_net_x5),
    .q_6(delay5_q_net_x5),
    .q_7(delay6_q_net_x5),
    .q_8(delay7_q_net_x5)
  );
  dsp_blr_vector_delay1 vector_delay1 (
    .d_1(reinterpret0_output_port_net_x0),
    .d_2(reinterpret1_output_port_net_x0),
    .d_3(reinterpret2_output_port_net),
    .d_4(reinterpret3_output_port_net),
    .d_5(reinterpret4_output_port_net),
    .d_6(reinterpret5_output_port_net),
    .d_7(reinterpret6_output_port_net),
    .d_8(reinterpret7_output_port_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .q_1(delay0_q_net_x4),
    .q_2(delay1_q_net_x4),
    .q_3(delay2_q_net_x4),
    .q_4(delay3_q_net_x4),
    .q_5(delay4_q_net_x4),
    .q_6(delay5_q_net_x4),
    .q_7(delay6_q_net_x4),
    .q_8(delay7_q_net_x4)
  );
  dsp_blr_vector_delay2 vector_delay2 (
    .d_1(reinterpret0_output_port_net_x0),
    .d_2(reinterpret1_output_port_net_x0),
    .d_3(reinterpret2_output_port_net),
    .d_4(reinterpret3_output_port_net),
    .d_5(reinterpret4_output_port_net),
    .d_6(reinterpret5_output_port_net),
    .d_7(reinterpret6_output_port_net),
    .d_8(reinterpret7_output_port_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .q_1(delay0_q_net_x3),
    .q_2(delay1_q_net_x3),
    .q_3(delay2_q_net_x3),
    .q_4(delay3_q_net_x3),
    .q_5(delay4_q_net_x3),
    .q_6(delay5_q_net_x3),
    .q_7(delay6_q_net_x3),
    .q_8(delay7_q_net_x3)
  );
  dsp_blr_vector_delay3 vector_delay3 (
    .d_1(reinterpret0_output_port_net_x0),
    .d_2(reinterpret1_output_port_net_x0),
    .d_3(reinterpret2_output_port_net),
    .d_4(reinterpret3_output_port_net),
    .d_5(reinterpret4_output_port_net),
    .d_6(reinterpret5_output_port_net),
    .d_7(reinterpret6_output_port_net),
    .d_8(reinterpret7_output_port_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .q_1(delay0_q_net_x2),
    .q_2(delay1_q_net_x2),
    .q_3(delay2_q_net_x2),
    .q_4(delay3_q_net_x2),
    .q_5(delay4_q_net_x2),
    .q_6(delay5_q_net_x2),
    .q_7(delay6_q_net_x2),
    .q_8(delay7_q_net_x2)
  );
  dsp_blr_vector_delay4 vector_delay4 (
    .d_1(reinterpret0_output_port_net_x0),
    .d_2(reinterpret1_output_port_net_x0),
    .d_3(reinterpret2_output_port_net),
    .d_4(reinterpret3_output_port_net),
    .d_5(reinterpret4_output_port_net),
    .d_6(reinterpret5_output_port_net),
    .d_7(reinterpret6_output_port_net),
    .d_8(reinterpret7_output_port_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .q_1(delay0_q_net_x1),
    .q_2(delay1_q_net_x1),
    .q_3(delay2_q_net_x1),
    .q_4(delay3_q_net_x1),
    .q_5(delay4_q_net_x1),
    .q_6(delay5_q_net_x1),
    .q_7(delay6_q_net_x1),
    .q_8(delay7_q_net_x1)
  );
  dsp_blr_vector_delay5 vector_delay5 (
    .d_1(reinterpret0_output_port_net_x0),
    .d_2(reinterpret1_output_port_net_x0),
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
    .q_6(delay5_q_net_x0),
    .q_7(delay6_q_net_x0),
    .q_8(delay7_q_net_x0)
  );
  dsp_blr_vector_delay6 vector_delay6 (
    .d_1(reinterpret0_output_port_net_x0),
    .d_2(reinterpret1_output_port_net_x0),
    .d_3(reinterpret2_output_port_net),
    .d_4(reinterpret3_output_port_net),
    .d_5(reinterpret4_output_port_net),
    .d_6(reinterpret5_output_port_net),
    .d_7(reinterpret6_output_port_net),
    .d_8(reinterpret7_output_port_net),
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
  dsp_blr_vector_reinterpret1 vector_reinterpret1 (
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
    .out_3(reinterpret2_output_port_net_x0),
    .out_4(reinterpret3_output_port_net_x0),
    .out_5(reinterpret4_output_port_net_x0),
    .out_6(reinterpret5_output_port_net_x0),
    .out_7(reinterpret6_output_port_net_x0),
    .out_8(reinterpret7_output_port_net_x0)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr/Vector Reinterpret
module dsp_blr_vector_reinterpret (
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
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice2_y_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [16-1:0] slice6_y_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] slice4_y_net;
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
  sysgen_reinterpret_879cf4842d reinterpret0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice0_y_net),
    .output_port(reinterpret0_output_port_net)
  );
  sysgen_reinterpret_879cf4842d reinterpret1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice1_y_net),
    .output_port(reinterpret1_output_port_net)
  );
  sysgen_reinterpret_879cf4842d reinterpret2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice2_y_net),
    .output_port(reinterpret2_output_port_net)
  );
  sysgen_reinterpret_879cf4842d reinterpret3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice3_y_net),
    .output_port(reinterpret3_output_port_net)
  );
  sysgen_reinterpret_879cf4842d reinterpret4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice4_y_net),
    .output_port(reinterpret4_output_port_net)
  );
  sysgen_reinterpret_879cf4842d reinterpret5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice5_y_net),
    .output_port(reinterpret5_output_port_net)
  );
  sysgen_reinterpret_879cf4842d reinterpret6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice6_y_net),
    .output_port(reinterpret6_output_port_net)
  );
  sysgen_reinterpret_879cf4842d reinterpret7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .input_port(slice7_y_net),
    .output_port(reinterpret7_output_port_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_struct
module dsp_blr_struct (
  input [128-1:0] h_s_axis_tdata,
  input [1-1:0] h_s_axis_tvalid,
  input [32-1:0] l_s_axis_tdata,
  input [1-1:0] l_s_axis_tvalid,
  input clk_1,
  input ce_1,
  output [160-1:0] dsp_m_axis_tdata,
  output [1-1:0] dsp_m_axis_tvalid,
  output [128-1:0] h_m_axis_tdata,
  output [1-1:0] h_m_axis_tvalid,
  output [32-1:0] l_m_axis_tdata,
  output [1-1:0] l_m_axis_tvalid
);
  wire [128-1:0] h_s_axis_tdata_net;
  wire [16-1:0] delay0_q_net_x0;
  wire clk_net;
  wire [16-1:0] delay5_q_net;
  wire [16-1:0] delay0_q_net;
  wire [20-1:0] addsub2_s_net;
  wire [16-1:0] slice2_y_net;
  wire [20-1:0] addsub1_s_net;
  wire [20-1:0] addsub6_s_net;
  wire [16-1:0] slice3_y_net;
  wire [16-1:0] slice5_y_net;
  wire [16-1:0] slice4_y_net;
  wire [1-1:0] delay_q_net;
  wire [16-1:0] delay4_q_net;
  wire [16-1:0] reinterpret6_output_port_net;
  wire [128-1:0] concat1_y_net;
  wire [32-1:0] l_gain_tdata_delay_q_net;
  wire [16-1:0] reinterpret3_output_port_net;
  wire [1-1:0] h_s_axis_tvalid_net;
  wire [1-1:0] l_s_axis_tvalid_net;
  wire [16-1:0] delay7_q_net;
  wire [16-1:0] reinterpret5_output_port_net;
  wire [20-1:0] addsub5_s_net;
  wire [16-1:0] delay3_q_net_x0;
  wire [16-1:0] delay4_q_net_x0;
  wire [16-1:0] reinterpret0_output_port_net;
  wire [16-1:0] delay1_q_net;
  wire [16-1:0] delay6_q_net_x0;
  wire [16-1:0] delay5_q_net_x0;
  wire [32-1:0] l_s_axis_tdata_net;
  wire [16-1:0] reinterpret2_output_port_net;
  wire [16-1:0] delay7_q_net_x0;
  wire [160-1:0] concat1_y_net_x0;
  wire [20-1:0] addsub7_s_net;
  wire [16-1:0] delay1_q_net_x0;
  wire [20-1:0] addsub3_s_net;
  wire [16-1:0] delay2_q_net;
  wire [16-1:0] delay3_q_net;
  wire [20-1:0] addsub0_s_net;
  wire [20-1:0] addsub4_s_net;
  wire [16-1:0] reinterpret4_output_port_net;
  wire [16-1:0] reinterpret7_output_port_net;
  wire [1-1:0] l_gain_tvalid_delay_q_net;
  wire ce_net;
  wire [16-1:0] delay6_q_net;
  wire [16-1:0] delay2_q_net_x0;
  wire [16-1:0] slice0_y_net;
  wire [16-1:0] slice1_y_net;
  wire [16-1:0] reinterpret1_output_port_net;
  wire [16-1:0] slice7_y_net;
  wire [16-1:0] slice6_y_net;
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
  dsp_blr_dsp_vector2scalar dsp_vector2scalar (
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
  dsp_blr_dsp_delay dsp_delay (
    .d_1(reinterpret0_output_port_net),
    .d_2(reinterpret1_output_port_net),
    .d_3(reinterpret2_output_port_net),
    .d_4(reinterpret3_output_port_net),
    .d_5(reinterpret4_output_port_net),
    .d_6(reinterpret5_output_port_net),
    .d_7(reinterpret6_output_port_net),
    .d_8(reinterpret7_output_port_net),
    .q_1(delay0_q_net_x0),
    .q_2(delay1_q_net_x0),
    .q_3(delay2_q_net),
    .q_4(delay3_q_net),
    .q_5(delay4_q_net),
    .q_6(delay5_q_net),
    .q_7(delay6_q_net),
    .q_8(delay7_q_net)
  );
  dsp_blr_hgain_vector2scalar hgain_vector2scalar (
    .in1_1(delay0_q_net),
    .in1_2(delay1_q_net),
    .in1_3(delay2_q_net_x0),
    .in1_4(delay3_q_net_x0),
    .in1_5(delay4_q_net_x0),
    .in1_6(delay5_q_net_x0),
    .in1_7(delay6_q_net_x0),
    .in1_8(delay7_q_net_x0),
    .out1(concat1_y_net)
  );
  dsp_blr_hgain_delay hgain_delay (
    .d_1(delay0_q_net_x0),
    .d_2(delay1_q_net_x0),
    .d_3(delay2_q_net),
    .d_4(delay3_q_net),
    .d_5(delay4_q_net),
    .d_6(delay5_q_net),
    .d_7(delay6_q_net),
    .d_8(delay7_q_net),
    .q_1(delay0_q_net),
    .q_2(delay1_q_net),
    .q_3(delay2_q_net_x0),
    .q_4(delay3_q_net_x0),
    .q_5(delay4_q_net_x0),
    .q_6(delay5_q_net_x0),
    .q_7(delay6_q_net_x0),
    .q_8(delay7_q_net_x0)
  );
  dsp_blr_scalar2vector scalar2vector (
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
  dsp_blr_subsystem subsystem (
    .in1_1(reinterpret0_output_port_net),
    .in1_2(reinterpret1_output_port_net),
    .in1_3(reinterpret2_output_port_net),
    .in1_4(reinterpret3_output_port_net),
    .in1_5(reinterpret4_output_port_net),
    .in1_6(reinterpret5_output_port_net),
    .in1_7(reinterpret6_output_port_net),
    .in1_8(reinterpret7_output_port_net),
    .clk_1(clk_net),
    .ce_1(ce_net),
    .out1_1(addsub0_s_net),
    .out1_2(addsub1_s_net),
    .out1_3(addsub2_s_net),
    .out1_4(addsub3_s_net),
    .out1_5(addsub4_s_net),
    .out1_6(addsub5_s_net),
    .out1_7(addsub6_s_net),
    .out1_8(addsub7_s_net)
  );
  dsp_blr_vector_reinterpret vector_reinterpret (
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
  sysgen_delay_19fd257691 delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(h_s_axis_tvalid_net),
    .q(delay_q_net)
  );
  sysgen_delay_1e8a7a1cc3 l_gain_tdata_delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(l_s_axis_tdata_net),
    .q(l_gain_tdata_delay_q_net)
  );
  sysgen_delay_19fd257691 l_gain_tvalid_delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(l_s_axis_tvalid_net),
    .q(l_gain_tvalid_delay_q_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
module dsp_blr_default_clock_driver (
  input dsp_blr_sysclk,
  input dsp_blr_sysce,
  input dsp_blr_sysclr,
  output dsp_blr_clk1,
  output dsp_blr_ce1
);
  xlclockdriver #(
    .period(1),
    .log_2_period(1)
  )
  clockdriver (
    .sysclk(dsp_blr_sysclk),
    .sysce(dsp_blr_sysce),
    .sysclr(dsp_blr_sysclr),
    .clk(dsp_blr_clk1),
    .ce(dsp_blr_ce1)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
(* core_generation_info = "dsp_blr,sysgen_core_2019_1,{,compilation=IP Catalog,block_icon_display=Default,family=zynquplusRFSOC,part=xczu29dr,speed=-1-e,package=ffvf1760,synthesis_language=verilog,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=1,interface_doc=1,ce_clr=0,clock_period=8,system_simulink_period=8e-09,waveform_viewer=1,axilite_interface=0,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=0.0001,addsub=64,concat=2,delay=75,reinterpret=32,slice=8,}" *)
module dsp_blr (
  input [128-1:0] h_s_axis_tdata,
  input [1-1:0] h_s_axis_tvalid,
  input [32-1:0] l_s_axis_tdata,
  input [1-1:0] l_s_axis_tvalid,
  input clk,
  output [160-1:0] dsp_m_axis_tdata,
  output [1-1:0] dsp_m_axis_tvalid,
  output [128-1:0] h_m_axis_tdata,
  output [1-1:0] h_m_axis_tvalid,
  output [32-1:0] l_m_axis_tdata,
  output [1-1:0] l_m_axis_tvalid
);
  wire clk_1_net;
  wire ce_1_net;
  dsp_blr_default_clock_driver dsp_blr_default_clock_driver (
    .dsp_blr_sysclk(clk),
    .dsp_blr_sysce(1'b1),
    .dsp_blr_sysclr(1'b0),
    .dsp_blr_clk1(clk_1_net),
    .dsp_blr_ce1(ce_1_net)
  );
  dsp_blr_struct dsp_blr_struct (
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
