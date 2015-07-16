library std;
	use std.textio.all;
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.types.all;
	use work.math.log;


entity escomips_program00 is
	generic (
		debug_stack:         boolean := false;
		debug_register_file: boolean := false;
		debug_alu:           boolean := false;
		debug_data_memory:   boolean := false;
		debug_control:       boolean := false;
		speed: natural := 25;
		common_cathode: boolean := false
	);
	port (
		clk: in std_logic;
		clr: in std_logic;
		led: out std_logic_vector(15 downto 0)
	);
end escomips_program00;


architecture escomips_program00_arch of escomips_program00 is

	signal clk_div: std_logic_vector(speed-1 downto 0);

	constant program_size: positive := 256;
	constant program: slv25_arr_t(0 to program_size-1) := (
		0 => "00001" & "0000" & "0000" & "0000" & "0000" & "0001",
		1 => "00001" & "0001" & "0000" & "0000" & "0000" & "0111",
		2 => "00000" & "0001" & "0001" & "0000" & "0000" & "0000",
		3 => "00011" & "0001" & "0000" & "0000" & "0000" & "0101",
		4 => "10011" & "0000" & "0000" & "0000" & "0000" & "0010",
		others => (others => '0')
	);
	constant mem_size: positive := 256;
	constant stack_size: positive := 8;
	constant word_width: positive := 16;
	signal instr: std_logic_vector(24 downto 0);
	signal micro: std_logic_vector(19 downto 0);
	signal pc:    std_logic_vector(word_width-1 downto 0);
	signal reg1:  std_logic_vector(word_width-1 downto 0);
	signal reg2:  std_logic_vector(word_width-1 downto 0);
	signal alu:   std_logic_vector(word_width-1 downto 0);
	signal mem:   std_logic_vector(word_width-1 downto 0);
	signal flags: std_logic_vector(3 downto 0);

begin

	led <= reg2;

	clock_divisor0: entity work.clock_divisor
	generic map (size => speed)
	port map (
		clk => clk,
		q => clk_div
	);

	program_memory0: entity work.program_memory
	generic map (
		program_size => program_size,
		program => program
	)
	port map (
		a => pc(log(program_size, 2)-1 downto 0),
		d => instr
	);

	escomips0: entity work.escomips
	generic map (
		debug_stack         => debug_stack,
		debug_register_file => debug_register_file,
		debug_alu           => debug_alu,
		debug_data_memory   => debug_data_memory,
		debug_control       => debug_control,
		mem_size => mem_size,
		stack_size => stack_size,
		word_width => word_width
	)
	port map (
		clk => clk_div(speed-1),
		clr => clr,
		instr => instr,
		micro => micro,
		pc    => pc,
		reg1  => reg1,
		reg2  => reg2,
		alu   => alu,
		mem   => mem,
		flags => flags
	);

end escomips_program00_arch;
