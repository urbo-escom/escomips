library ieee;
	use ieee.std_logic_1164.all;


entity control_asm is
	generic (
		debug: boolean := false
	);
	port (
		hl: in std_logic;
		reg: in std_logic;
		branch: in std_logic_vector(5 downto 0);
		cond: in std_logic_vector(5 downto 0);
		sdopc: out  std_logic;
		sm: out  std_logic
	);
end control_asm;


architecture control_asm_arch of control_asm is
	constant zero:    std_logic_vector := "01";
	constant funcode: std_logic_vector := "00";
	constant opcode:  std_logic_vector := "11";
	signal t: std_logic_vector(1 downto 0);
	signal j: std_logic_vector(5 downto 0);
begin

	sdopc <= t(1);
	sm <= t(0);
	j <= branch and cond;

	process(hl, reg, branch, cond, j)
	begin

		if (reg = '1') then
			t <= funcode;

		-- A zig zag, if not from here
		elsif (branch = "000000") then
			if debug then report "Normal instruction..."; end if;
			t <= opcode;

		-- search there
		elsif (hl = '1') then
			if debug then report "Branch comparing..."; end if;
			t <= zero;

		-- but really search there
		elsif (j = "000000") then
			if debug then report "Branch false"; end if;
			t <= zero;

		-- and if not there just return here
		else
			if debug then report "Branch true!"; end if;
			t <= opcode;

		end if;
	end process;

end control_asm_arch;
