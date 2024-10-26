library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern_generator is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        pattern_out : out std_logic_vector(3 downto 0)
    );
end pattern_generator;

architecture behavior of pattern_generator is
    signal counter : std_logic_vector(3 downto 0);
begin
    process (clk, reset)
    begin
        if reset = '1' then
            counter <= "0001";
        elsif rising_edge(clk) then
            -- Example logic: shifting 1 LED right
            counter <= counter(2 downto 0) & '0';
        end if;
    end process;

    pattern_out <= counter;
end behavior;
