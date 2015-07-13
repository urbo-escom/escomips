library ieee;
	use ieee.std_logic_1164.all;

library work;
	use work.conv.uint;
	use work.microinstr.all;


entity control_funcode is
	generic (
		debug: boolean := false
	);
	port (
		a: in std_logic_vector(3 downto 0);
		d: out std_logic_vector(19 downto 0)
	);
end control_funcode;


architecture control_funcode_arch of control_funcode is

	type mem is array(0 to 15) of std_logic_vector(19 downto 0);
	constant func: mem := (
		 0 => MICRO_ADD,
		 1 => MICRO_SUB,
		 2 => MICRO_AND,
		 3 => MICRO_OR,
		 4 => MICRO_XOR,
		 5 => MICRO_NAND,
		 6 => MICRO_NOR,
		 7 => MICRO_XNOR,
		 8 => MICRO_NOT,
		 9 => MICRO_SLL,
		10 => MICRO_SRL,
		others => (others => '0')
	);

begin
	process(a)
	begin
		d <= func(uint(a));
		if debug then
		case uint(a) is
		when  0 => report "func:  ADD";
		when  1 => report "func:  SUB";
		when  2 => report "func:  AND";
		when  3 => report "func:   OR";
		when  4 => report "func:  XOR";
		when  5 => report "func: NAND";
		when  6 => report "func:  NOR";
		when  7 => report "func: XNOR";
		when  8 => report "func:  NOT";
		when  9 => report "func:  SLL";
		when 10 => report "func:  SRL";
		when others => report "func: UNKOWN";
		end case;
		end if;
	end process;
end control_funcode_arch;
