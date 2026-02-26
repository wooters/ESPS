# NAME

fftinv - Inverse Fast Fourier Transform of ESPS FEA_SPEC file to SD file

# SYNOPSIS

**fftinv** \[ **-r** *range* \] \[ **-x** *debug_level* \] *specfile*
*sdfile*

# DESCRIPTION

*Fftinv* takes an input ESPS spectral record file (FEA_SPEC) file,
*specfile,* and takes the Fast Fourier Transform of one or more records
segments to produce an ESPS sampled data file (SD) file *sdfile.* If the
input file name *specfile* is replaced by "-", then stdin is read;
similarily, if *sdfile* is replaced by "-", then the output is written
to stdout.

The input FEA_SPEC file must have spectral type SPTYP_CPLX and frequency
format SPFMT_ASYM_EDGE - i.e., the full complex spectrum is stored. Such
spectral records are produced by *fft* (1-ESPS) using the **-c** option.

# OPTIONS

The following options are supported:

**-r** *first***:***last*  
**-r** *first-last*  
**-r** *first***:+***incr*  
In the first two forms, a pair of unsigned integers specifies the range
of sampled data to analyze. If *last* = *first* + *incr,* the third form
(with the plus sign) specifies the same range as the first two forms. If
*first* is omitted, the default value of 1 is used. If *last* is
omitted, then all records from *first* are processed.

**-x** *debug_level\[0\]*  
Specifies that debugging output be printed on stderr; larger values of
*debug_level* result in more output. The default is for no output.

# ESPS PARAMETERS

The ESPS parameter file is not read.

# ESPS COMMON

The ESPS Common file is not read or written.

# ESPS HEADERS

The generic header item *start_time* (type DOUBLE) is written in the
output file. The value written is computed by taking the *start_time*
value from the header of the input file (or zero, if such a header item
doesn't exist) and adding to it the offset time (from the beginning of
the input file) of the first point or record processed.

# FUTURE CHANGES

# SEE ALSO

fft(1-ESPS), plotsd (1-ESPS), get_fft_inv (3-ESPS), SD(5-ESPS),
FEA_SPEC(5-ESPS), ESPS(5-ESPS).

# BUGS

# REFERENCES

J. W. Cooley and J. W. Tukey, "An Algorithm for the Machine Calculation
of Complex Fourier Series," *Math. Computation*, Vol. 19, 1965, pp.
297-301.

Alan V. Oppenheim and Ronald W. Schafer, *Digital Signal Processing*.
Englewood Cliffs, New Jersey: Prentice-Hall, Inc., 1975.

# AUTHOR

manual page and program by John Shore, using library function by Shankar
Narayan.
