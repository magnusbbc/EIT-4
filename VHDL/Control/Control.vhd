LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--FIX MIXING POP
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
		NOA     : std_logic_vector := x"9"; -- NOT operand A
		LSL     : std_logic_vector := x"A"; -- Logic Shift Left Operand A by Operand B number of bits. Fill with "0"
		LSR     : std_logic_vector := x"B"; -- Logic Shift Right Operand A by Operand B number of bits. Fill with "0"
		ASL     : std_logic_vector := x"C"; -- Arithmetic Shift Left Operand A by Operand B number of bits. Fill with right bit
		ASR     : std_logic_vector := x"D"; -- Arithmetic Shift ri Operand A by Operand B number of bits. Fill with left bit
		PAS     : std_logic_vector := x"E"; -- Passes opeand A
		INC	  : std_logic_vector := x"F"; -- Passes opeand A
		NAA     : std_logic_vector := x"0"; -- Does nothing, does not change flags

		--JUMP Generics
		NB      : std_logic_vector := "0000";
		BR      : std_logic_vector := "0001";
		EQ      : std_logic_vector := "0010";
		LE      : std_logic_vector := "0100";
		GE      : std_logic_vector := "1000";

		--Other Control lines ENABLE
		MEMRD_E : std_logic        := '1';
		MEMWR_E : std_logic        := '1';
		REGWR_E : std_logic        := '1';
		MREWE_E : std_logic			:= '1';
		IMSEL_E : std_logic        := '1';
		DECRR_E : std_logic        := '1';

		--Other Control lines DISABLE
		MEMRD_D : std_logic        := '0';
		MEMWR_D : std_logic        := '0';
		REGWR_D : std_logic        := '0';
		MREWE_D : std_logic			:= '0';
		IMSEL_D : std_logic        := '0';
		DECRR_D : std_logic        := '0';

		--Opcodes
		ADDR    : INTEGER          := 1;
		ADDCR   : INTEGER          := 2;
		SUBR    : INTEGER          := 3;
		NEGR    : INTEGER          := 4;
		ANDR    : INTEGER          := 5;
		ORR     : INTEGER          := 6;
		XORR    : INTEGER          := 7;
		MULTR   : INTEGER          := 8;
		LSLR    : INTEGER          := 9;
		LSRR    : INTEGER          := 10;
		RASR    : INTEGER          := 11;
		LASR    : INTEGER          := 12;
		ADDI    : INTEGER          := 13;
		ADDCI   : INTEGER          := 14;
		SUBI    : INTEGER          := 15;
		NEGI    : INTEGER          := 16;
		ANDI    : INTEGER          := 17;
		ORI     : INTEGER          := 18;
		XORI    : INTEGER          := 19;
		MULTI   : INTEGER          := 20;
		LSLI    : INTEGER          := 21;
		LSRI    : INTEGER          := 22;
		RASI    : INTEGER          := 23;
		LASI    : INTEGER          := 24;
		NOP     : INTEGER          := 25;
		CMP     : INTEGER          := 26;
		MOV     : INTEGER          := 27;
		CMPI    : INTEGER          := 28;
		MOVI    : INTEGER          := 29;
		LOAD    : INTEGER          := 30;
		STORE   : INTEGER          := 31;
		POP     : INTEGER          := 32;
		PUSH    : INTEGER          := 33;
		JMP     : INTEGER          := 34;
		JMPEQ   : INTEGER          := 35;
		JMPLE   : INTEGER          := 36;
		JMPGR   : INTEGER          := 37

	);
	PORT (
		opcode    : IN std_logic_vector(31 DOWNTO 26); -- Operands 1 and 2
		cntSignal : OUT std_logic_vector(13 DOWNTO 0)
	);
END ENTITY control;

ARCHITECTURE Behavioral OF control IS
BEGIN
	WITH to_integer(unsigned(opcode)) SELECT cntSignal <=
	ADD & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN ADDR,
	ADC & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN ADDCR,
	SUB & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN SUBR,
	NOA & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN NEGR,  -- TJEK OM DET ER NOA DER SKAL BRUGES
	OGG & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN ANDR,
	ELL & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN ORR,
	XEL & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN XORR,
	MUL & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN MULTR,
	LSL & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN LSLR,
	LSR & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN LSRR,
	ASL & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN RASR,
	ASR & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN LASR,

	ADD & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN ADDI,
	ADC & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN ADDCI,
	SUB & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN SUBI,
	NOA & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN NEGI,   -- TJEK OM DET ER NOA DER SKAL BRUGES
	OGG & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN ANDI,
	ELL & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN ORI,
	XEL & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN XORI,
	MUL & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN MULTI,
	LSL & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN LSLI,
	LSR & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN LSRI,
	ASL & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN RASI,
	ASR & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN LASI,

	NAA & NB & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_D & DECRR_D WHEN NOP,

	SUB & NB & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_D & DECRR_D WHEN CMP,
	PAS & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN MOV,

	SUB & NB & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_E & DECRR_D WHEN CMPI,
	PAS & NB & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D WHEN MOVI,
	
	ADD & NB & MEMRD_E & MEMWR_D & REGWR_D & MREWE_E & IMSEL_E & DECRR_D WHEN LOAD,
	ADD & NB & MEMRD_D & MEMWR_E & REGWR_D & MREWE_D & IMSEL_E & DECRR_D WHEN STORE,
	
	INC & NB & MEMRD_D & MEMWR_E & REGWR_E & MREWE_D & IMSEL_D & DECRR_D WHEN PUSH,
	--NOP & NB & MEMRD_E & MEMWR_D & REGWR_E & MREWE_E & IMSEL_D & DECRR_E WHEN POP, //IMPORTANT

	PAS & BR & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_E & DECRR_D WHEN JMP,
	PAS & EQ & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_E & DECRR_D WHEN JMPEQ,
	PAS & GE & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_E & DECRR_D WHEN JMPLE,
	PAS & LE & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_E & DECRR_D WHEN JMPGR,
	"00000000000000" WHEN OTHERS;
END ARCHITECTURE Behavioral;