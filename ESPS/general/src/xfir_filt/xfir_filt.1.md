# NAME

    xfir_filt - A cover script for ESPS filter design programs 
    using XIG interface

# SYNOPSIS

**xfir_filt** *outfile* \[ *paramfile* \]

# DESCRIPTION

This shell script is intended as an example of extending ESPS programs
with XIG user interface to build a customized filtering design
environment. This example is far from perfect. Free free to modify it to
suit your needs.

Four FIR filter design programs are supported in this script:
*pkmc_filt*(1-ESPS), *cb_filt*(1-ESPS), *wmse_filt*(1-ESPS), and
*win_filt*(1-ESPS) \[1\]. The XIG programs used to create X-window
interface for parameter prompting are *exprompt*(1-ESPS) and
*expromptrun*(1-ESPS) \[2\]. Please see their man pages for usage
details.

The program first pops up a window with the following parameters:

*filt_method*: determines which FIR design algorithm or program to use.
A value of "EQUI_RIPPLE" is to use the Parks-McClellan algorithm or the
program *pkmc_filt*(1-ESPS). A value of "CONSTRAINT_BASED" is to use the
Simplex algorithm or the program *cb_filt*. A value of "WEIGHTED_MS" is
to use minimum mean square error algorithm or the program
*wmse_filt*(1-ESPS). And a value of "WINDOW_METH" is to use the Kaiser
windowing algorithm or the program *win_filt*(1-ESPS).

*filt_type*: determines the filter response type. A value of "MULTIBAND"
designs a multi-band filter. Values of "LOWPASS" and "HIGHPASS" design a
lowpass filter and a highpass filter. A bandpass, or bandstop filter
design interface can be constructed similarly. "DIFFERENTIATOR" for a
differentiator, this is only available to *pkmc_filt*(1-ESPS) and
*cb_filt*(1-ESPS). "HILBERT" for Hilbert transformer, this is only
available to *pkmc_filt*(1-ESPS).

WARNING: IF "MULTIBAND" IS SELECTED, IT IS YOUR RESPONSIBILITY TO ENTER
VALID PARAMETER VALUES. DEFAULT SETTINGS DO NOT WORK.

*nbands*: determines the number of bands in a multi-band filter response
type. For examples, a lowpass filter has 2 bands, and a bandpass filter
has 3 bands.

*samp_freq*: This is the sampling rate of the filter.

Once the button "done" is pressed, the set of parameters determines
which program to use and parameters for that program is constructed
accordingly in a temporary file. This file is then used by XIG programs
such as *exprompt*(1-ESPS) to query for filter bandedge frequencies,
band values, etc... If the optional output parameter file name,
*paramfile*, is given on the command line, actual parameters used by the
program is saved to it.

The filter is then designed and saved to *outfile*. Its filter response
is calculated by *filtspec*(1-ESPS) and plotted on screen by
*plotspec*(1-ESPS).

# REFERENCES

1\. "ESPS Applications Note: Filtering Sampled Data".

2\. "ESPS Applications Note: X Interface Generation in ESPS and
*xwaves*"

# SEE ALSO

*pkmc_filt*(1-ESPS), *cb_filt*(1-ESPS), *wmse_filt*(1-ESPS),
*win_filt*(1-ESPS), *iir_filt*(1-ESPS), *xeparam*(1-ESPS),
*exprompt*(1-ESPS), *expromptrun*(1-ESPS), *FEA_FILT*(5-ESPS)

# AUTHOR

Derek Lin
