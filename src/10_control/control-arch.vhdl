library std;
	use std.textio.all;
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.ctype.num_base;
	use work.conv.str2int;
	use work.conv.int2str;
	use work.conv.ustdlv;
	use work.conv.uint;


entity control is
	generic (
		debug: boolean := false
	);
	port (
		clk: in std_logic;
		clr: in std_logic;
		opcode: in std_logic_vector(4 downto 0);
		funcode: in std_logic_vector(3 downto 0);
		flags: in std_logic_vector(3 downto 0);
		lf: in std_logic;
		microcode: out std_logic_vector(19 downto 0);
		hl: out std_logic
	);
end control;


architecture control_arch of control is

	signal opcode_mux: std_logic_vector(4 downto 0);
	signal micro_mux: std_logic_vector(19 downto 0);
	signal funcode_d: std_logic_vector(19 downto 0);
	signal opcode_d: std_logic_vector(19 downto 0);
	signal sdopc: std_logic;
	signal sm: std_logic;

	signal reg: std_logic;
	signal branch: std_logic_vector(5 downto 0);
	signal cond: std_logic_vector(5 downto 0);
	signal flags_out: std_logic_vector(3 downto 0);

	signal hl_out: std_logic;

begin


	control_asm0: entity work.control_asm
	generic map (
		debug => debug
	)
	port map (
		hl => hl_out,
		reg => reg,
		branch => branch,
		cond => cond,
		sdopc => sdopc,
		sm => sm
	);


	control_funcode0: entity work.control_funcode
	generic map (
		debug => debug
	)
	port map (
		a => funcode,
		d => funcode_d
	);


	control_opcode0: entity work.control_opcode
	generic map (
		debug => debug
	)
	port map (
		a => opcode_mux,
		d => opcode_d
	);


	mux0: entity work.mux2to1
	generic map (size => 5)
	port map (
		a => "00000",
		b => opcode,
		s => sdopc,
		z => opcode_mux
	);


	mux1: entity work.mux2to1
	generic map (size => microcode'length)
	port map (
		a => funcode_d,
		b => opcode_d,
		s => sm,
		z => microcode
	);


	hl <= hl_out;
	control_clock0: entity work.control_clock
	port map (
		clk => clk,
		clr => clr,
		hl => hl_out
	);


	control_decoder0: entity work.control_decoder
	port map (
		a => opcode,
		reg => reg,
		branch => branch
	);


	control_cond0: entity work.control_cond
	port map (
		flags => flags_out,
		cond => cond
	);


	control_flags0: entity work.control_flags
	port map (
		clk => clk,
		clr => clr,
		lf => lf,
		flags_in => flags,
		flags_out => flags_out
	);


end control_arch;
