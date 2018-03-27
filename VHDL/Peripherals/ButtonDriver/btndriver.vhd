library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity btndriver is
    Port ( clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           btn : in  STD_LOGIC_vector (2 downto 0);
           dbtn : out  STD_LOGIC_vector (2 downto 0)
			  );
end btndriver;

architecture Behavioral of btndriver is
signal Q0, Q1, Q2 : std_logic_vector (2 downto 0); -- Debounce registers


				
begin

process(clk)
begin
   if (clk'event and clk = '1') then
       if ( clr = '1') then
         Q0<= (others => '0');
			Q1<= (others => '0');
			Q2<= (others => '0');
			
       else
         Q0(2) <= btn(0);
         Q0(1 downto 0) <= Q0(2 downto 1);
			 Q1(2) <= btn(1);
         Q1(1 downto 0) <= Q1(2 downto 1);
			 Q2(2) <= btn(2);
         Q2(1 downto 0) <= Q2(2 downto 1);
			
        
      end if;
   end if;
end process;
 
dbtn(0) <= Q0(1) and Q0(2) and Q0(0);
dbtn(1) <= Q1(1) and Q1(2) and Q1(0);
dbtn(2) <= Q2(1) and Q2(2) and Q2(0);




end Behavioral;