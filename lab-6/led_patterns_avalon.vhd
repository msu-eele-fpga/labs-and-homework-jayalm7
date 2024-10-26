library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity led_patterns_avalon is
  port (
    clk           : in std_ulogic;
    rst           : in std_ulogic;
    -- Avalon Memory-Mapped Slave Interface
    avs_read      : in std_logic;
    avs_write     : in std_logic;
    avs_address   : in std_logic_vector(1 downto 0);
    avs_readdata  : out std_logic_vector(31 downto 0);
    avs_writedata : in std_logic_vector(31 downto 0);
    -- External I/O ports
    push_button   : in std_ulogic;
    switches      : in std_ulogic_vector(3 downto 0);
    led           : out std_ulogic_vector(7 downto 0)
  );
end led_patterns_avalon;

architecture Behavioral of led_patterns_avalon is
  -- Register declarations
  signal hps_led_control : std_logic_vector(31 downto 0) := (others => '0');
  signal base_period     : std_logic_vector(31 downto 0) := (others => '0');
  signal led_reg         : std_logic_vector(7 downto 0) := (others => '0');
begin
  -- Write process
  process(clk, rst)
  begin
    if rst = '1' then
      hps_led_control <= (others => '0');
      base_period     <= (others => '0');
      led_reg         <= (others => '0');
    elsif rising_edge(clk) then
      if avs_write = '1' then
        case avs_address is
          when "00" => hps_led_control <= avs_writedata;
          when "01" => base_period     <= avs_writedata;
          when "10" => led_reg         <= avs_writedata(7 downto 0);
          when others => null;
        end case;
      end if;
    end if;
  end process;

  -- Read process
  process(avs_read, avs_address, hps_led_control, base_period, led_reg)
  begin
    if avs_read = '1' then
      case avs_address is
        when "00" => avs_readdata <= hps_led_control;
        when "01" => avs_readdata <= base_period;
        when "10" => avs_readdata <= "00000000" & led_reg;
        when others => avs_readdata <= (others => '0');
      end case;
    else
      avs_readdata <= (others => '0');
    end if;
  end process;

  -- Instantiate the led_patterns component
  led_pattern_inst: entity work.led_patterns
    port map (
      clk       => clk,
      rst       => rst,
      led       => led,
      switches  => switches,
      -- Map other internal signals
    );
end Behavioral;
