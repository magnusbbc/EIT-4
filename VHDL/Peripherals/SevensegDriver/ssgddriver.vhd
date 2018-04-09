LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;

--Seven segment display driver
--This driver is for a 4 panel sevensegment display with all segments directly connected

ENTITY ssgddriver IS
	PORT 
	(
		clr       : IN STD_LOGIC;									--Clear
		bcdenable : IN std_LOGIC;                          --Enable BCD format
		dat       : IN STD_LOGIC_vector (15 DOWNTO 0) := (others => '0');     --Hex data in 4 nibbles
		dots      : IN STD_LOGIC_vector (3 DOWNTO 0);      --Dots data
		sseg      : OUT STD_LOGIC_vector (31 DOWNTO 0)     --Segments connections (31| dot4 - 7seg4 - dot3 - 7seg3 - dot2 - 7seg2 - dot1 - 7seg1 |0)
	);
END ssgddriver;

ARCHITECTURE Behavioral OF ssgddriver IS

	COMPONENT b2bcd IS												--When input is changed the output is set to the BCD format using the 'shift and add 3' algorithm
		PORT 
		(
			clr    : IN std_logic;									--Clear
			binary : IN std_logic_vector (15 DOWNTO 0);		--Binary data in
			bcd    : OUT std_logic_vector (15 DOWNTO 0)		--BCD formatet output
		);
	END COMPONENT;

	SIGNAL bcd     : std_logic_vector (15 DOWNTO 0);
	SIGNAL display : std_logic_vector (15 DOWNTO 0);

BEGIN
	con : COMPONENT b2bcd
	PORT MAP
	(
		clr    => clr, 
		binary => dat, 
		bcd    => bcd
	);
 
	display <= 
		bcd WHEN bcdenable = '1' ELSE
		dat;
 
		--first display
		sseg(7) <= dots(0);
		WITH display(3 DOWNTO 0) SELECT sseg(6 DOWNTO 0) <=
		"1000000" WHEN "0000",
		"1111001" WHEN "0001",
		"0100100" WHEN "0010",
		"0110000" WHEN "0011", 
		"0011001" WHEN "0100", 
		"0010010" WHEN "0101", 
		"0000010" WHEN "0110", 
		"1111000" WHEN "0111", 
		"0000000" WHEN "1000", 
		"0010000" WHEN "1001", 
		"0001000" WHEN "1010", 
		"0000011" WHEN "1011", 
		"1000110" WHEN "1100", 
		"0100001" WHEN "1101", 
		"0000110" WHEN "1110", 
		"0001110" WHEN "1111";
		
		sseg(15) <= dots(1);
		WITH display(7 DOWNTO 4) SELECT sseg(14 DOWNTO 8) <=
		"1000000" WHEN "0000",
		"1111001" WHEN "0001",
		"0100100" WHEN "0010",
		"0110000" WHEN "0011", 
		"0011001" WHEN "0100", 
		"0010010" WHEN "0101", 
		"0000010" WHEN "0110", 
		"1111000" WHEN "0111", 
		"0000000" WHEN "1000", 
		"0010000" WHEN "1001", 
		"0001000" WHEN "1010", 
		"0000011" WHEN "1011", 
		"1000110" WHEN "1100", 
		"0100001" WHEN "1101", 
		"0000110" WHEN "1110", 
		"0001110" WHEN "1111";

		sseg(23) <= dots(2);
		WITH display(11 DOWNTO 8) SELECT sseg(22 DOWNTO 16) <=
		"1000000" WHEN "0000",
		"1111001" WHEN "0001",
		"0100100" WHEN "0010",
		"0110000" WHEN "0011", 
		"0011001" WHEN "0100", 
		"0010010" WHEN "0101", 
		"0000010" WHEN "0110", 
		"1111000" WHEN "0111", 
		"0000000" WHEN "1000", 
		"0010000" WHEN "1001", 
		"0001000" WHEN "1010", 
		"0000011" WHEN "1011", 
		"1000110" WHEN "1100", 
		"0100001" WHEN "1101", 
		"0000110" WHEN "1110", 
		"0001110" WHEN "1111";
		
		sseg(31) <= dots(3);
		WITH display(15 DOWNTO 12) SELECT sseg(30 DOWNTO 24) <=
		"1000000" WHEN "0000",
		"1111001" WHEN "0001",
		"0100100" WHEN "0010",
		"0110000" WHEN "0011", 
		"0011001" WHEN "0100", 
		"0010010" WHEN "0101", 
		"0000010" WHEN "0110", 
		"1111000" WHEN "0111", 
		"0000000" WHEN "1000", 
		"0010000" WHEN "1001", 
		"0001000" WHEN "1010", 
		"0000011" WHEN "1011", 
		"1000110" WHEN "1100", 
		"0100001" WHEN "1101", 
		"0000110" WHEN "1110", 
		"0001110" WHEN "1111";

END Behavioral;