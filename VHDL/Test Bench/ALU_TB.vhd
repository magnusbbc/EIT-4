LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU_TB IS
END ALU_TB;

ARCHITECTURE Behavioral OF ALU_TB IS
	 
	signal	Operand1    :  std_logic_vector(15 DOWNTO 0); -- Operands 1 and 2
	signal   Operand2    :  std_logic_vector(15 DOWNTO 0); -- Operands 1 and 2	
	signal   Operation   : std_logic_vector(5 DOWNTO 0);

		signal Parity_Flag        :  std_logic; -- Flag raised when a carry is present after adding
		signal Signed_Flag        :  std_logic; -- Flag that does something?
		signal Overflow_Flag      :  std_logic; -- Flag raised when overflow is present
		signal Zero_Flag          :  std_logic; -- Flag raised when operands are equal?
		
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
	result => result
	
	);
	
	-- Clock generation
   TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

	
stim_proc:process(TbClock)
		begin
			IF(rising_edge(TbClock)) THEN
			cnt<=cnt+1;
			operand1 <= x"0001";
			operand2 <= x"0000";
			operation <= std_logic_vector(to_unsigned(cnt,operation'length));
				IF(cnt = 8) THEN
						TbSimEnded <= '1';
						--wait;
				END IF; 
			END IF;
	end process; 
END Behavioral;