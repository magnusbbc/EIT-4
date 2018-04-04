library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_arith.all;

entity Memory is
    Port ( DI : in  STD_LOGIC_VECTOR (15 downto 0);
			  DO : out  STD_LOGIC_VECTOR (15 downto 0);
           Address : in  STD_LOGIC_VECTOR (9 downto 0);
           EN : in  STD_LOGIC;
           RW : in  STD_LOGIC;
           clk : in  STD_LOGIC
			  );
			 
end Memory;

architecture Behavioral of Memory is

	type ram_type is array (1024 downto 0) of std_logic_vector(15 downto 0);
	signal RAM: ram_type;
	
begin

RamProc: process(clk) is
	
	begin
		if rising_edge(clk) then --clock changes 1 to 0 or 0 to 1 AND is high aka rising edge
			if EN = '1' then --memory is requested - either read or write
				if RW = '0' then --RW is 0 for write
					RAM(conv_integer(address)) <= DI; --write DataIO bus into RAM array at position Address
				end if;
				if RW = '1' then
					DO <= RAM(conv_integer(address));
				end if;
			end if;
					if EN = '0' then
				DO <= (others => 'Z');
			end if;
		end if;	
		
end process;

end Behavioral;

