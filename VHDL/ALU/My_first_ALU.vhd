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
-- Sub
-- AND
-- OR
-- XOR
-- Negate A
-- Negate B
-- Logic shift left * To be implemented
-- Logic shift right * To be implemented
-- Arith shift left * To be implemented
-- Arith shift right * To be implemented
-- Pass through      
-- NOP					

-- FLAGS
-- Zero flag
-- Overflow flag
-- Signed flag
-- Parity flag 

ENTITY My_first_ALU IS
	GENERIC (
		ADD : std_logic_vector := x"1"; -- Adds two operands
		ADC : std_logic_vector := x"2"; -- Adds two operands, and the prevous overflow flag
		SUB : std_logic_vector := x"3"; -- Subtracts two operands
		MUL : std_logic_vector := x"4"; -- Multiplies two operands
		OGG : std_logic_vector := x"5"; -- ANDs two operands
		ELL : std_logic_vector := x"6"; -- ORs two operands
		XEL : std_logic_vector := x"7"; -- XORs two operands
		IKK : std_logic_vector := x"8"; -- NEGATES operand A
		NOA : std_logic_vector := x"9"; -- NOT operand A
		LSL : std_logic_vector := x"A"; -- Logic Shift Left Operand A by Operand B number of bits. Fill with "0"
		LSR : std_logic_vector := x"B"; -- Logic Shift Right Operand A by Operand B number of bits. Fill with "0"
		ASL : std_logic_vector := x"C"; -- Arithmetic Shift Left Operand A by Operand B number of bits. Fill with right bit
		ASR : std_logic_vector := x"D"; -- Arithmetic Shift ri Operand A by Operand B number of bits. Fill with left bit
		PAS : std_logic_vector := x"E"; -- Passes operand A
		INC : std_logic_vector := x"F"; -- Increments operand A
		NAA : std_logic_vector := x"0" -- Does nothing, does not change flags
	);
	PORT (
		Operand1, Operand2 : IN std_logic_vector(15 DOWNTO 0); -- Operands 1 and 2
		Operation          : IN std_logic_vector(3 DOWNTO 0);

		Parity_Flag        : OUT std_logic; -- Flag raised when a carry is present after adding
		Signed_Flag        : OUT std_logic; -- Flag that does something?
		Overflow_Flag      : OUT std_logic; -- Flag raised when overflow is present
		Zero_Flag          : OUT std_logic; -- Flag raised when operands are equal?
		
		Flags 				: out std_logic_vector(3 downto 0);
		Result             : OUT std_logic_vector(15 DOWNTO 0)
	);
END ENTITY My_first_ALU;

ARCHITECTURE Behavioral OF My_first_ALU IS

	SIGNAL Temp          : std_logic_vector(16 DOWNTO 0); -- Used to store results when adding. Has room for the carry
	SIGNAL Overflow_temp : std_logic_vector(15 DOWNTO 0); -- Used to store the value of the overflow flag.
	
BEGIN
	PROCESS (Operand1, Operand2, Operation, temp) IS
	variable Parity 		: std_logic; 
	BEGIN
		If (operation = NAA) theN
			
		ELSE 
			Parity 		  := '0';
			Parity_Flag   <= '0';
			Signed_Flag   <= '0';
			Overflow_Flag <= '0';
			Zero_Flag     <= '0';	
			CASE Operation IS
				WHEN ADD => -- res = op1 + op2
					-- Here, you first need to cast your input vectors to signed or unsigned
					-- (according to your needs). Then, you will be allowed to add them.
					-- The result will be a signed or unsigned vector, so you won't be able
					-- to assign it directly to your output vector. You first need to cast
					-- the result to std_logic_vector.
	
					Temp <= std_logic_vector(signed("0" & Operand1) + signed(Operand2)); -- We append "0" to the first operand before adding the two operands.
					-- This is done to make room for the sign-bit/carry bit.
					Result        <= Temp(15 DOWNTO 0);
	--				Overflow_Flag <= ((Operand1(15)) OR (Temp(15))) AND ((NOT (Operand2(15))) OR(NOT (Temp(15)))) AND ((NOT (Operand1(15))) OR ((Operand2(15))));
	--				-- http://www.c-jump.com/CIS77/CPU/Overflow/lecture.html Her st�r om overflow detection
					
					
				When SUB => -- Returns Operand1 - Operand2 
					Temp          <= std_logic_vector(signed("0" & Operand1) - signed(Operand2));
					Result        <= Temp(15 DOWNTO 0);
					
				WHEN OGG => -- Returns Operand1 AND Operand2
					Temp 				<= ("0" & (Operand1 AND Operand2));
					Result        <= Temp(15 DOWNTO 0);
					
				WHEN ELL => -- Returns Operand1 OR Operand2
					Temp 			<= ("0" & (Operand1 OR Operand2));
					Result        <= Temp(15 downto 0);
					
				WHEN XEL => -- Returns Operand1 XOR Operand2
					Temp 				<= ("0" & (Operand1 XOR Operand2));
					Result        <= Temp(15 downto 0);
					
