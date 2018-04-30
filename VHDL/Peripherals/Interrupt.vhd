#include "Config.hvhd"
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;

--Seven segment display driver
--This driver is for a 4 panel sevensegment display with all segments directly connected

ENTITY Interrupt IS
	PORT (
        Interrupt_btn : IN std_logic;
        Interrupt_btn_reset : INOUT std_logic;

        Interrupt_I2S : IN std_logic := '0';
        Interrupt_I2S_reset : INOUT std_logic := '0';

        Interrupt_enable : IN std_logic := '1';
        Interrupt_nest_enable : OUT std_logic := '1' ;
        Write_enable :IN std_logic;
        clk : IN std_logic;
        Address : IN std_logic_vector(1 downto 0);
        Data : IN std_logic_vector(ADDRESS_SIZE downto 0);
        Control : OUT std_logic_vector(9 downto 0);
        Interrupt_cpu : OUT std_logic
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
            IF(Interrupt_enable = '1') Then
                IF(Interrupt_btn_latch = '1') Then
                    IF(Interrupt_btn_enable = '1') THEN
                        Interrupt_cpu <= '1';
                        Interrupt_btn_reset_sig <= '1';
                        Control <= REG(0);
                        Interrupt_nest_enable <= Interrupt_btn_nest_enable;
                    ELSE
                        Interrupt_cpu <= '0';
                        Interrupt_btn_reset_sig <= '0';
                        Interrupt_I2S_reset_sig <= '0';
                        Interrupt_nest_enable <= '1';
                    END IF;
               ElSIF(Interrupt_I2S_latch = '1') THEN
                    IF(Interrupt_I2S_enable = '1') THEN
                        Interrupt_cpu <= '1';
                        Interrupt_I2S_reset_sig <= '1';
                        Control <= REG(2);
                        Interrupt_nest_enable <= Interrupt_I2S_nest_enable;
                    ELSE
                        Interrupt_cpu <= '0';
                        Interrupt_btn_reset_sig <= '0';
                        Interrupt_I2S_reset_sig <= '0';
                        Interrupt_nest_enable <= '1';
                    END IF;
                ELSE
                    Interrupt_cpu <= '0';
                    Interrupt_btn_reset_sig <= '0';
                    Interrupt_I2S_reset_sig <= '0';
                    Interrupt_nest_enable <= '1';
                END IF;
            ELSE
                Interrupt_cpu <= '0';
                Interrupt_btn_reset_sig <= '0';
                Interrupt_I2S_reset_sig <= '0';
                Interrupt_nest_enable <= '1';
            End IF;
        END IF;
    end process;

    BTN : PROCESS(Interrupt_btn, Interrupt_btn_reset_sig,Interrupt_btn_reset)
    BEGIN
        IF(Interrupt_btn_reset_sig = '1') THEN
            Interrupt_btn_latch <= '0';
        ElSIF(Interrupt_btn = '1') THEN
            Interrupt_btn_latch <= '1';
        END IF;
        IF (Interrupt_btn_reset_sig = '1') THEN
            Interrupt_btn_reset <= '1';
        ELSIF(Interrupt_btn_reset = '1' AND Interrupt_btn = '0') THEN
            Interrupt_btn_reset <= '0';
        END IF;

    END PROCESS;

    I2S : PROCESS(Interrupt_I2S, Interrupt_I2S_reset_sig,Interrupt_I2S_reset)
    BEGIN
        IF(Interrupt_I2S_reset_sig = '1') THEN
            Interrupt_I2S_latch <= '0';
        ElSIF(Interrupt_I2S = '1' AND Interrupt_I2S_reset = '0') THEN
            Interrupt_I2S_latch <= '1';
        END IF;
        IF (Interrupt_I2S_reset_sig = '1') THEN
            Interrupt_I2S_reset <= '1';
        ELSIF(Interrupt_I2S_reset = '1' AND Interrupt_I2S = '0') THEN
            Interrupt_I2S_reset <= '0';
        END IF;

    END PROCESS;

    WriteProc : PROCESS (clk) IS
	BEGIN
			IF (Write_enable = '1') THEN
				REG(to_integer(unsigned(Address))) <= Data(9 downto 0);
			END IF;
	END PROCESS;

    Interrupt_btn_enable <= REG(1)(9);
    Interrupt_I2S_enable <= REG(3)(9);
    
    Interrupt_btn_nest_enable <= REG(1)(8);
    Interrupt_I2S_nest_enable <= REG(3)(8);

    Interrupt_btn_priority <= to_integer(unsigned(REG(1)(7 downto 0)));
    Interrupt_I2S_priority <= to_integer(unsigned(REG(3)(7 downto 0)));

END Behavioral;