#include "Config.hvhd"
--------------------------------------------------------------------------------------
--Engineer: Jakob Thomsen, Mikkel Hardysoe, Magnus Christensen
--Module Name: (Data) Memory
--
--Description:
--
--
--
--------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Memory IS
	PORT
	(
		data_in      : IN STD_LOGIC_VECTOR (WORD_SIZE DOWNTO 0); --Data in
		DO           : OUT STD_LOGIC_VECTOR (WORD_SIZE DOWNTO 0) := (OTHERS => '0'); --Data Out
		address      : IN STD_LOGIC_VECTOR (WORD_SIZE DOWNTO 0); --address bus
		write_enable : IN STD_LOGIC; -- Write Enable
		read_enable  : IN STD_LOGIC; -- Read Enable
		CLK          : IN STD_LOGIC -- Clock
	);

END Memory;

ARCHITECTURE falling OF Memory IS

	TYPE ram_type IS ARRAY (WORD_COUNT DOWNTO 0) OF std_logic_vector(WORD_SIZE DOWNTO 0); -- Total 516k memory bits 8k*32 = 256k we use 50% for DataMemory and 50% for ProgramMemory
	SIGNAL RAM : ram_type := (OTHERS => x"0000");
BEGIN
	
	--------------------------------------------
	-- MemoryReadWrite:
	-- Reads and writes data from the data RAM
	--------------------------------------------
	MemoryReadWrite : PROCESS (CLK)
	BEGIN
		IF (falling_edge(CLK)) THEN -- Start when the clock rises
			IF write_enable = '1' THEN -- Write enable
				RAM(to_integer(unsigned(address))) <= data_in; --write Data In bus into RAM array at position address
			END IF;
			IF read_enable = '1' THEN -- Read enable
				DO <= RAM(to_integer(unsigned(address))); -- writes RAM array at the address position into Data Out bus.
			END IF;
			IF write_enable = '0' AND read_enable = '0' THEN --if not writing or reading set all to high impedance to make sure nothing unintended happens
				DO <= (OTHERS => 'Z');
			END IF;
		END IF;
	END PROCESS;
END falling;