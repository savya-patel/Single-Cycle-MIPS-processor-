library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips_overall_tb is
end mips_overall_tb;

architecture sim of mips_overall_tb is
    signal clk, reset: std_logic := '0';
    signal result: std_logic_vector(31 downto 0);
    
    -- Clock period definitions
    constant clk_period : time := 10 ns;
    
begin
    -- Instantiate the unit under test (UUT)
    uut: entity work.mips_overall
        port map (
            clk => clk,
            reset => reset,
            result => result
        );
        
    -- Clock process definitions
    clk_process :process
    begin
        wait for clk_period/2;
        clk <= not clk;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Reset pulse
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        
        -- Wait for some clock cycles
        wait for 10 * clk_period;
        
        -- Finish simulation
        wait;
    end process;

end sim;
