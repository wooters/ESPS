# NAME

lpcsynt - perform pitch-synchronous synthesis from FEA_ANA files

# SYNOPSIS

**lpcsynt** \[ **-x** \] \[ **-P** *param_file* \] \[ **-r** *range* \]
\[ **-p** *range* \] *input_fea output_sd*

# DESCRIPTION

This program must be used with files with a format such as that created
by *lpcana*(1-ESPS). Consider use of *lp_syn*(1-ESPS). While still
supported, *lpcana*(1-ESPS) and *lpcsynt*(1-ESPS) should be considered
obsolescent.

*Lpcsynt* takes as input an ESPS FEA_ANA(5-ESPS) file (*input_fea*)
containing analysis information, performs pitch-synchronous synthesis,
and outputs the synthesized speech to an ESPS FEA_SD(5-ESPS) file
*output_sd.* The output file is written in short format.

If "-" is specified as the input file name, standard input is used; if
"-" is specified as the output file name, standard output is used.

# OPTIONS

The following options are supported:

**-x**  
This option is specified for printing debugging message in the standard
error.

**-P** *param_file*  
uses the parameter file *param_file* rather than the default which is
*params.*

**-p** *range*  
Selects a subrange of points to be synthesized, where the start and end
points are defined with respect to the original SD file that is the
source of the input FEA_ANA file. The range is specified using the
format *start-end* or *start:end* or *start:+nan*. Either *start* or
*end* may be omitted, in which case the omitted parameter defaults
respectively to the start or end of the input FEA_ANA file.

**-r** *range*  
**r** is a synonym for **p**.

# ESPS PARAMETERS

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

The following parameters are read from the params file:

*post_filt_num - float*

> A three element vector specifying the numerator of a pole-zero post
> processing filter. If no values are specified in the parameter file,
> the vector \[1., -1., 0\] is used.

*post_filt_den - float*  
> A three element vector specifying the denominator of a pole-zero post
> processing filter. If no values are specified in the parameter file,
> the vector \[1., -.875, 0.\] is used.

# ESPS COMMON

ESPS Common is not processed.

# ESPS HEADERS

The following parameters are read from the header of the input FEA_ANA
file: *start, nan, nominal_frame_size, and src_sf.*

*Synt* writes the following header items in the output FEA_SD file:
*synt_order* (int), *synt_method* (coded), *synt_interp* (coded),
*synt_pwr* (coded), *v_excit_method* (coded), and *uv_excit_method*
(coded).

Also, *src_sf* is copied from the input header and used as *record_freq*
in the output FEA_SD file.

In addition, the generic header item *start_time* (type DOUBLE) is
written in the output file. The value written is computed by taking the
*start_time* value from the header of the input file (or zero, if such a
header item doesn't exist) and adding to it the offset time (from the
beginning of the original sampled data file) of the first point written
by *lpcsynt* (1-ESPS).

# COMMENTS

The synthesizer implementation is very simple. A single impulse is used
as the excitation function for each pitch pulse in the case of voiced
speech. A gaussian white noise sequence is used as the excitation
function when the frame is unvoiced. Linear interpolation is performed
(for each pulse) on the reflection coefficients, prior to synthesis.

# SEE ALSO

lpcana (1-ESPS), ESPS(5-ESPS), FEA_ANA(5-ESPS),\
FEA_SD(5-ESPS).

# BUGS

None known.

# AUTHOR

S. Shankar Narayan. Slight mods by John Shore. ESPS 3.0 modification by
David Burton
