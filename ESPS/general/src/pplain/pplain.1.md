# NAME

pplain - print values from ESPS file in "plain format"

# SYNOPSIS

**pplain** \[ **-r***range* \] \[ **-e***grange* \] \[
**-f***field_range* \] \[ **-i** \] \[ **-n** \]

file

# DESCRIPTION

*Pplain* prints data values from an ESPS file, without headers or other
extraneous information. ESPS files consist of a series of records; there
may be multiple elements per record. By default, all data from all
records are printed, excluding position tags, if any. Each line of the
output contains the values from a single record, separated by spaces.
*File* must be an ESPS data file. If *file* is "-", then the standard
input is read.

The **-r** option may be used to select a subset of the records in the
file for printing; all range formats accepted by the range_switch
function are legal. In particular, a single integer or two integers
separated by a colon form a legal range.

The **-e** option may be used to select a subset of elements within each
record for printing; if the ESPS file has position tags element 0 may be
specified and refers to the tag, otherwise the first element is
element 1. The range is parsed as a "generic" range. See
*grange_switch(3-ESPS)* for more details. The programs
*gen_element(1-ESPS)* and *fea_element(1-ESPS)* can be used to get
element number information for a file.

The **-f** option can only be used with ESPS feature files. This allows
specifying a feature file field and element range within that field.
Only one **-f** option can be used. To print more than one field (but
not all), use the **-e** option. A *field_range* is a field name,
followed by an optional generic element range in brackets. For example
to print elements 1 through 5, and 7 of field *spec_param* you would use
*-f spec_param\[1-5,7\]*. Since the bracket has special meaning to some
Unix shells, you may have to quote the argument to the **-f** option.

The **-n** option (for native type) may only be used in conjunction with
the **-f** option. It specifies printing the specified field in it's
actual type rather than converting to double and printing. Using this
option will cause any element ranges you specified on the -f option to
be ignored.

The **-i** option causes all printed values to be rounded to the nearest
integer.

# ESPS PARAMETERS

This program does not access the parameter file.

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
standard input isn't used.

> *filename - string*

> This is the name of the input file. If no input file is specified on
> the command line, *filename* is taken to be the input file. If an
> input file is specified on the command line, that input file name must
> match *filename* or the other items (below) are not read from Common.

> *start - integer*

> This is the starting record in the input file to begin printing. It is
> not read if the **-r** option is used.
>
> *nan - integer*

> This is the number of records to print from the input file. It is not
> read if the **-r** option is used. A value of zero means the last
> record in the file.

Again, the values of *start* and *nan* are only used if the input file
on the command line is the same as *filename* in the common file, or if
no input file was given on the command line. If *start* and/or *nan* are
not given in the common file, or if the common file can't be opened for
reading, then *start* defaults to the beginning of the file and *nan*
defaults to the number of records in the file.

The following items are written into the ESPS Common file:

> *start - integer*

> The starting record from the input file.
>
> *nan - integer*

> The number of records in the selected range.
>
> *prog - string*

> This is the name of the program (*pplain* in this case).
>
> *filename - string*

> The name of the input file.

# DIAGNOSTICS

    pplain: file is not an ESPS file.
    pplain: please specify last element explicitly.
    pplain: no tags in file; cannot print element 0.
    pplain: only %d elements per record in file
    pplain: only %d elements in field %s.
    pplain: -f option can only be used with feature files.
    pplain: no such field in file.

    Sphere, esignal, and pc wave file formats are not supported. Use
    "copysps infile - | pplain -" to achieve the same effect.

# BUGS

The **-e** does not work corretly if the file contains fields of a
complex data type. The real and imaginary part of a complex field are
considered separate elements in pplain, even though
*fea_element(1-ESPS)* reports a complex field as one element. This is a
bug and will be resolved.

# EXPECTED CHANGES

# SEE ALSO

*psps* (1-ESPS), *fea_print* (1-ESPS), *fea_element* (1-ESPS)

# AUTHOR

Original program by Joseph T. Buck. Modified by Ajaipal S. Virdy. Native
type printing added by Ken Nelson.
