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
	use work.microinstr.all;


entity microinstr_test is
	generic (
		test_in: string := "microinstr-test-in.txt";
		test_out: string := "microinstr-test-out.txt"
	);
end microinstr_test;


architecture microinstr_test_arch of microinstr_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

begin

	clk0: entity work.clock_pulse
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

			-- bcd
			-- str2int(l0.all(i to l0.all'right), i, n);
			-- bcd <= ustdlv(n, bcd'length);

			parsed := true;
			wait until rising_edge(clk);
		else
			-- writeline(f1, l0);
		end if;

		if parsed then
			-- write(l1, int2str(uint(display7_ca), hex), right, 8);
			-- writeline(f1, l1);
		end if;
		ln := ln + 1;

	end process;

end microinstr_test_arch;
