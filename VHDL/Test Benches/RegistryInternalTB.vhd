LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY RegistryInternalTB IS
END RegistryInternalTB;

ARCHITECTURE Behavioral OF RegistryInternalTB IS

	signal readOne : std_logic_vector(4 downto 0);
	signal readTwo : std_logic_vector(4 downto 0);
	
	signal WriteOne : std_logic_vector(4 downto 0);
	signal WriteTwo : std_logic_vector(4 downto 0);
	
	signal dataInOne : std_logic_vector(15 downto 0);
	signal dataInTwo : std_logic_vector(15 downto 0);

	signal dataOutOne : std_logic_vector(15 downto 0);
	signal dataOutTwo : std_logic_vector(15 downto 0);
	
	signal pcIn : std_logic_vector(15 downto 0);
	
	--Clock Constants
	constant TbPeriod : time := 10 ns;
   signal TbClock : std_logic := '0';
   signal TbSimEnded : std_logic := '0';
	signal count : integer := -1;
	signal swap : std_logic := '0';
	
BEGIN
	REG : ENTITY work.RegistryInternal(Behavioral) PORT MAP(readOne => readOne, readTwo => readTwo, writeOne => writeOne, writeTwo => writeTwo, dataOutOne => dataOutOne, dataOutTwo => dataOutTwo, dataInOne => dataInOne, dataInTwo => dataInTwo, pcIn => pcIn);
	
	-- Clock generation
   TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

	
stim_proc:process(TbClock)
		begin
		
		if (rising_edge(TbClock)) then
				if swap = '0' then --write
					dataInOne <= std_logic_vector(to_unsigned(count, dataInOne'length));
					writeOne <= std_logic_vector(to_unsigned(count, writeOne'length));
					
					count <= count + 1;
				
					if count = 31 then
						swap <= '1';
						count <= 0;
					end if;
				end if;
				
				if swap = '1' then --read
					readOne <= std_logic_vector(to_unsigned(count, readOne'length));
					
					count <= count + 1;
					
					if count = 32 then
						tbsimEnded <= '1';
					end if;
				end if;
		end if;
	end process; 
END Behavioral;