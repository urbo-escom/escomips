#
# <FILE>  : User generated file
# |FILE|  : Automatically generated file
# |FILE|- : Automatically generated file, intermediate file
# |FILE|* : Automatically generated file, final file
#
# The commands here  presented may not reflect the real  commands used by this
# Makefile, they are placed here just to give an idea of the workflow.
#


#
# ****************************************************************************
# ****************************  VHDL SIMULATION  *****************************
# ****************************************************************************
#
#                               M4 Magic VHDL SIM_PRJ
#           <VHDL> >--> ------------------------------------> |SIM_PRJ|-
#
#                         fuse -prj SIM_PRJ ENT -o SIM_EXE    |FUSE_LOG|*
#        |SIM_PRJ| >--> ------------------------------------> |SIM_EXE|-
#
#                                  M4 Magic SIM_TCL
#           <VHDL> >--> ------------------------------------> |SIM_TCL|-
#
#        |SIM_TCL| >-\   SIM_EXE -tclbatch SIM_TCL -WDB wdb   |ISIM_LOG|*
#        |SIM_EXE| >--> ------------------------------------> |TEST|* |WDB|-
#


#
# ****************************************************************************
# ****************************  VHDL SYNTHESIS  ******************************
# ****************************************************************************
#
#                               M4 Magic VHDL SYN_PRJ
#           <VHDL> >--> ------------------------------------> |SYN_PRJ|-
#
#                                   M4 Magic XST
#        |SYN_PRJ| >--> ------------------------------------> |XST|-
#
#                                   xst -ifn XST              |NGR|* |SRP|*
#            |XST| >--> ------------------------------------> |NGC|-
#
#            <UCF> >-\     ngdbuild -p DEVICE -uc UCF NGC     |BLD|*
#            |NGC| >--> ------------------------------------> |NGD|-
#
#                             map -w -detail -pr b NGD        |MAP|* |MRP|*
#            |NGD| >--> ------------------------------------> |PCF|- |NCD|-
#
#            |PCF| >-\        par -w NCD NCD_ROUTED PCF       |PAR_ROUTED|*
#            |NCD| >--> ------------------------------------> |NCD_ROUTED|-
#
#            |PCF| >-\      bitgen -w NCD_ROUTED BIT PCF      |BGN|*
#     |NCD_ROUTED| >--> ------------------------------------> |BIT|*
#


#
# ****************************************************************************
# ****************************  VHDL DOC  ************************************
# ****************************************************************************
#
#                                   wdb2png script
#            |WDB| >--> ------------------------------------> |SIM_PNG|*
#
#                                   ngr2png script            |PIN_PNG|*
#            |NGR| >--> ------------------------------------> |SCH_PNG|*
#
#           |TEST|                  M4 Magic HTML
#           <VHDL> >--> ------------------------------------> |HTML|*
#        |SIM_PNG|
#        |PIN_PNG|
#        |SCH_PNG|
#       |FUSE_LOG|
#       |ISIM_LOG|
#            |SRP|
#            |BLD|
#            |MAP|
#            |MRP|
#     |PAR_ROUTED|
#            |BGN|
#


.DELETE_ON_ERROR:
.SECONDEXPANSION:
.SUFFIXES:


default_device := xc7a100t-1-csg324
nexys3_device  := xc6slx16-3-csg324
nexys4_device  := xc7a100t-1-csg324


###################################
####### XILINX OPTS ###############
###################################

PNG_RESOLUTION ?= 3200x2400x24

FUSE := fuse
XST  := xst
NGD  := ngdbuild
MAP  := map
PAR  := par
BIT  := bitgen

override FUSE_OPT += -incremental
override FUSE_OPT += -timeprecision_vhdl 1ns
override MAP_OPT  +=
override PAR_OPT  +=

ifdef TRACK_TIME
FUSE := time fuse
XST  := time xst
NGD  := time ngdbuild
MAP  := time map
PAR  := time par
BIT  := time bitgen
endif


units :=
blacklist_sim :=
blacklist_syn :=


###################################
####### Utilities #################
###################################

u := util
$u-dep +=
units += $u
blacklist_syn += $u


