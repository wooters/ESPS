# NAME

    win_filt - Designs a FIR filter using Kaiser Windowing

# SYNOPSIS

**win_filt** **-P** *param_file* \[ **-x** *debug_level* \] file.filter

# DESCRIPTION

The program *win_filt* designs a linear-phase finite-impulse response
(FIR) filter with its specifications defined in the parameter file
*param_file*. The filter coefficients are saved in the output file
*file.filter*. If *file.filter* is replaced by "-", the standard output
is written.

The design method is based on the Kaiser Window -- a *sinc* function
representing the ideal response is multiplied by a Kaiser window to
obtain a finite length filter. Type I (symmetric and odd) and type II
(symmetric and even) multiband filter design are supported.

Also see the shell script *xfir_filt(1-ESPS)* that is a cover script for
this and other FIR filter design program.

Use *filtspec(1-ESPS)* to compute the actual filter response; use
*plotspec(1-ESPS)* to view the response. For example,

*filtspec file.filter - \| plotspec -*

The number of output filter taps is determined automatically by
*win_filt* in order to meet the design specification.

# OPTIONS

The following options are supported:

**-P** *param_file \[params\]*  
uses the parameter file *param_file* rather than the default, which is
*params*.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *win_filt* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

The following parameters are read from the *param_file*.

*samp_freq - float*  
Specifies the sampling frequency of the filter. This number is used for
scaling the values of *band_edge\[i\]* parameters.

*nbands - int*  
Specifies the number of bands. For example, for a bandpass filter,
*nbands* is *3*.

*band_edge\[i\] - float*  
Specifies the *i*th cutoff frequency in Hz. There are *nbands+1*
*band_edge\[i\]* parameters. The first *band_edge1* must start with 0,
and the last frequency must end with the Nyquist rate. The cutoff
frequency is in the center of the region specified by *trans_band*. For
example, for a 8KHz bandpass filter with stopband of 0 to 800 Hz and
2200 to 4000 Hz, and passband of 1200 to 1800 Hz, the parameter
*Band_edge1* is 0, *band_edge2* is 1000, *band_edge3* is 2000,
*band_edge4* is 4000, and *trans_band* is 400. Typically, the filter is
6 dB down at the band edge of transition.

*band\[i\]\_des - float*  
Specifies desired value for the *i*th band. For example, for a 3-band
bandpass filter, *band1_des* is 0, *band2_des* is 1, and *band3_des* is
0;

*rej_db - float*  
Specifies both the rejection ratio in dB from one passband to stopband,
and the peak error in the passband.

*trans_band - float*  
Specifies the transition bandwidth in Hz from one band to another.

*evenflag - int*  
This is an optional parameter. If not specified, by default *win_filt*
designs a filter with odd filter length; otherwise, a value of 1 forces
even length, and a value of 0 forces odd length.

# ESPS COMMON

No ESPS common parameter processing is used.

# ESPS HEADERS

A new *FEA_FILT*(5-ESPS) header is created for the output file. The
program fills in appropriate values in the common part of the FEA_FILT
header as well as the following generic header items.

The *samp_freq* generic header item contains value of the *samp_freq*
parameter.

The *trans_band* generic header item contains value of the *trans_band*
parameter.

The *rej_db* generic header item contains value of the *rej_db*
parameter.

In addition, the generic header item *delay_samples* (type DOUBLE) is
added to the header. *Delay_samples* is equal to (filter length - 1)/2.
This represents the delay to the center of the peak of the impulse
response.

# FUTURE CHANGES

# EXAMPLES

# ERRORS AND DIAGNOSTICS

# BUGS

None known.

# REFERENCES

Oppenheim & Schafer, *Discrete-Time Signal Processing*, Prentice Hall,
1989

# SEE ALSO

    xfir_filt(1-ESPS), notch_filt(1-ESPS), FEA_FILT(5-ESPS),
    atofilt(1-ESPS), wmse_filt(1-ESPS), iir_filt(1-ESPS), 
    sfconvert(1-ESPS), pkmc_filt(1-ESPS), 

# AUTHOR

Derek Lin
