# NAME

srecord - record to disk or pipe for SUN SPARC built-in audio device

# SYNOPSIS

**srecord** \[ **-s** *duration* \] \[ **-S** \] \[ **-W** *xwaves
display args.* \] \[ **-P** \] \[ **-p** *prompt string* \] \[ **-x**
*debug-level* \] \[ **-H** \] \[ **-e** \] \[\[ **-o** \] *file* \]

# DESCRIPTION

*Srecord* provides recording to local disk using SUN SPARCstation
built-in audio device, sampling at 8000 Hz. Direct recording onto
network disks is often feasible as well. Output data files are linear
encoded and have ESPS FEA_SD headers, or, optionally, no headers. Output
may optionally be directed to *stdout*. *Srecord* has special
adaptations that permit tight coupling with *xwaves* (see *INTERACTION
WITH XWAVES* below).

Note that processes consuming the output of *srecord* on a pipe must be
able to keep up with the average aggregate sampling frequency. Options
are available to control the recording duration, prompting, header
suppression, and immediate display by *xwaves*.

# OPTIONS

The following options are supported:

**-s** *duration* **\[10\]**  
Specifies the maximum duration of the recording session in seconds.
Recording may be interrupted before this time expires with SIGINT,
SIGQUIT or SIGUSR1 (see below). The default *duration* is 10 seconds.
The upper limit is set only by disk space.

**-S**  
Enable the *xwaves*(1-ESPS) "make" command via *send_xwaves2*(3-ESPS)
when the requested recording time has elapsed or when recording is
interrupted. This permits immediate examination of the recorded passage
using *xwaves*. See *INTERACTION WITH XWAVES* below.

**-W**  
The argument to this option will be appended to the *send_xwaves* "make"
command to permit display customization (e.g. via window location and
size specifications). See *INTERACTION* WITH XWAVES below.

**-P**  
Enable a prompt message when A/D has actually commenced. The default
message is a "bell ring" and the text "START RECORDING NOW...." This
prompt may be changed with the -p option.

**-p** *prompt string*  
*Prompt string* will be used as the alert that recording is commencing.
Specifying -p forces -P.

**-H**  
Suppresses header creation. A "bare" sample stream will result. The
default is to produce an ESPS FEA_SD file.

**-e**  
This option causes a/d input to be echoed out the d/a during recording.

**-x** *debug_level*  
Setting debug_level nonzero causes several messages to be printed as
internal processing proceeds. The default is level 0, which causes no
debug output.

**-o** *output*  
Specifies a file for output. Use of -*o* before the file designation is
optional if the filename is not the last command-line component.

# INTERACTION WITH XWAVES

*Srecord* is designed to optionally use the server mode of
*xwaves*(1-ESPS) for display of its output file on completion of the
record operation. This is implemented using *send_xwaves2*(3-ESPSu). The
following conditions must be met for this feature to work. (1) *Xwaves*
must be running in the server mode. (2) The environment variables
WAVES_PORT and WAVES_HOST must be correctly defined (see
*espsenv*(1-ESPS)). (3) The record operation must be interrupted with a
SIGUSR1 signal (e.g. via "kill -30 pid," where pid is the process ID of
the *srecord* process), or if *srecord* is not thus interrupted, the
-*S* flag must have been set. (4) Output must be to a file.

An example *mbuttons*(1-ESPS) script to implement a primitive record
control panel follows:

    "RECORD"	exec srecord  -P -s60 -S -W"name $$ loc_y 150" \
                    xx$$& echo $! > foo
    "STOP"          kill -30 `cat foo`
    "ERASE"         f=`cat foo` ; k=`echo $f 1 - p q | dc` ; \
    		kill -2 $f ; rm -f xx$k ; send_xwaves kill name $k

Note how the -*W* option is used to name the display ensemble and to fix
the vertical location of the waveform at the same place on consecutive
invocations. In general, the -*W* option can be used to augment the
display generation as described under the "make" command in the *xwaves*
manual. Note that the "STOP" function is implemented with a "kill -30"
(SIGUSR1). This causes *srecord* to send the "make" command to *xwaves*.
If either kill -2 (SIGINT) or kill -3 (SIGQUIT) is sent to *srecord*, it
will terminate gracefully, but will not send any messages to *xwaves*.
The -*S* option causes the *xwaves* display operation to occur even in
the non-interrupted case (i.e. after 60 sec of recording). The above
script is not robust, but may serve as a useful starting point for more
serious attempts.

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

ESPS Common is not read or written.

# WARNINGS

When output is to a file, the ESPS header, if it is present, will
correctly reflect the absolute maximum sample value encountered during
recording and the number of samples recorded. If output is to a pipe,
these values are not recorded in the header.

If another /fIsrecord/fR process is started while one is in progress, it
will hang until the device becomes available. Use the /fI-P/fR option to
signal when the recording starts.

# SEE ALSO

    FEA_SD(5-ESPS), testsd(1-ESPS), copysd(1-ESPS),
    splay(1-ESPS), sfconvert(1-ESPS), setmax(1-ESPS),
    mu2esps(1-ESPS)

# AUTHOR

Derek Lin
