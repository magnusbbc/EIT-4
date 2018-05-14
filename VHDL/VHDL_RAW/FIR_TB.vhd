
















LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY FIR_TB IS
END FIR_TB;

ARCHITECTURE Behavioral OF FIR_TB IS
	 
	SUBTYPE Data IS STD_LOGIC_VECTOR(15 DOWNTO 0); 
	TYPE arr IS ARRAY (0 TO 401-1) OF Data;
	TYPE arr_int IS ARRAY (0 TO 401-1) OF integer;
	Type coef is array (0 to 64-1) of data; 
	Type coef_int is array (0 to 64-1) of integer; 

	signal sin  : arr;
	signal sin_int  : arr_int;
	signal coefs : coef; 
	signal coefs_int : coef_int;
	
	signal reset : std_logic := '0';
	signal Load_x : std_logic;
	signal x_in : std_logic_vector(16-1 downto 0) := (others=>'0');
	signal c_in : std_logic_vector(16-1 downto 0) := (others=>'0');
	signal y_out : std_logic_vector(16-1 downto 0) := (others=>'0');

	
	--Clock Constants
	constant TbPeriod : time := 50 ns;
   signal TbClock : std_logic := '0';
   signal TbSimEnded : std_logic := '0';
	signal cnt : integer := 0;
	signal i : integer := 0;
	signal q : integer := 0; 

BEGIN
	FILTER : ENTITY work.Filter(Behavioural) 
	PORT MAP(
	clk    => tbclock,   
	reset  => reset, 
	load_system_input => Load_x,
	system_input   => x_in,  
	coefficient_in   => c_in,  
	system_output  => y_out 
	);
	
	-- Clock generation
	TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

	sin_int <= (
		4000,
		5340,
		3475,
		3903,
		3174,
		6156,
		3236,
		4027,
		3661,
		5588,
		4309,
		3030,
		4956,
		4588,
		5377,
		2454,
		5433,
		4700,
		5124,
		3253,
		4588,
		5922,
		4050,
		4470,
		3733,
		6707,
		3778,
		4559,
		4183,
		6099,
		4809,
		3518,
		5432,
		5052,
		5827,
		2891,
		5856,
		5109,
		5518,
		3632,
		4951,
		6269,
		4381,
		4785,
		4031,
		6988,
		4041,
		4805,
		4410,
		6309,
		5000,
		3690,
		5586,
		5187,
		5943,
		2988,
		5933,
		5167,
		5556,
		3651,
		4951,
		6250,
		4342,
		4727,
		3954,
		6891,
		3925,
		4670,
		4257,
		6136,
		4809,
		3481,
		5358,
		4941,
		5680,
		2707,
		5636,
		4852,
		5225,
		3304,
		4588,
		5871,
		3948,
		4318,
		3531,
		6454,
		3475,
		4206,
		3780,
		5648,
		4309,
		2970,
		4836,
		4409,
		5138,
		2156,
		5076,
		4285,
		4651,
		2722,
		4000,
		5278,
		3349,
		3715,
		2924,
		5844,
		2862,
		3591,
		3164,
		5030,
		3691,
		2352,
		4220,
		3794,
		4525,
		1546,
		4469,
		3682,
		4052,
		2129,
		3412,
		4696,
		2775,
		3148,
		2364,
		5293,
		2320,
		3059,
		2642,
		4519,
		3191,
		1864,
		3743,
		3330,
		4075,
		1109,
		4046,
		3273,
		3658,
		1750,
		3049,
		4349,
		2444,
		2833,
		2067,
		5012,
		2057,
		2813,
		2414,
		4310,
		3000,
		1691,
		3590,
		3195,
		3959,
		1012,
		3969,
		3215,
		3619,
		1731,
		3049,
		4368,
		2482,
		2891,
		2144,
		5109,
		2173,
		2948,
		2568,
		4482,
		3191,
		1901,
		3817,
		3441,
		4222,
		1293,
		4267,
		3530,
		3950,
		2078,
		3412,
		4747,
		2876,
		3300,
		2567,
		5546,
		2623,
		3412,
		3044,
		4970,
		3691,
		2412,
		4339,
		3973,
		4764,
		1844,
		4826,
		4097,
		4525,
		2660,
		4000,
		5340,
		3475,
		3903,
		3174,
		6156,
		3236,
		4027,
		3661,
		5588,
		4309,
		3030,
		4956,
		4588,
		5377,
		2454,
		5433,
		4700,
		5124,
		3253,
		4588,
		5922,
		4050,
		4470,
		3733,
		6707,
		3778,
		4559,
		4183,
		6099,
		4809,
		3518,
		5432,
		5052,
		5827,
		2891,
		5856,
		5109,
		5518,
		3632,
		4951,
		6269,
		4381,
		4785,
		4031,
		6988,
		4041,
		4805,
		4410,
		6309,
		5000,
		3690,
		5586,
		5187,
		5943,
		2988,
		5933,
		5167,
		5556,
		3651,
		4951,
		6250,
		4342,
		4727,
		3954,
		6891,
		3925,
		4670,
		4257,
		6136,
		4809,
		3481,
		5358,
		4941,
		5680,
		2707,
		5636,
		4852,
		5225,
		3304,
		4588,
		5871,
		3948,
		4318,
		3531,
		6454,
		3475,
		4206,
		3780,
		5648,
		4309,
		2970,
		4836,
		4409,
		5138,
		2156,
		5076,
		4285,
		4651,
		2722,
		4000,
		5278,
		3349,
		3715,
		2924,
		5844,
		2862,
		3591,
		3164,
		5030,
		3691,
		2352,
		4220,
		3794,
		4525,
		1546,
		4469,
		3682,
		4052,
		2129,
		3412,
		4696,
		2775,
		3148,
		2364,
		5293,
		2320,
		3059,
		2642,
		4519,
		3191,
		1864,
		3743,
		3330,
		4075,
		1109,
		4046,
		3273,
		3658,
		1750,
		3049,
		4349,
		2444,
		2833,
		2067,
		5012,
		2057,
		2813,
		2414,
		4310,
		3000,
		1691,
		3590,
		3195,
		3959,
		1012,
		3969,
		3215,
		3619,
		1731,
		3049,
		4368,
		2482,
		2891,
		2144,
		5109,
		2173,
		2948,
		2568,
		4482,
		3191,
		1901,
		3817,
		3441,
		4222,
		1293,
		4267,
		3530,
		3950,
		2078,
		3412,
		4747,
		2876,
		3300,
		2567,
		5546,
		2623,
		3412,
		3044,
		4970,
		3691,
		2412,
		4339,
		3973,
		4764,
		1844,
		4826,
		4097,
		4525,
		2660,
		4000
			);
   
   
