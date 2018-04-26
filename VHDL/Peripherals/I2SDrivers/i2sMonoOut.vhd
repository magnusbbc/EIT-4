LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY i2sMonoOut IS
	GENERIC
	(
		DATA_WIDTH : INTEGER RANGE 4 TO 32 := 16
	);
	PORT
	(
		
		int  : in std_logic;	-- interupt telling this driver that new data is stable at DIn.
		intr : out std_logic;	-- Interupt reset. This is set high when the data at DIn has been read
		clk		: in std_logic;	-- Clock that will be used for logic and will be directly used as output bitclock. Can be directly connected to a syncronized bitclock input from the i2s input signal.
		DIn	: in std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);-- The data input. The word that should be loaded into the buffers should be loaded to these inputs when the interupts are set to high, and will be loaded at next falling_edge.
		bclkO     : out std_logic;	-- Output bitclock for the output i2s signal.
		wsO       : out std_logic; --Output wordselect for the output i2s signal.
		DOut     	: out std_logic -- Output serial data for the i2s signal.    
	);
END i2sMonoOut;

ARCHITECTURE i2sMonoOut OF i2sMonoOut IS
signal intr_L,intr_R,notInt :std_logic;
BEGIN
notInt<= int;
	dut : entity work.i2sDriverOut
	generic map( 	
			DATA_WIDTH 	=> DATA_WIDTH  
	)
	port map(
			clk			=> clk 	,
			int_L			=> int	,
			int_R			=>  notInt	,
			intr_L		=> intr_L,
			intr_R		=> intr_R,
			DIn_L 		=> DIn,
			DIn_R  		=> DIn ,
			bclk   		=> bclkO ,
			ws    		=> wsO	,
			DOut  		=> DOut	
			--Ports for input
        );
intr<=intr_L and intr_R;	  
END i2sMonoOut;