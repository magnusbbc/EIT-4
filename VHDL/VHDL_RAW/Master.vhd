




















--------------------------------------------------------------------------------------
--Engineer: Magnus Christensen
--Module Name: Master
--
--Description:
--
--
--
--------------------------------------------------------------------------------------
--Definition of control lines groupings


















--Definition of instruction lines groupings









LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY Master IS
	PORT
	(
		clk   : IN std_logic; 						--Device hardware clock
		btn   : IN std_logic_vector(2 DOWNTO 0); 	--Device's 3 available push buttons (note: active low)
		sseg  : OUT std_logic_vector(31 DOWNTO 0); 	--Seven segment display control signals (8 signals for each of the four displays)

		led   : OUT std_logic_vector(9 DOWNTO 0) := (OTHERS => '0'); 	--Signals for controlling onboard LED's

		--I2S input
		bclk  : IN std_logic  := '0';				--External input bitclock signal
		ws    : IN std_logic  := '0';				--External input word select signal
		Din   : IN std_logic  := '0';				--External Data input

		--I2S output
		bclkO : OUT std_logic := '0';				--Bitclock output
		wsO   : OUT std_logic := '0';				--Word select output
		DOut  : OUT std_logic := '0'				--data output
		

	);
END ENTITY Master;

ARCHITECTURE Behavioral OF Master IS
	SIGNAL btn_inverted : std_logic_vector(2 DOWNTO 0) := (OTHERS => '0');
	--Control and instruction registers
	SIGNAL control_signals : Std_logic_vector(24 -1 DOWNTO 0) := (OTHERS => '0'); --Control signals generated by the control block
	SIGNAL instruction : std_logic_vector(32 -1 DOWNTO 0) := (OTHERS => '0'); --instruction sent to the system
	SIGNAL pram_data_out : std_logic_vector(32 -1 DOWNTO 0) := (OTHERS => '0'); --instruction oututted by the program memory
	
	--Wires
	SIGNAL operand_a, operand_b, alu_output : std_logic_vector(16 -1 DOWNTO 0); -- ALU inputs and output wires
	SIGNAL stack_controller_out : std_logic_vector(16 -1 DOWNTO 0); --Stackpointer address wires
	SIGNAL register_writeback : std_logic_vector(16 -1 DOWNTO 0); --Wires to connect ALU/Memory output to register writeback logic
	SIGNAL dram_address_index : std_logic_vector(16 -1 DOWNTO 0); --Wires connected to the memory controllers address port
	SIGNAL r2_w1_switch : std_logic_vector(4 DOWNTO 0); --Size '5' to be able to index register. Is used to switch between indexing Read_2 and Write_1 register

	--PRAM Signals
	SIGNAL PC : std_logic_vector(13 -1 DOWNTO 0) := (OTHERS => '0'); --Program Counter
	SIGNAL pram_address_index : std_logic_vector(13 -1 DOWNTO 0) := (OTHERS => '0'); --Wires connected to the PRAM's address port
	SIGNAL PC_ALT : std_logic_vector(13 -1 DOWNTO 0) := (OTHERS => '0'); --Alternative new PC (e.g. ALU/Memory Output), used when changing the PC (for jumps)
	SIGNAL interrupt_address : std_logic_vector(13 -1 DOWNTO 0) := (OTHERS => '0'); --Interrupt address, address that the ISR points to
	SIGNAL pDataIn : std_logic_vector(32 -1 DOWNTO 0); --Not used in current implementation, used to write to program memory
	SIGNAL pDataOut : std_logic_vector(32 -1 DOWNTO 0); --Program Memory instruction output
	SIGNAL previous_instruction : std_logic_vector(32 -1 DOWNTO 0);
	SIGNAL pram_write_enable : std_logic := '0'; --Program memory write enable disabled in current implementation
	SIGNAL pram_read_enable : std_logic := '1'; --Program memory read enable always on in current implementation
	--DRAM Signals
	SIGNAL dram_data_out : std_logic_vector(16 -1 DOWNTO 0); --Data RAM output data
	SIGNAL dram_data_in : std_logic_vector(16 -1 DOWNTO 0); --Data RAM Input data, either source_register_2_output, or R2O-2 (needed for proper interrupt implementation)

	SIGNAL fir_coefficient_in : std_logic_vector(16 -1 downto 0) := (others=>'0');
	SIGNAL fir_data_in : std_logic_vector(16 -1 downto 0) := (others=>'0');
	SIGNAL fir_data_out : std_logic_vector(16 -1 downto 0) := (others=>'0');
	SIGNAL fir_load_data_enable : std_logic := '0';
	SIGNAL fir_write : std_logic := '0';

	SIGNAL processing_output : std_logic_vector(16 -1 DOWNTO 0);
	--Reg Signals
	SIGNAL source_register_2_output : STD_logic_vector(16 -1 DOWNTO 0); --2nd indexed register output, needed as a buffer to be able to switch bewtween register_2 and Immediate input to the alu

	SIGNAL jmp_enable : std_logic := '0'; --Is '0' when PC increments by 1, is set to '1' when jump occours
	SIGNAL jmp_enable_latch : std_logic := '0';
	SIGNAL PC_TEMP : std_logic_vector(13 -1 DOWNTO 0) := (OTHERS => '0'); --Program Counter

	SIGNAL pc_overwrite, sp_overwrite : std_logic := '0'; --SP and PC are special registers, and PC/sp_overwrite needs to be '1' to be able to change their values

	SIGNAL pc_register_file_input : std_logic_vector(16 -1 DOWNTO 0); --Routes PC+1 into the register file

	SIGNAL interrupt_cpu : std_logic := '0'; --Interrupt signal for the CPU
	SIGNAL Interrupt_latch : std_logic := '0'; --Latch for the interrupt signal, ensures signal stays on for an additional clock cycle    (Varaible can not use small letters for some reason)
	SIGNAl interrupt_enable : std_logic := '1';
	SIGNAL interrupt_nest_enable : std_logic := '1';
	SIGNAL interrupt_nest_enable_latch : std_logic := '0';

	--FLAGS
	SIGNAL parity_flag                      : std_logic                    := '0';
	SIGNAL signed_flag                      : std_logic                    := '0';
	SIGNAL overflow_flag                    : std_logic                    := '0';
	SIGNAL zero_flag                        : std_logic                    := '0';
	SIGNAL carry_flag                       : std_logic                    := '0';

	--FLAG LATCHES
	SIGNAL parity_flag_latch                : std_logic                    := '0';
	SIGNAL signed_flag_latch                : std_logic                    := '0';
	SIGNAL overflow_flag_latch              : std_logic                    := '0';
	SIGNAL zero_flag_latch                  : std_logic                    := '0';
	SIGNAL carry_flag_latch                 : std_logic                    := '0';
	
	SIGNAL sys_clk : std_logic; --Clock that controls the system, can either be assigned to the normal clock (for simulation), or pll_tmp_clk
	SIGNAL pll_clk : std_logic; --PLL Clock
	SIGNAL pll_clk_i2s : std_logic; --PLL Clock
	SIGNAL pll_lock : std_logic; --PLL lock signal
	SIGNAL pll_i2s_lock : std_logic;
	SIGNAL pll_tmp_clk : std_logic; --Is assigned the pll_clk when pll_lock is detected
	SIGNAL pll_i2s_tmp_clk : std_logic;
	SIGNAL clk_counter : std_logic_vector(2 DOWNTO 0); --Clock divider, used to switch LED (works as a clock heart beat)

	SIGNAL FLAG_FITLER : std_logic_vector(1 downto 0);
