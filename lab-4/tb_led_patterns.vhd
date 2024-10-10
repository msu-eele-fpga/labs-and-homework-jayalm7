library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_led_patterns is
end entity tb_led_patterns;

architecture behavior of tb_led_patterns is

    component led_patterns is
        generic (
            system_clock_period : time := 20 ns
        );
        port (
            clk              : in  std_logic;
            rst              : in  std_logic;
            push_button      : in  std_logic;
            switches         : in  std_logic_vector(3 downto 0);
            hps_led_control  : in  boolean;
            base_period      : in  unsigned(7 downto 0);
            led_reg          : in  std_logic_vector(7 downto 0);
            led              : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk             : std_logic := '0';
    signal rst             : std_logic;
    signal push_button     : std_logic := '1';
    signal switches        : std_logic_vector(3 downto 0) := (others => '0');
    signal led             : std_logic_vector(7 downto 0);
    signal base_period     : unsigned(7 downto 0) := "00000001";

    constant CLK_PERIOD : time := 20 ns;

begin

    -- Instantiate the Unit Under Test
    uut: led_patterns
        generic map (
            system_clock_period => CLK_PERIOD
        )
        port map (
            clk              => clk,
            rst              => rst,
            push_button      => push_button,
            switches         => switches,
            hps_led_control  => false,
            base_period      => base_period,
            led_reg          => (others => '0'),
            led              => led
        );

    -- Clock generation process
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process clk_process;

    -- Stimulus process
    stimulus: process
    begin
        -- Initial reset state
        rst <= '1';
        wait for 100 ns;
        
        -- Assert reset
        rst <= '0';
        wait for 100 ns;
        
        -- Release reset
        rst <= '1';
        wait for 100 ns;

        -- Press the start button
        push_button <= '0';  -- Simulate button press to start
        wait for 100 ns;
        push_button <= '1';  -- Release button

        -- Test switch inputs to transition between patterns
        switches <= "0001";  -- Move to Pattern 2
        wait for 500 ns;
        
        switches <= "0010";  -- Move to Pattern 3
        wait for 500 ns;
        
        switches <= "0100";  -- Move to Pattern 4
        wait for 500 ns;
        
        switches <= "1000";  -- Cycle back to Pattern 1
        wait for 500 ns;

        wait;
    end process stimulus;

end architecture behavior;
