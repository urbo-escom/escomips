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


entity popcount_asm_test is
	generic (
		test_in: string := "popcount-asm-test-in.txt";
		test_out: string := "popcount-asm-test-out.txt"
	);
end popcount_asm_test;


architecture popcount_asm_test_arch of popcount_asm_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

	signal clr: std_logic;
	signal init: std_logic;
	signal a0: std_logic;
	signal zero: std_logic;

	signal count_ld: std_logic;
	signal count_en: std_logic;
	signal reg_ld: std_logic;
	signal reg_en: std_logic;
	signal dec_en: std_logic;

begin

	clk0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

	popcount_asm0: entity work.popcount_asm port map (
		clk => clk,
		clr => clr,
		init => init,
		a0 => a0,
		zero => zero,

		count_ld => count_ld,
		count_en => count_en,
		reg_ld => reg_ld,
		reg_en => reg_en,
		dec_en => dec_en
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

			-- clr
			str2int(l0.all(i to l0.all'right), i, n);
			clr <= ustdlv(n, 1)(0);

			-- init
			str2int(l0.all(i to l0.all'right), i, n);
			init <= ustdlv(n, 1)(0);

			-- a0
			str2int(l0.all(i to l0.all'right), i, n);
			a0 <= ustdlv(n, 1)(0);

			-- zero
			str2int(l0.all(i to l0.all'right), i, n);
			zero <= ustdlv(n, 1)(0);

			parsed := true;
			wait until rising_edge(clk);
		else
			writeline(f1, l0);
		end if;

		if parsed then
			write(l1, int2str(  uint("0" & clr), dec), right, 9);
			write(l1, int2str( uint("0" & init), dec), right, 6);
			write(l1, int2str(   uint("0" & a0), dec), right, 6);
			write(l1, int2str( uint("0" & zero), dec), right, 6);

			write(l1, int2str(uint("0" & count_ld), dec), right,10);
			write(l1, int2str(uint("0" & count_en), dec), right,11);
			write(l1, int2str(uint("0" &   reg_ld), dec), right, 9);
			write(l1, int2str(uint("0" &   reg_en), dec), right, 8);
			write(l1, int2str(uint("0" &   dec_en), dec), right, 8);
			writeline(f1, l1);
		end if;
		ln := ln + 1;

	end process;

end popcount_asm_test_arch;
