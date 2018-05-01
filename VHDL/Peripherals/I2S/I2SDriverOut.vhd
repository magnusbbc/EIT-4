--------------------------------------------------------------------------------------
--Engineer: Frederik Rasmussen
--Module Name: I2S Output Peripheral
--
--Description:
--
--
--
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity i2sDriverOut is
	generic
	(
		DATA_WIDTH : integer range 4 to 32 := 16 --size of the words, bitdepth of the sound
	);
	port
	(

		clk    : in std_logic;-- Clock that will be used for logic and will be directly used as output bitclock. Can be directly connected to a syncronized bitclock input from the i2s input signal.
		interrupt_left  : in std_logic  := '0';-- Interupt for when  new signals are stable at input. should be set high when a new word should be loaded into the output buffer.
		interrupt_right  : in std_logic  := '0';
		interrupt_reset_left : out std_logic := '0';--Interupt reset. Input is set to high when the input has been loaded to the input buffer.
		interrupt_reset_right : out std_logic := '0';
		data_in_left  : in std_logic_vector(DATA_WIDTH - 1 downto 0);-- The data input buses. The word that should be loaded into the buffer should be loaded to these inputs when the interupts are set to high.
		data_in_right  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		bit_clock   : out std_logic;-- Output bitclock for the output i2s signal. 
		word_select     : out std_logic;--Output wordselect for the output i2s signal.
		data_out   : out std_logic -- Output serial data for the i2s signal.     

	);
end i2sDriverOut;

architecture i2sDriverOut of i2sDriverOut is
	signal buff_in_left : std_logic_vector(DATA_WIDTH - 1 downto 0) := (1 => '1', others => '1');--buffers for the input, they are loaded when the interupt are set high
	signal buff_in_right : std_logic_vector(DATA_WIDTH - 1 downto 0) := (1 => '1', others => '1');
	signal bit_counter       : integer                                   := 0;		--Counter for the bits
	signal left_right_select        : std_logic                                 := '0';		--Internal wordselect, short for 'left right' left channel is active when '1'
begin

	bit_clock <= clk; --bitclock is using the same clock as the logic

	data_output : process (clk) --The main process
	begin
		if falling_edge(clk) then -- The logic is perfomed at the falling edge so that the signals are stable to read at the rising clock.

			if bit_counter < DATA_WIDTH then
				if left_right_select = '1' then --Write from the active buffer 
					data_out <= buff_in_left(bit_counter);
				else
					data_out <= buff_in_right(bit_counter);
				end if;

			end if;

			if bit_counter + 1 >= DATA_WIDTH then --Change channel
				word_select <= not left_right_select;
				left_right_select <= not left_right_select;

			end if;
		end if;

	end process;

	data_out_cnt : process (clk)
	begin
		if rising_edge(clk) then -- The counting and buffering are done on the rising edge as they dont affect the active data out. (This is not necesary but was done to try and fix another problem that wasn't a problem)

			
			bit_counter <= bit_counter + 1;

			if bit_counter + 1 >= DATA_WIDTH then --Change channel

				bit_counter <= 0;
			end if;
			if (interrupt_left = '1') and(bit_counter = datA_WIDTH - 1) then --Update the word that is ready
				buff_in_left <= data_in_left;
				interrupt_reset_left    <= '1';
			end if;
			if (interrupt_right = '1') and(bit_counter = datA_WIDTH - 1) then
				buff_in_right <= data_in_right;
				interrupt_reset_right    <= '1';
			end if;

			if (interrupt_left = '0') then --Update the word that is ready
				interrupt_reset_left <= '0';
			end if;
			if (interrupt_right = '0') then
				interrupt_reset_right <= '0';
			end if;
			--end if;

		end if;

	end process;

end i2sDriverOut;