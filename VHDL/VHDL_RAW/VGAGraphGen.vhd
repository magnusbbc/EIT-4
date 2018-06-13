library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;







entity VGAGraphGen is
    Port ( 
        max_y     :  IN std_logic_vector(16 - 1 DOWNTO 0):= (0=>'0',OTHERS => '1');
        index_in  :  IN std_logic_vector(16 - 1 DOWNTO 0):= (OTHERS => '0');
        point_in  :  IN std_logic_vector(16 - 1 DOWNTO 0):= (OTHERS => '0');
        bg_color  :  IN std_logic_vector(4+4+4-1 DOWNTO 0):=x"111";
        p_color   :  IN std_logic_vector(4+4+4-1 DOWNTO 0):=x"339";
        lines_on  : in STD_LOGIC :='1';

      
        disp_ena  :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
        row       :  IN   INTEGER;    --row pixel coordinate
        column    :  IN   INTEGER;    --column pixel coordinate

        red       :  OUT  STD_LOGIC_VECTOR(4-1 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
        green     :  OUT  STD_LOGIC_VECTOR(4-1 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
        blue      :  OUT  STD_LOGIC_VECTOR(4-1 DOWNTO 0) := (OTHERS => '0') --blue magnitude output to DAC
				);
end VGAGraphGen;

architecture Behavioral of VGAGraphGen is
type point_array_type     is array (0 to 640 -1) of std_logic_vector(16 - 1 DOWNTO 0);

signal point_array        : point_array_type:=(1=>x"1fff",  2=>x"2fff",  3=>x"3fff",  4=>x"4fff",  5=>x"5fff",  6=>x"6fff",  7=>x"7fff",  8=>x"8fff",  9=>x"9fff",  10=>x"afff",  11=>x"bfff",  12=>x"cfff",  13=>x"0dff",  14=>x"0eff",  others => x"09ff");

begin
    PROCESS(disp_ena, row, column)
    variable current_point :STD_LOGIC_VECTOR(16-1 DOWNTO 0) := (others=>'1');
    BEGIN

      current_point:=point_array(column);  

      IF(disp_ena = '1') THEN        --display time
        if(lines_on='1') then
          
          if(unsigned(abs(signed(unsigned(current_point)-((480-row)*(unsigned(max_y)/480))))) < 1*(unsigned(max_y)/480)) then
            red     <=  p_color(4-1 DOWNTO 0);
            green   <=  p_color(4+4-1 DOWNTO 4);
            blue    <=  p_color(4+4+4-1 DOWNTO 4+4);
          else
            red     <=  bg_color(4-1 DOWNTO 0);
            green   <=  bg_color(4+4-1 DOWNTO 4);
            blue    <=  bg_color(4+4+4-1 DOWNTO 4+4);
          end if;

        else

          if(unsigned(current_point)<(480-row)*(unsigned(max_y)/480))then
            red     <=  p_color(4-1 DOWNTO 0);
            green   <=  p_color(4+4-1 DOWNTO 4);
            blue    <=  p_color(4+4+4-1 DOWNTO 4+4);
          else
            red     <=  bg_color(4-1 DOWNTO 0);
            green   <=  bg_color(4+4-1 DOWNTO 4);
            blue    <=  bg_color(4+4+4-1 DOWNTO 4+4);
          end if;

        end if;
        
        
      ELSE                           --blanking time
        red <= (OTHERS => '0');
        green <= (OTHERS => '0');
        blue <= (OTHERS => '0');
      END IF;
    
    END PROCESS;
   PROCESS(index_in,point_in)
  begin
      
        if(to_integer(unsigned(index_in))<640  -1) then
          point_array(to_integer(unsigned(index_in)))<=point_in;
        end if;
    
     
    end process;
  END Behavioral;