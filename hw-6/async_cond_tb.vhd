library ieee;
use ieee.std_logic_1164.all;

entity async_conditioner_tb is
end entity async_conditioner_tb;

architecture testbench of async_conditioner_tb is
    signal clk_tb     : std_ulogic := '0';
    signal rst_tb     : std_ulogic := '0';
    signal async_tb   : std_ulogic := '0';
    signal pulse_out_tb : std_ulogic;

begin
    -- Instantiate the async conditioner
    dut : entity work.async_conditioner
        port map (
            clk       => clk_tb,
            rst       => rst_tb,
            async_in  => async_tb,
            pulse_out => pulse_out_tb
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

        -- Apply async signal
        async_tb <= '1';
        wait for 50 ns;
        async_tb <= '0';
        wait for 50 ns;

        -- Repeat the process
        async_tb <= '1';
        wait for 50 ns;
        async_tb <= '0';

        wait for 100 ns;
        std.env.finish;
    end process stimuli;

end architecture testbench;
