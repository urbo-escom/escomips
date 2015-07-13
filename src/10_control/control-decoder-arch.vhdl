--
-- branch xxxxxx
--        ||||||
--  beq --|||||+
-- bneq --||||+
--  blt --|||+
--  ble --||+
--  bgt --|+
-- bget --+
--

library ieee;
	use ieee.std_logic_1164.all;

library work;
	use work.microinstr.all;


entity control_decoder is
	port (
		a: in  std_logic_vector (4 downto 0);
		reg: out std_logic;
		branch: out std_logic_vector(5 downto 0)
	);
end control_decoder;


architecture control_decoder_arch of control_decoder is
	signal t: std_logic_vector(6 downto 0);
begin

	reg <= t(6);
	branch <= t(5 downto 0);

	process(a)
	begin
		case a is
		when "00000" => t <= "1000000";
		when "01101" => t <= "0000001"; report "beqi";
		when "01110" => t <= "0000010"; report "bneq";
		when "01111" => t <= "0000100"; report "blti";
		when "10000" => t <= "0001000"; report "bleti";
		when "10001" => t <= "0010000"; report "bgti";
		when "10010" => t <= "0100000"; report "bgeti";
		when others  => t <= "0000000";
		end case;
	end process;

end control_decoder_arch;
