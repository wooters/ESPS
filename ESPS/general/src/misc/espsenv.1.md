# NAME

espsenv - print values of ESPS environmental variables

# SYNOPSIS

**espsenv**

# DESCRIPTION

*Espsenv* prints to standard output the values for a number of
environment variables used by ESPS and *waves+*. The file *Eenv.csh* in
\$ESPS_BASE/lib contains *csh* commands to set all these variables to
their default values. Many users find it convenient to copy this file to
their \$HOME directory and insert a "source Eenv" command into their
.login file. An equivalent *sh* version is contained in
\$ESPS_BASE/lib/Eenv.sh. (\$ESPS_BASE represents the base of the
installed ESPS directory tree, and can be determined by running
*get_esps_base* (1-ESPS)).

A description of the meanings and possible values of the environment
variables follows. Note that the various path environment variables can
themselves have embedded environment variables (preceeded by the symbol
\$). These environment variables are expanded by *find_esps_file*
(3-ESPS). If "\$ESPS_BASE" is embedded within such an environment
variable definition but the environment variable ESPS_BASE itself is not
defined, then *find_esps_file* expands it to a compiled-in default
(/usr/esps).

ESPS_VERBOSE  
This variable controls the amount of feedback the user is provided about
the origin of parameters used by the programs. It has 3 significant
settings: 0, 1, and 2. If it is equal to 0, no feedback is provided. If
it is equal to 1, programs report the value of any parameters taken from
ESPS common. If it is 2 or greater, programs report the values of
parameters taken from ESPS common, the name of the actual parameter file
used (if any), and the values of parameters taken from the parameter
file. If ESPS_VERBOSE is not set, a value of 2 is assumed. Note that
parameter file selection is affected by ESPS_PARAMS_PATH.

USE_ESPS_COMMON  
This controls whether ESPS common is processed by programs. If set to
"off", common is not read by ESPS programs; otherwise, common is read
when appropriate. If this variable is undefined, a value of "YES" is
assumed. For a complete description of ESPS parameter and Common file
processing, see *read_params* (3-ESPS). For historical reasons, Common
processing is enabled by default (i.e., unless USE_ESPS_COMMON is
defined and set to "off"). However, many users find it advisable to
disable Common. This makes ESPS usage somewhat less error-prone. Also,
many programs will run faster if Common is disabled.

ESPSCOM  
This specifies the name of the file used for ESPS Common. If a full path
is not given, the path is interpreted relative to the directory from
which any given ESPS program is called. If ESPSCOM is not defined, the
default is ".espscom" in the user's home directory. For a complete
description of parameter and common processing, see *getparam* (1-ESPS).

FIELD_ORDER  
This controls whether the data records are written in data type order or
field order (see write_header(3-ESPS) for more details). If it is set to
"off" or is undefined, the data records are written in data type order;
otherwise, the data records are written in field order.

ESPS_EDR  
This variable determines the data representation format of ESPS files
written by ESPS programs. If this variable is not defined or has a value
other than *on* the default action is taken. The default is to write
ESPS files in the host machine's native data representation (this
includes such things as byte order and floating point formats). ESPS
files have a field in the header that indicates whether the file is in
the machine's native format (NATIVE) or in Entropic's external data
representation (EDR). All ESPS implementations on all supported machines
can read files made on any other implementation if they are in EDR
format. In addition all implementations can read files in their host
machine's native format. Some implementations can also read files in
other machine's native format, but this will not generally be the case.
If files must be portable then they should be written in EDR format. But
if not, then NATIVE mode should be used, since data conversions will not
be required and programs will run faster.

In summary, this variable should be set *on* to write files than can be
read on any valid ESPS implementation. It should be undefined or set to
*off* for maximum efficiency on the local machine.

ARIEL_16  
On Sun systems that have the AT&T ("Surfboard") DSP32C installed with an
Ariel ProPort option for analog I/O, setting this environment variable
indicates to the software that a 16 Mhz crystal is installed (rather
than the standard 24 MHz. crystal).

ARIELS32C_BIN_PATH  
For systems with an Ariel S-32C card, this is the location of the
directory containing DSP binaries. Use of this variable is not necessary
if programs are installed in standard places.

CODEC16  
On Sun systems that have the AT&T ("Fab 2") DSP32 board installed and
our driver software, setting this variable to any value results in the
on-board codec chip running at 16,000 samples/second. By default, the
codec chip runs at 12,000 samples/second.

DSPSPEC  
For systems with an Ariel S-32C card or Ariel ProPort (analog I/O), this
environment variable should be defined. Normally, it should have the
value "DEVICE=/dev/s32c0,PATH=\$ESPS_BASE/s32cbin".

DSP32_BIN_PATH  
For systems with an AT&T FAB2 board, this is the location of the
directory containing DSP binaries. Use of this variable is not necessary
if programs are installed in standard places.

DSP32C_BIN_PATH  
For systems with a Heurikon or AT&T SURF board, this is the location of
the directory containing DSP binaries. Use of this variable is not
necessary if programs are installed in standard places.

