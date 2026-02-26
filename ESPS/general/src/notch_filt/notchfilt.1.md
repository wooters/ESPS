# NAME

notch_filt - design a second order notch filter.

# SYNOPSIS

**notch_filt** \[ **-P** *param_file* \] \[ **-x** *debug_level* \] \[
**-s** *samp_freq* \] \[ **-n** *notch_freq* \] \[ **-b** *band_width*
\] \[ **-g** *gain* \] *feafilt_file*

# DESCRIPTION

The program *notch_filt* designs an IIR notch filter and writes the
coefficients to the *FEA_FILT*(5-ESPS) file *feafilt_file.* The user
must specify the sampling frequency, the frequency of the notch center,
and the desired notch bandwidth. These parameters may be specified in
the parameter file, or on the command line. The notch bandwidth is
defined as the distance in the frequency domain between the -6 dB.
points (magnitude) on either side of the notch.

If *feafilt_file* is "-", the output goes to the standard output.

Use *filtspec(1-ESPS)* to compute the actual filter response; use
*plotspec(1-ESPS)* to view the response. For example,

*filtspec feafilt_file - \| plotspec -*

# OPTIONS

The following options are supported:

**-P** *param_file*  
The file *param_file* is used for the parameter file instead of the
default, which is *params.*\

**-x** *debug_level*  
A value of 0 (the default value) will cause *notch_filt* to do its work
silently, unless there is an error. A nonzero value will cause various
parameters to be printed out during program initialization.\

**-s** *samp_freq*  
The value *samp_freq* is used for the sampling frequency instead of the
value given in the parameter file.\

**-n** *notch_freq*  
The value *notch_freq* is used for the notch frequency instead of the
value given in the parameter file.\

**-b** *band_width*  
The value *band_width* is used for the notch bandwidth instead of the
value given in the parameter file. The notch bandwidth is defined as the
distance (in Hz.) between the -6 dB points on either side of the notch
frequency in the magnitude response spectra.\

**-g** *gain*  
The d.c. gain of the filter. The default is 1.0.\

# ESPS PARAMETERS

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

The following parameters are read from the parameter file if they are
not entered on the command line. If all three values are provided on the
command line then the parameter file need not be provided.

*samp_freq - float*  
The value of the sampling frequency.

*notch_freq - float*  
The value of the notch frequency.

*band_width - float*  
The value of the notch bandwidth. The notch bandwidth is defined as the
distance (in Hz.) between the -6 dB points on either side of the notch
frequency in the magnitude response spectra.

# ESPS COMMON

Esps Common is not processed.

# ESPS HEADER

A new *FEA_FILT*(5-ESPS) header is created for the output file. The
program fills in values in the common part of the header as well as the
generic header items associated with the *FEA_FILT*(5-ESPS) file type.

*max_num*  
This value is always set to 3.

*max_denom*  
This value is always set to 3.

*complex_filter*  
These values are always set to NO.

*define_pz*  
This value is set to YES.

*func_spec*  
This value is set to BAND.

*nbands*  
This value is set to 3.

*type*  
This value is set to BS.

*method*  
This value is set to PZ_PLACE.

*band edges*  
There are six values entered in this array corresponding to the three
frequency "bands". The band edges of band \#1 will be 0 Hz. and the
lower -6 dB. point. The band edges of band \#2 are both set to the notch
frequency. The band edges of band \#3 will be the upper -6 dB. point and
half the sampling frequency.

*gains*  
There are three values in this array corresponding to the three
frequency "bands". The values are set to *gain,* 0.0, and *gain.*

In addition, three generic header items are added: *samp_freq,*
notch_freq, and *band_width*.

*samp_freq - double*  
The sampling frequency is stored here.

*notch_freq - double*  
The center frequency of the notch is stored here.

*band_width - double*  
The 6 dB bandwidth of the notch is stored here.

The fields *num_degree* and *denom_degree* in the output records are
always set to 3. The filter pole and zero locations are written to the
output file.

# DIAGNOSTICS

The program prints a message to the standard error output and exits if
*nf* is not less than one half the sampling frequency or if *nf* +/-
*bw/2* does not fall in the range from zero Hz. to one half the sampling
frequency.

# SEE ALSO

*FEA*(5-ESPS), *FEA_FILT*(5-ESPS), *filter*(1-ESPS),\
*wmse_filt*(1-ESPS), *xpz*(1-ESPS), *iir_filt*(1-ESPS)

# AUTHOR

Brian Sublett. FEA_FILT modifications by Bill Byrne.
