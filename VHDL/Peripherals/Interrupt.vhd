#include "Config.hvhd"

#define DEFAULT_BEHAVIOUR interrupt_cpu <= '0'; \
interrupt_btn_reset_latch <= '0';\
interrupt_i2s_reset_latch <= '0';\
interrupt_nest_enable <= '1';\
--\

#mode string QQQ "$$" "$$"
#define INTERRUPT_BEHAVIOUR(x,y) ELSIF( $$x$$_latch  = '1') Then \
IF($$x$$_enable = '1') THEN \
    interrupt_cpu <= '1'; \
    $$x$$_reset_latch <= '1'; \
    interrupt_address <= REG(y); \
    interrupt_nest_enable <= $$x$$_nest_enable; \
ELSE \
    DEFAULT_BEHAVIOUR \
END IF; \
--\

#define INTERRUPT_RESET(x) PROCESS($$x$$, $$x$$_reset_latch,$$x$$_reset) \
    BEGIN \
        IF($$x$$_reset_latch = '1') THEN\
            $$x$$_latch <= '0';\
        ElSIF($$x$$ = '1' AND $$x$$_reset = '0') THEN\
            $$x$$_latch <= '1';\
        END IF;\
        IF ($$x$$_reset_latch = '1') THEN\
            $$x$$_reset <= '1';\
        ELSIF($$x$$_reset = '1' AND $$x$$ = '0') THEN\
            $$x$$_reset <= '0';\
        END IF;\
    END PROCESS;\
--\

--Above macro is WIP, does not work with button interrupts

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

ENTITY Interrupt IS
	PORT (
        interrupt_btn : IN std_logic;                       --Is set high by the button peripheral to interrupt the CPU
        interrupt_btn_reset : INOUT std_logic;              --Is set high by the interrupt controller to reset the button peripheral's interrupt signal

        interrupt_i2s : IN std_logic := '0';                --Is set high by the i2s peripheral to interrupt the CPU
        interrupt_i2s_reset : INOUT std_logic := '0';       --Is set high by the interrupt controller to reset the i2s peripheral's interrupt signal

        interrupt_enable : IN std_logic := '1';             --Enables/Disables interrupts entirely 
        interrupt_nest_enable : OUT std_logic := '1' ;      --Tells the Main logic that whether nesting interrups are allowed. MUST ben high by default
        write_enable :IN std_logic;                         --Write enable to allow changes to the interrupt controllers configuration registers
        clk : IN std_logic;                                 --System Clock
        #ifdef LED_ENABLE
		led : OUT std_logic_vector(9 DOWNTO 0) := (OTHERS => '0'); 	--Signals for controlling onboard LED's
		#endif

        internal_register_address : IN std_logic_vector(1 downto 0);    --Addresses the configuration registers
        data_in : IN std_logic_vector(ADDRESS_SIZE downto 0);           --Input data to be written to the configuration registers
        interrupt_address : OUT std_logic_vector(9 downto 0);           --Address of the first instruction of an interrupt service routine
        interrupt_cpu : OUT std_logic                                   --Signals the CPU that an interrupt has occoured
	);
END Interrupt;

