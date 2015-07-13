--
-- ALU
--
--
--              op
--             /
--       .    /   flags
--       |'+./   /
--    a -|   \  /
--       |    \/
--       `'+.  \
--           +  |- s
--        .+`  /
--       |    /
--    b -|   /
--       | .`
--       +`
--
-- op    xxxx
--       ||||
-- ~A ---+|||
-- ~B ----+||
-- op -----++
--   \
--    +--> 00 and
--    +--> 01  or
--    +--> 10 xor
--    +--> 11 sum
--
-- flags xxxx
--       ||||
-- ov ---+|||
--  c ----+||
--  n -----+|
--  z ------+
--

library ieee;
	use ieee.std_logic_1164.all;

library work;
	use work.conv.stdlv2str;
	use work.conv.int2str;
	use work.conv.uint;
	use work.conv.int;


entity alu is
	generic (
		debug: boolean := false;
		size: positive := 4
	);
	port (
		a: in std_logic_vector(size-1 downto 0);
		b: in std_logic_vector(size-1 downto 0);
		op: in std_logic_vector(3 downto 0);
		s: out std_logic_vector(size-1 downto 0);
		flags: out std_logic_vector(3 downto 0)
	);
end alu;


architecture alu_arch of alu is
	constant flag_z:  integer := 0;
	constant flag_n:  integer := 1;
	constant flag_c:  integer := 2;
	constant flag_ov: integer := 3;
	signal g, p, r: std_logic_vector(size-1 downto 0)
		:= (others => '0');
	signal a_mux, b_mux: std_logic_vector(size-1 downto 0)
		:= (others => '0');
	signal t_flags: std_logic_vector(flags'range)
		:= (others => '0');
begin

	a_mux <= (not a) when (op(3) = '1') else a;
	b_mux <= (not b) when (op(2) = '1') else b;
	g <= a_mux and b_mux;
	p <= a_mux xor b_mux;
	s <= r;
	flags <= t_flags;

	process(a_mux, b_mux, g, p, op, r)
		variable t: std_logic_vector(size downto 0)
			:= (others => '0');
		constant zero: std_logic_vector(size-1 downto 0)
			:= (others => '0');
	begin

		case op(1 downto 0) is
		when "00" =>
			t := "0" & zero;
			r <= g;
		when "01" =>
			t := "0" & zero;
			r <= a_mux or b_mux;
		when "10" =>
			t := "0" & zero;
			r <= p;
		when others =>
			t(0) := op(2);
			for i in 1 to size loop
				t(i) := g(i-1) or (p(i-1) and t(i-1));
				r(i-1) <= a_mux(i-1) xor b_mux(i-1) xor t(i-1);
			end loop;
		end case;

		if zero = r then
			t_flags(flag_z)  <= '1';
		else
			t_flags(flag_z)  <= '0';
		end if;
		t_flags(flag_n)  <= r(size-1);
		t_flags(flag_c)  <= t(size);
		t_flags(flag_ov) <= t(size) xor t(size-1);

	end process;

end alu_arch;
