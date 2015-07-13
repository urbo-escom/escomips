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


entity stack_test is
	generic (
		test_in: string := "stack-test-in.txt";
		test_out: string := "stack-test-out.txt"
	);
end stack_test;


architecture stack_test_arch of stack_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

	constant stack_size: positive := 8;
	constant addr_width: positive := 16;
	signal clr: std_logic;
	signal up: std_logic;
	signal dw: std_logic;
	signal wpc: std_logic;
	signal d: std_logic_vector(addr_width-1 downto 0);
	signal q: std_logic_vector(addr_width-1 downto 0);

begin

	clk0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

	stack0: entity work.stack
	generic map (
		debug => true,
		stack_size => stack_size,
		addr_width => addr_width
	)
	port map (
		clk => clk,
		clr => clr,
		up => up,
		dw => dw,
		wpc => wpc,
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

			-- up
			str2int(l0.all(i to l0.all'right), i, n);
			up <= ustdlv(n, 1)(0);

			-- dw
			str2int(l0.all(i to l0.all'right), i, n);
			dw <= ustdlv(n, 1)(0);

			-- wpc
			str2int(l0.all(i to l0.all'right), i, n);
			wpc <= ustdlv(n, 1)(0);

			-- d
			str2int(l0.all(i to l0.all'right), i, n);
			d <= ustdlv(n, d'length);

			parsed := true;
			wait until rising_edge(clk);
		else
			writeline(f1, l0);
		end if;

		if parsed then
			write(l1, int2str(uint(clr), dec), right, 9);
			write(l1, int2str( uint(up), dec), right, 6);
			write(l1, int2str( uint(dw), dec), right, 6);
			write(l1, int2str(uint(wpc), dec), right, 6);
			write(l1, int2str(  uint(d), hex), right, 8);
			write(l1, int2str(  uint(q), hex), right,10);
			writeline(f1, l1);
		end if;
		ln := ln + 1;

	end process;

end stack_test_arch;
