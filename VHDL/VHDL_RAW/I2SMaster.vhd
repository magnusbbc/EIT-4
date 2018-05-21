LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY I2SMaster IS

	PORT
	(
		led   : OUT std_logic_vector(9 DOWNTO 0) := (OTHERS => '0'); 	--Signals for controlling onboard LED's
		--I2S input
		bclk  : IN std_logic  := '0';				--External input bitclock signal
		ws    : IN std_logic  := '0';				--External input word select signal
		Din   : IN std_logic  := '0';				--External Data input

		--I2S output
		bclkO : OUT std_logic := '0';				--Bitclock output
		wsO   : OUT std_logic := '0';				--Word select output
		DOut  : OUT std_logic := '0'				--data output

	);
END I2SMaster;

ARCHITECTURE Behavioral OF I2SMaster IS

	SIGNAL data  : std_logic_vector(15 downto 0) := x"0000";
	SIGNAL i2s_interrupt : std_logic := '0';
	SIGNAL interrupt_i2s_reset_signal : std_logic := '0';
	SIGNAL i2s_out_interrupt : std_logic := '0';
	SIGNAL interrupt_i2s_out_reset_signal : std_logic := '0';
BEGIN
    
    I2SMonoIn : ENTITY work.I2SMonoIn(Behavioral)
		PORT
		MAP(
		bit_clock       => bclk,
		word_select     => ws,
		data_in         => Din,
		data_out        => data,
		interrupt       => i2s_interrupt,
		interrupt_reset => interrupt_i2s_reset_signal
		);

	I2SMonoOut : ENTITY work.I2SMonoOut(Behavioral)
		PORT
		MAP(
		clk	    => bclk,
		data_in         => data,
		bit_clock_out    => bclkO,
		word_select_out => wsO,
		data_out        => DOut,
		interrupt_out 	=> i2s_out_interrupt,
		interrupt_out_reset => interrupt_i2s_out_reset_signal
		);
END Behavioral;
