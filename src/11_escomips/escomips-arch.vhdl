library std;
	use std.textio.all;
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.math.log;
	use work.ctype.num_base;
	use work.conv.str2int;
	use work.conv.int2str;
	use work.conv.ustdlv;
	use work.conv.uint;
	use work.microinstr.all;


entity escomips is
	generic (
		debug_stack:         boolean := false;
		debug_register_file: boolean := false;
		debug_alu:           boolean := false;
		debug_data_memory:   boolean := false;
		debug_control:       boolean := false;
		mem_size: positive := 256;
		stack_size: positive := 8;
		word_width: positive := 16
	);
	port (
		clk: in std_logic;
		clr: in std_logic;
		instr: in std_logic_vector(24 downto 0);
		micro: out std_logic_vector(19 downto 0);
		pc:    out std_logic_vector(word_width-1 downto 0);
		reg1:  out std_logic_vector(word_width-1 downto 0);
		reg2:  out std_logic_vector(word_width-1 downto 0);
		alu:   out std_logic_vector(word_width-1 downto 0);
		mem:   out std_logic_vector(word_width-1 downto 0);
		flags: out std_logic_vector(3 downto 0)
	);
end escomips;


architecture escomips_arch of escomips is

	alias opcode: std_logic_vector(4 downto 0) is instr(24 downto 20);
	alias funcode: std_logic_vector(3 downto 0) is instr(3 downto 0);
	alias rd: std_logic_vector(3 downto 0) is instr(19 downto 16);
	alias rt: std_logic_vector(3 downto 0) is instr(15 downto 12);
	alias rs: std_logic_vector(3 downto 0) is instr(11 downto  8);
	alias lit16: std_logic_vector(15 downto 0) is instr(15 downto 0);
	alias lit12: std_logic_vector(11 downto 0) is instr(11 downto 0);
	alias lit4:  std_logic_vector( 3 downto 0) is instr( 7 downto 4);

	-- Stack
	signal stack_up: std_logic;
	signal stack_dw: std_logic;
	signal stack_wpc: std_logic;
	signal stack_d: std_logic_vector(word_width-1 downto 0);
	signal stack_q: std_logic_vector(word_width-1 downto 0);
	signal mux_sr: std_logic_vector(word_width-1 downto 0);
	signal mux_sdmp: std_logic_vector(word_width-1 downto 0);

	-- Registers
	constant reg_size: positive := 16;
	signal reg_she: std_logic;
	signal reg_dir: std_logic;
	signal reg_wr: std_logic;
	signal reg_rr1: std_logic_vector(log(reg_size, 2)-1 downto 0);
	signal reg_rr2: std_logic_vector(log(reg_size, 2)-1 downto 0);
	signal reg_wrr: std_logic_vector(log(reg_size, 2)-1 downto 0);
	signal reg_wrd: std_logic_vector(word_width-1 downto 0);
	signal reg_shamt: std_logic_vector(log(word_width, 2)-1 downto 0);
	signal reg_rd1: std_logic_vector(word_width-1 downto 0);
	signal reg_rd2: std_logic_vector(word_width-1 downto 0);
	signal mux_sr2: std_logic_vector(log(reg_size, 2)-1 downto 0);
	signal mux_swd: std_logic_vector(word_width-1 downto 0);

	-- ALU
	signal alu_a: std_logic_vector(word_width-1 downto 0);
	signal alu_b: std_logic_vector(word_width-1 downto 0);
	signal alu_op: std_logic_vector(3 downto 0);
	signal alu_s: std_logic_vector(word_width-1 downto 0);
	signal alu_flags: std_logic_vector(3 downto 0);
	signal mux_sop1: std_logic_vector(word_width-1 downto 0);
	signal mux_sop2: std_logic_vector(word_width-1 downto 0);
	signal mux_sext: std_logic_vector(word_width-1 downto 0);
	signal dir_ext: std_logic_vector(word_width-1 downto 0);
	signal sign_ext: std_logic_vector(word_width-1 downto 0);

	-- Data memory
	signal mem_wr: std_logic;
	signal mem_a: std_logic_vector(word_width-1 downto 0);
	signal mem_di: std_logic_vector(word_width-1 downto 0);
	signal mem_do: std_logic_vector(word_width-1 downto 0);
	signal mux_sdmd: std_logic_vector(word_width-1 downto 0);

	-- Control
	signal control_opcode: std_logic_vector(4 downto 0);
	signal control_funcode: std_logic_vector(3 downto 0);
	signal control_flags: std_logic_vector(3 downto 0);
	signal control_lf: std_logic;
	signal control_microcode: std_logic_vector(19 downto 0);
	signal control_hl: std_logic;

