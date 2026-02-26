# NAME

setmax - find maximum sampled data value and store in max_value FEA_SD
header item

# SYNOPSIS

**setmax** \[ **-x** *debug_level* \] *input output*

# DESCRIPTION

*Setmax* takes a single-channel, real, FEA_SD file *input*, finds the
maximum and miminum values in the file, and produces an output FE_SD
file that duplicates *input*, but has the correct value stored in the
*max_value* generic in the file header. The value stored in *max_value*
is the larger of the absolute values of the minimum and maximum. The
principal use of *setmax* is to pre-process files to be played with a
D/A conversion program that can scale the data to use the maximum output
range. (Most ESPS processing programs do not fill in the generic header
item *max_value*, as headers usually are written before the data are
processed.)

If *input* is "-" then the input is read from the standard input. This
is somewhat less efficient than is the case when *input* is a disk file
because *setmax* has to store the data from *input* in a temporary file.
If *output* is "-" then the output is directed to the standard output.

# OPTIONS

The following options are supported:

**-x** *debug_level* **\[0\]**  
A positive value specifies that debugging output be printed on the
standard error output. Larger values result in more output. The default
is 0, for no output.\

# ESPS PARAMETERS

A parameter file is not read by *setmax*.

# ESPS COMMON

ESPS Common is not read by *setmax*.

# ESPS HEADER

The file header for *output* is created from the input header by means
of *copy_header*. Thus, for example, all of the generic header items are
copied over.

# SEE ALSO

    copysd(1-ESPS), play(1-ESPS), copy_header(3-ESPS),
    FEA_SD(5-ESPS)

# BUGS

Multi-channel or complex FEA_SD files are not handled.

# AUTHOR

Man page and program by John Shore.
