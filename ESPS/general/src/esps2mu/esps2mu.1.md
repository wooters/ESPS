# NAME

esps2mu - convert an ESPS sampled data file to a headerless mu-encoded
file

# SYNOPSIS

**esps2mu** \[ **-x** *debug_level* \] \[ **-s** *shift* \] *infile*
*outfile*

# DESCRIPTION

*Esps2mu* converts an ESPS sampled data file to a headerless binary file
containing mu-encoded data. The format of the data is appropriate for
use with the SPARCstation 1 codec chip. Note that the SPARCstation
expects data that was sampled at 8000 samples/second data. If *infile*
is replaced by "-", *esps2mu* will read from standard input, and if
*outfile* is replaced by "-", standard output is written.

# OPTIONS

The following options are supported:

**-x** *debug_level*  
If *debug_level* is positive, *esps2mu* prints diagnostic messages. The
default level is zero, which causes no debug output.

**-s** *shift*  
*Shift* is the number of bits to shift the data before mu encoding it.
Positive numbers shift to the right (make data values smaller) and
negative numbers shift to the left.

# ESPS HEADER

None is written.

# ESPS PARAMETERS

This program does not access the parameter file.

# ESPS COMMON

This program does not access common.

# DIAGNOSTICS

*Esps2mu* informs the user and quits if the input file does not exist or
is not an ESPS sampled data file.

# WARNINGS

*esps2mu* (1-ESPS) expects 14 bit data values that have a magnitude \<=
8159. Use the *shift* option to scale the data before converting. Input
values greater than 8159 in magnitude are treated as being equal to
8159.

# SE ALSO

*linear_to_mu* (3-ESPS), *splay* (1-ESPS)

# BUGS

None known.

# AUTHOR

Manual page and code by David Burton.
