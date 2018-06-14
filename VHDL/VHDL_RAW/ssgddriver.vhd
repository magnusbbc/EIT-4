
--Macro mapping digits (0-F) to the Seven segment display on the Terasic DE0


--------------------------------------------------------------------------------------
--Engineer: Frederik Rasmussen
--Module Name: 7-Segment Display Peripheral
--
--Description:
--
--
--
--------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;

--Seven segment display driver
--This driver is for a 4 panel sevensegment display with all segments directly connected

ENTITY ssgddriver IS
	PORT
	(
		clr                       : IN STD_LOGIC; --Clear
		bcd_enable                : IN std_LOGIC; --Enable BCD format
		input_data                : IN STD_LOGIC_vector (15 DOWNTO 0) := (OTHERS => '0'); --Hex data in 4 nibbles
		dot_control               : IN STD_LOGIC_vector (3 DOWNTO 0) := (OTHERS => '0'); --Dots data
		seven_seg_control_signals : OUT STD_LOGIC_vector (31 DOWNTO 0) --Segments connections (31| dot4 - 7seg4 - dot3 - 7seg3 - dot2 - 7seg2 - dot1 - 7seg1 |0)
	);
END ssgddriver;

ARCHITECTURE Behavioral OF ssgddriver IS

	COMPONENT b2bcd IS --When input is changed the output is set to the BCD format using the 'shift and add 3' algorithm
		PORT
		(
			clr    : IN std_logic; --Clear
			binary : IN std_logic_vector (15 DOWNTO 0); --Binary data in
			bcd    : OUT std_logic_vector (15 DOWNTO 0) --BCD formatet output
		);
	END COMPONENT;

	SIGNAL bcd     : std_logic_vector (15 DOWNTO 0);
	SIGNAL display : std_logic_vector (15 DOWNTO 0);

BEGIN
	con : COMPONENT b2bcd
		PORT MAP
		(
			clr    => clr,
			binary => input_data,
			bcd    => bcd
		);

		display <=
			bcd WHEN bcd_enable = '1' ELSE
			input_data;

		--Sets the first display
		seven_seg_control_signals(7)                                          <= dot_control(0);
		WITH display(3 DOWNTO 0) SELECT seven_seg_control_signals(6 DOWNTO 0) <=
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
"0001110" WHEN "1111", 
"0000000" WHEN OTHERS;

		--Sets the second display
		seven_seg_control_signals(15)                                          <= dot_control(1);
		WITH display(7 DOWNTO 4) SELECT seven_seg_control_signals(14 DOWNTO 8) <=
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
"0001110" WHEN "1111", 
"0000000" WHEN OTHERS;

		--Sets the third display
		seven_seg_control_signals(23)                                            <= dot_control(2);
		WITH display(11 DOWNTO 8) SELECT seven_seg_control_signals(22 DOWNTO 16) <=
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
"0001110" WHEN "1111", 
"0000000" WHEN OTHERS;

		--Sets the fourth display
		seven_seg_control_signals(31)                                             <= dot_control(3);
		WITH display(15 DOWNTO 12) SELECT seven_seg_control_signals(30 DOWNTO 24) <=
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
"0001110" WHEN "1111", 
"0000000" WHEN OTHERS;

	END Behavioral;