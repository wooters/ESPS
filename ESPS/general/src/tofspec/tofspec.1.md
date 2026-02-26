# NAME

tofspec - transforms data from arbitrary FEA field to FEA_SPEC file

# SYNOPSIS

**tofspec** \[ **-d** \] \[ **-f** *fea_field* \] \[ **-i**
*input_range* \] \[ **-o** *output_range* \] \[ **-r** *record_range* \]
\[ **-s** *sf* \] \[ **-v** *freqs* \] \[ **-x** *debug_level* \] \[
**-F** *freq_format* \] \[ **-P** *params* \] \[ **-R** \] \[ **-S** \]
*input output*

# DESCRIPTION

*Tofspec* accepts an arbitrary FEA file *input* and produces a FEA_SPEC
file *output*. The "power spectrum" in the FEA_SPEC output --- i.e., the
contents of the re_spec_val field --- is taken from the field in *input*
specified by the **-f** option. The main purpose of *tofspec* is to
allow *waves*+ users to display arbitrary FEA data in spectrogram form.

The output FEA_SPEC file has frequency format SYM_EDGE by default (see
*FEA_SPEC*(5-ESPS)). However, there is an option for specifying
frequency format ARB_FIXED instead, which also requires specifying an
explicit list of frequencies to be stored in the output file header (see
the **-F** and **-v** options). The spectrum type is DB (logarithmic
power spectral density in decibels; see *FEA_SPEC*(5-ESPS)). To conserve
space, the file is stored in BYTE format. Unless the**-S** option (no
scaling) is specified, *Tofspec* clips the input data to the input range
specified by the **-i** option, scales the resulting data to the default
output range (-64, +50), and stores the scaled data as float values in
the re_spec_val field of *output*. The output range can be changed from
the default range of (-64, +50) by means of the **-o** option, although
the BYTE format of the output file forces the range to stay within (-64,
+63). If the **-i** option is not used, the input data are not clipped
--- the miminum and maximum values are determined from the input data
and this range is scaled to the output range. If the **-S** option is
specified, no scaling is performed --- input data are copied directly to
output data with clipping at the limits of the output range. If the
**-d** is specified, the log (base 10) of the (possibly clipped) input
data is taken before the data are stored (after possible scaling) in
re_spec_val of *output*.

The data type of the field *fea_field* can be any supported FEA data
type. If the type is complex, only the real part is used.

If *input* is "-" and the input range is specified by the **-i** option
or is determined from the parameter file, then the input is taken from
standard input. (Standard input can not be used if the input range is
determined automatically from the input data.) If *output* is "-", the
output is directed to standard output.

The default output range provides 115 levels, from -64 to +50. This is
intended to use the first 115 entries in the *waves*+ color map. The
entire color map has 128 values, but the top 13 levels are used for
cursors, borders, and backgrounds. Thus, if the full 128 levels are
covered in the *tofspec* output, various colors will intrude when data
is displayed using the grey scale map.

# OPTIONS

The following options are supported:

**-d**  
Apply log (base 10) to input data before scaling (no **-S**) or storing
(**-S**) .

**-f** *field_name* **\[sd\]**  
Specifies the name of the data field in *input* to be converted. The
default name is "sd".

**-i** *low_input***:***high_input* **\[(determined from data)\]**  
**-i** *low_input***:+***incr*  
The first form gives the low and high limits of the range of input data
to scale to the output range. This option is ignored if the **-S**
option is used. If *high_input* = *low_input* + *incr,* the second form
(with the plus sign) specifies the same range as the first. If this
option is not used, the limits are determined from the data.

**-o** *low_output***:***high_output* **\[-64:+50\]**  
**-o** *low_output***:+***incr*  
The first form gives the low and high limits of the output range. If
*high_output* = *low_output* + *incr,* the second form (with the plus
sign) specifies the same range as the first. If *low_output* \< -64, it
is reset to -64 and a warning is printed. If *high_output* \> 63, it is
set to 63 and a warning is printed. This option specifies the range of
output data. Unless the**-S** option is specified, the input range is
scaled to the output range (see also **-d**). If **-S** is specified,
the input range is ignored, and the input data are clipped to the output
range (see also **-d**).

