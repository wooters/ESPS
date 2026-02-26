# NAME

zcross - computes average zero-crossing rate for sampled data in FEA
records

# SYNOPSIS

**zcross** \[ **-P** *params* \] \[ **-f** *sd_field* \[ **-f**
*zeros_field* \]\] \[ **-r** *range* \] \[ **-x** *debug_level* \]
*input output*

# DESCRIPTION

*Zcross* accepts a FEA file *input* containing a vector sampled-data
field in each record. It produces a FEA file *output* with records
containing the average zero-crossing rate of the sampled-data field from
that record. Each field of sampled data may be thought of as a separate
frame of data, such as might be produced by *frame* (1-ESPS). The
default name for the sampled data field in *input* is *sd*, and the
default name for the zero-crossing field in *output* is
*zero_cross_rate*. Both defaults can be changed by means of the **-f**
option. If *input* is "-", standard input is used for the input file. If
*output* is "-", standard input is used for the output file.

The zero-crossing rate is computed by multiplying the number of zero
crossings by the sampling frequency and dividing by the number of
samples in the frame. Thus, the units are zero-crossings per second. If
*input* is not a segment-labelled FEA file (see FEA (5-ESPS)), the frame
is considered to comprise all of the points in the sampled data field,
so the frame length is a constant set to the size of the sampled data
field (which can be determined from the file header). If *input* is
segment-labelled, the size of the sampled data field is really a maximum
size, and the frame size for a particular record is given by the
*segment_length* field (this field is always present in segment-labelled
files). Thus, for segment-labelled files, the frame from any input
record is the first *segment_length* points of the sampled data field.

The sampling frequency is determined by the generic header item *src_sf*
from *input*. If this generic header item doesn't exist, the sample
frequency is set to 1 so that the zero-crossing rate is reported in
units of crossings per sample. (Note that you can always use *addgen*
(1-ESPS) to put in the correct sampling frequency if it is missing.)

# OPTIONS

The following options are supported:

**-P** *param* **\[params\]**  
Specifies the name of the parameter file.

**-r** *start***:***last* **\[1:(last in file)\]**  
**-r** *start***:+***nan*  
In the first form, a pair of unsigned integers specifies the range of
records to be processed. Either *start* or *last* may be omitted; then
the default value is used. If *last* = *start* + *nan,* the second form
(with the plus sign) specifies the same range as the first. The **-r**
overrides the values of *start* and *nan* from the parameter file.

**-f** *field_name*  
If this option is used once, it specifies the name of the sampled data
field in *input*. If it is used twice, the second time it specifies the
name of the power field in *output*. The default names for these fields
are "sd" and "zero_cross_rate", respectively.

# ESPS PARAMETERS

The parameter file does not have to be present, since all the parameters
have default values. The following parameters are read, if present, from
the parameter file:

> *sd_field_name - string*

> This is the name of the sampled data field in *input*. The default is
> "sd". A parameter file value (if present) is overridden by the first
> use of the **-f** option.

> *zcross_field_name - string*

> This is the name of the raw power field in *output*. The default is
> "zero_cross_rate". A parameter file value (if present) is overridden
> by the second use of the **-f** option.

> *start - integer*

> This is the first record of *input* to process. The default is 1. It
> is not read if the **-r** option is used.
>
> *nan - integer*

> This is the number of records to process. It is not read if the **-r**
> option is used. A value of zero means all subsequent records in the
> file; this is the default.

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

ESPS Common is not processed by *zcross* if *input* is standard input.
Otherwise, provided that the Common file is newer than the parameter
file, and provided that the *filename* entry in Common matches *input*,
the Common values for *start* and *nan* override those that may be
present in the parameter file.

The following items are written into the ESPS Common file provided that
*output* is not \<stdout\>.

> *start - integer*

> The starting point from the input file.
>
> *nan - integer*

> The number of points in the selected range.
>
> *prog - string*

> This is the name of the program (*zcross* in this case).
>
> *filename - string*

> The name of the input file *input*.

# ESPS HEADERS

The *output* header is a new FEA file header. If the generic header item
*src_sf* exists in the input file, it is copied to the output file if it
exists (otherwise it is set to 1). The items *start* and *nan* are
written to contain the starting record number and number of records
processed.

The size of the input sampled data field is written to the generic
*frmlen*.

The generic header item *start_time* is written in the output file. The
value written is computed by taking the *start_time* value from the
header of the input file (or zero, if such a header item doesn't exist),
adding to it the relative time from the first record in the file to the
first record processed, and adding a displacement corresponding to half
of *frmlen*. The computation of *start_time* depends on the value of the
generic header item *src_sf* in the input file (which is assumed to be
the sampling rate of the actual data in each field). If this item is not
present, *start_time* is just copied from the input file to the output
file.

As usual, the command line is added as a comment and the header of
*input* is added as a source file to *output*. Another comment gives the
name of the field added by *zcross*.

# FUTURE CHANGES

Control over the type of the output power field.

# SEE ALSO

*frame* (1-ESPS), FEA (5-ESPS), *fea_stats* (1-ESPS), *pwr* (1-ESPS),
*window* (1-ESPS), *addgen* (1-ESPS), *stats* (1-ESPS)

# WARNINGS AND DIAGNOSTICS

*zcross* will exit with an error message if any of the following are
true: *input* does not exist or is not an ESPS FEA file; the
sampled-data field does not exist in *input;* the power field already
exists in *input.*

*Zcross* will warn if the generic *src_sf* doesn't exist in *input*.

# BUGS

None known.

# AUTHOR

Manual page and program by John Shore.
