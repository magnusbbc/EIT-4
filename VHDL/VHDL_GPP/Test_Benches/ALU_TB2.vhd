LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
ENTITY ALU_TB IS
END ALU_TB;
 
ARCHITECTURE Behavioral OF ALU_TB IS
   
  signal   Operand1    :  std_logic_vector(15 DOWNTO 0); -- Operands 1 and 2
  signal   Operand2    :  std_logic_vector(15 DOWNTO 0); -- Operands 1 and 2  
  signal   Operation   :  std_logic_vector(5 DOWNTO 0);
 
    signal Parity_Flag        :  std_logic; -- Flag raised when a carry is present after adding
    signal Signed_Flag        :  std_logic; -- Flag that does something?
    signal Overflow_Flag      :  std_logic; -- Flag raised when overflow is present
    signal Zero_Flag          :  std_logic; -- Flag raised when operands are equal?
    signal Carry_Flag         :  std_logic; -- Flag raised when operands are carry
--    signal flags          :  std_logic_vector(4 downto 0);
    signal Result             :  std_logic_vector(15 DOWNTO 0);
  
  
  --Clock Constants
  constant TbPeriod : time := 10 ns;
  signal TbClock : std_logic := '0';
  signal TbSimEnded : std_logic := '0';
  signal cnt : integer := 0;
 
BEGIN
  ALU : ENTITY work.My_first_ALU(Behavioral) 
  PORT MAP(
  operand1 => operand1,
  operand2 => operand2,
  operation => operation,
  parity_Flag => parity_Flag,
  signed_Flag => signed_Flag,
  overflow_Flag => overflow_Flag,
  zero_Flag => zero_Flag,
  Carry_Flag => Carry_Flag,
  result => result
--  flags => flags
  );
  
  -- Clock generation
TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
  
stim_proc:process(TbClock)
begin
    operation <= "000010"; 
    IF(rising_edge(TbClock)) THEN
        CASE cnt is 
            when 1 => 
              operand1 <= x"0000";
              operand2 <= x"0000";
              cnt<= cnt+1;          
            when 2 =>
              operand1 <= x"0000";
              operand2 <= x"2000";
              cnt<= cnt+1;          
            when 3 =>
              operand1 <= x"f000";
              operand2 <= x"1000";
              cnt<= cnt+1;          
            when 4 =>
              operand1 <= x"7000";
              operand2 <= x"5000";
              cnt<= cnt+1;          
            when 5 =>
              operand1 <= x"e000";
              operand2 <= x"b000";
              cnt<= cnt+1;          
            when 6 =>
              operand1 <= x"f000";
              operand2 <= x"f000";
              cnt<= cnt+1;
            when 7 =>
              operand1 <= x"f000";
              operand2 <= x"8000";
              cnt<= cnt+1;
            when 8 =>
              operand1 <= x"00F1";
              operand2 <= x"7FFF";
              cnt<= cnt+1;          
            when 9 =>
              operand1 <= x"00F1";
              operand2 <= x"7FFF";
              cnt<= cnt+1;

            when others => 
              cnt<= cnt+1;
        End case;     
        IF(cnt = 8) THEN
            TbSimEnded <= '1';
            --wait;
        END IF; 
    END IF;
end process;
 
  
END Behavioral;