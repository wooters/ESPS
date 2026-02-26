# NAME

    filter2 - Performs digital filtering on a sampled data file.
    filter - same as filter2

# SYNOPSIS

**filter\[2\]** \[ **-P** *param_file* \] \[ **-p** *range* \] \[ **-r**
*range* \] \[ **-d** *data_type* \] \[ **-f** *filter_string* \] \[
**-F** *filt_file* \] \[ **-x** *debug_level* \] \[ **-z** \] *input.sd
output.sd*

# DESCRIPTION

The program *filter2* performs a digital filtering operation on the
input sampled data FEA_SD(5-ESPS) file, *input.sd*, and produces an
output sampled data file, *output.sd*. The output sampled data file is
of the type FEA_SD(5-ESPS).

If *input.sd* is replaced by "-", the standard input is read. If
*output.sd* is replaced by "-", the standard output is written. If
*input.sd* is missing from the command line, *filter2* gets its name
from ESPS Common.

This program may implement either finite impulse response (FIR) or
infinite impulse response (IIR) filters. The filter data may come from a
FEA_FILT file specified by the **-F** option, or it may also be supplied
in the parameter file by the **-P** option. Currently, only real filters
are supported.

In the IIR system, the filter is realized by cascading the second order
sub-systems of pairs of poles and zeros and their complex conjugate
counterparts. Each sub-system is implemented in the direct form II. This
is to insure the numerical stability of the system.

In the case when only the numerator and denominator coefficients of H(z)
are available, the program will implement the IIR system in the direct
form using these coefficients. However, this implementation is
numerically unstable.

In FIR system, the filter is realized in the direct form.

All data samples occurring before the first sample in the input file are
assumed to be zero.

# OPTIONS

The following options are supported:

**-P** *param_file*  
uses the parameter file *param_file* instead of the default, which is
*params*.

**-r** *first:last*  
**-r** *first:+incr*  
Determines the range of points from input file for filtering. In the
first form, a pair of unsigned integers gives the first and last points
of the range. If *first* is omitted, 1 is used. If *last* is omitted,
the last point in the file is used. The second form is equivalent to the
first with *last = first + incr*.

**-p** **  
Same as the **-r** option.

**-d** *data_type \[input data type\]*  
This option specifies the data type of *output.sd*. Available data types
are DOUBLE, FLOAT, LONG, SHORT, BYTE, DOUBLE_CPLX, FLOAT_CPLX,
LONG_CPLX, SHORT_CPLX, and BYTE_CPLX. By default, output data type is
the same as the input data type.

**-f** *filter_string \[filter\]*  
If the coefficients are being read from the parameter file, then
*filt_string* is the body of the name of the variable that contains
filter coefficients. See the **ESPS_PARAMETERS** section. For example,
if this option is applied as *-f myfilter*, then the value of the
*myfilter_psiz* variable in the parameter file will be taken as the
number of poles.

If the coefficients are being read from a FEA_FILT file, then
*filter_string* is the number of the filter record to use. The default
name in this case is 1, the first record in the file.

**-F** *filt_file*  
Read the coefficients from the *FEA_FILT*(5-ESPS) file *filt_file*
rather than from the parameter file.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *filter* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

**-z** **  
By specifying **-z**, the output *start_time* generic value is reduced
by the value of the *delay_samples* generic header value of input filter
file, divided by the sampling rate of input sampled data. This often
helps time align a filtered signal with the input signal. If
*delay_samples* is not defined in the input file header, a value of 0 is
assumed.

# ESPS PARAMETERS

The following parameters are read from the parameter file:

*start - integer*  
The first point in the input sampled data file that is processed. The
samples are assumed to be numbered starting with one so that setting
*start = 1* will cause processing to begin with the first sample.

*nan - integer*  
The number of points in the sampled data file to process. A value 0
indicates to process the entire file.

*filter_file_name - string*  
The FEA_FILT file name containing the filter data.

If *filter_file_name* file exists, the rest of the parameters are
ignored.

*filter_string_psiz - integer*  
The number of poles in the transfer function for the filter without
their complex conjugate counterparts. *filter_string* is a string of
characters specified by the **-f** option.

