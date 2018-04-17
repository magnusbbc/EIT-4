#include "Config.hvhd"
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Stack IS
	PORT (
		addressOut : OUT std_logic_vector(WORD_SIZE DOWNTO 0);
		addressIn : IN std_logic_vector(WORD_SIZE DOWNTO 0);
		writeBack : IN std_logic := '0';
		pop : IN std_logic := '0';
		push : IN std_logic := '0';
		clk : IN std_logic
	);
END Stack;


ARCHITECTURE Behavioral OF Stack IS
	SIGNAL SP : std_logic_vector(WORD_SIZE DOWNTO 0) := (OTHERS => '0');

Begin

	PROCESS (clk)
	Begin
		IF(rising_edge(clk)) THEN
			IF(pop = '1') THEN
				SP <= std_logic_vector(unsigned(SP) - 1);
			ELSIF(push = '1') THEN
				SP <= std_logic_vector(unsigned(SP) + 1);
			ELSIF(writeBack = '1') THEN
				SP <= addressIn;
			END IF;
		END IF;

	END PROCESS;

	WITH push SELECT addressOut <=
	std_logic_vector(unsigned(SP) + 1) WHEN '1',
	SP WHEN OTHERS;
END Behavioral;