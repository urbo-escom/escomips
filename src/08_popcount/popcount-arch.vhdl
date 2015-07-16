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


entity popcount is
	generic (
		speed: natural := 25;
		common_cathode: boolean := false
	);
	port (
		clk: in std_logic;
		clr: in std_logic;
		init: in std_logic;
		d: in std_logic_vector(7 downto 0);
		a: out std_logic_vector(7 downto 0);
		display7: out std_logic_vector(6 downto 0)
	);
end popcount;


architecture popcount_arch of popcount is

	signal clk_div: std_logic_vector(speed-1 downto 0);
	signal clk_div_d: std_logic_vector(speed-1 downto 0);

	constant size: natural := 8;
	signal reg_a: std_logic_vector(size-1 downto 0);
	signal zero: std_logic;
	signal zero_tmp: std_logic_vector(size-1 downto 0);

	signal count_ld: std_logic;
	signal count_en: std_logic;
	signal reg_ld: std_logic;
	signal reg_en: std_logic;
	signal dec_en: std_logic;

	constant hyphen: std_logic_vector(6 downto 0) := "0000001";
	constant hyphen_b: std_logic_vector(6 downto 0) := not "0000001";
	signal count: std_logic_vector(3 downto 0);
	signal disp_out: std_logic_vector(6 downto 0);

begin


	disp_cc: if common_cathode generate
		mux0: entity work.mux2to1
		generic map (size => 7)
		port map (
			a => hyphen,
			b => disp_out,
			s => dec_en,
			z => display7
		);
	end generate;
	disp_ca: if not common_cathode generate
		mux0: entity work.mux2to1
		generic map (size => 7)
		port map (
			a => hyphen_b,
			b => disp_out,
			s => dec_en,
			z => display7
		);
	end generate;
	a <= reg_a;


	zero_tmp(0) <= reg_a(0);
	gen_zero: for i in 1 to size-1 generate
		zero_tmp(i) <= reg_a(i) or zero_tmp(i-1);
	end generate gen_zero;
	zero <= not zero_tmp(size-1);


	clk_div0: entity work.counter
	generic map (size => speed)
	port map (
		clk => clk,
		clr => clr,
		load => '0',
		en => '1',
		d => clk_div_d,
		q => clk_div
	);


	popcount_asm0: entity work.popcount_asm port map (
		clk => clk_div(speed-1),
		clr => clr,
		init => init,
		a0 => reg_a(0),
		zero => zero,

		count_ld => count_ld,
		count_en => count_en,
		reg_ld => reg_ld,
		reg_en => reg_en,
		dec_en => dec_en
	);


	reg0: entity work.shift_register generic map (size => size) port map (
		clk => clk_div(speed-1),
		clr => clr,
		load => reg_ld,
		en => reg_en,
		d => d,
		q => reg_a
	);


	counter0: entity work.counter generic map (4) port map (
		clk => clk_div(speed-1),
		clr => clr,
		load => count_ld,
		en => count_en,
		d => "0000",
		q => count
	);


	disp0: entity work.bcd2display7
	generic map (common_cathode => common_cathode)
	port map (
		bcd => count,
		display7 => disp_out
	);


end popcount_arch;
