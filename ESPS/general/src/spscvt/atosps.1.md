# NAME

atosps - convert spstoa output back into an ESPS SD or FEA file

# SYNOPSIS

**atosps** *infile* *outfile*

# DESCRIPTION

*Atosps* accepts a specially formatted ASCII file written by
*spstoa*(-ESPS) (possibly on a computer with different formats for data
values) and produces an ESPS file.

If the first argument is "-", *atosps* will read from the standard
input. If the second argument is "-", it will write to the standard
output. The two programs *atosps* and *spstoa* are almost perfect
inverses: integer and character values are represented exactly; float
values retain seven significant digits; double precision values retain
15 significant digits.

*Atosps* informs the user and quits if the input file does not exist or
does not have proper syntax.

# ESPS PARAMETERS

This program does not access the parameter file.

# DIAGNOSTICS

    Usage: atosps infile outfile
    atosps: infile is empty.
    atosps: infile has the wrong format.
    atosps: Unexpected EOF in infile
    atosps: Type already set (type_code); bad file!
    atosps: Could not allocate memory for ESPS SD header.
    atosps: Could not allocate memory for ESPS FEA header.
    atosps: Bad file type code type_code.
    atosps: Bad tag code (tag_code) in infile
    atosps: zfunc syntax error in infile
    atosps: syntax error in infile: line, header level hdrlev
    atosps: syntax error in infile: line, record record_num

# BUGS

*Atosps* is rigid about the format of the input file; it has no problem
with files produced by *spstoa* but may have trouble if you edit the
file (make sure to keep the same number of spaces). Fixing this might
make the program unacceptably slow for large data files.

File creates by the current version of *atosps* will always be in the
machines's native data representation. Unlike other ESPS programs, the
value of the Unix environment variable **ESPS_EDR** has no effect on the
output file.

# SEE ALSO

spstoa(1-ESPS)

# AUTHOR

Joe Buck and Alan Parker. ESPS FEA file support by Ajaipal S. Virdy,
Entropic Speech, Inc.
