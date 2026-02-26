# NAME

e2sphere - convert ESPS FEA_SD sampled data files to Sphere (NIST)
format

# SYNOPSIS

**e2sphere** \[ **-b** *sample_byte_format* \] \[ **-x** *debug_level*
\] *in.sd out.sphere*

# DESCRIPTION

*e2sphere* converts a single-channel, non-complex FT_SD or FEA_SD file
*in.sd* to Sphere format and writes the result to *out.sphere*. The
input data can be any type, but are converted to SHORT before output to
*out.sphere*.

All scalar generic header items from *in.sd* are reproduced as sphere
header items in the header of *out.sphere*. Note that CODED generics
from *in.sd* are converted as integers. In addition, the Sphere header
items *channel_count, sample_count,* sample_rate, sample_min,
sample_max, sample_n_bytes, sample_byte_format, and *sample_sig_bits*
are included in the output header.

If *in.sd* "-" then the input is read from the standard input. If
*out.sphere* is "-" then the output is directed to the standard output.

*e2sphere* makes two passes over the data, once to find values for
*sample_min* and *sample_max*, and once to copy the data (with
appropriate conversions) from *in.sd* to *out.sphere*. If the input is
stdin, a temporary file is created to permit the second pass.

# OPTIONS

The following options are supported:

**-b** *sample_byte_format* **\[10\]**  
Specifies the desired byte order in *out.sphere*. Only "10" or "01" are
permitted. If the value is "01", the data are byte-reversed before
output.

**-x** *debug_level* **\[0\]**  
A positive value specifies that debugging output be printed on the
standard error output. Larger values result in more output. The default
is 0, for no output.\

# ESPS PARAMETERS

A parameter file is not read by *e2sphere*.

# ESPS COMMON

ESPS Common is not read by *e2sphere*.

# ESPS HEADER

All scalar generic header items from *in.sd* are reproduced as sphere
header items in the header of *out.sphere*.

# SEE ALSO

*btosps* (1-ESPS), *addfeahd* (1-ESPS), sd_to_sphere (3-ESPS)

# BUGS

Multi-channel files are not supported; output as FLOAT data is not
supported.

# AUTHOR

Man page and program by John Shore.
