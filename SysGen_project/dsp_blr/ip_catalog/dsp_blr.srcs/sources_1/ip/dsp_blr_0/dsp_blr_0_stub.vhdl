-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Tue Dec 15 13:35:15 2020
-- Host        : LAPTOP-4N9JS6FC running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/1905p/git_repos/KRD/SysGen_project/dsp_blr/ip_catalog/dsp_blr.srcs/sources_1/ip/dsp_blr_0/dsp_blr_0_stub.vhdl
-- Design      : dsp_blr_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu29dr-ffvf1760-1-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dsp_blr_0 is
  Port ( 
    h_s_axis_tdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    h_s_axis_tvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    l_s_axis_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    l_s_axis_tvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    clk : in STD_LOGIC;
    dsp_m_axis_tdata : out STD_LOGIC_VECTOR ( 159 downto 0 );
    dsp_m_axis_tvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    h_m_axis_tdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    h_m_axis_tvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    l_m_axis_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    l_m_axis_tvalid : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

end dsp_blr_0;

architecture stub of dsp_blr_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "h_s_axis_tdata[127:0],h_s_axis_tvalid[0:0],l_s_axis_tdata[31:0],l_s_axis_tvalid[0:0],clk,dsp_m_axis_tdata[159:0],dsp_m_axis_tvalid[0:0],h_m_axis_tdata[127:0],h_m_axis_tvalid[0:0],l_m_axis_tdata[31:0],l_m_axis_tvalid[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "dsp_blr,Vivado 2019.1";
begin
end;
