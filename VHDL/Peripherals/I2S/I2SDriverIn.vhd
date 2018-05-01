--------------------------------------------------------------------------------------
--Engineer: Frederik Rasmussen
--Module Name: I2S Input Peripheral
--
--Description:
--
--
--
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity i2sDriverIn is
	generic
	(
		DATA_WIDTH : integer range 4 to 32 := 16
	);
	port
	(
		bit_clock   : in std_logic;-- Bitclock in
		word_select     : in std_logic;-- Worselect
		data_in    : in std_logic;-- Data in
		data_out_left : out std_logic_vector(DATA_WIDTH - 1 downto 0); -- One full word of data out
		data_out_right : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		interrupt_left  : out std_logic := '0';-- Interupt out. Is set high when a new word is ready
		interrupt_right  : out std_logic := '0';
		interrupt_reset_left : in std_logic  := '0';-- Interupt reset. Set this high to reset the interupt. Should be high untill intterupt put is low again.
		interrupt_reset_right : in std_logic  := '0'
		--Ports for input
	);
end i2sDriverIn;

architecture i2sDriverIn of i2sDriverIn is
	signal lr      : std_logic := '1';--Internal wordselect, short for 'left right' left channel is active when '1'
	signal cnt     : integer   := 0;  -- Bit counter
	signal outBuff : std_logic_vector (DATA_WIDTH - 1 downto 0);-- The initial buffer for the serial data

begin
	data_input : process (bit_clock, word_select)--The main process
		variable vcnt     : integer := 0; --Variable for the cnt signal
		variable voutBuff : std_logic_vector (DATA_WIDTH - 1 downto 0) := x"0000";--variable for the output buffer
	begin
		if rising_edge(bit_clock) then
		
		--load variables
			vcnt     := cnt;		
			voutBuff := outBuff;
			
			--reset interupts
			if interrupt_reset_left = '1' then
				interrupt_left <= '0';
			end if;
			if interrupt_reset_right = '1' then
				interrupt_right <= '0';
			end if;
		
			if vcnt < DATA_WIDTH then

				voutBuff(vcnt) := data_in; -- Read data to buffer

				vcnt     := vcnt + 1; --increment counter

			end if;

			if lr = not word_select then -- At this point the data change channel
		
				--Loading the buffer the apropiate output 
					--The logic for truncating the data have been removed because it caused problems, another implementation is possible if needed
				if lr = '1' then
					data_out_left <= voutbuff;
				
				else
					data_out_right <= voutbuff;
				
				end if;

				
					
				lr <= word_select; --change the internal worselect

				vcnt := 0; --reset counter

				if word_select = '0' then -- the buffer is now ready interrupt is set high.
					interrupt_right <= '1';

				else
					interrupt_left <= '1';
				end if;
				
			else
			

			end if;
			-- The variables are saved in the signals
			cnt     <= vcnt;
			outBuff <= voutBuff;
		end if;
	end process;
end i2sDriverIn;