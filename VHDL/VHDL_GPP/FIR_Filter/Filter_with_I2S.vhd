LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Filter_with_I2S IS
	GENERIC
	(
		DATA_WIDTH : INTEGER RANGE 4 TO 32 := 16
	);
	PORT
	(
        --clk         : IN std_logic;
		bit_clock   : IN std_logic;
		word_select     : IN std_logic;
        data_in    : IN std_logic;
        btn        : In std_logic_vector(2 downto 0); 
		
		bit_clock_out    : out std_logic;
		word_select_out      : out std_logic;
		data_out     	: out std_logic
	);
END Filter_with_I2S;

ARCHITECTURE Filter_with_I2S OF Filter_with_I2S IS
signal data_outs 	:  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
signal data_ins 	:  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);

signal interrupt :  std_logic;
signal interrupt_reset :  std_logic;
		--Ports for input

BEGIN
    Filter : entity work.FIR_Temp

    Port map(
        clk                 => word_select,
        reset               => '0',             -- No reset
        load_system_input   => '1',             -- Set to data-mode
        system_input        => data_ins, 
        coefficient_in      => x"0000",         -- Use defaults, so set to 0
        system_output       => data_outs,
        write_enable        => '1'              -- Always run filter
    );

	i2sdriverin : entity work.i2sMonoIn 

	port map(
			bit_clock 		=> bit_clock 		,
			word_select		=> word_select			,
			data_in			=> data_in		,
			data_out		=> data_ins		,
			interrupt		=> interrupt			,
			interrupt_reset	=> '1'	
			
			--input
			);
			
	i2sdriverout : entity work.i2sMonoOut 

	port map(
			clk 				=> bit_clock 		,
			word_select_out		=> word_select_out	,
			data_in				=> data_outs	,
			bit_clock_out		=> bit_clock_out	,
			data_out			=> data_out		
			--input
			);


		  
END Filter_with_I2S;