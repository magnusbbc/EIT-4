LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY i2sMonoIn IS
	GENERIC
	(
		DATA_WIDTH : INTEGER RANGE 4 TO 32 := 16
	);
	PORT
	(
		bclk   : IN std_logic;	--bitclock in
		ws     : IN std_logic;	--wordselect in 
		Din    : IN std_logic; --data in
		DOut 	: OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0); -- data recieved from the i2s (little endian)
		Int  : OUT std_logic;	--interupt. is set high when data is available at DOut
		Intr : IN std_logic		--interupt reset. This should be set high when the data has been read from DOut, and will reset Int at the next clock.
		
		
	);
END i2sMonoIn;

ARCHITECTURE i2sMonoIn OF i2sMonoIn IS

BEGIN
	dut : entity work.i2sDriverIn
	generic map( 	
			DATA_WIDTH 	=> DATA_WIDTH  
	)
	port map(
			bclk 			=> bclk 	,
			ws				=> ws		,
			Din			=> Din	,
			DOut_R 		=> DOut	,
			int_R			=> Int	,
			intr_R		=> Intr
			--Ports for input
        );
		  
	
END i2sMonoIn;