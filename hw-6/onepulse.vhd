library ieee;
use ieee.std_logic_1164.all;

entity one_pulse is
    port (
        clk   : in std_ulogic;
        rst   : in std_ulogic;
        input : in std_ulogic;
        pulse : out std_ulogic
    );
end entity one_pulse;

architecture behavioral of one_pulse is
    signal input_reg : std_ulogic := '0';
    signal pulse_reg : std_ulogic := '0';
begin
    process (clk, rst)
    begin
        if rst = '1' then
            input_reg <= '0';
            pulse_reg <= '0';
        elsif rising_edge(clk) then
            if input = '1' and input_reg = '0' then
                pulse_reg <= '1';
            else
                pulse_reg <= '0';
            end if;
            input_reg <= input;
        end if;
    end process;

    pulse <= pulse_reg;
end architecture behavioral;
