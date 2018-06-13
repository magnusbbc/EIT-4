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
				reset						: in std_logic;
				row, col					: out integer;
				disp_en, h_sync, v_sync  	: out std_logic
				);
end VGAController;

architecture Behavioral of VGAController is

begin
	VGAControlLogic : process(clk, reset)
	variable h_count : integer range 0 to 640 + 16 + 96 + 48	 - 1;
	variable v_count : integer range 0 to 480 + 10 + 2 + 33	 - 1;
	begin
		if rising_edge(clk) then
			--counting logic
			if (h_count<640 + 16 + 96 + 48	 - 1) then
				h_count := h_count+1;
			else
				h_count := 0;
				if(v_count<480 + 10 + 2 + 33	 - 1) then
					v_count := v_count+1;
				else
					v_count:=0;
				end if;
			end if;
			
			-- H-sync
			if(h_count < 640 + 16 OR h_count >= 640 + 16 + 96) then
				h_sync <= not '0';
			else
				h_sync <= '0';
			end if;

			-- v-sync
			if(v_count < 480 + 10 OR v_count >= 480 + 10 + 2) then
				v_sync <= not '0';
			else
				v_sync <= '0';
			end if;

			--send coordinates
			if(h_count<640) then
				col<=h_count;
			end if;
			if(v_count<480) then
				row <= v_count;
			end if;

			if(h_count<640 and v_count<480) then
				disp_en <='1';
			else
				disp_en<='0';
			end if;

			
			

		end if;
	end Process;

end Behavioral;