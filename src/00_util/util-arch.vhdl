--------------------------
-- Clock for testbenchs --
--------------------------

library ieee;
	use ieee.std_logic_1164.all;


entity clock_pulse is
	generic (period: time);
	port (enable: in std_logic; clock: out std_logic);
end clock_pulse;


architecture clock_pulse_arch of clock_pulse is
	signal clk: std_logic := '0';
begin
	clk <=
		not clk after period/2 when enable = '1' else
		'0' when enable = '0';
	clock <= clk;
end clock_pulse_arch;


--------------------------
-- A 2to1 mux ------------
--------------------------

library ieee;
	use ieee.std_logic_1164.all;


entity mux2to1 is
	generic (size: positive);
	port (
		a: in std_logic_vector(size-1 downto 0);
		b: in std_logic_vector(size-1 downto 0);
		s: in std_logic;
		z: out std_logic_vector(size-1 downto 0)
	);
end mux2to1;


architecture mux2to1_arch of mux2to1 is
begin
	process (s, a, b)
	begin
		case s is
		when '0'    => z <= a;
		when others => z <= b;
		end case;
	end process;
end mux2to1_arch;


---------------------
-- Math functions ---
---------------------

package math is

	function log(x: positive; base: positive) return natural;

end;


package body math is


	function log(x: positive; base: positive) return natural is
	begin
		if (base = 1) then
			report "log base 1 is not appropriate" severity error;
		elsif (x = 0) then
			report "log arg 0 is not appropriate" severity error;
		end if;
		if x < base then
			return 0;
		else
			return 1 + log(x/base, base);
		end if;
	end log;


end package body;


---------------------
-- Character types --
---------------------

package ctype is

	type num_base is (bin, oct, dec, hex);
	function max(f: num_base) return natural;

	function isspace(x: character)                     return boolean;
	function  isstdl(x: character)                     return boolean;
	function isdigit(x: character; f: num_base := dec) return boolean;

end;


package body ctype is


	function max(f: num_base) return natural is
	begin
		case f is
		when bin => return  2;
		when oct => return  8;
		when dec => return 10;
		when hex => return 16;
		end case;
	end max;


	function isspace(x: character) return boolean is
	begin
		case x is
		when ' '|HT|LF|VT|FF|CR => return true;
		when others => return false;
		end case;
	end isspace;


	function isstdl(x: character) return boolean is
	begin
		case x is
		when '0'|'1' => return true;
		when 'l'|'h'|'u'|'z'|'w'|'x'|'-' => return true;
		when 'L'|'H'|'U'|'Z'|'W'|'X'|'-' => return true;
		when others => return false;
		end case;
	end isstdl;


	function isdigit(x: character; f: num_base := dec) return boolean is
	begin
		case f is
		when bin =>
			case x is
			when '0'|'1' => return true;
			when others => return false;
			end case;
		when oct =>
			case x is
			when '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7' => return true;
			when others => return false;
			end case;
		when dec =>
			case x is
			when '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7' => return true;
			when '8'|'9' => return true;
			when others => return false;
			end case;
		when hex =>
			case x is
			when '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7' => return true;
			when '8'|'9' => return true;
			when 'a'|'b'|'c'|'d'|'e'|'f' => return true;
			when 'A'|'B'|'C'|'D'|'E'|'F' => return true;
			when others => return false;
			end case;
		end case;
	end isdigit;


end package body;


--
-- Conversion library
--

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

use work.ctype.all;


package conv is

	function    int(x: std_logic_vector)     return integer;
	function    int(x: std_logic)            return integer;
	function   uint(x: std_logic_vector)     return natural;
	function   uint(x: std_logic)            return natural;
	function  stdlv(x: integer; l: positive) return std_logic_vector;
	function ustdlv(x: natural; l: positive) return std_logic_vector;

	function chr2num(x: character; f: num_base := dec; xmap: bit := '0')
		return integer;
	function num2chr(x: integer; f: num_base := dec)
		return character;

	function   int2str(x: integer; f: num_base := dec) return string;
	function  stdl2chr(x: std_logic)                   return character;
	function stdlv2str(x: std_logic_vector)            return string;

	procedure str2int(             -- number can be bin, oct, dec or hex
		nstr: in string;       -- string to be converted
		endstr: out positive;  -- store index of first non-valid char
		num: out integer;      -- store converted number
		xmap: in bit := '0'    -- what to do with U, X, Z, etc
	);

end;


