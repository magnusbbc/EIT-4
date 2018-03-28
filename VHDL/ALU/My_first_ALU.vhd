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
------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
-- This is a simple ALU.
-- It can:
-- Add
-- Sub
-- AND
-- OR
-- XOR
-- Negate
-- Add + 1 ???

ENTITY My_first_ALU IS
	GENERIC 
	(
		ADD    : std_logic_vector := "0000";
		SUB    : std_logic_vector := "0001";
		OG     : std_logic_vector := "0010";
		ELLER  : std_logic_vector := "0011";
		XELLER : std_logic_vector := "0100";
		NOT_A  : std_logic_vector := "0101";
		NOT_B  : std_logic_vector := "0110"
	);
	PORT 
	(
		Operand1, Operand2 : IN std_logic_vector(15 DOWNTO 0); -- Operands 1 and 2
		Operation          : IN std_logic_vector(3 DOWNTO 0);

		Carry_Out          : OUT std_logic; -- Flag raised when a carry is present after adding
		Signed_Flag        : OUT std_logic; -- Flag that does something?
		Overflow_Flag      : OUT std_logic; -- Flag raised when overflow is present
		Zero_Flag          : OUT std_logic; -- Flag raised when operands are equal?

		Result             : OUT std_logic_vector(15 DOWNTO 0)
	);
END ENTITY My_first_ALU;

ARCHITECTURE Behavioral OF My_first_ALU IS

	SIGNAL Temp          : std_logic_vector(16 DOWNTO 0); -- Used to store results when adding. Has room for the carry
	SIGNAL Overflow_temp : std_logic_vector(15 DOWNTO 0); -- Used to store the value of the overflow flag.
 
BEGIN
	PROCESS (Operand1, Operand2, Operation, temp) IS
	BEGIN
		Signed_Flag   <= '0';
		Overflow_Flag <= '0';
		Zero_Flag     <= '0';
		CASE Operation IS
			WHEN ADD => -- res = op1 + op2, flag = carry = overflow // Det med flaget her fanger jeg ikke endnu.

				-- Here, you first need to cast your input vectors to signed or unsigned
				-- (according to your needs). Then, you will be allowed to add them.
				-- The result will be a signed or unsigned vector, so you won't be able
				-- to assign it directly to your output vector. You first need to cast
				-- the result to std_logic_vector.

				Temp <= std_logic_vector(signed("0" & Operand1) + signed(Operand2)); -- We append "0" to the first operand before adding the two operands.
				-- This is done to make room for the sign-bit/carry bit.
				Result        <= Temp(15 DOWNTO 0);
				Carry_Out     <= Temp(16);
				Overflow_Flag <= ((Operand1(15)) OR (Temp(15))) AND ((NOT (Operand2(15))) OR(NOT (Temp(15)))) AND ((NOT (Operand1(15))) OR ((Operand2(15)))); 
				-- http://www.c-jump.com/CIS77/CPU/Overflow/lecture.html Her står om overflow detection
 
			WHEN SUB => -- res = |op1 - op2|, flag = 1 iff op2 > op1, Zero = 1 if op2 = op1
				IF (Operand1 > Operand2) THEN
					Temp          <= std_logic_vector(signed("0" & Operand1) - signed(Operand2));
					Result        <= Temp(15 downto 0);
					Signed_Flag   <= '0'; -- Flag raised if result is negative
					Overflow_Flag <= ((Operand1(15)) OR (Operand2(15))) AND ((NOT (Operand2(15))) OR((Temp(15)))) AND ((NOT (Operand1(15))) OR (NOT (Temp(15))));
 
				ELSE
					Temp          <= std_logic_vector(signed("0" & Operand1) - signed(Operand2));
					Result        <= Temp(15 downto 0);
					Overflow_Flag <= ((Operand1(15)) OR (Operand2(15))) AND ((NOT (Operand2(15))) OR((Temp(15)))) AND ((NOT (Operand1(15))) OR (NOT (Temp(15))));
					IF (Operand1 < Operand2) THEN
						Signed_Flag <= '1'; -- Flag raised if result is negative
					ELSE
						Zero_Flag <= '1';
					END IF;
				END IF;

			WHEN OG => 
				Result <= Operand1 AND Operand2;

			WHEN ELLER => 
				Result <= Operand1 OR Operand2;

			WHEN XELLER => 
				Result <= Operand1 XOR Operand2;

			WHEN NOT_A => 
				Result <= NOT Operand1;

			WHEN NOT_B => 
				Result <= NOT Operand2;

			WHEN OTHERS => -- res = op1 + op2 + 1, flag = 0 // Fatter ikke hvad denne gør endnu
				Temp   <= std_logic_vector((signed("0" & Operand1) + signed(NOT Operand2)) + 1);
				Result <= temp(15 DOWNTO 0);
				Signed_Flag   <= temp(16);
		END CASE;
	END PROCESS;

END ARCHITECTURE Behavioral;