library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity de10nano_top is
  port (
    -- Clock inputs
    fpga_clk1_50 : in std_logic;
    fpga_clk2_50 : in std_logic;
    fpga_clk3_50 : in std_logic;

    -- Push button inputs (KEY)
    push_button_n : in std_logic_vector(1 downto 0);  -- Active-low buttons

    -- Slide switch inputs (SW)
    sw : in std_logic_vector(3 downto 0);

    -- LED outputs
    led : out std_logic_vector(7 downto 0);

    -- GPIO and Arduino headers
    gpio_0 : inout std_logic_vector(35 downto 0);
    gpio_1 : inout std_logic_vector(35 downto 0);
    arduino_io : inout std_logic_vector(15 downto 0);
    arduino_reset_n : inout std_logic
  );
end entity de10nano_top;

architecture structural of de10nano_top is
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
    signal base_period_signal : unsigned(7 downto 0) := to_unsigned(16, 8);  -- "00010000" converted to unsigned
    signal led_reg_signal     : std_logic_vector(7 downto 0) := (others => '0');

begin
    -- Instance of led_pattern
    uut: led_pattern
        port map (
            clk           => fpga_clk1_50,                 -- Connect 50 MHz clock
            rst           => not push_button_n(1),         -- Active-low reset
            push_button   => not push_button_n(0),         -- Invert for active-high push button
            switches      => sw,                           -- Connect switches directly
            hps_led_control => false,                      -- Disable HPS control (set to false)
            base_period   => base_period_signal,           -- Assign base period signal
            led_reg       => led_reg_signal,               -- Assign LED register signal
            led           => led                           -- Map to top-level LED output
        );

end architecture structural;
