#include "Config.hvhd"

--Definition of control lines
#define ALU_CONTROL 18 DOWNTO 13
#define JUMP_CONTROL 12 DOWNTO 10
#define MEMORY_READ 9
#define MEMORY_WRITE 8
#define REGISTER_WRITE 7
#define MEMORY_WRITE_BACK 6
#define IMMEDIATE_SELECT 5
#define PUSH 4
#define POP 3
#define SWITCH_READ_WRITE 2
#define MEMORY_TO_PC 1
#define HALT 0

--definition of instruction lines
#define OPCODE 31 DOWNTO 26
#define REGISTER_READ_INDEX_1 25 DOWNTO 21
#define REGISTER_READ_INDEX_2 15 DOWNTO 11
#define REGISTER_WRITE_INDEX_1 20 DOWNTO 16
#define IMMEDIATE 15 DOWNTO 0

#define PUSH_PC "10000100000000001111100000000000"

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY Master IS
	PORT (
		clk : IN std_logic;
		btn : IN std_logic_vector(2 DOWNTO 0);
		sseg : OUT std_logic_vector(31 DOWNTO 0);
		led : OUT std_logic_vector(9 DOWNTO 0)
	);
END ENTITY Master;

ARCHITECTURE Behavioral OF Master IS

	--Control and instruction registers
	SIGNAL CONTROL : Std_logic_vector(CONTROL_SIZE DOWNTO 0);
	SIGNAL INSTRUCTION, INSTRUCTION_PRAM : std_logic_vector(INSTRUCTION_SIZE DOWNTO 0);

	--Wires
	SIGNAL OP1, OP2, ALU_OUTPUT, SP_OUT, REGISTER_WRITEBACK, MEM_ADDRESS : std_logic_vector(WORD_SIZE DOWNTO 0);
	SIGNAL RWSWITCH : std_logic_vector(4 DOWNTO 0);
	--PRAM Signals
	SIGNAL PC, ADDR, PC_ALT, Interrupt_addr : std_logic_vector(9 DOWNTO 0) := (OTHERS => '0');
	SIGNAL pDataIn : std_logic_vector(INSTRUCTION_SIZE DOWNTO 0);
	SIGNAL pDataOut : std_logic_vector(INSTRUCTION_SIZE DOWNTO 0);
	SIGNAL PWE : std_logic := '0';
	SIGNAL PRE : std_logic := '1';
	--DRAM Signals
	SIGNAL DADDRS : std_logic_vector(9 DOWNTO 0);
	SIGNAL dDataOut : std_logic_vector(WORD_SIZE DOWNTO 0);

	--Reg Signals
	SIGNAL R2O : STD_logic_vector(WORD_SIZE DOWNTO 0);


	SIGNAL subClock : std_logic;
	SIGNAL PLL_CLOCK : std_logic;
	SIGNAL PLL_LOCK : std_logic;
	SIGNAL PLL_CLOCK_TEMP : Std_logic;
	SIGNAL DIVIDER : std_logic_vector(25 DOWNTO 0);
	SIGNAL JMP_SELECT : std_logic := '0';
	SIGNAL ADDR_SELECT : std_logic := '0';
	SIGNAL PC_OVERWRITE, SP_OVERWRITE : std_logic := '0';

	SIGNAL Parity_Flag : std_logic := '0';
	SIGNAL Signed_Flag : std_logic := '0';
	SIGNAL Overflow_Flag : std_logic := '0';
	SIGNAL Zero_Flag : std_logic := '0';

	SIGNAL Parity_Flag_Latch : std_logic := '0';
	SIGNAL Signed_Flag_Latch : std_logic := '0';
	SIGNAL Overflow_Flag_Latch : std_logic := '0';
	SIGNAL Zero_Flag_Latch : std_logic := '0';

	SIGNAL PC_REG_IN : std_logic_vector(WORD_SIZE DOWNTO 0);

	SIGNAL Interrupt_CPU : std_logic := '0';
	SIGNAL Interrupt_latch : std_logic := '0';

