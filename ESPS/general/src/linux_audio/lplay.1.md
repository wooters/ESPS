# NAME

lplay - send sampled data (PCM) to Linux audio driver

# SYNOPSIS

**lplay** \[ **-r** *range* \] \[ **-s** *start time* \] \[ **-e** *end
time* \] \[ **-f** *sample rate* \] \[ **-c** *channel* \] \[ **-x**
*debug-level* \] \[ **-H** \] \[\[ **-i** \] *file* \] \[ *more-files*
\]

# DESCRIPTION

*Lplay* sends all or a portion of one or more ESPS, SIGnal, NIST or
headerless sampled data files to the Linux audio driver for use by a
compatible sound card.

A subrange of data within the files may be chosen; this subrange may be
specified in seconds or sample points. Dual-channel (stereo) or
single-channel (monaural) data may be converted. Single-channel input
data may be directed to either or both output channels.

Playback may be stopped by sending the terminal's interrupt character
(normally control-C) after playback has started.

If "-" is given for a filename, then the input is taken from standard
input and must be an ESPS file or a headerless file (i.e., SIGnal or
NIST/Sphere files cannot be used with standard input).

The audio can be controlled by running one of the available mixer
programs, such as *xmixer*.

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
default value for headerless files is 16kHz.

**-c** *channel*  
Select the output channel configuration. For files with headers, the
behavior is to play stereo if the file is stereo and to provide
identical output on both channels if the file is single-channel. If the
file has no header, the default is to assume single-channel data and
provide identical output to both channels. For headerless files, this
may be changed with -*c* 2 (stereo data, stereo output).

**-H**  
Force *lplay* to treat the input as a headerless file. This is probably
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

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

ESPS Common is not read or written.

# DIAGNOSTICS

*Lplay* informs the user if the input file does not exist, if
inconsistent options are used, or if an unsupported sample rate is
requested. Also see **WARNINGS** below.

If the starting point requested is greater than the last point in the
file, then a message is printed. If the ending point requested is
greater than the last point in the file, it is reset to the last point
and processing continues.

# SEE ALSO

FEA_SD (5-ESPS), *testsd* (1-ESPS), *copysd* (1-ESPS),\
*lrecord* (1-ESPS), *sfconvert* (1-ESPS),\
*sgram* (1-ESPS), *xmixer*

# AUTHOR

David Talkin and Alan Parker at Entropic Research Laboratory.