begin

	micro <= control_microcode;
	pc    <= stack_q;
	reg1  <= reg_rd1;
	reg2  <= reg_rd2;
	alu   <= alu_s;
	mem   <= mem_do;
	flags <= alu_flags;

	stack0: entity work.stack
	generic map (
		debug => debug_stack,
		stack_size => stack_size,
		addr_width => word_width
	)
	port map (
		clk => clk,
		clr => clr,
		up  => stack_up,
		dw  => stack_dw,
		wpc => stack_wpc,
		d   => stack_d,
		q   => stack_q
	);
	stack_up  <= control_microcode(MICRO_UP);
	stack_dw  <= control_microcode(MICRO_DW);
	stack_wpc <= control_microcode(MICRO_WPC);
	stack_d   <= mux_sdmp;
		-- mux
		mux0: entity work.mux2to1
		generic map (size => word_width)
		port map (
			a => lit16,
			b => mux_sr,
			s => control_microcode(MICRO_MUX_SDMP),
			z => mux_sdmp
		);
		-- mux
		mux1: entity work.mux2to1
		generic map (size => word_width)
		port map (
			a => mem_do,
			b => alu_s,
			s => control_microcode(MICRO_MUX_SR),
			z => mux_sr
		);

	register_file0: entity work.register_file
	generic map (
		debug => debug_register_file,
		reg_size => reg_size,
		data_width => word_width
	)
	port map (
		clk   => clk,
		clr   => clr,
		she   => reg_she,
		dir   => reg_dir,
		wr    => reg_wr,
		rr1   => reg_rr1,
		rr2   => reg_rr2,
		wrr   => reg_wrr,
		wrd   => reg_wrd,
		shamt => reg_shamt,
		rd1   => reg_rd1,
		rd2   => reg_rd2
	);
	reg_she   <= control_microcode(MICRO_SHE);
	reg_dir   <= control_microcode(MICRO_DIR);
	reg_wr    <= control_microcode(MICRO_WR);
	reg_rr1   <= rt;
	reg_rr2   <= mux_sr2;
	reg_wrr   <= rd;
	reg_wrd   <= mux_swd;
	reg_shamt <= lit4;
		-- mux
		mux2: entity work.mux2to1
		generic map (size => log(reg_size, 2))
		port map (
			a => rs,
			b => rd,
			s => control_microcode(MICRO_MUX_SR2),
			z => mux_sr2
		);
		-- mux
		mux3: entity work.mux2to1
		generic map (size => word_width)
		port map (
			a => lit16,
			b => mux_sr,
			s => control_microcode(MICRO_MUX_SWD),
			z => mux_swd
		);

	alu0: entity work.alu
	generic map (
		debug => debug_alu,
		size => word_width
	)
	port map (
		a     => alu_a,
		b     => alu_b,
		op    => alu_op,
		s     => alu_s,
		flags => alu_flags
	);
	alu_a <= mux_sop1;
	alu_b <= mux_sop2;
	alu_op <= control_microcode(MICRO_ALUOP_UP downto MICRO_ALUOP_DW);
		-- mux
		mux4: entity work.mux2to1
		generic map (size => word_width)
		port map (
			a => reg_rd1,
			b => stack_q,
			s => control_microcode(MICRO_MUX_SOP1),
			z => mux_sop1
		);
		-- mux
		mux5: entity work.mux2to1
		generic map (size => word_width)
		port map (
			a => reg_rd2,
			b => mux_sext,
			s => control_microcode(MICRO_MUX_SOP2),
			z => mux_sop2
		);

	dir_ext  <= std_logic_vector(resize(unsigned(lit12), word_width));
	sign_ext <= std_logic_vector(resize(signed(lit12), word_width));
		-- mux
		mux6: entity work.mux2to1
		generic map (size => word_width)
		port map (
			a => dir_ext,
			b => sign_ext,
			s => control_microcode(MICRO_MUX_SEXT),
			z => mux_sext
		);

	data_memory0: entity work.data_memory
	generic map (
		debug => debug_data_memory,
		mem_size => mem_size,
		data_width => word_width
	)
	port map (
		clk => clk,
		wr  => mem_wr,
		a   => mem_a(log(mem_size, 2)-1 downto 0),
		di  => mem_di,
		do  => mem_do
	);
	mem_wr <= control_microcode(MICRO_WD);
	mem_a  <= mux_sdmd;
	mem_di <= reg_rd2;
		-- mux
		mux7: entity work.mux2to1
		generic map (size => word_width)
		port map (
			a => alu_s,
			b => lit16,
			s => control_microcode(MICRO_MUX_SDMD),
			z => mux_sdmd
		);

	control0: entity work.control
	generic map (
		debug => debug_control
	)
	port map (
		clk       => clk,
		clr       => clr,
		opcode    => control_opcode,
		funcode   => control_funcode,
		flags     => control_flags,
		lf        => control_lf,
		microcode => control_microcode,
		hl        => control_hl
	);
	control_opcode  <= opcode;
	control_funcode <= funcode;
	control_flags   <= alu_flags;
	control_lf      <= control_microcode(MICRO_LF);

end escomips_arch;
