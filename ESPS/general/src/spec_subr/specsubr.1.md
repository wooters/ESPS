# NAME

    spec_subr - Select subrange of frequencies in FEA_SPEC file

# SYNOPSIS

**spec_subr** **-b** *band* \[ **-r** *range* \] \[ **-x** *debug_level*
\] *in.spec* *out.spec*

# DESCRIPTION

Given an ESPS spectrum (FEA_SPEC) file *spec_subr* selects the spectrum
data corresponding to frequencies in a specified band and writes the
result to an output FEA_SPEC file (see *FEA_SPEC*(5-ESPS)). The output
file is in \`\`ARB_FIXED'' format, meaning that the header contains an
explicit list of the selected frequencies. \`\`Extraneous'' input fields
(those not part of the FEA_SPEC specification) are ignored.

# OPTIONS

The following options are supported:

**-b** *low***:***high* **\[(none)\]**  
**-b** *low***:+***width*  
This \`\`option'' is required; there are no default values. The first
form specifies the selected band of frequencies by giving the upper and
lower limits as a pair of real number. The second for (with the plus
sign) specifies the band by its lower limit and width. Thus, if *high* =
*low* + *width,* the two forms specify the same frequency band.

**-r** *start***:***last* **\[1:(last in file)\]**  
**-r** *start***:+***incr*  
**-r** *start*  
In the first form, a pair of unsigned integers specifies the range of
records to be processed. Either *start* or *last* may be omitted; then
the default value is used. If *last* = *start* + *incr,* the second form
(with the plus sign) specifies the same range as the first. The third
form (omitting the colon) specifies a single record.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *testsd* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

No ESPS parameter file is accessed.

# ESPS COMMON

The ESPS common file is not accessed.

# ESPS HEADERS

The program reads the header items *freq_format,* *spec_type,* *contin,*
*num_freqs,* and *frame_meth* in the header of the input file. It also
checks for the presence of the field *tot_power* in the input to decide
whether to create the same field is the output.

The header of the output file is a newly created FEA_SPEC header
containing the required generic header items and field definitions (see
*FEA_SPEC*(5-ESPS)). The value of *freq_format* in the output is
ARB_FIXED, regardless of the value in the input (which must not be
ARB_VAR, however). The values of *spec_type,* *contin,* and *frame_meth*
are copied from the input, and so is *frmlen* if *frame_meth* is FIXED.
The value of *num_freqs* is the number of frequencies represented in the
output, and the header item *freqs* lists the frequencies.

If the input file is tagged, then so is the output. In that case either
*src_sf* or *sf* is copied from the input header--- *src_sf* if present
and *sf* otherwise. The generic header item *start_time* is written with
a value computed by taking the *start_time* from the input header (or
zero, if the item doesn't exist) and adding to it the relative time from
the first record in the input file to the first record processed. The
computation of *start_time* depends on the value of the generic header
item *record_freq* in input. If that item isn't present, *start_time* is
just copied from the input to the output.

The items *start* and *nan* are written to contain the starting record
number and the number of records to be processed (with 0 implying all
records up to the end of the file). As usual, the command line is added
as a comment, and the header of the input file is added as a source file
to the output.

Items *band_low* and *band* in the output header record the lower limit
and the bandwidth of the band specified with **-b**.

# FUTURE CHANGES

Parameter-file processing.

# EXAMPLES

# ERRORS AND DIAGNOSTICS

If an unknown option is specified, or if the number of file names is
wrong, *spec_subr* prints a synopsis of command-line usage and exits.
The program exits with an error message if any of the following are
true: **-r** specifies an empty range or a starting record number of 0
or less, **-b** is lacking or specifies a bandwidth of 0 or less, no
frequencies of the input file lie in the given range, or the input file
has a *freq_format* of ARB_VAR. A warning message is issued if a tagged
input file contains neither *src_sf* nor *sf.*

# BUGS

None known.

# REFERENCES

# SEE ALSO

*FEA_SPEC*(5-ESPS)).

# AUTHOR
