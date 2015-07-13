--
-- flags xxxx
--       ||||
-- ov ---+|||
--  c ----+||
--  n -----+|
--  z ------+
--
-- cond  xxxxxx
--       ||||||
--  eq --|||||+
-- neq --||||+
--  lt --|||+
--  le --||+
--  gt --|+
-- get --+
--

library ieee;
	use ieee.std_logic_1164.all;


entity control_cond is
	port (
		flags: in  std_logic_vector (3 downto 0);
		cond: out std_logic_vector(5 downto 0)
	);
end control_cond;


architecture control_cond_arch of control_cond is
	constant flag_z:  integer := 0;
	constant flag_n:  integer := 1;
	constant flag_c:  integer := 2;
	constant flag_ov: integer := 3;
	constant eq:  integer := 0;
	constant neq: integer := 1;
	constant lt:  integer := 2;
	constant le:  integer := 3;
	constant gt:  integer := 4;
	constant get: integer := 5;
begin
	cond( eq) <= flags(flag_z);
	cond(neq) <= not flags(flag_z);
	cond( lt) <= not flags(flag_c);
	cond( le) <= flags(flag_z) or not flags(flag_c);
	cond( gt) <= flags(flag_c) and not flags(flag_z);
	cond(get) <= flags(flag_c);
end control_cond_arch;
