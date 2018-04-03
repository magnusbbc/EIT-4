LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Master IS
	PORT (
		clk : std_logic;
		op : IN std_logic_vector(31 DOWNTO 26); -- Operands 1 and 2
		cnt: OUT std_logic_vector(13 DOWNTO 0);
		PDO: OUT std_logic_vector(31 downto 0)
	);
END ENTITY Master;

ARCHITECTURE Behavioral OF Master IS
		--SIGNAL PDO : std_logic_vector(15 downto 0);
		SIGNAL PDI : std_logic_vector(31 downto 0);
		SIGNAL PADDR : std_logic_vector(9 downto 0);
		SIGNAL PEN   : STD_LOGIC := '0';
		SIGNAL PRW	 : STD_LOGIC := '0';
		
		SIGNAL PC : INTEGER :=0 ;
		SIGNAL SW : STD_LOGIC := '0';
BEGIN
	CONTROLLER : ENTITY work.Control(Behavioral) PORT MAP(opcode => op, cntSignal => cnt);
	PMEMORY    : ENTITY work.Memory(Behavioral) PORT MAP(DO => PDO, DI => PDI, Address => PADDR, EN => PEN, RW => PRW, clk => clk);
	
	onEdge : PROCESS(clk)
		BEGIN
			IF (rising_edge(clk)) THEN
				IF(SW = '0') THEN
					PADDR <= std_logic_vector(to_unsigned(PC, PADDR'length));
					PDI <= std_logic_vector(to_unsigned(PC, PDI'length));
					PRW  <= '1';
					PEN <= '1';
					PC <= PC+1;
					IF(PC =4) THEN
						SW <= '1';
						PC<= 0;
					END IF;
				END IF;
				
				IF(SW = '1') THEN
					PADDR <= std_logic_vector(to_unsigned(PC, PADDR'length));
					PRW  <= '0';
					PEN <= '1';
					PC <= PC+1;
					IF(PC =4) THEN
						SW <= '1';
						PC<= 0;
					END IF;
				END IF;
			END IF;
	END PROCESS;
	
	
	
END ARCHITECTURE Behavioral;