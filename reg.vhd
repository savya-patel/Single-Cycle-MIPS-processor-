library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is 
    port (source_1,source_2,destination: in std_logic_vector(4 downto 0);
			write_d: in std_logic_vector(31 downto 0);
			reset,clk,en_write: in std_logic;
         data_1,data_2: out std_logic_vector(31 downto 0));
end reg;

architecture behavior of reg is 
	type regtype is array (15 downto 0) of std_logic_vector(31 downto 0);
	signal regsig: regtype;
begin 
    process(clk)
    begin 
        if rising_edge(clk) then 
			if(reset='1') then
				regsig<=(others=>(others=>'0'));
			elsif (en_write='1') then
				regsig(to_integer(unsigned(destination)))<= write_d;
			end if;
			data_1<=regsig(to_integer(unsigned(source_1)));
			data_2<=regsig(to_integer(unsigned(source_2)));
        end if;
    end process;
end behavior;
