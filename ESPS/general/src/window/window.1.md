# NAME

window - windows sampled data in FEA records

# SYNOPSIS

**window** \[ **-P** *params* \] \[ **-f** *sd_field* \[ **-f**
*power_field* \] \[ **-r** *range* \] \[ **-l** *window_len* \] \[
**-w** *window_type* \] \[ **-x** *debug_level* \] *input output*

# DESCRIPTION

*Window* accepts a FEA file *input* containing a vector sampled-data
field in each record. It produces a FEA file *output* with records
containing the results of applying a fixed window to the input
sampled-data field. Each field of sampled data may be thought of as a
separate frame of data, such as might be produced by *frame* (1-ESPS).
The default name for the sampled data field in *input* is *sd*, and the
default name for the window field in *output* is *wind_sd*. Both
defaults can be changed by means of the **-f** option. If the input is
tagged or segment labelled, the relevant information is copied over to
the output. If *input* is "-", standard input is used for the input
file. If *output* is "-", standard input is used for the output file.

The window is computed using *window* (3-ESPS). The fixed window length
*window_len* must not be larger than the size of the sampled data field.
If it is smaller, zeros are filled to the end of the field. All of the
first *window_len* elements in each input field are processed. If
*input* is segment-labelled, *window* warns if any of the
*segment_length* values are less than *window_len*. (This may be
intentional, so it would be too verbose to identify each such frame.
They may, however, be identified using *select* (1-ESPS).)

Note that windowed FEA sampled data records can also be produced by
*frame* (1-ESPS). *Window* is intended for occasions when it is
appropriate to defer windowing because of intermediate processing.

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
name of the window field in *output*. The default names for these fields
are "sd" and "wind_sd", respectively.

**-l** *window_len* **\[0\]**  
Specifies the window length. If the option is omitted, the parameter
file is consulted. A value of 0 (from either the option or the parameter
file) indicates that the window length is the size of the sampled data
field in *input*. This is also the default value in case *window_len* is
not specified either with the **-l** option or in the parameter file.

**-w** *window_type***\[RECT\]**  
The name of the data window to apply to the data in each frame before
computing reflection coefficients. If the option is omitted, the
parameter file is consulted, and if no value is found there, the default
used is a rectangular window with amplitude one. Possible window types
include rectangular ("RECT"), Hamming ("HAMMING"), and triangular
("TRIANG"); see the window(3-ESPSsp) manual page for the complete list
of supported window types.

If the **-w** specified value is not a supported window type, it is
assumed to be the name of an ascii file containing weighting function
values. If no file by this name exists, *window* (1-ESPS) warns and
exits. Otherwise the file is read, the weighting values are saves, and
the number of weighting values is counted (*window_len*). In this case,
the *window_len* value from either the **-l** option or the specified
*params* file is ignored. The same rules about *window_len* as described
above in **DESCRIPTION** are in effect.

# ESPS PARAMETERS

The parameter file does not have to be present, since all the parameters
have default values. The following parameters are read, if present, from
the parameter file:

*sd_field_name - string*  
> This is the name of the sampled data field in *input*. The default is
> "sd". A paramter file value (if present) is overidden by the first use
> of the **-f** option.

*wind_field_name - string*  
> This is the name of the windowed sampled data field in *output*. The
> default is "wind_sd". A paramter file value (if present) is overidden
> by the second use of the **-f** option.

*start - integer*  
> This is the first record of *input* to process. The default is 1. It
> is not read if the **-r** option is used.

*nan - integer*  
> This is the number of records to process. It is not read if the **-r**
> option is used. A value of zero means all subsequent records in the
> file; this is the default.

*window_len - integer*  
> The window size. This parameter is not read if the **-l** option is
> specified. A value of 0 indicates that the window length is the size
> of the sampled data field in *input*; this is also the default value
> in case *window_len* is specified neither with the **-l** option nor
> in the parameter file.

*window_type - string*  
The data window to apply to the data. This parameter is not read if the
command-line option **-w** is specified. If the option is omitted and if
no value is found in the parameter file, the default used is "RECT", for
a rectangular window with amplitude one. If the specified value is not a
supported window type, it is assumed to be a user-defined window
function. See the discussion of the **-w** option.

Remember that command line option values override parameter file values.

# ESPS COMMON

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

ESPS Common is not processed by *window* if *input* is standard input.
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

> This is the name of the program (*window* in this case).
>
> *filename - string*

> The name of the input file *input*.

# ESPS HEADERS

The *output* header is a new FEA file header. If it exists in the input
header, the generic header item *src_sf* is copied from input to output.
Following the convention from *frame* (1-ESPS), this generic is intended
to contain the sampling rate of the original sampled data. The generic
header item *start_time* is written with a value computed by taking the
*start_time* value from the header of the input file (or zero, if such a
header item doesn't exist) and adding to it the relative time from the
first record in the file to the first record processed. The computation
of *start_time* depends on the value of the generic header item
*record_freq* in the input file. If this item is not present,
*start_time* is just copied from the input file to the output.

The items *start* and *nan* are rewritten (if they already exist) to
contain the starting record number and number of records processed.
Generic header items are added for the *window_len* and *window_type*.
As usual, the command line is added as a comment and the header of
*input* is added as a source file to *output*.

# FUTURE CHANGES

Control over the type of the output windowed sampled data field.

# SEE ALSO

*frame* (1-ESPS), window (3-ESPS), *pwr* (1-ESPS), FEA (5-ESPS),
*make_sd* (1-ESPS), *plotfield* (1-ESPS)

# WARNINGS AND DIAGNOSTICS

*window* will exit with an error message if any of the following are
true: *input* does not exist or is not an ESPS FEA file; the
sampled-data field does not exist in *input;* the window field already
exists in *input;* the *window_len* is larger than the size of the
*input* sampled data field.

# BUGS

None known.

# AUTHOR

Manual page and program by John Shore.
