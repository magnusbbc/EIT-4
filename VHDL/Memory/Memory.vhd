library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_arith.all;

entity Memory is
	 generic (
			WORD_SIZE : integer := 15; -- this is Word Size minus 1
			ADDR_SIZE : integer := 15; -- this is Address minus 1
			WORD_COUNT : integer := 1023 -- this is the Word count minus 1
	 );
    Port ( DI : in  STD_LOGIC_VECTOR (WORD_SIZE downto 0); --Data in
			  DO : out  STD_LOGIC_VECTOR (WORD_SIZE downto 0); --Data Out
           Address : in  STD_LOGIC_VECTOR (ADDR_SIZE downto 0); --Address bus
           WE : in  STD_LOGIC; -- Write Enable
           RE : in  STD_LOGIC; -- Read Enable
			  CLK : in  STD_LOGIC -- Clock
           );
			 
end Memory;

architecture rising of Memory is

	type ram_type is array (WORD_COUNT downto 0) of std_logic_vector(WORD_SIZE downto 0); -- Total 516k memory bits 8k*32 = 256k we use 50% for DataMemory and 50% for ProgramMemory
	signal RAM: ram_type;
	attribute ram_init_file : string;
	attribute ram_init_file of RAM : signal is "CPU_V1.mif";
	--(* RAM = "CPU_V1.mif" *) reg [31:0] CPU_V1[1024];
	
Begin
process(CLK) -- Memory only works with a clock...
begin
	IF(rising_edge(CLK)) THEN -- Start when the clock rises
				if WE = '1' then -- Write enable
					RAM(conv_integer(address)) <= DI; --write Data In bus into RAM array at position Address
				end if;
				if RE = '1' then -- Read enable
					DO <= RAM(conv_integer(address)); -- writes RAM array at the address position into Data Out bus.
				end if;
					if WE = '0' AND RE = '0' then --if not writing or reading set all to high impedance to make sure nothing unintended happens
				DO <= (others => 'Z');
			end if;
	END IF;
		End process;
end rising;

architecture falling of Memory is

	type ram_type is array (WORD_COUNT downto 0) of std_logic_vector(WORD_SIZE downto 0); -- Total 516k memory bits 8k*32 = 256k we use 50% for DataMemory and 50% for ProgramMemory
	signal RAM: ram_type := (others => x"0000");
	
	
Begin
process(CLK) -- Memory only works with a clock...
begin
	IF(falling_edge(CLK)) THEN -- Start when the clock rises
				if WE = '1' then -- Write enable
					RAM(conv_integer(address)) <= DI; --write Data In bus into RAM array at position Address
				end if;
				if RE = '1' then -- Read enable
					DO <= RAM(conv_integer(address)); -- writes RAM array at the address position into Data Out bus.
				end if;
					if WE = '0' AND RE = '0' then --if not writing or reading set all to high impedance to make sure nothing unintended happens
				DO <= (others => 'Z');
			end if;
	END IF;
		End process;
end falling;

