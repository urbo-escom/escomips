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


entity bcd2display7_test is
	generic (
		test_in: string := "bcd2display7-test-in.txt";
		test_out: string := "bcd2display7-test-out.txt"
	);
end bcd2display7_test;


architecture bcd2display7_test_arch of bcd2display7_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

	signal bcd: std_logic_vector(3 downto 0);
	signal display7_cc: std_logic_vector(6 downto 0);
	signal display7_ca: std_logic_vector(6 downto 0);

begin

	clk0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

	disp0: entity work.bcd2display7
	generic map (common_cathode => true)
	port map (
		bcd => bcd,
		display7 => display7_cc
	);

	disp1: entity work.bcd2display7
	generic map (common_cathode => false)
	port map (
		bcd => bcd,
		display7 => display7_ca
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

			-- bcd
			str2int(l0.all(i to l0.all'right), i, n);
			bcd <= ustdlv(n, bcd'length);

			parsed := true;
			wait until rising_edge(clk);
		else
			writeline(f1, l0);
		end if;

		if parsed then
			write(l1, int2str(        uint(bcd), hex), right,12);
			write(l1, int2str(uint(display7_cc), hex), right, 8);
			write(l1, int2str(uint(display7_ca), hex), right, 8);
			writeline(f1, l1);
		end if;
		ln := ln + 1;

	end process;

end bcd2display7_test_arch;
