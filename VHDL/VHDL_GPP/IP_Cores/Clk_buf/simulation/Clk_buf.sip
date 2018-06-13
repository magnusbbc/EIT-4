set_global_assignment -entity "Clk_buf" -library "lib_Clk_buf" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "Clk_buf" -library "lib_Clk_buf" -name IP_TOOL_VERSION "18.0"
set_global_assignment -entity "Clk_buf" -library "lib_Clk_buf" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_Clk_buf" -name SPD_FILE [file join $::quartus(sip_path) "../Clk_buf.spd"]
set_global_assignment -library "lib_Clk_buf" -name MISC_FILE [file join $::quartus(sip_path) "../../Clk_buf.qsys"]

set_global_assignment -library "lib_Clk_buf" -name MISC_FILE [file join $::quartus(sip_path) "Clk_buf.vhd"]
set_global_assignment -library "lib_Clk_buf" -name MISC_FILE [file join $::quartus(sip_path) "submodules/Clk_buf_altclkctrl_0.vhd"]
