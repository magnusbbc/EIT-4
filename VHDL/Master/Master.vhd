LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.Constants.all;

ENTITY Master IS
	GENERIC (
		ADD : INTEGER := ADDVAL; -- Adds two operands
		ADC : INTEGER := 2;-- Adds two operands, and the prevous overflow flag
		SUB : INTEGER := 3;-- Subtracts two operands
		MUL : INTEGER := 4;-- Multiplies two operands
		OGG : INTEGER := 5;-- ANDs two operands
		ELL : INTEGER := 6;-- ORs two operands
		XEL : INTEGER := 7;-- XORs two operands
		IKA : INTEGER := 8;-- NEGATES operand A
		IKB : INTEGER := 9; -- NEGATES operand B
		NOA : INTEGER := 10; -- NOT operand A
		NOB : INTEGER := 11; -- NOT operand B
		LSL : INTEGER := 12; -- Logic Shift Left Operand A by Operand B number of bits. Fill with "0"
		LSR : INTEGER := 13; -- Logic Shift Right Operand A by Operand B number of bits. Fill with "0"
		ASL : INTEGER := 14; -- Arithmetic Shift Left Operand A by Operand B number of bits. Fill with right bit
		ASR : INTEGER := 15; -- Arithmetic Shift ri Operand A by Operand B number of bits. Fill with left bit
		PAS : INTEGER := 16;-- Passes operand A
		PBS : INTEGER := 17; -- Passes operand B
		ICA : INTEGER := 18; -- Increments operand A
		ICB : INTEGER := 19; -- Increments operand B
		NAA : INTEGER := 20-- Does nothing, does not change flags
	);
	PORT (
		clk : IN std_logic;
		btn : IN std_logic_vector(2 DOWNTO 0);
		sseg : OUT std_logic_vector(31 DOWNTO 0);
		led : OUT std_logic_vector(9 DOWNTO 0)
	);
END ENTITY Master;

ARCHITECTURE Behavioral OF Master IS

	--Control and instruction registers
	SIGNAL CONTROL : STD_logic_vector(17 DOWNTO 0);
	SIGNAL INSTRUCTION : std_logic_vector(31 DOWNTO 0);

	--Wires
	SIGNAL OP1, OP2, ALU_OUTPUT, ALU_OUTPUT_MODIFIED : std_logic_vector(15 DOWNTO 0);
	SIGNAL RWSWITCH : std_logic_vector(4 DOWNTO 0);
	--PRAM Signals
	SIGNAL PC, ADDR, PC_ALT : std_logic_vector(9 DOWNTO 0) := (OTHERS => '0');
	SIGNAL pDataIn : std_logic_vector(31 DOWNTO 0);
	SIGNAL pDataOut : std_logic_vector(31 DOWNTO 0);
	SIGNAL PWE : std_logic := '0';
	SIGNAL PRE : std_logic := '1';
	--DRAM Signals
	SIGNAL DADDRS : std_logic_vector(9 DOWNTO 0);
	SIGNAL dDataOut : std_logic_vector(15 DOWNTO 0);

	--Reg Signals
	SIGNAL R2O : STD_logic_vector(15 DOWNTO 0);

	--Peripheral Signals
	--  SIGNAL clr : std_logic := '0';
	--  SIGNAL bcdenable : std_logic := '0';
	--  SIGNAL SsDAT : std_logic_vector(15 downto 0) := (others => '0');
	--  SIGNAL SsDOT : std_logic_vector(3 downto 0) := (others => '1');
	--  SIGNAL DBtn : std_logic_vector(2 downto 0);
	SIGNAL subClock : std_logic;
	SIGNAL PLL_CLOCK : std_logic;
	SIGNAL PLL_LOCK : std_logic;
	SIGNAL PLL_CLOCK_TEMP : Std_logic;
	SIGNAL DIVIDER : std_logic_vector(25 DOWNTO 0);
	SIGNAL JMP_SELECT : std_logic := '0';
	SIGNAL ADDR_SELECT : std_logic := '0';
	SIGNAL PC_OVERWRITE : std_logic := '0';

	SIGNAL Parity_Flag : std_logic := '0';
	SIGNAL Signed_Flag : std_logic := '0';
	SIGNAL Overflow_Flag : std_logic := '0';
	SIGNAL Zero_Flag : std_logic := '0';

	SIGNAL Parity_Flag_Latch : std_logic := '0';
	SIGNAL Signed_Flag_Latch : std_logic := '0';
	SIGNAL Overflow_Flag_Latch : std_logic := '0';
	SIGNAL Zero_Flag_Latch : std_logic := '0';

