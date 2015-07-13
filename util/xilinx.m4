m4_divert(-1)
#############################
# Use m4 with the -P switch #
#############################


m4_define(`MAP',
`m4_ifelse(
	`$#', `2', `$1($2)',
	`$1($2)'`,'`$0(`$1', m4_shift(m4_shift($@)))'m4_dnl
)'m4_dnl
)


m4_define(`FOLD_R',
`m4_ifelse(
	`$#', `3', `$1($2, $3)',
	`$1($2, $0($1, m4_shift(m4_shift($@))))'m4_dnl
)'m4_dnl
)


m4_define(`FOLD_L',
`m4_ifelse(
	`$#', `3', `$1($2, $3)',
	`$0($1, $1($2, $3), m4_shift(m4_shift(m4_shift($@))))'m4_dnl
)'m4_dnl
)


m4_define(`LINE',
`m4_ifelse(
	`$1', `',,
	`$1
$0(m4_shift($@))'m4_dnl
)'m4_dnl
)


m4_divert(0)m4_dnl
m4_dnl
m4_dnl Project file generation
m4_dnl
m4_define(`PRJ_VHDL', `vhdl work $1')m4_dnl
m4_ifdef(`PRJ', `LINE(MAP(`PRJ_VHDL', VHDL))')m4_dnl
m4_dnl
m4_dnl TCL batch generation
m4_dnl
m4_ifdef(`TCL', `onerror {resume}
wave add -radix hex /
wave add -radix dec /
run all;
quit
')m4_dnl
m4_dnl
m4_dnl LSO generation
m4_dnl
m4_ifdef(`LSO', `work
')m4_dnl
m4_dnl
m4_dnl XST generation
m4_dnl
m4_dnl set -tmpdir    syn.xst.d/projnav
m4_dnl set -xsthdpdir syn.xst.d
m4_ifdef(`XST', `
run
-ifn syn.prj
-ifmt mixed
-top ENTITY
-ofn syn.ngc
-ofmt ngc
-rtlview Yes
-p DEVICE
-opt_mode Speed
-opt_level 1
-fsm_style LUT
-bus_delimiter []
')m4_dnl
