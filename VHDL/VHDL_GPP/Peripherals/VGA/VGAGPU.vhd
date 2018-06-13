library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGAGPU is
   Port 	 ( 
	   			reset 		: in  STD_LOGIC;
				clk 		: in std_logic;
				sw 			: in  STD_LOGIC_vector (9 downto 0);
				led 		: out  STD_LOGIC_vector (9 downto 0);

				--HEX0		: out std_logic_vector (6 downto 0);
				--HEX1		: out std_logic_vector (6 downto 0);
				--HEX2		: out std_logic_vector (6 downto 0);
				--HEX3		: out std_logic_vector (6 downto 0);
				--HEX4		: out std_logic_vector (6 downto 0);
				--HEX5		: out std_logic_vector (6 downto 0);
	
				VGA_Red		: out std_logic_vector (3 downto 0);
				VGA_Green	: out std_logic_vector (3 downto 0);
				VGA_Blue	: out std_logic_vector (3 downto 0);
				VGA_H_SYNC	: out std_logic;
				VGA_V_SYNC	: out std_logic

			   -- btn 		: in std_logic_vector (3 downto 0)
	);
end VGAGPU;

architecture VGAGPU of VGAGPU is
	component PLL is 
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
		disp_ena :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
		row      :  IN   INTEGER;    --row pixel coordinate
		column   :  IN   INTEGER;    --column pixel coordinate
		red      :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) ;  --red magnitude output to DAC
		green    :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) ;  --green magnitude output to DAC
		blue     :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)  --blue magnitude output to DAC
	);
	end component;
	--signal disp_en_s, h_sync_s, v_sync_s 		: std_logic ;
	signal disp_en_s		: std_logic ;
	signal row_s, col_s 	: integer;
	signal sseg 			: STD_LOGIC_vector (41 downto 0);
	signal mclk 			: std_logic;
	signal resetn			: std_logic;
	--signal red_s,green_s,blue_s	: std_logic_vector(7 downto 0);
begin
	resetn<=not reset;
--HEX0 <= sseg(6 downto 0);
	--HEX1 <= sseg(13 downto 7);
	--HEX2 <= sseg(20 downto 14);
	--HEX3 <= sseg(27 downto 21);
--	HEX4 <= sseg(34 downto 28);
	--HEX5 <= sseg(41 downto 35);

clk1 : component PLL
	port map (
				refclk=>clk,
				rst=>resetn,
				outclk_0 =>mclk
				);
	
controller : component VGAController 
port map (
	clk 		=>	mclk		,
	reset		=>	resetn	,	
	row			=>	row_s	,
	col			=>	col_s	,
	disp_en		=>	disp_en_s,
	h_sync		=>	VGA_H_SYNC,
	v_sync 		=>	VGA_v_SYNC
);

imagegen : component VGAGraphGen 
port map (
	disp_ena	=> disp_en_s,
	row  		=>	row_s,
	column 		=> col_s,
	red    		=>	VGA_Red,
	green 		=>	VGA_Green,
	blue		=> 	VGA_Blue
);
	
led <=sw;
	
end VGAGPU;