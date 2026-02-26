# NAME

fft_filter - Performs FIR digital filtering on a sampled data file using
frequency domain convolution instead of time domain convolution.

# SYNOPSIS

**fft_filter** \[ **-P** *param_file* \] \[ **-x** *debug_level* \] \[
**-f** *filtername* \] \[ **-F** *filt_file* \] \[ **-p** *range* \] \[
**-r** *range* \] \[ **-z** \] *in_file out_file*

# DESCRIPTION

The program *fft_filter* takes the input sampled data file, *in_file,*
and produces an output sampled data file, *out_file,* after performing a
finite impulse response (FIR) digital filtering operation on it. The
program accepts "-" for either the input file or the output file to use
the standard input and standard output, respectively. This program
accomplishes the filtering operation by multiplying in the frequency
domain, instead of convolving in the time domain. If the filter length
is large (i.e. \> 50 taps), this has the effect of greatly reducing the
number of computations required to perform the filtering operation.

The program performs only FIR filtering. A set of numerator coefficients
are specified either in a parameter file or in a FEA_FILT(5-ESPS) file.
The numerator coefficients then become the {ai} in the following
z-domain transfer function:


            
     		H(z) = a0 + a1z-1 + a2z-2 + ... + am-1z-m+1

The first output sample will be computed from data samples occurring
before the starting point in the input file (as defined by the parameter
*start* , for example), if they exist. Data samples which would occur
before the first sample in the input file are assumed to be zero.

# OPTIONS

The following options are supported:

**-P** *param_file*  
uses the parameter file *param_fil* rather than the default, which is
*params.*\

**-f** *filtername*  
If the coefficients are being read from the parameter file, then
*filtername* is the body of the name in the params file that contains
both the number of coefficients and the actual coefficients. This means
that the coefficients will be found in the array *filtername_num,* and
the size of that array will be specified by *filtername_nsiz.* The
default name for the body of these parameter file entries is *filter.*

If the coefficients are being read from a FEA_FILT file, then
*filtername* is the number of the fft_filter record to use. The default
name in this case is 1, the first record in the file.\

**-F** *filt_file*  
Read the coefficients from the FEA_FILT file *filt_file* rather than
from the parameter file. In this case the header of *filt_file* is added
to the header of the program output as a source file. If the denominator
size is neither zero nor one an error message will be printed and
*fft_filter* will exit.\

**-x** *debug_level*  
A value of zero (the default value) will cause *fft_filter* to do its
work silently, unless there is an error. A nonzero value will cause
various parameters to be printed out during program initialization.\

**-p** *range*  
Perform the filtering operation on the specified range of points.
*range* is a character string which is interpreted by
*range_switch*(3-ESPSu). **p** and **r** are synonyms.\

**-r** *range*  
Perform the filtering operation on the specified range of points.
*range* is a character string which is interpreted by
*range_switch*(3-ESPSu). **p** and **r** are synonyms.

**-z**  
If specified, the *start_time* generic value is reduced by the value of
the *delay_samples* generic header value, if it exists. This often helps
time align a filtered signal with the input signal. Note that if
*delay_samples* is not defined in the input file header, a value of 0 is
assumed.

# ESPS PARAMETERS

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

Where command line options conflict with parameter file options, the
command line values are used. The following parameters are read from the
parameter file.

> *start - integer*

> The first point in the input sampled data file that is processed. The
> samples are assumed to be numbered starting with one so that setting
> *start = 1* will cause processing to begin with the first sample.
>
> *nan - integer*

> The number of points in the sampled data file to process.
>
> *filtername_nsiz - integer*

> The number of coefficients in the transfer function for the filter
>
> *filtername_num - float array*

> The numerator coefficients. They are specified in order starting with
> a0.

# ESPS COMMON

If the input is standard input, COMMON is not read. If COMMON is read
and the command line input filename does not match the filename listed
in COMMON, no further parameters are read from COMMON. Finally, if the
two filenames match, the following items are read.

> *start - integer*

> This is the starting point in the input file. Any **-p** option value
> supersedes the COMMON specified value.

> *nan - integer*

> This is the number of points to analyze. A **-p** specified value
> supersedes the COMMON specified value.

If the output is standard output, COMMON is not written. Otherwise the
following items are written to COMMON.

> *filename - string*

> This is the name of the output file.

> *start - integer*

> This is the starting point in the output file and is always equal to
> one.

> *nan - integer*

> This is the number of points in the output file.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADER

The file header of *out_file* will contain much of the same information
as is contained in *in_file,* except where they are altered by the
parameters in the parameter file. The filter coefficients will be stored
in the output header as the *fft_filter* zfunc.

A generic header item *start_time* (type DOUBLE), is added to the output
file header. It contains the starting time in seconds of the first point
in the output file. This start time is relative to the original sampled
data file. This means that if the input file has a *start_time* generic
in it, the output file's *start_time* value is computed relative to the
input file's *start_time*. Also see the **-z** option.

For example, if the input file has a *start_time* = 1.0 seconds, the
input file's sampling frequency = 8000 samples/second, and the starting
point in the input file = 2000, the output file's *start_time* = 1.0 +
2000/8000 = 1.25 seconds.

# FUTURE CHANGES

# SEE ALSO

    FEA_FILT(5-ESPS), filter(1-ESPS), wmse_filt(1-\SPS),
    atofilt(1-ESPS), FEA_SD(5-ESPS), iir_filt(1-ESPS),
    sfconvert(1-ESPS)

None known.

# AUTHOR

Brian Sublett; ESPS 3.0 modifications by David Burton; FEA_FILT
modifications by Bill Byrne
