
--------------------------------------------------------------------------------------
--Engineer: Frederik Rasmussen
--Module Name: I2S Input Mono Passthrough
--
--Description:
--
--
--
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity I2S_testbench_mono_passthrough is
end I2S_testbench_mono_passthrough;
architecture test of I2S_testbench_mono_passthrough is


constant t : time := 100 ns;

signal	bit_clock 			: std_logic;
signal	word_select				: std_logic;
signal	data_in			: std_logic;
signal	bit_clock_out 		: std_logic;
signal	word_select_out			: std_logic;
signal	data_out			: std_logic;


begin

	 dut : entity work.i2s_passthrough_mono

	port map(
			bit_clock 			=> bit_clock 	,
			word_select			=> word_select		,
			data_in				=> data_in	,
			bit_clock_out  	=> bit_clock_out ,
			word_select_out	=> word_select_out	,
			data_out				=> data_out	

        );

	
	simulation : process
	
	
	procedure clockEvents(
		constant w : std_logic;--wordselect 0 = left 1 = right
		constant d : std_logic_vector;--data
		constant m : integer--multiplier for repeats
	 ) 
	 is
	 		variable len : integer := (d'length)*m;
		begin
		
			for j in 1 to m loop
				for i in 1 to d'length loop
				
					wait for t;
					bit_clock 	<= '0';

					if j*i = len then 
						word_select <= not w;
					else
						word_select <= w;
					end if;
					data_in 		<= d(i-1);
					wait for t;

					bit_clock 	<= '1';
				end loop;
			end loop;
				
			end clockEvents;
			

		begin
		-----------------------------------------
		-- Loop counts to 10 in specified bit-depth
		-----------------------------------------
		
		for i in 0 to 10 loop
		clockEvents(('1'),(std_logic_vector(to_unsigned(i,16))),(1));
		clockEvents(('0'),(std_logic_vector(to_unsigned(i,16))),(1) );
		
		end loop;
		
			clockEvents(('1'),("0101"),(4));
			clockEvents(('0'),("0000"),(4));

			clockEvents(('1'),("1111"),(4));
			clockEvents(('0'),("1010"),(4));

			clockEvents(('1'),("0000"),(4));
			clockEvents(('0'),("1111"),(4));

			clockEvents(('1'),("0000"),(2));
			clockEvents(('0'),("1001"),(2));

			clockEvents(('1'),("1100"),(1));
			clockEvents(('0'),("1111"),(1));

			clockEvents(('1'),("0000"),(8));
			clockEvents(('0'),("1111"),(8));			
			clockEvents(('1'),("1111"),(1));
			clockEvents(('0'),("0000"),(1));
			
			
		
			wait;
		end process	;
end architecture test;
