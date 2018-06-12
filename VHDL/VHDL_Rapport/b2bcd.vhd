LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY b2bcd IS
	PORT
	(
		clr    : IN std_logic;
		binary : IN std_logic_vector (15 DOWNTO 0); --Input value
		bcd    : OUT std_logic_vector (15 DOWNTO 0) --Binary coded decimal representation of that value
	);
END b2bcd;
ARCHITECTURE a OF b2bcd IS
BEGIN
	
	--------------------------------------------
	-- b2bcd:
	-- converts a number to binary coded decimal
	-- Note that it is only possible to represent numbers up to
	-- 9999 with 16 available output BITS
	-- Uses double-dabble algorithm
	--------------------------------------------
	b2bcd : PROCESS (binary, clr)
		VARIABLE temp : std_logic_vector(31 DOWNTO 0);
	BEGIN
		temp := x"00000000";
		IF clr = '0' THEN
			temp(18 DOWNTO 3) := binary;

			FOR i IN 0 TO 12 LOOP
				IF temp(19 DOWNTO 16) > 4 THEN
					temp(19 DOWNTO 16) := temp(19 DOWNTO 16) + 3;
				END IF;
				IF temp(23 DOWNTO 20) > 4 THEN
					temp(23 DOWNTO 20) := temp(23 DOWNTO 20) + 3;
				END IF;
				IF temp(27 DOWNTO 24) > 4 THEN
					temp(27 DOWNTO 24) := temp(27 DOWNTO 24) + 3;
				END IF;
				IF temp(31 DOWNTO 28) > 4 THEN
					temp(31 DOWNTO 28) := temp(31 DOWNTO 28) + 3;
				END IF;
				temp(31 DOWNTO 1) := temp(30 DOWNTO 0);
			END LOOP;
		END IF;
		bcd <= temp(31 DOWNTO 16);
	END PROCESS b2bcd;
END a;