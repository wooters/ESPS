# NAME

addsd - add ESPS sampled data files with optional scaling\
multsd - multiply ESPS sampled data files with optional scaling

# SYNOPSIS

**addsd** \[ **-x** *debug_level* \] \[ **-r** *range* \] \[ **-p**
*range* \] \[ **-g** *scale* \] \[ **-z** \] \[ **-t** \] *file1 file2
file3*\
**multsd** \[ **-x** *debug_level* \] \[ **-r** *range* \] \[ **-p**
*range* \] \[ **-g** *scale* \] \[ **-z** \] \[ **-t** \] *file1 file2
file3*

# DESCRIPTION

*addsd* (1-ESPS) and *multsd* (1-ESPS) are the same binary file. The
function the program does (either adding or multiplying) depends on the
name that is used to call it. The options and syntax are the same for
both adding and multiplying. Because the calling name is used in the
program logic, both *addsd* (1-ESPS) and *multsd* (1-ESPS) cannot be
linked or copied to new names. Below only *addsd* (1-ESPS) is described,
but the description of *multsd* (1-ESPS) is completely analogous.

*Addsd* takes sampled data from *file1,* adds it sample-by-sample to the
sampled data in *file2,* possibly scaling the data in *file2* first, and
outputs the results as an ESPS FEA_SD file *file3.* If there are not
enough records in *file2,* and if the **-t** option is not used, *addsd*
reuses *file2,* starting with its first record.

Both *file1* and *file2* must be ESPS FEA_SD files, and they must have
the same sampling frequency (record_freq); otherwise *addsd* exits with
an error message. The output file data type is selected to "cover" the
two input data types. That is, all values of the input types can be
stored in the output type. For example, if one file is type SHORT_CPLX
and the other is type FLOAT, the output type is FLOAT_CPLX. If "-" is
supplied in place of *file1,* then standard input is used. If "-" is
supplied in place of *file3,* standard output is used.

# OPTIONS

The following options are supported:

**-x** *debug_level*  
If *debug_level* is positive, *addsd* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0, no messages are
printed. The default is 0. Levels up through 2 are supported currently.

**-p** *range*  
Selects a subrange of records from *file1* using the format *start-end*
or *start:end*. Either *start* or *end* may be omitted, in which case
the omitted parameter defaults respectively to the start or end of
*file1.* The first record in *file1* is considered to be frame 1,
regardless of its position relative to any original source file. The
default range is the entire input file *file1.* The selected subrange
from *file1* is then added to the (possibly scaled) data from the
*file2,* starting with the first record of *file2.* If the subrange does
not exist in *file1, addsd* exits with an error message.

**-r** *range*  
**-r** is a synonym for **-p**.

**-g** *scale*  
Causes *addsd* to multiply the data in *file2* by *scale* before adding
it to the data in *file1.* The format for *scale* is either integer or
floating point.

**-z**  
Supresses warning messages that normally are generated if the contents
of *file2* are used more than once.

**-t**  
Truncates the processing if there are not enough records in *file2.* In
this case, *file3* will contain as many records as there are in *file2*
or, if the **-p** option is used, as many records as in the intersection
of *range* and the full range of *file2.*

# ESPS PARAMETERS

The ESPS parameter file is not read by *addsd.*

# ESPS COMMON

If Common processing is enabled, the following items are read from the
ESPS Common File provided that *file1* is not standard input, and
provided that the Common item *filename* matches the input file name
*file1*:

> *start - integer*

> This is the starting point in *file1*.
>
> *nan - integer*

> This is the number of points to add from *file1*.
>
> If *start* and/or *nan* are not given in the common file, or if the
> common file can't be opened for reading, then *start* defaults to the
> beginning of the file and *nan* defaults to the number of points in
> the file. In all cases, values of *start* and *nan* are ignored if the
> **-p** is used.

If Common processing is enabled, the following items are written into
the ESPS Common file provided that the output file is not \<stdout\>:

> *start - integer*

> The starting point (1) in the output file *file3.*
>
> *nan - integer*

> The number of points in the output file *file3*
>
> *prog - string*

> This is the name of the program (*addsd* in this case).
>
> *filename - string*

> The name of the output file *file3.*

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to **off**. The default ESPS Common file is
*.espscom* in the user's home directory. This may be overidden by
setting the environment variable ESPSCOM to the desired path. User
feedback of Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

The following items are copied from the header of *file1* to the header
of *file3:*

> 
>
>     variable.comment
>     variable.refer
>     record_freq

If the **-g** option is used, a generic header item *scale* is added to
the output file header that contains the **-g** specified value.
*Max_value* in *file3* is not set.

The generic header item *start_time* is written in the output file. The
value written is computed by taking the *start_time* value from the
header of the first input file (or zero, if such a header item doesn't
exist) and adding to it the relative time from the first record in the
file to the first record processed.

# SEE ALSO

    ESPS (5-ESPS), FEA_SD (5-ESPS), record (1-ESPS), copysd (1-ESPS)

# WARNINGS

If there are not enough records in *file2* - i.e., if *addsd* has to
start over at the beginning of *file2,* - a warning message is printed.
This warning is inhibited by the **-z** option, and does not apply if
**-t** is used.

# BUGS

None known.

# AUTHOR

Ajaipal S. Virdy.\
Modified for ESPS 3.0 by David Burton and John Shore.\
Modified for FEA_SD by David Burton.\
Modified to support multiplication by David Burton.
