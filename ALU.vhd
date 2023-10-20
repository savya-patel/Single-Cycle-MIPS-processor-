library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Use Ieee.std_logic_signed.all;

entity ALU is 
    port (input1,input2: in std_logic_vector(31 downto 0);
	      clk: in std_logic;
			ALUcontrol: in std_logic_vector(3 downto 0);
			beqzero: out std_logic;
			result: out std_logic_vector(31 downto 0));
end ALU;

architecture behavior of ALU is 
signal zeroflag: std_logic_vector(31 downto 0);
begin 
    process(clk)
    begin 
        if rising_edge(clk) then 
		  case ALUcontrol is
            when "0000" => result <= input1 + input2;
            when "0010" => zeroflag <= input1 - input2;
					result<=zeroflag;
					if (zeroflag=0) then 
						beqzero<= '1';
					else 
						beqzero<= '0';
					end if; 
            when others => result <= input1 + input2;
        end case;
        end if;
    end process;
end behavior;
