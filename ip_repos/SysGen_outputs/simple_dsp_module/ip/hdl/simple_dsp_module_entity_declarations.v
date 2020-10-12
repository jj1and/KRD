//-----------------------------------------------------------------
// System Generator version 2019.1 Verilog source file.
//
// Copyright(C) 2019 by Xilinx, Inc.  All rights reserved.  This
// text/file contains proprietary, confidential information of Xilinx,
// Inc., is distributed under license from Xilinx, Inc., and may be used,
// copied and/or disclosed only pursuant to the terms of a valid license
// agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
// this text/file solely for design, simulation, implementation and
// creation of design files limited to Xilinx devices or technologies.
// Use with non-Xilinx devices or technologies is expressly prohibited
// and immediately terminates your license unless covered by a separate
// agreement.
//
// Xilinx is providing this design, code, or information "as is" solely
// for use in developing programs and solutions for Xilinx devices.  By
// providing this design, code, or information as one possible
// implementation of this feature, application or standard, Xilinx is
// making no representation that this implementation is free from any
// claims of infringement.  You are responsible for obtaining any rights
// you may require for your implementation.  Xilinx expressly disclaims
// any warranty whatsoever with respect to the adequacy of the
// implementation, including but not limited to warranties of
// merchantability or fitness for a particular purpose.
//
// Xilinx products are not intended for use in life support appliances,
// devices, or systems.  Use in such applications is expressly prohibited.
//
// Any modifications that are made to the source code are done at the user's
// sole risk and will be unsupported.
//
// This copyright and support notice must be retained as part of this
// text at all times.  (c) Copyright 1995-2019 Xilinx, Inc.  All rights
// reserved.
//-----------------------------------------------------------------

`include "conv_pkg.v"
`timescale 1 ns / 10 ps


module simple_dsp_module_xlconvert (din, clk, ce, clr, en, dout);

//Parameter Definitions
   parameter din_width= 16;
   parameter din_bin_pt= 4;
   parameter din_arith= `xlUnsigned;
   parameter dout_width= 8;
   parameter dout_bin_pt= 2;
   parameter dout_arith= `xlUnsigned;
   parameter en_width = 1;
   parameter en_bin_pt = 0;
   parameter en_arith = `xlUnsigned;
   parameter bool_conversion = 0;
   parameter latency = 0;
   parameter quantization= `xlTruncate;
   parameter overflow= `xlWrap;

//Port Declartions
   input [din_width-1:0] din;
   input clk, ce, clr;
   input [en_width-1:0] en;
   output [dout_width-1:0] dout;

//Wire Declartions
   wire [dout_width-1:0]   result;
   wire internal_ce;
   assign internal_ce = ce & en[0];

generate
 if (bool_conversion == 1)
    begin:bool_converion_generate
       assign result = din;
    end
 else
    begin:std_conversion
       convert_type #(din_width,
                      din_bin_pt,
                      din_arith,
		              dout_width,
                      dout_bin_pt,
                      dout_arith,
                      quantization,
                      overflow)
        conv_udp (.inp(din), .res(result));
    end
endgenerate

generate
if (latency > 0)
     begin:latency_test
	synth_reg # (dout_width, latency)
	  reg1 (
	       .i(result),
	       .ce(internal_ce),
	       .clr(clr),
	       .clk(clk),
	       .o(dout));
     end
else
     begin:latency0
	assign dout = result;
     end
endgenerate

endmodule

`timescale 1 ns / 10 ps
module simple_dsp_module_xldelay #(parameter width = -1, latency = -1, reg_retiming = 0, reset = 0)
  (input [width-1:0] d,
   input ce, clk, en, rst,
   output [width-1:0] q);

