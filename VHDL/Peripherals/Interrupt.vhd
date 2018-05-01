#include "Config.hvhd"

--------------------------------------------------------------------------------------
--Engineer: Magnus Christensen
--Module Name: Interrupt Peripheral
--
--Description:
--
--
--
--------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;

--Seven segment display driver
--This driver is for a 4 panel sevensegment display with all segments directly connected

ENTITY Interrupt IS
	PORT (
        interrupt_btn : IN std_logic;
        interrupt_btn_reset : INOUT std_logic;

        interrupt_i2s : IN std_logic := '0';
        interrupt_i2s_reset : INOUT std_logic := '0';

        interrupt_enable : IN std_logic := '1';
        interrupt_nest_enable : OUT std_logic := '1' ;
        write_enable :IN std_logic;
        clk : IN std_logic;
        internal_register_address : IN std_logic_vector(1 downto 0);
        data_in : IN std_logic_vector(ADDRESS_SIZE downto 0);
        interrupt_address : OUT std_logic_vector(9 downto 0);
        interrupt_cpu : OUT std_logic
	);
END Interrupt;

ARCHITECTURE Behavioral OF Interrupt IS
 TYPE register_type IS ARRAY (3 DOWNTO 0) OF std_logic_vector(9 DOWNTO 0);
    SIGNAL REG : register_type := (OTHERS => "0000000000");

    SIGNAL Interrupt_btn_enable : std_logic := '0';
    SIGNAL Interrupt_btn_latch : std_logic := '0';
    SIGNAL Interrupt_btn_reset_sig : std_logic := '0';
    SIGNAL Interrupt_btn_nest_enable : std_logic := '0';
    SIGNAL Interrupt_btn_priority : integer := 0;

    SIGNAL Interrupt_I2S_enable : std_logic := '0';
    SIGNAL Interrupt_I2S_latch : std_logic := '0';
    SIGNAL Interrupt_I2S_reset_sig : std_logic := '0';
    SIGNAL Interrupt_I2S_nest_enable : std_logic := '0';
    SIGNAL Interrupt_I2S_priority : integer := 0;
 
BEGIN

    Enable_int : process(clk)
    BEGIN
        if(rising_edge(clk)) Then
            IF(interrupt_enable = '1') Then
                IF(Interrupt_btn_latch = '1') Then
                    IF(Interrupt_btn_enable = '1') THEN
                        interrupt_cpu <= '1';
                        Interrupt_btn_reset_sig <= '1';
                        interrupt_address <= REG(0);
                        interrupt_nest_enable <= Interrupt_btn_nest_enable;
                    ELSE
                        interrupt_cpu <= '0';
                        Interrupt_btn_reset_sig <= '0';
                        Interrupt_I2S_reset_sig <= '0';
                        interrupt_nest_enable <= '1';
                    END IF;
               ElSIF(Interrupt_I2S_latch = '1') THEN
                    IF(Interrupt_I2S_enable = '1') THEN
                        interrupt_cpu <= '1';
                        Interrupt_I2S_reset_sig <= '1';
                        interrupt_address <= REG(2);
                        interrupt_nest_enable <= Interrupt_I2S_nest_enable;
                    ELSE
                        interrupt_cpu <= '0';
                        Interrupt_btn_reset_sig <= '0';
                        Interrupt_I2S_reset_sig <= '0';
                        interrupt_nest_enable <= '1';
                    END IF;
                ELSE
                    interrupt_cpu <= '0';
                    Interrupt_btn_reset_sig <= '0';
                    Interrupt_I2S_reset_sig <= '0';
                    interrupt_nest_enable <= '1';
                END IF;
            ELSE
                interrupt_cpu <= '0';
                Interrupt_btn_reset_sig <= '0';
                Interrupt_I2S_reset_sig <= '0';
                interrupt_nest_enable <= '1';
            End IF;
        END IF;
    end process;

    BTN : PROCESS(interrupt_btn, Interrupt_btn_reset_sig,interrupt_btn_reset)
    BEGIN
        IF(Interrupt_btn_reset_sig = '1') THEN
            Interrupt_btn_latch <= '0';
        ElSIF(interrupt_btn = '1') THEN
            Interrupt_btn_latch <= '1';
        END IF;
        IF (Interrupt_btn_reset_sig = '1') THEN
            interrupt_btn_reset <= '1';
        ELSIF(interrupt_btn_reset = '1' AND interrupt_btn = '0') THEN
            interrupt_btn_reset <= '0';
        END IF;

    END PROCESS;

    I2S : PROCESS(interrupt_i2s, Interrupt_I2S_reset_sig,interrupt_i2s_reset)
    BEGIN
        IF(Interrupt_I2S_reset_sig = '1') THEN
            Interrupt_I2S_latch <= '0';
        ElSIF(interrupt_i2s = '1' AND interrupt_i2s_reset = '0') THEN
            Interrupt_I2S_latch <= '1';
        END IF;
        IF (Interrupt_I2S_reset_sig = '1') THEN
            interrupt_i2s_reset <= '1';
        ELSIF(interrupt_i2s_reset = '1' AND interrupt_i2s = '0') THEN
            interrupt_i2s_reset <= '0';
        END IF;

    END PROCESS;

    WriteProc : PROCESS (clk) IS
	BEGIN
			IF (write_enable = '1') THEN
				REG(to_integer(unsigned(internal_register_address))) <= data_in(9 downto 0);
			END IF;
	END PROCESS;

    Interrupt_btn_enable <= REG(1)(9);
    Interrupt_I2S_enable <= REG(3)(9);
    
    Interrupt_btn_nest_enable <= REG(1)(8);
    Interrupt_I2S_nest_enable <= REG(3)(8);

    Interrupt_btn_priority <= to_integer(unsigned(REG(1)(7 downto 0)));
    Interrupt_I2S_priority <= to_integer(unsigned(REG(3)(7 downto 0)));

END Behavioral;