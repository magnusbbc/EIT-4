library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--timing based on 25 mHz
--Horizontal timing (pixels)
#define H_VISIBLE_AREA	640
#define H_FRONT_PORCH   16
#define H_SYNC_PULSE    96
#define H_BACK_PORCH	48	
#define H_TOTAL	        H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH
#define H_PERIOD		H_TOTAL - 1
--Vertical timing (lines)
#define V_VISIBLE_AREA	480
#define V_FRONT_PORCH   10
#define V_SYNC_PULSE    2
#define V_BACK_PORCH	33	
#define V_TOTAL	        V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH
#define V_PERIOD		V_TOTAL - 1
--Polarity of sync signals
#define H_POL '0'
#define V_POL '0'



entity VGAController is
    Port ( 
				clk 						: in  STD_LOGIC; -- 25 mhz clk
				reset						: in std_logic;
				row, col					: out integer;
				disp_en, h_sync, v_sync  	: out std_logic
				);
end VGAController;

architecture Behavioral of VGAController is

begin
	VGAControlLogic : process(clk, reset)
	variable h_count : integer range 0 to H_PERIOD;
	variable v_count : integer range 0 to V_PERIOD;
	begin
		if rising_edge(clk) then
			--counting logic
			if (h_count<H_PERIOD) then
				h_count := h_count+1;
			else
				h_count := 0;
				if(v_count<V_PERIOD) then
					v_count := v_count+1;
				else
					v_count:=0;
				end if;
			end if;
			
			-- H-sync
			if(h_count < H_VISIBLE_AREA + H_FRONT_PORCH OR h_count >= H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE) then
				h_sync <= not H_POL;
			else
				h_sync <= H_POL;
			end if;

			-- v-sync
			if(v_count < V_VISIBLE_AREA + V_FRONT_PORCH OR v_count >= V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE) then
				v_sync <= not V_POL;
			else
				v_sync <= V_POL;
			end if;

			--send coordinates
			if(h_count<H_VISIBLE_AREA) then
				col<=h_count;
			end if;
			if(v_count<V_VISIBLE_AREA) then
				row <= v_count;
			end if;

			if(h_count<H_VISIBLE_AREA and v_count<V_VISIBLE_AREA) then
				disp_en <='1';
			else
				disp_en<='0';
			end if;

			
			

		end if;
	end Process;

end Behavioral;