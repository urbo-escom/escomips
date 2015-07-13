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
	use work.conv.ustdlv;
	use work.conv.uint;


entity register_file_test is
	generic (
		test_in: string := "register-file-test-in.txt";
		test_out: string := "register-file-test-out.txt"
	);
end register_file_test;


architecture register_file_test_arch of register_file_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

	constant reg_size: positive := 16;
	constant data_width: positive := 16;
	signal clr: std_logic;
	signal she: std_logic;
	signal dir: std_logic;
	signal wr: std_logic;
	signal rr1: std_logic_vector(log(reg_size, 2)-1 downto 0);
	signal rr2: std_logic_vector(log(reg_size, 2)-1 downto 0);
	signal wrr: std_logic_vector(log(reg_size, 2)-1 downto 0);
	signal wrd: std_logic_vector(data_width-1 downto 0);
	signal shamt: std_logic_vector(log(data_width, 2)-1 downto 0);
	signal rd1: std_logic_vector(data_width-1 downto 0);
	signal rd2: std_logic_vector(data_width-1 downto 0);

begin

	clk0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

	register_file0: entity work.register_file
	generic map (
		debug => true,
		reg_size => reg_size,
		data_width => data_width
	)
	port map (
		clk => clk,
		clr => clr,
		she => she,
		dir => dir,
		wr => wr,
		rr1 => rr1,
		rr2 => rr2,
		wrr => wrr,
		wrd => wrd,
		shamt => shamt,
		rd1 => rd1,
		rd2 => rd2
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

			-- she
			str2int(l0.all(i to l0.all'right), i, n);
			she <= ustdlv(n, 1)(0);

			-- dir
			str2int(l0.all(i to l0.all'right), i, n);
			dir <= ustdlv(n, 1)(0);

			-- wr
			str2int(l0.all(i to l0.all'right), i, n);
			wr <= ustdlv(n, 1)(0);

			-- rr1
			str2int(l0.all(i to l0.all'right), i, n);
			rr1 <= ustdlv(n, rr1'length);

			-- rr2
			str2int(l0.all(i to l0.all'right), i, n);
			rr2 <= ustdlv(n, rr2'length);

			-- wrr
			str2int(l0.all(i to l0.all'right), i, n);
			wrr <= ustdlv(n, wrr'length);

			-- wrd
			str2int(l0.all(i to l0.all'right), i, n);
			wrd <= ustdlv(n, wrd'length);

			-- shamt
			str2int(l0.all(i to l0.all'right), i, n);
			shamt <= ustdlv(n, shamt'length);

			parsed := true;
			wait until rising_edge(clk);
		else
			writeline(f1, l0);
		end if;

		if parsed then

			write(l1, int2str(  uint(clr), dec), right,10);
			write(l1, int2str(  uint(she), dec), right, 4);
			write(l1, int2str(  uint(dir), dec), right, 4);
			write(l1, int2str(   uint(wr), dec), right, 4);
			write(l1, int2str(  uint(rr1), dec), right, 5);
			write(l1, int2str(  uint(rr2), dec), right, 5);
			write(l1, int2str(  uint(wrr), dec), right, 5);
			write(l1, int2str(  uint(wrd), dec), right, 6);
			write(l1, int2str(uint(shamt), dec), right, 7);
			write(l1, int2str(  uint(rd1), dec), right, 9);
			write(l1, int2str(  uint(rd2), dec), right, 6);

			writeline(f1, l1);
		end if;
		ln := ln + 1;

	end process;

end register_file_test_arch;
