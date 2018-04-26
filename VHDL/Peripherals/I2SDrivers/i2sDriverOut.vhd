library ieee;
use ieee.std_logic_1164.all;

entity i2sDriverOut is
	generic
	(
		DATA_WIDTH : integer range 4 to 32 := 16
	);
	port
	(

		clk    : in std_logic;-- Clock that will be used for logic and will be directly used as output bitclock. Can be directly connected to a syncronized bitclock input from the i2s input signal.
		int_L  : in std_logic  := '0';-- Interupt for when  new signals are stable at input. should be set high when a new word should be loaded into the output buffer.
		int_R  : in std_logic  := '0';
		intr_L : out std_logic := '0';--Interupt reset. Input is set to high when the input has been loaded to the input buffer.
		intr_R : out std_logic := '0';
		DIn_L  : in std_logic_vector(DATA_WIDTH - 1 downto 0);-- The data input buses. The word that should be loaded into the buffer should be loaded to these inputs when the interupts are set to high.
		DIn_R  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		bclk   : out std_logic;-- Output bitclock for the output i2s signal. 
		ws     : out std_logic;--Output wordselect for the output i2s signal.
		DOut   : out std_logic -- Output serial data for the i2s signal.     

	);
end i2sDriverOut;

architecture i2sDriverOut of i2sDriverOut is
	signal clkb      : std_logic                                 := '1';
	signal buff_In_L : std_logic_vector(DATA_WIDTH - 1 downto 0) := (1 => '1', others => '1');
	signal buff_In_R : std_logic_vector(DATA_WIDTH - 1 downto 0) := (1 => '1', others => '1');
	signal cnt       : integer                                   := 0;
	signal lr        : std_logic                                 := '0';
begin

	bclk <= clk;

	data_out : process (clk)
	begin
		if falling_edge(clk) then

			if cnt < DATA_WIDTH then
				if lr = '1' then --Write from the active buffer 
					DOut <= buff_In_L(DATA_WIDTH - 1 - cnt);
				else
					DOut <= buff_In_R(DATA_WIDTH - 1 - cnt);
				end if;

			end if;

			if cnt + 1 >= DATA_WIDTH then --Change channel
				ws <= not lr;
				lr <= not lr;

			end if;
		end if;

	end process;

	data_out_cnt : process (clk)
	begin
		if rising_edge(clk) then

			
			cnt <= cnt + 1;

			if cnt + 1 >= DATA_WIDTH then --Change channel

				cnt <= 0;
			end if;
			if (int_L = '1') and(cnt = datA_WIDTH - 1) then --Update the word that is ready
				buff_In_L <= DIn_L;
				intr_L    <= '1';
			end if;
			if (int_R = '1') and(cnt = datA_WIDTH - 1) then
				buff_In_R <= DIn_R;
				intr_R    <= '1';
			end if;

			if (int_L = '0') then --Update the word that is ready
				intr_L <= '0';
			end if;
			if (int_R = '0') then
				intr_R <= '0';
			end if;
			--end if;

		end if;

	end process;

end i2sDriverOut;