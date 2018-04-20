LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY i2sDriver IS
	GENERIC
	(
		DATA_WIDTH : INTEGER RANGE 4 TO 32 := 16
	);
	PORT
	(
		bclk   : IN std_logic;
		ws     : IN std_logic;
		Din    : IN std_logic;
		DOut_L : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
		DOut_R : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
		inInt_L  : OUT std_logic;
		inInt_R  : OUT std_logic;
		inIntr_L : IN std_logic;
		inIntr_R : IN std_logic;
		--Ports for input
		outInt_L  : in std_logic;
		outInt_R  : in std_logic;
		outIntr_L : out std_logic;
		outIntr_R : out std_logic;
		clk		: in std_logic;
		DIn_L 	: in std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
		DIn_R 	: in std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
		bclkO     : out std_logic;
		wsO       : out std_logic;
		DOut     	: out std_logic
	);
END i2sDriver;

ARCHITECTURE i2sDriver OF i2sDriver IS

BEGIN
	dut : entity work.i2sDriverIn 
	generic map( 	
			DATA_WIDTH 	=> DATA_WIDTH  
	)
	port map(
			bclk 			=> bclk 	,
			ws				=> ws		,
			Din			=> Din	,
			DOut_L 		=> DOut_L,
			DOut_R 		=> DOut_R,
			int_L			=> inInt_L	,
			int_R			=> inInt_R	,
			intr_L		=> inIntr_L	,
			intr_R		=> inIntr_R	
			--Ports for input
        );
		  
	dut2 : entity work.i2sDriverOut
	generic map( 	
			DATA_WIDTH 	=> DATA_WIDTH  
	)
	port map(
			clk			=> clk 	,
			int_L			=> outInt_L	,
			int_R			=> outInt_R	,
			intr_L		=> outIntr_L,
			intr_R		=> outIntr_R,
			DIn_L 		=> DIn_L ,
			DIn_R  		=> DIn_R ,
			bclk   		=> bclkO ,
			ws    		=> wsO	,
			DOut  		=> DOut	
			--Ports for input
        );
		  
END i2sDriver;