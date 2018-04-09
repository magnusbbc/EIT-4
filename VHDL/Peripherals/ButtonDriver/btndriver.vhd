LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--Debouncer for 3 buttons
--Debounces the buttons 'btn' and debounced output 'dbtn' by checking 'btn' for 3 clock cycles
ENTITY btndriver IS
	PORT
	(
		clk  : IN STD_LOGIC;								--Clock used for debouncing
		clr  : IN STD_LOGIC;								--Clear
		btn  : IN STD_LOGIC_vector (2 DOWNTO 0);	--Button inputs
		dbtn : OUT STD_LOGIC_vector (2 DOWNTO 0)	--Debounced button output
	);
END btndriver;

ARCHITECTURE Behavioral OF btndriver IS
	SIGNAL Q0, Q1, Q2 : std_logic_vector (2 DOWNTO 0); -- Debounce registers

BEGIN
	PROCESS (clk)
	BEGIN
	
		IF (clk'event AND clk = '1') THEN
			IF (clr = '1') THEN							--Clear 
				Q0 <= (OTHERS => '0');
				Q1 <= (OTHERS => '0');
				Q2 <= (OTHERS => '0');

			ELSE												--Shift registers for each button
				Q0(2)          <= btn(0);
				Q0(1 DOWNTO 0) <= Q0(2 DOWNTO 1);
				Q1(2)          <= btn(1);
				Q1(1 DOWNTO 0) <= Q1(2 DOWNTO 1);
				Q2(2)          <= btn(2);
				Q2(1 DOWNTO 0) <= Q2(2 DOWNTO 1);
			END IF;
		END IF;
	END PROCESS;
																--If all values in shift regisers are on the output will be on.
	dbtn(0) <= Q0(1) AND Q0(2) AND Q0(0);
	dbtn(1) <= Q1(1) AND Q1(2) AND Q1(0);
	dbtn(2) <= Q2(1) AND Q2(2) AND Q2(0);
END Behavioral;