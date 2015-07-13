library ieee;
	use ieee.std_logic_1164.all;


entity control_flags is
	port (
		clk: in  std_logic;
		clr: in  std_logic;
		lf: in  std_logic;
		flags_in: in  std_logic_vector (3 downto 0);
		flags_out: out  std_logic_vector (3 downto 0)
	);
end control_flags;


architecture control_flags_arch of control_flags is
begin
	process(clr, clk)
	begin
		if (falling_edge(clk)) then
			if (clr = '1') then
				flags_out <= "0000";
			elsif (lf = '1') then
				flags_out <= flags_in;
			end if;
		end if;
	end process;

end control_flags_arch;
