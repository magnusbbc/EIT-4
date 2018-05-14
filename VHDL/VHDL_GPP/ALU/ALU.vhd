#include "Control.hvhd"
#include "Config.hvhd"
------------------------------------------------------------------------------------
---- Engineer: Peter Fisker
---- Module Name: ALU
--
--
---- Description:
-- This is a simple ALU.
-- It has:
-- OPERATIONS:
-- Add
-- ADC Adds two operands, and the prevous overflow flag * To be implemented
-- Sub
-- Multiplier 			
-- AND
-- OR
-- XOR
-- Negate A				* To be implemented
-- Negate B				* To be implemented
-- Logic shift left
-- Logic shift right
-- Arith shift right 
-- Pass through
-- ICA Increments A
-- ICB Increments B
-- NOP
-- Convert signed to unsigned
-- Convert unsigned to signed
--
--The ALU does not depend on a clock signal
--
-- FLAGS:
-- Zero flag
-- Overflow flag
-- Signed flag
-- Parity flag
-- Carry flag
------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE ieee.numeric_std.ALL;


ENTITY ALU IS

	PORT (
		operand_a, operand_b : IN std_logic_vector(15 DOWNTO 0); -- Operands 1 and 2
		operation            : IN std_logic_vector(5 DOWNTO 0); --operation to perform

		overflow_flag        : OUT std_logic; -- Flag raised when overflow is present
		signed_flag          : OUT std_logic; -- Flag raised when negative result
		zero_flag            : OUT std_logic; -- Flag raised when result is zero
		parity_flag          : OUT std_logic; -- Flag raised when number of 1's in result is odd. 
		carry_flag           : OUT std_logic; -- Flag raised when carry is present			

		result               : OUT std_logic_vector(15 DOWNTO 0) --Output based on the two operands and operation port
	);
END ENTITY ALU;

ARCHITECTURE Behavioral OF ALU IS

	SIGNAL mult_temp    : std_LOGIC_VECTOR(31 DOWNTO 0); -- Used to store results from multiplier
	SIGNAL temp         : std_logic_vector(16 DOWNTO 0); -- Used to store signed results. 
	SIGNAL unsigned_emp : std_logic_vector(16 DOWNTO 0); -- used to store unsigned results.

