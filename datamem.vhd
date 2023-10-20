library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datamem is 
    port (address,write_data: in std_logic_vector(31 downto 0);
	      clk,reset,store_en,load_en: in std_logic;
			read_data: out std_logic_vector(31 downto 0));
end datamem;

architecture behavior of datamem is 
	type datastorage is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal data: datastorage;
begin
    process(clk)
    begin 
        if rising_edge(clk) then 
			if reset='1' then
				data<=(others=>(others=>'0'));
			elsif (store_en='1') then 
				data(to_integer(unsigned(address)))<=write_data;
			elsif (load_en='1') then
				read_data<=data(to_integer(unsigned(address)));
			end if;
        end if;
    end process;
end behavior;