#include VGA_Config.hvhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity VGAController is
    Port ( 
				clk 						: in  STD_LOGIC; -- 25 mhz clk
				reset						: in std_logic;	-- Reset signal
				row, col					: out integer;	--Coordiantes for Image generator
				h_sync, v_sync  	: out std_logic; --sync signals for VGA output
				disp_en  	: out std_logic --on when signal should be on
				);
end VGAController;

architecture Behavioral of VGAController is

begin
	VGAControlLogic : process(clk, reset)
	variable h_count : integer range 0 to H_PERIOD; --Horizontal counter
	variable v_count : integer range 0 to V_PERIOD;	--Vertical counter
	begin
		if rising_edge(clk) then
			--counting logic
			if (h_count<H_PERIOD) then
				h_count := h_count+1;--Add 1 to pixel counter if less than period count
			else --Line is  finished
				h_count := 0; 	--Reset horizontal pixel count
				if(v_count<V_PERIOD) then 
					v_count := v_count+1;	--Add 1 to vertical linecounter
				else--Screen is finished 
					v_count:=0;--Reset linecounter
				end if;
			end if;
			
			--H-sync
			if(h_count < H_VISIBLE_AREA + H_FRONT_PORCH OR h_count >= H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE) then
				h_sync <= not H_POL;
			else
				h_sync <= H_POL;
			end if;

			--V-sync
			if(v_count < V_VISIBLE_AREA + V_FRONT_PORCH OR v_count >= V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE) then
				v_sync <= not V_POL;
			else
				v_sync <= V_POL;
			end if;

			--Send coordinates
			if(h_count<H_VISIBLE_AREA) then
				col<=h_count;
			end if;
			if(v_count<V_VISIBLE_AREA) then
				row <= v_count;
			end if;
			--Enable display while within diplay region
			if(h_count<H_VISIBLE_AREA and v_count<V_VISIBLE_AREA) then
				disp_en <='1';
			else
				disp_en<='0';
			end if;

			
			

		end if;
	end Process;

end Behavioral;