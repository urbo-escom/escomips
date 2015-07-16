library std;
	use std.textio.all;
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.types.all;
	use work.math.log;
	use work.ctype.num_base;
	use work.conv.stdlv2str;
	use work.conv.str2int;
	use work.conv.int2str;
	use work.conv.ustdlv;
	use work.conv.uint;
	use work.conv.int;
	use work.microinstr.all;


entity escomips_program00_test is
	generic (
		test_in: string := "escomips-program00-test-in.txt";
		test_out: string := "escomips-program00-test-out.txt"
	);
end escomips_program00_test;


architecture escomips_program00_test_arch of escomips_program00_test is

	constant clk_period: time := 250 ns;
	signal clk_en: std_logic := '1';
	signal clk: std_logic;

	signal clr: std_logic;
	signal led: std_logic_vector(15 downto 0);

begin

	clk0: entity work.clock_pulse
		generic map (period => clk_period)
		port map (enable => clk_en, clock => clk);

	escomips_program000: entity work.escomips_program00
	generic map (
		debug_stack         => true,
		debug_register_file => true,
		debug_alu           => true,
		debug_data_memory   => true,
		debug_control       => true,
		speed => 1,
		common_cathode => true
	)
	port map (
		clk => clk,
		clr => clr,
		led => led
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

			-- reset
			str2int(l0.all(i to l0.all'right), i, n);
			if n /= 0 then
				report "Reset start...";
				clr <= '1';
				wait for clk_period*3/4;
				report "Reset end";
				clr <= '0';
				write(l1, LF);
				write(l1, "# Reset ");
				writeline(f1, l1);
			end if;

			-- clocks
			str2int(l0.all(i to l0.all'right), i, n);

			while n /= 0 loop
				report "Clock: " & natural'image(n);

				write(l1, natural'image(0), right, 10);
				write(l1, natural'image(n), right, 10);
				write(l1, int2str(uint(led)), right, 10);
				writeline(f1, l1);

				n := n - 1;
				wait for clk_period;
			end loop;
		else
			writeline(f1, l0);
		end if;
		ln := ln + 1;

	end process;

end escomips_program00_test_arch;
