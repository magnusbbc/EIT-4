LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Master IS
	PORT (
		op : IN std_logic_vector(31 DOWNTO 26); -- Operands 1 and 2
		cnt: OUT std_logic_vector(13 DOWNTO 0)
	);
END ENTITY Master;

ARCHITECTURE Behavioral OF Master IS
BEGIN
	CONTROLLER : ENTITY work.Control(Behavioral) PORT MAP(opcode => op, cntSignal => cnt);

END ARCHITECTURE Behavioral;