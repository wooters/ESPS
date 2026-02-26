# NAME

melspec - mel scale spectrum

# SYNOPSIS

**melspec** \[ **-a** *add_const* \] \[ **-m** *mult_const* \] \[ **-n**
*num_freqs* \] \[ **-r** *range* \] \[ **-x** *debug_level* \] \[ **-H**
*freq_range* \] \[ **-M** *mel_range* \] \[ **-P** *param_file* \] \[
**-S** *spec_type* \] \[ **-W** *channel_width* \] \[ **-X** \]
*input.spec* *output.spec*

# DESCRIPTION

This program reads an ESPS spectrum (FEA_SPEC) file containing power
spectra on a linear frequency scale. To each input spectrum it applies a
bank of triangular filters with uniform spacing on a mel scale. It
writes the resulting mel spectra to an output FEA_SPEC file.

If *input.spec* is \`\`-'', standard input is read. If *output.spec* is
\`\`-'', results are written to standard output. The input and output
should not be the same file; however, it is okay to run the program as a
filter by specifying \`\`-'' for both input and output.

For the input file, *freq_format* must be SYM_EDGE (see
*FEA_SPEC*(5-ESPS)). This is the normal output format used by
*fft*(1-ESPS) (for real spectra) and by *me_spec*(1-ESPS). The output
file is in ARB_FIXED format, meaning that the header contains an
explicit list of the frequencies corresponding to the spectral values in
the records. The output values may be written either in units of power
or log power (dB)---see **-S** under Options. (That is, the output
*spec_type* may be either PWR or DB---see *FEA_SPEC*(5-ESPS).) In either
case a further arbitrary linear scaling of the output values may be
specified---see options **-a** and **-m**.

The computation of the mel spectrum uses the correspondence between
mel-scale values *m* and frequencies *f* in hertz given by:

> m = 1127.01 log (1 + f/700)

where the constant shown as 1127.01 is actually 1000/log(1700/700), a
value chosen so that 1000 mel corresponds to 1000 Hz. (There is no
single universally accepted definition of the mel scale. The one used in
*melspec* is consistent with the one used in HTK \[1\].) A triangular
filter function *F* with width *W* is defined by:

> F(m) = 1 - \|2m/W\|,(\|m\| \< W/2)

> F(m) = 0,\`\|u\`(otherwise).

The filter bank that is used consists of a specified number *num_freqs*
of uniform translates of *F,* equally spaced in the mel domain and with
equal width *W* = *channel_width.* The number of filters, their width,
and the range of mel values that they cover may be specified by various
command-line options or parameter-file entries---see **-n**, **-W**,
**-M**, and **-H**. When transformed from the mel domain to the
linear-frequency domain, the filters provide a set of weighting
functions that are used in forming weighted sums of the input spectral
values. These weighted sums become the output mel-spectral values.

The output field *tot_power* (see *FEA_SPEC*(5-ESPS)) is filled in with
a copy of the input *tot_power.* A special generic header item
*mel_freqs* is included in the output file header to record the selected
set of uniformly spaced mel values *m.* The equivalent linear
frequencies (nonuniformly spaced) are recorded in the generic header
item *freqs.*

# OPTIONS

The following options are supported. Default values are shown in
brackets.

**-a** *add_const* **\[0.0\]**  
**-m** *mult_const* **\[1.0\]**  
Before being written out, each computed power *S* (or log power---see
option **-S**) may be transformed into a scaled value *add_const* +
*mult_const* \* *S*. The default values 0 and 1 for *add_const* and
*mult_const* result in no change in the output values. Option **-a**
overrides any value specified for *add_const* in the parameter file.
Option **-m** overrides any value specified for *mult_const* in the
parameter file.

**-n** *num_freqs* **\[(see text)\]**  
The number of equally spaced mel values at which mel-spectral values
will be computed. If the channel bandwidth in mels is specified
explicitly (option **-W**, parameter *channel_width*) then the default
*num_freqs* is a number of bands that attempts to cover the specified
range (see **-M**) with a center-to-center spacing of half the given
width. When this can be done exactly, the number is given by
2(*mel_high* - *mel_low*) /*channel_width* - 1; the default value in any
case is the value of this expression rounded to the nearest integer.
Specifying an argument of 0 implies this default value. If the channel
bandwidth is not specified then the number of bands must be given
explicitly, either with this option or by the parameter *num_freqs* in
the parameter file. This option overrides the parameter-file value.

**-r** *start***:***last* **\[1:(last in file)\]**  
**-r** *start***:+***incr*  
**-r** *start*  
The range of input records to be processed. In the first form, a pair of
unsigned integers gives the numbers of the first and last records of the
range. (Counting starts with 1 for the first record in the file.) Either
*start* or *last* may be omitted; then the default value is used: 1 for
*start* and the last record in the file for *last.* If *last* =
*start* + *incr,* the second form (with the plus sign) specifies the
same range as the first. The third form (omitting the colon) specifies a
single record. This option overrides any values of *start* and *nan* in
the parameter file. The implied value of *nan* is 1 + *last* - *start*
(first form), 1 + *incr* (second form), or 1 (third form).

**-x** *debug_level* **\[0\]**  
A positive value of *debug_level* calls for debugging output, which is
printed on the standard error output. Larger values result in more
output. For the default value of 0, no messages are printed.

Output at level 2 includes the same frequency table that option **-X**
generates.

**-H** *band_low***:***band_high* **\[0:(Nyquist)\]**  
**-H** *band_low***:+***width*  
The range of frequencies (in hertz) to be covered. The first form
specifies the range by giving the upper and lower limits as a pair of
real numbers. The second form (with the plus sign) specifies the range
by its lower limit and width. Thus, if *band_high* = *band_low* +
*width,* the two forms specify the same range. The default is to attempt
to cover the entire range of frequencies in the input file. A specified
value of 0 for *band_high* implies use of the default value---the
Nyquist rate. This option overrides any value of *band_low,* *mel_low,*
*band_high,* or *mel_high* specified in the parameter file. The
specified range is transformed into a range on the mel scale, and the
uniform interval between mel values is computed as described for option
**-M** below. See **-M** for more information. This option should not be
used if **-M** is specified.

**-M** *mel_low***:***mel_high* **\[0:(Nyquist equivalent)\]**  
**-M** *mel_low***:+***width*  
The mel-scale range to be covered. The first form specifies the range by
giving the upper and lower limits as a pair of real numbers. The second
form (with the plus sign) specifies the range by its lower limit and
width. Thus, if *mel_high* = *mel_low* + *width,* the two forms specify
the same range. The uniformly spaced mel values (at which mel-spectral
values will be computed) are chosen so that the corresponding intervals
span the specified range. The default is to attempt to cover the range
of mel values corresponding to the entire range of frequencies in the
input file. A specified value of 0 for *mel_high* implies use of the
default value---the mel-scale value corresponding to the Nyquist rate.
The uniform interval between mel values is equal to (*mel_high* -
*mel_low* - *channel_width* )/(*num_freqs* - 1), where *num_freqs* is
the number of such values (see option **-n**) and *channel_width* is the
total width of each filter (see option **-W**). The first such value is
*mel_low* + *channel_width*/2. The uniform interval is required to be
positive if *num_freqs* \> 1, and in any case *mel_high* - *mel_low*
must not be less than *channel_width.* When the width is not explicitly
specified, it is chosen so that the interval equals half the
width---i.e. so that the points at which each filter goes to 0 coincide
with the peaks of its neighbors. In that case the interval is equal to
(*mel_high* - *mel_low* )/(*num_freqs* + 1). This option overrides any
value of *band_low,* *mel_low,* *band_high,* or *mel_high* specified in
the parameter file. It should not be used if **-H** is specified.

**-P** *param_file* **\[params\]**  
The name of the ESPS parameter file.

**-S** *spec_type* **\[DB\]**  
Allowed values for the argument are DB and PWR (case-insensitive). These
result in an output file with a *spec_type* (see *FEA_SPEC*(5-ESPS)) of
DB or PWR, respectively. If DB, the default, is selected, each computed
mel-spectral power *S* is replaced with a logarithmic value *10 \*
log10(S)* before being written out. This transformation takes place
before any additive or multiplicative transformation implied by options
**-a** and **-m** or the corresponding parameter-file entries. This
option overrides any value for *spec_type* specified in the parameter
file.

**-W** *channel_width* **\[(see text)\]**  
The total bandwidth in mel of each triangular filter---i.e. the width of
the base of the triangle. If the number of filters is specified
explicitly (option **-n**, parameter *num_freqs*) then the default width
is chosen so that the given number of bands will cover the specified
range (see **-M**) with 50% overlap between adjacent bands. In that case
the width is 2(*mel_high* - *mel_low* )/(*num_freqs* + 1). A specified
value of 0 for *channel_width* implies use of this default value. If the
number of filters is not specified then the channel bandwidth must be
given explicitly, either with this option or by the parameter
*channel_width* in the parameter file. This option overrides the
parameter-file value.

**-X**  
This option causes the program to write a frequency table on the
standard error output. The table lists the filter peak frequencies and
band edges in mels and in hertz. This output is also included in the
debug output produced by option **-x** with a *debug_level* of 2 or
higher.

# ESPS PARAMETERS

The following parameters may be read, if present, from the parameter
file.

*add_const - float*  
> Constant to be added to mel-spectral powers before they are written
> out. See option **-a**. (See also option **-m** and parameter
> *mult_const.*) This parameter is not read if **-a** is specified.

*band_high - float*  
> High limit of the range of frequencies (in hertz) to be covered. See
> option **-H**. (See also option **-M** and parameters *band_low,*
> *mel_high,* and *mel_low.*) This parameter is not read if option
> **-M** or **-H** is specified or if parameter *mel_high* is also
> specified. A value of 0 implies use of the default value---see **-H**.

*band_low - float*  
> Low limit of the range of frequencies (in hertz) to be covered. See
> option **-H**. (See also option **-M** and parameters *band_high,*
> *mel_high,* and *mel_low.*) This parameter is not read if option
> **-M** or **-H** is specified or if parameter *mel_low* is also
> specified.

*mel_high - float*  
> High limit of the range of mel-scale values to be covered. See option
> **-M**. (See also option **-H** and parameters *mel_low,* *band_high,*
> and *band_low.*) This parameter is not read if **-M** or **-H** is
> specified. It takes precedence if parameter *band_high* is also
> specified. A value of 0 implies use of the default value---see **-M**.

*mel_low - float*  
> Low limit of the range of mel-scale values to be covered. See option
> **-M**. (See also option **-H** and parameters *mel_high,* *band_low,*
> and *band_high.*) This parameter is not read if option **-M** or
> **-H** is specified. It takes precedence if parameter *band_low* is
> also specified.

*mult_const - float*  
> Constant by which mel-spectral powers are to be multiplied before
> being written out. See option **-m**. (See also option **-a** and
> parameter *add_const.*) This parameter is not read if **-m** is
> specified.

*nan - int*  
> The number of records to process. See option **-r**. (See also
> parameter *start.*) A value of 0 implies processing all records from
> *start* to the end of the file; this is the default. This parameter is
> not read if **-r** is specified.

*num_freqs - int*  
> The number of mel values at which spectral values will be computed.
> See option **-n**. A value of 0 implies use of the default value (see
> **-n**). This parameter is not read if the option is specified.

*spec_type - string*  
> Allowed values are "DB" and "PWR" (case-insensitive). These indicate
> whether to output mel-spectral powers directly ("PWR") or convert them
> to dB ("DB"). See option **-S**. This parameter is not read if the
> option is specified.

*start - int*  
> The number of the first input record to process. See option **-r**.
> (See also parameter *nan.*) This parameter is not read if **-r** is
> specified.

*channel_width - float*  
> The total bandwidth in mel of each triangular filter. See option
> **-W**. This parameter is not read if the option is specified. A value
> of 0 implies use of the default value (see **-W**).

# ESPS COMMON

The ESPS common file is not accessed.

# ESPS HEADERS

The output file header is an ESPS FEA_SPEC header (see
*FEA_SPEC*(5-ESPS), *init_feaspec_hd*(3-ESPS)). A copy of the input
header is included in the output file as a source header. The output
file is tagged if and only if the input file is tagged. If the files are
tagged, the *refer* file name in the output header is copied from the
input header, and the generic header item *src_sf* is copied from the
input header if present; otherwise the value of *sf* is used. Output
generic header items *start_time* and *record_freq* are determined by
the corresponding input header items, if present, and by the *start*
record number.

Generic header items *add_const,* *band_high,* *band_low,*
*channel_width,* *mel_high,* *mel_low,* *mult_const,* *nan,* and *start*
are added to the output file header to record the values specified with
the corresponding parameters and options. The data types of the header
items are DOUBLE for *float* parameters and LONG for *int* parameters.
The usual FEA_SPEC generic header item *spec_type* (see
*FEA_SPEC*(5-ESPS)) takes the CODED value SPTYP_DB or SPTYP_PWR, as
determined by the parameter *spec_type* or the argument of **-S**, and
the usual FEA_SPEC generic header item *num_freqs* takes the value of
*num_freqs.*

A special generic header item *mel_freqs* of type FLOAT is added to
record the selected set of uniformly spaced mel values *m* for which
mel-spectral values are computed. The equivalent linear frequencies
(nonuniformly spaced) are recorded in the usual FEA_SPEC generic header
item *freqs* (see *FEA_SPEC*(5-ESPS)).

# FUTURE CHANGES

None contemplated.

# EXAMPLES

# ERRORS AND DIAGNOSTICS

The program prints a synopsis of command-line usage and exits if an
unknown option is specified or if the number of file names is wrong. It
exits with an error message if *input.spec* and *output.spec* are the
same (but not \`\`-''); if *input.spec* does not exist or is not an ESPS
FEA_SPEC file; if *freq_format* in the input file is not SYM_EDGE; if
the range of record numbers (see **-r**) is empty or starts before the
beginning of the file; if the mel-scale range to be covered (see **-H**
and **-M**) is less than *channel_width* (see **-W**); if **-H** and
**-M** are both specified; if neither *channel_width* nor *num_freqs*
(see **-n**) is specified; if *channel_width* is 0 or negative; if
*num_freqs* (see **-n**) is less than 1; if *num_freqs* is 2 or more,
but the uniform interval between mel values (see **-M**) is 0 or less;
if any of these mel values corresponds to a frequency less than 0 or
greater than the Nyquist frequency; or if an unsupported *spec_type*
(see **-S**) is specified.

# BUGS

None known.

# REFERENCES

\[1\] Steve Young, Julian Odell, Dave Ollason, Valtcho Valtchev, and
Phil Woodland, *The HTK Book,* Entropic, 1997.

# SEE ALSO

*barkspec*(1-ESPS), *fft*(1-ESPS), *me_spec*(1-ESPS),\
*init_feaspec_hd*(3-ESPS), *FEA_SPEC*(5-ESPS)

# AUTHOR

Rodney Johnson
