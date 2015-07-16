library ieee;
	use ieee.std_logic_1164.all;


entity popcount_asm is
	port (
		clk: in std_logic;
		clr: in std_logic;
		init: in std_logic;
		a0: in std_logic;
		zero: in std_logic;

		count_ld: out std_logic;
		count_en: out std_logic;
		reg_ld: out std_logic;
		reg_en: out std_logic;
		dec_en: out std_logic
	);
end popcount_asm;


architecture popcount_asm_arch of popcount_asm is
	type state is (
		wait_init,
		process_input,
		show_count
	);
	signal this_s, next_s: state;
	signal count: std_logic_vector(1 downto 0);
	signal reg: std_logic_vector(1 downto 0);
	signal dec: std_logic;
begin

	count_ld <= count(1);
	count_en <= count(0);
	reg_ld <= reg(1);
	reg_en <= reg(0);
	dec_en <= dec;

	process (clk, clr)
	begin
		if (clr = '1') then
			this_s <= wait_init;
		elsif (rising_edge(clk)) then
			this_s <= next_s;
		end if;
	end process;


	process (init, a0, zero, this_s)
	begin
		case this_s is

		when wait_init =>
			dec <= '0';
			count <= "10";
			if (init = '1') then
				next_s <= process_input;
			else
				next_s <= wait_init;
				reg <= "10";
			end if;

		when process_input =>
			dec <= '0';
			reg <= "01";
			if (zero = '1') then
				next_s <= show_count;
				count <= "00";
			else
				next_s <= process_input;
				if (a0 = '1') then
					count <= "01";
				else
					count <= "00";
				end if;
			end if;

		when show_count =>
			dec <= '1';
			if (init = '0') then
				next_s <= wait_init;
			else
				next_s <= show_count;
			end if;
		end case;

	end process;

end popcount_asm_arch;
