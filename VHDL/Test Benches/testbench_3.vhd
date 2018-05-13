library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity testbench_3 is
end testbench_3;
architecture test of testbench_3 is

constant DATA_WIDTH : integer := 4;

constant t : time := 100 ns;

signal	bit_clock 			: std_logic;
signal	word_select			: std_logic;
signal	data_in			: std_logic;
signal	bit_clock_out 		: std_logic;
signal	word_select_out			: std_logic;
signal	data_out			: std_logic;


begin

	dut : entity work.i2s_passthrough 
	
	port map(
			bit_clock => bit_clock 	,
			word_select				=> word_select		,
			data_in			=> data_in	,
			bit_clock_out		=> bit_clock_out ,
			word_select_out	 		=> word_select_out	,
			data_out			=> data_out	

        );

	
	simulation : process
	
	procedure clockEvents(
		constant w : std_logic;
		constant d: std_logic_vector(3 downto 0)) is
	begin
		
		wait for t;
		bit_clock<= '0';
		 word_select <= 	w;
		 data_in <= 		d(0);
		wait for t;
		bit_clock<= '1';
		
		
		wait for t;
		bit_clock<= '0';
		 word_select <= 	w;
		 data_in <= 		d(1);
		wait for t;
		bit_clock<= '1';
		
		wait for t;
		bit_clock<= '0';
		 word_select <= 	w;
		 data_in <= 		d(2);
		wait for t;
		bit_clock<= '1';
		
		wait for t;
		bit_clock<= '0';
		 word_select <= 	 w;
		 data_in <= 		d(3);
		wait for t;
		bit_clock<= '1';
		
		wait for t;
		bit_clock<= '0';
		 word_select <= 	w;
		 data_in <= 		d(0);
		wait for t;
		bit_clock<= '1';
		
		
		wait for t;
		bit_clock<= '0';
		 word_select <= 	w;
		 data_in <= 		d(1);
		wait for t;
		bit_clock<= '1';
		
		wait for t;
		bit_clock<= '0';
		 word_select <= 	w;
		 data_in <= 		d(2);
		wait for t;
		bit_clock<= '1';
		
		wait for t;
		bit_clock<= '0';
		 word_select <= 	 w;
		 data_in <= 		d(3);
		wait for t;
		bit_clock<= '1';
		
		wait for t;
		bit_clock<= '0';
		 word_select <= 	w;
		 data_in <= 		d(0);
		wait for t;
		bit_clock<= '1';
		
		
		wait for t;
		bit_clock<= '0';
		 word_select <= 	w;
		 data_in <= 		d(1);
		wait for t;
		bit_clock<= '1';
		
		wait for t;
		bit_clock<= '0';
		 word_select <= 	w;
		 data_in <= 		d(2);
		wait for t;
		bit_clock<= '1';
		
		wait for t;
		bit_clock<= '0';
		 word_select <= 	 w;
		 data_in <= 		d(3);
		wait for t;
		bit_clock<= '1';
		
				wait for t;
			bit_clock<= '0';
			 word_select <= 	w;
			 data_in <= 		d(0);
			wait for t;
			bit_clock<= '1';
			
			
			wait for t;
			bit_clock<= '0';
			 word_select <= 	w;
			 data_in <= 		d(1);
			wait for t;
			bit_clock<= '1';
			
			wait for t;
			bit_clock<= '0';
			 word_select <= 	w;
			 data_in <= 		d(2);
			wait for t;
			bit_clock<= '1';
			
			wait for t;
			bit_clock<= '0';
			 word_select <= 	not w;
			 data_in <= 		d(3);
			wait for t;
			bit_clock<= '1';
			end clockEvents;
	
		begin
			clockEvents(('1'),("1111"));
			clockEvents(('0'),("0000"));
			clockEvents(('1'),("1010"));
			clockEvents(('0'),("1010"));
			clockEvents(('1'),("0101"));
			clockEvents(('0'),("0101"));
			clockEvents(('1'),("0000"));
			clockEvents(('0'),("1111"));
			clockEvents(('1'),("1111"));
			clockEvents(('0'),("1111"));
			clockEvents(('1'),("1111"));
			clockEvents(('0'),("1111"));
			
			
		
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 data_in<= 		'1';
			wait for t;
		
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 word_select <= 		'0';
			 data_in <= 		'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 data_in<= 		'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<= 		'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<= 		'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			word_select <=			'1';
			data_in<=			'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<=			'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<=			'0';
			word_select <=			'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 data_in<= 		'1';
			wait for t;
		
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 word_select <= 		'0';
			 data_in <= 		'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 data_in<= 		'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<= 		'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<= 		'1';
			wait for t;
			
				bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 data_in<= 		'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<= 		'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<= 		'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			word_select <=			'1';
			data_in<=			'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<=			'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<=			'0';
			word_select <=			'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 data_in<= 		'1';
			wait for t;
		
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 word_select <= 		'0';
			 data_in <= 		'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 data_in<= 		'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<= 		'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<= 		'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			word_select <=			'1';
			data_in<=			'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<=			'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<=			'0';
			word_select <=			'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 data_in<= 		'1';
			wait for t;
		
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 word_select <= 		'0';
			 data_in <= 		'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 data_in<= 		'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<= 		'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<= 		'1';
			wait for t;
			
				bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			 data_in<= 		'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<= 		'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<= 		'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			word_select <=			'1';
			data_in<=			'0';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<=			'1';
			wait for t;
			
			bit_clock<= '1';
			wait for t;
			bit_clock<= '0';
			data_in<=			'0';
			word_select <=			'1';
			wait for t;
			wait;
		end process	;
end architecture test;
