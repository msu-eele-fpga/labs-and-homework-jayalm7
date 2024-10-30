library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity led_pattern_tb is
end entity led_pattern_tb;

architecture led_pattern_tb_arch of led_pattern_tb is

  -- Constant declaration for clock period
  constant CLK_PERIOD : time := 20 ns;  -- Adjust this value if needed

  component led_pattern is
    generic (
      system_clock_period : time := 20 ns
    );
    port (
      clk              : in std_ulogic;
      rst              : in std_ulogic;
      push_button      : in std_ulogic;
      switches         : in std_ulogic_vector(3 downto 0);
      hps_led_control  : in boolean;
      base_period      : in unsigned(7 downto 0);
      led_reg          : in std_ulogic_vector(7 downto 0);
      led              : out std_ulogic_vector(7 downto 0)
    );
  end component led_pattern;

  signal clk_tb            : std_ulogic := '0';
  signal rst_tb            : std_ulogic := '0';
  signal push_button_tb    : std_ulogic := '0';
  signal switches_tb       : std_ulogic_vector(3 downto 0);
  signal hps_led_control_tb: boolean;
  signal base_period_tb    : unsigned(7 downto 0);
  signal led_reg_tb        : std_ulogic_vector(7 downto 0);
  signal led_tb            : std_ulogic_vector(7 downto 0);

begin

  dut : component led_pattern
    port map (
      clk              => clk_tb,
      rst              => rst_tb,
      push_button      => push_button_tb,
      switches         => switches_tb,
      hps_led_control  => hps_led_control_tb,
      base_period      => base_period_tb,
      led_reg          => led_reg_tb,
      led              => led_tb
    );

  base_period_tb    <= "00111100";
  hps_led_control_tb <= true;
  led_reg_tb        <= "00000000";

  -- Clock generation process using CLK_PERIOD
  clk_gen : process
  begin
    clk_tb <= not clk_tb;
    wait for CLK_PERIOD / 2;
  end process clk_gen;

  -- Input stimulus process
  input_stim : process
  begin
    push_button_tb <= '0';
    switches_tb    <= "0001";
    wait for CLK_PERIOD;

    push_button_tb <= '1';
    wait for CLK_PERIOD;

    push_button_tb <= '0';
    wait for 30 * CLK_PERIOD;

    push_button_tb <= '0';
    switches_tb    <= "0010";
    wait for 1 * CLK_PERIOD;

    push_button_tb <= '1';
    wait for CLK_PERIOD;

    push_button_tb <= '0';
    wait for 30 * CLK_PERIOD;

    push_button_tb <= '0';
    switches_tb    <= "1000";
    wait for 1 * CLK_PERIOD;

    push_button_tb <= '1';
    wait for CLK_PERIOD;

    push_button_tb <= '0';
    wait for 30 * CLK_PERIOD;

    wait;
  end process input_stim;

end architecture led_pattern_tb_arch;
