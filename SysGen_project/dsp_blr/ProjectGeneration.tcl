# Note: This file is produced automatically, and will be overwritten the next
# time you press "Generate" in System Generator. 
#


namespace eval ::xilinx::dsp::planaheaddriver {
	set AnalyzeTiming 1
	set AnalyzeTimingNumPaths {10000}
	set AnalyzeTimingPostImplementation 0
	set AnalyzeTimingPostSynthesis 1
	set Compilation {IP Catalog}
	set CompilationFlow {IP}
	set CreateInterfaceDocument {on}
	set DSPDevice {xczu29dr}
	set DSPFamily {zynquplus}
	set DSPPackage {ffvf1760}
	set DSPSpeed {-1-e}
	set FPGAClockPeriod 8
	set GenerateTestBench 1
	set HDLLanguage {verilog}
	set IPOOCCacheRootPath {C:/Users/1905p/AppData/Local/Xilinx/Sysgen/SysgenVivado/win64.o/ip}
	set IP_Auto_Infer {1}
	set IP_Categories_Text {System_Generator_for_DSP}
	set IP_Common_Repos {0}
	set IP_Description {}
	set IP_Dir {}
	set IP_Library_Text {SysGen}
	set IP_LifeCycle_Menu {2}
	set IP_Logo {sysgen_icon_100.png}
	set IP_Name {}
	set IP_Revision {238944814}
	set IP_Socket_IP {0}
	set IP_Socket_IP_Proj_Path {}
	set IP_Vendor_Text {User_Company}
	set IP_Version_Text {1.0}
	set ImplStrategyName {Vivado Implementation Defaults}
	set PostProjectCreationProc {dsp_package_for_vivado_ip_integrator}
	set Project {dsp_blr}
	set ProjectFiles {
		{{conv_pkg.v}}
		{{synth_reg.v}}
		{{synth_reg_w_init.v}}
		{{convert_type.v}}
		{{xlclockdriver_rd.v}}
		{{vivado_ip.tcl}}
		{{dsp_blr_entity_declarations.v}}
		{{dsp_blr.v}}
		{{dsp_blr_tb.v}}
		{{dsp_blr_clock.xdc}}
		{{dsp_blr.xdc}}
		{{dsp_blr.htm}}
	}
	set SimPeriod 8e-09
	set SimTime 0.0001
	set SimulationTime {100208.00000000 ns}
	set SynthStrategyName {Vivado Synthesis Defaults}
	set SynthesisTool {Vivado}
	set TargetDir {C:/Users/1905p/git_repos/KRD/SysGen_project/dsp_blr}
	set TestBenchModule {dsp_blr_tb}
	set TopLevelModule {dsp_blr}
	set TopLevelSimulinkHandle 2.00024
	set TopLevelPortInterface {}
	dict set TopLevelPortInterface l_s_axis_tvalid Name {l_s_axis_tvalid}
	dict set TopLevelPortInterface l_s_axis_tvalid Type Bool
	dict set TopLevelPortInterface l_s_axis_tvalid ArithmeticType xlUnsigned
	dict set TopLevelPortInterface l_s_axis_tvalid BinaryPoint 0
	dict set TopLevelPortInterface l_s_axis_tvalid Width 1
	dict set TopLevelPortInterface l_s_axis_tvalid DatFile {dsp_blr_l_s_axis_tvalid.dat}
	dict set TopLevelPortInterface l_s_axis_tvalid IconText {L_S_AXIS_TVALID}
	dict set TopLevelPortInterface l_s_axis_tvalid Direction in
	dict set TopLevelPortInterface l_s_axis_tvalid Period 1
	dict set TopLevelPortInterface l_s_axis_tvalid Interface 0
	dict set TopLevelPortInterface l_s_axis_tvalid InterfaceName {}
	dict set TopLevelPortInterface l_s_axis_tvalid InterfaceString {DATA}
	dict set TopLevelPortInterface l_s_axis_tvalid ClockDomain {dsp_blr}
	dict set TopLevelPortInterface l_s_axis_tvalid Locs {}
	dict set TopLevelPortInterface l_s_axis_tvalid IOStandard {}
	dict set TopLevelPortInterface l_s_axis_tdata Name {l_s_axis_tdata}
	dict set TopLevelPortInterface l_s_axis_tdata Type UFix_32_0
	dict set TopLevelPortInterface l_s_axis_tdata ArithmeticType xlUnsigned
	dict set TopLevelPortInterface l_s_axis_tdata BinaryPoint 0
	dict set TopLevelPortInterface l_s_axis_tdata Width 32
	dict set TopLevelPortInterface l_s_axis_tdata DatFile {dsp_blr_l_s_axis_tdata.dat}
	dict set TopLevelPortInterface l_s_axis_tdata IconText {L_S_AXIS_TDATA}
	dict set TopLevelPortInterface l_s_axis_tdata Direction in
	dict set TopLevelPortInterface l_s_axis_tdata Period 1
	dict set TopLevelPortInterface l_s_axis_tdata Interface 0
	dict set TopLevelPortInterface l_s_axis_tdata InterfaceName {}
	dict set TopLevelPortInterface l_s_axis_tdata InterfaceString {DATA}
	dict set TopLevelPortInterface l_s_axis_tdata ClockDomain {dsp_blr}
	dict set TopLevelPortInterface l_s_axis_tdata Locs {}
	dict set TopLevelPortInterface l_s_axis_tdata IOStandard {}
	dict set TopLevelPortInterface h_s_axis_tvalid Name {h_s_axis_tvalid}
	dict set TopLevelPortInterface h_s_axis_tvalid Type Bool
	dict set TopLevelPortInterface h_s_axis_tvalid ArithmeticType xlUnsigned
	dict set TopLevelPortInterface h_s_axis_tvalid BinaryPoint 0
	dict set TopLevelPortInterface h_s_axis_tvalid Width 1
	dict set TopLevelPortInterface h_s_axis_tvalid DatFile {dsp_blr_h_s_axis_tvalid.dat}
	dict set TopLevelPortInterface h_s_axis_tvalid IconText {H_S_AXIS_TVALID}
	dict set TopLevelPortInterface h_s_axis_tvalid Direction in
	dict set TopLevelPortInterface h_s_axis_tvalid Period 1
	dict set TopLevelPortInterface h_s_axis_tvalid Interface 0
	dict set TopLevelPortInterface h_s_axis_tvalid InterfaceName {}
	dict set TopLevelPortInterface h_s_axis_tvalid InterfaceString {DATA}
	dict set TopLevelPortInterface h_s_axis_tvalid ClockDomain {dsp_blr}
	dict set TopLevelPortInterface h_s_axis_tvalid Locs {}
	dict set TopLevelPortInterface h_s_axis_tvalid IOStandard {}
	dict set TopLevelPortInterface h_s_axis_tdata Name {h_s_axis_tdata}
	dict set TopLevelPortInterface h_s_axis_tdata Type UFix_128_0
	dict set TopLevelPortInterface h_s_axis_tdata ArithmeticType xlUnsigned
	dict set TopLevelPortInterface h_s_axis_tdata BinaryPoint 0
	dict set TopLevelPortInterface h_s_axis_tdata Width 128
	dict set TopLevelPortInterface h_s_axis_tdata DatFile {dsp_blr_h_s_axis_tdata.dat}
	dict set TopLevelPortInterface h_s_axis_tdata IconText {H_S_AXIS_TDATA}
	dict set TopLevelPortInterface h_s_axis_tdata Direction in
	dict set TopLevelPortInterface h_s_axis_tdata Period 1
	dict set TopLevelPortInterface h_s_axis_tdata Interface 0
	dict set TopLevelPortInterface h_s_axis_tdata InterfaceName {}
	dict set TopLevelPortInterface h_s_axis_tdata InterfaceString {DATA}
	dict set TopLevelPortInterface h_s_axis_tdata ClockDomain {dsp_blr}
	dict set TopLevelPortInterface h_s_axis_tdata Locs {}
	dict set TopLevelPortInterface h_s_axis_tdata IOStandard {}
	dict set TopLevelPortInterface dsp_m_axis_tdata Name {dsp_m_axis_tdata}
	dict set TopLevelPortInterface dsp_m_axis_tdata Type UFix_160_0
	dict set TopLevelPortInterface dsp_m_axis_tdata ArithmeticType xlUnsigned
	dict set TopLevelPortInterface dsp_m_axis_tdata BinaryPoint 0
	dict set TopLevelPortInterface dsp_m_axis_tdata Width 160
	dict set TopLevelPortInterface dsp_m_axis_tdata DatFile {dsp_blr_dsp_m_axis_tdata.dat}
	dict set TopLevelPortInterface dsp_m_axis_tdata IconText {DSP_M_AXIS_TDATA}
	dict set TopLevelPortInterface dsp_m_axis_tdata Direction out
	dict set TopLevelPortInterface dsp_m_axis_tdata Period 1
	dict set TopLevelPortInterface dsp_m_axis_tdata Interface 0
	dict set TopLevelPortInterface dsp_m_axis_tdata InterfaceName {}
	dict set TopLevelPortInterface dsp_m_axis_tdata InterfaceString {DATA}
	dict set TopLevelPortInterface dsp_m_axis_tdata ClockDomain {dsp_blr}
	dict set TopLevelPortInterface dsp_m_axis_tdata Locs {}
	dict set TopLevelPortInterface dsp_m_axis_tdata IOStandard {}
	dict set TopLevelPortInterface dsp_m_axis_tvalid Name {dsp_m_axis_tvalid}
	dict set TopLevelPortInterface dsp_m_axis_tvalid Type Bool
	dict set TopLevelPortInterface dsp_m_axis_tvalid ArithmeticType xlUnsigned
	dict set TopLevelPortInterface dsp_m_axis_tvalid BinaryPoint 0
	dict set TopLevelPortInterface dsp_m_axis_tvalid Width 1
	dict set TopLevelPortInterface dsp_m_axis_tvalid DatFile {dsp_blr_dsp_m_axis_tvalid.dat}
	dict set TopLevelPortInterface dsp_m_axis_tvalid IconText {DSP_M_AXIS_TVALID}
	dict set TopLevelPortInterface dsp_m_axis_tvalid Direction out
	dict set TopLevelPortInterface dsp_m_axis_tvalid Period 1
	dict set TopLevelPortInterface dsp_m_axis_tvalid Interface 0
	dict set TopLevelPortInterface dsp_m_axis_tvalid InterfaceName {}
	dict set TopLevelPortInterface dsp_m_axis_tvalid InterfaceString {DATA}
	dict set TopLevelPortInterface dsp_m_axis_tvalid ClockDomain {dsp_blr}
	dict set TopLevelPortInterface dsp_m_axis_tvalid Locs {}
	dict set TopLevelPortInterface dsp_m_axis_tvalid IOStandard {}
	dict set TopLevelPortInterface h_m_axis_tdata Name {h_m_axis_tdata}
	dict set TopLevelPortInterface h_m_axis_tdata Type UFix_128_0
	dict set TopLevelPortInterface h_m_axis_tdata ArithmeticType xlUnsigned
	dict set TopLevelPortInterface h_m_axis_tdata BinaryPoint 0
	dict set TopLevelPortInterface h_m_axis_tdata Width 128
	dict set TopLevelPortInterface h_m_axis_tdata DatFile {dsp_blr_h_m_axis_tdata.dat}
	dict set TopLevelPortInterface h_m_axis_tdata IconText {H_M_AXIS_TDATA}
	dict set TopLevelPortInterface h_m_axis_tdata Direction out
	dict set TopLevelPortInterface h_m_axis_tdata Period 1
	dict set TopLevelPortInterface h_m_axis_tdata Interface 0
	dict set TopLevelPortInterface h_m_axis_tdata InterfaceName {}
	dict set TopLevelPortInterface h_m_axis_tdata InterfaceString {DATA}
	dict set TopLevelPortInterface h_m_axis_tdata ClockDomain {dsp_blr}
	dict set TopLevelPortInterface h_m_axis_tdata Locs {}
	dict set TopLevelPortInterface h_m_axis_tdata IOStandard {}
	dict set TopLevelPortInterface h_m_axis_tvalid Name {h_m_axis_tvalid}
	dict set TopLevelPortInterface h_m_axis_tvalid Type Bool
	dict set TopLevelPortInterface h_m_axis_tvalid ArithmeticType xlUnsigned
	dict set TopLevelPortInterface h_m_axis_tvalid BinaryPoint 0
	dict set TopLevelPortInterface h_m_axis_tvalid Width 1
	dict set TopLevelPortInterface h_m_axis_tvalid DatFile {dsp_blr_h_m_axis_tvalid.dat}
	dict set TopLevelPortInterface h_m_axis_tvalid IconText {H_M_AXIS_TVALID}
	dict set TopLevelPortInterface h_m_axis_tvalid Direction out
	dict set TopLevelPortInterface h_m_axis_tvalid Period 1
	dict set TopLevelPortInterface h_m_axis_tvalid Interface 0
	dict set TopLevelPortInterface h_m_axis_tvalid InterfaceName {}
	dict set TopLevelPortInterface h_m_axis_tvalid InterfaceString {DATA}
	dict set TopLevelPortInterface h_m_axis_tvalid ClockDomain {dsp_blr}
	dict set TopLevelPortInterface h_m_axis_tvalid Locs {}
	dict set TopLevelPortInterface h_m_axis_tvalid IOStandard {}
	dict set TopLevelPortInterface l_m_axis_tdata Name {l_m_axis_tdata}
	dict set TopLevelPortInterface l_m_axis_tdata Type UFix_32_0
	dict set TopLevelPortInterface l_m_axis_tdata ArithmeticType xlUnsigned
	dict set TopLevelPortInterface l_m_axis_tdata BinaryPoint 0
	dict set TopLevelPortInterface l_m_axis_tdata Width 32
	dict set TopLevelPortInterface l_m_axis_tdata DatFile {dsp_blr_l_m_axis_tdata.dat}
	dict set TopLevelPortInterface l_m_axis_tdata IconText {L_M_AXIS_TDATA}
	dict set TopLevelPortInterface l_m_axis_tdata Direction out
	dict set TopLevelPortInterface l_m_axis_tdata Period 1
	dict set TopLevelPortInterface l_m_axis_tdata Interface 0
	dict set TopLevelPortInterface l_m_axis_tdata InterfaceName {}
	dict set TopLevelPortInterface l_m_axis_tdata InterfaceString {DATA}
	dict set TopLevelPortInterface l_m_axis_tdata ClockDomain {dsp_blr}
	dict set TopLevelPortInterface l_m_axis_tdata Locs {}
	dict set TopLevelPortInterface l_m_axis_tdata IOStandard {}
	dict set TopLevelPortInterface l_m_axis_tvalid Name {l_m_axis_tvalid}
	dict set TopLevelPortInterface l_m_axis_tvalid Type Bool
	dict set TopLevelPortInterface l_m_axis_tvalid ArithmeticType xlUnsigned
	dict set TopLevelPortInterface l_m_axis_tvalid BinaryPoint 0
	dict set TopLevelPortInterface l_m_axis_tvalid Width 1
	dict set TopLevelPortInterface l_m_axis_tvalid DatFile {dsp_blr_l_m_axis_tvalid.dat}
	dict set TopLevelPortInterface l_m_axis_tvalid IconText {L_M_AXIS_TVALID}
	dict set TopLevelPortInterface l_m_axis_tvalid Direction out
	dict set TopLevelPortInterface l_m_axis_tvalid Period 1
	dict set TopLevelPortInterface l_m_axis_tvalid Interface 0
	dict set TopLevelPortInterface l_m_axis_tvalid InterfaceName {}
	dict set TopLevelPortInterface l_m_axis_tvalid InterfaceString {DATA}
	dict set TopLevelPortInterface l_m_axis_tvalid ClockDomain {dsp_blr}
	dict set TopLevelPortInterface l_m_axis_tvalid Locs {}
	dict set TopLevelPortInterface l_m_axis_tvalid IOStandard {}
	dict set TopLevelPortInterface clk Name {clk}
	dict set TopLevelPortInterface clk Type -
	dict set TopLevelPortInterface clk ArithmeticType xlUnsigned
	dict set TopLevelPortInterface clk BinaryPoint 0
	dict set TopLevelPortInterface clk Width 1
	dict set TopLevelPortInterface clk DatFile {}
	dict set TopLevelPortInterface clk Direction in
	dict set TopLevelPortInterface clk Period 1
	dict set TopLevelPortInterface clk Interface 6
	dict set TopLevelPortInterface clk InterfaceName {}
	dict set TopLevelPortInterface clk InterfaceString {CLOCK}
	dict set TopLevelPortInterface clk ClockDomain {dsp_blr}
	dict set TopLevelPortInterface clk Locs {}
	dict set TopLevelPortInterface clk IOStandard {}
	dict set TopLevelPortInterface clk AssociatedInterfaces {}
	dict set TopLevelPortInterface clk AssociatedResets {}
	set MemoryMappedPort {}
}

source SgPaProject.tcl
::xilinx::dsp::planaheadworker::dsp_create_project