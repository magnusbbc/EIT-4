LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_unsigned.ALL; 
USE IEEE.NUMERIC_STD.ALL; 
USE IEEE.std_logic_arith.all;
 
--Seven segment display driver 
--This driver is for a 4 panel sevensegment display with all segments directly connected 
 
ENTITY ssgddriver IS 
  PORT  
  ( 
    clr       : IN STD_LOGIC;                  --Clear 
    bcdenable : IN std_LOGIC := '1';                          --Enable BCD format 
    dat       : IN STD_LOGIC_vector (15 DOWNTO 0);     --Hex data in 4 nibbles 
    dots      : IN STD_LOGIC_vector (3 DOWNTO 0);      --Dots data 
    sseg      : OUT STD_LOGIC_vector (31 DOWNTO 0)     --Segments connections (31| dot4 - 7seg4 - dot3 - 7seg3 - dot2 - 7seg2 - dot1 - 7seg1 |0) 
  ); 
END ssgddriver; 
 
ARCHITECTURE Behavioral OF ssgddriver IS 
 
  COMPONENT b2bcd IS                        --When input is changed the output is set to the BCD format using the 'shift and add 3' algorithm 
    PORT  
    ( 
      clr    : IN std_logic;                  --Clear 
      binary : IN std_logic_vector (15 DOWNTO 0);    --Binary data in 
      bcd    : OUT std_logic_vector (15 DOWNTO 0)    --BCD formatet output 
    ); 
  END COMPONENT; 
 
  SIGNAL bcd     : std_logic_vector (15 DOWNTO 0); 
  SIGNAL display : std_logic_vector (15 DOWNTO 0); 
 
