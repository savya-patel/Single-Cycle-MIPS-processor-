library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_control is 
    port (aluop: in std_logic_vector(1 downto 0);
			func: in std_logic_vector(4 downto 0);
	      clk: in std_logic;
			alu_instr: out std_logic_vector(3 downto 0));
end alu_control;

architecture behavior of alu_control is 
begin
    process(clk)
    begin 
        if rising_edge(clk) then 
				case aluop is 
					when "00" => alu_instr <= "0000"; --ADD (J type)
					when "10" => alu_instr <= "0010"; --BEQ
					when others  => alu_instr <= "0000"; --DEFAULT ADD
				end case;
        end if;
    end process;
end behavior;