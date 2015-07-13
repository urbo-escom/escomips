--
--                di_size
--        ________/
--       /        \
--       0x....xxxx
--       ||....||||
--       vv....vvvv
-- 00..000x....xxxx
-- \______________/
--                \
--                do_size
--

--
--                di_size
--        ________/
--       /        \
--       1x....xxxx
--       ||....||||
--       vv....vvvv
-- 11..111x....xxxx
-- \______________/
--                \
--                do_size
--

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;


entity sign_ext is
	generic (
		di_size: positive := 8;
		do_size: positive := 8
	);
	port (
		di: in std_logic_vector(di_size-1 downto 0);
		do: out std_logic_vector(do_size-1 downto 0)
	);
end sign_ext;


architecture sign_ext_arch of sign_ext is
begin
	do(do_size-1 downto di_size) <=
		(others => '0') when di(di_size-1) = '0' else
		(others => '1') when di(di_size-1) = '1';
	do(di_size-1 downto 0) <= di;
end sign_ext_arch;
