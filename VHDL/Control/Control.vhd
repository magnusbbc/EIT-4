#include "Control.hvhd"
#include "Config.hvhd"
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--FIX MIXING POP
ENTITY Control IS
	PORT (
		opcode : IN std_logic_vector(31 DOWNTO 26);
		cntSignal : OUT std_logic_vector(CONTROL_SIZE DOWNTO 0)
	);
END ENTITY Control;

ARCHITECTURE Behavioral OF Control IS
BEGIN
	WITH to_integer(unsigned(opcode)) SELECT cntSignal <=
	std_logic_vector(to_unsigned(ADD, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ADDR,
	std_logic_vector(to_unsigned(ADC, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ADDCR,
	std_logic_vector(to_unsigned(SUB, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN SUBR,
	std_logic_vector(to_unsigned(NOA, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN NEGR, -- TJEK OM DET ER NOA DER SKAL BRUGES
	std_logic_vector(to_unsigned(OGG, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ANDR,
	std_logic_vector(to_unsigned(ELL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ORR,
	std_logic_vector(to_unsigned(XEL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN XORR,
	std_logic_vector(to_unsigned(MUL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN MULTR,
	std_logic_vector(to_unsigned(LSL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN LSLR,
	std_logic_vector(to_unsigned(LSR, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN LSRR,
	std_logic_vector(to_unsigned(ASL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN RASR,
	std_logic_vector(to_unsigned(ASR, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN LASR,

	std_logic_vector(to_unsigned(ADD, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ADDI,
	std_logic_vector(to_unsigned(ADC, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ADDCI,
	std_logic_vector(to_unsigned(SUB, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN SUBI,
	std_logic_vector(to_unsigned(NOA, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN NEGI, -- TJEK OM DET ER NOA DER SKAL BRUGES
	std_logic_vector(to_unsigned(OGG, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ANDI,
	std_logic_vector(to_unsigned(ELL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN ORI,
	std_logic_vector(to_unsigned(XEL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN XORI,
	std_logic_vector(to_unsigned(MUL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN MULTI,
	std_logic_vector(to_unsigned(LSL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN LSLI,
	std_logic_vector(to_unsigned(LSR, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN LSRI,
	std_logic_vector(to_unsigned(ASL, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN RASI,
	std_logic_vector(to_unsigned(ASR, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN LASI,

	std_logic_vector(to_unsigned(NAA, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN NOP,

	std_logic_vector(to_unsigned(SUB, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN CMP,
	std_logic_vector(to_unsigned(PAS, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN MOV,

	std_logic_vector(to_unsigned(SUB, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN CMPI,
	std_logic_vector(to_unsigned(17, 6))  & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_E & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN MOVI,

	std_logic_vector(to_unsigned(ADD, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_E & MEMWR_D & REGWR_E & MEMRB_E & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_E & HALTP_D WHEN LOAD,
	std_logic_vector(to_unsigned(ADD, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_E & REGWR_D & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_E & MW2PC_D & HALTP_D WHEN STORE,

	std_logic_vector(to_unsigned(ICA, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_E & REGWR_E & MEMRB_D & IMSEL_D & PUSHO_E & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN PUSH,
	std_logic_vector(to_unsigned(NOP, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_E & MEMWR_D & REGWR_E & MEMRB_E & IMSEL_D & PUSHO_D & POP_E & RWSWI_D & MW2PC_E & HALTP_D WHEN POP, --IMPORTANT

	std_logic_vector(to_unsigned(PBS, 6)) & std_logic_vector(to_unsigned(BR, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN JMP,
	std_logic_vector(to_unsigned(PBS, 6)) & std_logic_vector(to_unsigned(EQ, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN JMPEQ,
	std_logic_vector(to_unsigned(PBS, 6)) & std_logic_vector(to_unsigned(LE, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN JMPLE,
	std_logic_vector(to_unsigned(PBS, 6)) & std_logic_vector(to_unsigned(NQ, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MEMRB_D & IMSEL_E & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_D WHEN JMPNQ,

	std_logic_vector(to_unsigned(NAA, 6)) & std_logic_vector(to_unsigned(NB, 3)) & MEMRD_D & MEMWR_D & REGWR_D & MEMRB_D & IMSEL_D & PUSHO_D & POP_D & RWSWI_D & MW2PC_D & HALTP_E WHEN HALT,
	(OTHERS => '0') WHEN OTHERS;
END ARCHITECTURE Behavioral;