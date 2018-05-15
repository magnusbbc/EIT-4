
--------------------------------------------------------------------------------------
--Engineer: Frederik Rasmussen
--Module Name: I2S Input Mono Passthrough
--
--Description:
--This is a testbench to test the I2S Mono modules. 
--The modules are directly connected via the i2s_passthrough_mono.
--The testbench tests the I2S under by first sending 0 to 10 trough at the specified Bitdepth(This is setup for 16 bit).
--Then some other test signals such as all ones and all zeroes are send. 
--Finally it is tested with higher and lower bitdepth than the 16 bit.
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity I2S_testbench_mono_passthrough is
end I2S_testbench_mono_passthrough;
architecture test of I2S_testbench_mono_passthrough is

constant t : time := 100 ns;

signal	bit_clock_in 		: std_logic;
signal	word_select_in		: std_logic;
signal	data_in				: std_logic;

signal	bit_clock_out 		: std_logic;
signal	word_select_out		: std_logic;
signal	data_out			: std_logic;


begin

	 dut : entity work.i2s_passthrough_mono

	port map(
			bit_clock_in 		=> bit_clock_in 	,
			word_select_in		=> word_select_in		,
			data_in				=> data_in	,
			bit_clock_out  		=> bit_clock_out ,
			word_select_out		=> word_select_out	,
			data_out			=> data_out	

        );

	
	simulation : process
	
	
	procedure I2SSignalBurst(
		constant w : std_logic;			--wordselect, 0 = left and 1 = right
		constant d : std_logic_vector;	--data
		constant m : integer			--multiplier for repeats
		)	 
	is
	 	variable len : integer := (d'length)*m;
	begin
		
			for j in 1 to m loop
				for i in 1 to d'length loop
				
					wait for t;
					bit_clock_in 	<= '0';

					if j*i = len then 
						word_select_in <= not w;
					else
						word_select_in <= w;
					end if;

					data_in 		<= d(i-1);
					wait for t;

					bit_clock_in 	<= '1';
				end loop;
			end loop;
				
	end I2SSignalBurst;
			

		begin
		-----------------------------------------
		-- Loop counts to 10 in specified bit-depth to both channels
		-----------------------------------------
		
		for i in 0 to 10 loop
		I2SSignalBurst(('1'),(std_logic_vector(to_unsigned(i,16))),(1));
		I2SSignalBurst(('0'),(std_logic_vector(to_unsigned(i,16))),(1));
		
		end loop;
		-----------------------------------------
		-- Other test signals 
		-----------------------------------------
			I2SSignalBurst(('1'),("0101"),(4));
			I2SSignalBurst(('0'),("0000"),(4));

			I2SSignalBurst(('1'),("1111"),(4));
			I2SSignalBurst(('0'),("1010"),(4));

			I2SSignalBurst(('1'),("0000"),(4));
			I2SSignalBurst(('0'),("1111"),(4));
		-----------------------------------------
		-- Irregular signals to test behavior
		-----------------------------------------
			I2SSignalBurst(('1'),("0000"),(2));
			I2SSignalBurst(('0'),("1001"),(2));

			I2SSignalBurst(('1'),("1100"),(1));
			I2SSignalBurst(('0'),("1111"),(1));

			I2SSignalBurst(('1'),("0000"),(8));
			I2SSignalBurst(('0'),("1111"),(8));			
			I2SSignalBurst(('1'),("1111"),(1));
			I2SSignalBurst(('0'),("0000"),(1));
			
			
		
			wait;
		end process	;
end architecture test;