PROCESS(sin_int)
BEGIN
FOR k IN 0 TO 401-1 LOOP
	sin(k) <= std_logic_vector(to_signed(sin_int(k),16));
END LOOP;
END PROCESS;

   coefs_int <= (
    	-12,     -4,      5,     17,     31,     48,     65,     79,     86,
       83,     64,     26,    -31,   -106,   -194,   -284,   -366,   -424,
     -442,   -405,   -300,   -120,    139,    470,    862,   1295,   1744,
     2182,   2578,   2904,   3137,   3256,   3257,   3137,   2904,   2578,
     2182,   1744,   1295,    862,    470,    139,   -120,   -300,   -405,
     -442,   -424,   -366,   -284,   -194,   -106,    -31,     26,     64,
       83,     86,     79,     65,     48,     31,     17,      5,     -4,
      -12
);

PROCESS(coefs_int)
BEGIN
FOR k IN 0 TO 64-1 LOOP
	coefs(k) <= std_logic_vector(to_signed(coefs_int(k),16));
END LOOP;
END PROCESS;


	
	
	stim_proc:process(TbClock)
		begin
			IF(falling_edge(TbClock)) THEN
				CASE cnt is 
					when 0 =>
						reset <= '1'; 					--- reset first
						load_x <= '0';					--- enter load coeficcients mode
						x_in <= x"0000";
						c_in <= x"0000";
						cnt<= cnt+1;
					when 1 to 64 =>
					reset <= '0'; 
					load_x <= '0';					--- stay in load coeficcients mode
					x_in <= x"0000";
					c_in <= coefs(cnt-1);					--- First coefficient							
					cnt <= cnt+1;
						


					when 64+1 =>
						reset <= '0'; 
						load_x <= '1';					--- Enter load data sample mode
						x_in <= x"0000";
						c_in <= x"2a3f";						
						cnt <= cnt+1;

--					when 73 =>
--						reset <= '0'; 
--						load_x <= '1';					--- Enter load data sample mode
--						x_in <= x"2710";				--- Send data to the filter
--						c_in <= x"2a3f";						
--						cnt <= cnt+1;
--					when 74 =>
--						reset <= '0'; 
--						load_x <= '1';					--- Enter load data sample mode
--						x_in <= x"0000";				--- Send data to the filter
--						c_in <= x"2a3f";						
--						cnt <= cnt+1;


					when others => 
						reset <= '0'; 
						load_x <= '1';					--- Enter load data sample mode
						x_in <= sin(i);				--- Send data to the filter
						c_in <= x"2a3f";
						if (i<401-1) then
							i <= i+1;
						   cnt<= cnt+1;
						else 
							cnt<= cnt+1;
						end if;	
				End case; 		
				IF( cnt > 540) THEN
						TbSimEnded <= '1';
						--wait;
				END IF; 
			END IF;
	end process;

	
END Behavioral;