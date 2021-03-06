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


entity popcount_test is
	generic (
		test_in: string := "popcount-test-in.txt";
		test_out: string := "popcount-test-out.txt"
	);
end popcount_test;


architecture popcount_test_arch of popcount_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

	constant speed: positive := 1;
	signal clr: std_logic;
	signal init: std_logic;
	signal d: std_logic_vector(7 downto 0);
	signal a: std_logic_vector(7 downto 0);
	signal display7: std_logic_vector(6 downto 0);

begin

	clk0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

	popcount0: entity work.popcount
	generic map (
		speed => speed,
		common_cathode => true
	)
	port map (
		clk => clk,
		clr => clr,
		init => init,
		d => d,
		a => a,
		display7 => display7
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

			-- d
			str2int(l0.all(i to l0.all'right), i, n);
			d <= ustdlv(n, d'length);

			parsed := true;
			wait until rising_edge(clk);
		else
			writeline(f1, l0);
		end if;

		if parsed then
			write(l1, int2str(     uint(clr), dec), right, 9);
			write(l1, int2str(    uint(init), dec), right, 6);
			write(l1, int2str(       uint(d), bin), right, 14);
			write(l1, int2str(       uint(a), bin), right, 14);
			write(l1, int2str(uint(display7), bin), right, 14);
			writeline(f1, l1);
		end if;
		ln := ln + 1;

	end process;

end popcount_test_arch;
