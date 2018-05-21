






--------------------------------------------------------------------------------------
--Engineer: Frederik Rasmussen, Magnus Christensen
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
	PORT
	(
		clk               : IN STD_LOGIC; --Clock used for debouncing
		clr               : IN STD_LOGIC; --Clear
		btn               : IN STD_LOGIC_vector (3 DOWNTO 0)  := (OTHERS => '0'); --Button inputs
		debounced_btn_out : OUT STD_LOGIC_vector (2 DOWNTO 0) := (OTHERS => '0'); --Debounced button output
		interrupt_on      : OUT std_logic                     := '0';   --Send interrut signal out 
		interrupt_reset   : IN std_logic                      := '0'    --Resets interrupt signal when set high
	);
END btndriver;

ARCHITECTURE Behavioral OF btndriver IS
	SIGNAL debounce_register_0, debounce_register_1, debounce_register_2, debounce_register_3  : std_logic_vector (2 DOWNTO 0) := (OTHERS => '0'); -- Debounce registers
	SIGNAL debounced_buttons_signal : std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');
	SIGNAL int_toggle  : std_logic                     := '0';
BEGIN

	--------------------------------------------
	-- Debounce:
	-- Debounces a button press by ensuring the button
	-- has been pressed for 3 clock cycles, thus
	-- validing the button press
	--------------------------------------------
	Debounce : PROCESS (clk)
	BEGIN
		IF (rising_edge(clk)) THEN
			IF (clr = '1') THEN --Clear
				debounce_register_0 <= (OTHERS => '0');
				debounce_register_1 <= (OTHERS => '0');
				debounce_register_2 <= (OTHERS => '0');
				debounce_register_3 <= (OTHERS => '0');

			ELSE --Shift registers for each button
				debounce_register_0(2)          <= btn(0);
				debounce_register_0(1 DOWNTO 0) <= debounce_register_0(2 DOWNTO 1);
				debounce_register_1(2)          <= btn(1);
				debounce_register_1(1 DOWNTO 0) <= debounce_register_1(2 DOWNTO 1);
				debounce_register_2(2)          <= btn(2);
				debounce_register_2(1 DOWNTO 0) <= debounce_register_2(2 DOWNTO 1);
				debounce_register_3(2)          <= btn(3);
				debounce_register_3(1 DOWNTO 0) <= debounce_register_3(2 DOWNTO 1);
			END IF;
		END IF;
	END PROCESS;
	--If all values in shift regisers are on the output will be on.
	debounced_buttons_signal(0) <= debounce_register_0(1) AND debounce_register_0(2) AND debounce_register_0(0);
	debounced_buttons_signal(1) <= debounce_register_1(1) AND debounce_register_1(2) AND debounce_register_1(0);
	debounced_buttons_signal(2) <= debounce_register_2(1) AND debounce_register_2(2) AND debounce_register_2(0);
	debounced_buttons_signal(3) <= debounce_register_3(1) AND debounce_register_3(2) AND debounce_register_3(0);

	--------------------------------------------
	-- Interrupt:
	-- Sets interrupt signal high when any combination of button is pressed
	-- Disables when "int_toggle" is set high.
	-- An interrupt signal can then only be set once all buttons are released
	--------------------------------------------
	Interrupt : PROCESS (clk,debounced_buttons_signal, int_toggle)
	BEGIN
		IF rising_edge(clk) THEN
			IF (debounced_buttons_signal = "0000" OR debounced_buttons_signal = "ZZZZ" OR debounced_buttons_signal = "UUUU" OR int_toggle = '1') THEN
				interrupt_on <= '0';
			ELSE
				interrupt_on <= '1';
			END IF;
		END IF;
	END PROCESS;

	--------------------------------------------
	-- InterruptReset:
	-- Sets "int_toggle"
	-- Sets "int_toggle" when "interrupt_reset" is high
	-- Resets "int_toggle" back to zero once all buttons are released
	--------------------------------------------
	InterruptReset : PROCESS (interrupt_reset, debounced_buttons_signal)
	BEGIN
			IF (interrupt_reset = '1') THEN
				int_toggle <= '1';
			ELSIF (debounced_buttons_signal = "000") THEN
				int_toggle <= '0';
			END IF;
	END PROCESS;
	debounced_btn_out <= debounced_buttons_signal;
END Behavioral;