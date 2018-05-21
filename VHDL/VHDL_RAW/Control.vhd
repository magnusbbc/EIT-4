


























































































































--------------------------------------------------------------------------------------
--Engineer: Magnus Christensen
--Module Name: Control Unit
--
--Description:
--Accepts a 6 bit opcode and returns control signales used to control the functionality of the CPU
--Control Signal definitions can be found in Control.hvhd
--The Control unit does not depend on a clock signal
--
--The Control lines have the following uses:
--
--ALU_CONTROL 			18 DOWNTO 13
--JUMP_CONTROL 			12 DOWNTO 10
--MEMORY_READ 			9
--MEMORY_WRITE 			8
--REGISTER_WRITE 		7
--MEMORY_WRITE_BACK 	6
--IMMEDIATE_SELECT 		5
--33  					4
--32  					3
--SWITCH_READ_WRITE 	2
--MEMORY_TO_PC 			1
--38  					0
--
--------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY Control IS
	PORT (
		opcode : IN std_logic_vector(31 DOWNTO 26); --6 bit opcode (e.g 13 )
		control_signals : OUT std_logic_vector(24 -1 DOWNTO 0) --Control Output
	);
END ENTITY Control;

ARCHITECTURE Behavioral OF Control IS
BEGIN
	--One massive mux/look up table. Is used since the input is mutually exclusive
	WITH to_integer(unsigned(opcode)) SELECT control_signals <=

	--Register-Register ALU Control
	std_logic_vector(to_unsigned(2 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 1 ,
	std_logic_vector(to_unsigned(1 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 2 ,
	std_logic_vector(to_unsigned(3 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 3 ,
	std_logic_vector(to_unsigned(10 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 4 ,
	std_logic_vector(to_unsigned(5 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 5 ,
	std_logic_vector(to_unsigned(6 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 6 ,
	std_logic_vector(to_unsigned(7 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 7 ,
	std_logic_vector(to_unsigned(4 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 8 ,
	std_logic_vector(to_unsigned(12 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 9 ,
	std_logic_vector(to_unsigned(13 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 10 ,
	std_logic_vector(to_unsigned(14 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 11 ,

	--Register-Immediate ALU Control
	std_logic_vector(to_unsigned(2 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 13 ,
	std_logic_vector(to_unsigned(1 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 14 ,
	std_logic_vector(to_unsigned(3 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 15 ,
	std_logic_vector(to_unsigned(10 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 16 ,
	std_logic_vector(to_unsigned(5 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 17 ,
	std_logic_vector(to_unsigned(6 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 18 ,
	std_logic_vector(to_unsigned(7 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 19 ,
	std_logic_vector(to_unsigned(4 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 20 ,
	std_logic_vector(to_unsigned(12 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 21 ,
	std_logic_vector(to_unsigned(13 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 22 ,
	std_logic_vector(to_unsigned(14 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 23 ,

	--Nop
	std_logic_vector(to_unsigned(19 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 0 ,


	--Register Compare and Move
	std_logic_vector(to_unsigned(3 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 26 ,
	std_logic_vector(to_unsigned(15 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 27 ,

	--Immediate Compare and Move
	std_logic_vector(to_unsigned(3 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 28 ,
	std_logic_vector(to_unsigned(16 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 29 ,

	--Memory Control
	std_logic_vector(to_unsigned(2 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '1'  & '0' & '1'  & '1'  & '1'  & '0' & '0' & '0' & '1'  & '0' WHEN 30 ,
	std_logic_vector(to_unsigned(2 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '1'  & '0' & '0' & '1'  & '0' & '0' WHEN 31 ,

	--Stack Control
	std_logic_vector(to_unsigned(17 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '1'  & '1'  & '0' & '0' & '1'  & '0' & '0' & '0' & '0' WHEN 33 ,
	std_logic_vector(to_unsigned(0 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '1'  & '0' & '1'  & '1'  & '0' & '0' & '1'    & '0' & '1'  & '0' WHEN 32 ,

	--Branch Control
	std_logic_vector(to_unsigned(16 , 6)) & std_logic_vector(to_unsigned(1 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 34 ,
	std_logic_vector(to_unsigned(16 , 6)) & std_logic_vector(to_unsigned(2 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 35 ,
	std_logic_vector(to_unsigned(16 , 6)) & std_logic_vector(to_unsigned(3 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 36 ,
	std_logic_vector(to_unsigned(16 , 6)) & std_logic_vector(to_unsigned(4 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 37 ,
	std_logic_vector(to_unsigned(16 , 6)) & std_logic_vector(to_unsigned(5 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 48 ,

	--Branch Control (Jump to registers)
	std_logic_vector(to_unsigned(15 , 6)) & std_logic_vector(to_unsigned(1 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 44 ,
	std_logic_vector(to_unsigned(15 , 6)) & std_logic_vector(to_unsigned(2 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 47 ,
	std_logic_vector(to_unsigned(15 , 6)) & std_logic_vector(to_unsigned(3 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 46 ,
	std_logic_vector(to_unsigned(15 , 6)) & std_logic_vector(to_unsigned(4 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 45 ,
	std_logic_vector(to_unsigned(15 , 6)) & std_logic_vector(to_unsigned(5 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 49 ,

	--Stop Process
	std_logic_vector(to_unsigned(19 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1'  WHEN 38 ,
	
	--Filter instructions
	std_logic_vector(to_unsigned(15 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 39 ,
	std_logic_vector(to_unsigned(16 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 40 ,
	std_logic_vector(to_unsigned(19 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 41 ,
	std_logic_vector(to_unsigned(15 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '1'  & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 42 ,
	std_logic_vector(to_unsigned(16 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '0'  & '1'  & '0' & '0' & '0' & '0' & '1'  & '0' & '1'  & '0' & '0' & '0' & '0' & '0' WHEN 43 ,
	
	--Flag Operations
	std_logic_vector(to_unsigned(19 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '1'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 50 ,
	std_logic_vector(to_unsigned(19 , 6)) & std_logic_vector(to_unsigned(0 , 3)) & '1'  & '0'  & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' WHEN 51 ,
	(OTHERS => '0') WHEN OTHERS;
END ARCHITECTURE Behavioral;