BEGIN 
  con : COMPONENT b2bcd 
  PORT MAP 
  ( 
    clr    => clr,  
    binary => dat,  
    bcd    => bcd 
  ); 
  
  display <=  
    bcd WHEN bcdenable = '1' ELSE 
    dat; 
  
    --first display 
    sseg(7) <= dots(0); 
    sseg(6 DOWNTO 0) <=
    "1000000" WHEN display(3 DOWNTO 0) = "0000" ELSE
    "1111001" WHEN display(3 DOWNTO 0) = "0001" ELSE 
    "0100100" WHEN display(3 DOWNTO 0) = "0010" ELSE 
    "0110000" WHEN display(3 DOWNTO 0) = "0011" ELSE 
    "0011001" WHEN display(3 DOWNTO 0) = "0100" ELSE 
    "0010010" WHEN display(3 DOWNTO 0) = "0101" ELSE 
    "0000010" WHEN display(3 DOWNTO 0) = "0110" ELSE 
    "1111000" WHEN display(3 DOWNTO 0) = "0111" ELSE 
    "0000000" WHEN display(3 DOWNTO 0) = "1000" ELSE 
    "0010000" WHEN display(3 DOWNTO 0) = "1001" ELSE 
    "0001000" WHEN display(3 DOWNTO 0) = "1010" ELSE 
    "0000011" WHEN display(3 DOWNTO 0) = "1011" ELSE 
    "1000110" WHEN display(3 DOWNTO 0) = "1100" ELSE 
    "0100001" WHEN display(3 DOWNTO 0) = "1101" ELSE 
    "0000110" WHEN display(3 DOWNTO 0) = "1110" ELSE 
    "0001110" WHEN display(3 DOWNTO 0) = "1111"; 
    -- Second display 
    sseg(15) <= dots(1); 
    sseg(14 DOWNTO 8) <=
	 
    "1000000" WHEN display(7 DOWNTO 4) = "0000" ELSE 
    "1111001" WHEN display(7 DOWNTO 4) = "0001" ELSE 
    "0100100" WHEN display(7 DOWNTO 4) = "0010" ELSE 
    "0110000" WHEN display(7 DOWNTO 4) = "0011" ELSE 
    "0011001" WHEN display(7 DOWNTO 4) = "0100" ELSE 
    "0010010" WHEN display(7 DOWNTO 4) = "0101" ELSE 
    "0000010" WHEN display(7 DOWNTO 4) = "0110" ELSE 
    "1111000" WHEN display(7 DOWNTO 4) = "0111" ELSE 
    "0000000" WHEN display(7 DOWNTO 4) = "1000" ELSE 
    "0010000" WHEN display(7 DOWNTO 4) = "1001" ELSE 
    "0001000" WHEN display(7 DOWNTO 4) = "1010" ELSE 
    "0000011" WHEN display(7 DOWNTO 4) = "1011" ELSE 
    "1000110" WHEN display(7 DOWNTO 4) = "1100" ELSE 
    "0100001" WHEN display(7 DOWNTO 4) = "1101" ELSE 
    "0000110" WHEN display(7 DOWNTO 4) = "1110" ELSE 
    "0001110" WHEN display(7 DOWNTO 4) = "1111"; 
  
    -- Second display 
    sseg(23) <= dots(2); 
    sseg(22 DOWNTO 16) <=
    "1000000" WHEN display(11 DOWNTO 8) = "0000" ELSE 
    "1111001" WHEN display(11 DOWNTO 8) = "0001" ELSE 
    "0100100" WHEN display(11 DOWNTO 8) = "0010" ELSE 
    "0110000" WHEN display(11 DOWNTO 8) = "0011" ELSE 
    "0011001" WHEN display(11 DOWNTO 8) = "0100" ELSE 
    "0010010" WHEN display(11 DOWNTO 8) = "0101" ELSE 
    "0000010" WHEN display(11 DOWNTO 8) = "0110" ELSE 
    "1111000" WHEN display(11 DOWNTO 8) = "0111" ELSE 
    "0000000" WHEN display(11 DOWNTO 8) = "1000" ELSE 
    "0010000" WHEN display(11 DOWNTO 8) = "1001" ELSE 
    "0001000" WHEN display(11 DOWNTO 8) = "1010" ELSE 
    "0000011" WHEN display(11 DOWNTO 8) = "1011" ELSE 
    "1000110" WHEN display(11 DOWNTO 8) = "1100" ELSE 
    "0100001" WHEN display(11 DOWNTO 8) = "1101" ELSE 
    "0000110" WHEN display(11 DOWNTO 8) = "1110" ELSE 
    "0001110" WHEN display(11 DOWNTO 8) = "1111"; 
  
    -- Second display 
    sseg(31) <= dots(2); 
    sseg(30 DOWNTO 24) <=
    "1000000" WHEN display(15 DOWNTO 12) = "0000" ELSE 
    "1111001" WHEN display(15 DOWNTO 12) = "0001" ELSE 
    "0100100" WHEN display(15 DOWNTO 12) = "0010" ELSE 
    "0110000" WHEN display(15 DOWNTO 12) = "0011" ELSE 
    "0011001" WHEN display(15 DOWNTO 12) = "0100" ELSE 
    "0010010" WHEN display(15 DOWNTO 12) = "0101" ELSE 
    "0000010" WHEN display(15 DOWNTO 12) = "0110" ELSE 
    "1111000" WHEN display(15 DOWNTO 12) = "0111" ELSE 
    "0000000" WHEN display(15 DOWNTO 12) = "1000" ELSE 
    "0010000" WHEN display(15 DOWNTO 12) = "1001" ELSE 
    "0001000" WHEN display(15 DOWNTO 12) = "1010" ELSE 
    "0000011" WHEN display(15 DOWNTO 12) = "1011" ELSE 
    "1000110" WHEN display(15 DOWNTO 12) = "1100" ELSE 
    "0100001" WHEN display(15 DOWNTO 12) = "1101" ELSE 
    "0000110" WHEN display(15 DOWNTO 12) = "1110" ELSE 
    "0001110" WHEN display(15 DOWNTO 12) = "1111"; 
 
END Behavioral;