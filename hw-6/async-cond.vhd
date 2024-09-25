library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity async_cond is
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    input     : in  std_logic;
    debounced : out std_logic
  );
end entity async_cond;

architecture behavior of async_cond is
  signal clk_signal, rst_signal, input_signal, debounced_signal : std_logic;
  
  -- Define constants for the clock period and debounce time
  constant CLK_PERIOD    : time := 20 ns;
  constant DEBOUNCE_TIME : time := 100 ms;

begin

  -- Instantiate the debouncer
  u_debouncer : entity work.debouncer
    generic map (
      clk_period    => CLK_PERIOD,    -- Map clock period to debouncer
      debounce_time => DEBOUNCE_TIME  -- Map debounce time to debouncer
    )
    port map (
      clk       => clk_signal,        -- Clock signal
      rst       => rst_signal,        -- Reset signal
      input     => input_signal,      -- Input signal (bouncy signal)
      debounced => debounced_signal   -- Debounced output signal
    );

end architecture behavior;

