LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CPU_V1_TB IS
END CPU_V1_TB;

ARCHITECTURE Behavioral OF CPU_V1_TB IS
	--Clock Constants
	constant TbPeriod : time := 10 ns;
   signal TbClock : std_logic := '0';
   signal TbSimEnded : std_logic := '0';
	signal cnt : integer := 0;

BEGIN
	MAIN : ENTITY work.MASTER(Behavioral) PORT MAP(clk => TbClock); -- Map all signals to the original code
	
	-- Clock generation
   TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

	
stim_proc:process(TbClock)
		begin
			IF(rising_edge(TbClock)) THEN -- start when Test bench clock goes 1
				cnt <= cnt+1;
				IF(cnt = 5) THEN
					TbSimEnded <= '1';
				END IF;
			END IF;
	end process; 
END Behavioral;