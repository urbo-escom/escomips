library ieee;
	use ieee.std_logic_1164.all;

library work;
	use work.conv.int2str;
	use work.conv.uint;
	use work.conv.int;


entity data_memory is
	generic (
		debug: boolean := false;
		addr_width: positive := 11;
		data_width: positive := 16
	);
	port (
		clk: in std_logic;
		wr: in std_logic;
		a: in std_logic_vector(addr_width-1 downto 0);
		di: in std_logic_vector(data_width-1 downto 0);
		do: out std_logic_vector(data_width-1 downto 0)
	);
end entity data_memory;


architecture data_memory_arch of data_memory is
	type mem is array (0 to (2**addr_width)-1) of
		std_logic_vector(data_width-1 downto 0);
	signal ram: mem := (others => (others => '0'));
begin
	process (clk)
	begin
		if rising_edge(clk) then
			if wr = '1' then

				if debug then
				report "write " &
				"mem[" & natural'image(uint(a)) & "] = " &
				int2str(int(di));
				end if;

				ram(uint(a)) <= di;
			end if;

			if debug then
			report "read " &
			"mem[" & natural'image(uint(a)) & "] = " &
			int2str(int(ram(uint(a))));
			end if;

			do <= ram(uint(a));
		end if;
	end process;
end architecture data_memory_arch;
