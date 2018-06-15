--------------------------------------------------------------------------------------
--Engineer: Frederik Rasmussen
--Module Name: Binary to Binary Coded Decimal
--
--Description:
--
--
--
--------------------------------------------------------------------------------------
 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
 
ENTITY b2bcd IS
  PORT
  (
    clr    : IN std_logic;
    binary : IN std_logic_vector (15 DOWNTO 0); --Input value
    bcd    : OUT std_logic_vector (19 DOWNTO 0) --Binary coded decimal representation of that value
  );
END b2bcd;
ARCHITECTURE a OF b2bcd IS
BEGIN

  --------------------------------------------
  -- b2bcd:
  -- converts a number to binary coded decimal
  -- Note that it is only possible to represent numbers up to
  -- 9999 with 16 available output BITS
  --------------------------------------------
  b2bcd : PROCESS (binary, clr)
    VARIABLE temp : std_logic_vector(35 DOWNTO 0);
  BEGIN
    temp :=(others=>'0');
    IF clr = '0' THEN
      temp(15 DOWNTO 0) := binary;
 
      FOR i IN 0 TO 15 LOOP
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
        IF temp(35 DOWNTO 32) > 4 THEN
          temp(35 DOWNTO 32) := temp(35 DOWNTO 32) + 3;
        END IF;
        temp(35 DOWNTO 1) := temp(34 DOWNTO 0);
      END LOOP;
    END IF;
    bcd <= temp(35 DOWNTO 16);
  END PROCESS b2bcd;
END a;