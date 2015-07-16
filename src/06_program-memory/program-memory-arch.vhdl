library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.types.all;
	use work.math.log;
	use work.conv.uint;


entity program_memory is
	generic (
		program_size: positive := 256;
		program: slv25_arr_t(0 to 255) := (
		0 => "00001" & "0000" & "0000" & "0000" & "0000" & "0101",
		1 => "00001" & "0001" & "0000" & "0000" & "0000" & "1010",
		2 => "00000" & "0001" & "0001" & "0000" & "XXXX" & "0000",
		3 => "00011" & "0001" & "0000" & "0000" & "0000" & "0101",
		4 => "10011" & "XXXX" & "0000" & "0000" & "0000" & "0010",
		5 => "11111" & "1111" & "1111" & "1111" & "1111" & "1111",
		others => (others => '1')
		)
	);
	port (
		a: in std_logic_vector(log(program_size, 2)-1 downto 0);
		d: out std_logic_vector(24 downto 0)
	);
end entity program_memory;


architecture program_memory_arch of program_memory is
	constant rom: slv25_arr_t(0 to program_size-1) := program;
begin
	assert program_size = program'length
		report "program_size doesn't size of program, " &
		natural'image(program_size) & " /= " &
		natural'image(program'length);
	d <= rom(uint(a));
end architecture program_memory_arch;
