Library IEEE;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_unsigned.ALL; 

ENTITY MemPCon IS
	PORT
	(
	WE	:	IN	STD_LOGIC;
	RE :	IN	STD_LOGIC;
	Address :	IN STD_LOGIC_vector (15 DOWNTO 0);
	DI	: IN	STD_LOGIC_vector (15 DOWNTO 0);
	DO	: OUT	STD_LOGIC_vector (15 DOWNTO 0);
	CLK : IN  STD_LOGIC
--	Buff : IN STD_LOGIC (5 DOWNTO 0)
	-- 
	 );
END MemPCon;

ARCHITECTURE Behavioral OF MemPCon IS
	type ram_type is array (0 downto 0) of std_logic_vector(5 downto 0);
	signal Buff: RAM_type;
Begin
Sevensegdriver : entity work.ssgddriver
	port map(
		dat => DO,s
		Buff(0)(0) => clr,
		Buff(0)(1) => bcdenable,
		Buff(0)(5 DOWNTO 2) => dots
	);

ButtonDriver : entity work.btndriver
	port map(
	DI <= dbtn
	);
	
	

process(CLK) IS
Begin
  IF(rising_edge(CLK)) THEN


	IF (Address = 65000) THEN -- sevensegdriver data
	DO <= DI;
	
	
	ELSIF (Address = 65001) THEN -- Sevensegdriver control
	Buff <= DI;

	ELSIF (Address = 65002) THEN -- ButtonDriver Data
	
	
	
	Else
	
	
	
	END IF;
END IF;

END process;
END Behavioral;
