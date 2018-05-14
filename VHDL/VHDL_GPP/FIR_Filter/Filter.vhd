#include "FIR_Config.hvhd"

#define MULTEXTEND product_array(I)(MULTIPLIER_WIDTH - 1)
-- This is adder_array generic FIR filter generator
-- It uses INOUT_BIT_WIDTH bit data/coefficients bits
LIBRARY ieee; -- Using predefined packages
USE ieee.std_logic_1164.ALL;
--USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_signed.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE ieee.numeric_std.ALL;
-- --------------------------------------------------------
ENTITY Filter IS ------> Interface
	PORT 
	(
		clk    					: IN STD_LOGIC := '0'; -- System clock
		reset  					: IN STD_LOGIC := '0';	-- Asynchron reset
		load_system_input 		: IN STD_LOGIC := '0'; -- Load/run switch
		system_input  			: IN STD_LOGIC_VECTOR(INOUT_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0'); -- system_input
		coefficient_in  	    : IN STD_LOGIC_VECTOR(COEFFICIENT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0'); -- Coefficient data input
		system_output  			: OUT STD_LOGIC_VECTOR(INOUT_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');  -- System output
		write_enable			: IN STD_LOGIC := '0';
		array_toggle			: in std_logic := '0'
	);
	
END Filter; 
-- --------------------------------------------------------
ARCHITECTURE Behavioural OF Filter IS

	TYPE coefficient_array_type 	IS ARRAY (0 TO TAPS - 1) OF STD_LOGIC_VECTOR(COEFFICIENT_WIDTH - 1 DOWNTO 0);			
	TYPE product_array_type 		IS ARRAY (0 TO TAPS - 1) OF STD_LOGIC_VECTOR(MULTIPLIER_WIDTH - 1 DOWNTO 0);		
	TYPE adder_array_type 			IS ARRAY (0 TO TAPS - 1) OF STD_LOGIC_VECTOR(ADDER_WIDTH - 1 DOWNTO 0);				

	-- Type coefficient_array_type2 	is array (0 to NUMBER_OF_FILTERS - 1) of coefficient_array_type; 
	-- Type product_array_type2 		is array (0 to NUMBER_OF_FILTERS - 1) of product_array_type; 
	-- Type adder_array_type2 			is array (0 to NUMBER_OF_FILTERS - 1) of adder_array_type; 


	--//SIGNAL coefficient_array 		: coefficient_array_type :=  //DEFAULT_COEFS;

	SIGNAL coefficient_array 		: coefficient_array_type :=  (others => (others => '0')); 	-- Coefficient array
	SIGNAL product_array 			: product_array_type := (others => (others => '0')); 		-- Product array
	SIGNAL adder_array 				: adder_array_type := (others => (others => '0')); 		-- Adder array

	SIGNAL coefficient_array2 		: coefficient_array_type :=   (others => ( others =>'0')); 	-- Coefficient array
	SIGNAL product_array2 			: product_array_type :=  (others => ( others =>'0')); 		-- Product array
	SIGNAL adder_array2 			: adder_array_type :=   (others => ( others =>'0')); 		-- Adder array


	signal array_index 				: integer := 0;
	SIGNAL input_data_temp 			: STD_LOGIC_VECTOR(INOUT_BIT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL full_output 				: STD_LOGIC_VECTOR(ADDER_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL truncated_output 		: STD_LOGIC_VECTOR(ADDER_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');      

BEGIN
	Load : PROCESS (clk, reset, coefficient_in, coefficient_array, system_input)
	BEGIN
												------> Load data or coefficients
		IF reset = '1' THEN 			-- clear data and coefficients reg.
			IF(write_enable = '1') THEN
				input_data_temp <= (others=>'0');
				FOR K IN 0 TO TAPS - 1 LOOP
					coefficient_array(K) <= (others=>'0');
					coefficient_array2(K) <= (others=>'0');
				END LOOP;
			END IF;
		ELSIF falling_edge(clk) THEN
			IF(write_enable = '1') THEN
				IF load_system_input = '0' THEN
					coefficient_array(TAPS - 1) <= coefficient_in; -- Store coefficient in register
					coefficient_array2(TAPS - 1) <= coefficient_in; -- Store coefficient in register
					FOR I IN TAPS - 2 DOWNTO 0 LOOP -- Coefficients shift one
						coefficient_array(I) <= coefficient_array(I + 1);
						coefficient_array2(I) <= coefficient_array2(I + 1);
					END LOOP;
				ELSE
					input_data_temp <= system_input; -- Get one data sample at adder_array time
				END IF;
			END IF;
		END IF;
	END PROCESS Load;
	
	SOP : PROCESS (clk, reset, adder_array, product_array)-- Compute sum-of-products
	BEGIN
		IF reset = '1' THEN -- clear tap registers
			IF(write_enable = '1') THEN
				FOR K IN 0 TO TAPS - 1 LOOP
					adder_array(K) <= (OTHERS => '0');
					adder_array2(K) <= (OTHERS => '0');
				END LOOP;
			END IF;
		ELSIF falling_edge(clk) THEN
			IF(write_enable = '1') THEN
				FOR I IN 0 TO TAPS - 2 LOOP -- Compute the transposed
					adder_array(I) <= std_logic_vector(resize(signed(product_array(I)),adder_array(0)'length)) + adder_array(I + 1); -- filter adds
					adder_array2(I) <= std_logic_vector(resize(signed(product_array2(I)),adder_array2(0)'length)) + adder_array2(I + 1); -- filter adds
				END LOOP;
				adder_array(TAPS - 1) <= std_logic_vector(resize(signed(product_array(TAPS-1)),adder_array(0)'length)); -- First TAP has only adder_array register
				adder_array2(TAPS - 1) <= std_logic_vector(resize(signed(product_array2(TAPS-1)),adder_array2(0)'length)); -- First TAP has only adder_array register		
				END IF;
		END IF; 
		full_output <= adder_array(0);
	END PROCESS SOP;

	--CHANGE_INDEX : PROCESS (array_toggle)
	--BEGIN
	--	IF (write_enable = '1') THEN
	--		if (array_toggle = '1') then 
	--			if(array_index = NUMBER_OF_FILTERS - 1) then
	--				array_index <= 0;
	--			else 
	--				array_index <= array_index + 1;
	--			end if;
	--		end if;
	--	end if;
	--END PROCESS CHANGE_INDEX;
	
	
	-- Instantiate TAPS multipliers
	MulGen : FOR I IN 0 TO TAPS - 1 GENERATE
		product_array(i) <= coefficient_array(i) * input_data_temp;
		product_array2(i) <= coefficient_array2(i) * input_data_temp;
	END GENERATE;
	
	truncated_output <= std_logic_vector(shift_right(unsigned(full_output), 15));
	system_output <= truncated_output(15 downto 0);
END Behavioural;