BEGIN

	PLL : ENTITY work.PLL(SYN)
		PORT MAP(
			inclk0 => clk,
			c0 => pll_clk,
			locked => pll_lock
		);

	PLL_i2s : ENTITY work.PLL_i2s(SYN)
	PORT MAP(
		inclk0 => clk,
		c1 => pll_clk_i2s,
		locked => pll_i2s_lock
	);
	MEMCNT : ENTITY work.MemoryController
		PORT MAP(
			write_enable => control_signals(8),
			read_enable => control_signals(9),
			address => dram_address_index,
			data_in => dram_data_in,
			data_out => dram_data_out,
			CLK => sys_clk,
			btn => btn_inverted,
			seven_seg_control_signals => sseg,
			interrupt_address => interrupt_address,
			interrupt_cpu => interrupt_cpu,
			interrupt_enable => interrupt_enable,
			interrupt_nest_enable => interrupt_nest_enable,
			i2s_bit_clk => bclk,
			i2s_bit_clk_2 => pll_i2s_tmp_clk,
			--i2s_bit_clk_2 => bclk,
			i2s_word_select => ws,
			i2s_data_in => Din,
			i2s_bit_clk_out => bclkO,
			i2s_word_select_out => wsO,
			i2s_data_out => DOut
		);

	CONTROLLER : ENTITY work.Control(Behavioral)
		PORT MAP(
			opcode => instruction(31 DOWNTO 26),
			control_signals => control_signals
		);
	
	STACK : ENTITY work.Stack(Behavioral)
		PORT MAP(
			pop => control_signals(3),
			push => control_signals(4),
			clk => sys_clk,
			address_out => stack_controller_out,
			address_in => register_writeback,
			write_back => sp_overwrite
		);

	ALU : ENTITY work.ALU(Behavioral)
		PORT MAP(
			operation => control_signals(23 DOWNTO 18),
			operand_a => operand_a,
			operand_b => operand_b,
			result => alu_output,
			parity_flag => Parity_Flag,
			signed_flag => Signed_Flag,
			overflow_flag => Overflow_Flag,
			zero_flag => Zero_Flag,
			carry_flag => Carry_Flag
		);
	FIR : ENTITY work.Filter(Behavioural)
		PORT MAP(
		clk    => sys_clk,   
		load_system_input => fir_load_data_enable,
		reset  => control_signals(10), 
		system_input   => fir_data_in,  
		coefficient_in => fir_coefficient_in,  
		system_output  => fir_data_out,
		write_enable => fir_write
		);

	PRAM : ENTITY work.MemAuto(SYN)
		PORT MAP(
			data => pDataIn,
			q => pram_data_out,
			address => pram_address_index,
			wren => pram_write_enable,
			rden => pram_read_enable,
			clock => sys_clk
		);
	REGS : ENTITY work.RegistryInternal(Behavioral)
		PORT MAP(
			read_register_a_index => instruction(25 DOWNTO 21),
			write_register_index => instruction(20 DOWNTO 16),
			read_register_b_index => r2_w1_switch,

			register_file_data_in => register_writeback,

			register_file_data_out_a => operand_a,
			register_file_data_out_b => source_register_2_output,

			pc_value_input => pc_register_file_input,
			sp_value_input => stack_controller_out,

			write_enable => control_signals(7),

			clk => sys_clk
		);



	--Maybe Not needed
	PROCESS(source_register_2_output, jmp_enable_latch)
	BEGIN
	IF (jmp_enable_latch = '1') THEN
		dram_data_in <= "000"  & PC_TEMP-2; --pc-1 is used since pc-1 never executed, due to the interrupts blocing it
	ELSE
		dram_data_in <= source_register_2_output;
	END IF;
	END PROCESS;

	--------------------------------------------
	-- ImmediateOperand:
	-- If the Immediate control signal is set, 
    -- then the ALU's B operand is assigned the lowest 16 bit of the executing instruction
	-- as opposed to the register files 2nd output.
	-- This is done to allow register-immediate arithmatic,
	-- as opposed to only register-register arithmatic
	--------------------------------------------
	ImmediateOperand : WITH control_signals(5) SELECT operand_b <= -- Selects Register output 2 or Immediate
	source_register_2_output WHEN '0',
	instruction(15 DOWNTO 0) WHEN '1',
	source_register_2_output WHEN OTHERS;

	--------------------------------------------
	-- SwitchReadWriteIndex:
    -- Under normal operation the "read_register_b_index" is indexed by "instruction(15 DOWNTO 11)",
	-- except when excuting a "store" instruction (this sets "2" high). In that case
	-- it is indexed by "instruction(20 DOWNTO 16)"
	--
	-- This is necessary, as the "store" instruction is the only instruction requiring an immediate value as well
	-- as the data from two registers (and no destination registers to writeback data to). 
	--
	-- To elaborate, the standard grouping of instruction signals used for indexing "read_register_b_index" overlaps with with
	-- the immediate signal grouping "instruction(15 DOWNTO 0)" and can therfore not be used. Instead the grouping
	-- conventionally used for index the write index "instruction(20 DOWNTO 16)" is used since no writeback is required
	-- for the "store" instruction
	--------------------------------------------
	SwitchReadWriteIndex : WITH control_signals(2) SELECT r2_w1_switch <=
	instruction(20 DOWNTO 16) WHEN '1',
	instruction(15 DOWNTO 11) WHEN OTHERS;
	
	PROCESS(control_signals(12),control_signals(11),control_signals(10))
	BEGIN
		IF(control_signals(12) = '1' OR control_signals(11) = '1' OR control_signals(10) = '1') THEN
			fir_write <= '1';
		ELSE
			fir_write <= '0';
		END IF;
	END PROCESS;

	PROCESS(control_signals(12),control_signals(11), alu_output, operand_a, operand_b)
	BEGIN
		IF(control_signals(12) = '1') THEN
			fir_load_data_enable <= '1';
			fir_data_in <= alu_output;
		ELSIF(control_signals(11) = '1') THEN
			fir_load_data_enable <= '0';
			fir_coefficient_in <= alu_output;
		ELSE
			fir_load_data_enable <= '0';
		END IF;
	END PROCESS;
	
	WITH control_signals(13 DOWNTO 12) SELECT processing_output <=
		fir_data_out WHEN "01",
		fir_data_out WHEN "11", --replicated since the cpu doesn't function without this
		"00000000000" & carry_flag_latch & parity_flag_latch & signed_flag_latch & overflow_flag_latch & zero_flag_latch WHEN "10",
		alu_output WHEN OTHERS;

	--------------------------------------------
	-- MemoryRegisterWrite:
	-- Process controls what data is written to the register file.
	-- If "6" is high, the dram output is written,
	-- otherwise the ALU output is written
	--------------------------------------------
	MemoryRegisterWrite : WITH control_signals(6) SELECT register_writeback <=
	dram_data_out WHEN '1',
	processing_output  WHEN OTHERS;

	--------------------------------------------
	-- PcOvewriteEnable:
	-- Sets "pc_overwrite" if 31 (the register index corresponding to the PC register) is indexed TODO: Implement like SP?
	--------------------------------------------
	PcOvewriteEnable : WITH to_integer(unsigned(instruction(20 DOWNTO 16))) SELECT pc_overwrite <=
	'1' WHEN 31,
	'0' WHEN OTHERS;

	--------------------------------------------
	-- SpOvewriteEnable:
	-- Sets "sp_overwrite" if 30 (the register index corresponding to the SP register) is indexed
	--------------------------------------------
	SpOvewriteEnable : PROCESS (instruction(20 DOWNTO 16), control_signals(2))
	BEGIN
		IF (to_integer(unsigned(instruction(20 DOWNTO 16))) = 30 AND control_signals(2) /= '1') THEN
			sp_overwrite <= '1';
		ELSE
			sp_overwrite <= '0';
		END IF;
	END PROCESS;


	--------------------------------------------
	-- DramAddressIndex:
	-- If 3/4 instruction is exectuing, then index memory based on Stack Controller
	-- Otherwise index based on ALU output
	--------------------------------------------
	DramAddressIndex : PROCESS (control_signals(3), control_signals(4), stack_controller_out, processing_output )
		VARIABLE TMP : std_logic_vector(1 DOWNTO 0);
	BEGIN
		TMP := control_signals(3) & control_signals(4);
		IF (to_integer(UNSIGNED(TMP)) > 0) THEN
			dram_address_index <= stack_controller_out;
		ELSE
			dram_address_index <= processing_output ;
		END IF;
	END PROCESS;

	--------------------------------------------
	-- JumpEnable:
	-- enables/disables "jmp_enable" based
	-- on various control signals
	--------------------------------------------
	JumpEnable : WITH to_integer(unsigned(Interrupt_latch & pc_overwrite & control_signals(17 DOWNTO 15))) SELECT jmp_enable <= --Controls branching/changing PC
	'0' WHEN 0, --If not signals are high, then do not enable branching
	'1' WHEN 1, --unconditional jump
	zero_flag_latch WHEN 2, --jmpeq
	carry_flag_latch WHEN 3, --jmple
	NOT zero_flag_latch WHEN 4, --jmpnq
	parity_flag_latch WHEN 5,
	'1' WHEN 8, --Jump (change pc) when pc_overwrite is set 
	'1' WHEN 16, --Jump When Interrupt_latch is set
	'0' WHEN OTHERS;

	--------------------------------------------
	-- SetAlternativePc:
	-- Sets pc_alt based on interrupt status and the 1 control line
	--------------------------------------------
	SetAlternativePc : PROCESS (Interrupt_latch, control_signals(1), dram_data_out(13 -1 DOWNTO 0), processing_output (13 -1 DOWNTO 0))
	BEGIN
		IF (Interrupt_latch = '1') THEN
			pc_alt <= interrupt_address;
		ELSIF (control_signals(1) = '1') THEN
			pc_alt <= dram_data_out(13 -1 DOWNTO 0);
		ELSE
			pc_alt <= processing_output (13 -1 DOWNTO 0);
		END IF;
	END PROCESS;

	--------------------------------------------
	-- PramAddressSource:
	-- Choses instruction to be loaded based on branching.
	-- Loads "pc_alt" if "jump_enabled" is high
	-- Otherwise load "pc"
	--------------------------------------------
	PramAddressSource : WITH jmp_enable SELECT pram_address_index <=
		pc_alt WHEN '1', --Load pc alt if jump enabled
		pc WHEN OTHERS; --otherwise load pc




	--------------------------------------------
	-- InstructionSource:
	-- Changes instruction source if interrupt is detected
	--------------------------------------------
	InstructionSource : PROCESS (Interrupt_latch, pram_data_out)
	BEGIN
		IF (Interrupt_latch = '1') THEN
			instruction <= "10000100000000001111100000000000"; --if interrupt is set, then sets the output instruction to 4 PC (bypassing PRAM output)
		ELSE
			instruction <= pram_data_out; --Otherwise set the output instruction to PRAM output
		END IF;
	END PROCESS;


	--------------------------------------------
	-- SetPc:
	-- Chose new value of PC based on branching/interrupts
	--------------------------------------------
	SetPc : PROCESS (sys_clk) --Chose new value of PC based on branching
	BEGIN
		IF (rising_edge(sys_clk)) THEN
			IF (jmp_enable /= '1') THEN
				pc <= std_logic_vector(unsigned(pc) + 1); --Most common mode, simply increments PC every clock cycle
			ELSE
				pc <= std_logic_vector(unsigned(pc_alt) + 1); --If jump was performed, then set PC to "PC_ALT+1" (NOT "PC_ALT", as that is directly passed to the PRAM address index
			END IF;											  --If "PC_ALT" were to be passed direcly, then the instruction would run twice)		
		END IF;
	END PROCESS;

	--------------------------------------------
	-- EnableInterrupts:
	-- Enables/disables interrupts based on "interrupt_nest_enable" (send from the interrupt peripheral)
	--------------------------------------------
	EnableInterrupts : PROCESS (instruction, interrupt_nest_enable)
	BEGIN
		IF (interrupt_nest_enable = '0' AND interrupt_nest_enable_latch = '0') THEN --latching to ensure that the IF statement doesn't run an infinite loop when "interrupt_nest_enable" is set low
			interrupt_enable            <= '0';
			interrupt_nest_enable_latch <= '1'; 
		ELSIF (previous_instruction = "10000000000111110000000000000000") THEN --Resets interrupts when "10000000000111110000000000000000" is executed
			interrupt_enable            <= '1';
			interrupt_nest_enable_latch <= '0';
		END IF;
	END PROCESS;

	--------------------------------------------
	-- LatchInterrupt:
	-- latches interrupt_cpu and sets the PC top be pushed to the stack
	--------------------------------------------
	LatchInterrupt : PROCESS (sys_clk)
	BEGIN
		IF (rising_edge(sys_clk)) THEN
			IF (interrupt_cpu = '1') THEN
				Interrupt_latch <= '1';
				jmp_enable_latch <= jmp_enable; --Maybe delete latch
				PC_TEMP <= PC;
			ELSIF (Interrupt_latch = '1') THEN --Disables latc on the following clock cycle
				Interrupt_latch <= '0';
				jmp_enable_latch <= '0';
			END IF;
		END IF;
	END PROCESS;

	--------------------------------------------
	-- FlagLATCH:
	-- Latches Flags in temp register, neccesarry due to clock timing
	--------------------------------------------
	FlagLATCH : PROCESS (sys_clk)
	BEGIN
		IF (rising_edge(sys_clk)) THEN
			CASE control_signals(14) is
			WHEN '1' =>
				zero_flag_latch     <= processing_output(0);
				overflow_flag_latch <= processing_output(1);
				signed_flag_latch   <= processing_output(2);
				parity_flag_latch   <= processing_output(3);
				carry_flag_latch    <= processing_output(4);
			WHEN OTHERS =>  
				zero_flag_latch     <= zero_flag;
				overflow_flag_latch <= overflow_flag;
				signed_flag_latch   <= signed_flag;
				parity_flag_latch   <= parity_flag;
				carry_flag_latch    <= carry_flag;
			END CASE;
		END IF;
	END PROCESS;

	pc_register_file_input <= "000"  & std_logic_vector(unsigned(PC) - 1);

	PROCESS(sys_clk)
	BEGIN
		IF(rising_edge(sys_clk)) THEN
			previous_instruction <= instruction;
		END IF;
	END PROCESS;

	--------------------------------------------
	-- SysClockSelect:
	-- Controls "sys_clk" source
	--------------------------------------------
	SysClockSelect : WITH control_signals(0) SELECT sys_clk <=
	pll_tmp_clk WHEN '0',
	--DBtn(2) when '0',
	--clk_counter(2),
	--clk when '0',
	'0' WHEN OTHERS;

	--------------------------------------------
	-- WaitForPllLock:
	-- Only allows pll_clk to be accessible when a PLL lock is ensured 
	--------------------------------------------
	WaitForPllLock : WITH pll_lock SELECT pll_tmp_clk <=
		pll_clk WHEN '1',
		'0' WHEN OTHERS;
		
	WaitForPllI2sLock : WITH pll_i2s_lock SELECT pll_i2s_tmp_clk <=
		pll_clk_i2s WHEN '1',
		'0' WHEN OTHERS;
	--------------------------------------------
	-- ClockCount:
	-- Counts system clock rising edges
	--------------------------------------------
	ClockCount : PROCESS (pll_clk)
	BEGIN
		IF (rising_edge(pll_clk)) THEN
			clk_counter <= std_logic_vector(unsigned(clk_counter) + 1);
		END IF;
	END PROCESS;

	btn_inverted <= NOT btn;

	--Used for debugging
	--LED(9)       <= zero_flag;
	--LED(8)       <= overflow_flag;
	--LED(7)       <= signed_flag;
	--LED(6)       <= parity_flag;
	--LED(5)       <= btn_inverted(0);
	
	--LED(0)       <= clk_counter(24);
	--LED(1)       <= control_signals(0);

	--LED(0)       <= control_signals(0);
	--LED(1)       <= clk_counter(6);
	--LED(2)       <= clk_counter(8);
	--LED(3)       <= clk_counter(10);
	--LED(4)       <= clk_counter(12);
	--LED(5)       <= clk_counter(14);
	--LED(6)       <= clk_counter(18);
	--LED(7)       <= clk_counter(20);
	--LED(8)       <= clk_counter(22);
	--LED(9)       <= clk_counter(24);

	FLAG_FITLER <= control_signals(13) & control_signals(12);
END ARCHITECTURE Behavioral;