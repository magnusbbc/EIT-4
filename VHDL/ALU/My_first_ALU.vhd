------------------------------------------------------------------------------------
---- Company:
---- Engineer:
----
---- Create Date: 10:53:18 03/23/2018
---- Design Name:
---- Module Name: My_first_ALU - Behavioral
---- Project Name:
---- Target Devices:
---- Tool versions:
---- Description:
----
---- Dependencies:
----
---- Revision:
---- Revision 0.01 - File Created
---- Additional Comments:
----
---- Denne fil ligger i GIT-mappe
------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE ieee.numeric_std.ALL;
-- This is a simple ALU.
-- It has:
-- OPERATIONS:
-- Add
-- ADC Adds two operands, and the prevous overflow flag * To be implemented
-- Sub
-- Multiplier 			*To be implemented
-- AND
-- OR
-- XOR
-- Negate A				* To be implemented
-- Negate B				* To be implemented
-- Logic shift left
-- Logic shift right
-- Arith shift left  * To be implemented
-- Arith shift right 
-- Pass through
-- ICA Increments A
-- ICB Increments B
-- NOP 

-- FLAGS
-- Zero flag
-- Overflow flag
-- Signed flag
-- Parity flag

ENTITY My_first_ALU IS
	GENERIC 
	(
		ADD : INTEGER := 1;  -- Adds two operands
		ADC : INTEGER := 2;  -- Adds two operands, and the prevous overflow flag
		SUB : INTEGER := 3;  -- Subtracts two operands
		MUL : INTEGER := 4;  -- Multiplies two operands, Signed vector multiplied by signed integer. 
		OGG : INTEGER := 5;  -- ANDs two operands
		ELL : INTEGER := 6;  -- ORs two operands
		XEL : INTEGER := 7;  -- XORs two operands
		IKA : INTEGER := 8;  -- NEGATES operand A
		IKB : INTEGER := 9;  -- NEGATES operand B
		NOA : INTEGER := 10; -- NOT operand A
		NOB : INTEGER := 11; -- NOT operand B
		LSL : INTEGER := 12; -- Logic Shift Left Operand A by Operand B number of bits. Fill with "0"
		LSR : INTEGER := 13; -- Logic Shift Right Operand A by Operand B number of bits. Fill with "0"
		ASL : INTEGER := 14; -- Arithmetic Shift Left Operand A by Operand B number of bits. Fill with right bit
		ASR : INTEGER := 15; -- Arithmetic Shift right Operand A by Operand B number of bits. Fill with 1
		PAS : INTEGER := 16; -- Passes operand A
		PBS : INTEGER := 17; -- Passes operand B
		ICA : INTEGER := 18; -- Increments operand A
		ICB : INTEGER := 19; -- Increments operand B
		NAA : INTEGER := 20  -- Does nothing, does not change flags
	);
	PORT 
	(
		Operand1, Operand2 : IN std_logic_vector(15 DOWNTO 0); -- Operands 1 and 2
		Operation          : IN std_logic_vector(5 DOWNTO 0);

		Parity_Flag        : OUT std_logic; -- Flag raised when a carry is present after adding
		Signed_Flag        : OUT std_logic; -- Flag that does something?
		Overflow_Flag      : OUT std_logic; -- Flag raised when overflow is present
		Zero_Flag          : OUT std_logic; -- Flag raised when operands are equal?
 
		Flags              : OUT std_logic_vector(3 DOWNTO 0);
		Result             : OUT std_logic_vector(15 DOWNTO 0)
	);
END ENTITY My_first_ALU;

ARCHITECTURE Behavioral OF My_first_ALU IS

	SIGNAL Temp : std_logic_vector(16 DOWNTO 0); -- Used to store results when adding. Has room for the carry
 
BEGIN
	PROCESS (Operand1, Operand2, Operation, temp) IS
	VARIABLE Parity : std_logic;
	BEGIN
		IF (to_integer(unsigned(Operation)) = NAA) THEN
 
		ELSE
			Parity := '0';
			Parity_Flag   <= '0';
			Signed_Flag   <= '0';
			Overflow_Flag <= '0';
			Zero_Flag     <= '0'; 
			CASE to_integer(unsigned(Operation)) IS
				WHEN ADD => -- res = op1 + op2
					-- Here, you first need to cast your input vectors to signed or unsigned
					-- (according to your needs). Then, you will be allowed to add them.
					-- The result will be a signed or unsigned vector, so you won't be able
					-- to assign it directly to your output vector. You first need to cast
					-- the result to std_logic_vector.
 
					Temp <= std_logic_vector(signed("0" & Operand1) + signed(Operand2)); -- We append "0" to the first operand before adding the two operands.
					-- This is done to make room for the sign-bit/carry bit.
					Result <= Temp(15 DOWNTO 0);
					-- Overflow_Flag <= ((Operand1(15)) OR (Temp(15))) AND ((NOT (Operand2(15))) OR(NOT (Temp(15)))) AND ((NOT (Operand1(15))) OR ((Operand2(15))));
					-- -- http://www.c-jump.com/CIS77/CPU/Overflow/lecture.html Her stï¿½r om overflow detection
 
 
				WHEN SUB => -- Returns Operand1 - Operand2
					Temp   <= std_logic_vector(signed("0" & Operand1) - signed(Operand2));
					Result <= Temp(15 DOWNTO 0);
				
