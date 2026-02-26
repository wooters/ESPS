# NAME

filter - Performs digital filtering on a sampled data file.

# SYNOPSIS

**filter** \[ **-P** *param_file* \] \[ **-p** *range* \] \[ **-r**
*range* \] \[ **-d** *data_type* \] \[ **-f** *filtername* \] \[ **-F**
*filt_file* \] \[ **-x** *debug_level* \] \[ **-i** *up/down* \] \[
**-z** \] *in_file out_file*

# DESCRIPTION

This program is considered obsolete and will be eliminated in future
next Entropic software releases and replaced by the new program,
currently called *filter2*. See the manual entry for *filter2*.

The program *filter* takes the input sampled data file, *in_file,* and
produces an output sampled data file, *out_file,* after performing a
digital filtering operation on it. The output sampled data file is of
type FEA_SD (5-ESPS). *Filter* allows the user to change the data type
of the output file by using the **-d** option; see below for more
details. The program accepts "-" for either the input file or the output
file to use the standard input and standard output, respectively.

The program may implement either finite impulse response (FIR) or
infinite impulse response (IIR) filters. A set of numerator coefficients
and (optionally) a set of denominator coefficients are specified either
in the parameter file or in the FEAFILT file. Currently, only real
filters may be used; if a filter is complex, it's imaginary part is
ignored. The numerator coefficients then become the {ai} and the
denominator coefficients become the {bi} in the following z-domain
transfer function:


            
                           a0 + a1z-1 + a2z-2 + ... + am-1z-m+1
            H(z)  =   ___________________________________

                           b0 + b1z-1 + b2z-2 + ... + bn-1z-n+1

An FIR filter corresponds to the case where, in the equation above, b0 =
n = 1. An FIR filter may also be specified by choosing the order of the
denominator to be zero, and entering no denominator coefficients at all.

The program uses a different initialization procedure for FIR filters
than it uses for IIR filters. For FIR filtering, the first output will
be computed from data samples occurring before the starting point in the
input file (as defined by the parameter *start* , for example), if they
exist. Data samples which would occur before the first sample in the
input file are assumed to be zero. For IIR filtering, all inputs and
outputs occurring before the starting point are assumed to be zero.

# OPTIONS

The following options are supported:

**-P** *param_file*  
uses the parameter file *param_fil* rather than the default, which is
*params.*\

**-r** *range*  
Perform the filtering operation on the specified range of points.
*range* is a character string which is interpreted in the format
understood by *range_switch (3-ESPSu).* **r** and **p** are synonyms.\

**-p** *range*  
Perform the filtering operation on the specified range of points.
*range* is a character string which is interpreted in the format
understood by *range_switch (3-ESPSu).* **-r** is a synonym for **-p**.\

**-d** *data_type*  
The argument *data_type* is a character representing the desired output
data type in *out_file*: *b* for byte, *s* for short, *l* for long, *f*
for float, and *d* for double. This data type conversion is often useful
when the input data type is short and the filtering operation produces
sample values greater in magnitude than 215 . The output type is real or
complex in agreement with the input type; for example if *d* is
specified, the output type is DOUBLE if the input is real and
DOUBLE_CPLX if the input is complex.\

**-f** *filtername*  
If the coefficients are being read from the parameter file, then
*filtername* is the body of the name of the variable that contains the
number of coefficients and the actual coefficients. This means that the
coefficients will be found in the arrays *filtername_num* and
*filtername_den* and the size of those arrays will be specified by
*filtername_nsiz* and *filtername_dsiz,* respectively. The default name
in this case is *filter.*

If the coefficients are being read from a FEAFILT file, then
*filtername* is the number of the filter record to use. The default name
in this case is 1, the first record in the file.\

**-F** *filt_file*  
Read the coefficients from the FEAFILT file *filt_file* rather than from
the parameter file. In this case the header of *filt_file* is added to
the header of the program output as a source file.\

**-x** *debug_level*  
A value of zero (the default value) will cause *filter* to do its work
silently, unless there is an error. A nonzero value will cause various
parameters to be printed out during program initialization.\

**-i** *up/down*  
Perform interpolation filtering such that the output sampling rate is
equal to *(src_sf)\*(up/down).* Both *up* and *down* are integers.
Effectively, the program increases the sampling rate to *up\*(src_sf),*
filters this signal with the specified filter, and then downsamples the
resulting signal by a factor of *down.*

**-z**  
By specifying **-z**, the *start_time* generic value is reduced by the
value of the *delay_samples* generic header value, if it exists. This
often helps time align a filtered signal with the input signal. Note
that if *delay_samples* is not defined in the input file header, a value
of 0 is assumed.

# ESPS PARAMETERS

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

The following parameters are read from the parameter file:

> *start - integer*

> The first point in the input sampled data file that is processed. The
> samples are assumed to be numbered starting with one so that setting
> *start = 1* will cause processing to begin with the first sample.
>
> *nan - integer*

> The number of points in the sampled data file to process.
>
> *filtername_nsiz - integer*

> The number of numerator coefficients in the transfer function for the
> filter *filtername.*
>
> *filtername_dsiz - integer*

> The number of denominator coefficients in the transfer function for
> the filter *filtername.* A value of zero means that a denominator
> coefficient array need not be entered.
>
> *filtername_num - float array*

> The numerator coefficients. They are specified in order starting with
> a0.
>
> *filtername_den - float array*

> The denominator coefficients. They are specified in order starting
> with b0.

# ESPS COMMON

If the input is standard input, COMMON is not read. The following items
may be read from COMMON:

> *filename - string*

> This is the name of the input file. If the command line specifies only
> one filename, it is assumed to be the output filename and COMMON is
> read to get the input filename. If the input filename is specified on
> the command line, it must match *filename* in COMMON or the other
> items (below) are not read.

> *start - integer*

> This is the starting point in the input file.

> *nan - integer*

> This is the number of points to process.

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

The file header of *out_file* will contain mostly the same information
as is contained in that of *in_file,* except where they are altered by
the parameters in the parameter file. The -i option changes the
*record_freq* header item. The filter coefficients will be stored in the
output header as the *filter* zfunc.

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

# SEE ALSO

    filter2(1-ESPS), notch_filt(1-ESPS), FEAFILT(5-ESPS), 
    atofilt(1-ESPS), wmse_filt(1-ESPS), iir_filt(1-ESPS), 
    block_filter2(3-\SPS)

# BUGS

Due to the direct form implementation of the IIR filter, this program is
numerically unstable and will not be supported in the next release. This
program will be replaced by *filter2*(1-ESPS).

# AUTHOR

Brian Sublett; ESPS 3.0 modifications by David Burton.

FEA_SD modifications by David Burton; multichannel and complex FEA_SD
modifications by Bill Byrne.
