library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.conv.uint;
	use work.conv.stdlv;
	use work.conv.int2str;


entity stack is
	generic (
		debug: boolean := false;
		stack_size: positive := 8;
		addr_width: positive := 4
	);
	port (
		clk: in std_logic;
		clr: in std_logic;
		up: in std_logic;
		dw: in std_logic;
		wpc: in std_logic;
		d: in std_logic_vector(addr_width-1 downto 0);
		q: out std_logic_vector(addr_width-1 downto 0)
	);
end entity stack;


architecture stack_arch of stack is
	type arr is array (0 to stack_size-1) of
		std_logic_vector(addr_width-1 downto 0);
	signal ctrl: std_logic_vector(2 downto 0);
begin

	ctrl <= up & dw & wpc;
	process (clk, clr)
		variable i: natural range 0 to stack_size-1 := 0;
		variable s: arr := (others => (others => '0'));
	begin
		if rising_edge(clk) then

			if (clr = '1') then

				if debug then
				report "PC = NULL";
				end if;

				for k in 0 to stack_size-1 loop
					s(k) := (others => '0');
				end loop;
				i := 0;

			-- normal op
			elsif (ctrl = "000") then
				s(i) := stdlv(uint(s(i)) + 1, s(i)'length);

				if debug then
				report "PC[" &
				natural'image(i) & "]++ = " &
				int2str(uint(s(i))) &
				"";
				end if;

			-- branch op
			elsif (ctrl = "001") then
				s(i) := d;

				if debug then
				report "PC[" &
				natural'image(i) & "] = " &
				int2str(uint(s(i))) &
				"";
				end if;

			-- call op
			elsif (ctrl = "101") then
				i := i + 1;
				s(i) := d;

				if debug then
				report "SP++, PC[" &
				natural'image(i) & "] = " &
				int2str(uint(s(i))) &
				"";
				end if;

			-- ret op
			elsif (ctrl = "010") then
				i := i - 1;

				if debug then
				report "SP--, PC[" &
				natural'image(i) & "] = " &
				int2str(uint(s(i))) &
				"";
				end if;

			end if;

		end if;
		q <= s(i);
	end process;

end architecture stack_arch;
