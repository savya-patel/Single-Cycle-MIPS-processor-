library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_mem is 
    port (address: in std_logic_vector(31 downto 0);
	      reset,clk: in std_logic;
			instruction: out std_logic_vector(31 downto 0));
end instr_mem;

architecture behavior of instr_mem is 
	type memtype is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal mem: memtype;
    
begin 
    process(clk)
    begin 
        if rising_edge(clk) then 
			if(reset='1') then
				mem<=(others=>(others=>'0'));
			else 
				instruction<=mem(to_integer(unsigned(address)));
			end if;
        end if;
    end process;
end behavior;
