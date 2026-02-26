# NAME

    pkmc_filt - design an equiripple FIR filter using the Parks-McClellan algorithm

# SYNOPSIS

**pkmc_filt** **-P** *param_file* \[ **-x** *debug_level* \]
*file.filter*

# DESCRIPTION

The program *pkmc_filt* designs a linear-phase finite-impulse response
(FIR) filter that meets the specification defined in the parameter file
*param_file*. The filter coefficients are saved in the output file
*file.filter*. If *file.filter* is replaced by "-", the standard output
is written.

The design method is based on the Parks-McClellan algorithm. The
resulting filter minimizes the maximum-weighted approximation-error. One
of the four standard FIR types is produced. For a filter with multiple
stopbands and passbands, the Type 1 (symmetric and odd length) or Type 2
(symmetric and even length) filter is designed. For a differentiator or
a Hilbert Transformer, either the Type 3 (anti-symmetric and odd length)
or the Type 4 (anti-symmmetric and even length) is designed.

Frequency responses of Types 2 and 3 filters are equal to 0 at PI, which
is undesirable for a highpass filter. For multiple stopbands/passbands
filters, type 1 and 2 are used. For differentiator and Hilbert
transformer, type 3 and 4 are used.

A generic Parks-McClellan algorithm is implemented here, without
numerical optimization. Numerical problem occurs for filter with more
than 100 taps, narrow passbands/stopbands, large transition bands, and
non-symmetrical transition bands. In some cases, the algorithm does not
detect the problem. Typically the filter gain for such cases are large,
exceeding 1.0. Always check the result by *filtspec (1-ESPS)* and
*plotspec (1-ESPS)*.

Also see the shell script *xfir_filt(1-ESPS)* that is a cover script for
this and other FIR filter design programs.

# OPTIONS

The following option is supported:

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *pkmc_filt* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

The following parameters are read from the *param_file*:

*filt_type - string*  
The type of filter desired. Use *MULTIBAND* for lowpass, highpass,
bandpass, bandstop, and arbitrary multiple stop/passbands FIRs. Use
*DIFFERENTIATOR* for a differentiator and *HILBERT* for Hilbert
transform filter.

*filt_length - int*  
Number of taps for the filter.

*ngrid - int*  
This is an optional parameter. It specifies the number of grid points
used for interpolation from 0 to PI/2. The default value is 2 \*
*filt_length*.

*samp_freq - float*  
The sampling frequency. This number is used for rescaling the values of
bandedge parameters.

*nbands - int*  
Number of bands from 0 to *samp_freq/2*. For example, for a *MULTIBAND*
filter type, a lowpass filter has 2 bands -- a passband from 0 to some
frequency *f1* and a stopband from some frequency *f2* to *samp_freq/2*,
where *f1\<f2*. For a differentiator, *nbands* is 1 if a full band
differentiator is desired, 2 otherwise. For a Hilbert transform filter,
*nbands* is always 1, and its band extend from 0 to *samp_freq/2*.

The following set of the parameters have the forms of
*band\[i\]\_edge1*, *band\[i\]\_edge2*, *band\[i\]\_des*, and
*band\[i\]\_wt*, where *i* denotes the band number. For example,
*band2_edge1* is a parameter for the left edge of the second band. The
number of sets of these parameters must be equal to *nbands*. Band 1 is
the left-most band, band *nband* is the right-most band.

The response at the band edges is automatically determined by the
algorithm, the error on the band edge is the same equi-ripple error of
the band. The generic header item *ripple_db* in the output file
contains the equi-ripple error in dB that represents the smallest
approximation error that meets the specification.

*band\[i\]\_edge1 - float*  
The left edge of *i*th band. It must be 0 for *band1_edge1*.

*band\[i\]\_edge2 - float*  
The right edge of *i*th band. It must be *samp_freq/2* for the last
band. *band\[i\]\_edge2* and *band\[i+1\]\_edge1* can not be the same
number. In fact *band\[i\]\_edge2 \>* band\[i+1\]\_edge1.

*band\[i\]\_des - float*  
For *MULTIBAND* filter type, it is the desired constant value for the
*i*th band. For *DIFFERENTIATOR* filter type, it is the slope of the
frequency response on the passband. The slope is measured by the
amplitude response over normalized frequency axis. For *HILBERT*, it
should be set to 1.

*band\[i\]\_wt - float*  
For *MULTIBAND* filter type, it is the constant weighting factor for the
approximation error in *i*th band. The weights in bands are relative to
one another. For example, in a two band filter, *band1_wt* of 10 and
*band2_wt* of 20 are the same as *band1_wt* of 1 and 2 for the other
band. For *DIFFERENTIATOR* filter type, the weighting function *1/f* is
appplied to the the passband region of the differentiator. For
*HILBERT*, it should always be set to 1.

# ESPS COMMON

No ESPS common parameter processing is used.

# ESPS HEADERS

A new FEAFILT header is created for the output file. The program fills
in appropriate values in the common part of the header as well as the
following generic header items associated with the FEAFILT type.

The *samp_freq* generic header item contains value of the *samp_req*
parameter.

The *band_edges* generic header item of size *2\*nbands* is an array
containing the left and rights band edges of bands.

The *desired_value* generic header item of size *nbands* is an array
containing the *band\[i\]\_des* parameters

The *desired_weight* generic header item of size *nbands* is an array
containing the *band\[i\]\_wt* parameters

The *ripple_db* generic header item of size *nbands* is an array
containing the error in dB for each band.

In addition, the generic header item *delay_samples* (type DOUBLE) is
added to the header. *Delay_samples* is equal to (filter length - 1)/2.
This represents the delay to the center of the peak of the impulse
response.

# FUTURE CHANGES

# EXAMPLES

The following parameter file designs a bandpass filter with stop band
from 0 to 500 Hz, passband from 1000 to 2000 Hz, and stopband from 2500
to 4000 Hz.

    	int filt_length = 32;
    	float band1_edge1 = 0.000000;
    	float band1_edge2 = 500.000000;
    	float band1_des = 0.000000;
    	float band1_wt = 1.000000;
    	float band2_edge1 = 1000.000000;
    	float band2_edge2 = 2000.000000;
    	float band2_des = 1.000000;
    	float band2_wt = 1.000000;
    	float band3_edge1 = 2500.000000;
    	float band3_edge2 = 4000.000000;
    	float band3_des = 0.000000;
    	float band3_wt = 1.000000;
    	string filt_type = "MULTIBAND";
    	float samp_freq = 8000.000000;
    	int nbands = 3;

The unspecified regions from 500 to 1000 Hz and 2000 to 2500 Hz are
unspecified and are taken as transition bands which will have arbitray
repsonse.

# ERRORS AND DIAGNOSTICS

# BUGS

None known.

# REFERENCES

Oppenheim & Schafer, *Discrete-Time Signal Processing*, Prentice Hall,
1989

# SEE ALSO

xfir_filt(1-ESPS), cb_filt(1-ESPS), win_filt(1-ESPS),
notch_filt(1-ESPS), FEA_FILT(5-ESPS), atofilt(1-ESPS),
wmse_filt(1-ESPS), iir_filt(1-ESPS), sfconvert(1-ESPS)

# AUTHOR

Derek Lin
