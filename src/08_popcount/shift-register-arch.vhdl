library ieee;
	use ieee.std_logic_1164.all;

library work;
	use work.conv.uint;


entity shift_register is
	generic(size: natural := 4);
	port(
		clk: in std_logic;
		clr: in std_logic;
		load: in std_logic;
		en: in std_logic;
		d: in std_logic_vector(size-1 downto 0);
		q: out std_logic_vector(size-1 downto 0)
	);
end shift_register;


architecture shift_register_arch of shift_register is
	alias slv is to_stdlogicvector [bit_vector return std_logic_vector];
	alias bv is to_bitvector [std_logic_vector, bit return bit_vector];
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
				t := slv(bv(t) srl 1);
			elsif (load = '1' and en = '0') then
				t := d;
			end if;
		end if;
		q <= t;
	end process;

end shift_register_arch;
