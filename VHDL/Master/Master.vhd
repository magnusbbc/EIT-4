LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Master IS
	PORT (
		clk : std_logic
	);
END ENTITY Master;

ARCHITECTURE Behavioral OF Master IS
		SIGNAL INSTRUCTION : std_logic_vector(31 downto 0);
		SIGNAL PDI : std_logic_vector(15 downto 0);
		SIGNAL PADDR : std_logic_vector(9 downto 0);
		SIGNAL PEN   : STD_LOGIC := '0';
		SIGNAL PRW	 : STD_LOGIC := '0';
		
		SIGNAL CONTROL : STD_logic_vector(13 downto 0);
		SIGNAL PC : INTEGER :=0 ;
		SIGNAL SW : STD_LOGIC := '0';
BEGIN
	CONTROLLER : ENTITY work.Control(Behavioral) PORT MAP(opcode => INSTRUCTION, cntSignal => cnt);
	PMEMORY    : ENTITY work.Memory(Behavioral) PORT MAP(DO => INSTRUCTION, DI => PDI, Address => PADDR, EN => PEN, RW => PRW);
	REGFILE	  : ENTITY work.Registers(Behavioral) PORT MAP(R1I => , R2I => , R1O => , R2O => , R3I => , R4I => , DI3 => , DI4 => , WE3 => , WE4 => );
	ALU 		  : ENTITY work.ALU(Behavioral) PORT MAP();
	
	onEdge : PROCESS(clk)
		BEGIN
			IF (rising_edge(clk)) THEN
				IF(SW = '0') THEN --Write instructions to program memory
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
				
				IF(SW = '1') THEN --Execute Program
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