set_global_assignment -entity "PLL_VGA" -library "lib_PLL_VGA" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL_VGA" -library "lib_PLL_VGA" -name IP_TOOL_VERSION "18.0"
set_global_assignment -entity "PLL_VGA" -library "lib_PLL_VGA" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL_VGA" -name SPD_FILE [file join $::quartus(sip_path) "PLL_VGA.spd"]

set_global_assignment -library "lib_PLL_VGA" -name MISC_FILE [file join $::quartus(sip_path) "PLL_VGA_sim/PLL_VGA.vho"]
