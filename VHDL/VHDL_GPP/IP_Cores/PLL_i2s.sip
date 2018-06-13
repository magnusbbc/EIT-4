set_global_assignment -entity "PLL_i2s" -library "lib_PLL_i2s" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL_i2s" -library "lib_PLL_i2s" -name IP_TOOL_VERSION "18.0"
set_global_assignment -entity "PLL_i2s" -library "lib_PLL_i2s" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL_i2s" -name SPD_FILE [file join $::quartus(sip_path) "PLL_i2s.spd"]

set_global_assignment -library "lib_PLL_i2s" -name MISC_FILE [file join $::quartus(sip_path) "PLL_i2s_sim/PLL_i2s.vho"]
