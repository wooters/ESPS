# NAME

setrange - put range in records or seconds in Common; allow conversion
from seconds

# SYNOPSIS

**setrange** \[ **-x** *debug_level* \] \[ **-P** *param_file* \] \[
**-{prs}** *range* \] \[ **-z** \] *esps_file*

# DESCRIPTION

*Setrange* takes a range of time (specified in seconds), converts it to
a range of records in the ESPS FEA file *esps_file*, and leaves the
sample range in ESPS Common. Note that *setrange* takes into
consideration the value of the *start_time* generic, if it exists. (That
is, the times specified by **-s** are treated as absolute times, not as
times relative to the start of the file.) *Setrange* also takes a range
specified in records, converts it to a range in seconds, and leaves the
time range in ESPS Common. Actually, regardless of whether a time or
record range is given, *setrange* writes Common with range values in
both measurement units.

In computing the range in records, *setrange* uses the generic
*record_freq* (number of records per seconds). This is the sampling rate
for FEA_SD files. If *record_freq* does not exist or is less than or
equal to 0, *setrange* exits with an error message.

Unless the **-z** option is used, *setrange* prints a message giving the
range in points that is stored in ESPS Common.

*Setrange* will work properly with old-style sampled data (SD) files.

*Setrange* is useful when run before other ESPS programs that process
FEA files but that do not permit a range specification in time units. It
is also useful in scripts when one needs to convert in either direction
between range specs in records or time. Future versions of ESPS will
provide a uniform means of specifying ranges as time or samples.
*Setrange* is provided as interim support.

# OPTIONS

The following options are supported:

**-x** *debug*  
Only debug level 1 is defined in this version. This causes several
messages to be printed as internal processing proceeds. The default is
level 0, which causes no debug output.

**-P** *param_file*  
uses the parameter file *param_file* rather than the default, which is
*params.*

**-s** *first***:***last*  
**-s** *first***:+***incr*  
Specifies in units of time (seconds) the range of sampled data in
*esps_file*. In the first form, a pair of unsigned integers specifies
the range. If *last* = *first* + *incr,* the second form (with the plus
sign) specifies the same range as the first two forms. If *first* is
omitted, the default value of 0 is used. If *last* is omitted, then the
end of the file is assumed. The beginning of *esps_file* is treated as 0
seconds.

**-{p}** *first***:***last* **\[1:(last in file)\]**  
**-{p}** *first***:+***incr*  
**-{r}** *first***:***last* **\[1:(last in file)\]**  
**-{r}** *first***:+***incr*  
Specifies in units of points the range of sampled data in the
*esps_file*. In the first form, a pair of unsigned integers gives the
first and last points of the range, counting from 1 for the first point
in the file. If *first* is omitted, 1 is used. If *last* is omitted, the
range extends to the end of the file. The second form is equivalent to
the first with *last = first + incr .* This option should not be
specified if **-s** is specified. If neither option is specified, the
range is determined by the parameters *start_s* and *nan_s* as read from
the parameter file. If either parameter is missing from the parameter
file, it is determined by default. Note that **-p** and **-r** are
synonyms.

**-z**  
Suppress output message giving range of sampled data points.

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
parameter values that apply. If the parameter file does exist, the
following parameters are read:

*start_s - float*  
> The starting point to be processes (in seconds). A value of 0 denotes
> the start of the file. This parameter is read only if the no range
> option is used. If it is not in the parameter file, the default value
> of 0 is used.

*nan_s - float*  
> The total number of seconds in the range. If *nan_s* is 0, the whole
> file is processed. This parameter is read only if the no range option
> is used. If it is not in the parameter file, the default value of 0 is
> used.

# ESPS COMMON

ESPS Common is not read.

The following items are written into the ESPS Common file:

> *start - integer*

> The starting sample number in *esps_file*.

> *nan - integer*

> The number of samples in the selected range.

> *start_s - float*

> The starting time (seconds) in *esps_file*.

> *end_s - float*

> The ending time (seconds) in the selected range.

> *nan_s - float*

> The totoal time (seconds) in the selected range.

> *prog - string*

> This is the name of the program (*setrange* in this case). *filename -
> string*

> The name of *esps_file*.

# ESPS HEADERS

For FEA files, *setrange* makes use of the the generic header items
start_time and record_freq. If the input file is an old style SD, the
header is converted automatically to a FEA_SD header before proceeding
(i.e., the generics don't need to be there in the SD header).

# DIAGNOSTICS

*Setrange* informs the user and exits if *esps_file* does not exist, or
is not an ESPS sampled data file.

If the starting point requested is greater than the last point in
*esps_file*, then a message is printed and the program exits. If the
ending point requested is greater than the last point in *esps_file*, it
is reset to the last point and a warning is printed. continues.

# FILES

# BUGS

# EXPECTED CHANGES

# AUTHOR

Manual page and program by John Shore.
