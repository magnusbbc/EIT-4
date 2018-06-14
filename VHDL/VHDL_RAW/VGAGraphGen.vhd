library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;








entity VGAGraphGen is
    Port ( 
        point_address  :  IN std_logic_vector(16 - 1 DOWNTO 0):= (OTHERS => '0');    --Address for writing a point to ram
        point_in  :  IN std_logic_vector(16 - 1 DOWNTO 0):= (14=>'1',OTHERS => '0'); --The data to write to the specified address
        point_write_enable : IN STD_LOGIC:='0';                                                   --Write enable

        max_y     :  IN std_logic_vector(16 - 1 DOWNTO 0):= (15=>'1',OTHERS => '1'); --Scaling for the y-axis, max_y will be the max value shown
        bg_color  :  IN std_logic_vector(4+4+4-1 DOWNTO 0):=x"422";  --Color for the background (BGR)
        p_color   :  IN std_logic_vector(4+4+4-1 DOWNTO 0):=x"33b";  --Color for the points (BGR)
        grid_color:  IN std_logic_vector(4+4+4-1 DOWNTO 0):=x"666";  --Color for the grid (BGR)
        h_grid    :  IN INTEGER := 20;      --Grid distance horizontal
        v_grid    :  IN INTEGER := 20;      --Grid distance vertical
        thickness :  IN INTEGER := 3;       --Thickness of the line when linemode is on 
        lines_on  :  IN STD_LOGIC :='1';    --Linemode on/off

        bclk      :  IN STD_LOGIC;          --Bitclock from vga controller
        write_clk :  IN STD_LOGIC;          --Clock from writing source

        disp_ena  :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
        row       :  IN   INTEGER;    --row pixel coordinate
        column    :  IN   INTEGER;    --column pixel coordinate

        red       :  OUT  STD_LOGIC_VECTOR(4-1 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
        green     :  OUT  STD_LOGIC_VECTOR(4-1 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
        blue      :  OUT  STD_LOGIC_VECTOR(4-1 DOWNTO 0) := (OTHERS => '0') --blue magnitude output to DAC
				);
end VGAGraphGen;

architecture Behavioral of VGAGraphGen is

component GRAM is --Ram component for dedicated ram
PORT
(
  data		    : IN STD_LOGIC_VECTOR (15 DOWNTO 0);  
  rdaddress		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
  rdclock		  : IN STD_LOGIC ;
  wraddress		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
  wrclock		  : IN STD_LOGIC  := '1';
  wren	  	  : IN STD_LOGIC  := '0';
  q		        : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
);
end component;

signal ram_in             :  STD_LOGIC_VECTOR (15 DOWNTO 0);  --Data in for ram
signal ram_out            :  STD_LOGIC_VECTOR (15 DOWNTO 0);  --Data out for ram
signal read_address       :  STD_LOGIC_VECTOR (9 DOWNTO 0);   --Read address for ram
signal write_address      :  STD_LOGIC_VECTOR (9 DOWNTO 0);   --Write address for ram

begin

  RAM : component GRAM  --wirering of ram
  port map (
    data		    => ram_in,
    rdaddress		=> read_address,
    rdclock		  => not bclk,
    wraddress		=> write_address,
    wrclock		  => not write_clk,
    wren	  	  => point_write_enable,
    q		        => ram_out
  );
  



    PROCESS(bclk,disp_ena, row, column)
    BEGIN

     
    if rising_edge(bclk) then
      --What should be ready at ram_out on the next cycle
      if(column>=640-1)then
      read_address<= std_logic_vector(to_unsigned(1,10));           -- When at the last column the next data will be the first data point 
      else
      read_address<= std_logic_vector(to_unsigned((column+2),10));  --The column is 0-indexed and ram is 1-indexed plus the delay and thus +2
      end if; 

      IF(disp_ena = '1') THEN        --display time
        if(lines_on='1') then
          
          if(unsigned(abs(signed(unsigned(ram_out)-((480-row)*(unsigned(max_y)/480))))) < thickness*(unsigned(max_y)/480)) then --check if the scaled row is within 'thickness' of data point
            --If it is draw the line in 'p_color'
            red     <=  p_color(4-1 DOWNTO 0);
            green   <=  p_color(4+4-1 DOWNTO 4);
            blue    <=  p_color(4+4+4-1 DOWNTO 4+4);
            else
            --Else draw the background with a grid
              if ((column mod h_grid)=0) OR ((row mod v_grid)=0) then
                red     <=  grid_color(4-1 DOWNTO 0);
                green   <=  grid_color(4+4-1 DOWNTO 4);
                blue    <=  grid_color(4+4+4-1 DOWNTO 4+4);
              else
                red     <=  bg_color(4-1 DOWNTO 0);
                green   <=  bg_color(4+4-1 DOWNTO 4);
                blue    <=  bg_color(4+4+4-1 DOWNTO 4+4);
              end if;
            end if;
        else

          if(unsigned(ram_out)>(480-row)*(unsigned(max_y)/480))then --Checks if scalled row is less than datapoint
                  --If it is then fill with'p_color'
            red     <=  p_color(4-1 DOWNTO 0);
            green   <=  p_color(4+4-1 DOWNTO 4);
            blue    <=  p_color(4+4+4-1 DOWNTO 4+4);
          else
           --Else draw the background with a grid
            if ((column mod h_grid)=0) OR ((row mod v_grid)=0) then
              red     <=  grid_color(4-1 DOWNTO 0);
              green   <=  grid_color(4+4-1 DOWNTO 4);
              blue    <=  grid_color(4+4+4-1 DOWNTO 4+4);
            else
              red     <=  bg_color(4-1 DOWNTO 0);
              green   <=  bg_color(4+4-1 DOWNTO 4);
              blue    <=  bg_color(4+4+4-1 DOWNTO 4+4);
            end if;
          end if;

        end if;
        
        
      ELSE                           --blanking time
        red <= (OTHERS => '0');
        green <= (OTHERS => '0');
        blue <= (OTHERS => '0');
      END IF;
      end if ;
    END PROCESS;

   PROCESS(write_clk,point_address,point_in)--Write to RAM if write enable is on
   begin
      
        if rising_edge(write_clk) then
          write_address<=point_address(9 downto 0); --Set address
          ram_in<=point_in;                         --Set data
        end if;
    
     
    end process;
  END Behavioral;