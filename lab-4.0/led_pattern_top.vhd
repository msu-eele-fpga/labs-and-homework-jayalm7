library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library altera;
use altera.altera_primitives_components.all;

-----------------------------------------------------------
-- Signal Names are defined in the DE10-Nano User Manual
-- http://de10-nano.terasic.com
-----------------------------------------------------------
entity led_pattern_top is
  port (
    ----------------------------------------
    --  Clock inputs
    --  See DE10 Nano User Manual page 23
    ----------------------------------------
    --! 50 MHz clock input #1
    fpga_clk1_50 : in    std_logic;
    --! 50 MHz clock input #2
    fpga_clk2_50 : in    std_logic;
    --! 50 MHz clock input #3
    fpga_clk3_50 : in    std_logic;

    ----------------------------------------
    --  Push button inputs (KEY)
    --  See DE10 Nano User Manual page 24
    --  The KEY push button inputs produce a '0'
    --  when pressed (asserted)
    --  and produce a '1' in the rest (non-pushed) state
    ----------------------------------------
    push_button_n : in    std_logic_vector(1 downto 0);

    ----------------------------------------
    --  Slide switch inputs (SW)
    --  See DE10 Nano User Manual page 25
    --  The slide switches produce a '0' when
    --  in the down position
    --  (towards the edge of the board)
    ----------------------------------------
    sw : in    std_logic_vector(3 downto 0);

    ----------------------------------------
    --  LED outputs
    --  See DE10 Nano User Manual page 26
    --  Setting LED to 1 will turn it on
    ----------------------------------------
    led : out   std_logic_vector(7 downto 0);

    ----------------------------------------
    --  GPIO expansion headers (40-pin)
    --  See DE10 Nano User Manual page 27
    --  Pin 11 = 5V supply (1A max)
    --  Pin 29 - 3.3 supply (1.5A max)
    --  Pins 12, 30 GND
    ----------------------------------------
    gpio_0 : inout std_logic_vector(35 downto 0);
    gpio_1 : inout std_logic_vector(35 downto 0);

    ----------------------------------------
    --  Arudino headers
    --  See DE10 Nano User Manual page 30
    ----------------------------------------
    arduino_io      : inout std_logic_vector(15 downto 0);
    arduino_reset_n : inout std_logic
  );
end entity led_pattern_top;

architecture structural of led_pattern_top is
    component led_pattern
        generic (
            system_clock_period : time := 20 ns
        );
        port (
            clk              : in std_logic;
            rst              : in std_logic;
            push_button      : in std_logic;
            switches         : in std_logic_vector(3 downto 0);
            hps_led_control  : in boolean;
            base_period      : in unsigned(7 downto 0);
            led_reg          : in std_logic_vector(7 downto 0);
            led              : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Internal signals for base period and LED register
    signal base_period_signal : unsigned(7 downto 0) := to_unsigned(16, 8);
    signal led_reg_signal     : std_logic_vector(7 downto 0) := (others => '0');

begin
    -- Instance of led_pattern
    uut: led_pattern
        port map (
            clk           => fpga_clk1_50,                 
            rst           => not push_button_n(1),         
            push_button   => not push_button_n(0),         
            switches      => sw,                           
            hps_led_control => false,                      
            base_period   => base_period_signal,           
            led_reg       => led_reg_signal,               
            led           => led                           
        );

end architecture structural;
