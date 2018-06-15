























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
	variable h_count : integer range 0 to 640              + 16 + 96 + 48	 - 1; --Horizontal counter
	variable v_count : integer range 0 to 480              + 10 + 2 + 33	 - 1;	--Vertical counter
	begin
		if rising_edge(clk) then
			--counting logic
			if (h_count<640              + 16 + 96 + 48	 - 1) then
				h_count := h_count+1;--Add 1 to pixel counter if less than period count
			else --Line is  finished
				h_count := 0; 	--Reset horizontal pixel count
				if(v_count<480              + 10 + 2 + 33	 - 1) then 
					v_count := v_count+1;	--Add 1 to vertical linecounter
				else--Screen is finished 
					v_count:=0;--Reset linecounter
				end if;
			end if;
			
			--H-sync
			if(h_count < 640              + 16 OR h_count >= 640              + 16 + 96) then
				h_sync <= not '0' ;
			else
				h_sync <= '0' ;
			end if;

			--V-sync
			if(v_count < 480              + 10 OR v_count >= 480              + 10 + 2) then
				v_sync <= not '0';
			else
				v_sync <= '0';
			end if;

			--Send coordinates
			if(h_count<640             ) then
				col<=h_count;
			end if;
			if(v_count<480             ) then
				row <= v_count;
			end if;
			--Enable display while within diplay region
			if(h_count<640              and v_count<480             ) then
				disp_en <='1';
			else
				disp_en<='0';
			end if;

			
			

		end if;
	end Process;

end Behavioral;