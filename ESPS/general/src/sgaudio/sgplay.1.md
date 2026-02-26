# NAME

sgplay - send sampled data (PCM) to native Indigo D/A converter.

# SYNOPSIS

**sgplay** \[ **-r** *range* \] \[ **-s** *start time* \] \[ **-e** *end
time* \] \[ **-f** *sample rate* \] \[ **-c** *channel* \] \[ **-x**
*debug-level* \] \[ **-H** \] \[\[ **-i** \] *file* \] \[ *more-files*
\]

# DESCRIPTION

*Sgplay* sends all or a portion of one or more ESPS, SIGnal, NIST or
headerless sampled data files to a Silicon Graphics Indigo
digital-to-analog converter. A subrange of data within the files may be
chosen; this subrange may be specified in seconds or sample points.
Dual-channel (stereo) or single-channel (monaural) data may be
converted. Single-channel input data may be directed to either or both
output channels.

Playback may be stopped by sending the terminal's interrupt character
(normally control-C) after playback has started.

If "-" is given for a filename, then the input is taken from standard
input and must be an ESPS file or a headerless file (i.e., SIGnal or
NIST/Sphere files cannot be used with standard input).

The SGI Indigo program *apanel* may be used to set the output level, if
desired. *Apanel* should be started before *sgplay*. It may be left
running indefinitely.

# OPTIONS

The following options are supported:

**-r** *range*  
Select a subrange of points to be played, using the format *start-end* ,
*start:end* or *start:+count*. Either the start or the end may be
omitted; the beginning or the end of the file are used if no alternative
is specified.

If multiple files were specified, the same range from each file is
played.

**-s** *start time*  
Specify the start time in seconds. Play will continue to the end of file
or the end time specified with -e. -s may not be used with -r.

**-e** *end time*  
Specify the playback end time in seconds. Play will start at the
beginning of file or the time specified by -s. -e may not be used with
-r.

**-f** *frequency*  
Specifies the sampling frequency. The closest frequency to that
requested will be selected from those available and the user will be
notified if the selected value differs from that requested. If -f is not
specified, the sampling frequency in the header is used, else the
default value for headerless files is 16kHz (assuming the standard Ariel
crystal).

**-c** *channel*  
Select the output channel configuration. For files with headers, the
behavior is to play stereo if the file is stereo and to provide
identical output on both channels if the file is single-channel. If the
file has no header, the default is to assume single-channel data and
provide identical output to both channels. For headerless files, this
may be changed with -*c* 2 (stereo data, stereo output).

**-H**  
Force *sgplay* to treat the input as a headerless file. This is probably
unwise to use unless the gain on your loudspeaker or earphones is way
down, since a file that really does have a header, or a file composed of
data types other than shorts (of the correct byte order!) will cause a
terrible sound.

**-i** *input file*  
Specify a file to be D/A converted. Use of -i before the file
designation is optional if the filename is the last command-line
component. If no input file is specified, or if "-" is specified, input
is taken from stdin.

**-x** *debug_level*  
Setting debug_level nonzero causes several messages to be printed as
internal processing proceeds. The default is level 0, which causes no
debug output.

# INTERACTION WITH XWAVES

*Sgplay* is designed to optionally use the server mode of *xwaves*
(1-ESPS). This is especially handy when *sgplay* is used as an *xwaves*
external play command (e.g. by setting the *xwaves* global play_prog).
When the latter is the case, play commands initiated via *xwaves*' menu
operations may be interrupted by pressing the left mouse button in the
data view. *Xwaves* will send a signal (SIGUSR1) to the play program.
Sgplay responds to this by sending back to *xwaves* a command "set
da_location xx", where xx is the sample that was being output when play
was interrupted. This setting, in conjunction with *xwaves*' built-in
callback procedure for handling child-process exits, causes the *xwaves*
signal display to center itself on the sample where play was halted.

The SIGUSR1 signal to terminate *sgplay* may come from any source. If it
comes from sources other than *xwaves*, the environment variables
WAVES_PORT and WAVES_HOST must be correctly defined (see *espsenv*
(1-ESPS)), for correct functioning of the *xwaves* view positioning. (Of
course, *xwaves* must actually be displaying the signal in question at
the time and *xwaves* must have initiated the play.)

*Sgplay* may also be interrupted with kill -2 (SIGINT) or kill -3
(SIGQUIT). These signals are caught gracefully and *sgplay* halts
immediately, but no message is sent to *xwaves*. No message is sent if
the play operation finishes without interruption.

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

ESPS Common is not read or written.

# DIAGNOSTICS

*Sgplay* informs the user if the input file does not exist, if
inconsistent options are used, or if an unsupported sample rate is
requested. Also see **WARNINGS** below.

If the starting point requested is greater than the last point in the
file, then a message is printed. If the ending point requested is
greater than the last point in the file, it is reset to the last point
and processing continues.

# WARNINGS

*Sgplay* supports only the "native" Indigo sampling rates. These are (in
Hz): 48000 44100 32000 29400 24000 22050 16000 14700 12000 11025 10667
9800 9600 8820 8000 7350 6857 6400 6300 6000 5880 5512 5333 4900 4571
4200 4000 3675. If you play a file that is sampled at an unsupported
rate, *sgplay* plays the data at the closest supported rate and issues a
warning.

*Sgplay* provides stereo D/A conversion at rates up to at least 48kHz
when playing from local disk. Sampling from network disks is often
feasible as well. The maximum rate over the network is unpredictable in
general, but we routinely achieve 16kHz stereo at Entropic Research
Laboratory. Of course rate limitations due to network speed will be less
severe for single-channel playing. Obviously, processes supplying input
to *sgplay* on a pipe must be able to keep up with the average aggregate
sampling frequency.

# FILES

# BUGS

If readable header IS present, but -H is specified, the header is
treated like sampled data -- usually resulting in very unpleasant
sounds.

# SEE ALSO

    SD(5-ESPS), testsd(1-ESPS), copysd(1-ESPS),
    sgrecord(1-ESPS), sfconvert(1-ESPS), sgram(1-ESPS),
    send_xwaves2(3-ESPS)

# AUTHOR

David Talkin at Entropic Research Laboratory.