BEGIN

	PLL : ENTITY work.PLL(SYN)
		PORT MAP(
			inclk0 => clk,
			c0 => PLL_CLOCK,
			locked => PLL_LOCK
		);
	MEMCNT : ENTITY work.MemoryController
		PORT MAP(
			WE => CONTROL(MEMORY_WRITE),
			RE => CONTROL(MEMORY_READ),
			Address => MEM_ADDRESS,
			DI => R2O,
			DO => dDataOut,
			CLK => subClock,
			btn => btn,
			ss => sseg,
			control => Interrupt_addr,
			interrupt_cpu => Interrupt_CPU
		);

	CONTROLLER : ENTITY work.Control(Behavioral)
		PORT MAP(
			opcode => INSTRUCTION(OPCODE),
			cntSignal => CONTROL
		);
	
	STACK : ENTITY work.Stack(Behavioral)
		PORT MAP(
			pop => CONTROL(POP),
			push => CONTROL(PUSH),
			clk => clk,
			addressOut => SP_OUT,
			addressIn => REGISTER_WRITEBACK,
			writeBack => SP_OVERWRITE
		);

	ALU : ENTITY work.My_first_ALU(Behavioral)
		PORT MAP(
			Operation => CONTROL(ALU_CONTROL),
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
			q => INSTRUCTION_PRAM,
			address => ADDR,
			wren => PWE,
			rden => PRE,
			clock => subClock
		);
	REGS : ENTITY work.RegistryInternal(Behavioral)
		PORT MAP(
			readOne => INSTRUCTION(REGISTER_READ_INDEX_1),
			WriteOne => INSTRUCTION(REGISTER_WRITE_INDEX_1),
			readTwo => RWSWITCH,

			dataInOne => REGISTER_WRITEBACK,

			dataOutOne => OP1,
			dataOutTwo => R2O,

			pcIn => PC_REG_IN,
			spIN => SP_OUT,

			WR1_E => CONTROL(REGISTER_WRITE),

			clk => subClock
		);

	WITH CONTROL(IMMEDIATE_SELECT) SELECT OP2 <= -- Selects Register output 2 or Immediate
	R2O WHEN '0',
	INSTRUCTION(IMMEDIATE) WHEN '1',
	R2O WHEN OTHERS;

	WITH CONTROL(SWITCH_READ_WRITE) SELECT RWSWITCH <= --if SWITCH_READ_WRITE, Read 2 index will be write 1 index
	INSTRUCTION(REGISTER_WRITE_INDEX_1) WHEN '1',
	INSTRUCTION(REGISTER_READ_INDEX_2) WHEN OTHERS;

	WITH to_integer(unsigned(INSTRUCTION(REGISTER_WRITE_INDEX_1))) SELECT PC_OVERWRITE <=
	'1' WHEN 31,
	'0' WHEN OTHERS;

	WITH to_integer(unsigned(INSTRUCTION(REGISTER_WRITE_INDEX_1))) SELECT SP_OVERWRITE <=
	'1' WHEN 30,
	'0' WHEN OTHERS;

	WITH to_integer(unsigned(PC_OVERWRITE & CONTROL(JUMP_CONTROL))) SELECT JMP_SELECT <= --Controls branching/changing PC
	'0' WHEN 0,
	'1' WHEN 1,
	Zero_Flag_Latch WHEN 2,
	Overflow_Flag_Latch WHEN 3,
	NOT Zero_Flag_Latch WHEN 4,
	'1' WHEN 8, --WHEN PC_OVERWRITE is set
	'1' WHEN 16,
	'0' WHEN OTHERS;


	PROCESS(subClock)
	BEGIN
		IF(falling_edge(subClock)) THEN
			IF(Interrupt_latch = '1') THEN
				PC_ALT <= Interrupt_addr;
			ELSIF(CONTROL(MEMORY_TO_PC) = '1') THEN
				PC_ALT <= dDataOut(9 DOWNTO 0);
			ELSE
				PC_ALT <= ALU_OUTPUT(9 DOWNTO 0);
			END IF;
		END IF;
	END PROCESS;

