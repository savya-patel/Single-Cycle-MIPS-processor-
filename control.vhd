library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is 
    port (opcode: in std_logic_vector(5 downto 0);
	      clk,reset: in std_logic;
			control_instr: out std_logic_vector(9 downto 0));
end control;

architecture behavior of control is 
begin
    process(clk)
    begin 
        if rising_edge(clk) then 
			if reset='1' then
				control_instr<=(others=>'0');
			else 
				case opcode is 
				-- control instr (10 bits): 0 mux1,0 reg_en,0 mux2,0 AND_gate(branch),
				-- 00 alu, 0 store, 0 load, 0 mux5(jump), 0 mux3
					when "000000" => control_instr <= "1100000001"; --ADD 
					when "000001" => control_instr <= "0110010001"; --ADDI
					when "000010" => control_instr <= "X0X0XX001X"; --JUMP
					when "000011" => control_instr <= "X00110000X"; --BEQ
					when "000100" => control_instr <= "0110010100"; --LOAD
					when "000101" => control_instr <= "X01001100X"; --STORE
					when others   => control_instr <= "1100000001"; --DEFAULT ADD
				end case;
			end if;
        end if;
    end process;
end behavior;