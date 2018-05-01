--------------------------------------------------------------------------------------
--Engineer: Frederik Rasmussen
--Module Name: Button Peripheral
--
--Description:
--
--
--
--------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--Debouncer for 3 buttons
--Debounces the buttons 'btn' and debounced output 'debounced_btn_out' by checking 'btn' for 3 clock cycles
ENTITY btndriver IS
	PORT (
		clk : IN STD_LOGIC; --Clock used for debouncing
		clr : IN STD_LOGIC; --Clear
		btn : IN STD_LOGIC_vector (2 DOWNTO 0) := "000"; --Button inputs
		debounced_btn_out : OUT STD_LOGIC_vector (2 DOWNTO 0) := "000"; --Debounced button output
		interrupt_on : OUT std_logic := '0';
		interrupt_reset: IN std_logic := '0'
	);
END btndriver;

ARCHITECTURE Behavioral OF btndriver IS
	SIGNAL Q0, Q1, Q2 : std_logic_vector (2 DOWNTO 0) := "000"; -- Debounce registers
	SIGNAL dbtn_buffer : std_logic_vector(2 downto 0) := "000";
	SIGNAL int_toggle : std_logic := '0';
BEGIN
	PROCESS (clk)
	BEGIN
		IF (clk'EVENT AND clk = '1') THEN
			IF (clr = '1') THEN --Clear
				Q0 <= (OTHERS => '0');
				Q1 <= (OTHERS => '0');
				Q2 <= (OTHERS => '0');

			ELSE --Shift registers for each button
				Q0(2) <= btn(0);
				Q0(1 DOWNTO 0) <= Q0(2 DOWNTO 1);
				Q1(2) <= btn(1);
				Q1(1 DOWNTO 0) <= Q1(2 DOWNTO 1);
				Q2(2) <= btn(2);
				Q2(1 DOWNTO 0) <= Q2(2 DOWNTO 1);
			END IF;
		END IF;
	END PROCESS;
	--If all values in shift regisers are on the output will be on.
	dbtn_buffer(0) <= Q0(1) AND Q0(2) AND Q0(0);
	dbtn_buffer(1) <= Q1(1) AND Q1(2) AND Q1(0);
	dbtn_buffer(2) <= Q2(1) AND Q2(2) AND Q2(0);

	PROCESS(dbtn_buffer,int_toggle)
	BEGIN
		IF(dbtn_buffer = "000" OR dbtn_buffer = "ZZZ" OR dbtn_buffer = "UUU" OR int_toggle = '1') THEN
			interrupt_on <= '0';
		ELSE
			interrupt_on <= '1';
		END IF;	
	END PROCESS;

	PROCESS(interrupt_reset,dbtn_buffer)
	BEGIN
		IF(interrupt_reset = '1') THEN
			int_toggle <= '1';
		ELSIF(dbtn_buffer = "000") THEN
			int_toggle <= '0';
		END IF;
	END PROCESS;
	debounced_btn_out <= dbtn_buffer;
END Behavioral;