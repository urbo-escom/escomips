library std;
	use std.textio.all;
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.ctype.num_base;
	use work.conv.stdlv2str;
	use work.conv.str2int;
	use work.conv.int2str;
	use work.conv.ustdlv;
	use work.conv.uint;


entity control_test is
	generic (
		test_in: string := "control-test-in.txt";
		test_out: string := "control-test-out.txt"
	);
end control_test;


architecture control_test_arch of control_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

	signal clr: std_logic;
	signal flags: std_logic_vector(3 downto 0);
	signal opcode: std_logic_vector(4 downto 0);
	signal funcode: std_logic_vector(3 downto 0);
	signal lf: std_logic;
	signal microcode: std_logic_vector(19 downto 0);
	signal hl: std_logic;

begin


	clk0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

	control0: entity work.control
	generic map (
		debug => true
	)
	port map (
		clk => clk,
		clr => clr,
		opcode => opcode,
		funcode => funcode,
		flags => flags,
		lf => lf,
		microcode => microcode,
		hl => hl
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

			-- opcode
			str2int(l0.all(i to l0.all'right), i, n);
			opcode <= ustdlv(n, opcode'length);

			-- funcode
			str2int(l0.all(i to l0.all'right), i, n);
			funcode <= ustdlv(n, funcode'length);

			-- flags
			str2int(l0.all(i to l0.all'right), i, n);
			flags <= ustdlv(n, flags'length);

			-- clr
			str2int(l0.all(i to l0.all'right), i, n);
			clr <= ustdlv(n, 1)(0);

			-- lf
			str2int(l0.all(i to l0.all'right), i, n);
			lf <= ustdlv(n, 1)(0);

			report "Instr = " &
			stdlv2str(opcode) & "," &
			stdlv2str(funcode) & "," &
			stdlv2str(flags) & "," &
			std_logic'image(lf) &
			"";

			parsed := true;
			wait for clk_period/2;
		else
			writeline(f1, l0);
		end if;

		if parsed then
			write(l1, int2str(   uint(opcode), dec), right, 13);
			write(l1, int2str(  uint(funcode), dec), right, 10);
			write(l1, int2str(    uint(flags), bin), right,  9);
			write(l1, int2str(      uint(clr), dec), right,  6);
			write(l1, int2str(       uint(lf), dec), right,  5);
			write(l1, int2str(uint(microcode), bin), right, 26);
			write(l1, int2str(       uint(hl), dec), right,  7);
			writeline(f1, l1);
		end if;
		ln := ln + 1;

	end process;

end control_test_arch;
