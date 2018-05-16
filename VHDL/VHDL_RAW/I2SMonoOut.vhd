
--------------------------------------------------------------------------------------
--Engineer: Frederik Rasmussen, Magnus Christensen
--Module Name: I2S Output Mono Wrapper
--
--Description:
--
--
--
--------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY I2SMonoOut IS
	PORT
	(

		clk             : IN std_logic; -- Clock that will be used for logic and will be directly used as output bitclock. Can be directly connected to a syncronized bitclock input from the i2s input signal.
		data_in         : IN std_logic_vector(16-1 DOWNTO 0);-- The data input. The word that should be loaded into the buffers should be loaded to these inputs when the interupts are set to high, and will be loaded at next falling_edge.
		bit_clock_out   : OUT std_logic; -- Output bitclock for the output i2s signal.
		word_select_out : OUT std_logic; --Output wordselect for the output i2s signal.
		data_out        : OUT std_logic; -- Output serial data for the i2s signal.    

		interrupt_out   : OUT std_logic := '0';
		interrupt_out_reset : IN std_logic := '0'
	);
END I2SMonoOut;

ARCHITECTURE Behavioral OF I2SMonoOut IS
	SIGNAL interrupt_reset_left, interrupt_reset_right, interrupt : std_logic;
	SIGNAL interrupt_reset                                        : std_logic                                 := '0';
	SIGNAL data_in_temp                                           : std_logic_vector(16-1 DOWNTO 0) := x"0000";
BEGIN
	PROCESS (clk,data_in, interrupt_reset)
	BEGIN
		IF(rising_edge(clk)) THEN
			IF (interrupt_reset = '1') THEN
				interrupt <= '0';
				interrupt_out <= '1';
			ELSIF(interrupt_out_reset = '1') THEN
				interrupt_out <= '0';
			ELSIF (data_in /= data_in_temp) THEN
				data_in_temp <= data_in;
				interrupt    <= '1';
			END IF;
		END IF;
	END PROCESS;

	Output : ENTITY work.i2sDriverOut
		PORT MAP
		(
			clk                   => clk,
			interrupt_left        => interrupt,
			interrupt_right       => interrupt,
			interrupt_reset_left  => interrupt_reset_left,
			interrupt_reset_right => interrupt_reset_right,
			data_in_left          => data_in_temp,
			data_in_right         => data_in_temp,
			bit_clock             => bit_clock_out,
			word_select           => word_select_out,
			data_out              => data_out
			--Ports for Output
		);
	interrupt_reset <= interrupt_reset_left AND interrupt_reset_right;
END Behavioral;