library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--timing based on 25 mHz
--Horizontal timing (pixels)
#define h_visible_area	640
#define h_front_porch   16
#define h_sync_pulse    96
#define h_back_porch	48	
#define h_total	        h_visible_area + h_front_porch + h_sync_pulse + h_back_porch
--Vertical timing (lines)
#define v_visible_area	480
#define v_front_porch   10
#define v_sync_pulse    2
#define v_back_porch	33	
#define v_total	         v_visible_area + v_front_porch + v_sync_pulse + v_back_porch	
--Polarity of sync signals
#define h_pol '0'
#define v_pol '0'


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
	variable h_count : integer range 0 to h_total - 1;
	variable v_count : integer range 0 to v_total - 1;
	begin
		if rising_edge(clk) then
			
			

		end if;
	end Process;

end Behavioral;