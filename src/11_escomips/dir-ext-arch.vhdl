--
--                di_size
--        ________/
--       /        \
--       xx....xxxx
--       ||....||||
--       vv....vvvv
-- 00..00xx....xxxx
-- \______________/
--                \
--                do_size
--

library ieee;
	use ieee.std_logic_1164.all;


entity dir_ext is
	generic (
		di_size: positive := 8;
		do_size: positive := 8
	);
	port (
		di: in std_logic_vector(di_size-1 downto 0);
		do: out std_logic_vector(do_size-1 downto 0)
	);
end dir_ext;


architecture dir_ext_arch of dir_ext is
begin
	do(do_size-1 downto di_size) <= (others => '0');
	do(di_size-1 downto 0) <= di;
end dir_ext_arch;