BEGIN

	PLL : ENTITY work.PLL(SYN)
		PORT MAP(
			inclk0 => clk,
			c0 => PLL_CLOCK,
			locked => PLL_LOCK
		);
	MEMCNT : ENTITY work.MemoryController
		GENERIC MAP(
			WORD_SIZE => 15,
			ADDR_SIZE => 15,
			WORD_COUNT => 1023
		)
		PORT MAP(
			WE => CONTROL(7),
			RE => CONTROL(8),
			Address => ALU_OUTPUT,
			DI => R2O,
			DO => dDataOut,
			CLK => subClock,
			btn => btn,
			ss => sseg
		);
	--	SEVENSEG : ENTITY work.ssgddriver(Behavioral)
	--		PORT MAP(
	--		clr => clr,     
	--		bcdenable => bcdenable,
	--		dat => SsDAT,
	--		dots => SsDOT,
	--		sseg => sseg    
	--		);
	--		
	--	BUTTON : ENTITY work.btnDriver(Behavioral)
	--		PORT MAP(
	--		clk => clk,								--Clock used for debouncing
	--		clr => clr,								--Clear
	--		btn => btn,	--Button inputs
	--		dbtn => DBtn	--Debounced button output
	--		);
	--
	--
	--
	--	DRAM : ENTITY work.Memory(falling)
	--		GENERIC MAP(
	--		WORD_SIZE => 15,
	--		ADDR_SIZE => 15,
	--		WORD_COUNT => 1023
	--		)
	--		PORT MAP(
	--		DI => R2O,
	--		DO => dDataOut,
	--		Address => ALU_OUTPUT,
	--		WE => CONTROL(6),
	--		RE => CONTROL(7),
	--		CLK => subClock
	--		);
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
			Operation => CONTROL(17 DOWNTO 12),
			Operand1 => OP1,
			Operand2 => OP2,
			Result => ALU_OUTPUT,
			Parity_Flag => Parity_Flag,
			Signed_Flag => Signed_Flag,
			Overflow_Flag => Overflow_Flag,
			Zero_Flag => Zero_Flag
		);
	PRAM : ENTITY work.MemAuto(SYN)
		PORT MAP(
			data => pDataIn,
			q => INSTRUCTION,
			address => ADDR,
			wren => PWE,
			rden => PRE,
			clock => subClock
		);
	REGS : ENTITY work.RegistryInternal(Behavioral)
		PORT MAP(
			readOne => INSTRUCTION(25 DOWNTO 21),
			WriteOne => INSTRUCTION(20 DOWNTO 16),
			readTwo => RWSWITCH,
			WriteTwo => INSTRUCTION(10 DOWNTO 6),

			dataInOne => ALU_OUTPUT_MODIFIED,
			dataInTwo => dDataOut,

			dataOutOne => OP1,
			dataOutTwo => R2O,

			pcIn => "000000" & std_logic_vector(unsigned(PC) + 1),

			WR1_E => CONTROL(6),
			WR2_E => CONTROL(5),

			clk => subClock
		);

	WITH CONTROL(4) SELECT OP2 <=
	R2O WHEN '0',
	INSTRUCTION(15 DOWNTO 0) WHEN '1',
	R2O WHEN OTHERS;

	WITH CONTROL(2) SELECT RWSWITCH <=
	INSTRUCTION(15 DOWNTO 11) WHEN '0',
	INSTRUCTION(20 DOWNTO 16) WHEN '1',
	INSTRUCTION(15 DOWNTO 11) WHEN OTHERS;

	WITH to_integer(unsigned(INSTRUCTION(20 DOWNTO 16))) SELECT PC_OVERWRITE <=
	'1' WHEN 31,
	'0' WHEN OTHERS;

	WITH to_integer(unsigned(PC_OVERWRITE & CONTROL(11 DOWNTO 9))) SELECT JMP_SELECT <=
	'0' WHEN 0,
	'1' WHEN 1,
	Zero_Flag_Latch WHEN 2,
	Overflow_Flag_Latch WHEN 3,
	NOT Zero_Flag_Latch WHEN 4,
	'1' WHEN 8, --WHEN PC_OVERWRITE is set
	'0' WHEN OTHERS;

	WITH CONTROL(1) SELECT PC_ALT <=
	dDataOut(9 DOWNTO 0) WHEN '1',
	ALU_OUTPUT(9 DOWNTO 0) WHEN OTHERS;

	WITH JMP_SELECT SELECT ADDR <=
		PC_ALT WHEN '1',
		PC WHEN OTHERS;

	WITH CONTROL(3) SELECT ALU_OUTPUT_MODIFIED <=
	std_logic_vector(unsigned(ALU_OUTPUT) - 1) WHEN '1',
	ALU_OUTPUT WHEN OTHERS;
	RUN : PROCESS (subClock)
	BEGIN
		IF (rising_edge(subClock)) THEN --clk
			IF (JMP_SELECT /= '1') THEN
				PC <= std_logic_vector(unsigned(PC) + 1);
			ELSE
				PC <= std_logic_vector(unsigned(PC_ALT) + 1);
				LED(5) <= '1';
			END IF;
		END IF;
	END PROCESS;

	LATCH : PROCESS (subClock)
	BEGIN
		IF (rising_edge(subClock)) THEN
			Zero_Flag_Latch <= Zero_Flag;
			Overflow_Flag_Latch <= Overflow_Flag;
			Signed_Flag_Latch <= Signed_Flag;
			Parity_Flag_Latch <= Parity_Flag;
		END IF;
	END PROCESS;

	WITH CONTROL(0) SELECT subClock <=
	PLL_CLOCK_TEMP WHEN '0',
	--DBtn(2) when '0',
	--clk when '0',
	'0' WHEN OTHERS;

	WITH PLL_LOCK SELECT PLL_CLOCK_TEMP <=
		PLL_CLOCK WHEN '1',
		'0' WHEN OTHERS;
	PROCESS (PLL_CLOCK)
	BEGIN
		IF (rising_edge(PLL_CLOCK)) THEN
			DIVIDER <= std_logic_vector(unsigned(DIVIDER) + 1);
		END IF;
	END PROCESS;
	LED(9) <= Zero_Flag; --Latch not needed
	LED(8) <= Overflow_Flag;
	LED(7) <= Signed_Flag;
	LED(6) <= Parity_Flag;

	LED(0) <= DIVIDER(25);
	LED(1) <= CONTROL(0);

END ARCHITECTURE Behavioral;