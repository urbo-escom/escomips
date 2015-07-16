library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.conv.uint;
	use work.conv.ustdlv;


entity counter is
	generic(size: natural := 4);
	port(
		clk: in std_logic;
		clr: in std_logic;
		load: in std_logic;
		en: in std_logic;
		d: in std_logic_vector(size-1 downto 0);
		q: out std_logic_vector(size-1 downto 0)
	);
end counter;


architecture counter_arch of counter is
begin

	process(clk, clr)
		variable t: std_logic_vector(size-1 downto 0);
	begin
		if (clr = '1') then
			t := (others => '0');
		elsif (rising_edge(clk)) then
			   if (load = '0' and en = '0') then
				t := t;
			elsif (load = '0' and en = '1') then
				t := std_logic_vector(
					unsigned(t) + to_unsigned(1, t'length)
				);
			elsif (load = '1' and en = '0') then
				t := d;
			end if;
		end if;
		q <= t;
	end process;

end counter_arch;
