# NAME

copysd - copy portions of sampled data files to a new file (with scaling
and type change)

# SYNOPSIS

**copysd** \[ **-a** *add_constant* \] \[ **-d** *data_type* \] \[
**-o** \] \[ **-g** \] \[ **-p** *range* \] \[ **-r** *range* \] \[
**-s** *scale* \] \[ **-x** *debug_level* \] \[ **-S** *time_range* \]
\[ *file1* \[ *file2 ...* \] \] *outfile*

# DESCRIPTION

*Copysd* copies selected portions of sampled data files into a new
sampled data file. In addition to the range of points that are copied,
*copysd* allows the user to change the data type as well as to apply
multiplicative and additive scale factors. Allowable output data types
that can be specified are bytes, shorts, longs, float, double,
byte_cplx, short_cplx, long_cplx, float_cplx, and double_cplx; the
default data type of the output file is that of the first input file.

If an input file name is "-", stdin is read; similarly, if *outfile* is
"-", the output is written to stdout. If only a single input file is
involved, it may be omitted from the command line, in which case
*copysd* gets its name from ESPS Common (see EXAMPLES).

When a floating type is converted to an integer type, the values are
rounded. When a complex type is converted to a real type, the imaginary
part is discarded. Values that are too large to represent in the output
data type are clipped, and no warning is given.

For appending to an existing FEA_SD file, use *copysps* (1-ESPS).

# OPTIONS

The following options are supported:

**-a** *add_constant \[0\]*  
The argument *add_constant* is a float value that is added to samples
before they are written to the output.

**-d** *data_type*  
The argument representing the desired output data type in *outfile* :
byte, short, long, float, double, byte_cplx, short_cplx, long_cplx,
float_cplx, and double_cplx.

**-g**  
By default, generic header items are not copied from the input files to
the output file, except for *record_freq*. The item *start_time* is
computed and filled in. If the **-g** option is used, then all generic
are copied from the first input file to the output file. Note that this
might result in some of these values not being valid over the range of
data copied. This program has no way of knowing the semantics of generic
header items.

**-o**  
Normally the ESPS headers from the input files are copied into the
header of the new output file as source files. If the **-o** is
specified, the input files' headers are not stored in the output file.

**-p** *range*  
**-p** is a synonym for **-r**.

**-r** *first:last*  
**-r***"***first:+incr**  
Determines the range of points to be copied from each input file (same
range for all input files). In the first form, a pair of unsigned
integers gives the first and last points of the range. If *first* is
omitted, 1 is used. If *last* is omitted, the last point in the file is
used. The second form is equivalent to the first with *last = first +
incr .* To specify a range in seconds, use **-S** (see below) instead of
**-r** or **-p**.

**-s** *scale \[1\]*  
The argument *scale* is a float value by which the input samples are
multiplied before being written to the output.

**-x** *debug_level*  
If *debug_level* is positive, *copysd* prints progress and diagnostic
messages. Debug levels 1-3 are defined - the higher the number, the more
verbose the messages. The default level is zero, which causes no debug
output.

**-S** *start_time:end_time*  
**-S** *start_time:+time_incr*  
**-S** is similar to **-p** and **-r**, except that the range limits are
interpreted as times (in seconds). If *start_time* is omitted, it is set
to the value of the *start_time* generic header item. If *end_time* is
omitted, it is set to the time corresponding to the end of the file. No
more than one of the options **-p**, **-r**, and **-S** should be used.

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

The following items are read from the ESPS Common File provided that
only one input file or no input file is given on the command line and
provided that standard input isn't used.

> *filename - string*

> This is the name of the input file. If no input file is specified on
> the command line, *filename* is taken to be the input file. If an
> input file is specified on the command line, that input file name must
> match *filename* or the other items (below) are not read from Common.

> *start - integer*

> This is the starting point in the input file to begin copying. It is
> not read if the **-p**, **-r**, or **-S** option is used.
>
> *nan - integer*

> This is the number of points to copy from the input file. It is not
> read if the **-p**, **-r**, or **-S** option is used. A value of zero
> means the last point in the file.

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

> This is the name of the program (*copysd* in this case).
>
> *filename - string*

> The name of the input file. If multiple input files are processed,
> this is the name of the first file.

These items are not written to ESPS COMMON if the output file is
\<stdout\>.

# ESPS HEADERS

Items in the FEA_SD header of *outfile* are set as follows:

    record_freq"=samplingfrequencyofinputfiles(mustbesameinall)

The generic header item *start_time* (type DOUBLE) is written in the
output file. The value written is computed by taking the *start_time*
value from the header of the first input file (or zero, if such a header
item doesn't exist) and adding to it the offset time (from the beginning
of the first input file) of the first point copied. If the **-s** option
is used, the corresponding *scale* is written as the generic
*scale_factor*. If the **-a** option is used, the corresponding
*add_constant* is written as the generic *add_constant*.

# EXAMPLES

In this example, a range of sampled data is selected from a plot of
*file.sd* and then copied to another file *segment.sd* (*copysd* gets
the file name and range from ESPS Common):


        %plotsd file.sd
        %range
        %copysd segment.sd

In this example, some Gaussian noise is added to an existing file
*d1.sd*, and the results are copied, together with the contents of two
other sampled data files, to the file *combined.sd*:


        %testd -Tgauss - | addsd - d1.sd - | copysd - d2.sd d3.sd combined.sd

# SEE ALSO

    copysps(1-ESPS), FEA_SD(5-ESPS), ESPS(5-ESPS), 
    testsd(1-ESPS), setmax(1-ESPS), feafunc (1-ESPS)

# BUGS

It would have been better if **-S** had been lower case (consistent with
other ESPS programs), but we left **-s** for scaling so as to not break
old programs. The result is error prone. As a precaution, a warning
message is issued if a ':' is used in the argument to **-s**.

# AUTHOR

Alan Parker, John Shore\
