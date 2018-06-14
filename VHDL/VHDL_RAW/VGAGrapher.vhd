library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

£define ROWS 480




entity VGAGraphGen is
    Port ( 
        max_y     :  IN std_logic_vector(16 - 1 DOWNTO 0):= (OTHERS => '1');
        point_in  :  IN std_logic_vector(16 - 1 DOWNTO 0):= (OTHERS => '0');
        bg_color  :  IN std_logic_vector(4+4+4-1 DOWNTO 0):=x"666";
        p_color   :  IN std_logic_vector(4+4+4-1 DOWNTO 0):=x"933";
      
        disp_ena  :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
        row       :  IN   INTEGER;    --row pixel coordinate
        column    :  IN   INTEGER;    --column pixel coordinate

        red       :  OUT  STD_LOGIC_VECTOR(4-1 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
        green     :  OUT  STD_LOGIC_VECTOR(4-1 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
        blue      :  OUT  STD_LOGIC_VECTOR(4-1 DOWNTO 0) := (OTHERS => '0') --blue magnitude output to DAC
				);
end VGAGraphGen;

architecture Behavioral of VGAGraphGen is
type point_array_type     is array (0 to points-1) of std_logic_vector(16 - 1 DOWNTO 0);

signal point_array        : point_array_type:=(others => x"00ff")

begin
    PROCESS(disp_ena, row, column)
    BEGIN
  
      IF(disp_ena = '1') THEN        --display time
        if(point_array(column)>row*(ROWS/max_y))then
          red     <=  p_color(4-1 DOWNTO 0);
          green   <=  p_color(4-1 DOWNTO 4);
          blue    <=  p_color(4-1 DOWNTO 4);
        else
        red     <=  bg_color(4-1 DOWNTO 0);
        green   <=  bg_color(4-1 DOWNTO 4);
        blue    <=  bg_color(4-1 DOWNTO 4);
        end if;

        
      ELSE                           --blanking time
        red <= (OTHERS => '0');
        green <= (OTHERS => '0');
        blue <= (OTHERS => '0');
      END IF;
    
    END PROCESS;
  END Behavioral;