# NAME

lrecord - mono or stereo record to disk or pipe for Linux sound card

# SYNOPSIS

**lrecord** \[ **-s** *duration* \] \[ **-f** *sample rate* \] \[ **-c**
*channel* \] \[ **-S** \] \[ **-W** *xwaves display args.* \] \[ **-P**
\] \[ **-p** *prompt string* \] \[ **-x** *debug-level* \] \[ **-H** \]
\[\[ **-o** \] *file* \]

# DESCRIPTION

*Lrecord* provides mono or stereo sampling at selected rates up to at
least 44.1kHz when recording to local disk. Direct recording onto
network disks is often feasible as well. Output files have ESPS
FEA_SD(5-ESPS) headers, or, optionally, no headers. Output may
optionally be directed to *stdout*. *Lrecord* has special adaptations
that permit tight coupling with *xwaves* (see *INTERACTION WITH XWAVES*
below).

When no output file is specified, *lrecord* will, by default, write a
FEA_SD file to standard output. When stereo recording is selected (see
the -c option) channels 0 and 1 alternate in the file, with channel 0
being first. Note that processes consuming the output of *lrecord* on a
pipe must be able to keep up with the average aggregate sampling
frequency. Options are available to control the sampling rate, recording
duration, prompting, header suppression, and immediate display by
*xwaves*.

# OPTIONS

The following options are supported:

**-s** *duration***\[10\]**  
Specifies the maximum duration of the recording session in seconds.
Recording may be interrupted before this time expires with SIGINT,
SIGQUIT or SIGUSR1 (see below). The default *duration* is 10 seconds.
The upper limit is set only by disk space.

**-f** *frequency***\[16000\]**  
Specifies the sampling frequency. The closest frequency to that
requested will be selected from those available and the user will be
notified if the selected value differs from that requested. If -f is not
specified, the default sampling frequency of 16kHz is used.

**-c** *channel***\[1\]**  
By default *lrecord* samples and stores single-channel data from the
left channel. Dual-channel (stereo) recording is selected by setting
*channel* to 2.

**-S**  
Using *SendXwavesNoReply*(3-ESPS), enable the *xwaves* "make" command
when the requested recording time has elapsed or when recording is
interrupted. This permits immediate examination of the recorded passage
using *xwaves*. See *INTERACTION WITH XWAVES* below.

**-W**  
The argument to this option will be appended to the *xwaves* "make"
command to permit display customization (e.g. via window location and
size specifications). See *INTERACTION* WITH XWAVES below.

**-P**  
Enable a prompt message when A/D has actually commenced. The default
message is a "bell ring" and the text "Start recording now ...." This
prompt may be changed with the -p option.

**-p** *prompt string*  
*Prompt string* will be used as the alert that recording is commencing.
Specifying -p forces -P.

**-H**  
Suppresses header creation. A "bare" sample stream will result. The
default is to produce an ESPS FEA_SD file with one or two channels
depending on the -c option.

**-x** *debug_level*  
Setting debug_level nonzero causes several messages to be printed as
internal processing proceeds. The default is level 0, which causes no
debug output.

**-o** *output*  
Specifies a file for output. Use of -*o* before the file designation is
optional if the filename is the last command-line component. If no
output file is specified or if "-" is specified, output will go to
*stdout*.

# INTERACTION WITH XWAVES

*Lrecord* is designed to optionally use the server mode of *xwaves* for
display of its output file on completion of the record operation. For
this to work the record operation must be interrupted with a SIGUSR1
signal or if *lrecord* is not thus interrupted, the -*S* flag must have
been set and output must be to a file.

This is implemented using *SendXwavesNoReply*(3-ESPS).

An example *mbuttons*(1-ESPS) script to implement a primitive record
control panel follows:

    "RECORD Mono"  exec lrecord  -P -s60 -S -W"name $$ loc_y 150" \
                    xx$$& echo $! > foo
    "RECORD Stereo" exec lrecord -P -c2 -s60 -S -W"name $$ loc_y 150" \
                    xx$$& echo $! > foo
    "STOP"          kill -16 `cat foo`
    "ERASE"         f=`cat foo` ; k=`echo $f 1 - p q | dc` ; \
    		kill -2 $f ; rm -f xx$k ; send_xwaves kill name $k

Note how the -*W* option is used to name the display ensemble and to fix
the vertical location of the waveform at the same place on consecutive
invocations. In general, the -*W* option can be used to augment the
display generation as described under the "make" command in the *xwaves*
manual. Note that the "STOP" function is implemented with a "kill -16"
(SIGUSR1). This causes *lrecord* to send the "make" command to *xwaves*.
If either kill -2 (SIGINT) or kill -3 (SIGQUIT) is sent to *lrecord*, it
will terminate gracefully, but will not send any messages to *xwaves*.
The -*S* option causes the *xwaves* display operation to occur even in
the non-interrupted case (i.e. after 60 sec of recording). The above
script is not robust, but may serve as a useful starting point for more
serious attempts.

An available mixer program, such as *xmixer* should be used to control
the sound card, such as selecting input port and gains.

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

ESPS Common is not read or written.

# WARNINGS

When output is to a file, the ESPS header, if it is present, will
correctly reflect the absolute maximum sample value encountered during
recording and the number of samples recorded. If output is to a pipe,
these values are not recorded in the header.

If the output of *lrecord* goes to the terminal, bad things will happen
to the terminal configuration and you may not be able to regain control
of the terminal. In this case, kill the window or kill the record
process remotely from another window.

The maximum rate over the network is unpredictable in general, but we
routinely achieve 16kHz stereo at Entropic Research Laboratory. Of
course rate limitations due to network speed will be less severe for
single-channel recording.

# FILES

# BUGS

# SEE ALSO

copysd(1-ESPS), lplay(1-ESPS),\
send_xwaves(1-ESPS), sfconvert(1-ESPS), sgram(1-\SPS),\
SendXwavesNoReply(3-ESPS), FEA_SD(5-ESPS), xmixer

# AUTHORS

David Talkin and Alan Parker at Entropic Research Laboratory.
