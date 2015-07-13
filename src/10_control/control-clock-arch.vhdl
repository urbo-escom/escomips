library ieee;
	use ieee.std_logic_1164.all;


entity control_clock is
	port (
		clk: in  std_logic;
		clr: in  std_logic;
		hl: out  std_logic
	);
end control_clock;


architecture control_clock_arch of control_clock is
	signal pclk, nclk: std_logic;
begin

	hl <= pclk xor nclk;

	process(clk, clr)
	begin
		if (clr = '1') then
			pclk <= '0';
		elsif (rising_edge(clk)) then
			pclk <= not pclk;
		end if;
	end process;

	process(clk, clr)
	begin
		if (clr = '1') then
			nclk <= '0';
		elsif (falling_edge(clk)) then
			nclk <= not nclk;
		end if;
	end process;

end control_clock_arch;
