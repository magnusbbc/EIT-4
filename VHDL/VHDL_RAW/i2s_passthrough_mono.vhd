LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY i2s_passthrough_mono IS
	GENERIC
	(
		DATA_WIDTH : INTEGER RANGE 4 TO 32 := 4
	);
	PORT
	(
		bit_clock   : IN std_logic;
		word_select     : IN std_logic;
		data_in    : IN std_logic;
		
		bit_clock_out    : out std_logic;
		word_select_out      : out std_logic;
		data_out     	: out std_logic
	);
END i2s_passthrough_mono;

ARCHITECTURE i2s_passthrough_mono OF i2s_passthrough_mono IS
signal data_outs 	:  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
signal interrupt :  std_logic;
signal interrupt_reset :  std_logic;
		--Ports for input

BEGIN
	i2sdriverin : entity work.i2sMonoIn 

	port map(
			bit_clock 		=> bit_clock 		,
			word_select			=> word_select			,
			data_in		=> data_in		,
			data_out		=> data_outs		,
			interrupt	=> interrupt			,
			interrupt_reset	=> '1'	
			
			--input
			);
			
				i2sdriverout : entity work.i2sMonoOut 

	port map(
			clk 		=> bit_clock 		,
			word_select_out		=> word_select_out	,
			data_in	=> data_outs	,
			bit_clock_out	=> bit_clock_out	,
			data_out		=> data_out		
			--input
			);

	
		  
END i2s_passthrough_mono;