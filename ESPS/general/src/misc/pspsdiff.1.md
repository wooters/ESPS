# NAME

pspsdiff - differential ESPS file comparator

# SYNOPSIS

**pspsdiff** \[ **-aDghHlvx** \] \[ **-r***start:end* \] \[ **-t***tag*
\] \[ **-f***field_name* \] *file1 file2*

# DESCRIPTION

*Pspsdiff* is a shell script which compares the *psps*(1-ESPS) listings
of two ESPS files. All options of *psps*(1-ESPS) are supported. Diff(1)
is used to print the output on stdout.

# OPTIONS

**-a**  
Compare every parameter in every subheader. Use of this option along
with **-v** forces comparison of all information contained in the two
ESPS files.

**-D**  
Suppress printing of data records. Compares header information only.

**-f** *field_name*  
Compares only the feature file field that matches the given field name.
A warning is printed on stderr if the requested field name does not
exist. This option may be specified as often as desired.

**-g**  
Comparison is made by printing the ESPS files in a generic format.

**-h**  
Compare the common part of all embedded headers in the file.

**-H**  
Suppress comparison of header information. Compares record information
only.

**-l**  
Compare all the parameters in the header of the file, except for
included subheaders.

**-r** *start:end*  
**-r***"***start:+incr**  
Determines the range of data records to compare. In the first form, a
pair of unsigned integers gives the first and last points of the range.
If *start* is omitted, 1 is used. If *end* is omitted, the last point in
the file is used. The second form is equivalent to the first with *end =
start + incr .*

**-t** *tag*  
Only compare the data record with the corresponding tag. A warning
message is printed if this option is specified and the data is not
tagged. This option may be specified as many times as desired.

**-v**  
This option enables comparison of feature file field definitions.
Otherwise feature file field definitions are not compared, even if the
**-l** option is used. Using this option also sets the **-l**. Use of
this option along with **-a** forces comparison of all information
contained in the two ESPS files.

**-x**  
Compare debug output.

# BUGS

Options that take an argument (i.e., **-f**, **-r**, and **-t**) require
a space between the option and the argument.

# DIAGNOSTICS

The program bombs if the specified files does not exist, or if the files
are not ESPS files.

# SEE ALSO

diff(1), psps(1-ESPS)

# AUTHOR

Ajaipal S. Virdy, Entropic Speech, Inc.
