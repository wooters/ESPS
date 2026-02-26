# NAME

hdshrink - remove the recursive headers from an ESPS file

# SYNOPSIS

**hdshrink** \[ **-c** \] *in_file out_file*

# DESCRIPTION

*Hdshrink* takes an ESPS file *in_file* and copies all the data records
and only the top level header into the output file *out_file.* It is
normally used to remove embedded headers from a file in which the
complete processing history is not important.

If *in_file* is replaced by "-", standard input is used; if *out_file*
is replaced by "-", standard output is used.

# OPTIONS

The following options are supported:

**-c**  
If this options is given, then all of the comments in the embedded
headers are brought up to the main header. In this way, some processing
history is preserved.

# ESPS PARAMETERS

The parameter file is not accessed.

# ESPS COMMON

ESPS Common is not used.

# ESPS HEADER

All input file header items are copied to the output file header.

# SEE ALSO

bhd(1-ESPS)

# BUGS

None known.

# AUTHOR

Manual page by David Burton; program by Alan Parker.
