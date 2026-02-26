# NAME

zero_pole - convert complex ascii zero and pole locations to ESPS filter

# SYNOPSIS

**zero_pole** \[ **-x** *debug_level* \] \[ **-c** *comment* \] \[
**-g** *gain* \] \[ **-f** *freq* \] *zero_file* \[ *pole_file* \]
*feafilt_file*

# DESCRIPTION

The program *zero_pole* reads complex zero locations from the file
*zero_file* and (optionally) complex pole locations from the file
*pole_file,* computes the numerator and denominator coefficients, and
prints the coefficients, poles and zeros to the output FEAFILT file
*feafilt_file.* Zero and pole locations are specified by a real part
followed by an imaginary part. Poles or zeros on the real axis need the
imaginary part specified. If a pole or zero is specified off the real
axis (i.e. with a nonzero imaginary part), its complex conjugate is
automatically included. This insures that the resulting filter
coefficients are all real. Any poles specified outside of the unit
circle will result in an error.

Both input files are in ascii format. The *zero_file* and the
*pole_file* may be the same file, in which case the numerator
coefficients should appear first. In both *zero_file* and *pole_file*
the first number should be an integer which tells how many zeros or
poles are in the file. The zeros or poles follow. Both real and
imaginary part of each pole and zero must be specified. Any combination
of spaces and newlines may separate the data.

The program prompts the user for comments to be added to the comment
field of *feafilt_file* unless the -c option is used or unless any
coefficients are being read from the standard input. The user should
type in his comments and terminate them with a ^D on a line by itself.
In either case the user added comment is limited to 2047 characters. In
addition to any user specified comments, the program automatically
specifies the source of the zero locations and (if appropriate) the pole
locations in the comment field.

If *feafilt_file* is "-", the output goes to the standard output. If
*zero_file* is "-", the zeros are read from standard input. If
*pole_file* is "-", the poles are read from standard input also.

# OPTIONS

The following options are supported:

**-x** *debug_level*  
A value of 0 (the default value) will cause *zero_pole* to do its work
silently, unless there is an error. A nonzero value will cause various
parameters to be printed out during program initialization.\

**-c** *comment*  
The character string *comment* is added to the comment field of the
output file header. If this option is not used, the program prompts the
user for a comment string, which he should terminate with a ^D.\

**-g** *gain*  
This is the gain of the filter at the "critical frequency" specified by
the **-f** option. The default for *gain* is 1.0. If neither the **-g**
nor the **-f** option is used, the filter gain is not normalized.\

**-f** *freq*  
This is the critical frequency at which the gain of the filter is
normalized, expressed as a fraction of the sampling frequency. The
default for *freq* is 0.0. If neither the **-g** nor the **-f** option
is used, the filter gain is not normalized.

# ESPS PARAMETERS

The parameter file is not accessed.

# ESPS COMMON

The Common file is not processed.

# ESPS HEADER

A new header is created for the output FEAFILT file. The program fills
in appropriate values in the common part of the header. The generic
header items *max_num* and *max_denom* are set to the number of items in
*num_file* and *denom_file,* respectively; *define_pz* is set to YES and
*complex_filter* is set to NO; *type* is set to FILT_ARB and *method* is
set to PZ_PLACE. All other items take their null values. The program
enters the names of the input coefficient files in the comment field of
the header.

# DIAGNOSTICS

The program prints a warning to the standard error output if the total
comment field of the output file exceeds MAX_STRING.

# SEE ALSO

atofilt(1-ESPS), notch_filt(1-ESPS), wmse_filt(1-ESPS),
iir_filt(1-ESPS), fea2filt(1-ESPS), filter (1-ESPS), fft_filter
(1-ESPS), pz_to_co (3-ESPSsp), init_feafilt_hd(3-ESPSu),
allo_feafilt_rec(3-ESPSu), put_feafilt_rec(3-ESPSu), ESPS(5-ESPS),
FEA(5-ESPS), FEAFILT(5-ESPS), FILT (5-ESPS)

# AUTHOR

Brian Sublett. Modified for ESPS 3.0 by David Burton. Modified for
FEAFILT output by Bill Byrne.
