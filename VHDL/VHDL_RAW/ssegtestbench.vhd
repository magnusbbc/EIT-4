library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity testbench is
end testbench;

architecture test of testbench is

constant t : time := 100 ns;

signal clr                       :  STD_LOGIC; --Clear
signal bcd_enable                :  std_LOGIC; --Enable BCD format
signal input_data                :  STD_LOGIC_vector (15 DOWNTO 0) := (OTHERS => '0'); --Hex data in 4 nibbles
signal dot_control               :  STD_LOGIC_vector (4 DOWNTO 0); --Dots data
signal seven_seg_control_signals :  STD_LOGIC_vector (39 DOWNTO 0); --Segments connections (31| dot4 - 7seg4 - dot3 - 7seg3 - dot2 - 7seg2 - dot1 - 7seg1 |0)




begin

	dut : entity work.ssgddriver
	
	port map(
		clr => clr,                     
		bcd_enable => bcd_enable,               
		input_data => input_data,               
		dot_control => dot_control,              
		seven_seg_control_signals => seven_seg_control_signals
		);

	simulation : process
	begin
		
	end process;
		
end architecture test;
