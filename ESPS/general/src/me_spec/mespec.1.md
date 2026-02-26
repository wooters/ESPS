# NAME

me_spec - Generate maximum-entropy spectra from parameter vectors.

# SYNOPSIS

**me_spec** \[ **-n** *num_freqs* \] \[ **-o** *max_order* \] \[ **-r**
*range* \] \[ **-x** *debug_level* \] \[ **-G** \]\
\[ **-P** *params* \] *input* *output.spec*

# DESCRIPTION

*Me_spec* reads spectral parameters and other information from the input
file and generates a corresponding spectral record file containing
logarithmically scaled (in dB) maximum-entropy spectral power densities.

The spectral parameters may be reflection coefficients,
autoregressive-filter coefficients, or any of several other types of
parameters; see *spec_rep* in the Parameters section and the
documentation for reps_rc(3-ESPS) for a list. Other required information
includes the total power, the order of the spectrum, and the sampling
frequency. These may be obtained from the input file, or defaults may be
used; see the descriptions of the parameters *max_order,*
*samp_freq_name,* *samp_freq,* *power_field,* and *power.*
FEA_ANA(5-ESPS) files are suitable as input and are specially provided
for, but any vector field of type *float* in any FEA file may be treated
as a vector of spectral parameters; see *spec_param_field* and
*spec_rep* in the Parameters section.

The spectral values are computed for the specified number of
frequencies, which must be at least 2. The frequencies are equispaced
from 0 to half the sampling frequency. There is an option to compute the
spectrum to a lower order than the number of coefficients present in the
analysis records.

