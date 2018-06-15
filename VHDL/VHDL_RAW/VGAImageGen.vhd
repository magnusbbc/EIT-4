library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity VGAImageGen is
    Port ( 
        disp_ena :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
        row      :  IN   INTEGER;    --row pixel coordinate
        column   :  IN   INTEGER;    --column pixel coordinate
        red      :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
        green    :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
        blue     :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0') --blue magnitude output to DAC
				);
end VGAImageGen;

architecture Behavioral of VGAImageGen is

begin
    PROCESS(disp_ena, row, column)
    BEGIN
  
      IF(disp_ena = '1') THEN        --display time
        
          red <=  std_logic_vector(to_unsigned(row/10, red'length));
          green  <= std_logic_vector(to_unsigned(column/10, red'length));
          blue <= std_logic_vector(to_unsigned((row+column)/20, red'length));
        

        
      ELSE                           --blanking time
        red <= (OTHERS => '0');
        green <= (OTHERS => '0');
        blue <= (OTHERS => '0');
      END IF;
    
    END PROCESS;
  END Behavioral;