###################################
####### 3. ALU ####################
###################################

u := alu
$u-dep += util
units += $u


###################################
####### 4. Register File ##########
###################################

u := register-file
$u-dep += util
units += $u


###################################
####### 5. Data Memory ############
###################################

u := data-memory
$u-dep += util
units += $u


###################################
####### 6. Program Memory #########
###################################

u := program-memory
$u-dep += util
units += $u


###################################
####### 7. Stack ##################
###################################

u := stack
$u-dep += util
units += $u


###################################
####### 8. Popcount ###############
###################################

u := bcd2display7
$u-dep += util
units += $u

u := shift-register
$u-dep += util
units += $u

u := counter
$u-dep += util
units += $u

u := popcount-asm
$u-dep += util
units += $u

u := popcount
$u-dep  += popcount-asm
$u-dep  += bcd2display7
$u-dep  += shift-register
$u-dep  += counter
$u-dep  += util
units += $u


###################################
####### 9. Microinstr #############
###################################

u := microinstr
$u-dep += util
units += $u
blacklist_syn += $u


###################################
####### 10. Control ###############
###################################

u := control
$u-dep += util
$u-dep += microinstr
$u-dep += control-asm
$u-dep += control-clock
$u-dep += control-cond
$u-dep += control-decoder
$u-dep += control-funcode
$u-dep += control-opcode
$u-dep += control-flags
units += $u


###################################
####### 11. ESCOMIPS ##############
###################################

u := escomips
$u-dep += util
$u-dep += alu            ${alu-dep}
$u-dep += register-file  ${register-file-dep}
$u-dep += data-memory    ${data-memory-dep}
$u-dep += program-memory ${program-memory-dep}
$u-dep += stack          ${stack-dep}
$u-dep += control        ${control-dep}
units += $u

u := escomips-program00
$u-dep += util
$u-dep += escomips ${escomips-dep}
units += $u


###################################
####### LIST ALL ##################
###################################

.DEFAULT_GOAL := all
all:
	@\
	$(call echo, Run make list-sim to list all the simulation targets) && \
	$(call echo, Run make list-rtl to list all the schematic targets) && \
	$(call echo, Run make list-syn to list all the synthesis targets) && \
	$(call echo, Run make list-doc to list all the html doc targets) && \
	$(call echo, Run make list-clean to list all the clean targets) && \
	$(call echo, Run make all-sim to run all the simulations) && \
	$(call echo, Run make all-rtl to run all the schematics) && \
	$(call echo, Run make all-syn to run all the synthesis) && \
	$(call echo, Run make all-doc to run all the html docs)

list-sim: ; @$(foreach l, $(sort ${LIST_SIM}), $(call echo, $l) &&) $(call true)
list-rtl: ; @$(foreach l, $(sort ${LIST_RTL}), $(call echo, $l) &&) $(call true)
list-syn: ; @$(foreach l, $(sort ${LIST_SYN}), $(call echo, $l) &&) $(call true)
list-doc: ; @$(foreach l, $(sort ${LIST_DOC}), $(call echo, $l) &&) $(call true)