package body conv is


	function int(x: std_logic_vector) return integer is
	begin
		return to_integer(signed(x));
	end int;


	function int(x: std_logic) return integer is
	begin
		return uint("0" & x); -- a bit is unsigned anyway
	end int;


	function uint(x: std_logic_vector) return natural is
	begin
		return to_integer(unsigned(x));
	end uint;


	function uint(x: std_logic) return natural is
	begin
		return uint("0" & x); -- a bit is unsigned anyway
	end uint;


	function stdlv(x: integer; l: positive) return std_logic_vector is
	begin
		return std_logic_vector(to_signed(x, l));
	end stdlv;


	function ustdlv(x: natural; l: positive) return std_logic_vector is
	begin
		return std_logic_vector(to_unsigned(x, l));
	end ustdlv;


	function chr2num(x: character; f: num_base := dec; xmap: bit := '0')
			return integer is
	begin
		if isdigit(x, f) then
			case x is
			when '0' => return 0;
			when '1' => return 1;
			when '2' => return 2;
			when '3' => return 3;
			when '4' => return 4;
			when '5' => return 5;
			when '6' => return 6;
			when '7' => return 7;
			when '8' => return 8;
			when '9' => return 9;
			when 'a'|'A' => return 10;
			when 'b'|'B' => return 11;
			when 'c'|'C' => return 12;
			when 'd'|'D' => return 13;
			when 'e'|'E' => return 14;
			when 'f'|'F' => return 15;
			end case;
		elsif f /= dec then -- L, H, W, etc don't make sense in decimal
			case x is
			when 'l'|'L' => return 0;
			when 'h'|'H' => return max(f) - 1;
			when
				'u'|'z'|'w'|'x'|'-'|
				'U'|'Z'|'W'|'X'|'-' =>
				case xmap is
				when '0' => return 0;
				when '1' => return max(f) - 1;
				end case;
			when others => return -1;
			end case;
		end if;
		return -1;
	end chr2num;


	function num2chr(x: integer; f: num_base := dec) return character is
		variable c: character;
	begin
		case x is
		when 0 => c := '0';
		when 1 => c := '1';
		when 2 =>
			if f = bin then c := '?';
			else c := '2'; end if;
		when 3 =>
			if f = bin then c := '?';
			else c := '3'; end if;
		when 4 =>
			if f = bin then c := '?';
			else c := '4'; end if;
		when 5 =>
			if f = bin then c := '?';
			else c := '5'; end if;
		when 6 =>
			if f = bin then c := '?';
			else c := '6'; end if;
		when 7 =>
			if f = bin then c := '?';
			else c := '7'; end if;
		when 8 =>
			if f = bin or f = oct then c := '?';
			else c := '8'; end if;
		when 9 =>
			if f = bin or f = oct then c := '?';
			else c := '9'; end if;
		when 10 =>
			if f = bin or f = oct or f = dec then c := '?';
			else c := 'a'; end if;
		when 11 =>
			if f = bin or f = oct or f = dec then c := '?';
			else c := 'b'; end if;
		when 12 =>
			if f = bin or f = oct or f = dec then c := '?';
			else c := 'c'; end if;
		when 13 =>
			if f = bin or f = oct or f = dec then c := '?';
			else c := 'd'; end if;
		when 14 =>
			if f = bin or f = oct or f = dec then c := '?';
			else c := 'e'; end if;
		when 15 =>
			if f = bin or f = oct or f = dec then c := '?';
			else c := 'f'; end if;
		when others =>
			c := '?';
		end case;
		return c;
	end num2chr;


	function int2str(x: integer; f: num_base := dec) return string is
		-- recursion to the rescue!!!
		function c(x: integer) return string is
		begin
			if x < max(f) then
				return "" & num2chr(x);
			else
				return c(x/max(f)) & num2chr(x mod max(f), f);
			end if;
		end c;
		variable a: integer;
	begin
		if x < 0 then
			a := -x;
			case f is
			when bin => return "-0b" & c(a);
			when oct => return "-0" & c(a);
			when dec => return "-" & c(a);
			when hex => return "-0x" & c(a);
			end case;
		else
			a := x;
			case f is
			when bin => return "0b" & c(a);
			when oct => return "0" & c(a);
			when dec => return "" & c(a);
			when hex => return "0x" & c(a);
			end case;
		end if;
	end int2str;


	function stdl2chr(x: std_logic) return character is
		variable c: character;
	begin
		case x is
		when '0' => c := '0';
		when '1' => c := '1';
		when 'L' => c := 'L';
		when 'H' => c := 'H';
		when 'U' => c := 'U';
		when 'Z' => c := 'Z';
		when 'W' => c := 'W';
		when 'X' => c := 'X';
		when '-' => c := '-';
		end case;
		return c;
	end stdl2chr;


	function stdlv2str(x: std_logic_vector) return string is
		variable s: string(1 to x'length);
	begin
		for i in x'left downto x'right loop
			s(x'left - i + 1) := stdl2chr(x(i));
		end loop;
		return s;
	end stdlv2str;


	procedure str2int(
			nstr: in string;
			endstr: out positive;
			num: out integer;
			xmap: in bit := '0') is
		variable i: positive := nstr'left;
		variable v: integer := 0;
		variable t: num_base;
		variable b: positive;
		variable s: boolean := false;
	begin
		endstr := i;
		num := 0;
		while i <= nstr'right and isspace(nstr(i)) loop
			i := i + 1;
		end loop;
		if nstr'right < i then
			report "str2int: empty" severity warning;
			return;
		end if;
		-- number must start here
		if nstr(i) = '-' then
			i := i + 1;
			if nstr'right < i then
				report "str2int: empty after '-'"
					severity warning;
				return;
			end if;
			s := true;
		end if;
		if nstr(i) = '0' then
			i := i + 1;
			if nstr'right < i then
				endstr := i;
				num := 0;
				return;
			end if;
			case nstr(i) is
			when 'x'|'X' => t := hex; b := 16;
			when 'b'|'B' => t := bin; b := 2;
			when others => -- oct has only the '0' prefix
				if chr2num(nstr(i), oct, xmap) = -1 then
					endstr := i;
					num := 0;
					return;
				end if;
				i := i - 1;
				t := oct; b := 8;
			end case;
			i := i + 1;
		elsif chr2num(nstr(i), dec, xmap) = -1 then
			report "str2int invalid dec char " &
				"'" & nstr(i) & "'" severity warning;
			return;
		else
			t := dec; b := 10;
		end if;
		if nstr'right < i then
			report "str2int empty after prefix" severity warning;
			return;
		end if;
		-- start conversion
		while
			i <= nstr'right and
			chr2num(nstr(i), t, xmap) /= -1 loop
			v := b*v + chr2num(nstr(i), t, xmap);
			i := i + 1;
		end loop;
		endstr := i;
		if s then num := -v; else num := v; end if;
	end procedure str2int;

end package body;
