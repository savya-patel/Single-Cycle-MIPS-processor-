library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use Ieee.std_logic_signed.all;

entity mips_overall is 
    port (clk,reset: in std_logic;
			result: out std_logic_vector(31 downto 0));
end mips_overall;

architecture behavior of mips_overall is 
	component reg is 
    port (source_1,source_2,destination: in std_logic_vector(4 downto 0);
			write_d: in std_logic_vector(31 downto 0);
			reset,clk,en_write: in std_logic;
         data_1,data_2: out std_logic_vector(31 downto 0));
	end component;
	component instr_mem is 
    port (address: in std_logic_vector(31 downto 0);
	      reset,clk: in std_logic;
			instruction: out std_logic_vector(31 downto 0));
	end component;
	component counter is 
    port (increment: in std_logic_vector(31 downto 0);
	      reset,clk: in std_logic;
			count: out std_logic_vector(31 downto 0));
	end component;
	component ALU is 
    port (input1,input2: in std_logic_vector(31 downto 0);
	      clk: in std_logic;
			ALUcontrol: in std_logic_vector(3 downto 0);
			beqzero: out std_logic;
			result: out std_logic_vector(31 downto 0));
	end component;
	component datamem is 
    port (address,write_data: in std_logic_vector(31 downto 0);
	      clk,reset,store_en,load_en: in std_logic;
			read_data: out std_logic_vector(31 downto 0));
	end component;
	component alu_control is 
    port (aluop: in std_logic_vector(1 downto 0);
			func: in std_logic_vector(4 downto 0);
	      clk: in std_logic;
			alu_instr: out std_logic_vector(3 downto 0));
	end component;
	component control is 
    port (opcode: in std_logic_vector(5 downto 0);
	      clk,reset: in std_logic;
			control_instr: out std_logic_vector(9 downto 0));
	end component;
	
	signal sig_write_d, sig_data1, sig_data2, sig_instr, sig_increment, sig_count, sig_input2, sig_result, sig_data_read_data, sig_count1, sig_count2, sig_count3, sig_count4: std_logic_vector(31 downto 0);
	--signal sig_instr_address, sig_data_address, sig_data_write_data, sig_input1: std_logic_vector(31 downto 0);
	signal sig_dest: std_logic_vector(4 downto 0); 	
	--signal sig_source1, sig_source2, sig_func: std_logic_vector(4 downto 0);
	signal sig_alu_instr: std_logic_vector(3 downto 0);	
	signal sig_control_instr: std_logic_vector(9 downto 0); 	
	--signal sig_aluop: std_logic_vector(1 downto 0);
	--signal sig_opcode: std_logic_vector(5 downto 0);
	signal sig_beqzero: std_logic;
	--signal sig_en_store, sig_en_load, sig_en_write, sig_and, mux1, mux2, mux3, mux4, mux5: std_logic;
	signal extended_input, extended_count: std_logic_vector(31 downto 0);
	
	begin 
	result <= sig_write_d;
	extended_input <= (31 downto 16 => sig_instr(15)) & sig_instr(15 downto 0);
	
	--sig_opcode<=sig_instr(31 downto 26);
	--sig_source1<=sig_instr(25 downto 21);
	--sig_source2<=sig_instr(20 downto 16);
	--sig_func<=sig_instr(4 downto 0);
	--sig_input1<=sig_data1;
	--mux1<=sig_control_instr(9);
	--sig_en_write<=sig_control_instr(8);
	--mux2<=sig_control_instr(7);
	--sig_and<=sig_control_instr(6);
	--sig_aluop<=sig_control_instr(5 downto 4);
	--sig_en_store<=sig_control_instr(3);
	--sig_en_load<=sig_control_instr(2);
	--mux5<=sig_control_instr(1);
	--mux3<=sig_control_instr(0);
	--sig_instr_address <= sig_count;
   -- AND logic for sig_and and sig_beqzer
   -- Control logic for mux4 based on sig_and
	--sig_data_address<=sig_result;
	--sig_data_write_data<=sig_data2;
   --mux4 <= sig_beqzero AND sig_control_instr(6);

	sig_dest <= sig_instr(20 downto 16) when sig_control_instr(9) = '0' else
            sig_instr(15 downto 11) when sig_control_instr(9) = '1'; 

	sig_write_d <= sig_data_read_data when sig_control_instr(0) = '0' else
						sig_result when sig_control_instr(0) = '1';

	sig_input2 <= sig_data2 when sig_control_instr(7) = '0' else
					  extended_input when sig_control_instr(7) = '1';
	

	sig_count1 <= std_logic_vector(unsigned(sig_count) + 4); -- Increment sig_count by 4
	sig_count2 <= ((31 downto 18 => sig_instr(15)) & sig_instr(15 downto 0) & "00");	-- Calculate sig_count2 based on sig_instr
	sig_count3 <= sig_count1 + sig_count2;	-- Calculate sig_count3 based on sig_count1 and sig_count2
	sig_count4 <= sig_count1 when (sig_beqzero AND sig_control_instr(6)) = '0' else -- Choose sig_count4 based on mux4
               	sig_count3 when (sig_beqzero AND sig_control_instr(6)) = '1';
	extended_count <= (sig_count1(31 downto 28) & sig_instr(25 downto 0) & "00"); -- Calculate extended_count based on sig_count1 and sig_instr
	sig_increment <= sig_count4 when sig_control_instr(1) = '0' else -- Choose sig_increment based on mux5
						  extended_count when sig_control_instr(1) ='1';
	
	 alu_control_inst: alu_control
    port map (aluop => sig_control_instr(5 downto 4),
              func => sig_instr(4 downto 0),
              clk => clk,
              alu_instr => sig_alu_instr);

    control_inst: control
    port map (opcode => sig_instr(31 downto 26),
              clk => clk,
              reset => reset,
              control_instr => sig_control_instr);

    reg_inst : reg
    port map (source_1 => sig_instr(25 downto 21),
				  source_2 => sig_instr(20 downto 16),
				  destination => sig_dest,
				  write_d => sig_write_d,
				  reset => reset,
				  clk => clk,
				  en_write => sig_control_instr(8),
				  data_1 => sig_data1,
				  data_2 => sig_data2);

    instr_mem_inst : instr_mem
    port map ( address => sig_count,
				  reset => reset,
				  clk => clk,
				  instruction => sig_instr);

    counter_inst : counter
    port map (increment => sig_increment, 
				  reset => reset,
				  clk => clk,
				  count => sig_count); 

    ALU_inst : ALU
    port map (input1 => sig_data1,
				  input2 => sig_input2,
				  clk => clk,
				  ALUcontrol => sig_alu_instr,
				  beqzero => sig_beqzero,
				  result => sig_result);

    datamem_inst : datamem
    port map (address => sig_result,
				  write_data => sig_data2,
				  clk => clk,
				  reset => reset,
				  store_en => sig_control_instr(3),  
				  load_en => sig_control_instr(2),  
				  read_data => sig_data_read_data);
end behavior;