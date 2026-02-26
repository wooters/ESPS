# NAME

ils_esps - convert an ILS sampled data file to an ESPS sampled data
file.

# SYNOPSIS

**ils_esps** \[ **-x** *debug_level* \] \[ **-p** *range* \] \[ **-r**
*range* \] \[ **-g** *scale* \] \[ **-h** *size* \] \[ **-d** *type* \]
\[ **-q** *equip* \] *in_file out_file*

# DESCRIPTION

The program *ils_esps* takes the ILS sampled data file *in_file* and
produces the ESPS sampled data file *out_file* (FEA_SD). The data is
scaled by the factor *scale* and printed to the output file in the data
format specified by *type.* If *in_file* is "-" then the standard input
is read. If *out_file* is "-" or left off, the program writes to
standard output.

Prior to any processing, the program checks the ILS file type code to
determine whether the file was produced on another machine that requires
byte swapping. The byte swapping is performed on the file during
processing if necessary. If the appropriate file type code is not
produced by swapping the type code in the ILS header, an error message
is printed to *stderr* and the program exits. *Ils_esps* assumes that
the header data is written in long (32 bit) format and that the data is
written in short (16 bit) format.

# OPTIONS

The following options are supported:

**-x** *debug_level*  
A value of 0 (the default value) will cause *ils_esps* to do its work
silently, unless there is an error. A nonzero value will cause various
parameters to be printed out during program initialization.\

**-r** *range*  
**-p** *range* Selects a subrange of points to be converted, where the
start and end points are defined with respect to the original input ILS
file. The range is specified using the format *start-end* or
*start:end*. Either *start* or *end* may be omitted, in which case the
omitted parameter defaults respectively to the start or end of the input
ILS file. The form *start:+number* and *start-+number* are supported
also. They are both equivalent to *start:start + number.* If the range
runs past the end of the file, the program prints an error message to
the standard error and exits. **p** and **r** are synonyms.

**-g** *scale*  
The integers in the ILS file are multiplied by *scale* before printing
to the output file. The default value for *scale* is 1.0.\

**-h** *size* **\[128\]**  
Specifies the number of items (longs) in the ILS header.\

**-d** *type*  
The data is printed to the ESPS sampled data file in *type* format.
Choices for *type* are 'd' for doubles, 'f' for floats, 'l' for longs,
and 's' for shorts. The default for *type* is 'f'.\

**-q** *equip*  
The specified equipment code is entered in the header of the output
file. Choices for the character string *equip* are "ef12m", "ad12f",
"dsc", "lpa11", and "none". The default for *equip* is "dsc".

# ESPS PARAMETERS

The parameter file is not accessed.

# ESPS COMMON

The Common file is not accessed.

# ESPS HEADER

A new header is created for the output file. The program stores the
source file name in the ESPS header but does not store a source file
header. Other appropriate header items such as *src_sf,* *sf,* and
*equip* are also stored in the ESPS header.

# WARNINGS

Mu law compressed data is not handled by this program. ILS files with 16
bit header items are not handled by this program.

# BUGS

None known.

# AUTHOR

Brian Sublett; modified for ESPS by David Burton.