--				When MUL => -- Returns Operand1 * Operand2
--					Temp <= std_logic_vector("0" & (signed(Operand1)* to_integer(signed(Operand2))));
--					Result <= Temp(15 DOWNTO 0);
					
				WHEN OGG => -- Returns Operand1 AND Operand2
					Temp   <= ("0" & (Operand1 AND Operand2));
					Result <= Temp(15 DOWNTO 0);
 
				WHEN ELL => -- Returns Operand1 OR Operand2
					Temp   <= ("0" & (Operand1 OR Operand2));
					Result <= Temp(15 DOWNTO 0);
 
				WHEN XEL => -- Returns Operand1 XOR Operand2
					Temp   <= ("0" & (Operand1 XOR Operand2));
					Result <= Temp(15 DOWNTO 0);
 
					-- When IKA => -- Negates operand A
					-- Temp <= ("0" &((NOT Operand1)+1));
					-- Result <= Temp(15 downto 0);
 
					-- When IKB => -- Negates operand A
					-- Temp <= ("0" &((NOT Operand2)+1));
					-- Result <= Temp(15 downto 0); 
 
				WHEN NOA => -- Returns NOT Operand1
					Temp   <= ("0" & (NOT Operand1));
					Result <= Temp(15 DOWNTO 0);
 
				WHEN NOB => -- Returns NOT Operand1
					Temp   <= ("0" & (NOT Operand2));
					Result <= Temp(15 DOWNTO 0);
 
				WHEN LSL => -- Logic Shift Left Operand1 by Operand2 number of bits. Fill with "0"
					Temp   <= std_logic_vector("0" & (shift_left(unsigned(Operand1), to_integer(unsigned(Operand2)))));
					Result <= Temp(15 DOWNTO 0);
 
				WHEN LSR => -- Logic Shift Right Operand1 by Operand2 number of bits. Fill with "0"
					Temp   <= std_logic_vector("0" & (shift_right(unsigned(Operand1), to_integer(unsigned(Operand2)))));
					Result <= Temp(15 DOWNTO 0);
					
					-- WHEN LSL => -- Arithmetic Shift Left Operand1 by Operand2 number of bits. Fill with right bit
					-- Overflow_temp <= std_logic_vector(signed(Operand1) sla signed(Operand2));
					-- Result <= Overflow_temp(15 DOWNTO 0);
	
				WHEN ASR => -- Arithmetic Shift right Operand1 by Operand2 number of bits. Fill with "1"
					Temp   <= std_logic_vector("0" & (shift_right(signed(Operand1), to_integer(unsigned(Operand2)))));
					Result <= Temp(15 DOWNTO 0);
 
				WHEN ICA => 
					Temp   <= std_logic_vector("0" & (signed(Operand1) + 1));
					Result <= Temp(15 DOWNTO 0);
 
				WHEN ICB => 
					Temp          <= std_logic_vector("0" & (signed(Operand2) + 1));
					Result        <= Temp(15 DOWNTO 0);
 
					-- WHEN DEC_A =>
					-- Result <= std_logic_vector(signed(Operand1) - 1); 
					-- -- Overflow_flag <= ((NOT Overflow_temp(15)) AND Operand1(15));
					-- -- 
				WHEN PAS => 
					Temp   <= ("0" & Operand1);
					Result <= Operand1;
 
				WHEN PBS => 
					Temp   <= ("0" & Operand2);
					Result <= Operand2; 
 
				WHEN OTHERS => 
 
			END CASE;
 
			IF (to_integer(unsigned(Operation)) = ADD) THEN
				Overflow_Flag <= ((Operand1(15)) OR (Temp(15))) AND ((NOT (Operand2(15))) OR(NOT (Temp(15)))) AND ((NOT (Operand1(15))) OR ((Operand2(15))));
			ELSIF (to_integer(unsigned(Operation)) = SUB) THEN
				Overflow_Flag <= ((Operand1(15)) OR (Operand2(15))) AND ((NOT (Operand2(15))) OR((Temp(15)))) AND ((NOT (Operand1(15))) OR (NOT (Temp(15))));
			ELSIF (to_integer(unsigned(Operation)) = ICA ) THEN
				Overflow_flag <= ((NOT Operand1(15)) AND Temp(15));
			ELSIF (to_integer(unsigned(Operation)) = ICB ) THEN
					Overflow_flag <= ((NOT Operand2(15)) AND Temp(15));
			END IF;
 
			Signed_Flag <= Temp(15);
 
			IF (Temp(15 DOWNTO 0) = "0000000000000000") THEN
				Zero_Flag <= '1'; 
			END IF;
			
			-- Here magic begins
			FOR I IN 0 TO 15 LOOP
				Parity := Parity XOR Temp(I);
			END LOOP;
 
			Parity_Flag <= Parity; 
			-- Here magic ends 
		END IF;
 
	END PROCESS;

END ARCHITECTURE Behavioral;