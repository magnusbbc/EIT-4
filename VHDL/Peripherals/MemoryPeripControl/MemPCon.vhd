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
	DO	: buffer STD_LOGIC_vector (15 DOWNTO 0);
	CLK : IN  STD_LOGIC;
	clrO : buffer std_LOGIC;
	bcdeO : buffer std_LOGIC;
	dotsO : buffer std_LOGIC_vector(3 downto 0);
	dbtnI : buffer std_LOGIC_vector(2 downto 0);
	btn : in std_LOGIC_vector(2 downto 0)
	 );
END MemPCon;

ARCHITECTURE Behavioral OF MemPCon IS
--	type ram_type is array (0 downto 0) of std_logic_vector(5 downto 0);
--	signal Buff: RAM_type;
	
Begin

Sevensegdriver : entity work.ssgddriver
	port map(
		dat => DO,
		clr => clrO,
		bcdenable => bcdeO,
		dots => dotsO
	);

ButtonDriver : entity work.btndriver
	port map(
	dbtn => dbtnI,
	clk => clk,
	clr => clrO,
	btn => btn
	);
	

	

process(CLK) IS
Begin
  IF(rising_edge(CLK)) THEN


	IF (Address = 65000) THEN -- sevensegdriver data
	DO <= DI;
	
	ELSIF (Address = 65001) THEN -- Sevensegdriver control
	clrO <= DI(0);
	bcdeO <= DI(1);
	dotsO <= DI(5 downto 2);

	ELSIF (Address = 65002) THEN -- ButtonDriver Data
	DO(2 downto 0) <= dbtnI;
	
	Else -- memory 
	
	
	
	END IF;
END IF;

END process;
END Behavioral;
