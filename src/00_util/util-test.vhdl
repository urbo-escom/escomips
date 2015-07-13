library std;
	use std.textio.all;

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use work.math.all;
	use work.ctype.all;
	use work.conv.all;


entity util_test is
	generic (
		test_in: string := "util-test-in.txt";
		test_out: string := "util-test-out.txt"
	);
end util_test;


architecture util_test_arch of util_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

begin

	util0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

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

			str2int(l0.all(i to l0.all'right), i, n);
			write(l1, int2str(n, dec), right, 10);

			str2int(l0.all(i to l0.all'right), i, n);
			write(l1, int2str(n, hex), right, 10);

			str2int(l0.all(i to l0.all'right), i, n);
			write(l1, int2str(n, oct), right, 10);

			str2int(l0.all(i to l0.all'right), i, n);
			write(l1, int2str(n, bin), right, 10);

			writeline(f1, l1);

			parsed := true;
			deallocate(l0);
			wait until rising_edge(clk);
		else
			writeline(f1, l0);
		end if;
		ln := ln + 1;
	end process;

end util_test_arch;
