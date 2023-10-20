library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is 
    port (increment: in std_logic_vector(31 downto 0);
	      reset,clk: in std_logic;
			count: out std_logic_vector(31 downto 0));
end counter;

architecture behavior of counter is 
begin 
    process(clk)
    begin 
        if rising_edge(clk) then 
			if(reset='1') then
				count<=(others=>'0');
			end if;	
			count<=increment;
        end if;
    end process;
end behavior;
