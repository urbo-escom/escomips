library std;
	use std.textio.all;
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.types.all;
	use work.math.log;
	use work.ctype.num_base;
	use work.conv.stdlv2str;
	use work.conv.str2int;
	use work.conv.int2str;
	use work.conv.ustdlv;
	use work.conv.uint;
	use work.conv.int;
	use work.microinstr.all;


entity escomips_test is
	generic (
		test_in: string := "escomips-test-in.txt";
		test_out: string := "escomips-test-out.txt"
	);
end escomips_test;


architecture escomips_test_arch of escomips_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

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
	signal clr: std_logic;
	signal instr: std_logic_vector(24 downto 0);
	signal micro: std_logic_vector(19 downto 0);
	signal pc:    std_logic_vector(word_width-1 downto 0);
	signal reg1:  std_logic_vector(word_width-1 downto 0);
	signal reg2:  std_logic_vector(word_width-1 downto 0);
	signal alu:   std_logic_vector(word_width-1 downto 0);
	signal mem:   std_logic_vector(word_width-1 downto 0);
	signal flags: std_logic_vector(3 downto 0);

begin

	clk0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

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
		debug_stack         => true,
		debug_register_file => true,
		debug_alu           => true,
		debug_data_memory   => true,
		debug_control       => true,
		mem_size => mem_size,
		stack_size => stack_size,
		word_width => word_width
	)
	port map (
		clk => clk,
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

	process
		file f0: text open read_mode is test_in;
		file f1: text open write_mode is test_out;
		variable l0, l1: line;
		variable ln: positive := 1;
		variable i: positive;
		variable n: integer;
		variable parsed: boolean;
	begin

		if endfile(f0) then
			clk_en <= '0';
			wait;
		end if;

		parsed := false;
		readline(f0, l0);
		if l0'length /= 0 and l0(l0'low) /= '#' then
			i := 1;

			-- reset
			str2int(l0.all(i to l0.all'right), i, n);
			if n /= 0 then
				report "Reset start...";
				clr <= '1';
				wait for clk_period*3/4;
				report "Reset end";
				clr <= '0';
				write(l1, LF);
				write(l1, "# Reset ");
				writeline(f1, l1);
			end if;

			-- clocks
			str2int(l0.all(i to l0.all'right), i, n);

			report "Waiting " & natural'image(n) & " clocks";
			write(l1, LF);
			write(l1, "# Waiting " & natural'image(n) & " clocks");
			writeline(f1, l1);
			while n /= 0 loop
				report "--- CLOCKS LEFT: " & natural'image(n);
				report "--- INSTR: " & stdlv2str(instr);
				report "--- MICRO: " & micro2str(micro);
				n := n - 1;

				write(l1, LF);
				write(l1, "# clocks left " & natural'image(n));
				writeline(f1, l1);

				write(l1, "    => instr: ");
				write(l1, int2str(uint(instr(24 downto 20))));
				write(l1, " " & stdlv2str(instr(19 downto 16)));
				write(l1, " " & stdlv2str(instr(15 downto 12)));
				write(l1, " " & stdlv2str(instr(11 downto  8)));
				write(l1, " " & stdlv2str(instr( 7 downto  4)));
				write(l1, " " & stdlv2str(instr( 3 downto  0)));
				writeline(f1, l1);

				write(l1, "    => micro: ");
				write(l1, micro2str(micro));
				writeline(f1, l1);

				write(l1, "    => pc(next): ");
				write(l1, int2str(uint(pc)));
				writeline(f1, l1);

				write(l1, "    => reg1: ");
				write(l1, int2str(uint(reg1)));
				writeline(f1, l1);

				write(l1, "    => reg2: ");
				write(l1, int2str(uint(reg2)));
				writeline(f1, l1);

				write(l1, "    => alu: ");
				write(l1, int2str(int(alu)));
				writeline(f1, l1);

				write(l1, "    => mem: ");
				write(l1, int2str(int(mem)));
				writeline(f1, l1);

				write(l1, "    => flags ");
				write(l1, stdlv2str(flags));
				writeline(f1, l1);

				wait for clk_period;
			end loop;
		else
			writeline(f1, l0);
		end if;
		ln := ln + 1;

	end process;

end escomips_test_arch;
