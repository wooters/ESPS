# NAME

tofeasd - converts data from arbitrary FEA field to FEA_SD (sampled
data) file

# SYNOPSIS

**tofeasd** \[ **-P** *params* \] \[ **-f** *fea_field* \] \[ **-r**
*record_range* \] \[ **-R** *record_freq* \] \[ **-x** *debug_level* \]
*input output*

# DESCRIPTION

*Tofeasd* accepts an arbitary FEA file *input* and produces a FEA_SD
file *output*. The data for the "samples" field in the FEA_SD output -
i.e., the sampled data - are taken from the field in *input* specified
by the **-f** option. The size and numeric data type of the output field
are the same as those of the intput. (Thus, *tofeasd* will produce a
multi-channel FEA_SD file if the input field is a vector.) If the input
field is a vector and the the desired output is a single channel FEA_SD
file with data resulting from the catenation of the data in each input
record, use *make_sd*(1-ESPS) instead.

The sampling rate (generic header item *record_freq*) normally is set to
that of the input file, but an arbitrary value can be forced by means of
the **-R** option. If a single component of an input vector field is
desired, use *demux*(1-ESPS) after *tofeasd*.

If *input* is "-", the input is taken from standard input. If *output*
is "-", the output is directed to standard output.

# OPTIONS

The following options are supported:

**-P** *params* **\[params\]**  
Specifies the name of the parameter file.

**-f** *field_name* **\[***samples"\]"*  
Specifies the name of the data field in *input* to be converted.

**-r** *start***:***last* **\[1:(last in file)\]**  
**-r** *start***:+***nan*  
In the first form, a pair of unsigned integers specifies the range of
records to be processed. Either *start* or *last* may be omitted; then
the default value is used. If *last* = *start* + *nan,* the second form
(with the plus sign) specifies the same range as the first. The **-r**
overrides the values of *start* and *nan* from the parameter file.

**-R** *record_freq* **\[value from input file\]**  
Forces a given value for the generic header item *record_freq* in the
output file. If this option isn't used, the value is set to that of the
generic in the input file, if such a generic exists; otherwise,
*record_freq* is set to 1.

**-x** *debug_level* **\[0\]**  
Print diagnostic messages as program runs (for debugging purposes only).
Higher levels give more messages. The default level of zero suppresses
all debugging messages.

# ESPS PARAMETERS

The parameter file does not have to be present, since all the parameters
have default values. The following parameters are read, if present, from
the parameter file:

*field_name - string*  
> This is the name of the source field in *input*. The default is
> "samples". This parameter is not read if the **-f** option is used.

*start - integer*  
> This is the first record of *input* to process. The default is 1. It
> is not read if the **-r** option is used.

*nan - integer*  
> This is the number of records to process. It is not read if the **-r**
> option is used. A value of zero means all subsequent records in the
> file; this is the default.

*record_freq - float*  
> This provides a value for the *record_freq* generic header item in the
> output file - i.e., the sampling rate (since the output is FEA_SD). If
> the parameter isn't provided (or if it is provided and is not
> positive), the value from the input file is copied.

Remember that command line option values override parameter file values.

# ESPS COMMON

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overridden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

The following items are written into the ESPS Common file provided that
*output* is not \<stdout\>.

> *start - integer*

> The starting point from the input file.
>
> *nan - integer*

> The number of points in the selected range.
>
> *prog - string*

> This is the name of the program ("tofeasd" in this case).
>
> *filename - string*

> The name of the input file *input*.

# ESPS HEADERS

The *output* header is a FEA_SD file header. The generic items *start*
and *nan* are written to store the range of input data records
processed.

The generic header item *start_time* is written in the output file. The
value written is computed by taking the *start_time* value from the
header of the input file (or zero, if such a header item doesn't exist)
and adding to it the relative time from the first record in the file to
the first record processed. The computation of *start_time* depends on
the value of the generic header item *record_freq* in the input file. If
this item is not present, *start_time* is just copied from the input
file to the output file.

The generic *record_freq* (sampling rate, in this case) is copied from
the input to the output, unless the value is overriden by the **-R**
option (or a value from the parameter file).

As usual, the command line is added as a comment and the header of
*input* is added as a source file to *output*.

# SEE ALSO

    make_sd(1-ESPS), mux(1-ESPS), demux(1-ESPS),
    addgen(1-ESPS), addfea(1-ESPS), addfeahd(1-ESPS),
    FEA_SD(5-ESPS), FEA(5-ESPS), FEA_SPEC(5-ESPS),
    ESPS(5-ESPS), xwaves(1-ESPS)

# WARNINGS AND DIAGNOSTICS

*tofeasd* will exit with an error message if any of the following are
true: *input* does not exist or is not an ESPS FEA file; the data field
does not exist in *input;*

In FEA_SPEC files of BYTE data format, spectral values are represented
as integers in a limited range and with an offset of 64 dB: values from
-64.0 dB to 63.0 dB are represented by bytes ranging from 0 to 127. A
program such as *psps*(1-ESPS) reads and offsets the data before writing
it out to standard output to reflect true dB values. When converting
BYTE data of FEA_SPEC file to FEA_SD file, *tofeasd* does not offset the
data by -64 dB. Use *feafunc*(1-ESPS) to do the offseting.

# BUGS

None known.

# FUTURE CHANGES

A later version of this program will subsume the functions of
*make_sd*(1-ESPS). Also, it would in general be better if one could run
FEA_SD programs directly on arbitrary FEA files (naming the field to be
treated as "samples"), rather than having to convert to an intermediate
file by means of *tofeasd*. In a later release of ESPS, we intend to
include a general mechanism for this.

# AUTHOR

Manual page and program by John Shore.
