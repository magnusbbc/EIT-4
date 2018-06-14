#include I2S_Config.hvhd
--------------------------------------------------------------------------------------
--Engineer: Frederik Rasmussen
--Module Name: I2S Input Peripheral
--
--Description:
--
--
--
--------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY i2sDriverIn IS
	PORT
	(
		bit_clock             : IN std_logic := '0';-- Bitclock in
		word_select           : IN std_logic := '0';-- Worselect
		data_in               : IN std_logic := '0';-- Data in
		data_out_left         : OUT std_logic_vector(DATA_WIDTH -1 DOWNTO 0) := (OTHERS => '0'); -- One full word of data out
		data_out_right        : OUT std_logic_vector(DATA_WIDTH -1 DOWNTO 0) := (OTHERS => '0');
		interrupt_left        : OUT std_logic := '0';-- Interupt out. Is set high when a new word is ready
		interrupt_right       : OUT std_logic := '0';
		interrupt_reset_left  : IN std_logic  := '0';-- Interupt reset. Set this high to reset the interupt. Should be high untill intterupt put is low again.
		interrupt_reset_right : IN std_logic  := '0'
		--Ports for input
	);
END i2sDriverIn;

ARCHITECTURE i2sDriverIn OF i2sDriverIn IS
	SIGNAL lr      : std_logic := '1';--Internal wordselect, short for 'left right'. Right channel is active when '1'
	SIGNAL cnt     : INTEGER   := 0; -- Bit counter
	SIGNAL outBuff : std_logic_vector (DATA_WIDTH -1 DOWNTO 0) := (OTHERS => '0') ;-- The initial buffer for the serial data

BEGIN
	data_input : PROCESS (bit_clock, word_select)--The main process
		VARIABLE vcnt     : INTEGER                                    := 0; --Variable for the cnt signal
		VARIABLE voutBuff : std_logic_vector (DATA_WIDTH -1 DOWNTO 0) := x"0000";--variable for the output buffer
	BEGIN
		IF rising_edge(bit_clock) THEN

			--load variables
			vcnt     := cnt;
			voutBuff := outBuff;

			--reset interupts
			IF interrupt_reset_left = '1' THEN
				interrupt_left <= '0';
			END IF;
			IF interrupt_reset_right = '1' THEN
				interrupt_right <= '0';
			END IF;

			IF vcnt < (DATA_WIDTH ) THEN

				voutBuff(DATA_WIDTH-1-vcnt) := data_in; -- Read data to buffer

				vcnt           := vcnt + 1; --increment counter

			END IF;

			IF lr = NOT word_select THEN -- At this point the data change channel

				--Loading the buffer the apropiate output 
				--The logic for truncating the data have been removed because it caused problems, another implementation is possible if needed
				IF lr = '0' THEN
					data_out_left <= voutbuff;
					
				ELSE
					data_out_right <= voutbuff;

				END IF;

				voutbuff := (others=>'0'); -- Rady the buffer for the next word

				lr <= word_select; --change the internal worselect

				vcnt := 0; --reset counter

				IF word_select = '0' THEN -- the buffer is now ready interrupt is set high.
					interrupt_right <= '1';

				ELSE
					interrupt_left <= '1';
				END IF;

			ELSE
			END IF;
			-- The variables are saved in the signals
			cnt     <= vcnt;
			outBuff <= voutBuff;
		END IF;
	END PROCESS;
END i2sDriverIn;