library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library altera;
use altera.altera_primitives_components.all;

entity led_patterns_avalon is
port(
	  clk : in std_logic;
	  rst : in std_logic;
	  
	  -- avalon memory-mapped slave interface
	  avs_read : in std_logic;
	  avs_write : in std_logic;
	  avs_address : in std_logic_vector(1 downto 0);
	  avs_readdata : out std_logic_vector(31 downto 0);
	  avs_writedata : in std_logic_vector(31 downto 0);
	  
	  -- external I/0; export to top level
	  push_button : in std_logic;
	  switches : in std_logic_vector(3 downto 0);
	  led : out std_logic_vector(7 downto 0)
);

end entity led_patterns_avalon;

architecture led_patterns_avalon_arch of led_patterns_avalon is

  component led_pattern is
    generic(
		      system_clock_period : time := 20 ns
				);
    port(clk : in std_logic; -- system clock
         rst : in std_logic; -- system reset (assume active high, change at top level if needed)
         PB : in std_logic;  -- Pushbutton to change state (assume active high, change at top level if needed)
         SW : in std_logic_vector(3 downto 0); -- Switches that determine the next state to be selected
         HPS_LED_control: in boolean;	-- Software is in control when asserted (=1)
         Base_rate : in unsigned(7 downto 0);  -- base transition period in seconds, fixed-point data type (W=8, F=4)
         LED_reg : in std_logic_vector(7 downto 0); -- LED register
         LED : out std_logic_vector(7 downto 0) -- LEDs on the DE10 NANO board
	      );		
  end component led_pattern;


  
  signal hps_reg : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal bp_reg : std_logic_vector(31 downto 0) :=  "00000000000000000000000000010000";
  signal led_reg : std_logic_vector(31 downto 0) := "00000000000000000000000000010000";
  signal internHPS : boolean := false;
  

begin

  avalon_register_read : process(clk)
  begin
    if rising_edge(clk) and avs_read = '1' then
	   case (avs_address) is
		  when "00" => avs_readdata <= hps_reg;
		  when "01" => avs_readdata <= bp_reg;
		  when "10" => avs_readdata <= led_reg;
		  when others => avs_readdata <= (others => '0');
		end case;
	end if;
  end process;
  
  avalon_register_write : process(clk,rst)
  begin
    if rst = '1' then
	   hps_reg <= "00000000000000000000000000000000";
		bp_reg <=  "00000000000000000000000000010000";
		led_reg <= "00000000000000000000000000010000";
    elsif rising_edge(clk) and avs_write = '1' then
	   case (avs_address) is
		  when "00" => hps_reg <= avs_writedata;
		  when "01" => bp_reg <= avs_writedata; 
		  when "10" => led_reg <= avs_writedata;
		  when others => null;
		end case;
    end if;
  end process;
  
  avalon_HPS_Control: process(clk)
  begin
    if (hps_reg = "00000000000000000000000000000001") then
      internHPS <= true; -- SW mode
    else
      internHPS <= false; -- HW mode
    end if;
  end process;
  
  
  led_patterns_MAP : led_pattern generic map(system_clock_period => 20 ns)
											 port map(clk => clk,
														 rst => rst,
														 PB => push_button,
														 SW => switches,
														 HPS_LED_control => internHPS,
														 Base_rate => unsigned(bp_reg(7 downto 0)),
														 LED_reg => led_reg(7 downto 0),
														 LED => led);
										
				 

end architecture led_patterns_avalon_arch;