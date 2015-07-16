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


entity shift_register_test is
	generic (
		test_in: string := "shift-register-test-in.txt";
		test_out: string := "shift-register-test-out.txt"
	);
end shift_register_test;


architecture shift_register_test_arch of shift_register_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

	constant size: natural := 8;
	signal clr: std_logic;
	signal load: std_logic;
	signal en: std_logic;
	signal d: std_logic_vector(size-1 downto 0);
	signal q: std_logic_vector(size-1 downto 0);

begin

	clk0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

	reg0: entity work.shift_register generic map (size => size) port map (
		clk => clk,
		clr => clr,
		load => load,
		en => en,
		d => d,
		q => q
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

			-- load
			str2int(l0.all(i to l0.all'right), i, n);
			load <= ustdlv(n, 1)(0);

			-- en
			str2int(l0.all(i to l0.all'right), i, n);
			en <= ustdlv(n, 1)(0);

			-- d
			str2int(l0.all(i to l0.all'right), i, n);
			d <= ustdlv(n, d'length);

			parsed := true;
			wait until rising_edge(clk);
		else
			writeline(f1, l0);
		end if;

		if parsed then
			write(l1, int2str( uint("0" & clr), dec), right, 9);
			write(l1, int2str(uint("0" & load), dec), right, 6);
			write(l1, int2str(  uint("0" & en), dec), right, 6);
			write(l1, int2str(         uint(d), hex), right, 8);
			write(l1, int2str(         uint(q), hex), right,12);
			writeline(f1, l1);
		end if;
		ln := ln + 1;

	end process;

end shift_register_test_arch;
