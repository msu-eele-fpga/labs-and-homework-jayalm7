library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_state_machine is
    port (
        clk        : in std_logic;       -- System clock
        reset      : in std_logic;       -- Reset signal
        switch     : in std_logic;       -- Input to change state
        push_button: in std_logic;       -- Push button for state transition
        led_output : out std_logic_vector(3 downto 0)  -- LED output signals
    );
end led_state_machine;

architecture fsm of led_state_machine is

    -- Define the states
    type state_type is (State0, State1, State2, State3);
    signal current_state, next_state : state_type;
    signal pattern_output : std_logic_vector(3 downto 0);  -- LED pattern from generators

begin
    -- State transition logic
    process (clk, reset)
    begin
        if reset = '1' then
            current_state <= State0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Next state logic and pattern output
    process (current_state, switch, push_button)
    begin
        case current_state is
            when State0 =>
                if push_button = '1' then
                    next_state <= State1;
                else
                    next_state <= State0;
                end if;
                pattern_output <= "0001";  -- Generator 0: 1 LED shifting right

            when State1 =>
                if switch = '1' then
                    next_state <= State2;
                else
                    next_state <= State1;
                end if;
                pattern_output <= "0011";  -- Generator 1: 2 LEDs shifting left

            when State2 =>
                if switch = '1' then
                    next_state <= State3;
                else
                    next_state <= State2;
                end if;
                pattern_output <= "0100";  -- Generator 2: Example pattern

            when State3 =>
                if switch = '1' then
                    next_state <= State1;
                else
                    next_state <= State3;
                end if;
                pattern_output <= "1000";  -- Generator 3: Down counter pattern
        end case;
    end process;

    -- Output the LED pattern
    led_output <= pattern_output;

end fsm;
