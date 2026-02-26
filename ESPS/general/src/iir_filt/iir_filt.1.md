# NAME

iir_filt - design recursive filter.

# SYNOPSIS

**iir_filt** \[ **-P** *param_file* \] \[ **-x** *debug_level* \]
*filt_file*

# DESCRIPTION

*Iir_filt* designs a recursive filter (often called an infinite impulse
response filter) and puts the coefficients, poles, and zeros in the
*FEA_FILT*(5-ESPS) file *filt_file.* It supports filter reponse types of
lowpass, highpass, bandpass, and bandstop filters. The design methods
supported are Butterworth, Chebyshev1, Chebyshev2, and elliptical
methods. Other input parameters are passband and stopband frequency
edges, and the frequency versus loss characteristics.

All the design information must be supplied in the parameter file. By
using *eparam*(1-ESPS), however, the user will be prompted for all the
design information.

If *filt_file* is "-", the output goes to standard output.

# OPTIONS

The following options are supported:

**-P** *param_file*  
The file *param_file* is used for the parameter file instead of the
default, which is *params.*\

**-x** *debug_level*  
A value of 0 (the default value) will cause *iir_filt* to work silently,
unless there is an error. A nonzero value will cause various parameters
to be printed out during the filter design. A value greater than 9 will
cause all the debug messages to be printed.\

# ESPS PARAMETERS

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

> *samp_freq - float*

> The value of the sampling frequency.

> *gain - float*

> The gain of the filter in the pass band.

> *filt_method - string*

> The type of the polynomial used in the filter design. The options are
> BUTTERWORTH, CHEBYSHEV1, CHEBYSHEV2, and ELLIPTICAL.

> *filt_type - string*

> The type of filter response to design. Allowable types are the
> following: low pass (LP), high pass (HP), band pass (BP), and band
> stop (BS).

> *pass_band_loss - float*

> Specifies the maximum dB deviation from 1 for the filter amplitude
> response within the pass band.

> *stop_band_loss - float*

> Specifies the minimum dB loss for the filter amplitude response in the
> stop band from the pass band.

> *p_freq1 - float*

> Also referred to as "passband frequency 1". For lowpass and highpass
> filters, this is the passband frequency. For bandpass and bandstop
> filters, this is the first passband frequency. See **EXAMPLES** below.

> *s_freq1 - float*

> Also referred to as "stopband frequency 1". Stop band frequency for
> low pass and high pass filters. Or the first stop band frequency for
> band pass and band stop filters. See **EXAMPLES** below.

> *p_freq2 - float* Also referred to as "passband frequency 2". The
> second pass band frequency for band pass and band stop filters. This
> is ignore for lowpass and highpass filters. See **EXAMPLES** below.

> *s_freq2 - float* Also referred to as "stopband frequency 2". The
> second stop band frequency for band pass and band stop filters. This
> is ignore for lowpass and highpass filters. See **EXAMPLES** below.

> *filt_order - int*

> This is an optional parameter. Only use this parameter if the optimal
> filter order computed by the program to meet the filter specification
> is not desired. If *filt_order* is present, *iir_filt* uses this
> parameter for its filter order. A warning message is printed, values
> for the optimal filter order and *filt_order* are printed.

# ESPS COMMON

Esps Common is not processed.

# ESPS HEADER

A new FEA_FILT header is created for the output file. The program fills
in appropriate values in the common part of the header as well as the
following generic header items associated with the FEA_FILT type

> *max_num*

> It is set equal to *filt_order*.

> *max_denom*

> It is set equal to *filt_order*.

> *func_spec*

> It is set equal to IIR.

> *type*

> It is set equal to the specified *filt_type* value.

> *method*

> It is set equal to the specified *filt_method* value.

> *define_pz*

> It is set to YES.

> *pass_band_loss*

> It is set equal to *pass_band_loss*.

> *stop_band_loss*

> It is set equal to *stop_band_loss*.

> *filt_order*

> It is the filter order.

# WARNING

The stopband loss of the Elliptical filter may not meet the desired
specification in some cases. This is due to the approximation procedure
involved in the Elliptical filter design method that maximizes the
stopband attenuation, but gives the desired passband attenuation,
passband frequencies, and stopband frequencies. In these cases, raise
the stopband loss, *stop_band_loss*.

The filter response can be plotted and viewed using *filtspec(1-ESPS)*
and *plotspec(1-ESPS)*, for example,

*filtspec filt_file - \| plotspec -*

# FUTURE CHANGES

A generic header item *delay_samples*, which has the "filter delay" in
samples, will be added. This will enable programs to automatically
compensate for the delay caused by the filter and allow plotting
programs to automatically time align waveforms.

For now, *impulse_resp*(1-ESPS) and *plotsd*(1-ESPS) can be used to
compute and plot the impulse response, which can be visually inspected
to locate the peak of the response. The offset of the peak from the
beginning of the response is often useful as an estimate of the delay.
*addgen*(1-ESPS) can then be used to add the *delay_samples* generic
header item.

# EXAMPLES

The parameters *p_freq1, s_freq1, p_freq2*, and *s_freq2* are used in
the following manner for each filter response type. Suppose the Nyquist
rate is denoted as *nf*.

                  passband (Hz)      stopband (Hz)
     Lowpass      0 to p_freq1      s_freq1 to nf   
     Hihgpass     0 to s_freq1      p_freq1 to nf   

                  stopband1          passband              stopband2
     Bandpass     0 to s_freq1      p_freq1 to p_freq2     s_freq2 to nf

                  passband1          stopband              passband2
     Bandstop     0 to p_freq1      s_freq1 to s_freq2     p_freq2 to nf   


    The easiest way to use this program is by eparam(1-ESPS).  Depending
    on the filter reponse type (e.g. lowpass) selected, eparam(1-ESPS)
    prompts for appropriate pass/stopband frequency edges (e.g. p_freq1) 
    from left to right.  Simply enter frequencies in an ascending order as 
    they are prompted.  For examples, suppose a bandpass filter,

       %eparam iir_filt bandpass.filt
       Desired filter type: [ELLIPTICAL]  (Choices are: BUTTERWORTH CHEBYSHEV1 
       CHEBYSHEV2 ELLIPTICAL):
       Desired filter reponse [LP]  (Choices are: LP HP BP BS):BP
       Desired sampling frequency. [8000] :
       Stopband frequency 1 [1100] :1000
       Passband frequency 1 [1000] :1100
       Passband frequency 2 [2100] :2000
       Stopband frequency 2 [2000] :2100
       Desired maximum pass band loss (dB). [1] :
       Desired minimum stop band attenuation (dB). [20] :

This creates a bandpass filter with passband over 1100 to 2000 Hz, and
stopband over 0 to 1000 Hz and 2100 to 4000 Hz.

# SEE ALSO

    ESPS(5-ESPS), FEA(5-ESPS), FEA_FILT(5-ESPS), filter2(1-ESPS), 
    wmse_filt(1-ESPS), notch_filt(1-ESPS), xpz(1-ESPS)

# REFERENCES

Parks, T. W. and Burrus, C. S., *Digital Filter Design*, John Wiley and
Sons, 1987, New York

Sublett, B. and Burton, D., *ESPS APPLICATIONS NOTE: Filtering Sampled
Data*, ESPS USER'S MANUAL

# AUTHOR

Derek Lin
