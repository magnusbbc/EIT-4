library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity testbench_4 is
end testbench_4;
architecture test of testbench_4 is

constant DATA_WIDTH : integer := 4;

constant t : time := 100 ns;

signal	bclk 			: std_logic;
signal	ws				: std_logic;
signal	Din			: std_logic;
signal	bclkO 		: std_logic;
signal	wsO			: std_logic;
signal	Dout			: std_logic;


begin

	dut : entity work.i2s_passthrough_mono
	generic map( 	
			DATA_WIDTH 	=> DATA_WIDTH  
	)
	port map(
			bclk 			=> bclk 	,
			ws				=> ws		,
			Din			=> Din	,
			bclkO  		=> bclkO ,
			wsO	 		=> wsO	,
			Dout			=> Dout	

        );

	
	simulation : process
	
	procedure clockEvents(
		constant w : std_logic;
		constant d: std_logic_vector(3 downto 0)) is
	begin
--			
--			wait for t;
--			bclk <= '0';
--			 ws <= 	w;
--			 din <= 		d(0);
--			wait for t;
--			bclk <= '1';
--			
--			
--			wait for t;
--			bclk <= '0';
--			 ws <= 	w;
--			 din <= 		d(1);
--			wait for t;
--			bclk <= '1';
--			
--			wait for t;
--			bclk <= '0';
--			 ws <= 	w;
--			 din <= 		d(2);
--			wait for t;
--			bclk <= '1';
--			
--			wait for t;
--			bclk <= '0';
--			 ws <= 	 w;
--			 din <= 		d(3);
--			wait for t;
--			bclk <= '1';
--			
				wait for t;
			bclk <= '0';
			 ws <= 	w;
			 din <= 		d(0);
			wait for t;
			bclk <= '1';
			
			
			wait for t;
			bclk <= '0';
			 ws <= 	w;
			 din <= 		d(1);
			wait for t;
			bclk <= '1';
			
			wait for t;
			bclk <= '0';
			 ws <= 	w;
			 din <= 		d(2);
			wait for t;
			bclk <= '1';
			
			wait for t;
			bclk <= '0';
			 ws <= 	not w;
			 din <= 		d(3);
			wait for t;
			bclk <= '1';
			end clockEvents;
	
		begin
			clockEvents(('1'),("1111"));
			clockEvents(('0'),("0000"));
			
			clockEvents(('1'),("1111"));
			clockEvents(('0'),("1101"));
			
			clockEvents(('1'),("1111"));
			clockEvents(('0'),("1101"));
			
			clockEvents(('1'),("1111"));
			clockEvents(('0'),("1001"));
			
			clockEvents(('1'),("0000"));
			clockEvents(('0'),("1111"));
			
			clockEvents(('1'),("0000"));
			clockEvents(('0'),("1111"));
			
			
		
			bclk <= '1';
			wait for t;
			bclk <= '0';
			 din<= 		'1';
			wait for t;
		
			bclk <= '1';
			wait for t;
			bclk <= '0';
			 ws <= 		'0';
			 din <= 		'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			 din<= 		'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<= 		'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<= 		'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			ws<=			'1';
			din<=			'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<=			'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<=			'0';
			ws<=			'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			 din<= 		'1';
			wait for t;
		
			bclk <= '1';
			wait for t;
			bclk <= '0';
			 ws <= 		'0';
			 din <= 		'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			 din<= 		'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<= 		'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<= 		'1';
			wait for t;
			
				bclk <= '1';
			wait for t;
			bclk <= '0';
			 din<= 		'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<= 		'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<= 		'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			ws<=			'1';
			din<=			'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<=			'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<=			'0';
			ws<=			'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			 din<= 		'1';
			wait for t;
		
			bclk <= '1';
			wait for t;
			bclk <= '0';
			 ws <= 		'0';
			 din <= 		'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			 din<= 		'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<= 		'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<= 		'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			ws<=			'1';
			din<=			'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<=			'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<=			'0';
			ws<=			'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			 din<= 		'1';
			wait for t;
		
			bclk <= '1';
			wait for t;
			bclk <= '0';
			 ws <= 		'0';
			 din <= 		'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			 din<= 		'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<= 		'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<= 		'1';
			wait for t;
			
				bclk <= '1';
			wait for t;
			bclk <= '0';
			 din<= 		'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<= 		'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<= 		'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			ws<=			'1';
			din<=			'0';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<=			'1';
			wait for t;
			
			bclk <= '1';
			wait for t;
			bclk <= '0';
			din<=			'0';
			ws<=			'1';
			wait for t;
			wait;
		end process	;
end architecture test;
