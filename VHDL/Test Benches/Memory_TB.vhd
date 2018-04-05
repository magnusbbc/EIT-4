LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Memory_TB IS
generic (
			WORD_SIZE : integer := 31;
			ADDR_SIZE : integer := 12;
			WORD_COUNT : integer := 10
	 );
END Memory_TB;

ARCHITECTURE Behavioral OF Memory_TB IS

	signal DI : STD_LOGIC_VECTOR (WORD_SIZE downto 0);
	signal DO : STD_LOGIC_VECTOR (WORD_SIZE downto 0);
   signal Address : STD_LOGIC_VECTOR (ADDR_SIZE downto 0);
   signal WE : STD_LOGIC := '1';
   signal RE : STD_LOGIC;
	
	--Clock Constants
	constant TbPeriod : time := 10 ns;
   signal TbClock : std_logic := '0';
   signal TbSimEnded : std_logic := '0';
	signal cnt : integer := 0;
	signal scnt : integer := 0;
	signal zero : integer := 0;

BEGIN
	MEM : ENTITY work.Memory(Behavioral) 	GENERIC MAP(WORD_SIZE => WORD_SIZE ,ADDR_SIZE =>ADDR_SIZE ,WORD_COUNT =>WORD_COUNT) PORT MAP(DI=> DI, DO => DO, Address => Address, WE => WE, RE => RE, CLK => TbClock); -- Map all signals to the original code
	
	-- Clock generation
   TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

	
stim_proc:process(TbClock)
		begin
			IF(rising_edge(TbClock)) THEN -- start when Test bench clock goes 1
				IF(WE = '1') THEN -- Write enable the first "IF-function" is writing the scnt value into the scnt address and continues until this is done 4 times
					Address <= STD_LOGIC_VECTOR (TO_unsigned(scnt,Address'length)); -- scnt interger changes into binary and goes into Address bus
					DI <= STD_LOGIC_VECTOR (TO_unsigned(scnt,DI'length)); -- scnt interger changes into binary and goes into Data in bus
					scnt <= scnt+1; -- increments scnt by 1 to make it do this function 4 times
					
					IF(scnt = 4) THEN -- after 4 times the program starts to go into Read Enable mode and shuts off Write enable
						RE <= '1';
						WE <= '0';
						Address <= STD_LOGIC_VECTOR (TO_unsigned(zero,Address'length)); -- We want the Scnt to be 0 but the program is parallel so we need to brute force it to be 0
						scnt <= 1; -- again The program is parallel so the reason for scnt to be 1 instead of 0 is because the next time scnt is loaded ** we want it to be incremented instead of just 0 again. 
					END IF;
				END IF;
				
				IF(RE = '1') THEN -- here we start the "Read-function" which Reads at the given address which is controlled by the scnt. So it reads from 1 to 4 in binary.
				Address <= STD_LOGIC_VECTOR (TO_unsigned(scnt,Address'length)); -- This is the next time scnt is loaded ** and since again the program is parallel, scnt is loaded into the address and in the next line it's incremented but it happens both at the same time.
				scnt <= scnt+1; -- increments scnt
				END IF;
				
				cnt<=cnt+1; -- every run through the counter "cnt" is incremented and after 8 loops of the program this function is set to freeze the program.
				IF(cnt = 8) THEN
						TbSimEnded <= '1'; -- freeze (wait) program.
				END IF; 
			END IF;
	end process; 
END Behavioral;