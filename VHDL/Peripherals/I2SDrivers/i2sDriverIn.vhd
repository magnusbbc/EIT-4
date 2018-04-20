LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY i2sDriverIn IS
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
		int_L  	: out std_logic :='0';
		int_R  	: out	std_logic :='0';
		intr_L  	: in std_logic :='0';
		intr_R  	: in std_logic :='0'
		--Ports for input
	);
END i2sDriverIn;

ARCHITECTURE i2sDriverIn OF i2sDriverIn IS
	SIGNAL lr  : std_logic := '1';
	SIGNAL cnt : INTEGER   := 0;
	signal outBuff : std_logic_vector ( DATA_WIDTH -1 downto 0);
	
BEGIN
	data_in : PROCESS (bclk, ws)
	variable vcnt : integer :=0;
	variable voutBuff : std_logic_vector ( DATA_WIDTH -1 downto 0);
	BEGIN
		IF rising_edge(bclk) THEN
			vcnt:= cnt;
			voutBuff:=outBuff;
			
			if intr_L = '1' then
			int_L <='0';
			end if;
			if intr_R ='1' then
			int_R<='0';
			end if;
			
			
			IF vcnt < DATA_WIDTH THEN

				voutBuff(DATA_WIDTH - vcnt - 1) := Din;

				vcnt := vcnt + 1;

			END IF;

			IF lr = NOT ws THEN
				
				--IF vcnt < DATA_WIDTH THEN
					IF lr = '1' THEN
						dout_L<=voutbuff;
						--dout_L(DATA_WIDTH - vcnt - 1 DOWNTO 0) <= (OTHERS => '0');
					ELSE
						dout_R<=voutbuff;
						--dout_R(DATA_WIDTH - vcnt - 1 DOWNTO 0) <= (OTHERS => '0');
					END IF;
					
				--END IF;

				lr  <= ws;

				vcnt := 0;

				IF ws = '0' THEN

					int_R <= '1';
					int_L <= '0';

				ELSE

					int_R <= '0';
					int_L <= '1';
				END IF;
			ELSE
				IF ws = '1' THEN

					int_R <= '1';
					int_L <= '0';

				ELSE

					int_R <= '0';
					int_L <= '1';
				END IF;
				
			END IF;
			cnt<=vcnt;
			outBuff<=voutBuff;
		END IF;
	END PROCESS;
END i2sDriverIn;