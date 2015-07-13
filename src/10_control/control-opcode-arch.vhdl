library ieee;
	use ieee.std_logic_1164.all;

library work;
	use work.conv.uint;
	use work.microinstr.all;


entity control_opcode is
	generic (
		debug: boolean := false
	);
	port (
		a: in  std_logic_vector(4 downto 0);
		d: out  std_logic_vector(19 downto 0)
	);
end control_opcode;


architecture control_opcode_arch of control_opcode is

	type mem is array(0 to 31) of std_logic_vector(19 downto 0);
	constant op: mem := (
		 0 => MICRO_CMP,
		 1 => MICRO_LI,
		 2 => MICRO_LWI,
		 3 => MICRO_SWI,
		 4 => MICRO_SW,
		 5 => MICRO_ADDI,
		 6 => MICRO_SUBI,
		 7 => MICRO_ANDI,
		 8 => MICRO_ORI,
		 9 => MICRO_XORI,
		10 => MICRO_NANDI,
		11 => MICRO_NORI,
		12 => MICRO_XNORI,
		13 => MICRO_BEQI,
		14 => MICRO_BNEI,
		15 => MICRO_BLTI,
		16 => MICRO_BLETI,
		17 => MICRO_BGTI,
		18 => MICRO_BGETI,
		19 => MICRO_B,
		20 => MICRO_CALL,
		21 => MICRO_RET,
		22 => MICRO_NOP,
		23 => MICRO_LW,
		others => (others => '0')
	);

begin
	process(a)
	begin
		d <= op(uint(a));
		if debug then
		case uint(a) is
		when  0 => report "op:   CMP";
		when  1 => report "op:    LI";
		when  2 => report "op:   LWI";
		when  3 => report "op:   SWI";
		when  4 => report "op:    SW";
		when  5 => report "op:  ADDI";
		when  6 => report "op:  SUBI";
		when  7 => report "op:  ANDI";
		when  8 => report "op:   ORI";
		when  9 => report "op:  XORI";
		when 10 => report "op: NANDI";
		when 11 => report "op:  NORI";
		when 12 => report "op: XNORI";
		when 13 => report "op:  BEQI";
		when 14 => report "op:  BNEI";
		when 15 => report "op:  BLTI";
		when 16 => report "op: BLETI";
		when 17 => report "op:  BGTI";
		when 18 => report "op: BGETI";
		when 19 => report "op:     B";
		when 20 => report "op:  CALL";
		when 21 => report "op:   RET";
		when 22 => report "op:   NOP";
		when 23 => report "op:    LW";
		when others => report "op: UNKOWN";
		end case;
		end if;
	end process;
end control_opcode_arch;
