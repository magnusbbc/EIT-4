LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--FIX MIXING POP
ENTITY Control IS
	GENERIC (
		--ALU Generics
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
		NAA : integer := 20;-- Does nothing, does not change flags
		
		--JUMP Generics
		NB      : integer := 0;
		BR      : integer := 1;
		EQ      : integer := 2;
		LE      : integer := 3;
		NQ      : integer := 4;

		--Other Control lines ENABLE
		MEMRD_E : std_logic        := '1';
		MEMWR_E : std_logic        := '1';
		REGWR_E : std_logic        := '1';
		MREWE_E : std_logic			:= '1';
		IMSEL_E : std_logic        := '1';
		DECRR_E : std_logic        := '1';
		RWSWI_E : std_logic        := '1'; --Read/Write Switch
		MW2PC_E : std_logic			:= '1'; --Memory Wrie to PC
		HALTP_E : std_logic			:= '1';

		--Other Control lines DISABLE
		MEMRD_D : std_logic        := '0';
		MEMWR_D : std_logic        := '0';
		REGWR_D : std_logic        := '0';
		MREWE_D : std_logic			:= '0';
		IMSEL_D : std_logic        := '0';
		DECRR_D : std_logic        := '0';
		RWSWI_D : std_logic        := '0';
		MW2PC_D : std_logic			:= '0';
		HALTP_D : std_logic			:= '0';
		
		--Opcodes
		NOP     : INTEGER          := 0;
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
		JMPNQ   : INTEGER          := 37;
		HALT	  : INTEGER				:= 38

	);
	PORT (
		opcode    : IN std_logic_vector(31 DOWNTO 26); -- Operands 1 and 2
		cntSignal : OUT std_logic_vector(17 DOWNTO 0)
	);
END ENTITY control;

ARCHITECTURE Behavioral OF control IS
BEGIN
	WITH to_integer(unsigned(opcode)) SELECT cntSignal <=
	std_logic_vector(to_unsigned(ADD, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ADDR,
	std_logic_vector(to_unsigned(ADC, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ADDCR,
	std_logic_vector(to_unsigned(SUB, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN SUBR,
	std_logic_vector(to_unsigned(NOA, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN NEGR,  -- TJEK OM DET ER NOA DER SKAL BRUGES
	std_logic_vector(to_unsigned(OGG, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ANDR,
	std_logic_vector(to_unsigned(ELL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ORR,
	std_logic_vector(to_unsigned(XEL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN XORR,
	std_logic_vector(to_unsigned(MUL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN MULTR,
	std_logic_vector(to_unsigned(LSL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN LSLR,
	std_logic_vector(to_unsigned(LSR, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN LSRR,
	std_logic_vector(to_unsigned(ASL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN RASR,
	std_logic_vector(to_unsigned(ASR, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN LASR,
	
	std_logic_vector(to_unsigned(ADD, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ADDI,
	std_logic_vector(to_unsigned(ADC, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ADDCI,
	std_logic_vector(to_unsigned(SUB, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN SUBI,
	std_logic_vector(to_unsigned(NOA, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN NEGI,   -- TJEK OM DET ER NOA DER SKAL BRUGES
	std_logic_vector(to_unsigned(OGG, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ANDI,
	std_logic_vector(to_unsigned(ELL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ORI,
	std_logic_vector(to_unsigned(XEL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN XORI,
	std_logic_vector(to_unsigned(MUL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN MULTI,
	std_logic_vector(to_unsigned(LSL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN LSLI,
	std_logic_vector(to_unsigned(LSR, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN LSRI,
	std_logic_vector(to_unsigned(ASL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN RASI,
	std_logic_vector(to_unsigned(ASR, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN LASI,
	
	std_logic_vector(to_unsigned(NAA, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN NOP,
	
	std_logic_vector(to_unsigned(SUB, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN CMP,
	std_logic_vector(to_unsigned(PAS, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN MOV,
	
	std_logic_vector(to_unsigned(SUB, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN CMPI,
	std_logic_vector(to_unsigned(PBS, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN MOVI,
	
	std_logic_vector(to_unsigned(ADD, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_E & MEMWR_D & REGWR_D & MREWE_E & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_E & HALTP_D WHEN LOAD,
	std_logic_vector(to_unsigned(ADD, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_E & REGWR_D & MREWE_D & IMSEL_E & DECRR_D & RWSWI_E & MW2PC_D & HALTP_D WHEN STORE,
	
	std_logic_vector(to_unsigned(ICA, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_E & REGWR_E & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN PUSH,
	std_logic_vector(to_unsigned(NOP, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_E & MEMWR_D & REGWR_E & MREWE_E & IMSEL_D & DECRR_E & RWSWI_D & MW2PC_D & HALTP_D WHEN POP, --IMPORTANT
	
	std_logic_vector(to_unsigned(PBS, 6)) & std_logic_vector(to_unsigned(BR, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN JMP,
	std_logic_vector(to_unsigned(PBS, 6)) & std_logic_vector(to_unsigned(EQ, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN JMPEQ,
	std_logic_vector(to_unsigned(PBS, 6)) & std_logic_vector(to_unsigned(LE, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN JMPLE,
	std_logic_vector(to_unsigned(PBS, 6)) & std_logic_vector(to_unsigned(NQ, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_E & DECRR_D & RWSWI_D & MW2PC_D & HALTP_D WHEN JMPNQ,
	
	std_logic_vector(to_unsigned(NAA, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MREWE_D & IMSEL_D & DECRR_D & RWSWI_D & MW2PC_D & HALTP_E WHEN HALT,
	"000000000000000000" WHEN OTHERS;
END ARCHITECTURE Behavioral;