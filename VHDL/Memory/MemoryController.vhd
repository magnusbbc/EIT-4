LIBRARY IEEE;
USE IEEE.std_logic_arith.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;

ENTITY MemoryController IS
	GENERIC (
		WORD_SIZE : INTEGER := 15; -- this is Word Size minus 1
		ADDR_SIZE : INTEGER := 15; -- this is Address minus 1
		WORD_COUNT : INTEGER := 1023 -- this is the Word count minus 1
	);
	PORT (
		WE : IN STD_LOGIC;
		RE : IN STD_LOGIC;
		Address : IN STD_LOGIC_vector (15 DOWNTO 0);
		DI : IN STD_LOGIC_vector (15 DOWNTO 0);
		DO : BUFFER STD_LOGIC_vector (15 DOWNTO 0);
		CLK : IN STD_LOGIC;
		btn : IN std_LOGIC_vector(2 DOWNTO 0);
		ss : OUT std_LOGIC_vector(31 DOWNTO 0)
	);
END MemoryController;

ARCHITECTURE Behavioral OF MemoryController IS
	--	type ram_type is array (0 downto 0) of std_logic_vector(5 downto 0);
	--	signal Buff: RAM_type;
	SIGNAL ssreg_data, ssreg_config, btnreg_data, memreg_dataI, memreg_dataO : std_LOGIC_vector(15 DOWNTO 0);
	SIGNAL SevenSegOut : std_logic_vector(31 DOWNTO 0);
	SIGNAL dAddress : std_logic_vector(15 DOWNTO 0);
BEGIN

	Sevensegdriver : ENTITY work.ssgddriver
		PORT MAP(
			dat => ssreg_data,
			clr => ssreg_config(5),
			bcdenable => ssreg_config(4),
			dots => ssreg_config(3 DOWNTO 0),
			sseg => SevenSegOut
		);

	ButtonDriver : ENTITY work.btndriver
		PORT MAP(
			dbtn => btnreg_data(2 DOWNTO 0),
			clk => clk,
			clr => '0',
			btn => btn
		);

	MemoryDriver : ENTITY work.Memory
		PORT MAP(
			DI => memreg_dataI,
			DO => memreg_dataO,
			clk => clk,
			WE => WE,
			RE => RE,
			Address => dAddress
		);

	PROCESS (CLK) IS
	BEGIN
		IF (falling_edge(CLK)) THEN
			IF (Address = 65000 AND WE = '1') THEN -- sevensegdriver data
				ssreg_data <= DI;

			ELSIF (Address = 65001 AND WE = '1') THEN -- Sevensegdriver control
				ssreg_config <= DI;

			ELSIF (Address = 65002 AND RE = '1') THEN -- ButtonDriver Data
				DO <= btnreg_data;

			ELSE -- memory 
				IF (WE = '1' AND Address < 1023) THEN
					memreg_dataI <= DI;
					dAddress <= Address;
				ELSIF (RE = '1' AND Address < 1023) THEN
					DO <= memreg_dataO;
					dAddress <= Address;
				END IF;

			END IF;
		END IF;

		ss <= SevenSegOut;

	END PROCESS;
END Behavioral;