**-r** *start***:***last* **\[1:(last in file)\]**  
**-r** *start***:+***nan*  
In the first form, a pair of unsigned integers specifies the range of
records to be processed. Either *start* or *last* may be omitted; then
the default value is used. If *last* = *start* + *nan,* the second form
(with the plus sign) specifies the same range as the first. The **-r**
overrides the values of *start* and *nan* from the parameter file.

**-s** *sf* **\[0\]**  
Specifies the value to be used for the generic header item *sf* in
*output*. As a result, if the frequency format of *output* is SYM_CTR,
the frequency scale will range from 0 to *sf*/2 when *output* is
displayed with *waves*+. (If the output *freq_format* is ARB_FIXED, *sf*
plays no role in setting the frequency scale, which is determined by an
explicit list of values in the header instead---see the **-F** and
**-v** options.) If the option argument is 0 (the default), the
generic's value is set to 2\*(*size* - 1), where *size* is the size of
the input field *fea_field* (this is done so that the implicit
"frequencies" correspond to element number in the input field).

**-v** *freqs* **\[(none)\]**  
A list of frequencies to be stored as the value of the generic header
item *freqs* in the output file (see *FEA_SPEC*(5-ESPS)). This option is
ignored unless the *freq_format* of the output file is specified as
ARB_FIXED, either with the **-F** option or with the *freq_format*
parameter in a parameter file. The format of the argument is a list of
real numbers, separated by commas or blanks. If blanks are present, they
must be escaped with back slashes (\\, or the argument must be enclosed
in double quotes (").

**-x** *debug_level* **\[0\]**  
Print diagnostic messages as program runs (for debugging purposes only).
Higher levels give more messages. The default level of zero suppresses
all debugging messages.

**-F** *freq_format* **\[SYM_EDGE\]**  
The value to assign to the *freq_format* generic header item in the
output file (see *FEA_SPEC*(5-ESPS)). Currently supported values are
SYM_EDGE and ARB_FIXED (case-insensitive). If ARB_FIXED is specified, a
list of frequency values must be given also, either with the **-v**
option or with the *freqs* parameter in a parameter file.

**-P** *params* **\[params\]**  
Specifies the name of the parameter file.

**-R**  
Reverse the order of elements in the *fea_field* before writing to
*output*. This is useful if you want to invert the orientation of the
display shown when *output* is displayed with *waves*+.

**-S**  
Do not scale the data. This means that any input range is ignored. The
input data (or the log of the input data, if **-d**) are stored in
*output* with clipping at the output range limits.

# ESPS PARAMETERS

The parameter file does not have to be present, since all the parameters
have default values. The following parameters are read, if present, from
the parameter file:

*field_name - string*  
This is the name of the source field in *input*. The default is "sd".
This parameter is not read if the **-f** option is used.

*freq_format - string*  
The value to assign to the *freq_format* generic header item in the
output file (see *FEA_SPEC*(5-ESPS)). This parameter is not read if the
**-F** command-line option is specified. Currently supported values are
SYM_EDGE (the default) and ARB_FIXED (both case-insensitive). If
ARB_FIXED is specified, a list of frequency values must be given with
the **-v** option or the *freqs* parameter.

*freqs - float array*  
A list of frequencies to be stored as the value of the generic header
item *freqs* in the output file (see *FEA_SPEC*(5-ESPS)). This option is
not read if the **-v** command-line option is specified, and it is
ignored unless the *freq_format* of the output file is specified as
ARB_FIXED with the **-F** option or the *freq_format* parameter.

*start - integer*  
This is the first record of *input* to process. The default is 1. It is
not read if the **-r** option is used.

*nan - integer*  
This is the number of records to process. It is not read if the **-r**
option is used. A value of zero means all subsequent records in the
file; this is the default.

*low_input - string (converted to float)*  
Lower limit of range of input data to scale to the output range. Data
below this value are clipped. If the string "determine from file" is
entered, the limit is determined from the file. This parameter is not
read if the **-i** option is specified. If the command-line option is
not specified and the parameter is not present in the parameter file,
the default used is the minimum value of the input data.

*high_input - string (converted to float)*  
Upper limit of range of input data to scale to the output range. Data
above this value are clipped. If the string "determine from file" is
entered, the limit is determined form the file. This parameter is not
read if the **-i** option is specified. If the command-line option is
not specified and the parameter is not present in the parameter file,
the default used is the maximum value of the input data.

*low_output - float*  
Lower limit of range of output data. Data in the input range are scaled
to the output range. This parameter is not read if the **-o** option is
specified. If the command-line option is not specified and the parameter
is not present in the parameter file, the default used is -64.

*high_output - float*  
Upper limit of range of output data. Data in the input range are scaled
to the output range. This parameter is not read if the **-o** option is
specified. If the command-line option is not specified and the parameter
is not present in the parameter file, the default used is +50.

*sf - float*  
Specifies the value to be used for the generic header item *sf* in
*output*. As a result, if the frequency format of *output* is SYM_CTR,
the frequency scale will range from 0 to *sf*/2 when *output* is
displayed with *waves*+. (If the output *freq_format* is ARB_FIXED, *sf*
plays no role in setting the frequency scale, which is determined by an
explicit list of values in the header instead---see the parameters
*freq_format* and *freqs.*) If the parameter value is 0 (the default),
the generic's value is set to 2\*(*size* - 1), where *size* is the size
of the input field *fea_field* (this is done so that the "frequencies"
correspond to element number in the input field). This parameter is not
read if the option -**s** is used.

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

> This is the name of the program ("tofspec" in this case).
>
> *filename - string*

> The name of the input file *input*.

# ESPS HEADERS

The *output* header is a FEA_SPEC file header. The generic items *start*
and *nan* are written to store the range of input data records
processed. The items *low_input, high_input,* low_output, and
*high_output* are written to record the range of input data that was
transformed to the output data. If the **-d** was used the log of the
input range limits are also written as generics *log_low_input* and
*log_high_input*.

The generic header item *start_time* is written in the output file. The
value written is computed by taking the *start_time* value from the
header of the input file (or zero, if such a header item doesn't exist)
and adding to it the relative time from the first record in the file to
the first record processed. The computation of *start_time* depends on
the value of the generic header item *record_freq* in the input file. If
this item is not present, *start_time* is just copied from the input
file to the output file.

The generic header item *sf* is written in the output file; the value is
specified by the parameter *sf* or the value given in the **-s** option.
See the discussions of the parameter and the option for details.

If the input file is tagged, then the output, and the generic header
item *src_sf* is written in the output file header. In that case, the
value of *src_sf* is copied from the input if the input header contains
a *src_sf* item; otherwise the values is taken from *sf* in the input
header. (A warning message is printed if a tagged input file has neither
*src_sf* nor *sf* in its header.)

As usual, the command line is added as a comment and the header of
*input* is added as a source file to *output*.

# SEE ALSO

    FEA_SPEC(5-ESPS), xwaves(1-ESPS), addfea(1-ESPS),
    addfeahd(1-ESPS), FEA(5-ESPS), image(1-ESPS),
    plotsgram(1-ESPS)

# WARNINGS AND DIAGNOSTICS

*tofspec* will exit with an error message if any of the following are
true: the **-d** is used and any of the input data are not positive;
*input* does not exist or is not an ESPS FEA file; the data field does
not exist in *input;*

# BUGS

None known.

# AUTHOR

Manual page and program by John Shore.
