






--------------------------------------------------------------------------------------
--Engineer: Jakob Thomsen, Mikkel Hardysoe, Magnus Christensen
--Module Name: Master
--
--Description:
--
--
--
--------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--use IEEE.std_logic_arith.all;

ENTITY RegistryInternal IS
	PORT
	(
		--Index of the two registers to be read
		read_register_a_index    : IN std_logic_vector(4 DOWNTO 0); 
		read_register_b_index    : IN std_logic_vector(4 DOWNTO 0);

		write_register_index     : IN std_logic_vector(4 DOWNTO 0); --Index of register to write data to

		register_file_data_in    : IN std_logic_vector(16-1 DOWNTO 0); --data to be written to a register

		--Data outputs
		register_file_data_out_a : OUT std_logic_vector(16-1 DOWNTO 0); 
		register_file_data_out_b : OUT std_logic_vector(16-1 DOWNTO 0);

		--Input data from the PC/SP register
		pc_value_input           : IN std_logic_vector(16-1 DOWNTO 0);
		sp_value_input           : IN std_logic_vector(16-1 DOWNTO 0);

		write_enable             : IN std_logic; --Write enable signal

		clk                      : IN std_logic  --System clock
	);

END RegistryInternal;

ARCHITECTURE Behavioral OF RegistryInternal IS

	TYPE register_type IS ARRAY (29 DOWNTO 0) OF std_logic_vector(16-1 DOWNTO 0);
	SIGNAL reg : register_type := (OTHERS => x"0000");
BEGIN

	--------------------------------------------
	-- RegIndex:
	-- Indexes, reads, and outputs the correct register
	-- data.
	-- Note that the Program counter and Stack Pointer Register
	-- are handled differently that the other 30 general purpose registers
	-- since the physical register is not located inside the register file
	--------------------------------------------
	RegIndex : PROCESS (read_register_a_index, read_register_b_index, write_register_index, write_enable, pc_value_input, reg) IS

	BEGIN
		IF to_integer(unsigned(read_register_a_index)) = 31 THEN --pc to outOne
			register_file_data_out_a <= pc_value_input;
		ELSIF to_integer(unsigned(read_register_a_index)) = 30 THEN
			register_file_data_out_a <= sp_value_input;
		ELSE
			register_file_data_out_a <= reg(to_integer(unsigned(read_register_a_index)));
		END IF;

		IF to_integer(unsigned(read_register_b_index)) = 31 THEN --pc to outTwo
			register_file_data_out_b <= pc_value_input;
		ELSIF to_integer(unsigned(read_register_b_index)) = 30 THEN
			register_file_data_out_b <= sp_value_input;
		ELSE
			register_file_data_out_b <= reg(to_integer(unsigned(read_register_b_index)));
		END IF;
	END PROCESS;

	--------------------------------------------
	-- WriteReg:
	-- Writes data to the 30 General purpose registers
	-- SP and PC writes are handled externally
	--------------------------------------------
	WriteReg : PROCESS (clk) IS
	BEGIN
		IF (rising_edge(clk)) THEN
			IF (write_enable = '1') THEN
				IF (to_integer(unsigned(write_register_index)) <= 29) THEN
					reg(to_integer(unsigned(write_register_index))) <= register_file_data_in;
				END IF;
			END IF;
		END IF;
	END PROCESS;

END Behavioral;