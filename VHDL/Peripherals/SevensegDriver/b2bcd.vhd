library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity b2bcd is 
	generic (
		bits 		: integer := 16;
		digits 	: integer := 4
);
port(	
		clr 		: in 	std_logic;
		binary 	: in std_logic_vector (15 downto 0);
		bcd		: out std_logic_vector (15 downto 0)
		);
end b2bcd;
architecture a of b2bcd is 
begin
b2bcd : process (binary,clr)
	variable  temp : std_logic_vector(31 downto 0);
	begin
		temp:= x"00000000";
		if  clr= '0' then
			temp(18 downto 3):= binary;
			
			for i in 0 to 12 loop
				if temp(19 downto 16) > 4 then
					temp(19 downto 16) := temp(19 downto 16)+3;
				end if;
				if temp(23 downto 20) > 4 then
					temp(23 downto 20) := temp(23 downto 20)+3;
				end if;
				if temp(27 downto 24) > 4 then
					temp(27 downto 24) := temp(27 downto 24)+3;
				end if;
				if temp(31 downto 28) > 4 then
					temp(31 downto 28) := temp(31 downto 28)+3;
				end if;
				temp(31 downto 1) := temp(30 downto 0);
			end loop;
		end if;
		bcd <= temp(31 downto 16);
	end process b2bcd;
end a;