--				When IKK =>  -- Negates operand A
--					Temp 			<= ("0" &((NOT Operand1)+1));
--					Result        <= Temp(15 downto 0);		
			
				WHEN NOA => -- Returns NOT Operand1
					Temp 			  <= ("0" & (NOT Operand1));
					Result        <= Temp(15 downto 0);
				
--				WHEN NOB => -- Returns NOT Operand1
--					Temp 			  <= ("0" & (NOT Operand2));
--					Result        <= Temp(15 downto 0);
										
				WHEN LSL => -- Logic Shift Left Operand1 by Operand2 number of bits. Fill with "0"
					Overflow_temp <= std_logic_vector(shift_left(unsigned(Operand1), to_integer(unsigned(Operand2))));
					Result        <= Overflow_temp(15 DOWNTO 0);
	
					-- WHEN LSL => -- Logic Shift Left Operand1 by Operand2 number of bits. Fill with "0"
					-- Overflow_temp <= to_stdlogicvector(to_bitvector(Operand1) sra to_integer(unsigned(Operand2)));
					-- Result <= Overflow_temp(15 DOWNTO 0);
					-- --
					---- WHEN LSR => -- Logic Shift Right Operand1 by Operand2 number of bits. Fill with "0"
					---- Overflow_temp <= std_logic_vector(unsigned(Operand1) srl unsigned(Operand2));
					---- Result <= Overflow_temp(15 DOWNTO 0);
					--
					-- WHEN LSL => -- Arithmetic Shift Left Operand1 by Operand2 number of bits. Fill with right bit
					-- Overflow_temp <= std_logic_vector(signed(Operand1) sla signed(Operand2));
					-- Result <= Overflow_temp(15 DOWNTO 0);
					--
					-- WHEN LSL => -- Arithmetic Shift right Operand1 by Operand2 number of bits. Fill with left bit
					-- Overflow_temp <= std_logic_vector(signed(Operand1) sra signed(Operand2));
					-- Result <= Overflow_temp(15 DOWNTO 0);
	
				WHEN INC => 
					Temp <= std_logic_vector("0" & (signed(Operand1) + 1));
					Result <= Temp(15 downto 0);

--			   WHEN DEC_A => 
--			  		Result <= std_logic_vector(signed(Operand1) - 1);  
--			  	-- Overflow_flag <= ((NOT Overflow_temp(15)) AND Operand1(15));
--			  	--	
				When PAS =>
					Temp 			<= ("0" & Operand1);
					Result		<= Operand1; 	
					
				WHEN OTHERS => 
	
			END CASE;
			
			IF (Operation = ADD) theN
				Overflow_Flag <= ((Operand1(15)) OR (Temp(15))) AND ((NOT (Operand2(15))) OR(NOT (Temp(15)))) AND ((NOT (Operand1(15))) OR ((Operand2(15))));
			ELsif (Operation = SUB) theN
				Overflow_Flag <= ((Operand1(15)) OR (Operand2(15))) AND ((NOT (Operand2(15))) OR((Temp(15)))) AND ((NOT (Operand1(15))) OR (NOT (Temp(15))));
			elsif (operation = INC) theN
				Overflow_flag <= ((NOT Operand1(15)) AND Overflow_temp(15));
			end if;
			
			Signed_Flag   <= Temp(15);
			
			IF (Temp(15 downto 0) = "0000000000000000") THEN
			Zero_Flag <= '1' ; 	
			end if;
																		-- Here magic begins
			for I in 0 to 15 loop
				Parity := Parity xor Temp(I); 
			end loop; 
			
			Parity_Flag <= Parity;						
																		-- Here magic ends			
		END IF;
		
	END PROCESS;

END ARCHITECTURE Behavioral;