*filter_string_zsiz - integer*  
The number of zeros in the transfer function for the filter without
their complex conjugate counterparts. *filter_string* is a string of
characters specified by the **-f** option.

*filter_string_poles - float array*  
An array of size *2\*filter_string_psiz* representing
*filter_string_psiz* poles without their complex conjugate counterparts.
Each pole is represented by 2 numbers, the first and second numbers
represent the real and imaginary parts of the pole, respectively. For
example, a system with four poles *\[0.9, 0.1i\], \[0.9, -0.1i\], \[0.8,
0.2i\],* *\[0.8, -0.2i\]*, can be stored in the parameter file by
setting *filter_string_poles = {0.9, 0.1, 0.8, 0.2}*. *filter_string* is
a string of characters specified by the **-f** option.

*filter_string_zeros - float array*  
An array of size *2\*filter_string_zsiz* representing
*filter_string_zsiz* poles without their complex conjugate counterparts.
Each pole is represented by 2 numbers, the first and second numbers
represent the real and imaginary parts of the pole, respectively.
*filter_string* is a string of characters specified by the **-f**
option.

*filter_string_gain - float*  
The overall gain for the pole-zero system of the IIR filter implemented
by cascading its second order IIR sub-systems. This variable is ignored
in the FIR system. If *filter_string_gain* is not set, and if the
numerator coefficient array is specified, its value is set to equal to
the first element of the numerator coefficient array. Otherwise, the
default value is 1. *filter_string* is a string of characters specified
by the **-f** option.

In the IIR system, the pole/zero parameter data is sufficient for the
filtering operation. If the above pole/zero and gain parameters exist in
the parameter file, the following parameters are ignored. Otherwise, the
following numerator and denominator coefficient parameters must be
supplied.

*filter_string_dsiz - integer*  
The number of denominator coefficients in the transfer function for the
filter. *filter_string* is a string of characters specified by the
**-f** option.

*filter_string_den - float array*  
The denominator coefficients. They are specified in order starting with
b0. *filter_string* is a string of characters specified by the **-f**
option.

In the FIR system, the following parameters are necessary to define the
filtering operation.

*filter_string_nsiz - integer*  
The number of numerator coefficients in the transfer function for the
filter. *filter_string* is a string of characters specified by the
**-f** option.

*filter_string_num - float array*  
The numerator coefficients. They are specified in order starting with
a0. *filter_string* is a string of characters specified by the **-f**
option.

# ESPS COMMON

If the **-r** option is not used and ESPS Common processing is enabled,
the following items are read from the ESPS Common File provided that no
input file is given on the command line and provided that standard input
is not used.

> *filename - string*

> This is the name of the input file.

> *start - integer*

> This is the starting point in the input file for filtering.
>
> *nan - integer*

> This is the number of points in the input file for filtering. A value
> of zero means the last point in the file.

The following items are written into the ESPS Common file, provided ESPS
Common processing is enabled and the output file is not \<stdout\>.

> *start - integer*

> A value of 1 is written to the Common file.
>
> *nan - integer*

> The number of points in the output file.
>
> *prog - string*

> This is the name of the program (*filter2* in this case).

# ESPS HEADER

The file header of *output.sd* will contain mostly the same information
as is contained in that of *input.sd*,

The *start_time* generic header item contains the starting time in
seconds of the first point in the output file. *start_time* maybe
changed by the **-z** option. This helps time align a filtered signal
with the input signal since the filter is causal.

# EXAMPLES

Filters input sampled data file with a filter file *Bworth.filt*.

*filter2 -F Bworth.filt input.sd output.sd*

# REFERENCES

Leland B. Jackson, *Digital Filters and Signal Processing*, Kluwer
Academic Publishers, 1986

# SEE ALSO

    block_filter2(3-ESPS), notch_filt(1-ESPS), FEA_FILT(5-ESPS), 
    atofilt(1-ESPS), wmse_filt(1-ESPS), iir_filt(1-ESPS), 
    sfconvert(1-ESPS)

# AUTHOR

Program and man page by Derek Lin
