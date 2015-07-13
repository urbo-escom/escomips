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
	use work.conv.int;


entity alu_test is
	generic (
		test_in: string := "alu-test-in.txt";
		test_out: string := "alu-test-out.txt"
	);
end alu_test;


architecture alu_test_arch of alu_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

	constant size: natural := 4;
	signal a: std_logic_vector(size-1 downto 0);
	signal b: std_logic_vector(size-1 downto 0);
	signal op: std_logic_vector(3 downto 0);
	signal s: std_logic_vector(size-1 downto 0);
	signal flags: std_logic_vector(3 downto 0);

begin

	clk0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

	alu0: entity work.alu
	generic map (
		debug => true,
		size => size
	)
	port map (
		a => a,
		b => b,
		op => op,
		s => s,
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

			-- a
			str2int(l0.all(i to l0.all'right), i, n);
			a <= ustdlv(n, b'length);

			-- b
			str2int(l0.all(i to l0.all'right), i, n);
			b <= ustdlv(n, b'length);

			-- op
			str2int(l0.all(i to l0.all'right), i, n);
			op <= ustdlv(n, op'length);

			parsed := true;
			wait until rising_edge(clk);

		else
			writeline(f1, l0);
		end if;

		if parsed then
			write(l1, int2str(    uint(a), bin), right,10);
			write(l1, int2str(    uint(b), bin), right,10);
			write(l1, int2str(   uint(op), bin), right,14);
			write(l1, int2str(    uint(s), bin), right,14);
			write(l1, int2str(uint(flags), bin), right, 9);

			report "ALU op[" & stdlv2str(op) & "](" &
			int2str(int(a)) & ", " & int2str(int(b)) &
			") = " & int2str(int(s)) & ", " &
			"[Ov, C, N, Z] = " & stdlv2str(flags);

			writeline(f1, l1);
		end if;
		ln := ln + 1;

	end process;

end alu_test_arch;
