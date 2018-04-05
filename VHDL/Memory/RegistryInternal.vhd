library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--use IEEE.std_logic_arith.all;

entity RegistryInternal is
	port (
		readOne : in std_logic_vector(4 downto 0);
		readTwo : in std_logic_vector(4 downto 0);
		
		WriteOne : in std_logic_vector(4 downto 0);
		WriteTwo : in std_logic_vector(4 downto 0);
		
		dataInOne : in std_logic_vector(15 downto 0);
		dataInTwo : in std_logic_vector(15 downto 0);
		
		dataOutOne : out std_logic_vector(15 downto 0);
		dataOutTwo : out std_logic_vector(15 downto 0);
		
		pcIn : in std_logic_vector(15 downto 0);
		
		WR1_E : in std_logic;
		WR2_E : in std_logic
	);

end RegistryInternal;

architecture Behavioral of RegistryInternal is

type register_type is array (31 downto 0) of std_logic_vector(15 downto 0);
signal REG: register_type;


begin

RegProc: process (readOne, readTwo, writeOne, writeTwo) is

begin
		if conv_integer(readOne) = 32 then --pc to outOne
			dataOutOne <= pcIn;
		else
			dataOutOne <= REG(conv_integer(readOne));
		end if;

		if conv_integer(readTwo) = 32 then --pc to outTwo
			dataOutTwo <= pcIn;
		else
			dataOutTwo <= REG(conv_integer(readTwo));
		end if;		
		
		if(WR1_E = '1') THEN
		REG(conv_integer(writeOne)) <= dataInOne;
		END IF;
		
		if(WR2_E = '1') THEN
		REG(conv_integer(writeTwo)) <= dataInTwo;
		END IF;
		
end process;

end Behavioral;