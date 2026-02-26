# NAME

    get_resid - LPC inverse filtering, usually for speech residual analysis

# SYNOPSIS

**get_resid** \[ **-P** *param_file* \] \[ **-{pr}***range* \] \[ **-s**
*range* \] \[ **-a** *normal* \] \[ **-i** *int_const* \] \[ **-b**
*band_width* \] \[ **-n** *nformants* \] \[ **-y** \] \[ **-x**
*debug_level* \] *in_signal* *in_coef* *out_signal*

# DESCRIPTION

This program applies a time-varying linear FIR filter to a signal. The
FIR filter typically has coefficients equal to autoregressive parameters
of the signal computed using standard LPC analysis.

*In_signal* is a 16-bit PCM *FEA_SD*(5-ESPS) file of *SHORT* data type.
*Out_signal* is the output FEA_SD filtered signal in *SHORT* data type.
*In_coef* may be a *FEA_ANA*(5-ESPS) file containing spectral parameters
in the form of reflection coefficients (if the generic header item
*spec_rep* is *RC*) or linear prediction coefficients (if *spec_rep* is
AFC), as produced by *refcof*(1-ESPS) or *transpec*(1-ESPS). Or
*In_coef* may be a *FEA*(5-ESPS) file containing the field *fm* for
formant frequencies and the field *bw* for formant bandwidths, as
produced by *formant(1-ESPS)*. *Get_resid* converts the spectral
information in *in_coef* to predictor coefficients for inverse
filtering.

If *in_signal* is an unpreemphasized speech signal, and *in_coef* is its
spectral representation, the resulting *out_signal* is an approximation
of the second derivative of the glottal flow. The derivative of the
glottal volume velocity is obtained via the **-i** option with
*int_const* close to 1.0.

If *in_signal* or *in_coef* is "-", standard input is read. But the
input files cannot both be standard input.

If *out_signal* is "-", then standard output is written.

# OPTIONS

The following options are supported:

**-P** *param_file \[params\]*  
uses the parameter file *param_file* rather than the default, which is
*params*.

**-r** *first:last*  
**-r** *first:+incr*  
Determines the range of points from input file, *in_signal*. In the
first form, a pair of unsigned integers gives the first and last points
of the range. If *first* is omitted, 1 is used. If *last* is omitted,
the last point in the file is used. The second form is equivalent to the
first with *last = first + incr*. If no range is specified, the entire
file is processed.

**-p** **  
Same as the **-r** option.

**-s** *first:last*  
**-s** *first:+incr*  
Same function as the **-r** option, but specifies the range of input
data *in_signal* in seconds

**-a** *normal \[0\]*  
A value of 1 indicates the output signal should be normalized to keep DC
gain equal to 1. This is a good choice when the residual is to be used
for epoch detection. A value of 2 results in normalization by the filter
gain. This would be appropriate if the residual is to eventually excite
a synthesizer (e.g. *lp_syn*). A value of 0 causes no normalization,
which might be appropriate for other types of synthesizers.

**-i** *int_const \[0\]*  
This is an integration constant between 0 and 1.0 that specifies the
coefficient of a first-order integrator to be applied to the inversed
signal to get an approximation of glottal flow derivative. If the speech
was preemphasized during the LPC analysis used to obtain the LPC
coefficients, the correct value of *int_const* would usually be 0.0.

**-n** *nformants*  
If the input *in_coef* contains formant frequencies, this parameter
specifies that only the first *nformants* formants should used to
inverse filter the speech. The default is to use all formants in the
file.

**-b** *bandwidth*  
If the input *in_coef* contains formants and their bandwidths, this
parameter specifies the formant bandwiths that should be used, rather
than the default bandwidths stored in the file. If BW is the argument to
the -b option, then *B\[i\] = int(BW) + F\[i\] \* (BW - int(BW))* where
*F\[i\]* are the formant frequencies, *int(BW)* is the integer part of
the parameter *BW*, and *B\[i\]* are the synthetic bandwidths.

**-y**  
If *-y* is specified the coefficients and gains will switch abruptly at
frame boundaries. Otherwise, the LP coefficients and gain will be
linearly interpolated between frame centers.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *get_resid* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

The following parameters options are supported.

*start - integer*  
> The first point in the input sampled data file that is processed. A
> value of 1 denotes the first sample in the file. This is only read if
> the **-p** option is not used. If it is not in the parameter file, the
> default value of 1 is used.

*nan - integer*  
> The total number of data points to process. If *nan* is 0, the whole
> file is processed. *Nan* is read only if the **-p** option is not
> used. (See the discussion under **-l**).

*int_const - float*  
> See **OPTIONS**.

*normal - int*  
> See **OPTIONS**.

*band_width - float*  
> See **OPTIONS**. A value 0 means default.

*nformants - int*  
> See **OPTIONS**. A value 0 means default.

*interp - int*  
> See the **-y** option in **OPTIONS**. A value 1 is to interpolate; 0
> for otherwise.

# ESPS COMMON

No common parameter processing is supported

# ESPS HEADERS

The standard generic header items, *start_time* for the starting time in
seconds and *record_freq* for sampling frequency, and all non-default
parameters used for processing are written to the header.

# FUTURE CHANGES

# EXAMPLES

See the example on the manual page for *epochs (1-ESPS)*.

# ERRORS AND DIAGNOSTICS

# BUGS

None known.

# REFERENCES

# SEE ALSO

    refcof(1-ESPS), get_f0(1-ESPS), epochs(1-ESPS), 
    filter2(1-ESPS), formant(1-ESPS), formsy(1-ESPS)

# AUTHORS

David Talkin, Derek Lin
