library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity testbench is
end testbench;

architecture test of testbench is

constant t : time := 100 ns;

signal clk               : STD_LOGIC; --Clock used for debouncing
signal clr               : STD_LOGIC; --Clear
signal btn               : STD_LOGIC_vector (3 DOWNTO 0)  := (OTHERS => '0'); --Button inputs
signal debounced_btn_out : STD_LOGIC_vector (3 DOWNTO 0) := (OTHERS => '0'); --Debounced button output
signal interrupt_on      : std_logic                     := '0';   --Send interrut signal out 
signal interrupt_reset   : std_logic                      := '0';    --Resets interrupt signal when set high

begin

	dut : entity work.btndriver
	
	port map(
		clk => clk,              
		clr => clr,             
		btn => btn,            
		debounced_btn_out => debounced_btn_out,
		interrupt_on => interrupt_on,     
      interrupt_reset => interrupt_reset 
		);

	
	clock : process
	
	begin
		clk <= '0';
		wait for t;
		clk <= '1';
		wait for t;
	end process;	


	simulation : process
	begin
		for i in 0 to 5 loop
			btn(0) <= '1';
			wait for 2*i*t;
			btn(0) <= '0';
			wait for 2*i*t;
		end loop;
	end process;
		
end architecture test;
