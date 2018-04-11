Library IEEE;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_unsigned.ALL; 

ENTITY MemoryController IS
	generic (
			WORD_SIZE : integer := 15; -- this is Word Size minus 1
			ADDR_SIZE : integer := 15; -- this is Address minus 1
			WORD_COUNT : integer := 1023 -- this is the Word count minus 1
	 );
	PORT
	(
	WE	:	IN	STD_LOGIC;
	RE :	IN	STD_LOGIC;
	Address :	IN STD_LOGIC_vector (15 DOWNTO 0);
	DI	: IN	STD_LOGIC_vector (15 DOWNTO 0);
	DO	: buffer STD_LOGIC_vector (15 DOWNTO 0);
	CLK : IN  STD_LOGIC;
	btn : in std_LOGIC_vector(2 downto 0);
	ss : out std_LOGIC_vector(31 downto 0)
	 );
END MemoryController;

ARCHITECTURE Behavioral OF MemoryController IS
--	type ram_type is array (0 downto 0) of std_logic_vector(5 downto 0);
--	signal Buff: RAM_type;
	signal ssreg_data, ssreg_config, btnreg_data, memreg_dataI, memreg_dataO : std_LOGIC_vector(15 downto 0);
	signal SevenSegOut : std_logic_vector(31 downto 0);
	signal dAddress : std_logic_vector(15 downto 0);
Begin

Sevensegdriver : entity work.ssgddriver
	port map(
		dat => ssreg_data,
		clr => ssreg_config(5),
		bcdenable => ssreg_config(4),
		dots => ssreg_config(3 downto 0),
		sseg => SevenSegOut
	);

ButtonDriver : entity work.btndriver
	port map(
	dbtn => btnreg_data(2 downto 0),
	clk => clk,
	clr => '0',
	btn => btn
	);
	
MemoryDriver : entity work.Memory
	port map(
	DI => memreg_dataI,
	DO => memreg_dataO,
	clk => clk,
	WE => WE,
	RE => RE,
	Address => dAddress
	);
	
	

process(CLK) IS
Begin
  IF(falling_edge(CLK)) THEN


	IF (Address = 65000 AND WE = '1') THEN -- sevensegdriver data
		ssreg_data <= DI;
	
	ELSIF (Address = 65001 AND WE = '1') THEN -- Sevensegdriver control
		ssreg_config <= DI;

	ELSIF (Address = 65002 AND RE = '1') THEN -- ButtonDriver Data
		DO <= btnreg_data;
	
	Else -- memory 
		if (WE = '1' AND Address < 1023) then
			memreg_dataI <= DI;
			dAddress <= Address;
		elsif (RE = '1' AND Address < 1023) then
			DO <= memreg_dataO;
			dAddress <= Address;
		end if;
	
	END IF;
END IF;

ss <= SevenSegOut;

END process;
END Behavioral;