--	PROCESS(CONTROL(MEMORY_TO_PC), Interrupt_latch)
--	BEGIN
--		IF(Interrupt_latch = '1') THEN
--			PC_ALT <= Interrupt_addr;
--		ELSIF(CONTROL(MEMORY_TO_PC) = '1') THEN
--			PC_ALT <= dDataOut(9 DOWNTO 0);
--		ELSE
--			PC_ALT <= ALU_OUTPUT(9 DOWNTO 0);
--		END IF;
--	END PROCESS;


	PROCESS(CONTROL(POP),CONTROL(PUSH),SP_OUT,ALU_OUTPUT)
		VARIABLE TMP : std_logic_vector(1 downto 0);
	BEGIN
		TMP := CONTROL(POP) & CONTROL(PUSH);
		IF(to_integer(UNSIGNED(TMP)) > 0) THEN
			MEM_ADDRESS <= SP_OUT;
		ELSE
			MEM_ADDRESS <= ALU_OUTPUT;
		END IF;
	END PROCESS;

	WITH JMP_SELECT SELECT ADDR <= --Choses instruction to be loaded based on branching
		PC_ALT WHEN '1',
		PC WHEN OTHERS;

	PROCESS  (Interrupt_latch, INSTRUCTION_PRAM)--Changes instruction if interrupt is detected
	BEGIN
		IF(Interrupt_latch = '1') THEN
			INSTRUCTION <= PUSH_PC;
		ELSE
			INSTRUCTION <= INSTRUCTION_PRAM;
		END IF;
	END PROCESS;

	WITH CONTROL(MEMORY_WRITE_BACK) SELECT REGISTER_WRITEBACK <=
	dDataOut WHEN '1',
	ALU_OUTPUT WHEN OTHERS;

	RUN : PROCESS (subClock) --Chose new value of PC based on branching
	BEGIN
		IF (rising_edge(subClock)) THEN --clk
			IF (Interrupt_latch = '1' AND JMP_SELECT /= '1') THEN
				PC <= PC;
			ELSIF (Interrupt_latch = '1' AND JMP_SELECT = '1') THEN
				PC <= std_logic_vector(unsigned(PC_ALT) - 1);
			ELSIF (JMP_SELECT /= '1') THEN
				PC <= std_logic_vector(unsigned(PC) + 1);
			ELSE
				PC <= std_logic_vector(unsigned(PC_ALT) + 1);
				LED(5) <= '1';
			END IF;
		END IF;
	END PROCESS;

	LATCH : PROCESS (subClock) --Latches Flags in tempo register, neccesarry due to clock timing
	BEGIN
		IF (rising_edge(subClock)) THEN
			Zero_Flag_Latch <= Zero_Flag;
			Overflow_Flag_Latch <= Overflow_Flag;
			Signed_Flag_Latch <= Signed_Flag;
			Parity_Flag_Latch <= Parity_Flag;
		END IF;
	END PROCESS;

	WITH CONTROL(HALT) SELECT subClock <=
	--PLL_CLOCK_TEMP WHEN '0',
	--DBtn(2) when '0',
	clk when '0',
	'0' WHEN OTHERS;

	PROCESS(subClock)
	BEGIN
		IF(falling_edge(subClock)) THEN
			IF(Interrupt_CPU = '1') THEN
				Interrupt_latch <= '1';
			ELSIF(Interrupt_latch = '1') THEN
				Interrupt_latch <= '0';
			END IF;
		END IF;
	END PROCESS;
	WITH PLL_LOCK SELECT PLL_CLOCK_TEMP <=
		PLL_CLOCK WHEN '1',
		'0' WHEN OTHERS;
	PROCESS (PLL_CLOCK)
	BEGIN
		IF (rising_edge(PLL_CLOCK)) THEN
			DIVIDER <= std_logic_vector(unsigned(DIVIDER) + 1);
		END IF;
	END PROCESS;

	PC_REG_IN <= "000000" & std_logic_vector(unsigned(PC) + 1);

	LED(9) <= Zero_Flag; --Latch not needed
	LED(8) <= Overflow_Flag;
	LED(7) <= Signed_Flag;
	LED(6) <= Parity_Flag;

	LED(0) <= DIVIDER(25);
	LED(1) <= CONTROL(HALT);

END ARCHITECTURE Behavioral;