library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--timing based on 25 mHz
--Horizontal timing (pixels)





--Vertical timing (lines)





--Polarity of sync signals




entity VGAController is
    Port ( 
				clk 						: in  STD_LOGIC; -- 25 mhz clk
				row, col					: out std_logic_vector ( 9 downto 0);
				disp_en, h_sync, v_sync  	: out std_logic
				);
end VGAController;

architecture Behavioral of VGAController is

begin
	VGAControlLogic : process(clk)
	variable h_count : integer range 0 to 640 + 16 + 96 + 48	 - 1;
	variable v_count : integer range 0 to 480 + 10 + 2 + 33		 - 1;
	begin
		if rising_edge(clk) then
			
			

		end if;
	end Process;

end Behavioral;