# NAME

spstoa - convert an ESPS SD, FILT or FEA file to a machine-independent
format

# SYNOPSIS

**spstoa** *infile* *outfile*

# DESCRIPTION

*Spstoa* converts an ESPS SD, FILT or FEA file to a machine-independent,
ASCII format. The output can then be moved to a different type of
computer (with different representation for integers and floating
values) and converted back into an ESPS file using *atosps*(1-ESPS).

If the first argument is "-", *spstoa* will read from the standard
input. If the second argument is "-", it will write to the standard
output. Integer and character values are represented exactly in the
output; float values retain seven significant digits; double precision
values retain 15 significant digits.

*Spstoa* informs the user and quits if the input file does not exist or
is not an ESPS file.

# BUGS

This version of the program cannot deal with feature files with complex
fields. The next version will.

# ESPS PARAMETERS

This program does not access the parameter file.

# DIAGNOSTICS

    Usage: spstoa infile outfile
    spstoa: Input file %s must either be an ESPS SD, FILT file or an ESPS FEA file.
    spstoa: Unknown file type: type_code
    spstoa: Unknown embedded header type %d: removing header.
    spstoa: Error reading infile

# SEE ALSO

atosps(1-ESPS)

# AUTHOR

Joe Buck and Alan Parker. ESPS FEA file support by Ajaipal S. Virdy,
Entropic Speech, Inc.