generate
  if ((latency == 0) || ((reg_retiming == 0) && (reset == 0)))
  begin:srl_delay
    synth_reg # (width, latency)
      reg1 (
        .i(d),
        .ce(ce & en),
        .clr(1'b0),
        .clk(clk),
        .o(q));
  end

  if ((latency>=1) && ((reg_retiming) || (reset)))
  begin:reg_delay
    synth_reg_reg # (width, latency)
      reg2 (
        .i(d),
        .ce(ce & en),
        .clr(rst),
        .clk(clk),
        .o(q));
  end
endgenerate
endmodule
`timescale 1 ns / 10 ps
module sysgen_reinterpret_45d55ecbc1 (
  input [(16 - 1):0] input_port,
  output [(16 - 1):0] output_port,
  input clk,
  input ce,
  input clr);
  wire [(16 - 1):0] input_port_1_40;
  wire signed [(16 - 1):0] output_port_5_5_force;
  assign input_port_1_40 = input_port;
  assign output_port_5_5_force = input_port_1_40;
  assign output_port = output_port_5_5_force;
endmodule
`timescale 1 ns / 10 ps

module  simple_dsp_module_xlslice  (x, y);

//Parameter Definitions
parameter new_msb= 9;
parameter new_lsb= 1;
parameter x_width= 16;
parameter y_width= 8;

//Port Declartions
input [x_width-1:0] x;
output [y_width-1:0] y;

assign y = x[new_msb:new_lsb];

endmodule
`timescale 1 ns / 10 ps
module sysgen_reinterpret_2e11a5155c (
  input [(16 - 1):0] input_port,
  output [(16 - 1):0] output_port,
  input clk,
  input ce,
  input clr);
  wire signed [(16 - 1):0] input_port_1_40;
  wire [(16 - 1):0] output_port_5_5_force;
  assign input_port_1_40 = input_port;
  assign output_port_5_5_force = input_port_1_40;
  assign output_port = output_port_5_5_force;
endmodule
`timescale 1 ns / 10 ps
module sysgen_concat_1221d5c9f7 (
  input [(16 - 1):0] in0,
  input [(16 - 1):0] in1,
  input [(16 - 1):0] in2,
  input [(16 - 1):0] in3,
  input [(16 - 1):0] in4,
  input [(16 - 1):0] in5,
  input [(16 - 1):0] in6,
  input [(16 - 1):0] in7,
  output [(128 - 1):0] y,
  input clk,
  input ce,
  input clr);
  wire [(16 - 1):0] in0_1_23;
  wire [(16 - 1):0] in1_1_27;
  wire [(16 - 1):0] in2_1_31;
  wire [(16 - 1):0] in3_1_35;
  wire [(16 - 1):0] in4_1_39;
  wire [(16 - 1):0] in5_1_43;
  wire [(16 - 1):0] in6_1_47;
  wire [(16 - 1):0] in7_1_51;
  wire [(128 - 1):0] y_2_1_concat;
  assign in0_1_23 = in0;
  assign in1_1_27 = in1;
  assign in2_1_31 = in2;
  assign in3_1_35 = in3;
  assign in4_1_39 = in4;
  assign in5_1_43 = in5;
  assign in6_1_47 = in6;
  assign in7_1_51 = in7;
  assign y_2_1_concat = {in0_1_23, in1_1_27, in2_1_31, in3_1_35, in4_1_39, in5_1_43, in6_1_47, in7_1_51};
  assign y = y_2_1_concat;
endmodule
`timescale 1 ns / 10 ps
module sysgen_shift_4a50d33dfe (
  input [(19 - 1):0] ip,
  output [(19 - 1):0] op,
  input clk,
  input ce,
  input clr);
  wire signed [(19 - 1):0] ip_1_23;
  localparam signed [(19 - 1):0] const_value = 19'sb0000000000000000000;
  reg signed [(19 - 1):0] op_mem_46_20[0:(1 - 1)];
  initial
    begin
      op_mem_46_20[0] = 19'b0000000000000000000;
    end
  wire signed [(19 - 1):0] op_mem_46_20_front_din;
  wire signed [(19 - 1):0] op_mem_46_20_back;
  wire op_mem_46_20_push_front_pop_back_en;
  localparam [(1 - 1):0] const_value_x_000000 = 1'b1;
  wire signed [(19 - 1):0] cast_internal_ip_36_3_convert;
  assign ip_1_23 = ip;
  assign op_mem_46_20_back = op_mem_46_20[0];
  always @(posedge clk)
    begin:proc_op_mem_46_20
      integer i;
      if (((ce == 1'b1) && (op_mem_46_20_push_front_pop_back_en == 1'b1)))
        begin
          op_mem_46_20[0] <= op_mem_46_20_front_din;
        end
    end
  assign cast_internal_ip_36_3_convert = {{3{ip_1_23[18]}}, ip_1_23[18:3]};
  assign op_mem_46_20_front_din = cast_internal_ip_36_3_convert;
  assign op_mem_46_20_push_front_pop_back_en = 1'b1;
  assign op = op_mem_46_20_back;
endmodule
`timescale 1 ns / 10 ps
module sysgen_accum_65a68633b7 (
  input [(20 - 1):0] b,
  input [(1 - 1):0] rst,
  output [(32 - 1):0] q,
  input clk,
  input ce,
  input clr);
  wire signed [(20 - 1):0] b_17_24;
  wire rst_17_27;
  wire signed [(32 - 1):0] accum_reg_39_23_next;
  reg signed [(32 - 1):0] accum_reg_39_23 = 32'b00000000000000000000000000000000;
  localparam [(1 - 1):0] const_value = 1'b1;
  localparam [(1 - 1):0] const_value_x_000000 = 1'b1;
  wire signed [(33 - 1):0] cast_49_22;
  wire signed [(33 - 1):0] cast_49_42;
  wire signed [(33 - 1):0] accum_reg_49_9_addsub;
  reg signed [(33 - 1):0] accum_reg_join_45_1;
  wire signed [(32 - 1):0] cast_accum_reg_39_23_next;
  assign b_17_24 = b;
  assign rst_17_27 = rst;
  always @(posedge clk)
    begin:proc_accum_reg_39_23
      if ((ce == 1'b1))
        begin
          accum_reg_39_23 <= accum_reg_39_23_next;
        end
    end
  assign cast_49_22 = {{1{accum_reg_39_23[31]}}, accum_reg_39_23[31:0]};
  assign cast_49_42 = {{13{b_17_24[19]}}, b_17_24[19:0]};
  assign accum_reg_49_9_addsub = cast_49_22 + cast_49_42;
  always @(accum_reg_49_9_addsub or b_17_24 or rst_17_27)
    begin:proc_if_45_1
      if (rst_17_27)
        begin
          accum_reg_join_45_1 = {{13{b_17_24[19]}}, b_17_24[19:0]};
        end
      else 
        begin
          accum_reg_join_45_1 = accum_reg_49_9_addsub;
        end
    end
  assign cast_accum_reg_39_23_next = {accum_reg_join_45_1[31:0]};
  assign accum_reg_39_23_next = cast_accum_reg_39_23_next;
  assign q = accum_reg_39_23;
endmodule
`timescale 1 ns / 10 ps
module sysgen_constant_4cf6c9391e (
  output [(16 - 1):0] op,
  input clk,
  input ce,
  input clr);
  assign op = 16'b0000001110111110;
endmodule
`timescale 1 ns / 10 ps
module sysgen_inverter_9355411c35 (
  input [(1 - 1):0] ip,
  output [(1 - 1):0] op,
  input clk,
  input ce,
  input clr);
  wire ip_1_26;
  reg op_mem_22_20[0:(1 - 1)];
  initial
    begin
      op_mem_22_20[0] = 1'b0;
    end
  wire op_mem_22_20_front_din;
  wire op_mem_22_20_back;
  wire op_mem_22_20_push_front_pop_back_en;
  localparam [(1 - 1):0] const_value = 1'b1;
  wire internal_ip_12_1_bitnot;
  assign ip_1_26 = ip;
  assign op_mem_22_20_back = op_mem_22_20[0];
  always @(posedge clk)
    begin:proc_op_mem_22_20
      integer i;
      if (((ce == 1'b1) && (op_mem_22_20_push_front_pop_back_en == 1'b1)))
        begin
          op_mem_22_20[0] <= op_mem_22_20_front_din;
        end
    end
  assign internal_ip_12_1_bitnot = ~ip_1_26;
  assign op_mem_22_20_push_front_pop_back_en = 1'b0;
  assign op = internal_ip_12_1_bitnot;
endmodule
`timescale 1 ns / 10 ps
module sysgen_logical_5a019e3573 (
  input [(1 - 1):0] d0,
  input [(1 - 1):0] d1,
  output [(1 - 1):0] y,
  input clk,
  input ce,
  input clr);
  wire d0_1_24;
  wire d1_1_27;
  wire fully_2_1_bit;
  assign d0_1_24 = d0;
  assign d1_1_27 = d1;
  assign fully_2_1_bit = d0_1_24 | d1_1_27;
  assign y = fully_2_1_bit;
endmodule
`timescale 1 ns / 10 ps
module sysgen_constant_bc9615795b (
  output [(16 - 1):0] op,
  input clk,
  input ce,
  input clr);
  assign op = 16'b0000000111011111;
endmodule
`timescale 1 ns / 10 ps
module sysgen_constant_acba946d69 (
  output [(16 - 1):0] op,
  input clk,
  input ce,
  input clr);
  assign op = 16'b0000000000000000;
endmodule
`timescale 1 ns / 10 ps
module sysgen_logical_75b30515b9 (
  input [(1 - 1):0] d0,
  input [(1 - 1):0] d1,
  output [(1 - 1):0] y,
  input clk,
  input ce,
  input clr);
  wire d0_1_24;
  wire d1_1_27;
  wire fully_2_1_bit;
  wire [(1 - 1):0] unregy_3_1_convert;
  assign d0_1_24 = d0;
  assign d1_1_27 = d1;
  assign fully_2_1_bit = d0_1_24 & d1_1_27;
  assign unregy_3_1_convert = {fully_2_1_bit};
  assign y = unregy_3_1_convert;
endmodule
`timescale 1 ns / 10 ps
module sysgen_relational_56fa687b43 (
  input [(19 - 1):0] a,
  input [(16 - 1):0] b,
  output [(1 - 1):0] op,
  input clk,
  input ce,
  input clr);
  wire signed [(19 - 1):0] a_1_31;
  wire signed [(16 - 1):0] b_1_34;
  localparam [(1 - 1):0] const_value = 1'b1;
  wire signed [(19 - 1):0] cast_18_16;
  wire result_18_3_rel;
  assign a_1_31 = a;
  assign b_1_34 = b;
  assign cast_18_16 = {{3{b_1_34[15]}}, b_1_34[15:0]};
  assign result_18_3_rel = a_1_31 > cast_18_16;
  assign op = result_18_3_rel;
endmodule
`timescale 1 ns / 10 ps
module sysgen_relational_eb6769c3da (
  input [(16 - 1):0] a,
  input [(16 - 1):0] b,
  output [(1 - 1):0] op,
  input clk,
  input ce,
  input clr);
  wire signed [(16 - 1):0] a_1_31;
  wire signed [(16 - 1):0] b_1_34;
  localparam [(1 - 1):0] const_value = 1'b1;
  wire signed [(18 - 1):0] cast_18_12;
  wire signed [(18 - 1):0] cast_18_16;
  wire result_18_3_rel;
  assign a_1_31 = a;
  assign b_1_34 = b;
  assign cast_18_12 = {a_1_31[15:0], 2'b00};
  assign cast_18_16 = {{2{b_1_34[15]}}, b_1_34[15:0]};
  assign result_18_3_rel = cast_18_12 > cast_18_16;
  assign op = result_18_3_rel;
endmodule
`timescale 1 ns / 10 ps
module sysgen_shift_ce2cc87a73 (
  input [(50 - 1):0] ip,
  output [(50 - 1):0] op,
  input clk,
  input ce,
  input clr);
  wire signed [(50 - 1):0] ip_1_23;
  localparam signed [(50 - 1):0] const_value = 50'sb00000000000000000000000000000000000000000000000000;
  reg signed [(50 - 1):0] op_mem_46_20[0:(1 - 1)];
  initial
    begin
      op_mem_46_20[0] = 50'b00000000000000000000000000000000000000000000000000;
    end
  wire signed [(50 - 1):0] op_mem_46_20_front_din;
  wire signed [(50 - 1):0] op_mem_46_20_back;
  wire op_mem_46_20_push_front_pop_back_en;
  localparam [(1 - 1):0] const_value_x_000000 = 1'b1;
  wire signed [(50 - 1):0] cast_internal_ip_36_3_convert;
  assign ip_1_23 = ip;
  assign op_mem_46_20_back = op_mem_46_20[0];
  always @(posedge clk)
    begin:proc_op_mem_46_20
      integer i;
      if (((ce == 1'b1) && (op_mem_46_20_push_front_pop_back_en == 1'b1)))
        begin
          op_mem_46_20[0] <= op_mem_46_20_front_din;
        end
    end
  assign cast_internal_ip_36_3_convert = {{1{ip_1_23[49]}}, ip_1_23[49:1]};
  assign op_mem_46_20_push_front_pop_back_en = 1'b0;
  assign op = cast_internal_ip_36_3_convert;
endmodule
`timescale 1 ns / 10 ps
module sysgen_accum_63d8a07e86 (
  input [(21 - 1):0] b,
  input [(1 - 1):0] rst,
  output [(32 - 1):0] q,
  input clk,
  input ce,
  input clr);
  wire signed [(21 - 1):0] b_17_24;
  wire rst_17_27;
  wire signed [(32 - 1):0] accum_reg_39_23_next;
  reg signed [(32 - 1):0] accum_reg_39_23 = 32'b00000000000000000000000000000000;
  localparam [(1 - 1):0] const_value = 1'b1;
  localparam [(1 - 1):0] const_value_x_000000 = 1'b1;
  wire signed [(33 - 1):0] cast_49_22;
  wire signed [(33 - 1):0] cast_49_42;
  wire signed [(33 - 1):0] accum_reg_49_9_addsub;
  reg signed [(33 - 1):0] accum_reg_join_45_1;
  wire signed [(32 - 1):0] cast_accum_reg_39_23_next;
  assign b_17_24 = b;
  assign rst_17_27 = rst;
  always @(posedge clk)
    begin:proc_accum_reg_39_23
      if ((ce == 1'b1))
        begin
          accum_reg_39_23 <= accum_reg_39_23_next;
        end
    end
  assign cast_49_22 = {{1{accum_reg_39_23[31]}}, accum_reg_39_23[31:0]};
  assign cast_49_42 = {{12{b_17_24[20]}}, b_17_24[20:0]};
  assign accum_reg_49_9_addsub = cast_49_22 + cast_49_42;
  always @(accum_reg_49_9_addsub or b_17_24 or rst_17_27)
    begin:proc_if_45_1
      if (rst_17_27)
        begin
          accum_reg_join_45_1 = {{12{b_17_24[20]}}, b_17_24[20:0]};
        end
      else 
        begin
          accum_reg_join_45_1 = accum_reg_49_9_addsub;
        end
    end
  assign cast_accum_reg_39_23_next = {accum_reg_join_45_1[31:0]};
  assign accum_reg_39_23_next = cast_accum_reg_39_23_next;
  assign q = accum_reg_39_23;
endmodule
`timescale 1 ns / 10 ps
module sysgen_logical_8f99cd5115 (
  input [(1 - 1):0] d0,
  input [(1 - 1):0] d1,
  output [(1 - 1):0] y,
  input clk,
  input ce,
  input clr);
  wire d0_1_24;
  wire d1_1_27;
  localparam [(1 - 1):0] const_value = 1'b0;
  reg [(1 - 1):0] latency_pipe_5_26[0:(1 - 1)];
  initial
    begin
      latency_pipe_5_26[0] = 1'b0;
    end
  wire [(1 - 1):0] latency_pipe_5_26_front_din;
  wire [(1 - 1):0] latency_pipe_5_26_back;
  wire latency_pipe_5_26_push_front_pop_back_en;
  wire fully_2_1_bit;
  wire [(1 - 1):0] unregy_3_1_convert;
  assign d0_1_24 = d0;
  assign d1_1_27 = d1;
  assign latency_pipe_5_26_back = latency_pipe_5_26[0];
  always @(posedge clk)
    begin:proc_latency_pipe_5_26
      integer i;
      if (((ce == 1'b1) && (latency_pipe_5_26_push_front_pop_back_en == 1'b1)))
        begin
          latency_pipe_5_26[0] <= latency_pipe_5_26_front_din;
        end
    end
  assign fully_2_1_bit = d0_1_24 & d1_1_27;
  assign unregy_3_1_convert = {fully_2_1_bit};
  assign latency_pipe_5_26_front_din = unregy_3_1_convert;
  assign latency_pipe_5_26_push_front_pop_back_en = 1'b1;
  assign y = latency_pipe_5_26_back;
endmodule
`timescale 1 ns / 10 ps
module sysgen_relational_e080d4f0e4 (
  input [(16 - 1):0] a,
  input [(16 - 1):0] b,
  output [(1 - 1):0] op,
  input clk,
  input ce,
  input clr);
  wire signed [(16 - 1):0] a_1_31;
  wire signed [(16 - 1):0] b_1_34;
  localparam [(1 - 1):0] const_value = 1'b1;
  wire result_18_3_rel;
  assign a_1_31 = a;
  assign b_1_34 = b;
  assign result_18_3_rel = a_1_31 > b_1_34;
  assign op = result_18_3_rel;
endmodule
module simple_dsp_module_xladdsub (a, b, c_in, ce, clr, clk, rst, en, c_out, s);
 
 parameter core_name0= "";
 parameter a_width= 16;
 parameter signed a_bin_pt= 4;
 parameter a_arith= `xlUnsigned;
 parameter c_in_width= 16;
 parameter c_in_bin_pt= 4;
 parameter c_in_arith= `xlUnsigned;
 parameter c_out_width= 16;
 parameter c_out_bin_pt= 4;
 parameter c_out_arith= `xlUnsigned;
 parameter b_width= 8;
 parameter signed b_bin_pt= 2;
 parameter b_arith= `xlUnsigned;
 parameter s_width= 17;
 parameter s_bin_pt= 4;
 parameter s_arith= `xlUnsigned;
 parameter rst_width= 1;
 parameter rst_bin_pt= 0;
 parameter rst_arith= `xlUnsigned;
 parameter en_width= 1;
 parameter en_bin_pt= 0;
 parameter en_arith= `xlUnsigned;
 parameter full_s_width= 17;
 parameter full_s_arith= `xlUnsigned;
 parameter mode= `xlAddMode;
 parameter extra_registers= 0;
 parameter latency= 0;
 parameter quantization= `xlTruncate;
 parameter overflow= `xlWrap;
 parameter c_a_width= 16;
 parameter c_b_width= 8;
 parameter c_a_type= 1;
 parameter c_b_type= 1;
 parameter c_has_sclr= 0;
 parameter c_has_ce= 0;
 parameter c_latency= 0;
 parameter c_output_width= 17;
 parameter c_enable_rlocs= 1;
 parameter c_has_c_in= 0;
 parameter c_has_c_out= 0;
 
 input [a_width-1:0] a;
 input [b_width-1:0] b;
 input c_in, ce, clr, clk, rst, en;
 output c_out;
 output [s_width-1:0] s;
 
 parameter full_a_width = full_s_width;
 parameter full_b_width = full_s_width;
 parameter full_s_bin_pt = (a_bin_pt > b_bin_pt) ? a_bin_pt : b_bin_pt;
 
 wire [full_a_width-1:0] full_a;
 wire [full_b_width-1:0] full_b;
 wire [full_s_width-1:0] full_s;
 wire [full_s_width-1:0] core_s;
 wire [s_width-1:0] conv_s;
 wire  temp_cout;
 wire  real_a,real_b,real_s;
 wire  internal_clr;
 wire  internal_ce;
 wire  extra_reg_ce;
 wire  override;
 wire  logic1;
 wire  temp_cin;
 
 assign internal_clr = (clr | rst) & ce;
 assign internal_ce = ce & en;
 assign logic1 = 1'b1;
 assign temp_cin = (c_has_c_in) ? c_in : 1'b0;
 
 align_input # (a_width, b_bin_pt - a_bin_pt, a_arith, full_a_width)
 align_inp_a(.inp(a),.res(full_a));
 align_input # (b_width, a_bin_pt - b_bin_pt, b_arith, full_b_width)
 align_inp_b(.inp(b),.res(full_b));
 convert_type # (full_s_width, full_s_bin_pt, full_s_arith, s_width,
                 s_bin_pt, s_arith, quantization, overflow)
 conv_typ_s(.inp(core_s),.res(conv_s));
 
 generate


if (core_name0 == "simple_dsp_module_c_addsub_v12_0_i0") 
     begin:comp0
simple_dsp_module_c_addsub_v12_0_i0 core_instance0 ( 
         .A(full_a),
         .S(core_s),
         .B(full_b) 
       ); 
     end 

if (core_name0 == "simple_dsp_module_c_addsub_v12_0_i1") 
     begin:comp1
simple_dsp_module_c_addsub_v12_0_i1 core_instance1 ( 
         .A(full_a),
         .S(core_s),
         .B(full_b) 
       ); 
     end 

if (core_name0 == "simple_dsp_module_c_addsub_v12_0_i2") 
     begin:comp2
simple_dsp_module_c_addsub_v12_0_i2 core_instance2 ( 
         .A(full_a),
         .S(core_s),
         .B(full_b) 
       ); 
     end 

if (core_name0 == "simple_dsp_module_c_addsub_v12_0_i3") 
     begin:comp3
simple_dsp_module_c_addsub_v12_0_i3 core_instance3 ( 
         .A(full_a),
         .CLK(clk),
         .CE(internal_ce),
         .S(core_s),
         .B(full_b) 
       ); 
     end 

if (core_name0 == "simple_dsp_module_c_addsub_v12_0_i4") 
     begin:comp4
simple_dsp_module_c_addsub_v12_0_i4 core_instance4 ( 
         .A(full_a),
         .S(core_s),
         .B(full_b) 
       ); 
     end 

if (core_name0 == "simple_dsp_module_c_addsub_v12_0_i5") 
     begin:comp5
simple_dsp_module_c_addsub_v12_0_i5 core_instance5 ( 
         .A(full_a),
         .S(core_s),
         .B(full_b) 
       ); 
     end 

if (core_name0 == "simple_dsp_module_c_addsub_v12_0_i6") 
     begin:comp6
simple_dsp_module_c_addsub_v12_0_i6 core_instance6 ( 
         .A(full_a),
         .S(core_s),
         .B(full_b) 
       ); 
     end 

if (core_name0 == "simple_dsp_module_c_addsub_v12_0_i7") 
     begin:comp7
simple_dsp_module_c_addsub_v12_0_i7 core_instance7 ( 
         .A(full_a),
         .S(core_s),
         .B(full_b) 
       ); 
     end 

if (core_name0 == "simple_dsp_module_c_addsub_v12_0_i8") 
     begin:comp8
simple_dsp_module_c_addsub_v12_0_i8 core_instance8 ( 
         .A(full_a),
         .CLK(clk),
         .CE(internal_ce),
         .S(core_s),
         .B(full_b) 
       ); 
     end 

endgenerate 
 
 
 generate
   if (extra_registers > 0)
   begin:latency_test
     
     if (c_latency > 1)
     begin:override_test
       synth_reg # (1, c_latency)
         override_pipe (
           .i(logic1),
           .ce(internal_ce),
           .clr(internal_clr),
           .clk(clk),
           .o(override));
       assign extra_reg_ce = ce & en & override;
     end // override_test
 
     if ((c_latency == 0) || (c_latency == 1))
     begin:no_override
       assign extra_reg_ce = ce & en;
     end // no_override
 
     synth_reg # (s_width, extra_registers)
       extra_reg (
         .i(conv_s),
         .ce(extra_reg_ce),
         .clr(internal_clr),
         .clk(clk),
         .o(s));
 
     if (c_has_c_out == 1)
     begin:cout_test
       synth_reg # (1, extra_registers)
         c_out_extra_reg (
           .i(temp_cout),
           .ce(extra_reg_ce),
           .clr(internal_clr),
           .clk(clk),
           .o(c_out));
     end // cout_test
     
   end // latency_test
 endgenerate
 
 generate
   if ((latency == 0) || (extra_registers == 0))
   begin:latency_s
     assign s = conv_s;
   end // latency_s
 endgenerate
 
 generate
   if (((latency == 0) || (extra_registers == 0)) &&
       (c_has_c_out == 1))
   begin:latency0
     assign c_out = temp_cout;
   end // latency0
 endgenerate
 
 generate
   if (c_has_c_out == 0)
   begin:tie_dangling_cout
     assign c_out = 0;
   end // tie_dangling_cout
 endgenerate
 
 endmodule

module simple_dsp_module_xlmult (a, b, ce, clr, clk, core_ce, core_clr,core_clk, rst, en,p);
     parameter core_name0 = "";
     parameter a_width = 4;
     parameter a_bin_pt = 2;
     parameter a_arith = `xlSigned;
     parameter b_width = 4;
     parameter b_bin_pt = 1;
     parameter b_arith = `xlSigned;
     parameter p_width = 8;
     parameter p_bin_pt = 2;
     parameter p_arith = `xlSigned;
     parameter rst_width = 1;
     parameter rst_bin_pt = 0;
     parameter rst_arith = `xlUnsigned;
     parameter en_width = 1;
     parameter en_bin_pt = 0;
     parameter en_arith = `xlUnsigned;
     parameter quantization = `xlTruncate;
     parameter overflow = `xlWrap;
     parameter extra_registers = 0;
     parameter c_a_width = 7;
     parameter c_b_width = 7;
     parameter c_type = 0;
     parameter c_a_type = 0;
     parameter c_b_type = 0;
     parameter c_baat = 4;
     parameter oversample = 1;
     parameter multsign = `xlSigned;
     parameter c_output_width = 16;
     input [a_width - 1 : 0] a;
     input [b_width - 1 : 0] b;
     input ce, clr, clk;
     input core_ce, core_clr, core_clk;
     input en, rst;
     output [p_width - 1 : 0] p;
     wire [c_a_width - 1 : 0]    tmp_a, conv_a;
     wire [c_b_width - 1 : 0]    tmp_b, conv_b;
    wire [c_output_width - 1 : 0] tmp_p;
    wire [p_width - 1 : 0] conv_p;
    wire internal_ce, internal_clr, internal_core_ce;
    wire rfd, rdy, nd;
    
 
    assign internal_ce = ce & en;
    assign internal_core_ce = core_ce & en;
    assign internal_clr = (clr | rst) & en;
    assign nd = ce & en;
 
    zero_ext # (a_width, c_a_width) zero_ext_a (.inp(a), .res(tmp_a));
    zero_ext # (b_width, c_b_width) zero_ext_b (.inp(b), .res(tmp_b));
 
    //Output Process
    convert_type # (c_output_width, a_bin_pt+b_bin_pt, multsign,
 		   p_width, p_bin_pt, p_arith, quantization, overflow)
      conv_udp (.inp(tmp_p), .res(conv_p));
    
 generate
 


if (core_name0 == "simple_dsp_module_mult_gen_v12_0_i0") 
     begin:comp0
simple_dsp_module_mult_gen_v12_0_i0 core_instance0 ( 
        .A(tmp_a),
        .B(tmp_b),
        .CLK(clk),
        .CE(internal_ce),
        .SCLR(internal_clr),
        .P(tmp_p) 
       ); 
     end 

if (core_name0 == "simple_dsp_module_mult_gen_v12_0_i1") 
     begin:comp1
simple_dsp_module_mult_gen_v12_0_i1 core_instance1 ( 
        .A(tmp_a),
        .B(tmp_b),
        .CLK(clk),
        .CE(internal_ce),
        .SCLR(internal_clr),
        .P(tmp_p) 
       ); 
     end 

if (core_name0 == "simple_dsp_module_mult_gen_v12_0_i2") 
     begin:comp2
simple_dsp_module_mult_gen_v12_0_i2 core_instance2 ( 
        .A(tmp_a),
        .B(tmp_b),
        .CLK(clk),
        .CE(internal_ce),
        .SCLR(internal_clr),
        .P(tmp_p) 
       ); 
     end 

if (extra_registers > 0)
 begin:latency_gt_0
 synth_reg # (p_width, extra_registers) 
 reg1 (
 .i(conv_p), 
 .ce(internal_ce),
 .clr(internal_clr),
 .clk(clk),
 .o(p));
 end
 
 if (extra_registers == 0)
 begin:latency_eq_0
 assign p = conv_p;
 end
 endgenerate
 
 endmodule

