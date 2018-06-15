#include VGA_Config.hvhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGAGPU is
   Port 	 ( 
	   			reset 		: in  STD_LOGIC;
				clk_50 		: in std_logic;
				clk_sync	: in std_logic;

				point_address  		:  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= (OTHERS => '0');    --Address for writing a point to ram
				point_in  			:  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= (14=>'1',OTHERS => '0'); --The data to write to the specified address
				point_write_enable 	: IN STD_LOGIC:='0';                                                   --Write enable
		
				max_y     :  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= (15=>'1',OTHERS => '1'); --Scaling for the y-axis, max_y will be the max value shown
				bg_color  :  IN std_logic_vector(RED_BIT_WIDTH+GREEN_BIT_WIDTH+BLUE_BIT_WIDTH-1 DOWNTO 0):=x"422";  --Color for the background (BGR)
				p_color   :  IN std_logic_vector(RED_BIT_WIDTH+GREEN_BIT_WIDTH+BLUE_BIT_WIDTH-1 DOWNTO 0):=x"33b";  --Color for the points (BGR)
				grid_color:  IN std_logic_vector(RED_BIT_WIDTH+GREEN_BIT_WIDTH+BLUE_BIT_WIDTH-1 DOWNTO 0):=x"666";  --Color for the grid (BGR)
				h_grid    			:  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= x"0014";      --Grid distance horizontal
				v_grid    			:  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= x"0014";     --Grid distance vertical
				thickness 			:  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= x"0001";       --Thickness of the line when linemode is on 
				lines_on  :  IN STD_LOGIC :='1';    --Linemode on/off
		
				VGA_Red		: out std_logic_vector (3 downto 0);
				VGA_Green	: out std_logic_vector (3 downto 0);
				VGA_Blue	: out std_logic_vector (3 downto 0);
				VGA_H_SYNC	: out std_logic;
				VGA_V_SYNC	: out std_logic
	);
end VGAGPU;

architecture VGAGPU of VGAGPU is
	component PLL_VGA is 
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic;        -- outclk0.clk
		locked   : out std_logic         --  locked.export
	);
end component;
component VGAController is 
	Port ( 
		clk 						: in  STD_LOGIC; -- 25 mhz clk
		reset						: in std_logic;
		row, col					: out integer;
		disp_en, h_sync, v_sync  	: out std_logic
	);
end component;

component VGAGraphGen is 
	Port ( 
		point_address  		:  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= (OTHERS => '0');    --Address for writing a point to ram
        point_in  			:  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= (14=>'1',OTHERS => '0'); --The data to write to the specified address
        point_write_enable 	:  IN STD_LOGIC:='0';                                                   --Write enable

        max_y     			:  IN std_logic_vector(POINT_BIT_WIDTH - 1 DOWNTO 0):= (15=>'1',OTHERS => '1'); --Scaling for the y-axis, max_y will be the max value shown
        bg_color  			:  IN std_logic_vector(RED_BIT_WIDTH+GREEN_BIT_WIDTH+BLUE_BIT_WIDTH-1 DOWNTO 0):=x"422";  --Color for the background (BGR)
        p_color   			:  IN std_logic_vector(RED_BIT_WIDTH+GREEN_BIT_WIDTH+BLUE_BIT_WIDTH-1 DOWNTO 0):=x"33b";  --Color for the points (BGR)
        grid_color			:  IN std_logic_vector(RED_BIT_WIDTH+GREEN_BIT_WIDTH+BLUE_BIT_WIDTH-1 DOWNTO 0):=x"666";  --Color for the grid (BGR)
		h_grid    			:  IN INTEGER := 20;      --Grid distance horizontal
		v_grid    			:  IN INTEGER := 20;      --Grid distance vertical
		thickness 			:  IN INTEGER := 3;       --Thickness of the line when linemode is on 
        lines_on  			:  IN STD_LOGIC :='1';    --Linemode on/off

		bclk				:	IN 	STD_LOGIC;	
		write_clk			:	IN 	STD_LOGIC;
		disp_ena 			:  	IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
		row      			:  	IN   INTEGER;    --row pixel coordinate
		column   			:  	IN   INTEGER;    --column pixel coordinate
		red      			:  	OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) ;  --red magnitude output to DAC
		green    			:  	OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) ;  --green magnitude output to DAC
		blue     			:  	OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)  --blue magnitude output to DAC
	);
	end component;

	signal disp_en_s		: std_logic ;
	signal row_s, col_s 	: integer;
	signal sseg 			: STD_LOGIC_vector (41 downto 0);
	signal mclk 			: std_logic;


begin


clk1 : component PLL_VGA
	port map (
				refclk=>clk_50,
				rst=>reset,
				outclk_0 =>mclk
				);
	
controller : component VGAController 
port map (
	clk 		=>	mclk		,
	reset		=>	reset	,	
	row			=>	row_s	,
	col			=>	col_s	,
	disp_en		=>	disp_en_s,
	h_sync		=>	VGA_H_SYNC,
	v_sync 		=>	VGA_v_SYNC
);

imagegen : component VGAGraphGen 
port map (
	point_address  		=>	point_address  		,
	point_in  			=>	point_in  			,
	point_write_enable 	=>	point_write_enable 	,
	max_y     			=>	max_y     			,
	bg_color  			=>	bg_color  			,
	p_color   			=>	p_color   			,
	grid_color			=>	grid_color			,
	h_grid    			=>	to_integer(unsigned(h_grid)),
	v_grid    			=>	to_integer(unsigned(v_grid)), 
	thickness 			=>	to_integer(unsigned(thickness)), 
	lines_on  			=>	lines_on  			,
	bclk				=> 	mclk				,
	write_clk			=> 	clk_sync			,
	disp_ena			=> 	disp_en_s			,
	row  				=>	row_s				,
	column 				=> 	col_s				,
	red    				=>	VGA_Red				,
	green 				=>	VGA_Green			,	
	blue				=> 	VGA_Blue
);

	
end VGAGPU;