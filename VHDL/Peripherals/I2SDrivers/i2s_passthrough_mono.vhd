LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY i2s_passthrough_mono IS
	GENERIC
	(
		DATA_WIDTH : INTEGER RANGE 4 TO 32 := 16
	);
	PORT
	(
		bclk   : IN std_logic;
		ws     : IN std_logic;
		Din    : IN std_logic;
		
		bclkO     : out std_logic;
		wsO       : out std_logic;
		DOut     	: out std_logic
	);
END i2s_passthrough_mono;

ARCHITECTURE i2s_passthrough_mono OF i2s_passthrough_mono IS
signal DOuts 	:  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
signal Int :  std_logic;
signal Intr :  std_logic;
		--Ports for input

BEGIN
	i2sdriverin : entity work.i2sMonoIn 
	generic map( 	
			DATA_WIDTH 	=> DATA_WIDTH  
	)
	port map(
			bclk 		=> bclk 		,
			ws			=> ws			,
			Din		=> Din		,
			DOut		=> DOuts		,
			
			Int	=> Int			,
			Intr	=> Intr	
			
			--input
			);
			
				i2sdriverout : entity work.i2sMonoOut 
	generic map( 	
			DATA_WIDTH 	=> DATA_WIDTH  
	)
	port map(
			clk 		=> bclk 		,
			wsO		=> wsO		,
			DIn	=> DOuts	,
			
			Int	=> Int	,
			Intr	=> Intr	,
			bclkO 	=> bclkO 	,
			DOut		=> DOut		
			--input
			);

	
		  
END i2s_passthrough_mono;