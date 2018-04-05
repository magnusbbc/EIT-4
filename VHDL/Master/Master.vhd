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
		clk         : IN std_logic
	);
END ENTITY Master;

ARCHITECTURE Behavioral OF Master IS
	SIGNAL CONTROL : STD_logic_vector(13 DOWNTO 0);
	SIGNAL INSTRUCTION : std_logic_vector(31 DOWNTO 0);
	
	SIGNAL OP1, OP2, ALU_OUTPUT   : std_logic_vector(15 DOWNTO 0);
	
	--PRAM Signals
	SIGNAL PC : std_logic_vector(9 DOWNTO 0) := (others => '0') ;
	SIGNAL pDataIn : std_logic_vector(31 DOWNTO 0);
	SIGNAL pDataOut : std_logic_vector(31 DOWNTO 0);
	SIGNAL PWE : std_logic := '0';
	SIGNAL PRE : std_logic := '0';
	--DRAM Signals
	
	SIGNAL DADDRS : std_logic_vector(9 downto 0);
	SIGNAL dDataOut : std_logic_vector(15 DOWNTO 0);
	
	--Reg Signals
	SIGNAL R2O : STD_logic_vector(15 downto 0);
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
		Operation => CONTROL(13 DOWNTO 10), 
		Operand1 => OP1, 
		Operand2 => OP2, 
		Result => ALU_OUTPUT
		);
		
	PRAM : ENTITY work.Memory(rising)
		GENERIC MAP(
		WORD_SIZE => 31,
		ADDR_SIZE => 9,
		WORD_COUNT => 1023
		)
		PORT MAP(
		DI => pDataIn,
		DO => pDataOut,
		Address => PC,
		WE => PWE,
		RE => PRE,
		CLK => clk
		);
		
	DRAM : ENTITY work.Memory(falling)
		GENERIC MAP(
		WORD_SIZE => 15,
		ADDR_SIZE => 15,
		WORD_COUNT => 1023
		)
		PORT MAP(
		DI => OP2,
		DO => dDataOut,
		Address => ALU_OUTPUT,
		WE => CONTROL(4),
		RE => CONTROL(5),
		CLK => clk
		);

	REGS : ENTITY work.RegistryInternal(Behavioral)
		PORT MAP(
		readOne =>INSTRUCTION(25 downto 21),
		readTwo =>INSTRUCTION(20 downto 16),
		
		WriteOne =>INSTRUCTION(15 downto 11),
		WriteTwo =>INSTRUCTION(10 downto 6),
		
		dataInOne => ALU_OUTPUT,
		dataInTwo => dDataOut,
		
		dataOutOne => OP1,
		dataOutTwo => R2O,
		
		pcIn => x"0000",
		
		WR1_E => CONTROL(2), 
		WR2_E => CONTROL(3)
		);
		
	WITH CONTROL(1) SELECT OP2 <=
		R2O 							 WHEN '0',
		INSTRUCTION(15 downto 0) WHEN '1',
		R2O WHEN OTHERS;
		
	RUN: process (clk)
		BEGIN
		IF(rising_edge(clk)) THEN
		PC <= std_logic_vector(unsigned(PC)+1);
		END IF;
	END PROCESS;

 
END ARCHITECTURE Behavioral;