library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is
    port (
        clk   : in std_ulogic;
        rst   : in std_ulogic;
        async : in std_ulogic;
        sync  : out std_ulogic
    );
end entity synchronizer;

architecture behavioral of synchronizer is
    signal sync_reg : std_ulogic_vector(1 downto 0);
begin
    process (clk, rst)
    begin
        if rst = '1' then
            sync_reg <= (others => '0');
        elsif rising_edge(clk) then
            sync_reg(0) <= async;
            sync_reg(1) <= sync_reg(0);
        end if;
    end process;

    sync <= sync_reg(1);  -- output synchronized signal
end architecture behavioral;