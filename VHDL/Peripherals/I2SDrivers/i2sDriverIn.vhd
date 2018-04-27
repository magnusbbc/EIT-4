library ieee;
use ieee.std_logic_1164.all;

entity i2sDriverIn is
	generic
	(
		DATA_WIDTH : integer range 4 to 32 := 16
	);
	port
	(
		bclk   : in std_logic;-- Bitclock in
		ws     : in std_logic;-- Worselect
		Din    : in std_logic;-- Data in
		DOut_L : out std_logic_vector(DATA_WIDTH - 1 downto 0); -- One full word of data out
		DOut_R : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		int_L  : out std_logic := '0';-- Interupt out. Is set high when a new word is ready
		int_R  : out std_logic := '0';
		intr_L : in std_logic  := '0';-- Interupt reset. Set this high to reset the interupt. Should be high untill intterupt put is low again.
		intr_R : in std_logic  := '0'
		--Ports for input
	);
end i2sDriverIn;

architecture i2sDriverIn of i2sDriverIn is
	signal lr      : std_logic := '1';
	signal cnt     : integer   := 0;
	signal outBuff : std_logic_vector (DATA_WIDTH - 1 downto 0);

begin
	data_in : process (bclk, ws)
		variable vcnt     : integer := 0;
		variable voutBuff : std_logic_vector (DATA_WIDTH - 1 downto 0);
	begin
		if rising_edge(bclk) then
			vcnt     := cnt;
			voutBuff := outBuff;

			if intr_L = '1' then
				int_L <= '0';
			end if;
			if intr_R = '1' then
				int_R <= '0';
			end if;
			if vcnt < DATA_WIDTH then

				voutBuff(vcnt) := Din;

				vcnt                            := vcnt + 1;

			end if;

			if lr = not ws then

				--IF vcnt < DATA_WIDTH THEN
				if lr = '1' then
					dout_L <= voutbuff;
					--dout_L(DATA_WIDTH - vcnt - 1 DOWNTO 0) <= (OTHERS => '0');
				else
					dout_R <= voutbuff;
					--dout_R(DATA_WIDTH - vcnt - 1 DOWNTO 0) <= (OTHERS => '0');
				end if;

				--END IF;

				lr <= ws;

				vcnt := 0;

				if ws = '0' then

					int_R <= '1';
				

				else

					
					int_L <= '1';
				end if;
			else
				if ws = '1' then

					int_R <= '1';
					

				else


					int_L <= '1';
				end if;

			end if;
			cnt     <= vcnt;
			outBuff <= voutBuff;
		end if;
	end process;
end i2sDriverIn;