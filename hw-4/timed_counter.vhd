library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timed_counter is
    generic (
        clk_period : time;
        count_time : time
    );
    port (
        clk    : in std_ulogic;
        enable : in boolean;
        done   : out boolean
    );
end entity timed_counter;

architecture timed_counter_arch of timed_counter is
    constant COUNTER_LIMIT : integer := integer(count_time / clk_period);
    signal counter : integer range 0 to COUNTER_LIMIT := 0;
begin
    counter_proc : process (clk, enable) is
    begin
        if rising_edge(clk) then
            if enable = true then
                if counter = COUNTER_LIMIT then
                    counter <= 0;
                    done <= true;
                else
                    counter <= counter + 1;
                    done <= false;
                end if;
            else
                counter <= 0;  -- Reset counter when disabled
                done <= false;
            end if;
        end if;
    end process;
end architecture timed_counter_arch;

