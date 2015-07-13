library ieee;
	use ieee.std_logic_1164.all;

library work;
	use work.conv.stdlv2str;
	use work.conv.ustdlv;


package microinstr is

	-- instr
	subtype instr is std_logic_vector(4 downto 0);
	constant INSTR_ADD:   instr := ustdlv( 0, instr'length);
	constant INSTR_SUB:   instr := ustdlv( 0, instr'length);
	constant INSTR_AND:   instr := ustdlv( 0, instr'length);
	constant INSTR_OR:    instr := ustdlv( 0, instr'length);
	constant INSTR_XOR:   instr := ustdlv( 0, instr'length);
	constant INSTR_NAND:  instr := ustdlv( 0, instr'length);
	constant INSTR_NOR:   instr := ustdlv( 0, instr'length);
	constant INSTR_XNOR:  instr := ustdlv( 0, instr'length);
	constant INSTR_NOT:   instr := ustdlv( 0, instr'length);
	constant INSTR_CMP:   instr := ustdlv( 0, instr'length);
	constant INSTR_LI:    instr := ustdlv( 1, instr'length);
	constant INSTR_LWI:   instr := ustdlv( 2, instr'length);
	constant INSTR_SWI:   instr := ustdlv( 3, instr'length);
	constant INSTR_SW:    instr := ustdlv( 4, instr'length);
	constant INSTR_ADDI:  instr := ustdlv( 5, instr'length);
	constant INSTR_SUBI:  instr := ustdlv( 6, instr'length);
	constant INSTR_ANDI:  instr := ustdlv( 7, instr'length);
	constant INSTR_ORI:   instr := ustdlv( 8, instr'length);
	constant INSTR_XORI:  instr := ustdlv( 9, instr'length);
	constant INSTR_NANDI: instr := ustdlv(10, instr'length);
	constant INSTR_NORI:  instr := ustdlv(11, instr'length);
	constant INSTR_XNORI: instr := ustdlv(12, instr'length);
	constant INSTR_BEQI:  instr := ustdlv(13, instr'length);
	constant INSTR_BNEI:  instr := ustdlv(14, instr'length);
	constant INSTR_BLTI:  instr := ustdlv(15, instr'length);
	constant INSTR_BLETI: instr := ustdlv(16, instr'length);
	constant INSTR_BGTI:  instr := ustdlv(17, instr'length);
	constant INSTR_BGETI: instr := ustdlv(18, instr'length);
	constant INSTR_B:     instr := ustdlv(19, instr'length);
	constant INSTR_CALL:  instr := ustdlv(20, instr'length);
	constant INSTR_RET:   instr := ustdlv(21, instr'length);
	constant INSTR_NOP:   instr := ustdlv(22, instr'length);
	constant INSTR_LW:    instr := ustdlv(23, instr'length);

	--
	-- <up dw wpc> sdmp       *>-----+
	-- sr2 swd <she dir wr>   *>-----|--------+
	-- sext sop1 sop2 <aluop> *>-----|--------|---------+
	-- sdmd <wd> sr | lf      *>-----|--------|---------|-----------+
	--                               |_       |__       |____       |_
	--                              /  \     /   \     /     \     /  \
	--                             "0000" & "00000" & "0000000" & "0000";
	constant MICRO_UP:       natural := 19;
	constant MICRO_DW:       natural := 18;
	constant MICRO_WPC:      natural := 17;
	constant MICRO_MUX_SDMP: natural := 16;
	constant MICRO_MUX_SR2:  natural := 15;
	constant MICRO_MUX_SWD:  natural := 14;
	constant MICRO_SHE:      natural := 13;
	constant MICRO_DIR:      natural := 12;
	constant MICRO_WR:       natural := 11;
	constant MICRO_MUX_SEXT: natural := 10;
	constant MICRO_MUX_SOP1: natural :=  9;
	constant MICRO_MUX_SOP2: natural :=  8;
	constant MICRO_ALUOP_UP: natural :=  7;
	constant MICRO_ALUOP_DW: natural :=  4;
	constant MICRO_MUX_SDMD: natural :=  3;
	constant MICRO_WD:       natural :=  2;
	constant MICRO_MUX_SR:   natural :=  1;
	constant MICRO_LF:       natural :=  0;

	subtype micro is std_logic_vector(19 downto 0);

	function micro2str(x: micro) return string is
		function m2s(x: micro; m: natural) return string is
		begin
			if x(m) = '0' then
				return "";
			else
				case m is
				when MICRO_UP       => return "UP ";
				when MICRO_DW       => return "DW ";
				when MICRO_WPC      => return "WPC ";
				when MICRO_MUX_SDMP => return "MUX_SDMP ";
				when MICRO_MUX_SR2  => return "MUX_SR2 ";
				when MICRO_MUX_SWD  => return "MUX_SWD ";
				when MICRO_SHE      => return "SHE ";
				when MICRO_DIR      => return "DIR ";
				when MICRO_WR       => return "WR ";
				when MICRO_MUX_SEXT => return "MUX_SEXT ";
				when MICRO_MUX_SOP1 => return "MUX_SOP1 ";
				when MICRO_MUX_SOP2 => return "MUX_SOP2 ";
				when MICRO_MUX_SDMD => return "MUX_SDMD ";
				when MICRO_WD       => return "WD ";
				when MICRO_MUX_SR   => return "MUX_SR ";
				when MICRO_LF       => return "LF ";
				when others => return "";
				end case;
			end if;
		end m2s;
	begin
		return "" &
		m2s(x, MICRO_UP      ) &
		m2s(x, MICRO_DW      ) &
		m2s(x, MICRO_WPC     ) &
		m2s(x, MICRO_MUX_SDMP) &
		m2s(x, MICRO_MUX_SR2 ) &
		m2s(x, MICRO_MUX_SWD ) &
		m2s(x, MICRO_SHE     ) &
		m2s(x, MICRO_DIR     ) &
		m2s(x, MICRO_WR      ) &
		m2s(x, MICRO_MUX_SEXT) &
		m2s(x, MICRO_MUX_SOP1) &
		m2s(x, MICRO_MUX_SOP2) &
		"ALUOP(" & stdlv2str(x(
			MICRO_ALUOP_UP
			downto
			MICRO_ALUOP_DW)) & ") " &
		m2s(x, MICRO_MUX_SDMD) &
		m2s(x, MICRO_WD      ) &
		m2s(x, MICRO_MUX_SR  ) &
		m2s(x, MICRO_LF      ) &
		"";
	end micro2str;

	-- <up dw wpc> sdmp       *>-----+
	-- sr2 swd <she dir wr>   *>-----|--------+
	-- sext sop1 sop2 <aluop> *>-----|--------|---------+
	-- sdmd <wd> sr | lf      *>-----|--------|---------|-----------+
	--                               |_       |__       |____       |_
	--                              /  \     /   \     /     \     /  \
	constant MICRO_ADD:   micro := "0000" & "01001" & "0000011" & "0011";
	constant MICRO_SUB:   micro := "0000" & "01001" & "0000111" & "0011";
	constant MICRO_AND:   micro := "0000" & "01001" & "0000000" & "0011";
	constant MICRO_OR:    micro := "0000" & "01001" & "0000001" & "0011";
	constant MICRO_XOR:   micro := "0000" & "01001" & "0000010" & "0011";
	constant MICRO_NAND:  micro := "0000" & "01001" & "0001101" & "0011";
	constant MICRO_NOR:   micro := "0000" & "01001" & "0001100" & "0011";
	constant MICRO_XNOR:  micro := "0000" & "01001" & "0001010" & "0011";
	constant MICRO_NOT:   micro := "0000" & "01001" & "0001101" & "0011";
	constant MICRO_SLL:   micro := "0000" & "00111" & "0000000" & "0000";
	constant MICRO_SRL:   micro := "0000" & "00101" & "0000000" & "0000";
	--                              \ _/     \ __/     \ ____/     \ _/
	--                               |        |         |           |
	-- sdmd <wd> sr | lf      *>-----|--------|---------|-----------+
	-- sext sop1 sop2 <aluop> *>-----|--------|---------+
	-- sr2 swd <she dir wr>   *>-----|--------+
	-- <up dw wpc> sdmp       *>-----+

	-- <up dw wpc> sdmp       *>-----+
	-- sr2 swd <she dir wr>   *>-----|--------+
	-- sext sop1 sop2 <aluop> *>-----|--------|---------+
	-- sdmd <wd> sr | lf      *>-----|--------|---------|-----------+
	--                               |_       |__       |____       |_
	--                              /  \     /   \     /     \     /  \
	constant MICRO_CMP:   micro := "0000" & "10000" & "0000111" & "0001";
	constant MICRO_LI:    micro := "0000" & "00001" & "0000000" & "0000";
	constant MICRO_LWI:   micro := "0000" & "01001" & "0000000" & "1000";
	constant MICRO_SWI:   micro := "0000" & "10000" & "0000000" & "1100";
	constant MICRO_SW:    micro := "0000" & "10000" & "1010011" & "0100";
	constant MICRO_ADDI:  micro := "0000" & "01001" & "1010011" & "0011";
	constant MICRO_SUBI:  micro := "0000" & "01001" & "1010111" & "0011";
	constant MICRO_ANDI:  micro := "0000" & "01001" & "1010000" & "0011";
	constant MICRO_ORI:   micro := "0000" & "01001" & "1010001" & "0011";
	constant MICRO_XORI:  micro := "0000" & "01001" & "1010010" & "0011";
	constant MICRO_NANDI: micro := "0000" & "01001" & "1011101" & "0011";
	constant MICRO_NORI:  micro := "0000" & "01001" & "1011100" & "0011";
	constant MICRO_XNORI: micro := "0000" & "01001" & "1011010" & "0011";
	constant MICRO_BEQI:  micro := "0011" & "00000" & "1110011" & "0010";
	constant MICRO_BNEI:  micro := "0011" & "00000" & "1110011" & "0010";
	constant MICRO_BLTI:  micro := "0011" & "00000" & "1110011" & "0010";
	constant MICRO_BLETI: micro := "0011" & "00000" & "1110011" & "0010";
	constant MICRO_BGTI:  micro := "0011" & "00000" & "1110011" & "0010";
	constant MICRO_BGETI: micro := "0011" & "00000" & "1110011" & "0010";
	constant MICRO_B:     micro := "0010" & "00000" & "0000000" & "0000";
	constant MICRO_CALL:  micro := "1010" & "00000" & "0000000" & "0000";
	constant MICRO_RET:   micro := "0100" & "00000" & "0000000" & "0000";
	constant MICRO_NOP:   micro := "0000" & "00000" & "0000000" & "0000";
	constant MICRO_LW:    micro := "0000" & "01001" & "1010011" & "0000";
	--                              \ _/     \ __/     \ ____/     \ _/
	--                               |        |         |           |
	-- sdmd <wd> sr | lf      *>-----|--------|---------|-----------+
	-- sext sop1 sop2 <aluop> *>-----|--------|---------+
	-- sr2 swd <she dir wr>   *>-----|--------+
	-- <up dw wpc> sdmp       *>-----+

end;
