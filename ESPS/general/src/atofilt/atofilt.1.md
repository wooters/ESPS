# NAME

atofilt - create filter by converting ascii files to an ESPS FEAFILT
file.

# SYNOPSIS

**atofilt** \[ **-x** *debug_level* \] \[ **-c** *comment* \] *num_file*
\[ *den_file* \] *feafilt_file*

# DESCRIPTION

The program *atofilt* reads numerator filter coefficients from the file
*num_file* and (optionally) denominator coefficients from the file
*den_file* and prints them to the output FEAFILT file *feafilt_file.*
Both input files are in ascii format. The *num_file* and the *den_file*
may be the same file, in which case the numerator coefficients should
appear first. In both *num_file* and *den_file* the first number should
be an integer which tells how many filter coefficients are in the file.
The filter coefficients follow. Data can be separated by any combination
of spaces and newline characters.

The program prompts the user for comments to be added to the comment
field of *feafilt_file* unless the -c option is used or unless any
coefficients are being read from the standard input. The user should
type in his comments and terminate them with a ^D on a line by itself.
In either case the user added comment is limited to 2047 characters. In
addition to any user specified comments, the program automatically
specifies the source of the numerator and (if appropriate) the
denominator coefficients in the comment field.

If *feafilt_file* is "-", the output goes to the standard output. If
*num_file* is "-", the numerator coefficients are read from standard
input. If *den_file* is "-", the denominator coefficients are read from
standard input also.

# OPTIONS

The following options are supported:

**-x** *debug_level*  
A value of 0 (the default value) will cause *atofilt* to do its work
silently, unless there is an error. A nonzero value will cause various
parameters to be printed out during program initialization.\

**-c** *comment*  
The character string *comment* is added to the comment field of the
output file header. If this option is not used, the program prompts the
user for a comment string, which he should terminate with a ^D.

# ESPS PARAMETERS

The parameter file is not accessed.

# ESPS COMMON

The Common file is not used.

# ESPS HEADER

A new header is created for the output FEAFILT file. The program fills
in appropriate values in the common part of the header. The generic
header items *max_num* and *max_denom.* are set to the number of items
in *num_file* and *denom_file,* respectively; *define_pz* and
*complex_filter* are set to NO; *type* is set to FILT_ARB and *method*
is set to PZ_PLACE. All other items take their null values. The program
enters the names of the input coefficient files in the comment field of
the header.

A new command line option will be added that allows specification of the
*delay_samples* generic header item value. This should contain the delay
in samples of the input signal that results from using the filter. For
now, *addgen* (1-ESPS) can be used to add this item.

# DIAGNOSTICS

The program prints a warning to the standard error output if the total
comment field of the output file exceeds MAX_STRING.

# SEE ALSO

    notch_filt(1-ESPS), wmse_filt(1-ESPS), iir_filt(1-ESPS), 
    fea2filt(1-ESPS), filter (1-ESPS), init_feafilt_hd(3-ESPSu), 
    allo_feafilt_rec(3-ESPSu), get_feafilt_rec(3-ESPSu), 
    put_feafilt_rec(3-ESPSu), ESPS(5-ESPS), FEA(5-ESPS), 
    FEA_FILT(5-ESPS)

# AUTHOR

Brian Sublett. Modified for ESPS 3.0 by David Burton. Modified to
produce FEAFILT files by Bill Byrne.
