# NAME

mcplay - send portions of an ESPS file to the MASSCOMP digital to analog
converter. play - send portions of an ESPS file to the digital to analog
converter.

# SYNOPSIS

**mcplay** \[ **-x** *debug-level* \] \[ **-{psf}** *range* \] \[ **-g**
*gain* \] \[ **-w** *width* \] \[ **-r** *nrepeat* \] \[ **-c**
*channel* \] \[ **-k** *clock* \] \[ **-i** \] \[ **-h** *hist-file* \]
\[ **-b** *shift-value* \] \[ **-C** *clock device* \] \[ **-D** *D/A
device* \] \[ **-q** \] *file* \[ *more-files* \]

# DESCRIPTION

*Mcplay* sends a portion of one or more ESPS sampled data files to a
MASSCOMP digital-to-analog converter. A subrange of data within the
files may be chosen; this subrange may be specified in seconds, frames,
or points. Furthermore, a repeat count, a scaling factor (gain), shift
factor, and an alternate channel number may be specified.

If "-" is given for a filename, then the input is taken from standard
input.

The following options are supported:

**-x** *debug*  
Only debug level 1 is defined in this version. This causes several
messages to be printed as internal processing proceeds. The default is
level 0, which causes no debug output.

**-p** *range*  
Select a subrange of points to be played, using the format *start-end* ,
*start:end* or *start:+count*. Either the start or the end may be
omitted; the beginning or the end of the file are used if no alternate
is specified.

If multiple files were specified, the same range from each file is
played.

**-s** *range*  
Select a subrange of speech, specified in seconds. For compatibility
with DSC LISTEN, the beginning of the file is 0. The format for a
subrange is the same as the **-f** option. The arguments to the **-s**
option can be decimal numbers (eg. 1.5).

**-f** *range*  
Select a subrange of speech, specified in frames. By default, a frame is
100 points, but this may be changed.

**-w** *width*  
This switch defines the frame width. The width is ignored unless the
**-f** switch is also specified.

**-r** *count*  
Repeat count. The selected speech is played *count* times. If multiple
files were specified, the files are played in order, and the order is
repeated *count* times.

**-c** *channel*  
Specifies an alternate channel number (default zero).

**-k** *clock*  
Specifies an alternate clock number (default zero).

**-g** *gain*  
Speech samples are multiplied by *gain* before playback. Gain is a
floating point value. This overrides the automatic gain control
described below.

**-i**  
If this flag is given and ESPS FEA_SD file generic header item
*max_value* is zero, then any samples with a value greater than the
maximum of the D/A converter will be clipped. If clipping occurs, then
an entry is made in a history file for each sampled clipped. This entry
gives the sample number and the value before clipping. At the end of the
file a scale factor is given that will prevent clipping. Use of this
option, slows things down noticeably.

**-h** *hist-file*  
Specifies an alternate history file. The default is *play.his*.

**-b** *shift-value*  
If this option is given and *shift-value* is positive, then each sample
(after it is converted to integer format) is shifted to the right by
*shift-value* bits. *Shift-value* being negative causes a left shift.
This option is useful to rescale data that has a higher resolution than
the D/A converter being used here. For example, files recorded by or
synthesized from data recorded by a 16 bit A/D can be shifted 4 bits to
the right for correct output on a 12 bit D/A. This is preferred to using
the **-g** option with a gain of .0625 because the shift is faster than
a floating multiply. This difference is most noticeable on large files.

**-q**  
This option (q for quiet) suppresses all terminal output (except for
fatal error messages) from the program. It is useful when play is being
called by another program.

The default clock device is /dev/dacp0/efclk0, and the default D/A
device is /dev/dacp0/daf0. These defaults, might be different at your
site, however, since they can be changed by the ESPS installation
program. The compiled in defaults can be replaced on the command line
with the **-C** and the **-D** options.

If the ESPS FEA_SD file generic header item *max_value* is greater than
the maximum value that the D/A converter can convert (MAXDA), then each
sample is multiplied by MAXDA/*max_value*. The effect is to scale the
data so that the sample with the maximum value is scaled to MAXDA.

Playback may be aborted by sending the terminal's interrupt character
(normally control-C) after playback has started.

If any of the command line range options are given, they override the
*start* and *nan* common file values described below.

This program is installed under the name *mcplay* and *play*. Since this
program is specific to MASSCOMP systems, a different play program is
used on non-MASSCOMP systems. These system dependent play programs all
have a common user interface and are installed under their system
dependent name (eg. *mcplay*, *netplay*, *sunplay*, etc) and the name
*play*.

This version of the program only operates on single channel FEA_SD or SD
files. Use *demux*(1-ESPS) to select channels from a multi-channel
FEA_SD file. Only files containing non-complex fields can be played.

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

If Common file processing is enabled the following are read from the
Common file if only one input file or no input file is given on the
command line and provided that standard input isn't used.

> *filename - string*

> This is the name of the input file. If no input file is specified on
> the command line, *filename* is taken to be the input file. If an
> input file is specified on the command line, that input file name must
> match *filename* or the other items (below) are not read from Common.

> *start - integer*

> This is the starting point in the input file to begin output. It is
> not read if the **-p, -f,** or **-s** option is used.
>
> *nan - integer*

> This is the number of points to output from the input file. It is not
> read if the **-p, -f** or **-s** option is used. A value of zero means
> the last point in the file.
>
> *gain - float*

> This value is the same as the argument to the -g option described
> above. This value is not read from Common if the **-g** or **-b**
> option is used.
>
> *shift - integer*

> This value is the same as the argument to the -b option described
> above. A gain value and a shift value cannot both be used. If both are
> present in the common file, then only the shift value is used. This
> value is not read from Common if the **-g** or **-b** option is used.

Again, the values of *start* and *nan* are only used if the input file
on the command line is the same as *filename* in the common file, or if
no input file was given on the command line. If *start* and/or *nan* are
not given in the common file, or if the common file can't be opened for
reading, then *start* defaults to the beginning of the file and *nan*
defaults to the number of points in the file.

The following items are written into the ESPS Common file:

> *start - integer*

> The starting point from the input file.
>
> *nan - integer*

> The number of points in the selected range.
>
> *prog - string*

> This is the name of the program (*play* in this case).
>
> *filename - string*

> The name of the input file. If multiple input files are processed,
> this is the name of the first file.
>
> *gain - float*

> This value is written if the **-g** option is used, or if *gain* was
> read from Common.
>
> *shift - integer*

> This value is written if the **-b** option is used, or if *shift* was
> read from Common.

These items are not written to ESPS COMMON if the input file is
\<stdin\> or if there are more than one input files.

# DIAGNOSTICS

*Mcplay* informs the user if the input file does not exist, or is not an
ESPS sampled data file, or if inconsistent options are used.

The program will timeout if the incorrect clock is connected.

If the starting point requested is greater than the last point in the
file, then a message is printed and the program exits with status 1. If
the ending point requested is greater than the last point in the file,
it is reset to the last point, a warning is printed and processing
continues.

# SEE ALSO

mux(1-ESPS), demux(1-ESPS)

# BUGS

# AUTHOR

Alan Parker, based on the network play program by Joe Buck.
