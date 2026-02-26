# NAME

splay - send ESPS sampled data to the SPARCstation codec output.

# SYNOPSIS

**splay** \[ **-x** *debug-level* \] \[ **-{ps}** *range* \] \[ **-g**
*gain* \] \[ **-R** *nrepeat* \] \[ **-b** *shift-value* \] \[ **-a** \]
\[ **-e** \] \[ **-q** \] *file* \[ *more-files* \]

# DESCRIPTION

*Splay* does a mu-law encoding of the data in one or more ESPS, SIGnal,
NIST or headerless type SHORT sampled data files and sends the data to
the SPARCstation 1 digital-to-analog converter. A subrange of data
within the files may be chosen; this subrange may be specified in
seconds or points. Furthermore, a repeat count, a scaling factor (gain),
and a shift factor may be specified.

The mu-encoding algorithm expects data in the range +/- 8059. The
scaling, shifting, or automatic (see **-a**) option can be used to
change the data values before mu encoding. If after all shifting or
scaling of the data is completed, there are still data values greater
than 8059, these values are set to 8059 and mu encoding is carried out.

The SPARCstation supports only one sampling rate: 8000 samples/second.
*Splay* checks the sampling rate of the input file. If it is different
than 8000, it sends a warning to standard error, resamples the data
using a relatively crude but fast algorithm, and plays the resampled
data.

Playback may be aborted by sending the terminal's interrupt character
(normally control-C) after playback has started.

If "-" is given for a filename, then the input is taken from standard
input and must be an ESPS FEA_SD file (ie., SIGnal or NIST/Sphere files
cannot be used with standard input).

# ENVIRONMENT

**SPLAY_GAIN** - audio chip playback volume level: from 0 to 100.\

**SPLAY_X** - if set to a non-zero value, use external speaker jack. If
not set, use internal speaker. This is overrriden by the **-e** option.

# OPTIONS

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

**-r** *range*  
**-r** is a synonym for **-p**.

**-s** *range*  
Select a subrange of speech, specified in seconds. The beginning of the
file is 0. The format for a subrange is the same as the **-p** option.
The arguments to the **-s** option can be decimal numbers (e.g. 1.5).

**-R** *count*  
Repeat count. The selected speech is played *count* times. Playback from
standard input can not be repeated. If multiple files were specified,
the files are played in order, and the order is repeated *count* times.

**-g** *gain*  
Speech samples are multiplied by *gain* before being mu-law encoded and
played back. Gain is a floating point value.

**-b** *shift-value*  
If this option is given and *shift-value* is positive, then each sample
(after it is converted to integer format) is shifted to the right by
*shift-value* bits. *Shift-value* being negative causes a left shift.
The shifting takes place before the mu-law conversion. This is preferred
to using the **-g** option because the shift is faster than a floating
multiply. This difference is most noticeable on large files.

**-a**  
If set and the generic header item *max_value* is set in the input file
header, automatic scaling is done. This multiplies each data value by
8059/*max_value* before mu encoding.

**-e**  
If set, the external output jack is used.

**-q**  
Suppresses various warnings and information messages (quiet mode).

# INTERACTION WITH XWAVES

*Splay* is designed to optionally use the server mode of
*xwaves*(1-ESPS). This is especially handy when *splay* is used as an
*xwaves* external play command (e.g. by setting the *xwaves* global
play_prog). When the latter is the case, play commands initiated via
*xwaves*' menu operations may be interrupted by pressing the left mouse
button in the data view. *Xwaves* will send a signal 30 (SIGUSR1) to the
play program. Splay responds to this by sending back to *xwaves* a
command "set da_location xx", where xx is the sample that was being
output when play was interrupted. This setting, in conjunction with
*xwaves*' built-in callback procedure for handling child-process exits,
causes the *xwaves* signal display to center itself on the sample where
play was halted.

The SIGUSR1 signal to terminate *splay* may come from any source. If it
comes from sources other than *xwaves*, the environment variables
WAVES_PORT and WAVES_HOST must be correctly defined (see
*espsenv*(1-ESPS)), for correct functioning of the *xwaves* view
positioning. (Of course, *xwaves* must actually be displaying the signal
in question at the time and *xwaves* must have initiated the play.)

*Splay* may also be interrupted with kill -2 (SIGINT) or kill -3
(SIGQUIT). These signals are caught gracefully and *splay* halts
immediately, but no message is sent to *xwaves*. No message is sent if
the play operation finishes without interruption.

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overridden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

If Common file processing is enabled the following are read from the
Common file.

> *filename - string*

> This is the name of the input file. If no input file is specified on
> the command line, *filename* is taken to be the input file. If an
> input file is specified on the command line, that input file name must
> match *filename* or the other items (below) are not read from Common.

> *start - integer*

> This is the starting point in the input file to begin output. It is
> not read if the **-p** or **-s** option is used.
>
> *nan - integer*

> This is the number of points to output from the input file. It is not
> read if the **-p** or **-s** option is used. A value of zero means the
> last point in the file.

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

> This is the name of the program (*splay* in this case).
>
> *filename - string*

> The name of the last input file.

These items are not written to ESPS COMMON if the input file is
\<stdin\>.

# ESPS HEADER

The generic header items *max_value* and *record_freq* are read, if they
exist. If the **-a** is specified and *max_value* exists, the value of
the *max_value* header item is used to automatically scale the data for
full scale output. The *record_freq* header item is checked to see if it
equals 8000, if it doesn't, a warning is issued.

# DIAGNOSTICS

*Splay* informs the user if the input file does not exist, it is not an
ESPS sampled data file, the sampling frequency of the input file(s) !=
8000, or if inconsistent options are used.

If the starting point requested is greater than the last point in the
file, then a message is printed and the program exits with status 1. If
the ending point requested is greater than the last point in the file,
it is reset to the last point, a warning is printed and processing
continues.

# SEE ALSO

    esps2mu(1-ESPS), tofeasd(1-ESPS)

# AUTHOR

Program by Derek Lin. Manual page by David Burton, modified by Derek
Lin. The program used a resampling funcion from Tom Veatch, Department
of Linguistics, University of Pennsylvania. Thanks to Tom for permission
to use the resampling function.
