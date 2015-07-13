library std;
	use std.textio.all;
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.math.log;
	use work.ctype.num_base;
	use work.conv.str2int;
	use work.conv.int2str;
	use work.conv.stdlv2str;
	use work.conv.ustdlv;
	use work.conv.uint;


entity program_memory_test is
	generic (
		test_in: string := "program-memory-test-in.txt";
		test_out: string := "program-memory-test-out.txt"
	);
end program_memory_test;


architecture program_memory_test_arch of program_memory_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

	constant program_size: positive := 4096;
	constant data_width: positive := 25;
	signal a: std_logic_vector(log(program_size, 2)-1 downto 0);
	signal d: std_logic_vector(data_width-1 downto 0);

	alias opcode: std_logic_vector(data_width-1 downto 20) is
	                          d(data_width-1 downto 20);
	alias data4: std_logic_vector(19 downto 16) is d(19 downto 16);
	alias data3: std_logic_vector(15 downto 12) is d(15 downto 12);
	alias data2: std_logic_vector(11 downto  8) is d(11 downto  8);
	alias data1: std_logic_vector( 7 downto  4) is d( 7 downto  4);
	alias data0: std_logic_vector( 3 downto  0) is d( 3 downto  0);

begin

	clk0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

	program_memory0: entity work.program_memory
	generic map (
		program_size => program_size,
		data_width => data_width
	)
	port map (
		clk => clk,
		a => a,
		d => d
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

		wait until rising_edge(clk);
		parsed := false;
		readline(f0, l0);
		if l0'length /= 0 and l0(l0'low) /= '#' then
			i := 1;

			-- a
			str2int(l0.all(i to l0.all'right), i, n);
			a <= ustdlv(n, a'length);

			parsed := true;
			wait until rising_edge(clk);
		else
			writeline(f1, l0);
		end if;

		if parsed then
			wait until rising_edge(clk);
			write(l1, int2str(uint(a), hex), right, 10);
			write(l1, "0b" & stdlv2str(opcode), right, 10);
			write(l1, "0b" &  stdlv2str(data4), right, 9);
			write(l1, "0b" &  stdlv2str(data3), right, 9);
			write(l1, "0b" &  stdlv2str(data2), right, 9);
			write(l1, "0b" &  stdlv2str(data1), right, 9);
			write(l1, "0b" &  stdlv2str(data0), right, 9);
			writeline(f1, l1);
		end if;
		ln := ln + 1;

	end process;

end program_memory_test_arch;
