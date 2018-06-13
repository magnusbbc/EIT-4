-- Clk_buf.vhd

-- Generated using ACDS version 18.0 614

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Clk_buf is
	port (
		inclk  : in  std_logic := '0'; --  altclkctrl_input.inclk
		outclk : out std_logic         -- altclkctrl_output.outclk
	);
end entity Clk_buf;

architecture rtl of Clk_buf is
	component Clk_buf_altclkctrl_0 is
		port (
			inclk  : in  std_logic := 'X'; -- inclk
			outclk : out std_logic         -- outclk
		);
	end component Clk_buf_altclkctrl_0;

begin

	altclkctrl_0 : component Clk_buf_altclkctrl_0
		port map (
			inclk  => inclk,  --  altclkctrl_input.inclk
			outclk => outclk  -- altclkctrl_output.outclk
		);

end architecture rtl; -- of Clk_buf
