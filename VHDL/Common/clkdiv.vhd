LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
--Clock divider
--This entity divides the incomming clock 'clk' by 2^N and output to the 'mclk'
ENTITY clkdiv IS
	GENERIC
		(N : INTEGER := 8);   	--Dividr 2^N
	PORT
	(
		clk  : IN STD_LOGIC;		--Incomming clock	
		clr  : IN STD_LOGIC;		--Clear
		mclk : OUT STD_LOGIC		--Outgoing divided clock (clk*2^N)
	);
END clkdiv;

ARCHITECTURE clkdiv OF clkdiv IS
	SIGNAL q : std_logic_vector (N - 1 DOWNTO 0); --counter used for dividing the clock, the MSB is used as outgoing clk
BEGIN
	--clock divider
	PROCESS (clk, clr)
	BEGIN
		IF clr = '1' THEN
			q <= (OTHERS => '0');  				--Clearing function
		ELSIF clk'event AND clk = '1' THEN
			q <= q + 1;								--Increment counter
		END IF;
	END PROCESS;
	mclk <= q(n - 1);								--MSB of the counter is set as the output clock
END clkdiv;