ARCHITECTURE Behavioral OF Interrupt IS
 TYPE register_type IS ARRAY (3 DOWNTO 0) OF std_logic_vector(9 DOWNTO 0);
    SIGNAL REG : register_type := (OTHERS => "0000000000");

    --These signals are configurable by the programmer
    SIGNAL interrupt_btn_enable : std_logic := '0';         --Enables/Disables Button Interrupts
    SIGNAL interrupt_btn_nest_enable : std_logic := '0';    --Enables/Disables nesting of Button Interrupts
    SIGNAL interrupt_btn_priority : integer := 0;           --Priority of the Button interrupt (currently not implemented)

    SIGNAL interrupt_btn_latch : std_logic := '0';          --Latches Button Interrupts
    SIGNAL interrupt_btn_reset_latch : std_logic := '0';    --Used to make sure that resat interrupts can not run until their interrupt is set low again 
                                                            --(so we aren't relying on a peripherals ability to quickly reset its interrupt)

    --Same functionaly as the button signals, just for
    --the i2s peripheral
    SIGNAL interrupt_i2s_enable : std_logic := '0';         
    SIGNAL interrupt_i2s_nest_enable : std_logic := '0';
    SIGNAL interrupt_i2s_priority : integer := 0;

    SIGNAL interrupt_i2s_latch : std_logic := '0';
    SIGNAL interrupt_i2s_reset_latch : std_logic := '0';      --Used to make sure that resat interrupts can not run until their interrupt is set low again 
                                                            --(so we aren't relying on a peripherals ability to quickly reset its interrupt)
    SIGNAL false_signal : std_logic := '0';
BEGIN

    --------------------------------------------
	-- InterruptCpu:
	-- Process wait for an interrupt signal from a
    -- peripheral, and then sends an interrupt
    -- signal to the CPU along with an accompanying
    -- ISR address, and a bool informing the CPU
    -- if nesting is allowed
	--------------------------------------------
    InterruptCpu : process(clk)
    BEGIN
        if(falling_edge(clk)) Then
            IF(interrupt_enable = '1') Then
                IF(false_signal = '1') THEN --Done to force an if statement, so the INTERRUPT _BEHAVIOUR can be used for all interrupts

                INTERRUPT_BEHAVIOUR(Interrupt_btn,0)

                INTERRUPT_BEHAVIOUR(interrupt_i2s,2)

                ELSE
                    DEFAULT_BEHAVIOUR
                END IF;
            ELSE
                DEFAULT_BEHAVIOUR
            End IF;
        END IF;
    end process;

    --------------------------------------------
	-- BtnResetLatching:
	-- Latches the reset signal to the button peripheral
    -- Used to make sure that the button interrupts can not run until their interrupt is set low again 
    --
    -- In practice this means that interrupts are dependent on changes (e.g rising /falling edges)
    -- from the received interrupt signals. This ensures that the CPU does not rely on a
    -- peripherals ability to quickly reset its interrupt
	--------------------------------------------
    --BtnResetLatching : INTERRUPT_ RESET(interrupt_btn)
    BtnResetLatching : PROCESS(clk)
    BEGIN
        IF(falling_edge(clk)) THEN
            IF(interrupt_btn_reset_latch = '1') THEN
                interrupt_btn_latch <= '0';
            ElSIF(interrupt_btn = '1') THEN
                interrupt_btn_latch <= '1';
            END IF;
            IF (interrupt_btn_reset_latch = '1') THEN
                interrupt_btn_reset <= '1';
            ELSIF(interrupt_btn_reset = '1' AND interrupt_btn = '0') THEN
                interrupt_btn_reset <= '0';
            END IF;
        END IF;   
    END PROCESS;

    --------------------------------------------
	-- I2sResetLatching:
	-- Latches the reset signal to the I2S peripheral
    -- Used to make sure that the i2s interrupts can not run until their interrupt is set low again 
    --
    -- In practice this means that interrupts are dependent on changes (e.g rising /falling edges)
    -- from the received interrupt signals. This ensures that the CPU does not rely on a
    -- peripherals ability to quickly reset its interrupt
	--------------------------------------------\

    --I2sResetL atching : INTERRUPT_ RESET(interrupt_i2s)

    I2sResetLatching : PROCESS(clk)
    BEGIN
        IF(falling_edge(clk)) THEN
            IF(interrupt_i2s_reset_latch = '1') THEN
                interrupt_i2s_latch <= '0';
            ElSIF(interrupt_i2s = '1' AND interrupt_i2s_reset = '0') THEN
                interrupt_i2s_latch <= '1';
            END IF;
            IF (interrupt_i2s_reset_latch = '1') THEN
                interrupt_i2s_reset <= '1';
            ELSIF(interrupt_i2s_reset = '1' AND interrupt_i2s = '0') THEN
                interrupt_i2s_reset <= '0';
            END IF;
        END IF;

    END PROCESS;


    --------------------------------------------
	-- WriteProccess:
	-- Writes data to the configuration registers
	--------------------------------------------
    WriteProccess : PROCESS (clk) IS
	BEGIN
        IF(rising_edge(clk)) THEN
			IF (write_enable = '1') THEN
				REG(to_integer(unsigned(internal_register_address))) <= data_in(9 downto 0);
			END IF;
        END IF;
	END PROCESS;

    --Maps registers to control signals
    interrupt_btn_enable <= REG(1)(9); 
    interrupt_i2s_enable <= REG(3)(9);
    
    interrupt_btn_nest_enable <= REG(1)(8);
    interrupt_i2s_nest_enable <= REG(3)(8);

    interrupt_btn_priority <= to_integer(unsigned(REG(1)(7 downto 0)));
    interrupt_i2s_priority <= to_integer(unsigned(REG(3)(7 downto 0)));



END Behavioral;