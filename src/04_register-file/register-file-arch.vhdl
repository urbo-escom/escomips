library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.conv.int2str;
	use work.conv.uint;
	use work.conv.int;
	use work.math.log;


entity register_file is
	generic (
		debug: boolean := false;
		reg_size: positive := 16;
		data_width: positive := 16
	);
	port (
		clk: in std_logic;
		clr: in std_logic;
		she: in std_logic;
		dir: in std_logic;
		wr: in std_logic;
		rr1: in std_logic_vector(log(reg_size, 2)-1 downto 0);
		rr2: in std_logic_vector(log(reg_size, 2)-1 downto 0);
		wrr: in std_logic_vector(log(reg_size, 2)-1 downto 0);
		wrd: in std_logic_vector(data_width-1 downto 0);
		shamt: in std_logic_vector(log(data_width, 2)-1 downto 0);
		rd1: out std_logic_vector(data_width-1 downto 0);
		rd2: out std_logic_vector(data_width-1 downto 0)
	);
end register_file;


architecture register_file_arch of register_file is

	type arr is array (0 to reg_size-1) of
		std_logic_vector(data_width-1 downto 0);
	signal r: arr := (others => (others => '0'));

	alias slv is to_stdlogicvector [bit_vector return std_logic_vector];
	alias bv is to_bitvector [std_logic_vector, bit return bit_vector];

begin

	rd1 <= r(uint(rr1));
	rd2 <= r(uint(rr2));

	process(clk, clr)
	begin
		if (rising_edge(clk)) then

			-- reset
			if (clr = '1') then

				if debug then
				report "reg = NULL";
				end if;

				for i in 0 to reg_size-1 loop
					r(i) <= (others => '0');
				end loop;

			-- read (always)
			elsif (wr = '0') then
				-- empty --

			-- write
			elsif (she = '0') then

				if debug then
				report "write " &
				"reg[" & int2str(uint(wrr)) & "] = " &
					int2str(int(wrd)) &
				"";
				end if;

				r(uint(wrr)) <= wrd;

			-- shift right
			elsif (dir = '0') then

				if debug then
				report "shift " &
				"reg[" & int2str(uint(wrr))  & "] = " &
				"reg[" & int2str(uint(rr1))  & "] >> " &
					int2str(uint(shamt)) &
				"";
				end if;

				r(uint(wrr)) <=
					slv(bv(r(uint(rr1))) srl uint(shamt));

			-- shift left
			elsif (dir = '1') then

				if debug then
				report "shift " &
				"reg[" & int2str(uint(wrr))  & "] = " &
				"reg[" & int2str(uint(rr1))  & "] << " &
					int2str(uint(shamt)) &
				"";
				end if;

				r(uint(wrr)) <=
					slv(bv(r(uint(rr1))) sll uint(shamt));

			end if;

			if debug then
			report "read " &
			"reg[" & int2str(uint(rr1))         & "] = " &
				int2str(uint(r(uint(rr1)))) &   ", " &
			"reg[" & int2str(uint(rr2))         & "] = " &
				int2str(uint(r(uint(rr2)))) &
			"";
			end if;

		end if;
	end process;

end register_file_arch;
