# NAME

spectofea - convert SPEC file to FEA_SPEC file

# SYNOPSIS

**spectofea** \[ **-f** {**BYTE**\|**FLOAT**} \] \[ **-x** *debug_level*
\] *input.spec output.fea*

# DESCRIPTION

*Spectofea* accepts an ESPS SPEC file *input.spec* and writes an ESPS
FEA_SPEC file *output.fea* containing the same number of records with
the same information in each record. If *input.spec* is "-", standard
input is used for the input file. If *output.fea* is "-", standard
output is used for the output file.

# OPTIONS

The following option is supported:

**-f** *re_spec_val format*  
If the input SPEC file is of type ST_DB, then this argument determines
whether the field *re_spec_val* in the output FEA file is in BYTE format
or FLOAT format. See *FEA_SPEC*(5-ESPS) for details. This option is
ignored if the SPEC file is not of type ST_DB. The default output format
for DB type files is BYTE.

**-x** *debug_level*  
Positive values of *debug_level* cause debugging information to be
printed. The default value is 0, which suppresses the messages.

# ESPS PARAMETERS

No parameter file is read.

# ESPS COMMON

The ESPS common file is not accessed.

# ESPS HEADERS

The output header is a new FEA file header, with appropriate items
copied from the input header. Generic header items *freq_format,*
*spec_type,* *contin,* *num_freqs,* and *frame_meth* and, if necessary,
*freqs,* *sf,* and *frmlen* are created in the output header and filled
with the information from the like-named elements of the type-specific
part of the input header. (See FEA_SPEC(5-ESPS) for details on when
these last three items are required.) The generic header items of the
input header are copied to the output header after being renamed, if
necessary, to avoid name conflicts. As usual, the command line is added
as a comment, and the header of *input.spec* is added as a source file
to *output.fea.*

# FUTURE CHANGES

None planned.

# SEE ALSO

*featospec*(1-ESPSu), *SPEC*(5-ESPS), *FEA*(5-ESPS),\
*FEA_SPEC*(5-ESPS),

# WARNINGS AND DIAGNOSTICS

*Spectofea* will exit with an error message if the command line contains
unrecognized options or too many or too few file names. It will print a
warning if a generic header item in the input file has to be renamed to
avoid a name conflict in the output file.

# BUGS

None known.

# AUTHOR

Manual page and program by Rodney Johnson.
