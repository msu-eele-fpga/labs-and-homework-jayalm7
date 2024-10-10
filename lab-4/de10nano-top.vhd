library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity de10nano_top is
    Port (
        CLOCK_50 : in  std_logic;
        RESET_N  : in  std_logic;
        SW       : in  std_logic_vector(1 downto 0);
        LED      : out std_logic_vector(7 downto 0)
    );
end de10nano_top;

architecture rtl of de10nano_top is

    component led_patterns
        Port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            sw      : in  std_logic_vector(1 downto 0);
            led     : out std_logic_vector(7 downto 0)
        );
    end component;

    signal reset : std_logic;

begin

    -- Reset signal
    reset <= not RESET_N;

    -- Instantiate the LED patterns module
    led_pattern_inst : led_patterns
        port map (
            clk    => CLOCK_50,
            reset  => reset,
            sw     => SW,
            led    => LED
        );

end rtl;
