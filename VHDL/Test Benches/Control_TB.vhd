LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Control_TB IS
END Control_TB;

ARCHITECTURE Behavioral OF Control_TB IS
	 
	SIGNAL MO : std_logic_vector(15 downto 0);
	
	--Clock Constants
	constant TbPeriod : time := 10 ns;
   signal TbClock : std_logic := '0';
   signal TbSimEnded : std_logic := '0';
	signal cnt : integer := 0;
BEGIN
	MAIN : ENTITY work.Master(Behavioral) PORT MAP(clk=>TbClock, PDO => MO);
	
	-- Clock generation
   TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

	
stim_proc:process(TbClock)
		begin
			IF(rising_edge(TbClock)) THEN
			cnt<=cnt+1;
				IF(cnt = 8) THEN
						TbSimEnded <= '1';
						--wait;
				END IF; 
			END IF;
	end process; 
END Behavioral;