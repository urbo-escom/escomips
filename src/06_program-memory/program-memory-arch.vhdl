library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.math.log;
	use work.conv.uint;


entity program_memory is
	generic (
		program_size: positive := 4096;
		data_width: positive := 25
	);
	port (
		clk: in std_logic;
		a: in std_logic_vector(log(program_size, 2)-1 downto 0);
		d: out std_logic_vector(data_width-1 downto 0)
	);
end entity program_memory;


architecture program_memory_arch of program_memory is
	type mem is array (0 to program_size-1) of std_logic_vector(d'range);
	constant rom: mem := (
		0 => "00001" & "0000" & "0000" & "0000" & "0000" & "0101",
		1 => "00001" & "0001" & "0000" & "0000" & "0000" & "1010",
		2 => "00000" & "0001" & "0001" & "0000" & "XXXX" & "0000",
		3 => "00011" & "0001" & "0000" & "0000" & "0000" & "0101",
		4 => "10011" & "XXXX" & "0000" & "0000" & "0000" & "0010",
		5 => "11111" & "1111" & "1111" & "1111" & "1111" & "1111",
		4095 =>
			"00000" & "0000" & "0000" & "0000" & "0000" & "0000",
		others => (others => '1')
	);
begin
	process (clk)
	begin
		if (rising_edge(clk)) then
			d <= rom(uint(a));
		end if;
	end process;
end architecture program_memory_arch;