DEF_HEADER  
If this variable is defined, it is assumed to be the path to a file
containing an ESPS header, which will then be used as a default header
by *read_header* (3-ESPS) when reading any non-ESPS or non-SIGnal file.
In effect, when any ESPS program (including *(x)waves*+) tries to read a
non-ESPS file, the file is treated as an ESPS file with the header
DEF_HEADER. Note that, if DEF_HEADER is defined, programs will no longer
report "non-ESPS file" and exit, since they will stick the header in
front of any non-ESPS input file. The exception for AT&T format SIGnal
files (DEF_HEADER is not used for them) is made so that *(x)waves+*
continues to read them as SIGnal files.

ELM_HOST  
This variable must be set to the name of the host running the Entropic
license manager daemon.

ELMTIMEOUT  
This variable specifies the time in seconds that the Entropic software
will wait for a response from the license daemon, before determining
that it is down. If the variable is undefined the default timeout period
is 10 seconds. You may need to adjust this depending on your network
environment (a very large and busy network might require a longer
timeout period).

ELMRETRIES  
This variable specifies the number of times that an ESPS program tries
to contact the license manager before giving up. The default is 2.
Increase for a heavily loaded network, if problems occur.

ESPS_TEMP_PATH  
This can be set to the directory that you want programs to use for
temporary files. Not all programs currenlty pay attention to
ESPS_TEMP_PATH, but over time they will be modified to do so.

ESPS_MENU_PATH  
This is the path used by *mbuttons* (1-ESPS) and *fbuttons* (1-ESPS) to
find *olwm*-format menu files. If ESPS_MENU_PATH is not defined, the
default path used is ".:\$ESPS_BASE/lib/menus".

ESPS_PARAMS_PATH  
This is the path used by find ESPS parameter files specified by the
standard ESPS **-P** option. If ESPS_PARAMS_PATH is not defined, the
default path used is ".:\$ESPS_BASE/lib/params".

ESPS_FILTERS_PATH  
This is the path used by certain programs and scripts to locate standard
ESPS filter files. If ESPS_FILTERS_PATH is not defined, the default path
used is ".:\$ESPS_BASE/lib/filters"

ESPS_LIB_PATH  
This is the path used by certain programs and scripts to find standard
ESPS library files. If ESPS_LIB_PATH is not defined, the dfault path is
"\$ESPS_BASE/lib"

ESPS_INPUT_PATH  
This is the path used by certain programs and scripts to find certain
standard ESPS input files. If ESPS_INPUT_PATH is not defined, the
default path used is ".:\$ESPS_BASE/lib/files".

LSISC30_BIN_PATH  
For systems with an LSI-SC30 board, this is the location of the
directory containing DSP binaries. Use of this variable is not necessary
if programs are installed in standard places.

WAVES_INPUT_PATH  
This is the path used by *waves*+ and *xwaves*+ to find all input signal
files, label files, and labelmenu files. If WAVES_INPUT_PATH is not
defined, the default path used is ".:\$ESPS_BASE/lib/waves/files".

WAVES_LIB_PATH  
This is the path used by *waves*+ and *xwaves*+ to find certain library
files. If WAVES_LIB_PATH is not defined, the default path used is
"\$ESPS_BASE/lib/waves".

WAVES_MENU_PATH  
This is the path used by *xwaves*+ to find *olwm*-format menu files used
with the *xwaves*+ command *make_panel*. If WAVES_MENU_PATH is not
defined, the default path used is ".:\$ESPS_BASE/lib/waves/menus".

WAVES_COMMAND_PATH  
This is the path used by *waves*+ and *xwaves*+ to find command files.
If WAVES_COMMAND_PATH is not defined, the default path used is
".:\$ESPS_BASE/lib/waves/commands".

WAVES_COLORMAP_PATH  
This is the path used by *waves*+ and *xwaves*+ to find colormaps. If
WAVES_COLORMAP_PATH is not defined, the default path used is
".:\$ESPS_BASE/lib/waves/colormaps".

WAVES_PROFILE_PATH  
This is the path used by *waves*+ and *xwaves*+ to find the startup
profile. IF WAVES_PROFILE_PATH is not defined, the default path used is
"\$HOME:\$ESPS_BASE/lib/waves".

BBOX_QUIT_BUTTON  
If this variable is defined, it forces a "QUIT" button to be included at
the top of every button panel created via exv_bbox (3-ESPS). This
includes button panels created by *mbuttons* (1-ESPS), *fbuttons*
(1-ESPS), and the *xwaves*+ command *make_panel*. The variable has no
effect if a quit button was specified directly using the **-q** option
to *mbuttons* or the *quit_button* keyword of the *xwaves*+ command
*make_panel*.

# OPTIONS

There are none.

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

The common file is not used.

# BUGS

None known.

# EXPECTED CHANGES

More variables will be added.

# SEE ALSO

*getparam* (1-ESPS),*read_header* (3-ESPS),\
*write_header*(3-ESPS), *e_temp_name*(3-ESPS),\
*find_esps_file* (3-ESPS),*find_esps_file*(1-ESPS),\
*get_esps_base* (1-ESPS)

# AUTHOR

David Burton, John Shore
