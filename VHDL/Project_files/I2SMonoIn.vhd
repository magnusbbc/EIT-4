
--------------------------------------------------------------------------------------
--Engineer: Frederik Rasmussen
--Module Name: I2S Input Mono Wrapper
--
--Description:
--
--
--
--------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY I2SMonoIn IS
	PORT
	(
		bit_clock       : IN std_logic; --bitclock in
		word_select     : IN std_logic; --wordselect in 
		data_in         : IN std_logic; --data in
		data_out        : OUT std_logic_vector(3 DOWNTO 0); -- data recieved from the i2s (little endian)
		interrupt       : OUT std_logic; --interupt. is set high when data is available at data_out
		interrupt_reset : IN std_logic --interupt reset. This should be set high when the data has been read from data_out, and will reset interrupt at the next clock.
	);
END I2SMonoIn;

ARCHITECTURE Behavioral OF I2SMonoIn IS

BEGIN
	Input : ENTITY work.i2sDriverIn
	PORT MAP
		(
			bit_clock             => bit_clock,
			word_select           => word_select,
			data_in               => data_in,
			data_out_right        => data_out,
			interrupt_right       => interrupt,
			interrupt_reset_right => interrupt_reset
			--Ports for input
		);
END Behavioral;