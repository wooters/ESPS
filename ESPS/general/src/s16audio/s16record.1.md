# NAME

s16record - mono or stereo record to disk or pipe for Sparc 16 bit A/D
converter

# SYNOPSIS

**s16record** \[ **-s** *duration* \] \[ **-f** *sample rate* \] \[
**-c** *channel* \] \[ **-S** \] \[ **-W** *xwaves display args.* \] \[
**-P** \] \[ **-p** *prompt string* \] \[ **-x** *debug-level* \] \[
**-H** \] \[\[ **-o** \] *file* \]

# DESCRIPTION

*S16record* provides mono or stereo sampling at selected rates up to at
least 48kHz when recording to local disk. Direct recording onto network
disks is often feasible as well. Output files have ESPS FEA_SD headers,
or, optionally, no headers. Output may optionally be directed to
*stdout*. *S16record* has special adaptations that permit tight coupling
with *xwaves* (see *INTERACTION WITH XWAVES* below).

When no output file is specified, *s16record* will, by default, write a
FEA_SD file to standard output. When stereo recording is selected (see
the -c option) channels 0 and 1 alternate in the file, with channel 0
being first. Note that processes consuming the output of *s16record* on
a pipe must be able to keep up with the average aggregate sampling
frequency. Options are available to control the sampling rate, recording
duration, prompting, header suppression, and immediate display by
*xwaves*.

This program is for Sun Sparc systems with the 16 bit audio. It supports
systems with an external speakerbox (such as SS10), the SS5, and those
machines using the internal dbri codec and optional external speakerbox
(such as LX). It is not for the 8 bit codec such as the SS1, SS1+, SS2,
SLC, and Classic. The ESPS program *srecord* supports those machines.

On a Sparcstation LX, the optional speakerbox must be attached at boot
time in order to be usable. If the speakerbox is not attached, then the
only available input port is the microphone input jack. The microphone
input is single channel only. You cannot do dual channel recordings on
an LX without the optional speakerbox.

On a SS10, or an LX with the speakerbox, the input options are a
microphone input jack and a line level input jack. The microphone jack
is single channel and the line input is dual channel.

On a SS5 the input options are the microphone or line level jack.

There is modified version of the Sun *gaintool* program in the Entropic
bin directory. This program must be used to set the input gain, monitor
the input, and select the input (microphone jack vs. line jack).

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
By default s16record samples and stores single-channel data from the
left channel. Dual-channel (stereo) recording is selected by setting
*channel* to 2.

**-S**  
Enable the *xwaves* (1-ESPS) "make" command via *send_xwaves2* (3-ESPS)
when the requested recording time has elapsed or when recording is
interrupted. This permits immediate examination of the recorded passage
using *xwaves*. See *INTERACTION WITH XWAVES* below.

**-W**  
The argument to this option will be appended to the *send_xwaves* "make"
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

*S16record* is designed to optionally use the server mode of *xwaves*
(1-ESPS) for display of its output file on completion of the record
operation. This is implemented using *send_xwaves2* (3u-ESPS). The
following conditions must be met for this feature to work. (1) *Xwaves*
must be running in the server mode. (2) The environment variables
WAVES_PORT and WAVES_HOST must be correctly defined (see *espsenv*
(1-ESPS)). (3) The record operation must be interrupted with a SIGUSR1
signal or if *s16record* is not thus interrupted, the -*S* flag must
have been set. (4) Output must be to a file.

An example *mbuttons* (1-ESPS) script to implement a primitive record
control panel follows:

    "RECORD Mono"  exec s16record  -P -s60 -S -W"name $$ loc_y 150" \
                    xx$$& echo $! > foo
    "RECORD Stereo" exec s16record -P -c2 -s60 -S -W"name $$ loc_y 150" \
                    xx$$& echo $! > foo
    "STOP"          kill -16 `cat foo`
    "ERASE"         f=`cat foo` ; k=`echo $f 1 - p q | dc` ; \
    		kill -2 $f ; rm -f xx$k ; send_xwaves kill name $k

Note how the -*W* option is used to name the display ensemble and to fix
the vertical location of the waveform at the same place on consecutive
invocations. In general, the -*W* option can be used to augment the
display generation as described under the "make" command in the *xwaves*
manual. Note that the "STOP" function is implemented with a "kill -16"
(SIGUSR1). This causes *s16record* to send the "make" command to
*xwaves*. If either kill -2 (SIGINT) or kill -3 (SIGQUIT) is sent to
*s16record*, it will terminate gracefully, but will not send any
messages to *xwaves*. The -*S* option causes the *xwaves* display
operation to occur even in the non-interrupted case (i.e. after 60 sec
of recording). The above script is not robust, but may serve as a useful
starting point for more serious attempts.

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

ESPS Common is not read or written.

# WARNINGS

When output is to a file, the ESPS header, if it is present, will
correctly reflect the absolute maximum sample value encountered during
recording and the number of samples recorded. If output is to a pipe,
these values are not recorded in the header.

If the output of *s16record* goes to the terminal, bad things will
happen to the terminal configuration and you may not be able to regain
control of the terminal. In this case, kill the window or kill the
record process remotely from another window.

*S16record* supports only the dbri 16 bit sampling rates. These are (in
Hz): 48000 44100 37800 32000 22050 18900 16000 11025 9600 8000. If you
try to record a file at an unsupported rate, *s16record* records the
data at the closest supported rate and issues a warning.

The maximum rate over the network is unpredictable in general, but we
routinely achieve 16kHz stereo at Entropic Research Laboratory. Of
course rate limitations due to network speed will be less severe for
single-channel recording.

# FILES

# BUGS

# SEE ALSO

FEA_SD (5-ESPS), *testsd* (1-ESPS), *copysd* (1-ESPS),\
*s16play* (1-ESPS), *sfconvert* (1-ESPS), *sgram* (1-ESPS),\
*gaintool* (1)

# AUTHORS

David Talkin and Alan Parker at Entropic Research Laboratory.