BEGIN

	--Altera Multiplier IP Core
	multiplier : ENTITY work.Multiplier_1
		PORT MAP(
			dataa  => operand_a,
			datab  => operand_b,
			result => mult_temp
		);

	
	--------------------------------------------
	-- Arithmetic:
	-- Performs ALU operations.
	--
	-- Uses the two operands in combination
	-- with the operation signal to calculate
	-- an output
	--------------------------------------------
	Arithmetic : PROCESS (operand_a, operand_b, operation, temp) IS
		VARIABLE Parity : std_logic;
	BEGIN
		temp         <= (OTHERS         => '0');
		unsigned_emp <= (OTHERS => '0');

		IF (to_integer(unsigned(operation)) = NAA) THEN

		ELSE
			CASE to_integer(unsigned(operation)) IS
				WHEN ADD => -- Returns operand_a + operand_b
					-- Here, you first need to cast your input vectors to signed or unsigned
					-- (according to your needs). Then, you will be allowed to add them.
					-- The result will be a signed or unsigned vector, so you won't be able
					-- to assign it directly to your output vector. You first need to cast
					-- the result to std_logic_vector.

					temp         <= std_logic_vector(signed("0" & operand_a) + signed(operand_b)); -- We append "0" to the first operand before adding the two operands.
					unsigned_emp <= std_logic_vector(unsigned("0" & operand_a) + unsigned(operand_b)); -- We use an unsigned result to determine carry-bit if any. 
					result       <= temp(15 DOWNTO 0);
					-- -- http://www.c-jump.com/CIS77/CPU/Overflow/lecture.html Good source about overflow detection

				WHEN SUB => -- Returns operand_a - operand_b
					temp         <= std_logic_vector(signed("0" & operand_a) - signed(operand_b));
					unsigned_emp <= std_logic_vector(unsigned("0" & operand_a) - unsigned(operand_b));

					result       <= temp(15 DOWNTO 0);

				WHEN MUL => -- Returns operand_a * operand_b
					temp   <= ("0" & (mult_temp(15 DOWNTO 0))); -- When opcode for mult is chosen, output from multiplier is routed to the output of the ALU.
					result <= temp(15 DOWNTO 0);

				WHEN OGG => -- Returns operand_a AND operand_b
					temp   <= ("0" & (operand_a AND operand_b));
					result <= temp(15 DOWNTO 0);

				WHEN ELL => -- Returns operand_a OR operand_b
					temp   <= ("0" & (operand_a OR operand_b));
					result <= temp(15 DOWNTO 0);

				WHEN XEL => -- Returns operand_a XOR operand_b
					temp   <= ("0" & (operand_a XOR operand_b));
					result <= temp(15 DOWNTO 0);

				WHEN IKA => -- Negates operand A
					temp   <= std_logic_vector("0" & ((NOT signed(operand_a)) + "0000000000000001"));
					result <= temp(15 DOWNTO 0);

				WHEN IKB => -- Negates operand A
					temp   <= std_logic_vector("0" & ((NOT signed(operand_b)) + "0000000000000001"));
					result <= temp(15 DOWNTO 0);

				WHEN NOA => -- Returns NOT operand_a
					temp   <= ("0" & (NOT (operand_a)));
					result <= temp(15 DOWNTO 0);

				WHEN NOB => -- Returns NOT operand_a
					temp   <= ("0" & (NOT (operand_b)));
					result <= temp(15 DOWNTO 0);

				WHEN LSL => -- Logic Shift Left operand_a by operand_b number of bits. Fill with "0"
					temp   <= std_logic_vector("0" & (shift_left(unsigned(operand_a), to_integer(unsigned(operand_b)))));
					result <= temp(15 DOWNTO 0);

				WHEN LSR => -- Logic Shift Right operand_a by operand_b number of bits. Fill with "0"
					temp   <= std_logic_vector("0" & (shift_right(unsigned(operand_a), to_integer(unsigned(operand_b)))));
					result <= temp(15 DOWNTO 0);

				WHEN ASR => -- Arithmetic Shift right operand_a by operand_b number of bits. Fill with "sign-bit"
					temp   <= std_logic_vector("0" & (shift_right(signed(operand_a), to_integer(unsigned(operand_b)))));
					result <= temp(15 DOWNTO 0);

				WHEN ICA => -- Increments operand_a
					temp   <= std_logic_vector("0" & (signed(operand_a) + 1));
					result <= temp(15 DOWNTO 0);

				WHEN ICB => -- Increments operand_b
					temp   <= std_logic_vector("0" & (signed(operand_b) + 1));
					result <= temp(15 DOWNTO 0);

				WHEN PAS => -- Lets operand_a pass through the ALU
					temp   <= ("0" & operand_a);
					result <= operand_a;

				WHEN PBS => -- Lets operand_b pass through the ALU
					temp   <= ("0" & operand_b);
					result <= operand_b;

				--WHEN UTS => 
				WHEN OTHERS =>

			END CASE;

			Parity := '0';
			carry_flag    <= '0';
			parity_flag   <= '0';
			signed_flag   <= '0';
			overflow_flag <= '0';
			zero_flag     <= '0';

			IF (to_integer(unsigned(operation)) = ADD) THEN
				overflow_flag <= ((operand_a(15)) OR (temp(15))) AND ((NOT (operand_b(15))) OR(NOT (temp(15)))) AND ((NOT (operand_a(15))) OR ((operand_b(15))));
			ELSIF (to_integer(unsigned(operation)) = SUB) THEN
				overflow_flag <= ((operand_a(15)) OR (operand_b(15))) AND ((NOT (operand_b(15))) OR((temp(15)))) AND ((NOT (operand_a(15))) OR (NOT (temp(15))));
			ELSIF (to_integer(unsigned(operation)) = ICA) THEN
				overflow_flag <= ((NOT operand_a(15)) AND temp(15));
			ELSIF (to_integer(unsigned(operation)) = ICB) THEN
				overflow_flag <= ((NOT operand_b(15)) AND temp(15));

			ELSIF (to_integer(unsigned(operation)) = MUL) THEN -- This dont work??? 
				IF (to_integer(signed(mult_temp(31 DOWNTO 16))) > 0) THEN
					overflow_flag <= '1';
				END IF;
			END IF;

			carry_flag  <= unsigned_emp(16);
			signed_flag <= temp(15);

			IF (temp(15 DOWNTO 0) = "0000000000000000") THEN
				zero_flag <= '1';
			END IF;

			FOR I IN 0 TO 15 LOOP
				Parity := Parity XOR temp(I);
			END LOOP;
			parity_flag <= Parity;

		END IF;

	END PROCESS;

END ARCHITECTURE Behavioral;