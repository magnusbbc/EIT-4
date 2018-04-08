LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Master IS
	GENERIC 
	(
		ADD : integer := 1; -- Adds two operands
		ADC : integer := 2;-- Adds two operands, and the prevous overflow flag
		SUB : integer := 3;-- Subtracts two operands
		MUL : integer := 4;-- Multiplies two operands
		OGG : integer := 5;-- ANDs two operands
		ELL : integer := 6;-- ORs two operands
		XEL : integer := 7;-- XORs two operands
		IKA : integer := 8;-- NEGATES operand A
		IKB : integer := 9; -- NEGATES operand B
		NOA : integer := 10; -- NOT operand A
		NOB : integer := 11; -- NOT operand B
		LSL : integer := 12; -- Logic Shift Left Operand A by Operand B number of bits. Fill with "0"
		LSR : integer := 13; -- Logic Shift Right Operand A by Operand B number of bits. Fill with "0"
		ASL : integer := 14; -- Arithmetic Shift Left Operand A by Operand B number of bits. Fill with right bit
		ASR : integer := 15; -- Arithmetic Shift ri Operand A by Operand B number of bits. Fill with left bit
		PAS : integer := 16;-- Passes operand A
		PBS : integer := 17; -- Passes operand B
		ICA : integer := 18; -- Increments operand A
		ICB : integer := 19; -- Increments operand B
		NAA : integer := 20-- Does nothing, does not change flags
	);
	PORT 
	(
		clk         : IN std_logic
	);
END ENTITY Master;

ARCHITECTURE Behavioral OF Master IS
	SIGNAL CONTROL : STD_logic_vector(16 DOWNTO 0);
	SIGNAL INSTRUCTION : std_logic_vector(31 DOWNTO 0);
	
	SIGNAL OP1, OP2, ALU_OUTPUT   : std_logic_vector(15 DOWNTO 0);
	
	SIGNAL RWSWITCH : std_logic_vector(4 DOWNTO 0);
	
	--PRAM Signals
	SIGNAL PC : std_logic_vector(9 DOWNTO 0) := (others => '0') ;
	SIGNAL pDataIn : std_logic_vector(31 DOWNTO 0);
	SIGNAL pDataOut : std_logic_vector(31 DOWNTO 0);
	SIGNAL PWE : std_logic := '0';
	SIGNAL PRE : std_logic := '1';
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
		IKA => IKA,
		IKB => IKB,
		NOA => NOA,
		NOB => NOB,
		LSL => LSL,
		LSR => LSR,
		ASL => ASL,
		ASR => ASR,
		PAS => PAS,
		PBS => PBS,
		ICA => ICA,
		ICB => ICB,
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
		IKA => IKA,
		IKB => IKB,
		NOA => NOA,
		NOB => NOB,
		LSL => LSL,
		LSR => LSR,
		ASL => ASL,
		ASR => ASR,
		PAS => PAS,
		PBS => PBS,
		ICA => ICA,
		ICB => ICB,
		NAA => NAA
		)
		PORT MAP(
		Operation => CONTROL(16 DOWNTO 11), 
		Operand1 => OP1, 
		Operand2 => OP2, 
		Result => ALU_OUTPUT
		);
		
--	PRAM : ENTITY work.Memory(rising)
--		GENERIC MAP(
--		WORD_SIZE => 31,
--		ADDR_SIZE => 9,
--		WORD_COUNT => 1023
--		)
--		PORT MAP(
--		DI => pDataIn,
--		DO => pDataOut,
--		Address => PC,
--		WE => PWE,
--		RE => PRE,
--		CLK => clk
--		);
		
	PRAM : ENTITY work.MemAuto(SYN)
		PORT MAP(
		data => pDataIn,
		q => INSTRUCTION,
		address => PC,
		wren => PWE,
		rden => PRE,
		clock => clk
		);
		
	DRAM : ENTITY work.Memory(falling)
		GENERIC MAP(
		WORD_SIZE => 15,
		ADDR_SIZE => 15,
		WORD_COUNT => 1023
		)
		PORT MAP(
		DI => R2O,
		DO => dDataOut,
		Address => ALU_OUTPUT,
		WE => CONTROL(5),
		RE => CONTROL(6),
		CLK => clk
		);

	REGS : ENTITY work.RegistryInternal(Behavioral)
		PORT MAP(
		readOne =>INSTRUCTION(25 downto 21),
		WriteOne =>INSTRUCTION(20 downto 16),
		readTwo =>RWSWITCH,
		WriteTwo =>INSTRUCTION(10 downto 6),
		
		dataInOne => ALU_OUTPUT,
		dataInTwo => dDataOut,
		
		dataOutOne => OP1,
		dataOutTwo => R2O,
		
		pcIn => x"0000",
		
		WR1_E => CONTROL(4), 
		WR2_E => CONTROL(3),
		
		clk => clk
		);
		
	WITH CONTROL(2) SELECT OP2 <=
		R2O 							 WHEN '0',
		INSTRUCTION(15 downto 0) WHEN '1',
		R2O WHEN OTHERS;
	
	WITH CONTROL(0) SELECT RWSWITCH <=
		INSTRUCTION(15 downto 11) when '0',
		INSTRUCTION(20 downto 16) WHEN  '1',
		INSTRUCTION(15 downto 11) when OTHERS;
		
	RUN: process (clk)
		BEGIN
		IF(rising_edge(clk)) THEN
		PC <= std_logic_vector(unsigned(PC)+1);
		END IF;
	END PROCESS;

 
END ARCHITECTURE Behavioral;