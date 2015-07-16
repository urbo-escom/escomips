library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.conv.uint;
	use work.math.log;


entity program is
	generic (
		size: natural
	);
	port (
		a: in std_logic_vector(log(size, 2)-1 downto 0);
		d: out std_logic_vector(25-1 downto 0)
	);
end program;


architecture program_arch of program is
	type mem is array (0 to size-1) of std_logic_vector(d'range);
	constant rom: mem := (
		0 => "00001" & "0000" & "0000" & "0000" & "0000" & "0001",
		1 => "00001" & "0001" & "0000" & "0000" & "0000" & "0111",
		2 => "00000" & "0001" & "0001" & "0000" & "0000" & "0000",
		3 => "00011" & "0001" & "0000" & "0000" & "0000" & "0101",
		4 => "10011" & "0000" & "0000" & "0000" & "0000" & "0010",
		others => (others => '0')
	);
begin
	d <= rom(uint(a));
end architecture program_arch;
