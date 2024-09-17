library ieee;
use ieee.std_logic_1164.all;
use work.print_pkg.all;
use work.assert_pkg.all;
use work.tb_pkg.all;

entity timed_counter_tb is
end entity timed_counter_tb;

architecture testbench of timed_counter_tb is

    component timed_counter is
        generic (
            clk_period : time;
            count_time : time
        );
        port (
            clk    : in std_ulogic;
            enable : in boolean;
            done   : out boolean
        );
    end component timed_counter;

    signal clk_tb : std_ulogic := '0';
    signal enable_100ns_tb : boolean := false;
    signal done_100ns_tb : boolean;

    constant HUNDRED_NS : time := 100 ns;

begin
    -- Clock generation
    clk_tb <= not clk_tb after CLK_PERIOD / 2;

    -- DUT instantiation (100 ns counter)
    dut_100ns_counter : component timed_counter
        generic map (
            clk_period => CLK_PERIOD,
            count_time => HUNDRED_NS
        )
        port map (
            clk => clk_tb,
            enable => enable_100ns_tb,
            done => done_100ns_tb
        );

    stimuli_and_checker : process is
        procedure predict_counter_done (
            constant count_time : in time;
            signal enable       : in boolean;
            signal done         : in boolean;
            constant count_iter : in natural
        ) is
        begin
            if enable then
                if count_iter < (count_time / CLK_PERIOD) then
                    assert_false(done, "counter not done");
                else
                    assert_true(done, "counter is done");
                end if;
            else
                assert_false(done, "counter not enabled");
            end if;
        end procedure;

    begin
        -- Test case 1: 100 ns timer, enabled
        print("Testing 100 ns timer: enabled");
        wait_for_clock_edge(clk_tb);
        enable_100ns_tb <= true;

        -- loop for the number of clock cycles that is equal to the timer's period
        for i in 0 to (HUNDRED_NS / CLK_PERIOD) loop
            wait_for_clock_edge(clk_tb);
            predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
        end loop;

        -- Test case 2: Timer disabled for 2 cycles
        print("Testing 100 ns timer for 2 cycles: disabled");
        wait_for_clock_edge(clk_tb);
        enable_100ns_tb <= false;

        for i in 0 to (HUNDRED_NS / CLK_PERIOD) * 2 loop
            wait_for_clock_edge(clk_tb);
            predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
        end loop;

        -- Test case 3: Timer enabled for multiple cycles
        print("Testing 100 ns timer for multiple cycles: enabled");
        wait_for_clock_edge(clk_tb);
        enable_100ns_tb <= true;

        for j in 0 to 3 loop  -- Testing multiple periods
            for i in 0 to (HUNDRED_NS / CLK_PERIOD) loop
                wait_for_clock_edge(clk_tb);
                predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
            end loop;
        end loop;

        -- End of simulation
        std.env.finish;
    end process stimuli_and_checker;
end architecture testbench;

