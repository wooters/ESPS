# NAME

demux - (demultiplex) extract real or complex channels from a
sampled-data file

# SYNOPSIS

**demux** \[ **-e** *grange* \] \[ **-o** *prototype* \] \[
**-**{**prs**} ***range*** \] \[ **-x** *debug_level* \] \[ **-S** \] \[
**-P** *param_file* \] *input.fsd* \[ *output1.fsd* \[ *output2.fsd* \]
. . . \]

# DESCRIPTION

The *demux* (\`\`demultiplex'') program extracts the information from
selected channels of its input sampled-data (FEA_SD) file and writes the
information in either one multichannel output FEA_SD file or a set of
single-channel output files, one for each selected channel. (Channels
can be selected with the **-e** option). Optionally, *demux* may also
split complex input channels into pairs of real output channels. (See
**-S**.) Any fields other than *samples* in the input file are ignored.

If a single output filename is specified, a single multichannel file
with that name is created, and all output goes to that file. If more
than one output filename is specified, the number of names must equal
the number of selected channels, and a single-channel output file is
created for each selected channel. A single-channel output file for each
selected channel is also created if no output filename is specified. In
that case the program generates output filenames automatically from a
prototype, which must be given with the **-o** option (*q.v.*) or as the
value of the ESPS parameter *prototype.*

If \`\`-'' is written for the input file, the standard input is used. If
\`\`-'' is written for an output file, the standard output is used. At
most one output file may be standard output.

# OPTIONS

The following options are supported:

**-e** *grange*  
The argument should be a general range specification acceptable to
*grange_switch*(3-ESPSu). The format of the argument is that of a
comma-separated list of integers and pairs *a***:***b,* where *a* and
*b* are integers. This specifies a set of integers that indicate the
channel numbers of the channels that are selected for output. For
example, *2,5:8,12* specifies channel 2, channels 5 through 8, and
channel 12. Additionally, an expression *a***:+***c* may be written
instead of *a***:***b,* where *c* is an integer such that *a*+*c*=*b.*
Thus *5:8* could be replaced with *5:+3* in the example.

The numbering of channels begins with 0. The channel numbers must be
specified in increasing order without repetitions. If this option is not
specified, the value of the parameter *channels* is used, and if the
parameter is not defined, the default is to output all the channels in
the input file. Note that the channel numbers can be affected by the use
of the **-S** option described below.

**-o** *prototype*  
This option is ignored if any explicit output filename is given. If no
output file is named explicitly, and this option is specified, then each
output channel is written to a separate, single-channel file, and the
program creates output file names by modifying the option argument
*prototype.* This must be a filename base. Each output file name is
obtained by appending the corresponding channel number to prototype
string. (The numbering of the channels may be affected by the **-S**
option; see the description of **-S**.) If this option is not selected,
and no explicit output filenames are specified, the parameter
*prototype* must be defined.

**-p** *range*  
For this program, **-p** is a synonym for **-r**. See **-r** for the
interpretation and the format of the argument.

**-r** *first***:***last*  
**-r** *first***:+***incr*  
Determines the range of records to be taken from an input file. In the
first form, a pair of unsigned integers gives the numbers of the first
and last records of the range. (Counting starts with 1 for the first
record in the file.) If *first* is omitted, 1 is used. If *last* is
omitted, the last record in the file is used. The second form is
equivalent to the first with *last = first + incr.* If the specified
starting record does not exist in the input file, the program exits with
an error message. If the end of the input file is reached before the
specified last record, processing stops with a warning message.

**-s** *start***:***end*  
**-s** *start***:+***incr*  
Determines the range in seconds of the data to be taken from the input
file. In the first form, a pair of floating-point numbers give the
beginning time and ending time of the range. The second form is
equivalent to the first with *last = first + incr.* Each sample has a
time given by *s* + (*r*-1)/*f,* where *s* is the value of the generic
header item "start_time", *r* is the record number, and *f* is the
sampling frequency, given by the generic header item "record_freq". This
time may depend on the channel number, since the "start_time" item may
be a vector with a component per channel; for present purposes the value
for channel 0 is used. The range selected by the **-s** option consists
of the records for which the time is less than *end* but not less than
*start.*

**-x** *debug_level*  
If *debug_level* is positive, the program prints debugging messages as
it progresses--- the higher the number, the more messages. The default
level is 0, for no debugging output.

**-S**  
Split complex input channels into pairs of real channels. The input file
must have one of the complex data types: DOUBLE_CPLX, FLOAT_CPLX,
LONG_CPLX, SHORT_CPLX, or BYTE_CPLX. (See *FEA*(5-ESPS) for an
explanation of these type codes.) The output file or files have the
corresponding real data type: DOUBLE, FLOAT, LONG, SHORT, or BYTE. This
option affects the numbering of channels used by the **-e** and **-o**
options. The real and imaginary parts of the channel that normally is
numbered *c* become channels number 2*c* and 2*c*+1, respectively, for
purposes of the **-e** and **-o** options. (Channel numbers start from
0.)

**-P** *param_file*  
The name of the parameter file. The default name is \`\`params''.

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
values for all parameters. (But if no parameter *prototype* is defined,
the output file(s) must either be named explicitly or with **-o**.) If
the file exists, the following parameters may be read if they are not
determined by command-line options.

*channels - integer array*  
Channel numbers selected for output. This parameter is not read if the
**-e** option is selected. The numbers must be in increasing order
without duplications. The default is all channels in the input file.

*prototype - string*  
Prototype for output file names. This parameter is not read if the
**-o** option is specified, or if the output file or files are named
explicitly. Each channel selected for output is written to a file whose
name is the result of appending the channel number to the prototype.
(See the Options section for the effect of **-S** on channel numbering.)

*start - integer*  
The starting record number in the input file. This parameter is not read
if the **-p**, **-r**, or **-s** option is specified. The default is 1,
meaning the beginning of the input file.

*nan - integer*  
The number of records to process in the input file. A value of 0 (the
default) means continue processing until the end of the input file is
reached. This parameter is not read if the **-p**, **-r**, or **-s**
option is specified.

*make_real - string*  
A value of "YES" or "yes" means split complex input channels into pairs
of real channels as if the **-S** option is in force. A value of "NO" or
"no" indicates normal processing: the output data type is the same as
the input type, and channels are not split when the type is complex. No
other values are allowed. This parameter is not read if the **-S**
option is specified. The default value is "NO".

# ESPS COMMON

The parameters *start* and *nan* are read from the ESPS Common file and
take precedence over the values in the Parameter file provided that
Common processing is enabled, the input file is not standard in, the
Common file is newer than the parameter file, and the parameter
*filename* in the Common file matches the name of the input file. These
values do not take precedence over values established on the command
line with **-p**, **-r**, or **-s**.

This program does not write the Common file.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to *off.* The default ESPS Common file is
*espscom* in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

Each output header is a new FEA_SD file header, with appropriate items
copied from the input header.

The generic header item "record_freq" from the input is copied into the
output headers.

The generic header item "start_time" is included in every output file.
It is a single number for a single-channel output file or a multichannel
output file in which all channels have the same starting time; otherwise
it is a vector with one element for each channel in the output file. The
starting time for a channel is its starting time in the input file plus
an offset in case the data taken from the input file do not start with
the first record. The offset is given by (*r*-1)/*f* where *r* is the
starting record number in the input file and *f* is the sampling
frequency given by the "record_freq" header item.

If the input file has a "max_value" header item, then so do the output
files.

# EXAMPLES

Copy data from channel 3 of a multichannel FEA_SD input file *aaa.fsd*
to make one single_chanel output file *xxx.fsd.*

> *demux -e3 aaa.fsd xxx.fsd*

Copy data from channels 0, 2 through 5, and 7 of an input FEA_SD file
*aaa.fsd* to make a 6-channel output FEA_SD file *xyz.fsd.*

> *demux -e 1,2:5,7 aaa.fsd xyz.fsd*

Copy data from channels 0, 1, and 2 of input file *bbb.fsd* to make
single-channel output files *xxx.fsd,* *yyy.fsd,* and *zzz.fsd,*
respectively. The input file must have exactly 3 channels.

> *demux bbb.fsd xxx.fsd yyy.fsd zzz.fsd*

Copy data from channels 2, 3, and 4 of *aaa.fsd* to make 3
single-channel FEA_SD output files *sig002* *sig003* and *sig004*

> *demux -e2:4 -o sig aaa.fsd*

Copy the data from a single-channel complex input file *ccc.fsd* to make
a 2-channel real output file *rst.fsd*

> *demux -S ccc.fsd rst.fsd*

Copy the data from the imaginary part of channel 3 of a multichannel
complex input file *cde.fsd* to make one single-channel real output file
*r007* (7 = 2×3 + 1.)

> *demux -S -e7 -o r cde.fsd*

# SEE ALSO

    mux(1-ESPS), copysps(1-ESPS), addgen(1-ESPS), 
    FEA_SD(5-ESPS), FEA(5-ESPS)

# DIAGNOSTICS

The program exits with an error message if any of the following occur.
The command line cannot be parsed. More than one output file name is
\`\`-''. The input file cannot be opened or is not an ESPS sampled-data
file. The number of explicit output filenames is greater than 1 and not
equal to the number of selected channels. A selected channel does not
exist. -S is specified and the input data type is real. Channel numbers
are duplicated or not specified in increasing order There is no explicit
output file name and no prototype

The program issues a warning message if the end of a range specified by
a **-p**, **-r**, or **-s** option is not reached.

# BUGS

The **-s** option is not implemented in this version.

# AUTHOR

Manual page by Rodney Johnson. Program by Alan Parker.