vhdl_src  = $(foreach a, $1, $(filter %${a}, ${src}))
src      := $(foreach d, $(wildcard src/*), $(wildcard $d/*.vhdl))
src      += $(foreach d, $(wildcard src/*), $(wildcard $d/*.txt))
src      += $(foreach d, $(wildcard src/*), $(wildcard $d/*.ucf))


# Simulation
.PHONY: all-sim
.PHONY: all-clean
define VHDL_SIM

$(eval p := $(patsubst %/,%, $(dir $(call vhdl_src, $u-arch.vhdl))))
$(eval d := $p/_xilinx-$u.d)

$(eval LIST_SIM   += sim/$u)
$(eval LIST_CLEAN += clean/all/$u)
$(eval all-sim:   sim/$u)
$(eval all-clean: clean/all/$u)
$(eval .PHONY: sim/$u)
$(eval sim/$u: $p/$u-test-out.txt)
$(eval .PHONY: clean/sim/$u)
$(eval clean/sim/$u:: ; $$(call rmdir, $d/)             || $$(call true))
$(eval clean/sim/$u:: ; $$(call rm, $p/$u-test-out.txt) || $$(call true))
$(eval clean/sim/$u:: ; $$(call rm, $p/$u-test.png)     || $$(call true))
$(eval .PHONY: clean/all/$u)
$(eval clean/all/$u: clean/sim/$u)

$(eval $p/$u-test-out.txt: $d/sim.wdb)
$(eval $p/$u-test.png: $d/sim.wdb)
$(eval $p/$u-test.png: ; $$(call wdb2png, $$<, $$@))
$(eval $d/sim.wdb: $p/$u-test-in.txt)
$(eval $d/sim.exe: | $d/)
$(eval $d/sim.exe: entity  := $(subst -,_,$u-test))
$(eval $d/sim.exe: override GENERIC +=  test_in=../../../$p/$u-test-in.txt)
$(eval $d/sim.exe: override GENERIC += test_out=../../../$p/$u-test-out.txt)
$(eval $d/sim.prj: | $d/)
$(eval $d/sim.tcl: | $d/)
$(eval $u-src += $(call vhdl_src, $(addsuffix -arch.vhdl, $u)))
$(eval $u-src += $(call vhdl_src, $(addsuffix -test.vhdl, $u)))
$(eval $u-src += $(call vhdl_src, $(addsuffix -arch.vhdl, ${$u-dep})))
$(eval $d/sim.prj: ${$u-src})

endef


# Schematic
.PHONY: all-rtl
define VHDL_RTL

$(eval p := $(patsubst %/,%, $(dir $(call vhdl_src, $u-arch.vhdl))))
$(eval n := ${dev_name})
$(eval d := $p/_xilinx-$u.d/$n)
$(eval $d/: | $p/_xilinx-$u.d/)

$(eval LIST_RTL   += rtl/$u-$n)
$(eval LIST_CLEAN += clean/rtl/$u-$n)
$(eval all-rtl: rtl/$u-$n)
$(eval .PHONY: rtl/$u-$n)
$(eval rtl/$u-$n: $p/$u-$n-pinout.png)
$(eval rtl/$u-$n: $p/$u-$n-schema.png)
$(eval .PHONY: clean/rtl/$u-$n)
$(eval clean/rtl/$u-$n:: ; $$(call rmdir, $d/)       || $$(call true))
$(eval clean/rtl/$u-$n:: ; $$(call rm, $p/$u-$n-pinout.png) || $$(call true))
$(eval clean/rtl/$u-$n:: ; $$(call rm, $p/$u-$n-schema.png) || $$(call true))
$(eval clean/all/$u: clean/rtl/$u-$n)

$(eval $p/$u-$n-pinout.png: $d/syn.snt ; $$(call touch, $$@))
$(eval $p/$u-$n-schema.png: $d/syn.snt ; $$(call touch, $$@))
$(eval $d/syn.snt: | $d/)
$(eval $d/syn.snt: $d/syn.ngr)
$(eval $d/syn.snt: ; \
	$$(call ngr2png, $$<, $p/$u-$n-pinout.png, $p/$u-$n-schema.png) && \
	$$(call touch, $$@))
$(eval $d/syn.xst: | $d/)
$(eval $d/syn.xst: entity := $(subst -,_,${u}))
$(eval $d/syn.xst: device := ${$n_device})
$(eval $d/syn.xst: $d/syn.prj)
$(eval $d/syn.prj: | $d/)
$(eval $d/syn.prj: $(call vhdl_src, $(addsuffix -arch.vhdl, $u)))
$(eval $d/syn.prj: $(call vhdl_src, $(addsuffix -arch.vhdl, ${$u-dep})))

endef


# Synthesis
.PHONY: all-syn
define VHDL_BIT

$(eval p := $(patsubst %/,%, $(dir $(call vhdl_src, $u-arch.vhdl))))
$(eval n := ${dev_name})
$(eval d := $p/_xilinx-$u.d/$n)
$(eval $d/: | $p/_xilinx-$u.d/)

$(eval LIST_SYN   += syn/$u-$n)
$(eval LIST_CLEAN += clean/syn/$u-$n)
$(eval all-syn: syn/$u-$n)
$(eval .PHONY: syn/$u-$n)
$(eval syn/$u-$n: $p/$u-$n.bit)
$(eval .PHONY: clean/syn/$u-$n)
$(eval clean/syn/$u-$n:: ; $$(call rmdir, $d/)       || $$(call true))
$(eval clean/syn/$u-$n:: ; $$(call rm, $p/$u-$n.bit) || $$(call true))
$(eval clean/all/$u: clean/syn/$u-$n)

$(eval $p/$u-$n.bit: $d/syn.bit ; $$(call cp, $$<, $$@))
$(eval $d/syn.ngd: device := ${$n_device})
$(eval $d/syn.bld: device := ${$n_device})
$(eval $d/syn.ucf: | $d/)
$(eval $d/syn.ucf: ${ucf})
$(eval $d/syn.ucf: ; $$(call cp, $$<, $$@))

endef


# HTML generation
.PHONY: all-doc
define VHDL_DOC

$(eval p := $(patsubst %/,%, $(dir $(call vhdl_src, $u-arch.vhdl))))
$(eval n := ${dev_name})
$(eval d := $p/_xilinx-$u.d)

$(eval LIST_DOC   += html/$u-$n)
$(eval LIST_CLEAN += clean/html/$u-$n)
$(eval all-doc: html/$u-$n)
$(eval .PHONY: html/$u-$n)
$(eval html/$u-$n: $p/$u-$n.html)
$(eval clean/html/$u-$n:: ; $$(call rm, $p/$u-$n.html) || $$(call true))
$(eval clean/html/$u-$n:: ; $$(call rm, $p/prism.css) || $$(call true))
$(eval clean/html/$u-$n:: ; $$(call rm, $p/prism.js) || $$(call true))
$(eval clean/all/$u: clean/html/$u-$n)

$(eval $p/$u-$n.html: sim/$u rtl/$u-$n syn/$u-$n)

$(eval $p/$u-$n.html: ${$u-src})
$(eval $p/$u-$n.html: $p/$u-test-in.txt)
$(eval $p/$u-$n.html: $p/$u-test-out.txt)
$(eval $p/$u-$n.html: $p/$u-test.png)
$(eval $p/$u-$n.html: $p/$u-$n-pinout.png)
$(eval $p/$u-$n.html: $p/$u-$n-schema.png)
$(eval $p/$u-$n.html: $p/$u-$n.ucf)
$(eval $p/$u-$n.html: $d/fuse.log)
$(eval $p/$u-$n.html: $d/isim.log)
$(eval $p/$u-$n.html: $d/$n/syn.srp)
$(eval $p/$u-$n.html: $d/$n/syn.bld)
$(eval $p/$u-$n.html: $d/$n/syn.map)
$(eval $p/$u-$n.html: $d/$n/syn.mrp)
$(eval $p/$u-$n.html: $d/$n/syn-routed.par)
$(eval $p/$u-$n.html: $d/$n/syn.bgn)

$(eval $p/$u-$n.html:  VHDL_TOP := $(filter %$u-arch.vhdl, ${$u-src}))
$(eval $p/$u-$n.html: VHDL_TEST := $(filter %$u-test.vhdl, ${$u-src}))
$(eval $p/$u-$n.html:      VHDL := $(filter-out \
					%$u-arch.vhdl \
					%$u-test.vhdl, \
					${$u-src}))
$(eval $p/$u-$n.html:   TEST_IN := $p/$u-test-in.txt)
$(eval $p/$u-$n.html:  TEST_OUT := $p/$u-test-out.txt)
$(eval $p/$u-$n.html:    SIMPNG := $p/$u-test.png)
$(eval $p/$u-$n.html:    PINOUT := $p/$u-$n-pinout.png)
$(eval $p/$u-$n.html:    SCHEMA := $p/$u-$n-schema.png)
$(eval $p/$u-$n.html:       UCF := $p/$u-$n.ucf)
$(eval $p/$u-$n.html:  FUSE_LOG := $d/fuse.log)
$(eval $p/$u-$n.html:  ISIM_LOG := $d/isim.log)
$(eval $p/$u-$n.html:   XST_LOG := $d/$n/syn.srp)
$(eval $p/$u-$n.html:   NGD_LOG := $d/$n/syn.bld)
$(eval $p/$u-$n.html:   MAP_LOG := $d/$n/syn.map)
$(eval $p/$u-$n.html:   MRP_LOG := $d/$n/syn.mrp)
$(eval $p/$u-$n.html:   PAR_LOG := $d/$n/syn-routed.par)
$(eval $p/$u-$n.html:   BIT_LOG := $d/$n/syn.bgn)

endef


$(foreach u, ${units}, $(eval $u-dep := $(sort ${$u-dep})))
$(foreach u, $(filter-out ${blacklist_sim}, ${units}), $(eval ${VHDL_SIM}))
$(foreach u, $(filter-out ${blacklist_syn}, ${units}), \
	$(foreach ucf, $(call vhdl_src, ${u}-nexys3.ucf), \
		$(eval $u-ucf := ${ucf}) \
		$(eval dev_name := nexys3) \
		$(eval ${VHDL_RTL}) \
		$(eval ${VHDL_BIT}) \
		$(eval ${VHDL_DOC}) \
		$(eval dev_name :=) \
		$(foreach v, ${VERBOSE}, $(info UCF Nexys3 @ ${ucf})) \
	) \
	$(foreach ucf, $(call vhdl_src, ${u}-nexys4.ucf), \
		$(eval $u-ucf := ${ucf}) \
		$(eval dev_name := nexys4) \
		$(eval ${VHDL_RTL}) \
		$(eval ${VHDL_BIT}) \
		$(eval ${VHDL_DOC}) \
		$(eval dev_name :=) \
		$(foreach v, ${VERBOSE}, $(info UCF Nexys4 @ ${ucf})) \
	) \
	$(if $(strip ${u-ucf}), , \
		$(eval dev_name := default) \
		$(eval ${VHDL_RTL}) \
		$(eval dev_name :=) \
	) \
)


%/:        ; $(call mkdir, $@)


# Used to cd into subdirectories
xlnx_exec = $(call subsh, \
	$(call pushd, $1) && $(call xlnx_path) && $2)


# Only on Linux
wdb2png = $(call xlnx_path) && \
	xvfb-run \
	--server-args="-screen 0 ${PNG_RESOLUTION}" \
	--auto-servernum \
	./util/wdb2png.sh $1 $2


# Only on Linux
ngr2png = $(call xlnx_path) && \
	xvfb-run \
	--server-args="-screen 0 ${PNG_RESOLUTION}" \
	--auto-servernum \
	./util/ngr2png.sh $1 $2 $3


%sim.prj:
	$(call m4_xlnx, \
	-DPRJ \
	-DVHDL=$(subst ${space},${comma},$(addprefix ../../../, $^)), $@)


%fuse.log %sim.exe: %sim.prj
	$(call xlnx_exec, $(dir $<), \
	${FUSE} ${FUSE_OPT} $(foreach g, ${GENERIC}, -generic_top $g) \
	-prj $(notdir $*sim.prj) \
	work.$(strip ${entity}) \
	-o $(notdir $*sim.exe))


%.tcl:
	$(call m4_xlnx, -DTCL, $@)


%sim.wdb %isim.log: %sim.exe %sim.tcl
	$(call xlnx_exec, $(dir $<), \
	$(call exec, ./$(notdir $*sim.exe)) \
	-tclbatch $(notdir $*sim.tcl) \
	-wdb $(notdir $*sim.wdb))


%syn.prj:
	$(call m4_xlnx, \
	-DPRJ \
	-DVHDL=$(subst ${space},${comma},$(addprefix ../../../../, $^)), $@)


%syn.xst: %syn.prj
	$(call m4_xlnx, \
	-DXST -DENTITY=$(strip ${entity}) -DDEVICE=$(strip ${device}), $@)


%.ngr %.srp %.ngc: %.xst
	$(call xlnx_exec, $(dir $<), \
	${XST} ${XST_OPT} -ifn $(notdir $<))


%.bld %.ngd: %.ucf %.ngc
	$(call xlnx_exec, $(dir $<), \
	${NGD} ${NGD_OPT} -p ${device} \
	-uc $(notdir $*.ucf) \
	$(notdir $*.ngc))


%.map %.mrp %.pcf %.ncd: %.ngd
	$(call xlnx_exec, $(dir $<), \
	${MAP} ${MAP_OPT} -w -detail -pr b $(notdir $*.ngd))


%-routed.par %-routed.ncd: %.pcf %.ncd
	$(call xlnx_exec, $(dir $<), \
	${PAR} ${PAR_OPT} \
	-w $(notdir $*.ncd) \
	$(notdir $*-routed.ncd) \
	$(notdir $*.pcf))


%.bgn %.bit: %.pcf %-routed.ncd
	$(call xlnx_exec, $(dir $<), \
	${BIT} ${BIT_OPT} \
	-w $(notdir $*-routed.ncd) \
	$(notdir $*.bit) \
	$(notdir $*.pcf))


%.html:
	$(call m4_html, \
	-DVHDL_TOP=${VHDL_TOP} \
	-DVHDL_TEST=${VHDL_TEST} \
	-DVHDL=$(subst ${space},${comma},$(sort ${VHDL})) \
	-DTEST_IN=${TEST_IN} \
	-DTEST_OUT=${TEST_OUT} \
	-DSIMPNG=${SIMPNG} \
	-DPINOUT=${PINOUT} \
	-DSCHEMA=${SCHEMA} \
	-DUCF=${UCF} \
	-DFUSE_LOG=${FUSE_LOG} \
	-DISIM_LOG=${ISIM_LOG} \
	-DXST_LOG=${XST_LOG} \
	-DNGD_LOG=${NGD_LOG} \
	-DMAP_LOG=${MAP_LOG} \
	-DMRP_LOG=${MRP_LOG} \
	-DPAR_LOG=${PAR_LOG} \
	-DBIT_LOG=${BIT_LOG} \
	, $@) \
	&& $(call cp, ./util/prism.css, $(@D)/prism.css) \
	&& $(call cp, ./util/prism.js, $(@D)/prism.js)


empty :=
space := ${empty} ${empty}
comma := ,


# Convert all / to \, except for escaped \/
dospath  = $(subst \$0,/,$(subst /,\,$(subst \/,\$0,$1)))
ifdef SystemRoot
true  = dir .   >nul 2>nul
false = dir con >nul 2>nul
mkdir = $(call dospath, (pushd $1 1>nul 2>nul && popd) || mkdir $1)
touch = $(call dospath, type nul >>$1& copy $1 +${comma}${comma})
cp    = $(call dospath, copy $1 $2 1>nul 2>nul)
rm    = $(call dospath, del $1 1>nul 2>nul)
rmdir = $(call dospath, (del \/f\/s\/q $1 && rmdir \/s\/q $1) 1>nul 2>nul)
exec  = $(call dospath, $1)
pushd = $(call dospath, pushd $1)
popd  = $(call dospath, popd)
echo  = echo $1
subsh = cmd /s /c "$1"
null  = nul
m4    = m4
xlnx_m4 = ./util/xilinx.m4
html_m4 = ./util/html.m4
m4_xlnx = $(call dospath, ${m4} -P $1 ${xlnx_m4} > $2)
m4_html = $(call dospath, ${m4} -P $1 ${html_m4} > $2)
xlnx_path = $(if $(strip ${XLNX_SETTINGS}), ${XLNX_SETTINGS}, echo No Xilinx)
else
true  = true
false = false
mkdir = test -d $1 || mkdir $1
touch = touch $1
cp    = cp $1 $2
rm    = rm -f $1
rmdir = rm -rf $1
exec  = $1
pushd = pushd $1
popd  = popd
echo  = echo $1
subsh = ($(strip $1))
null  = /dev/null
m4    = m4
xlnx_m4 = ./util/xilinx.m4
html_m4 = ./util/html.m4
m4_xlnx = ${m4} -P $1 ${xlnx_m4} > $2
m4_html = ${m4} -P $1 ${html_m4} > $2
xlnx_path = $(if $(strip ${XLNX_SETTINGS}), . ${XLNX_SETTINGS}, echo No Xilinx)
endif