One output record is written for each input record in the specified
range. If \`\`-'' is given for the input file, the standard input is
read. If \`\`-'' is given for the output file, the standard output is
written to. The output file can be plotted using the plotspec(1-ESPS)
command.

# OPTIONS

The following options are supported. Values in brackets are defaults.

**-n** *num_freqs* **\[513\]**  
Compute spectral values for this number of frequencies, equispaced from
0 to half the sampling frequency. Must be at least 2.

**-o** *max_order*  
Maximum-entropy spectra of at most this order will be computed, even
when more coefficients are available in the analysis records. The
program converts the spectral parameters to reflection coefficients,
carrying the computation out to the actual order of the parameter set
contained in the record. In FEA_ANA files, when **-G** has not been
specified, the actual order is given by the header item *order_vcd,* for
records in which the *frame_type* field is VOICED or TRANSITION, and by
*order_unvcd* in other records. In other files, or when **-G** has been
specified, the actual order is assumed to be the length of the field (or
subsequence of a field) named by the parameter *spec_param_field.* After
converting the parameters, the program truncates the sequence of
reflection coefficients to length *max_order* and computes a
maximum_entropy spectrum from the truncated sequence.

This procedure is *not* equivalent to simply truncating the original
parameter set, for example by specifing a shorter field with
*spec_param_field.* The latter procedure may give incorrect results,
depending on the spectral representation (see *spec_rep* in the
Parameters section). For example, the *m* autoregressive filter
coefficients of order *m* are not in general the same as the first *m*
autoregressive filter coefficients of order *n* (where *n \> m*).

**-r** *first***:***last* **\[(first in file):(last in file)\]**  
**-r** *first***:+***incr*  
In the first form, a pair of unsigned integers specifies the range of
records to be processed. Either *first* or *last* may be omitted; then
the default value is used. If *last* = *first* + *incr,* the second form
(with the plus sign) specifies the same range as the first. If the
specified range contains records not in the file, *me_spec* complains
and quits.

**-x** *debug_level \[0\]*  
If *debug_level* is non-zero, *me_spec* prints debugging messages and
other information on the standard error output.

**-G**  
Even if the input file is a FEA_ANA file, it is treated like any other
FEA file. Special processing does not take place for determining filter
order from voicing or computing average power from individual pulse
powers and durations in multipulse FEA_ANA files. The parameter file
must supply values for the parameters *spec_param_field,* *spec_rep,*
*power_field* or *power,* and *samp_freq_name* or *samp_freq.* The
filter order is taken to be the length of the field specified by
*spec_param_field;* but see the discussion of the **-o** option.

**-P** *params***\[params\]**  
The name of the parameter file.

# ESPS COMMON

The ESPS common file is not referred to.

# ESPS PARAMETERS

The following parameters are read as required.

*num_freqs - integer*  
The number of frequencies for which spectral values are computed. The
value in the parameter file is not used if a value is specified with the
command-line option **-n.** The default value and restrictions are as
for the argument of the option.

*max_order - integer*  
An upper bound on the order of the maximum-entropy spectra that will be
computed. The value in the parameter file is not used if a value is
specified with the command-line option **-o.** See the discussion of
**-o** in the Options section for the detailed interpretation of this
parameter.

*start - integer*  
The number of the first record to be processed, counting the first in
the input file as number 1. The value in the parameter file is not used
if a starting value is given with the **-r** option. The default value
is 1.

*nan - integer*  
The number of records to be processed. The value in the parameter file
is not used if the **-r** option is specified. By convention, a value of
0 means that all records from the starting record through the end of the
file are processed. This also the default behavior in case no value is
specified either on the command line or in the parameter file.

*spec_param_field - string*  
The field containing the spectral parameters. This must be explicitly
specified in the parameter file unless the input file is a FEA_ANA file
and the **-G** option is not specified. The default in that case is
"spec_param". This parameter may be simply a field name, or it may be of
the form

*field-name*** \[ ***grange*** \] ***,*

where *grange* is a general range specification acceptable to
*grange_switch*(3-ESPSu). The bracketed range specification specifies
the indices of a subsequence of the elements of the named field that are
to be used as the spectral parameters.

*spec_rep - string*  
A name or abbreviation for the type of spectral parameters. Acceptable
values include "RC" (reflection coefficients), "LAR" (log area ratios),
"AUTO" (normalized autocorrelation coefficients), "AFC" (autoregressive
filter coefficients), "CEP" (cepstrum coefficients), and "LSF" (line
spectral frequencies). See the documentation for reps_rc*(3-ESPSsp).*
This parameter must be explicitly specified in the parameter file unless
the input file is a FEA_ANA file and the **-G** option is not specified.
The default in that case is the contents of the generic header item
*spec_rep.*

*power_field - string*  
A field containing the total power of the spectrum. Either this
parameter or *power* must be explicitly specified in the parameter file
unless the input file is a FEA_ANA file and the **-G** option is not
specified. The default in that case is "raw_power".

*power - float*  
A numerical value for the total power of the spectrum. This value is
used, and applies to all records, unless the parameter *power_field* is
defined and names a field that exists in the input file. In that case,
the contents of the named field are used instead.

*samp_freq_name - string*  
The name of a generic header item that contains the sampling frequency.
Either this parameter or *samp_freq* must be explicitly specified in the
parameter file unless the input file is a FEA_ANA file and the **-G**
option is not specified. The default in that case is "src_sf".

*samp_freq - float*  
A numerical value for the sampling frequency. This values is used unless
the parameter *samp_freq_name* is defined and names a generic header
item that exists in the input file. In that case, the value of the
header item takes precedence.

# ESPS HEADERS

The values *common.type,* *variable.refer,* and *hd.fea-\>fea_type* are
read from the header of the input file. The following generic header
items may also read if the input is a FEA_ANA file: *order_vcd,*
*order_unvcd,* *src_sf,* *spec_rep* *frmlen,* *start,* *nan,* and
*maxpulses.*

The following parameters are written to the header of the FEA_SPEC file:
*common.tag,* *common.prog,* *common.vers,* *common.progdate,*
*variable.refer,* *frmlen* (long), *sf* (float), *frame_meth* (CODED),
*freq_format* (CODED), *spec_type* (CODED), *contin* (CODED),
*num_freqs* (LONG). For input FEA_ANA (5-ESPS) files, *order_vcd* (LONG)
and *order_unvcd* (LONG) are added to the output file header. In
addition, the input file is added as the source of the output file, and
the command line is added as a comment.

The generic header item *start_time* is written in the output file. The
value written is computed by taking the *start_time* value from the
header of the input file (or zero, if such a header item doesn't exist)
and adding to it the offset time (from the beginning of the input file)
of the first point or record processed. If *record_freq* doesn't exist
in the input file, it defaults to 1. Otherwise, it is copied to the
output file header. This item gives the number of records per second of
original data analyzed.

# SEE ALSO

*refcof* (1-ESPS), *plotspec* (1-ESPS), *reps_rc* (3-ESPSsp), FEA_SPEC
(5-ESPS), ESPS (5-ESPS),

# DIAGNOSTICS

me_spec: unknown option: -*letter*\
Usage: me_spec \[-n num_freqs\]\[-o order\]\[-r range\]\[-x
debug_level\]\[-G\]\[-P params\] ana_file spec_file\
me_spec: too many file names specified.\
me_spec: too few file names specified.\
me_spec: number of frequencies *n* is less than 2.\
me_spec: can't open *filename: reason*\
me_spec: *filename* is not an ESPS file\
me_spec: Can't start before beginning of file.\
me_spec: Last record precedes first.\
me_spec: Name of spec_param field not specified.\
me_spec: Unrecognized spectral representation.\
me_spec: Spectral representation not specified.\
me_spec: Field *name* and symbol "power" undefined or not float.\
me_spec: Neither field nor default value for power specified.\
me_spec: Header item *name* and symbol "samp_freq" undefined or not
float.\
me_spec: No header-item name or default value for sampling frequency.\
me_spec: Input field *name* undefined.\
me_spec: Input field *name* undefined or not float.\
me_spec: Input field length *n* too small.\
me_spec: can't allocate memory--input spectral parameters\
me_spec: can't allocate memory--lpc filter\
me_spec: can't allocate memory--reflection coefficients\
me_spec: unknown spectral parameter type

When *debug_level*!=0, the reflection coefficients, average raw power,
location tag, and inverse filter coefficients are listed for each
record.

# BUGS

The *frame_len* field in an input FEA_ANA record, defined as \`\`number
of samples to synthesize from frame,'' is copied to the *frame_len*
field in a spectral record, defined as \`\`number of samples in analysis
window.'' This is invalid if the FEA_ANA file was produced by a program
for which the two are different.

# WARNINGS

In order to produce FEA_SPEC (5-ESPS) that can be overlaid on FEA_SPEC
(5-ESPS) files produced by *fft* (1-ESPS), the **-G** option should be
used. This produces a generic FEA_SPEC (5-ESPS) file without the voicing
information.

# FUTURE CHANGES

# AUTHOR

S. Shankar Narayan. Made SDS compatible by Joe Buck. Originally called
*pltspc,* later *fanaspec.* Modified for ESPS and number of frequencies
made variable by Rod Johnson, Entropic Speech, Inc. Modified for FEA_ANA
files by John Shore. Additions by Rod Johnson to accept spec_reps other
than reflection coefficients and to accept files other than FEA_ANA
files.
