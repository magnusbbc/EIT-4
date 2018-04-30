#include "Config.hvhd"

--------------------------------------------------------------------------------------
--Engineer: Magnus Christensen
--Module Name: Stack Controller
--
--
--Description:
--Controls the Stack Pointer register's output, as well as a
--automatically incrementing/decrementing the stack pointer
--when executing push/pop instructions.
--
--The Stack Controller depends on the rising edge of the system clock
--------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Stack IS
	PORT (
		addressOut : OUT std_logic_vector(WORD_SIZE DOWNTO 0); --Stack Pointer output
		addressIn : IN std_logic_vector(WORD_SIZE DOWNTO 0); --New value of stack pointer (only applicable when "writeback" is set high)
		writeBack : IN std_logic := '0'; --Control port, set high when performing a manual stack point overwrite
		pop : IN std_logic := '0'; --Control port, set high when a "pop" instruction occours (should be connected to the "pop" control port)
		push : IN std_logic := '0'; --Control port, set high when a "push" instruction occours (should be connected to the "push" control port)
		clk : IN std_logic --CPU clock signal (should be connected to the System Clock)
	);
END Stack;


ARCHITECTURE Behavioral OF Stack IS
	SIGNAL SP : std_logic_vector(WORD_SIZE DOWNTO 0) := (OTHERS => '0');

Begin

	ChangeSP : PROCESS (clk) --Process changes the value of the stack pointer
	Begin
		IF(rising_edge(clk)) THEN
			IF(pop = '1') THEN
				SP <= std_logic_vector(unsigned(SP) - 1); 	--Decrement when pop
			ELSIF(push = '1') THEN
				SP <= std_logic_vector(unsigned(SP) + 1); 	--Increment when push
			ELSIF(writeBack = '1') THEN
				SP <= addressIn;							--Manual Overwrite
			END IF;
		END IF;

	END PROCESS;


	--If a "push" instruction is being executed, the stack controller outputs the "stack pointer + 1" 
	--to ensure that the pushed value is stored at the new location at the top of the stack.
	--The SP itself is changed on the next rising edge (see the ChangeSP : Process)
	
	--If a pop instruction is being executed, the stack controller outputs the current value of the stack pointer
	--Since this corresponds to the value of the current top. The SP is changed on the next rising edge (see the ChangeSP : Process)
	--To correspond to the new address of the top of the stack.
	WITH push SELECT addressOut <=
	std_logic_vector(unsigned(SP) + 1) WHEN '1',
	SP WHEN OTHERS;
END Behavioral;