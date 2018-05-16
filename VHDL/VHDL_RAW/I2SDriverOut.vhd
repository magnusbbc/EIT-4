
--------------------------------------------------------------------------------------
--Engineer: Frederik Rasmussen
--Module Name: I2S Output Peripheral
--
--Description:
--
--
--
--------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY i2sDriverOut IS
	PORT
	(

		clk                   : IN std_logic;-- Clock that will be used for logic and will be directly used as output bitclock. Can be directly connected to a syncronized bitclock input from the i2s input signal.
		interrupt_left        : IN std_logic  := '0';-- Interupt for when  new signals are stable at input. should be set high when a new word should be loaded into the output buffer.
		interrupt_right       : IN std_logic  := '0';
		interrupt_reset_left  : OUT std_logic := '0';--Interupt reset. Input is set to high when the input has been loaded to the input buffer.
		interrupt_reset_right : OUT std_logic := '0';
		data_in_left          : IN std_logic_vector(16-1 DOWNTO 0);-- The data input buses. The word that should be loaded into the buffer should be loaded to these inputs when the interupts are set to high.
		data_in_right         : IN std_logic_vector(16-1 DOWNTO 0);
		bit_clock             : OUT std_logic;-- Output bitclock for the output i2s signal. 
		word_select           : OUT std_logic;--Output wordselect for the output i2s signal.
		data_out              : OUT std_logic -- Output serial data for the i2s signal.     

	);
END i2sDriverOut;

ARCHITECTURE i2sDriverOut OF i2sDriverOut IS
	SIGNAL buff_in_left      : std_logic_vector(16-1 DOWNTO 0) := (1 => '1', OTHERS => '1');--buffers for the input, they are loaded when the interupt are set high
	SIGNAL buff_in_right     : std_logic_vector(16-1 DOWNTO 0) := (1 => '1', OTHERS => '1');
	SIGNAL bit_counter       : INTEGER                                   := 0; --Counter for the bits
	SIGNAL left_right_select : std_logic                                 := '0'; --Internal wordselect, short for 'left right' left channel is active when '1'
BEGIN

	bit_clock <= clk; --bitclock is using the same clock as the logic

	data_output : PROCESS (clk) --The main process
	BEGIN
		IF falling_edge(clk) THEN -- The logic is perfomed at the falling edge so that the signals are stable to read at the rising clock.

			IF bit_counter < (16-1 + 1) THEN
				IF left_right_select = '1' THEN --Write from the active buffer 
					data_out <= buff_in_left(16 -1- bit_counter);
				ELSE
					data_out <= buff_in_right(16 -1- bit_counter);
				END IF;

			END IF;

			IF bit_counter + 1 >= (16-1 + 1) THEN --Change channel
				word_select       <= NOT left_right_select;
				left_right_select <= NOT left_right_select;

			END IF;
		END IF;

	END PROCESS;

	data_out_cnt : PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN -- The counting and buffering are done on the rising edge as they dont affect the active data out. (This is not necesary but was done to try and fix another problem that wasn't a problem)
			bit_counter <= bit_counter + 1;

			IF bit_counter + 1 >= (16-1 + 1) THEN --Change channel

				bit_counter <= 0;
			END IF;
			IF (interrupt_left = '1') AND(bit_counter = 16-1) THEN --Update the word that is ready
				buff_in_left         <= data_in_left;
				interrupt_reset_left <= '1';
			END IF;
			IF (interrupt_right = '1') AND(bit_counter = 16-1) THEN
				buff_in_right         <= data_in_right;
				interrupt_reset_right <= '1';
			END IF;

			IF (interrupt_left = '0') THEN --Update the word that is ready
				interrupt_reset_left <= '0';
			END IF;
			IF (interrupt_right = '0') THEN
				interrupt_reset_right <= '0';
			END IF;
			--end if;

		END IF;

	END PROCESS;

END i2sDriverOut;