library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

--THIS IS A COMMENT

entity ssgddriver is
    Port ( clk 		: in  STD_LOGIC;
           clr 		: in  STD_LOGIC;
			  bcdenable	: in std_LOGIC;
           dat			: in  STD_LOGIC_vector	(15 downto 0);
			  dots		: in  STD_LOGIC_vector	(3 downto 0);
           sseg 		: out  STD_LOGIC_vector (31 downto 0)
         
			  );
end ssgddriver;

architecture Behavioral of ssgddriver is

component b2bcd is 
	port(	
			clr 		: in 	std_logic;
			binary 	: in std_logic_vector (15 downto 0);
			bcd		: out std_logic_vector (15 downto 0)
		);
end component;

signal bcd 	: std_logic_vector (15 downto 0);
signal display	: std_logic_vector (15 downto 0);

begin

con : component b2bcd
port map ( 	
				clr 		=> clr,
				binary 	=> dat,
				bcd		=> bcd
			);
			
display<=
		bcd when bcdenable = '1' else
		dat;
		
--first display
sseg(7)<=dots(0);
sseg(6 downto 0)
<= 	"1000000" when display(3 downto 0) = "0000" else 
		"1111001" when display(3 downto 0) = "0001" else 
		"0100100" when display(3 downto 0) = "0010" else 
		"0110000" when display(3 downto 0) = "0011" else
      "0011001" when display(3 downto 0) = "0100" else
      "0010010" when display(3 downto 0) = "0101" else
		"0000010" when display(3 downto 0) = "0110" else
		"1111000" when display(3 downto 0) = "0111" else
		"0000000" when display(3 downto 0) = "1000" else
		"0010000" when display(3 downto 0) = "1001" else
		"0001000" when display(3 downto 0) = "1010" else
		"0000011" when display(3 downto 0) = "1011" else
		"1000110" when display(3 downto 0) = "1100" else
		"0100001" when display(3 downto 0) = "1101" else
		"0000110" when display(3 downto 0) = "1110" else
		"0001110" when display(3 downto 0) = "1111";
-- Second display
sseg(15)<=dots(1);
sseg(14 downto 8)
<= 	"1000000" when display(7 downto 4) = "0000" else 
		"1111001" when display(7 downto 4) = "0001" else 
		"0100100" when display(7 downto 4) = "0010" else 
		"0110000" when display(7 downto 4) = "0011" else
      "0011001" when display(7 downto 4) = "0100" else
      "0010010" when display(7 downto 4) = "0101" else
		"0000010" when display(7 downto 4) = "0110" else
		"1111000" when display(7 downto 4) = "0111" else
		"0000000" when display(7 downto 4) = "1000" else
		"0010000" when display(7 downto 4) = "1001" else
		"0001000" when display(7 downto 4) = "1010" else
		"0000011" when display(7 downto 4) = "1011" else
		"1000110" when display(7 downto 4) = "1100" else
		"0100001" when display(7 downto 4) = "1101" else
		"0000110" when display(7 downto 4) = "1110" else
		"0001110" when display(7 downto 4) = "1111";
		
-- Second display
sseg(23)<=dots(2);
sseg(22 downto 16)
<= 	"1000000" when display(11 downto 8) = "0000" else 
		"1111001" when display(11 downto 8) = "0001" else 
		"0100100" when display(11 downto 8) = "0010" else 
		"0110000" when display(11 downto 8) = "0011" else
      "0011001" when display(11 downto 8) = "0100" else
      "0010010" when display(11 downto 8) = "0101" else
		"0000010" when display(11 downto 8) = "0110" else
		"1111000" when display(11 downto 8) = "0111" else
		"0000000" when display(11 downto 8) = "1000" else
		"0010000" when display(11 downto 8) = "1001" else
		"0001000" when display(11 downto 8) = "1010" else
		"0000011" when display(11 downto 8) = "1011" else
		"1000110" when display(11 downto 8) = "1100" else
		"0100001" when display(11 downto 8) = "1101" else
		"0000110" when display(11 downto 8) = "1110" else
		"0001110" when display(11 downto 8) = "1111";
		
-- Second display
sseg(31)<=dots(2);
sseg(30 downto 24)
<= 	"1000000" when display(15 downto 12) = "0000" else 
		"1111001" when display(15 downto 12) = "0001" else 
		"0100100" when display(15 downto 12) = "0010" else 
		"0110000" when display(15 downto 12) = "0011" else
      "0011001" when display(15 downto 12) = "0100" else
      "0010010" when display(15 downto 12) = "0101" else
		"0000010" when display(15 downto 12) = "0110" else
		"1111000" when display(15 downto 12) = "0111" else
		"0000000" when display(15 downto 12) = "1000" else
		"0010000" when display(15 downto 12) = "1001" else
		"0001000" when display(15 downto 12) = "1010" else
		"0000011" when display(15 downto 12) = "1011" else
		"1000110" when display(15 downto 12) = "1100" else
		"0100001" when display(15 downto 12) = "1101" else
		"0000110" when display(15 downto 12) = "1110" else
		"0001110" when display(15 downto 12) = "1111";



end Behavioral;

