#include "Config.hvhd"
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MemoryController IS

	PORT (
		WE : IN STD_LOGIC;
		RE : IN STD_LOGIC;
		Address : IN STD_LOGIC_vector (WORD_SIZE DOWNTO 0);
		DI : IN STD_LOGIC_vector (WORD_SIZE DOWNTO 0);
		DO : BUFFER STD_LOGIC_vector (WORD_SIZE DOWNTO 0);
		CLK : IN STD_LOGIC;
		btn : IN std_LOGIC_vector(2 DOWNTO 0);
		ss : OUT std_LOGIC_vector(31 DOWNTO 0);
		control : OUT std_logic_vector(9 downto 0);
		interrupt_cpu : OUT std_logic
	);
END MemoryController;

ARCHITECTURE Behavioral OF MemoryController IS
	--	type ram_type is array (0 downto 0) of std_logic_vector(5 downto 0);
	--	signal Buff: RAM_type;
	SIGNAL ssreg_data, ssreg_config, btnreg_data, int_data : std_LOGIC_vector(WORD_SIZE DOWNTO 0);
	SIGNAL SevenSegOut : std_logic_vector(31 DOWNTO 0);
	SIGNAL dAddress : std_logic_vector(WORD_SIZE DOWNTO 0);
	SIGNAL Int_address : std_logic_vector(1 downto 0);
	SIGNAL Interrupt_btn_off_sig : STD_LOGIC;
	SIGNAL dataOutMem :std_logic_vector(WORD_SIZE DOWNTO 0);
	SIGNAL btn_interrupt : std_logic := '0';
	SIGNAL Write_enable_mem : std_logic := '0';
BEGIN

	Sevensegdriver : ENTITY work.ssgddriver
		PORT MAP(
			dat => ssreg_data,
			clr => ssreg_config(5),
			bcdenable => ssreg_config(4),
			dots => ssreg_config(3 DOWNTO 0),
			sseg => SevenSegOut
		);

	ButtonDriver : ENTITY work.btndriver
		PORT MAP(
			dbtn => btnreg_data(2 DOWNTO 0),
			clk => clk,
			clr => '0',
			btn => btn,
			interrupt_on => btn_interrupt,
			interrupt_off => Interrupt_btn_off_sig
		);

	MemoryDriver : ENTITY work.Memory(falling)
		PORT MAP(
			DI => DI,
			DO => dataOutMem,
			clk => clk,
			WE => Write_enable_mem,
			RE => RE,
			Address => dAddress
		);

	InterruptDriver : ENTITY work.Interrupt(Behavioral)
		PORT MAP(
			Interrupt_btn => btn_interrupt,
			Interrupt_btn_off =>  Interrupt_btn_off_sig,
        	Write_enable => WE,
        	clk => clk,
        	Address => Int_address,
        	Data => int_data,
        	Control => control,
        	Interrupt_cpu => interrupt_cpu
		);

	PROCESS (CLK) IS
	BEGIN
			IF (to_integer(unsigned(Address)) = 65000 AND WE = '1') THEN -- sevensegdriver data
				IF (falling_edge(CLK)) THEN
					ssreg_data <= DI;
				END IF;

			ELSIF (to_integer(unsigned(Address)) = 65001 AND WE = '1') THEN -- Sevensegdriver control
				IF (falling_edge(CLK)) THEN
					ssreg_config <= DI;
				END IF;

--AND to_integer(unsigned(Address)) <= 6101 
			ELSIF (65100 <= to_integer(unsigned(Address)) AND WE = '1') THEN
				IF (falling_edge(clk)) THEN
					Int_address <= std_logic_vector(to_unsigned(to_integer(unsigned(Address) - 65100),Int_address'length));
					int_data <= DI;
				END IF;
			
			ELSIF (to_integer(unsigned(Address)) = 65002 AND RE = '1') THEN -- ButtonDriver Data
				IF (falling_edge(CLK)) THEN
				DO <= btnreg_data;
				END IF;
			ElSE
				DO <= dataOutMem;
			END IF;
	END PROCESS;

	PROCESS(Address, WE)
	BEGIN
		IF(to_integer(unsigned(Address)) <= 1023 AND WE = '1') THEN
			dAddress <= Address;
			Write_enable_mem <= '1';
		Else
			Write_enable_mem <= '0';
		END IF;
	END PROCESS;

	ss <= SevenSegOut;

END Behavioral;