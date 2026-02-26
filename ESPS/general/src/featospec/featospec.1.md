# NAME

featospec - convert FEA_SPEC file to SPEC file

# SYNOPSIS

**featospec** \[ **-x** *debug_level* \] *input.fea output.spec*

# DESCRIPTION

*Featospec* accepts an ESPS FEA_SPEC file *input.fea* and writes an ESPS
SPEC file *output.spec* containing the same number of records with the
same information in each record. If *input.fea* is "-", standard input
is used for the input file. If *output.spec* is "-", standard output is
used for the output file.

# OPTIONS

The following option is supported:

**-x** *debug_level*  
Positive values of *debug_level* cause debugging information to be
printed. The default value is 0, which suppresses the messages.

# ESPS PARAMETERS

No parameter file is read.

# ESPS COMMON

The ESPS common file is not accessed.

# ESPS HEADERS

The output header is a new SPEC file header, with appropriate items
copied from the input header. The information in the generic header
items *freq_format,* *spec_type,* *contin,* *num_freqs,* and
*frame_meth* and, if necessary, *freqs,* *sf,* and *frmlen* is copied
into the like-named elements of the type-specific part of the output
header. (See FEA_SPEC(5-ESPS) for details on when these last three items
are required.) Input generic header items that are not so used are
copied into generic header items in the output header. As usual, the
command line is added as a comment, and the header of *input.fea* is
added as a source file to *output.spec.*

# FUTURE CHANGES

None planned.

# SEE ALSO

    SPEC (5-ESPS), FEA (5-ESPS), FEA_SPEC(5-ESPS)

# WARNINGS AND DIAGNOSTICS

*Featospec* exits with an error message if the command line contains
unrecognized opions or too many or too few file names or if required
header items in the input file are missing or of the wrong type.

# BUGS

None known.

# AUTHOR

Manual page and program by Rodney Johnson.
