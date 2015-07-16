library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;


entity bcd2display7 is
	generic (common_cathode: boolean := true);
	port (
		bcd: in std_logic_vector(3 downto 0);
		display7: out std_logic_vector(6 downto 0)
	);
end bcd2display7;


architecture bcd2display7_arch of bcd2display7 is
begin
	process (bcd)
	begin
		if common_cathode then
			case  bcd is
			when "0000" => display7 <= "1111110"; -- 0
			when "0001" => display7 <= "0110000"; -- 1
			when "0010" => display7 <= "1101101"; -- 2
			when "0011" => display7 <= "1111001"; -- 3
			when "0100" => display7 <= "0110011"; -- 4
			when "0101" => display7 <= "1011011"; -- 5
			when "0110" => display7 <= "1011111"; -- 6
			when "0111" => display7 <= "1110000"; -- 7
			when "1000" => display7 <= "1111111"; -- 8
			when "1001" => display7 <= "1110011"; -- 9
			when others => display7 <= "0000001"; -- -
			end case;
		else
			case  bcd is
			when "0000" => display7 <= not "1111110"; -- 0
			when "0001" => display7 <= not "0110000"; -- 1
			when "0010" => display7 <= not "1101101"; -- 2
			when "0011" => display7 <= not "1111001"; -- 3
			when "0100" => display7 <= not "0110011"; -- 4
			when "0101" => display7 <= not "1011011"; -- 5
			when "0110" => display7 <= not "1011111"; -- 6
			when "0111" => display7 <= not "1110000"; -- 7
			when "1000" => display7 <= not "1111111"; -- 8
			when "1001" => display7 <= not "1110011"; -- 9
			when others => display7 <= not "0000001"; -- -
			end case;
		end if;
	end process;
end bcd2display7_arch;
