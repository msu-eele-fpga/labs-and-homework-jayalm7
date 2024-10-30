library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
  generic (
    clk_period    : time := 20 ns;    -- Default clock period
    debounce_time : time := 100 ms    -- Default debounce time
  );
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    input     : in  std_logic;
    debounced : out std_logic
  );
end entity debouncer;

architecture rtl of debouncer is
  signal counter      : integer := 0;
  signal stable_value : std_logic := '0';  -- Holds the debounced output value
  signal prev_input   : std_logic := '0';  -- Tracks the previous input signal

  constant DEBOUNCE_CYCLES : integer := integer(debounce_time / clk_period);  -- Calculate debounce cycles

begin
  process (clk, rst)
  begin
    if rst = '1' then
      counter <= 0;
      stable_value <= '0';
      prev_input <= '0';
    elsif rising_edge(clk) then
      -- If the input has changed compared to the previous cycle
      if input /= prev_input then
        counter <= 0;  -- Reset counter on any change in input
        prev_input <= input;  -- Update previous input state
      else
        -- If input is stable, increment the counter
        if counter < DEBOUNCE_CYCLES then
          counter <= counter + 1;
        end if;

        -- If the input is stable for the entire debounce period, latch the stable_value
        if counter = DEBOUNCE_CYCLES then
          stable_value <= input;
        end if;
      end if;
    end if;
  end process;

  -- Assign stable_value to the debounced output
  debounced <= stable_value;

end architecture rtl;