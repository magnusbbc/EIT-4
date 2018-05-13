LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY i2s_passthrough IS
	GENERIC
	(
		DATA_WIDTH : INTEGER RANGE 4 TO 32 := 4
	);
	PORT
	(
		bit_clock   : IN std_logic;
		word_select     : IN std_logic;
		data_in   : IN std_logic;
		
		bit_clock_out     : out std_logic;
		word_select_out       : out std_logic;
		data_out     	: out std_logic
	);
END i2s_passthrough;

ARCHITECTURE i2s_passthrough OF i2s_passthrough IS
signal DOut_L 	:  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
signal DOut_R 	:  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
signal inInt_L  :  std_logic;
signal inInt_R  :  std_logic;
signal inIntr_L :  std_logic;
signal inIntr_R :  std_logic;
		--Ports for input

BEGIN
	i2sIn : entity work.i2sDriverIn 
	
	port map(
			bit_clock	 			=> bit_clock	 		,
			word_select				=> word_select			,
			data_in 				=> data_in 				,
			data_out_left 			=> DOut_L 		,
			data_out_right 			=> DOut_R 		,
			interrupt_left			=> inInt_L		,
			interrupt_right			=> inInt_R		,
			interrupt_reset_left	=> inIntr_L	,
			interrupt_reset_right	=> inIntr_R		);
			--
			i2sOut : entity work.i2sDriverOut
			port map(
				
			clk	 					=> bit_clock 		,
			interrupt_left			=> inInt_L	,
			interrupt_right			=> inInt_R	,
			interrupt_reset_left	=> inIntr_L,
			interrupt_reset_right	=> inIntr_R,
			data_in_left	 		=> DOut_L 	,
			data_in_right		 	=> DOut_R 	,
			bit_clock	 			=> bit_clock_out 	,
			word_select				=> word_select_out		,
			data_out				=> data_out			
        );
		  
	
		  
END i2s_passthrough;