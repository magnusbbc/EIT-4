#include "Config.hvhd"
--------------------------------------------------------------------------------------
--Engineer: Jakob Thomsen, Mikkel Hardysoe, Magnus Christensen
--Module Name: Memory Controller
--
--Description:
--
--
--
--------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MemoryController IS

	PORT (
		WE : IN STD_LOGIC;
		RE : IN STD_LOGIC;
		Address : IN STD_LOGIC_vector (WORD_SIZE DOWNTO 0);
		DI : IN STD_LOGIC_vector (WORD_SIZE DOWNTO 0);
		DO : BUFFER STD_LOGIC_vector (WORD_SIZE DOWNTO 0) := x"0000";
		CLK : IN STD_LOGIC;
		btn : IN std_LOGIC_vector(2 DOWNTO 0);
		ss : OUT std_LOGIC_vector(31 DOWNTO 0);
		control : OUT std_logic_vector(9 downto 0);
		interrupt_cpu : OUT std_logic;
		Interrupt_enable : IN std_logic := '0';
		Interrupt_nest_enable : OUT std_logic;

		--I2S
		bclk   : IN std_logic := '0';
		ws     : IN std_logic := '0';
		Din    : IN std_logic := '0';
		bclkO     : out std_logic := '0';
		wsO  : out std_logic := '0';
		DOut : out std_logic := '0'
	);
END MemoryController;

ARCHITECTURE Behavioral OF MemoryController IS
	--	type ram_type is array (0 downto 0) of std_logic_vector(5 downto 0);
	--	signal Buff: RAM_type;
	SIGNAL ssreg_data, ssreg_config, btnreg_data, int_data : std_LOGIC_vector(WORD_SIZE DOWNTO 0);
	SIGNAL SevenSegOut : std_logic_vector(31 DOWNTO 0);
	SIGNAL dAddress : std_logic_vector(WORD_SIZE DOWNTO 0);
	SIGNAL Int_address : std_logic_vector(1 downto 0);
	SIGNAL Interrupt_btn_reset_sig, Interrupt_I2S_reset_sig : STD_LOGIC;
	SIGNAL dataOutMem :std_logic_vector(WORD_SIZE DOWNTO 0) := x"0000";
	SIGNAL btn_interrupt, I2S_interrupt : std_logic := '0';
	SIGNAL Write_enable_mem : std_logic := '0';
	SIGNAL Read_enable_mem : std_logic := '0';
	SIGNAL I2SMonoIn_DataOut :std_logic_vector(WORD_SIZE DOWNTO 0) := x"0000";
	SIGNAL I2SMonoOut_DataIn :std_logic_vector(WORD_SIZE DOWNTO 0) := x"0000";
--	SIGNAL I2SMonoOut_internal_int : std_logic := '0';
--	SIGNAL I2SMonoOut_internal_int_reset : std_logic := '0';
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
			interrupt_reset => Interrupt_btn_reset_sig
		);

	MemoryDriver : ENTITY work.Memory(falling)
		PORT MAP(
			DI => DI,
			DO => dataOutMem,
			clk => clk,
			WE => Write_enable_mem,
			RE => Read_enable_mem,
			Address => dAddress
		);

	I2SMonoIn : Entity work.I2SMonoIn(Behavioral)
		PORT MAP(
			bclk => bclk,
			ws  => ws,
			Din => Din,
			DOut => I2SMonoIn_DataOut,
			Int => I2S_interrupt,
			Intr => Interrupt_I2S_reset_sig
		);

	I2SMonoOut : Entity work.I2SMonoOut(Behavioral)
		PORT MAP(
--			int => I2SMonoOut_internal_int,
--			intr => I2SMonoOut_internal_int_reset,
			clk => bclk, 
			DIn => I2SMonoOut_DataIn,
			bclkO => bclkO,
			wsO =>  wsO,
			DOut =>Dout
		);
	InterruptDriver : ENTITY work.Interrupt(Behavioral)
		PORT MAP(
			Interrupt_btn => btn_interrupt,
			Interrupt_btn_reset =>  Interrupt_btn_reset_sig,
        	Interrupt_I2S => I2S_interrupt,
			Interrupt_I2S_reset => Interrupt_I2S_reset_sig,
			Write_enable => WE,
        	clk => clk,
        	Address => Int_address,
        	Data => int_data,
        	Control => control,
        	Interrupt_cpu => interrupt_cpu,
			Interrupt_enable => Interrupt_enable,
			Interrupt_nest_enable => Interrupt_nest_enable
		);

	

	PROCESS (CLK,btnreg_data,dataOutMem)
	BEGIN
		IF (to_integer(unsigned(Address)) = 65000 AND WE = '1') THEN -- sevensegdriver data
			IF (falling_edge(CLK)) THEN
				ssreg_data <= DI;
			END IF;
		
		ELSIF (to_integer(unsigned(Address)) = 65001 AND WE = '1') THEN -- Sevensegdriver control
			IF (falling_edge(CLK)) THEN	
				ssreg_config <= DI;
			END IF;

		ELSIF (to_integer(unsigned(Address)) = 65010 AND WE = '1') THEN -- Sevensegdriver control
			IF (falling_edge(CLK)) THEN	
				I2SMonoOut_DataIn <= DI;
			END IF;

--AND to_integer(unsigned(Address)) <= 6101 
		ELSIF (65100 <= to_integer(unsigned(Address)) AND WE = '1') THEN
			IF (falling_edge(CLK)) THEN	
				Int_address <= std_logic_vector(to_unsigned(to_integer(unsigned(Address) - 65100),Int_address'length));
				int_data <= DI;
			END IF;
			
		ELSIF (to_integer(unsigned(Address)) >= 65000 AND RE = '1') THEN -- ButtonDriver Data
			IF (falling_edge(CLK)) THEN	
				IF(to_integer(unsigned(Address)) = 65002) THEN
					DO <= btnreg_data;
				ELSIF(to_integer(unsigned(Address)) = 65011) THEN
					DO <= I2SMonoIn_DataOut;
				END IF;
			END IF;

		ElSIF (RE = '1') THEN
				DO <= dataOutMem; --Not sure this works, might need to revert

		ELSE 
			DO <= (OTHERS => 'Z');
		END IF;

	END PROCESS;

	PROCESS(Address, WE, RE)
	BEGIN
		IF(to_integer(unsigned(Address)) <= 1023) THEN
			IF(WE = '1') THEN
				dAddress <= Address;
				Write_enable_mem <= '1';
			ELSE
				Write_enable_mem <= '0';
			END IF;

			IF(RE = '1') THEN
				dAddress <= Address;
				Read_enable_mem <= '1';
			ELSE
				Read_enable_mem <= '0';
			END IF;
		ELSE
			Write_enable_mem <= '0';
			Read_enable_mem <= '0';

		END IF;
	END PROCESS;
	ss <= SevenSegOut;

END Behavioral;