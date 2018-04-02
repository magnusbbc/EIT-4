LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Control IS
	GENERIC (
		--ALU Generics
		ADD     : std_logic_vector := x"1"; -- Adds two operands
		ADC     : std_logic_vector := x"2"; -- Adds two operands, and the prevous overflow flag
		SUB     : std_logic_vector := x"3"; -- Subtracts two operands
		MUL     : std_logic_vector := x"4"; -- Multiplies two operands
		OGG     : std_logic_vector := x"5"; -- ANDs two operands
		ELL     : std_logic_vector := x"6"; -- ORs two operands
		XEL     : std_logic_vector := x"7"; -- XORs two operands
		IKK     : std_logic_vector := x"8"; -- NEGATES operand A
		NOO     : std_logic_vector := x"9"; -- NOT operand A
		LSL     : std_logic_vector := x"A"; -- Logic Shift Left Operand A by Operand B number of bits. Fill with "0"
		LSR     : std_logic_vector := x"B"; -- Logic Shift Right Operand A by Operand B number of bits. Fill with "0"
		ASL     : std_logic_vector := x"C"; -- Arithmetic Shift Left Operand A by Operand B number of bits. Fill with right bit
		ASR     : std_logic_vector := x"D"; -- Arithmetic Shift ri Operand A by Operand B number of bits. Fill with left bit
		PAS     : std_logic_vector := x"E"; -- Passes opeand A
		NAA     : std_logic_vector := x"0"; -- Does nothing, does not change flags

		--JUMP Generics
		NB      : std_logic_vector := "0000";
		BR      : std_logic_vector := "0001";
		EQ      : std_logic_vector := "0010";
		LE      : std_logic_vector := "0100";
		GE      : std_logic_vector := "1000";

		--Other Control lines ENABLE
		MEMRD_E : std_logic        := '1';
		MEM2R_E : std_logic        := '1';
		MEMWR_E : std_logic        := '1';
		REGWR_E : std_logic        := '1';
		ALUS1_E : std_logic        := '1';
		ALUS2_E : std_logic        := '1';

		--Other Control lines DISABLE
		MEMRD_D : std_logic        := '0';
		MEM2R_D : std_logic        := '0';
		MEMWR_D : std_logic        := '0';
		REGWR_D : std_logic        := '0';
		ALUS1_D : std_logic        := '0';
		ALUS2_D : std_logic        := '0';

		--Opcodes
		R       : INTEGER          := 0;
		ADDI    : INTEGER          := 1;
		ADDCI   : INTEGER          := 2;
		SUBI    : INTEGER          := 3;
		NEGI    : INTEGER          := 4;
		ANDI    : INTEGER          := 5;
		ORI     : INTEGER          := 6;
		XORI    : INTEGER          := 7;
		MULTI   : INTEGER          := 8;
		LSLI    : INTEGER          := 9;
		LSRI    : INTEGER          := 10;
		RASI    : INTEGER          := 11;
		LASI    : INTEGER          := 12;
		NOP     : INTEGER          := 14;
		CMP     : INTEGER          := 15;
		MOV     : INTEGER          := 16;
		CMPI    : INTEGER          := 17;
		MOVI    : INTEGER          := 18;
		LOAD    : INTEGER          := 19;
		STORE   : INTEGER          := 20;
		POP     : INTEGER          := 21;
		PUSH    : INTEGER          := 22;
		JMP     : INTEGER          := 23;
		JMPEQ   : INTEGER          := 24;
		JMPLE   : INTEGER          := 25;
		JMPGR   : INTEGER          := 26

	);
	PORT (
		opcode    : IN std_logic_vector(31 DOWNTO 26); -- Operands 1 and 2
		cntSignal : OUT std_logic_vector(13 DOWNTO 0)
	);
END ENTITY control;

ARCHITECTURE Behavioral OF control IS
BEGIN
	WITH to_integer(unsigned(opcode)) SELECT cntSignal <=
	NAA & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_D WHEN R,
	ADD & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN ADDI,
	ADC & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN ADDCI,
	SUB & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN SUBI,
	NOO & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN NEGI,
	OGG & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN ANDI,
	ELL & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN ORI,
	XEL & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN XORI,
	MUL & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN MULTI,
	LSL & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN LSLI,
	LSR & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN LSRI,
	ASL & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN RASI,
	ASR & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN LASI,
	NAA & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_D & ALUS1_D & ALUS2_D WHEN NOP,
	SUB & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_D & ALUS1_D & ALUS2_D WHEN CMP,
	PAS & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_D WHEN MOV,
	SUB & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_D & ALUS1_D & ALUS2_E WHEN CMPI,
	PAS & NB & MEMRD_D & MEM2R_D & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN MOVI,
	ADD & NB & MEMRD_E & MEM2R_E & MEMWR_D & REGWR_E & ALUS1_D & ALUS2_E WHEN LOAD,
	ADD & NB & MEMRD_D & MEM2R_D & MEMWR_E & REGWR_D & ALUS1_D & ALUS2_E WHEN STORE,
	"00000000000000" WHEN POP,
	"00000000000000" WHEN PUSH,
	"00000000000000" WHEN JMP,
	"00000000000000" WHEN JMPEQ,
	"00000000000000" WHEN JMPLE,
	"00000000000000" WHEN JMPGR,
	"00000000000000" WHEN OTHERS;
END ARCHITECTURE Behavioral;