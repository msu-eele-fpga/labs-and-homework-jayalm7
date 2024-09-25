library ieee;
use ieee.std_logic_1164.all;

entity synchronizer_tb is
end entity synchronizer_tb;

architecture testbench of synchronizer_tb is
    signal clk_tb   : std_ulogic := '0';
    signal rst_tb   : std_ulogic := '0';
    signal async_tb : std_ulogic := '0';
    signal sync_tb  : std_ulogic;

begin
    -- Instantiate the synchronizer
    dut : entity work.synchronizer
        port map (
            clk   => clk_tb,
            rst   => rst_tb,
            async => async_tb,
            sync  => sync_tb
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

        std.env.finish;
    end process stimuli;

end architecture testbench;
