library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity clkdiv is
generic (N : integer := 8);
    Port (
				clk 		: in  STD_LOGIC;
				clr 		: in STD_LOGIC;
				mclk	 	: out  STD_LOGIC
				);
end clkdiv;

architecture clkdiv of clkdiv is
signal q : std_logic_vector (N-1 downto 0);
begin
--clock divider
	process(clk, clr)
	begin
	if clr = '1' then
		q <= (others => '0');
	elsif clk'event and clk = '1' then
		q <= q + 1;
	end if;
	end process;
	mclk <= q(n-1);
	
	
end clkdiv;



