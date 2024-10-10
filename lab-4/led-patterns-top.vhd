library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity led_patterns is
    Port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        sw      : in  std_logic_vector(1 downto 0);
        led     : out std_logic_vector(7 downto 0)
    );
end led_patterns;

architecture Behavioral of led_patterns is

    -- Define states for pattern selection
    type state_type is (IDLE, PATTERN1, PATTERN2, PATTERN3, PATTERN4);
    signal current_state, next_state : state_type;

    signal pattern_counter : std_logic_vector(31 downto 0);
    signal led_reg          : std_logic_vector(7 downto 0);

begin

    -- State machine for pattern control
    process (clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
            pattern_counter <= (others => '0');
        elsif rising_edge(clk) then
            current_state <= next_state;
            pattern_counter <= pattern_counter + 1;
        end if;
    end process;

    -- Determine next state based on switches
    process (current_state, sw)
    begin
        case current_state is
            when IDLE =>
                if sw = "00" then
                    next_state <= PATTERN1;
                elsif sw = "01" then
                    next_state <= PATTERN2;
                elsif sw = "10" then
                    next_state <= PATTERN3;
                elsif sw = "11" then
                    next_state <= PATTERN4;
                else
                    next_state <= IDLE;
                end if;

            when PATTERN1 =>
                if sw /= "00" then
                    next_state <= IDLE;
                else
                    next_state <= PATTERN1;
                end if;

            when PATTERN2 =>
                if sw /= "01" then
                    next_state <= IDLE;
                else
                    next_state <= PATTERN2;
                end if;

            when PATTERN3 =>
                if sw /= "10" then
                    next_state <= IDLE;
                else
                    next_state <= PATTERN3;
                end if;

            when PATTERN4 =>
                if sw /= "11" then
                    next_state <= IDLE;
                else
                    next_state <= PATTERN4;
                end if;

            when others =>
                next_state <= IDLE;
        end case;
    end process;

    -- Generate LED patterns based on the current state
    process (current_state, pattern_counter)
    begin
        case current_state is
            when PATTERN1 =>
                led_reg <= "10101010"; -- pattern 1 (Alternating)
            when PATTERN2 =>
                led_reg <= "11001100"; -- pattern 2 (Blocks of two)
            when PATTERN3 =>
                led_reg <= "11110000"; -- pattern 3 (Upper half on)
            when PATTERN4 =>
                led_reg <= pattern_counter(31 downto 24); -- pattern 4 (Counter-based)
            when others =>
                led_reg <= (others => '0');
        end case;
    end process;

    -- Assign the registered LED pattern to the output
    led <= led_reg;

end Behavioral;
