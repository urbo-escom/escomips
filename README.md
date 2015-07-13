escomips
--------


Simulation and Synthesis
------------------------

In  order to  run the  Makefile, add  the  Xilinx tools  to the  path, or  set
`XLNX_SETTINGS` to the location of the settings script in Xilinx, for example:

- Windows (for 32 bit)

	XLNX_SETTINGS=C:\Xilinx\14.7\ISE_DS\settings32.bat

- Linux (for 32 bit)

	export XLNX_SETTINGS=/opt/Xilinx/14.7/ISE_DS/settings32.bat

Run `make` alone to see the Makefile help, the [Makefile](Makefile) gives more
details.

Additionally for  Windows, the  GNU Make 4.0  and GNU M4  1.4 are  included in
`util/`, you need to run `.\make.bat` or just `make` if you don't already have
Make in your path.

The schematic  and simulation  PNG's are generated  via `xdotool`,  `Xvfb` and
`imagemagick` so it will work only on Linux with this tools installed.

The html  generation won't work  on Windows unless  the PNG files  are already
created.
