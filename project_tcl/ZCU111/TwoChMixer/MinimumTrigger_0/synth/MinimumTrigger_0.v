// (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: www.awa.tohoku.ac.jp:jj1and:MinimumTrigger:1.3
// IP Revision: 4

(* X_CORE_INFO = "MinimumTrigger,Vivado 2019.1" *)
(* CHECK_LICENSE_TYPE = "MinimumTrigger_0,MinimumTrigger,{}" *)
(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module MinimumTrigger_0 (
  S_AXIS_ACLK,
  S_AXIS_ARESETN,
  S_AXIS_TDATA,
  S_AXIS_TVALID,
  S_AXIS_TREADY,
  RD_CLK,
  RD_RESET,
  PRE_ACQUIASION_LEN,
  THRESHOLD_VAL,
  BASELINE,
  CURRENT_TIME,
  iREADY,
  DOUT,
  oVALID
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_ACLK, ASSOCIATED_BUSIF S_AXIS, ASSOCIATED_RESET S_AXIS_ARESETN, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S_AXIS_ACLK CLK" *)
input wire S_AXIS_ACLK;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S_AXIS_ARESETN RST" *)
input wire S_AXIS_ARESETN;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TDATA" *)
input wire [127 : 0] S_AXIS_TDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TVALID" *)
input wire S_AXIS_TVALID;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS, TDATA_NUM_BYTES 16, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TREADY" *)
output wire S_AXIS_TREADY;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RD_CLK, ASSOCIATED_RESET RD_RESET:RD_RESET, ASSOCIATED_BUSIF M_EASYHS, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 RD_CLK CLK" *)
input wire RD_CLK;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RD_RESET, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RD_RESET RST" *)
input wire RD_RESET;
input wire [4 : 0] PRE_ACQUIASION_LEN;
input wire [12 : 0] THRESHOLD_VAL;
input wire [11 : 0] BASELINE;
input wire [47 : 0] CURRENT_TIME;
(* X_INTERFACE_INFO = "www.awa.tohoku.ac.jp:jj1and:easyhs:1.1 M_EASYHS READY" *)
input wire iREADY;
(* X_INTERFACE_INFO = "www.awa.tohoku.ac.jp:jj1and:easyhs:1.1 M_EASYHS DATA" *)
output wire [63 : 0] DOUT;
(* X_INTERFACE_INFO = "www.awa.tohoku.ac.jp:jj1and:easyhs:1.1 M_EASYHS VALID" *)
output wire oVALID;

  MinimumTrigger #(
    .HIT_DETECTION_WINDOW_WORD(8),
    .CHANNEL_ID(0),
    .ADC_RESOLUTION_WIDTH(12),
    .MAX_FRAME_LENGTH(100),
    .MAX_DELAY_CNT_WIDTH(5),
    .POST_ACQUI_LEN(38),
    .TIME_STAMP_WIDTH(48),
    .FIRST_TIME_STAMP_WIDTH(32),
    .TDATA_WIDTH(128),
    .DOUT_WIDTH(64)
  ) inst (
    .S_AXIS_ACLK(S_AXIS_ACLK),
    .S_AXIS_ARESETN(S_AXIS_ARESETN),
    .S_AXIS_TDATA(S_AXIS_TDATA),
    .S_AXIS_TVALID(S_AXIS_TVALID),
    .S_AXIS_TREADY(S_AXIS_TREADY),
    .RD_CLK(RD_CLK),
    .RD_RESET(RD_RESET),
    .PRE_ACQUIASION_LEN(PRE_ACQUIASION_LEN),
    .THRESHOLD_VAL(THRESHOLD_VAL),
    .BASELINE(BASELINE),
    .CURRENT_TIME(CURRENT_TIME),
    .iREADY(iREADY),
    .DOUT(DOUT),
    .oVALID(oVALID)
  );
endmodule
