#include "Config.hvhd"
--------------------------------------------------------------------------------------
--Engineer: Jakob Thomsen, Mikkel Hardysoe, Magnus Christensen
--Module Name: Master
--
--Description:
--
--
--
--------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
--use IEEE.std_logic_arith.all;

ENTITY RegistryInternal IS
	PORT (
		readOne : IN std_logic_vector(4 DOWNTO 0);
		readTwo : IN std_logic_vector(4 DOWNTO 0);

		WriteOne : IN std_logic_vector(4 DOWNTO 0);

		dataInOne : IN std_logic_vector(WORD_SIZE DOWNTO 0);

		dataOutOne : OUT std_logic_vector(WORD_SIZE DOWNTO 0);
		dataOutTwo : OUT std_logic_vector(WORD_SIZE DOWNTO 0);

		pcIn : IN std_logic_vector(WORD_SIZE DOWNTO 0);
		
		spIN : IN std_logic_vector(WORD_SIZE DOWNTO 0);

		WR1_E : IN std_logic;

		clk : IN std_logic
	);

END RegistryInternal;

ARCHITECTURE Behavioral OF RegistryInternal IS

	TYPE register_type IS ARRAY (29 DOWNTO 0) OF std_logic_vector(WORD_SIZE DOWNTO 0);
	SIGNAL REG : register_type := (OTHERS => x"0000");
BEGIN

	RegProc : PROCESS (readOne, readTwo, writeOne, WR1_E, pcIn, REG) IS

	BEGIN
		IF conv_integer(readOne) = 31 THEN --pc to outOne
			dataOutOne <= pcIn;
		ELSIF conv_integer(readOne) = 30 THEN
			dataOutOne <= spIn;
		ELSE
			dataOutOne <= REG(conv_integer(readOne));
		END IF;

		IF conv_integer(readTwo) = 31 THEN --pc to outTwo
			dataOutTwo <= pcIn;
		ELSIF conv_integer(readTwo) = 30 THEN
			dataOutTwo <= spIn;
		ELSE
			dataOutTwo <= REG(conv_integer(readTwo));
		END IF;
	END PROCESS;

	WriteProc : PROCESS (clk) IS
	BEGIN
		IF (rising_edge(clk)) THEN
			IF (WR1_E = '1') THEN
				IF(to_integer(unsigned(writeOne)) <= 29) THEN
					REG(conv_integer(writeOne)) <= dataInOne;
				END IF;
			END IF;
		END IF;
	END PROCESS;

END Behavioral;