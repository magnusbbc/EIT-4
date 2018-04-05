LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Master IS
	GENERIC 
	(
		--ALU Generics
		ADD : std_logic_vector := x"1"; -- Adds two operands
		ADC : std_logic_vector := x"2"; -- Adds two operands, and the prevous overflow flag
		SUB : std_logic_vector := x"3"; -- Subtracts two operands
		MUL : std_logic_vector := x"4"; -- Multiplies two operands
		OGG : std_logic_vector := x"5"; -- ANDs two operands
		ELL : std_logic_vector := x"6"; -- ORs two operands
		XEL : std_logic_vector := x"7"; -- XORs two operands
		IKK : std_logic_vector := x"8"; -- NEGATES operand A
		NOA : std_logic_vector := x"9"; -- NOT operand A
		LSL : std_logic_vector := x"A"; -- Logic Shift Left Operand A by Operand B number of bits. Fill with "0"
		LSR : std_logic_vector := x"B"; -- Logic Shift Right Operand A by Operand B number of bits. Fill with "0"
		ASL : std_logic_vector := x"C"; -- Arithmetic Shift Left Operand A by Operand B number of bits. Fill with right bit
		ASR : std_logic_vector := x"D"; -- Arithmetic Shift ri Operand A by Operand B number of bits. Fill with left bit
		PAS : std_logic_vector := x"E"; -- Passes operand A
		INC : std_logic_vector := x"F"; -- Increments operand A
		NAA : std_logic_vector := x"0" -- Does nothing, does not change flags
	);
	PORT 
	(
		clk         : IN std_logic;
		INSTRUCTION : IN std_logic_vector(31 DOWNTO 0);
		--CONTROL : OUT STD_logic_vector(13 downto 0);
		OP1, OP2   : IN std_logic_vector(15 DOWNTO 0);
		ALU_OUTPUT : OUT std_logic_vector(15 DOWNTO 0)
	);
END ENTITY Master;

ARCHITECTURE Behavioral OF Master IS
	-- SIGNAL INSTRUCTION : std_logic_vector(31 downto 0);
	SIGNAL CONTROL : STD_logic_vector(13 DOWNTO 0);
	-- SIGNAL OP1, OP2, ALU_OUTPUT : std_logic_vector(15 downto 0);
	SIGNAL PC : INTEGER := 0;
	SIGNAL SW : STD_LOGIC := '0';
BEGIN
	CONTROLLER : ENTITY work.Control(Behavioral)
		GENERIC MAP(
		ADD => ADD,
		ADC => ADC,
		SUB => SUB,
		MUL => MUL,
		OGG => OGG,
		ELL => ELL,
		XEL => XEL,
		IKK => IKK,
		NOA => NOA,
		LSL => LSL,
		LSR => LSR,
		ASL => ASL,
		ASR => ASR,
		PAS => PAS,
		INC => INC,
		NAA => NAA
		)
		PORT MAP(
		opcode => INSTRUCTION(31 DOWNTO 26), 
		cntSignal => CONTROL
		);
	ALU : ENTITY work.My_first_ALU(Behavioral)
		GENERIC MAP(
		ADD   => ADD, 
		SUB   => SUB,
		OGG   => OGG,
		ELL   => ELL,
		XEL   => XEL, 
		NOA   => NOA,
		LSL   => LSL,
		LSR   => LSR,
		ASL   => ASL,
		ASR   => ASR, 
		PAS   => PAS,
		INC_A => INC 
		)
		PORT MAP(
		Operation => CONTROL(13 DOWNTO 10), 
		Operand1 => OP1, 
		Operand2 => OP2, 
		Result => ALU_OUTPUT
		);
 
				-- onEdge :PROCESS(clk)
				-- BEGIN
				-- IF (rising_edge(clk)) THEN
				-- IF(SW = '0') THEN --Write instructions to program memory
				-- PADDR <= std_logic_vector(to_unsigned(PC, PADDR'length));
				-- PDI <= std_logic_vector(to_unsigned(PC, PDI'length));
				-- PRW <= '1';
				-- PEN <= '1';
				-- PC <= PC+1;
				-- IF(PC =4) THEN
				-- SW <= '1';
				-- PC<= 0;
				-- END IF;
				-- END IF;
				-- 
				-- IF(SW = '1') THEN --Execute Program
				-- PADDR <= std_logic_vector(to_unsigned(PC, PADDR'length));
				-- PRW <= '0';
				-- PEN <= '1';
				-- 
				-- PC <= PC+1;
				-- IF(PC =4) THEN
				-- SW <= '1';
				-- PC<= 0;
				-- END IF;
				-- END IF;
				-- END IF;
				-- END PROCESS;
 
 
 
END ARCHITECTURE Behavioral;