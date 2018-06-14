#include VGA_Config.hvhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_Standalone is
   Port 	 ( 
	   			reset 		: in  STD_LOGIC;
				clk     	: in std_logic;
				sw 			: in  STD_LOGIC_vector (9 downto 0);
				led 		: out  STD_LOGIC_vector (9 downto 0);

				HEX0		: out std_logic_vector (6 downto 0);
				HEX1		: out std_logic_vector (6 downto 0);
				HEX2		: out std_logic_vector (6 downto 0);
				HEX3		: out std_logic_vector (6 downto 0);
				--HEX4		: out std_logic_vector (6 downto 0);
				--HEX5		: out std_logic_vector (6 downto 0);
	
				VGA_Red		: out std_logic_vector (3 downto 0);
				VGA_Green	: out std_logic_vector (3 downto 0);
				VGA_Blue	: out std_logic_vector (3 downto 0);
				VGA_H_SYNC	: out std_logic;
				VGA_V_SYNC	: out std_logic;

				btn 		: in std_logic_vector (3 downto 0)

	);
end VGA_Standalone;

architecture VGA_Standalone of VGA_Standalone is
	component VGAGPU is
        Port 	 ( 
                     reset 		        : in  STD_LOGIC;
                     clk_50 		    : in std_logic;
                     clk_sync	        : in std_logic;
     
                     point_address  	:  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= (OTHERS => '0');    --Address for writing a point to ram
                     point_in  			:  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= (14=>'1',OTHERS => '0'); --The data to write to the specified address
                     point_write_enable :  IN STD_LOGIC:='0';                                                   --Write enable
             
                     max_y              :  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= (15=>'1',OTHERS => '1'); --Scaling for the y-axis, max_y will be the max value shown
                     bg_color           :  IN std_logic_vector(RED_BIT_WIDTH+GREEN_BIT_WIDTH+BLUE_BIT_WIDTH-1 DOWNTO 0):=x"422";  --Color for the background (BGR)
                     p_color            :  IN std_logic_vector(RED_BIT_WIDTH+GREEN_BIT_WIDTH+BLUE_BIT_WIDTH-1 DOWNTO 0):=x"33b";  --Color for the points (BGR)
                     grid_color         :  IN std_logic_vector(RED_BIT_WIDTH+GREEN_BIT_WIDTH+BLUE_BIT_WIDTH-1 DOWNTO 0):=x"666";  --Color for the grid (BGR)
                     h_grid             :  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0) := x"0013";      --Grid distance horizontal
                     v_grid             :  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0) := x"0013";      --Grid distance vertical
                     thickness          :  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0) := x"0003";       --Thickness of the line when linemode is on 
                     lines_on           :  IN STD_LOGIC :='1';    --Linemode on/off
             
                     VGA_Red	        : out std_logic_vector (3 downto 0);
                     VGA_Green	        : out std_logic_vector (3 downto 0);
                     VGA_Blue	        : out std_logic_vector (3 downto 0);
                     VGA_H_SYNC	        : out std_logic;
                     VGA_V_SYNC	        : out std_logic
     
                   
         );
     end component;

    component ssgddriver IS
     PORT
     (
         clr                       : IN STD_LOGIC; --Clear
         bcd_enable                : IN std_LOGIC; --Enable BCD format
         input_data                : IN STD_LOGIC_vector (15 DOWNTO 0) := (OTHERS => '0'); --Hex data in 4 nibbles
         seven_seg_control_signals : OUT STD_LOGIC_vector (31 DOWNTO 0) --Segments connections (31| dot4 - 7seg4 - dot3 - 7seg3 - dot2 - 7seg2 - dot1 - 7seg1 |0)
     );
    END component;

    signal point_address        : std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= (OTHERS => '0'); 
    signal point_in  		    : std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= (14=>'1',OTHERS => '0');
    signal point_write_enable   : STD_LOGIC:='0';     

    signal max_y              :  std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= (15=>'1',OTHERS => '1'); --Scaling for the y-axis, max_y will be the max value shown
    signal bg_color           :  std_logic_vector(RED_BIT_WIDTH+GREEN_BIT_WIDTH+BLUE_BIT_WIDTH-1 DOWNTO 0):=x"633";  --Color for the background (BGR)
    signal p_color            :  std_logic_vector(RED_BIT_WIDTH+GREEN_BIT_WIDTH+BLUE_BIT_WIDTH-1 DOWNTO 0):=x"33b";  --Color for the points (BGR)
    signal grid_color         :  std_logic_vector(RED_BIT_WIDTH+GREEN_BIT_WIDTH+BLUE_BIT_WIDTH-1 DOWNTO 0):=x"666";  --Color for the grid (BGR)
    signal h_grid             :  std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0) := x"0014";      --Grid distance horizontal
    signal v_grid             :  std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0) := x"0014";      --Grid distance vertical
    signal thickness          :  std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0) := x"0001"; --Thickness of the line when linemode is on 
    signal lines_on           :  STD_LOGIC :='1';    --Linemode on/off
    
    signal data_peek           : std_logic_vector(16 - 1 DOWNTO 0);
    signal sseg 			    : STD_LOGIC_vector (41 downto 0):=( others =>'1');	
    signal menu_index           : integer range 0 to 9;

begin

    HEX0 <= sseg(6 downto 0);
	HEX1 <= sseg(14 downto 8);
	HEX2 <= sseg(22 downto 16);
	HEX3 <= sseg(30 downto 24);
	--HEX4 <= sseg(34 downto 28);
	--HEX5 <= sseg(41 downto 35);


	
GPU : component VGAGPU 
port map (
    reset 		        => not reset 		    ,       
    clk_50 		        =>clk 		            ,
    clk_sync	        =>clk	                ,   
    point_address  	    =>point_address  	    ,   
    point_in  		    =>point_in  		    ,	
    point_write_enable  =>point_write_enable    ,
    max_y               =>max_y                 ,
    bg_color            =>bg_color              ,
    p_color             =>p_color               ,
    grid_color          =>grid_color            ,
    h_grid              =>h_grid                ,
    v_grid              =>v_grid                ,
    thickness           =>thickness             ,
    lines_on            =>lines_on              ,
    VGA_Red	            =>VGA_Red	            , 
    VGA_Green	        =>VGA_Green	            ,
    VGA_Blue	        =>VGA_Blue	            ,
    VGA_H_SYNC	        =>VGA_H_SYNC	        ,   
    VGA_V_SYNC	        =>VGA_V_SYNC	          
);
ssegd : component ssgddriver
port map (
clr                       =>reset,
bcd_enable                => '0',
input_data                => data_peek,
seven_seg_control_signals => sseg(31 downto 0)
);
process(btn)
begin

if btn(0)='1' then
menu_index <= menu_index + 1;
elsif btn(1)='1' then
menu_index <= menu_index + 1;
elsif btn(2)='1' then

elsif btn(3)='1' then

end if;

end process;

with menu_index select led <=
    (0=>'1',others=>'0') when 0,
    (1=>'1',others=>'0') when 1,
    (2=>'1',others=>'0') when 2,
    (3=>'1',others=>'0') when 3,
    (4=>'1',others=>'0') when 4,
    (5=>'1',others=>'0') when 5,
    (6=>'1',others=>'0') when 6,
    (7=>'1',others=>'0') when 7,
    (8=>'1',others=>'0') when 8,
    (9=>'1',others=>'0') when 9;
	
end VGA_Standalone;