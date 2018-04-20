LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY i2sDriverOut IS
	GENERIC
	(
		DATA_WIDTH : INTEGER RANGE 4 TO 32 := 16
	);
	PORT
	(
		
		clk		: in std_logic;
		int_L  	: in 	std_logic :='0';
		int_R  	: in 	std_logic :='0';
		intr_L  	: out std_logic :='0';
		intr_R  	: out std_logic :='0';
		DIn_L 	: in std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
		DIn_R 	: in std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
		bclk     : out std_logic;
		ws       : out std_logic;
		DOut     : out std_logic
		
	);
END i2sDriverOut;

ARCHITECTURE i2sDriverOut OF i2sDriverOut IS
	signal clkb	: std_logic :='1';
	signal buff_In_L 	: std_logic_vector(DATA_WIDTH - 1 DOWNTO 0):= (1=> '1',others => '1');
	signal buff_In_R 	: std_logic_vector(DATA_WIDTH - 1 DOWNTO 0):= (1=> '1',others => '1');
	SIGNAL cnt : INTEGER   := 0;
	Signal lr : std_logic := '0';
BEGIN

bclk<=clk;

data_out : PROCESS (clk)
	BEGIN
		IF falling_edge(clk) THEN
		
		--clkb <= not clkb;							-- Clock logic
		--	bclk<= clkb;
			
			--if clkb ='0' then							--The Master does most of the work on the falling edge
			if cnt < DATA_WIDTH then
			if lr ='1' then					--Write from the active buffer 
				DOut <= buff_In_L(DATA_WIDTH - 1-cnt);
			else
				DOut <= buff_In_R(DATA_WIDTH - 1-cnt);
			end if;
			
			end if;
			
			if cnt +1 >= DATA_WIDTH then	--Change channel
				ws <= not lr;
				lr <= not lr;
						
			end if;
			
		
		END IF;
		
	END PROCESS;
	
	data_out_cnt : PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
		
		--clkb <= not clkb;							-- Clock logic
		--	bclk<= clkb;
			
			
			
			cnt<=cnt+1;
			
			
			
			if cnt +1 >= DATA_WIDTH then	--Change channel

				cnt <= 0;				
			end if;
			
			
			if (int_L='1') and(cnt=datA_WIDTH-1) then 						--Update the word that is ready
				buff_In_L<=DIn_L;
				intr_L <='1';
			elsif (int_R = '1') and(cnt=datA_WIDTH-1) then
				buff_In_R<=DIn_R;
				intr_R <='1';
			end if;
			
			if (int_L='0') then 						--Update the word that is ready
				intr_L <='0';
			end if;
			if (int_R = '0') then
				intr_R <='0';
			end if;
			--end if;
		
		END IF;
		
	END PROCESS;

END i2sDriverOut;