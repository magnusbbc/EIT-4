#include "Config.hvhd"
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_arith.ALL;

ENTITY Memory IS
	PORT (
		DI : IN STD_LOGIC_VECTOR (WORD_SIZE DOWNTO 0); --Data in
		DO : OUT STD_LOGIC_VECTOR (WORD_SIZE DOWNTO 0) := x"0000"; --Data Out
		Address : IN STD_LOGIC_VECTOR (WORD_SIZE DOWNTO 0); --Address bus
		WE : IN STD_LOGIC; -- Write Enable
		RE : IN STD_LOGIC; -- Read Enable
		CLK : IN STD_LOGIC -- Clock
	);

END Memory;

ARCHITECTURE rising OF Memory IS

	TYPE ram_type IS ARRAY (WORD_COUNT DOWNTO 0) OF std_logic_vector(WORD_SIZE DOWNTO 0); -- Total 516k memory bits 8k*32 = 256k we use 50% for DataMemory and 50% for ProgramMemory
	SIGNAL RAM : ram_type;
	ATTRIBUTE ram_init_file : STRING;
	ATTRIBUTE ram_init_file OF RAM : SIGNAL IS "CPU_V1.mif";
	--(* RAM = "CPU_V1.mif" *) reg [31:0] CPU_V1[1024];

BEGIN
	PROCESS (CLK) -- Memory only works with a clock...
	BEGIN
		IF (rising_edge(CLK)) THEN -- Start when the clock rises
			IF WE = '1' THEN -- Write enable
				RAM(conv_integer(address)) <= DI; --write Data In bus into RAM array at position Address
			END IF;
			IF RE = '1' THEN -- Read enable
				DO <= RAM(conv_integer(address)); -- writes RAM array at the address position into Data Out bus.
			END IF;
			IF WE = '0' AND RE = '0' THEN --if not writing or reading set all to high impedance to make sure nothing unintended happens
				DO <= (OTHERS => 'Z');
			END IF;
		END IF;
	END PROCESS;
END rising;

ARCHITECTURE falling OF Memory IS

	TYPE ram_type IS ARRAY (WORD_COUNT DOWNTO 0) OF std_logic_vector(WORD_SIZE DOWNTO 0); -- Total 516k memory bits 8k*32 = 256k we use 50% for DataMemory and 50% for ProgramMemory
	SIGNAL RAM : ram_type := (OTHERS => x"0000");
BEGIN
	PROCESS (CLK) -- Memory only works with a clock...
	BEGIN
		IF (falling_edge(CLK)) THEN -- Start when the clock rises
			IF WE = '1' THEN -- Write enable
				RAM(conv_integer(address)) <= DI; --write Data In bus into RAM array at position Address
			END IF;
			IF RE = '1' THEN -- Read enable
				DO <= RAM(conv_integer(address)); -- writes RAM array at the address position into Data Out bus.
			END IF;
			IF WE = '0' AND RE = '0' THEN --if not writing or reading set all to high impedance to make sure nothing unintended happens
				DO <= (OTHERS => 'Z');
			END IF;
		END IF;
	END PROCESS;
END falling;