library ieee;
use ieee.std_logic_1164.all;

entity one_pulse_tb is
end entity one_pulse_tb;

architecture testbench of one_pulse_tb is
    signal clk_tb   : std_ulogic := '0';
    signal rst_tb   : std_ulogic := '0';
    signal input_tb : std_ulogic := '0';
    signal pulse_tb : std_ulogic;

begin
    -- Instantiate the one pulse component
    dut : entity work.one_pulse
        port map (
            clk   => clk_tb,
            rst   => rst_tb,
            input => input_tb,
            pulse => pulse_tb
        );

    -- Clock generation
    clk_tb <= not clk_tb after 10 ns;

    -- Stimuli process
    stimuli : process is
    begin
        -- Reset
        rst_tb <= '1';
        wait for 40 ns;
        rst_tb <= '0';

        -- Apply input signal
        input_tb <= '1';
        wait for 20 ns;
        input_tb <= '0';

        -- Check again
        wait for 100 ns;
        input_tb <= '1';
        wait for 50 ns;
        input_tb <= '0';

        std.env.finish;
    end process stimuli;

end architecture testbench;
