# NAME

frame - create FEA records containing windowed sampled data frames

# SYNOPSIS

**frame** \[ **-P** *param* \] \[ **-f** *sd_field_name* \] \[ **-{pr}**
*range* \] \[ **-l** *frame_len* \] \[ **-S** *step* \] \[ **-w**
*window_type* \] \[ **-x** *debug_level* \] *input output*

# DESCRIPTION

*Frame* takes a single channel ESPS FEA_SD (sampled data) file, which
contains one sample per record, and produces an ESPS FEA file *output*
with each record containing one frame of *frame_len* samples (see **-l**
option). The initial point of the first frame is determined by the
**-p** option or by *start* in the parameter file. Initial points of any
subsequent frames follow at equal intervals *step* (see **-S** option).
Thus the 3 cases *step* \< *frame_len,* *step* = *frame_len,* and *step*
\> *frame_len,* correspond to overlapping frames, exactly abutted
frames, and frames separated by gaps.

The number of frames is the minimum sufficient to cover a specified
range of *nan* points (see **-p** option), given *frame_len* and *step*.
The last frame in each file may overrun the range, in which case a
warning is printed. If a frame overruns the end of a file, it is filled
out with zeros.

The sampled data in each frame optionally may be windowed using a window
function specified by the **-w** option or by *windown_type* in the
parameter file. To defer window processing, use *window* (1-ESPS).

The output file is not of any special feature-file subtype. It is tagged
FEA file containing a *float* vector field of sampled data of length
*frame_len.* By default, the field name is "sd", but this can be changed
with the **-f** option. The tags in each record give the starting point
of the frame in *input*.

If *input* is "-" then the input is read from the standard input and if
*output* is "-" then the output is directed to the standard output.

# OPTIONS

The following options are supported:

**-P** *param*  
uses the parameter file *param* rather than the default, which is
*params.*

**-f** *sd_field_name \[sd\]*  
Specifies the name of the sampled data field in *output*.

**-{pr}** *first***:***last*  
**-{pr}** *first-last*  
**-{pr}** *first***:+***incr*  
In the first two forms, a pair of unsigned integers specifies the range
of sampled data to analyze. If *last* = *first* + *incr,* the third form
(with the plus sign) specifies the same range as the first two forms. If
*first* is omitted, the default value of 1 is used. If *last* is
omitted, then the entire file is processed. If the specified range
contains points not in the file, zeros are appended. Both forms of the
option override the values of *start* and *nan* in the parameter file or
ESPS Common file. If the **-p** option or **-r** options are not used,
the range is determined from the ESPS Parameter or Common file if the
appropriate parameters are present. Note that **-r** is a synonym for
**-p**.

**-l** *frame_len* **\[0\]**  
Specifies the length of each frame. If the option is omitted, the
parameter file is consulted. A value of 0 (from either the option or the
parameter file) indicates that a single frame of length *nan* (see
**-p**) is processed; this is also the default value in case *frame_len*
is not specified either with the **-l** option or in the parameter file.

**-S** *step* **\[***frame_len***\]**  
Initial points of consecutive frames differ by this number of samples.
If the option is omitted, the parameter file is consulted, and if no
value is found there, a default equal to *frame_len* is used (resulting
in exactly abutted frames). (The same default applies if *step* is given
a value of 0).

**-w** *window_type***\[RECT\]**  
The name of the data window to apply to the data in each frame before
computing reflection coefficients. If the option is omitted, the
parameter file is consulted, and if no value is found there, the default
used is a rectangular window with amplitude one. Possible window types
include rectangular ("RECT"), Hamming ("HAMMING"), Hanning ("HANNING"),
cosine ("COS4"), and triangular ("TRIANG"); see the window(3-ESPSsp)
manual page for the complete list.

**-x** *debug_level* **\[0\]**  
A positive value specifies that debugging output be printed on the
standard error output. Larger values result in more output. The default
is 0, for no output.\

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
parameter values that apply. If the parameter file does exist, the
following parameters are read:

*sd_field_name - string*  
> This is the name of the sampled data field created in *output*. The
> default is "sd". A parameter file value (if present) is overidden by
> the **-f** option.

*start - integer*  
> The first point in the input sampled data file that is processed. A
> value of 1 denotes the first sample in the file. This is only read if
> the **-p** option is not used. If it is not in the parameter (or
> Common) file, the default value of 1 is used.

*nan - integer*  
> The total number of data points to process. If *nan* is 0, the whole
> file is processed. *Nan* is read only if the **-p** option is not
> used. (See the discussion under **-l**).

*frame_len - integer*  
> The number of points in each frame. This parameter is not read if the
> **-l** option is specified. A value of 0 indicates that a single frame
> of length *nan* is processed; this is also the default value in case
> *frame_len* is specified neither with the **-l** option nor in the
> parameter file.

*step - integer*  
Initial points of consecutive frames differ by this number of samples.
This parameter is not read if the **-S** option is specified. If the
option is omitted and no value is found in the parameter file, a default
equal to *frame_len* is used (resulting in exactly abutted frames).

*window_type - string*  
The data window to apply to the data. This parameter is not read if the
command-line option **-w** is specified. If the option is omitted and if
no value is found in the parameter file, the default used is "RECT", for
a rectangular window with amplitude one. Other acceptable values include
"HAMMING", for Hamming, and "TRIANG", for triangular; see the
window(3-ESPSsp) manual page for the complete list.

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

# ESPS COMMON

ESPS Common is read provided that Common processing is enabled and that
the *filename* entry in Common matches *input,* in which case parameters
present in Common override values from the parameter file, which in turn
may be overriden by command line options (see the discussion in ESPS
PARAMETERS and under each option). Common is not read if *input* is
standard input. If *output* is not standard output and *input* is not
standard input, the Common parameters *filename* (= input), *prog* (=
frame), *start,* and *nan* are written to ESPS Common.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADER

A new file header is created for the FEA_ANA file. The sampled data
header from the input header is added as a source in the output file
header, and the command line is added as a comment. Another comment
gives the name of the field created by *frame*. The input file *input*
is set as the reference header for tags.

The program writes the usual values into the common part of the output
header. *Frame* creates and writes the following generic header items in
the output file:


    start = start (LONG)
    nan = nan (LONG)
    frmlen = frame_len (LONG)
    src_sf = sample frequency of input (FLOAT)
    step = step (LONG)
    window_type = window_type (CODED) (not written for RECT window)
    start_time
    record_freq

The value written for *start_time* is computed by taking the
*start_time* value from the header of the input file (or zero, if such a
header item doesn't exist) and adding to it the relative time from the
first record in the file to the first record processed. The generic
header item *record_freq* is the number of output records per second of
input

# SEE ALSO

    pwr(1-ESPS), zcross(1-ESPS),window(1-ESPS), 
    plotsd(1-ESPS), copysd(1-ESPS), copysps (1-ESPS), 
    make_sd(1-ESPS), plotfield(1-ESPS), FEA(5-ESPS), 
    SD(5-ESPS), get_sd_orecf(3-ESPS)

# BUGS

None known.

# FUTURE CHANGES

Allow types other than float for the output field.

# AUTHOR

Man page and program by John Shore (program based on the guts of
cross_cor.c by Rod Johnson)
