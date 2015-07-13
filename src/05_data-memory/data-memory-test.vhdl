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


entity data_memory_test is
	generic (
		test_in: string := "data-memory-test-in.txt";
		test_out: string := "data-memory-test-out.txt"
	);
end data_memory_test;


architecture data_memory_test_arch of data_memory_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

	constant addr_width: positive := 11;
	constant data_width: positive := 16;
	signal wr: std_logic;
	signal a: std_logic_vector(addr_width-1 downto 0);
	signal di: std_logic_vector(data_width-1 downto 0);
	signal do: std_logic_vector(data_width-1 downto 0);

	alias slv is to_stdlogicvector [bit_vector return std_logic_vector];
	alias bv is to_bitvector [std_logic_vector, bit return bit_vector];

begin

	clk0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

	data_memory0: entity work.data_memory
	generic map (
		debug => true,
		addr_width => addr_width,
		data_width => data_width
	)
	port map (
		clk => clk,
		wr => wr,
		a => a,
		di => di,
		do => do
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
			a <= ustdlv(n, a'length);

			-- di
			str2int(l0.all(i to l0.all'right), i, n);
			di <= ustdlv(n, di'length);

			-- write/~read
			str2int(l0.all(i to l0.all'right), i, n);
			wr <= ustdlv(n, 1)(0);

			parsed := true;
			wait until rising_edge(clk);
		else
			writeline(f1, l0);
		end if;

		if parsed then
			write(l1, int2str( uint(a), hex), right, 10);
			write(l1, int2str(uint(di), hex), right,  9);
			write(l1, int2str(uint(wr), dec), right,  8);
			write(l1, int2str(uint(do), hex), right, 16);
			writeline(f1, l1);
		end if;
		ln := ln + 1;

	end process;

end data_memory_test_arch;
