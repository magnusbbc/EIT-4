library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity I2S_testbench_mono_passthrough is
end I2S_testbench_mono_passthrough;
architecture test of I2S_testbench_mono_passthrough is

constant DATA_WIDTH : integer := 4;

constant t : time := 100 ns;

signal	bit_clock 			: std_logic;
signal	word_select				: std_logic;
signal	data_in			: std_logic;
signal	bit_clock_out 		: std_logic;
signal	word_select_out			: std_logic;
signal	data_out			: std_logic;


begin

	 dut : entity work.i2s_passthrough_mono
	generic map( 	
			DATA_WIDTH 	=> DATA_WIDTH  
	)
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
	
	 ) is
	 		variable len : integer := d'length*m - 1;
			

	begin
			for i in 0 to len-1 loop
				wait for t;
				bit_clock 	<= '0';
				word_select <= w;
				data_in 		<= d(i);
				wait for t;
				bit_clock 	<= '1';
			end loop;
				
			wait for t;
			bit_clock 	<= '0';
			word_select <= not w;
			data_in 		<= d(len);
			wait for t;
			bit_clock 	<= '1';
			end clockEvents;
			


		begin
		-----------------------------------------
		-- Loop counts to 10 in specified bit-depth
		-----------------------------------------
		
		for i in 0 to 10 loop
		clockEvents(('1'),(std_logic_vector(to_unsigned(i,datA_WIDTH))),(1));
		clockEvents(('0'),(std_logic_vector(to_unsigned(i,datA_WIDTH))),(1) );
		
		end loop;
		
			clockEvents(('1'),("0101"),(1));
			clockEvents(('0'),("0000"),(1));			
			clockEvents(('1'),("1111"),(1));
			clockEvents(('0'),("1101"),(1));
			clockEvents(('1'),("1111"),(1));
			clockEvents(('0'),("1101"),(1));
			clockEvents(('1'),("1111"),(1));
			clockEvents(('0'),("1001"),(1));			
			clockEvents(('1'),("0000"),(1));
			clockEvents(('0'),("1111"),(1));			
			clockEvents(('1'),("0000"),(1));
			clockEvents(('0'),("1111"),(1));
			
			
		
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 data_in<= 		'1';
			wait for t;
		
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 word_select <= 		'0';
			 data_in <= 		'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 data_in<= 		'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<= 		'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<= 		'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			word_select<=			'1';
			data_in<=			'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<=			'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<=			'0';
			word_select<=			'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 data_in<= 		'1';
			wait for t;
		
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 word_select <= 		'0';
			 data_in <= 		'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 data_in<= 		'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<= 		'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<= 		'1';
			wait for t;
			
				bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 data_in<= 		'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<= 		'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<= 		'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			word_select<=			'1';
			data_in<=			'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<=			'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<=			'0';
			word_select<=			'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 data_in<= 		'1';
			wait for t;
		
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 word_select <= 		'0';
			 data_in <= 		'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 data_in<= 		'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<= 		'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<= 		'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			word_select<=			'1';
			data_in<=			'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<=			'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<=			'0';
			word_select<=			'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 data_in<= 		'1';
			wait for t;
		
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 word_select <= 		'0';
			 data_in <= 		'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 data_in<= 		'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<= 		'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<= 		'1';
			wait for t;
			
				bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			 data_in<= 		'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<= 		'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<= 		'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			word_select<=			'1';
			data_in<=			'0';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<=			'1';
			wait for t;
			
			bit_clock <= '1';
			wait for t;
			bit_clock <= '0';
			data_in<=			'0';
			word_select<=			'1';
			wait for t;
			wait;
		end process	;
end architecture test;
