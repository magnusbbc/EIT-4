LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CPU_V1_TB IS
END CPU_V1_TB;

ARCHITECTURE Behavioral OF CPU_V1_TB IS

	SIGNAL btn : std_logic_vector(2 DOWNTO 0);
	SIGNAL sseg : std_logic_vector(31 DOWNTO 0);
	SIGNAL led : std_logic_vector(9 DOWNTO 0);
	--Clock Constants
	CONSTANT TbPeriod : TIME := 10 ns;
	SIGNAL TbClock : std_logic := '0';
	SIGNAL TbSimEnded : std_logic := '0';
	SIGNAL cnt : INTEGER := 0;
BEGIN
	MAIN : ENTITY work.MASTER(Behavioral)
		PORT MAP(clk => TbClock, btn => btn, sseg => sseg, led => led); -- Map all signals to the original code
 
		-- Clock generation
		TbClock <= NOT TbClock AFTER TbPeriod/2 WHEN TbSimEnded /= '1' ELSE '0';

 
		stim_proc : PROCESS (TbClock)
		BEGIN
			IF (rising_edge(TbClock)) THEN -- start when Test bench clock goes 1
				cnt <= cnt + 1;
				IF (cnt = 10) THEN
					TbSimEnded <= '1';
				END IF;
			END IF;
		END PROCESS;
END Behavioral;