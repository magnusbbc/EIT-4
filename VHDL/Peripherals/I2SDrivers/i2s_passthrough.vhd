LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY i2s_passthrough IS
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
	i2sdrivers : entity work.i2sDriver 
	generic map( 	
			DATA_WIDTH 	=> DATA_WIDTH  
	)
	port map(
			bclk 		=> bclk 		,
			ws			=> ws			,
			Din		=> Din		,
			DOut_L	=> DOut_L	,
			DOut_R	=> DOut_R	,
			inInt_L	=> inInt_L	,
			inInt_R	=> inInt_R	,
			inIntr_L	=> inIntr_L	,
			inIntr_R	=> inIntr_R	,
			--input
			clk 		=> bclk 		,
			outInt_L	=> inInt_L	,
			outInt_R	=> inInt_R	,
			outIntr_L=> inIntr_L,
			outIntr_R=> inIntr_R,
			DIn_L 	=> DOut_L 	,
			DIn_R	 	=> DOut_R 	,
			bclkO 	=> bclkO 	,
			wsO		=> wsO		,
			DOut		=> DOut			
        );
		  
	
		  
END i2s_passthrough;