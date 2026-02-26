# NAME

impulse_resp - compute unit impulse responses of filters in FEA_FILT
file.

# SYNOPSIS

**impulse_resp** \[ **-i** \] **-n** *size* \[ **-p** *range* \] \[
**-r** *range* \] \[ **-s** \] \[ **-x** *debug_level* \]
*input.feafilt* *output*

# DESCRIPTION

For each record in the specified range in the input FEA_FILT file,
*impulse_resp* reads the filter zfunc (see *ESPS*(5-ESPS))
*FEA_FILT*(5-ESPS), and computes a specified number of points of the
unit impulse response of the filter by using *block_filter2*(3-ESPSsp)
to filter a sequence consisting of a single 1 followed by zeros.
Normally the result is written as a FEA_FILT record; the response is
stored in the field *re_num_coeff*. Tags are copied from input to
output.

Alternatively, output to a sampled-data file may be specified. In that
case, if there is more than one filter in the input, the output consists
of several sampled-data segments that are simply catenated. (To recover
a particular segment, it is necessary to use knowledge of the number of
points per segment.)

If the input or output filename is given as \`\`-'', the standard input
or output is used.

# ESPS PARAMETERS

The ESPS parameter file is not referred to.

# ESPS COMMON

The ESPS common file is not referred to.

# ESPS HEADERS

The input file is included as the only source file of the output file,
and the reference file of the input file becomes the reference file of
the output file. The command line is included as a comment in the output
file header.

The generic header item *start_rec* in the output header records the
number of the starting input record (counting from 1 for the first in
the file).

The generic header item *invert* records the *-i* option (1 if the
option was specified, 0 if not).

When output is to a filter file, the value of the generic header item
*max_num* in the output header is taken from the *-n* input option. That
of *max_denom* is zero. The value of field *num_degree* in the output
record is also set to *-n.* The other items in the filter-file-specific
part of the output header are given null values such as NONE or NO. The
corresponding values from the input header are available, since the
input file is given as the source of the output file.

When output is to a sampled-data file, the generic output header item
*size* records the value specified with the *-n* option, which equals
the length of the sampled-data segment written for each input record.
The sampling frequency *record_freq* in the output header is arbitrarily
set equal to 1.0, but this can be changed by using *addgen* (1-ESPS).

If the generic header item *samp_freq* exists in the input
*FEA_FILT*(5-ESPS) file, and if the output file is also a
*FEA_FILT*(5-ESPS) file, *samp_freq* is copied to the output file.

# OPTIONS

The following options are supported. Values in brackets are defaults.

**-i**  
Causes the impulse response of the inverse of each input filter to be
computed, rather than that of the filter itself.

**-n** *size* **\[(no default)\]**  
This is the number of points of the output impulse response function;
for filter-function output, it equals *nsiz* of the output zfunc. (See
ESPS(5-ESPS).)

**-r** *first***:***last* **\[(first in file):(last in file)\]**  
**-r** *first***:+***incr*  
**-r** *first*  
In the first form, a pair of unsigned integers specifies the range of
records to be processed. Either *first* or *last* may be omitted; then
the default value is used. If *last* = *first* + *incr,* the second form
(with the plus sign) specifies the same range as the first. The third
form is equivalent to **-r** *first***:***first;* it specifies a single
record.

**-p** *range*  
**r** and **p** are synonyms.

**-s**  
Specifies output to a sampled-data file rather than to a filter file.

**-x** *debug_level* **\[0\]**  
A nonzero value may invoke various debugging messages on the standard
error output.

# SEE ALSO

block_filter2(3-ESPSsp), FEA_FILT(5-ESPS), FEA_SD(5-ESPS), ESPS(5-ESPS)

# DIAGNOSTICS

impulse_resp: unknown option: -*letter*\
Usage: impulse_resp \[-i\] -n size \[-r range\]\[-s\]\[-x debug_level\]
input.feafilt output\
impulse_resp: output length unspecified or negative\
impulse_resp: can't open *filename*: *reason*\
impulse_resp: *filename* is not an ESPS file\
impulse_resp: input file *filename* is not a filter file.\
impulse_resp: beginning of range precedes 1.\
impulse_resp: empty range specified.\
impulse_resp: premature EOF encountered.

# AUTHOR

Rodney W. Johnson
