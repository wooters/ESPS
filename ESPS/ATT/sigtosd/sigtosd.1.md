# NAME

sigtosd - convert SIGnal format sampled data file to ESPS FEA_SD file

# SYNOPSIS

**sigtosd** \[ **-x** *debug_level* \] \[ **-H** \] *input.sig
output.esps*

# DESCRIPTION

*Sigtosd* converts a SIGnal format sampled data file to an equivalent
ESPS FEA_SD file. The FEA_SD file is written with data type SHORT (which
is the data type of SIGnal sampled data files). Unless the **-H** option
is used, the ASCII header from the input SIGnal file is inserted in the
comment section of the output ESPS header. Any null characters in the
SIGnal header are stripped from the comment added to the ESPS header
(thus, care must be taken if you intend later to take the ESPS comment
and turn it back into a SIGnal header).

This program cannot be used on pipes.

# OPTIONS

**-x** *debug_level*  
A positive value causes debugging output to be printed on the standard
error output. Larger values give more output. The default is 0, for no
output.

**-H**  
Specifies that the SIGnal header from *input.sig* is not to be inserted
as a comment in the ESPS header of *output.esps*.

# ESPS PARAMETERS

The ESPS Parameter file is not processed.

# ESPS COMMON

The ESPS Common file is not processed.

# ESPS HEADERS

A standard ESPS FEA_SD header is written for *output.esps*, with the
input SIGnal header added as a comment unless the **-H** is used.

# FUTURE CHANGES

# SEE ALSO

*featosd* (1-ESPS), FEA_SD (5-ESPS)

# BUGS

*Sigtosd* doesn't notice if *input.sig* is an ESPS SD file instead of a
SIGnal file. In this case, *output.esps* is an equivalent ESPS SD file;
*sigtosd* doen't work on FEA_SD (5-ESPS) input files, however. The
following cryptic error messages occur: *write_data: SD file; Signal
type not P_SHORT.* Problems writing data in put_signal(). If the **-H**
is not used, the comment labeled as a SIGnal header is a SIGnal header
synthesized from the ESPS header on *input.sig*.

# AUTHOR

Manual page and program by John Shore. FEA_SD modifications by David
Burton.
