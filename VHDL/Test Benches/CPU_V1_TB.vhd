LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CPU_V1_TB IS
END CPU_V1_TB;

ARCHITECTURE Behavioral OF CPU_V1_TB IS

	SIGNAL btn : std_logic_vector(2 DOWNTO 0);
	SIGNAL sseg : std_logic_vector(31 DOWNTO 0);
	SIGNAL led : std_logic_vector(9 DOWNTO 0);
	SIGNAL wsIn : std_logic := '0';
	SIGNAL I2SDataIn : std_logic;
	--Clock Constants
	CONSTANT TbPeriod : TIME := 10 ns;
	SIGNAL TbClock : std_logic := '0';
	SIGNAL TbSimEnded : std_logic := '0';
	SIGNAL cnt : INTEGER := 0;

	CONSTANT TbPeriodI2S : TIME := 100 ns;
	SIGNAL TbClockI2S : std_logic := '0';
	SIGNAL I2SCnt : INTEGER := 0;
BEGIN
	MAIN : ENTITY work.MASTER(Behavioral)
		PORT MAP(
		clk => TbClock,
		btn => btn,
		sseg => sseg,
		led => led,
		bclk => TbClockI2S,
		ws => wsIn, 
		Din => I2SDataIn
		); -- Map all signals to the original code
 
		-- Clock generation
		TbClock <= NOT TbClock AFTER TbPeriod/2 WHEN TbSimEnded /= '1' ELSE '0';
		TbClockI2S <= NOT TbClockI2S AFTER TbPeriodI2S/2 WHEN TbSimEnded /= '1' ELSE '0';

		stim_proc : PROCESS (TbClock)
		BEGIN
			IF (rising_edge(TbClock)) THEN -- start when Test bench clock goes 1
				cnt <= cnt + 1;
				IF (cnt = 5120) THEN
					TbSimEnded <= '1';
				END IF;
			END IF;
		END PROCESS;

		Process (TbClockI2S)
		Begin
			IF(rising_edge(TbClockI2S)) THEN
				IF ((I2SCnt/16) MOD 2 = 1) THEN
					I2SDataIn <= '0';
					wsIn <= '0';
				ELSE
					I2SDataIn <= '1';
					wsIn <= '1';
				END IF;
				I2SCnt <= I2SCnt+1;
			END IF;
		END PROCESS;

		PROCESS
		BEGIN
			btn <= "111";
			WAIT FOR 1000 ns;
			btn <= "110";
			WAIT FOR 1000 ns;
			btn <= "111";
			WAIT FOR 1000 ns;
			btn <= "110";
			WAIT FOR 100000 ns;
		END PROCESS;

		PROCESS (TbSimEnded)
		BEGIN
			IF(TbSimEnded = '1') THEN
				ASSERT false
					REPORT "I've finished"
					SEVERITY failure;
			END IF;
		END PROCESS;
END Behavioral;