library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HPS_LED_patterns is
    port (
        clk           : in std_ulogic;
        rst           : in std_ulogic;
        -- Avalon memory-mapped slave interface
        avs_read      : in std_logic;
        avs_write     : in std_logic;
        avs_address   : in std_logic_vector(1 downto 0);
        avs_readdata  : out std_logic_vector(31 downto 0);
        avs_writedata : in std_logic_vector(31 downto 0);
        -- External I/O
        push_button   : in std_ulogic;
        switches      : in std_ulogic_vector(3 downto 0);
        led           : out std_ulogic_vector(7 downto 0)
    );
end entity HPS_LED_patterns;

architecture rtl of HPS_LED_patterns is

    -- Component instantiation for led_pattern
    component led_pattern
        generic (
            system_clock_period : time := 20 ns
        );
        port (
            clk              : in std_ulogic;
            rst              : in std_ulogic;
            push_button      : in std_ulogic;
            switches         : in std_ulogic_vector(3 downto 0);
            hps_led_control  : in std_logic;
            base_period      : in unsigned(7 downto 0);
            led_reg          : in std_ulogic_vector(7 downto 0);
            led              : out std_ulogic_vector(7 downto 0)
        );
    end component;

    -- Signals for memory-mapped reg
    signal hps_led_control_reg : std_logic := '0'; 
    signal base_period_reg     : unsigned(7 downto 0) := (others => '0');
    signal led_reg             : std_ulogic_vector(7 downto 0) := (others => '0');
    signal read_data           : std_logic_vector(31 downto 0) := (others => '0');

begin

    -- Instantiate led_pattern component
    led_patterns_inst : led_pattern
        port map (
            clk              => clk,
            rst              => rst,
            push_button      => push_button,
            switches         => switches,
            hps_led_control  => hps_led_control_reg,
            base_period      => base_period_reg,
            led_reg          => led_reg,
            led              => led
        );

    -- Memory-Mapped Register Logic
    process (clk, rst)
    begin
        if rst = '1' then
            hps_led_control_reg <= '0';
            base_period_reg     <= (others => '0');
            led_reg             <= (others => '0');
            read_data           <= (others => '0');
        elsif (rising_edge(clk)) then
            -- Handle write transactions
            if avs_write = '1' then
                case avs_address is
                    when "00" =>
                        hps_led_control_reg <= avs_writedata(0); 
                    when "01" =>
                        base_period_reg <= unsigned(avs_writedata(7 downto 0));  -- Set base period
                    when "10" =>
                        led_reg <= std_ulogic_vector(avs_writedata(7 downto 0));  -- Set LED register
                    when others =>
                        null;
                end case;
            end if;

            -- Handle read transactions
            if avs_read = '1' then
                case avs_address is
                    when "00" =>
                        read_data <= (31 downto 1 => '0') & hps_led_control_reg;
                    when "01" =>
                        read_data(7 downto 0) <= std_logic_vector(base_period_reg);
                    when "10" =>
                        read_data(7 downto 0) <= std_logic_vector(led_reg);
                    when others =>
                        read_data <= (others => '0');
                end case;
            end if;
        end if;
    end process;

    -- Connect read data to Avalon readdata output
    avs_readdata <= read_data;

end architecture rtl;
