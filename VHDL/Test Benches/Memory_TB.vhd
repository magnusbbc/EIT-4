LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Memory_TB IS
END Memory_TB;

ARCHITECTURE Behavioral OF Memory_TB IS

	signal DI : STD_LOGIC_VECTOR (15 downto 0);
	signal DO : STD_LOGIC_VECTOR (15 downto 0);
   signal Address : STD_LOGIC_VECTOR (9 downto 0);
   signal EN : STD_LOGIC;
   signal RW : STD_LOGIC := '0';
	
	--Clock Constants
	constant TbPeriod : time := 10 ns;
   signal TbClock : std_logic := '0';
   signal TbSimEnded : std_logic := '0';
	signal cnt : integer := 0;
	signal scnt : integer := 0;
BEGIN
	MEM : ENTITY work.Memory(Behavioral) PORT MAP(DI=> DI, DO => DO, Address => Address, EN => EN, RW => RW, clk => TbClock);
	
	-- Clock generation
   TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

	
stim_proc:process(TbClock)
		begin
			IF(rising_edge(TbClock)) THEN
				IF(RW = '0') THEN
					Address <= STD_LOGIC_VECTOR (TO_unsigned(scnt,Address'length));
					DI <= STD_LOGIC_VECTOR (TO_unsigned(scnt,DI'length));
					EN <= '1';
					scnt <= scnt+1;
					
					IF(scnt = 4) THEN
						RW <= '1';
						scnt <= 0;
					END IF;
				END IF;
				
				IF(RW = '1') THEN
				Address <= STD_LOGIC_VECTOR (TO_unsigned(scnt,Address'length));
				EN <= '1';
				scnt <= scnt+1;
				IF(scnt = 4) THEN
						RW <= '0';
						scnt <= 0;
					END IF;
				END IF;
				
				cnt<=cnt+1;
				IF(cnt = 8) THEN
						TbSimEnded <= '1';
						--wait;
				END IF; 
			END IF;
	end process; 
END Behavioral;