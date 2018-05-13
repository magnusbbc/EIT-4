




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

	PORT
	(
		write_enable              : IN STD_LOGIC;
		read_enable               : IN STD_LOGIC;
		address                   : IN STD_LOGIC_vector (15 DOWNTO 0);
		data_in                   : IN STD_LOGIC_vector (15 DOWNTO 0);
		data_out                  : BUFFER STD_LOGIC_vector (15 DOWNTO 0) := (OTHERS => '0');
		clk                       : IN STD_LOGIC;
		btn                       : IN std_LOGIC_vector(2 DOWNTO 0);
		seven_seg_control_signals : OUT std_LOGIC_vector(31 DOWNTO 0);
		interrupt_address         : OUT std_logic_vector(9 DOWNTO 0);
		interrupt_cpu             : OUT std_logic;
		interrupt_enable          : IN std_logic := '0';
		interrupt_nest_enable     : OUT std_logic;

		--I2S
		i2s_bit_clk               : IN std_logic  := '0';
		i2s_word_select           : IN std_logic  := '0';
		i2s_data_in               : IN std_logic  := '0';
		i2s_bit_clk_out           : OUT std_logic := '0';
		i2s_word_select_out       : OUT std_logic := '0';
		i2s_data_out              : OUT std_logic := '0'
	);
END MemoryController;

ARCHITECTURE Behavioral OF MemoryController IS
	SIGNAL seven_seg_data, seven_seg_configuration, btn_data, interrupt_data : std_LOGIC_vector(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL dram_address                                                      : std_logic_vector(15 DOWNTO 0);
	SIGNAL interrupt_controller_address_index                                : std_logic_vector(1 DOWNTO 0);
	SIGNAL interrupt_btn_reset_signal, interrupt_i2s_reset_signal            : STD_LOGIC;
	SIGNAL dram_data_out                                                     : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL btn_interrupt, i2s_interrupt                                      : std_logic                            := '0';
	SIGNAL write_enable_dram                                                 : std_logic                            := '0';
	SIGNAL read_enable_dram                                                  : std_logic                            := '0';
	SIGNAL i2s_mono_in_data_out                                              : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL i2s_mono_out_data_in                                              : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
BEGIN

	SevenSegmentDisplayDriver : ENTITY work.ssgddriver
		PORT MAP
		(
			input_data                => seven_seg_data,
			clr                       => seven_seg_configuration(5),
			bcd_enable                => seven_seg_configuration(4),
			dot_control               => seven_seg_configuration(3 DOWNTO 0),
			seven_seg_control_signals => seven_seg_control_signals
		);

	ButtonDriver : ENTITY work.btndriver
		PORT
		MAP(
		debounced_btn_out => btn_data(2 DOWNTO 0),
		clk               => clk,
		clr               => '0',
		btn               => btn,
		interrupt_on      => btn_interrupt,
		interrupt_reset   => interrupt_btn_reset_signal
		);

	MemoryDriver : ENTITY work.Memory(falling)
		PORT
		MAP(
		data_in      => data_in,
		data_out     => dram_data_out,
		clk          => clk,
		write_enable => write_enable_dram,
		read_enable  => read_enable_dram,
		address      => dram_address
		);

	I2SMonoIn : ENTITY work.I2SMonoIn(Behavioral)
		PORT
		MAP(
		bit_clock       => i2s_bit_clk,
		word_select     => i2s_word_select,
		data_in         => i2s_data_in,
		data_out        => i2s_mono_in_data_out,
		interrupt       => i2s_interrupt,
		interrupt_reset => interrupt_i2s_reset_signal
		);

	I2SMonoOut : ENTITY work.I2SMonoOut(Behavioral)
		PORT
		MAP(
		clk             => i2s_bit_clk,
		data_in         => i2s_mono_out_data_in,
		bit_clk_out     => i2s_bit_clk_out,
		word_select_out => i2s_word_select_out,
		data_out        => i2s_data_out
		);
	InterruptDriver : ENTITY work.Interrupt(Behavioral)
		PORT
		MAP(
		interrupt_btn             => btn_interrupt,
		interrupt_btn_reset       => interrupt_btn_reset_signal,
		interrupt_i2s             => i2s_interrupt,
		interrupt_i2s_reset       => interrupt_i2s_reset_signal,
		write_enable              => write_enable,
		clk                       => clk,
		internal_register_address => interrupt_controller_address_index,
		data_in                   => interrupt_data,
		interrupt_address         => interrupt_address,
		interrupt_cpu             => interrupt_cpu,
		interrupt_enable          => interrupt_enable,
		interrupt_nest_enable     => interrupt_nest_enable
		);

	--------------------------------------------
	-- MainReadWrite:
	-- Process takes care of reading from all peripherals
	-- aswell as writing to all peripherals, except DRAM
	--
	-- While much of this process's syntax/logic may seem strange,
	-- illogical and obscure, it was required for quartus to be able to
	-- synthesize the design ¯_(ツ)_/¯
	--------------------------------------------
	MainReadWrite : PROCESS (clk, btn_data, dram_data_out)
	BEGIN
		IF (to_integer(unsigned(address)) = 65000 AND write_enable = '1') THEN -- sevensegdriver data
			IF (falling_edge(clk)) THEN
				seven_seg_data <= data_in;
			END IF;

		ELSIF (to_integer(unsigned(address)) = 65001 AND write_enable = '1') THEN -- Sevensegdriver control
			IF (falling_edge(clk)) THEN
				seven_seg_configuration <= data_in;
			END IF;

		ELSIF (to_integer(unsigned(address)) = 65010 AND write_enable = '1') THEN -- Sevensegdriver control
			IF (falling_edge(clk)) THEN
				i2s_mono_out_data_in <= data_in;
			END IF;

			--AND to_integer(unsigned(address)) <= 6101 
		ELSIF (65100 <= to_integer(unsigned(address)) AND write_enable = '1') THEN
			IF (falling_edge(clk)) THEN
				interrupt_controller_address_index <= std_logic_vector(to_unsigned(to_integer(unsigned(address) - 65100), interrupt_controller_address_index'length));
				interrupt_data                     <= data_in;
			END IF;

		--The nested if statements are required for quartus allow synthesis.
		ELSIF (to_integer(unsigned(address)) >= 65000 AND read_enable = '1') THEN -- ButtonDriver Data
			IF (falling_edge(clk)) THEN
				IF (to_integer(unsigned(address)) = 65002) THEN
					data_out <= btn_data;
				ELSIF (to_integer(unsigned(address)) = 65011) THEN
					data_out <= i2s_mono_in_data_out;
				END IF;
			END IF;

		ELSIF (read_enable = '1') THEN
			data_out <= dram_data_out; --Not sure this works, might need to revert

		ELSE
			data_out <= (OTHERS => 'Z');
		END IF;

	END PROCESS;

	--------------------------------------------
	-- DramWrite:
	-- Process takes care of writing ram
	-- again required due to synthesis limitations
	--------------------------------------------
	DramWrite : PROCESS (address, write_enable, read_enable)
	BEGIN
		IF (to_integer(unsigned(address)) <= 1023) THEN
			IF (write_enable = '1') THEN
				dram_address      <= address;
				write_enable_dram <= '1';
			ELSE
				write_enable_dram <= '0';
			END IF;

			IF (read_enable = '1') THEN
				dram_address     <= address;
				read_enable_dram <= '1'; -- <--- is read_enable_dram required?
			ELSE
				read_enable_dram <= '0';
			END IF;
		ELSE
			write_enable_dram <= '0';
			read_enable_dram  <= '0';

		END IF;
	END PROCESS;

END Behavioral;