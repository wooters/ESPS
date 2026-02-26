# NAME

sfconvert - converts sampling frequency in a sampled data file by using
a lowpass interpolation filter designed by the windowing method

xsfconvert - runs *sfconvert* with X windows interactions and displays

esfconvert - converts sampling frequency in a sampled data file by using
a lowpass interpolation filter designed by the windowing method

# SYNOPSIS

**\[e\]sfconvert \[** **-P***param_file* \] \[ **-s** *new_sample_freq*
\] \[ **-r** *range* \] \[ **-v** *deviation* \] \[ **-c** *corner_freq*
\] \[ **-R** *rej_db* \] \[ **-t** *trans_band* \] \[ **-w**
*sfwin_type* \] \[ **-l** *sfwin_len* \] \[ **-e** *channels* \] \[
**-o** *output_type* \] \[ **-d** \] \[ **-f** \] \[ **-F** *filt_file*
\] \[ **-x** *debug_level* *input.sd* *output.sd*

xsfconvert *input.sd* *output.sd*

# DESCRIPTION

This program is installed under the name of *sfconvert* and
*esfconvert*. The name *esfconvert* should be used on SGI computers to
avoid a clash with the SGI supplied *sfconvert* command (sound file
convert).

*Sfconvert* takes an input ESPS Sampled Data (FEA_SD) file, *input.sd,*
and resamples it with a new sampling frequency specified by **-s** and
**-v** options to produce an ESPS FEA_SD file, *output.sd.* By default,
the new sampling frequency is the input sampling frequency.

If *input.sd* is replaced by "-", the standard input is read. If
*output.sd* is replaced by "-", the standard output is written.

The actual new sampling frequency is of the form (*up*/*down*)\**sf_in*.
The variable *sf_in* is the sampling rate of the input file and the
variables *up* and *down* are interpolation and decimation factors. They
are the smallest integers such that the actual new sampling frequency is
deviated from *new_sample_freq* with the maximum tolerable deviation in
percent, *deviation,* from *new_sample_freq*. The default of *deviation*
is zero.

*Sfconvert* supports multichannel input data. Single or multiple
channels selected are extracted from *input.sd*, resampled, and written
in a single or multichannel *output.sd*. Channels are selected with the
**-e** options. Default is all channels.

*Sfconvert* supports data types of DOUBLE, FLOAT, LONG, SHORT, BYTE,
DOUBLE_CPLX, FLOAT_CPLX, LONG_CPLX, SHORT_CPLX, and BYTE_CPLX. The data
type of *ouput.sd* by default is the same as that of *input.sd*. But it
can be set to any data type by **-o** option. If input data type is
complex and output data type is set to real, imaginary part of input
data is discarded. If input data type is real and output data type is
set to complex, zeros are filled in the imaginary part of output data.
Converting one data type to another with less dynamic range will result
in clipping.

Actual resampling is computed via floating point or double precision
operation. By default, if *input.sd* is of any data types other than
DOUBLE or DOUBLE_CPLX, resampling is carried out in floating point
computation. Otherwise, double precision is used. **-d** option forces
all computation to be carried out in double precision, regardless of
input data types.

*Sfconvert* first designs a non-causal type I lowpass FIR filter (a
filter with odd length and with filter shape symmetrical about its
center point) by the windowing method. By default, the Kaiser windowing
method is used to design the lowpass filter with the transition
bandwidth, *trans_band* by the **-t** option, between passband and
stopband, and with the rejection ratio, *rej_db* by the **-R** option,
in dB values from passband to stopband. Such filter is then convoluted
with input sampled data.

The parameters, *trans_band* and *rej_db* determine the filter length
designed by the Kaiser windowing method and they have direct impact on
computational time. The filter length is directly proportional to
*rej_db* and inversely proportional to *trans_band*.

The lowpass filter can be designed by the windowing method using other
window types, such as rectangular, Hanning, Hamming, triangular, and
cosine^4 windows. The **-w** option specifies which window type to use
and the **-l** option specifies the time duration of the filter length
in seconds. Kaiser windowing method allows the lowpass filter to be
designed from the criteria of stopband rejection ratio and transition
bandwidth, but these other windowing methods do not use such criteria.

The paramters *rej_db* and *trans_band* for the Kaiser windowing design
method may coexist with *sfwin_type* and *sfwin_len* for other windowing
design method in command line or in paramter file. A non-Kaiser
windowing design is used only when the **-w** option exists on command
line, or when the *sfwin_type* paramter in a paramter file is set to a
non-Kaiser window and *Kaiserflag* is set to zero in a paramter file.
Otherwise, Kaiser windowing design method is used.

In the case when the input data is too short to convolute with the
designed filter, zeros are padded to input data.

By default the corner frequency or cutoff frequency for the lowpass
filter is the Nyquist frequency, (the input sampling frequency divided
by two). Since the transition bandwidth must be nonzero, in many cases
it is desirable to have a broad transition region that occurs entirely
below Nyquist frequency. The **-c** option sets the corner frequency,
*corner_freq*, in Hertz.

# OPTIONS

The following options are supported:

**-P** *param_file*  
The file *param_file* is used for the parameter file, instead of the
default which is *params*.

**-s** *new_sample_freq \[input sampling frequency\]*  
Sampling frequency of *output.sd*. Default is the input sampling
frequency.

**-v** *deviation \[0\]*  
Maximum tolerable frequency deviation from *new_sample_freq* in percent.
For example, *deviation=2* means the actual output sampling frequency is
the requested sampling frequency plus or minus 2%. This options allows
*sfcovnert* to find the smallest integer conversion factors, *up* and
*down*, within the allowable range, and thereby reduce the problem of
generating long filter lengths in the Kaiser windowing method due to a
large interpolation factor. Note that this only affects memory
requirement.

**-r** *first:last*  
**-r** *first:+incr*  
Determines the range of points from input file for frequency conversion.
In the first form, a pair of unsigned integers gives the first and last
points of the range. If *first* is omitted, 1 is used. If *last* is
omitted, the last point in the file is used. The second form is
equivalent to the first with *last = first + incr*.

**-c** *corner_freq \[input sampling frequency/2\]*  
Corner frequency of the lowpass interpolation filter designed by the
windowing method. If this paramter is not specified or a value of zero
is given, a default value of the Nyquist rate of output data file is
used.

**-R** *rej_db \[60\]*  
Rejection ratio in dB values from passband to stopband in the lowpass
filter designed by the Kaiser windowing method. *Sfconvert* ignores this
option if a non-Kaiser windowing design method is used.

**-t** *trans_band \[200\]*  
Transition bandwidth in Hertz from passband to stopband in the lowpass
filter designed by the Kaiser windowing method. *Sfconvert* ignores this
option if a non-Kaiser windowing filter design method is used.

**-w** *sfwin_type*  
If Kaiser windowing method is not desired in designing the lowpass
filter, another window type can be used. *sfwin_type* can be set to any
of these window types: RECT (rectangular), HAMMING (Hamming), TRIANG
(triangular), HANNING (Hanning), and COS4 (cosine^4). If this option is
selected, the **-R** and **-t** are ignored.

**-l** *sfwin_len*  
Time duration in seconds of the window selected by **-w** option.
*Sfconvert* ensures the window length in samples is an odd number by
adding 1 to the multiplication product of *sfwin_len* and the maximum of
*up* or *down*, if the product is even. This is to ensure the lowpass
interpolation filter is a type I filter. *Sfwin_len* must be greater
than zero. *Sfconvert* ignores this option if the Kaiser windowing
filter design method is used.

**-e** *channels \[all channels\]*  
Determines which channels are extracted out of *input.sd* for sampling
frequency conversion. The format is that of a comma separated list of
integers and pairs *a:b*, where *a* and *b* are integers. This specifies
the channel numbers that are selected for output. For example,
*2,5:8,12* specifies channel 2, channels 5 through 8, and channel 12.
Additionally, an expression *a:+c* may be written instead of *a:b* where
*c* is an integer such that *a+c=b*. Thus *5:8* could be replaced with
*5:+3* in the example.

The numbering of channels begins with 0. The channel numbers must be
specified in increasing order without repetitions. If this option is not
specified, the default is to select all channels in the input file.

**-o** *output_type \[input data type\]*  
This option specifies the data type of *output.sd*. Available data types
are DOUBLE, FLOAT, LONG, SHORT, BYTE, DOUBLE_CPLX, FLOAT_CPLX,
LONG_CPLX, SHORT_CPLX, and BYTE_CPLX. By default, output data type is
the same as input data type.

**-d**  
This option forces all computation to be carried out in double precision
format. By default if this option is not specified, floating point
operation is used for input data types of FLOAT, LONG, SHORT, BYTE,
FLOAT_CPLX, LONG_CPLX, SHORT_CPLX, and BYTE_CPLX; otherwise if input
data type is DOUBLE or DOUBLE_CPLX, double precision operation is used.

**-f**  
This option saves the lowpass filter coeffiecients in the header of
output file.

**-F** *filt_file*  
This option saves the lowpass filter coeffiecients in the file named
*filt_file*.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *sfconvert* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
parameters that apply. If the parameter file does exist, the following
parameters are read:

*new_sample_freq - int*  
The sampling frequency of output file. This parameter is not read if the
**-s** option is used.

*deviation - float*  
The maximum tolerable deviation from *new_sample_freq* in percent. This
parameter is not read if the **-v** option is used.

*start - integer*  
The first point in the input sampled-data file that is processed. A
value of 1 denotes the first sample in the file. If it is not in the
parameter (or Common) file, the default value of 1 is used.

*nan - integer*  
The total number of points to analyze. If it is set to 0 or if the value
is not given, *nan* is set equal to the total number of points in the
input file minus *start* plus 1.

*corner_freq - float*  
The corner frequency of the lowpass filter designed for interpolation.
This parameter is not read if the **-c** option is used. A value of zero
indicates the Nyquist rate of output file is used.

*Kaiserflag - int*  
This paramter is optional. It is used to determine the window type used
for the filter design in case of ambiguity. Set *Kaiserflag* to 1 for
the Kaiser window type, or 0 for non-Kaiser window type. If there is no
**-w** on the command line, *sfwin_type* is set to a non-Kaiser window
type in the paramter file, and *Kaiserflag* exists in the paramter file
and it is equal to zero, then the window type determined by *sfwin_type*
is used for the filter design. Otherwise, the Kaiser windowing filter
design is used. In the case when **-w** exists on the command line and
*Kaiserflag* is 1, then window type specified by **-w** is used since a
command line option always takes precedence. *rej_db - float* The
rejection ratio of the lowpass filter designed by Kaiser window from
passband to stopband in dBs. This paramter is ignored if a non-Kaiser
window type is used for filter design.

*trans_band - float*  
The transition bandwidth of the lowpass filter designed by the Kaiser
windowing method between passband and stopband. This paramter is ignored
if a non-Kaiser window type is used for filter design.

*sfwin_type - string*  
Window type used in designing the lowpass filter other than Kaiser
windowing method. Available parameters are RECT (rectangular window),
HAMMING (Hamming window), TRIANG (Triangular window), HANNING (Hanning
window), and COS4 (Cosine to power of 4 window).

*sfwin_len - float*  
Window length in seconds used in designing the lowpass filter designed
by *sfwin_type* window type. This paramter is ignored if the Kaiser
windowing filter design method is used.

*channels - string*  
This parameter specifies which channels from a multichannel input file
for sampling frequency conversion. This parameter is not read if the
**-e** option is used.

*output_type - string*  
This parameter specifies the output data type. Available data types are
DOUBLE, FLOAT, LONG, SHORT, BYTE, DOUBLE_CPLX, FLOAT_CPLX, LONG_CPLX,
SHORT_CPLX, and BYTE_CPLX. This parameter is not read if the **-o**
option is used.

*dflag - int*  
This specifies whether resampling is to be carried out in floating point
or double precision. A value of *1* is for double precision. A value of
*0* specifies floating point computation.

# ESPS COMMON

If the **-r** option is not used and ESPS Common processing is enabled,
the following items are read from the ESPS Common File provided that
input file given on the command line matches the *filename* entry in the
common file.

> *start - integer*

> This is the starting point in the input file for frequency conversion.
>
> *nan - integer*

> This is the number of points in the input file for frequency
> conversion. A value of zero means the last point in the file.

The following items are written into the ESPS Common file, provided ESPS
Common processing is enabled and the output file is not \<stdout\>.

> *start - integer*

> A value of 1 is written to the Common file.
>
> *nan - integer*

> The number of points in the output file.
>
> *prog - string*

> This is the name of the program (*sfconvert* in this case).
>
> *filename - string*

> The name of the output file.

# ESPS HEADERS

The generic header item *record_freq* is written in the output file with
the actual sampling frequency which may be different from
*new_sample_freq* if *deviation* by the **-v** option is not zero. The
input file sampling frequency is also written as *source_freq*. Both
header items are type DOUBLE. The corner frequency of lowpass filter is
written as *corner_freq* as type DOUBLE if its default value 0 is not
used.

*start_time* header item of type DOUBLE of output file is computed by
taking the *start_time* of the input file and adding to it the offset
time (from the beginning of the first input file) of the first point
used in frequency conversion.

The header item, *filter_siz*, for the size of the lowpass filter is
written as type SHORT. If **-f** is specified on the command line, the
lowpass filter coeffiecients are saved in the header. The coefficients,
*filter*, is written as type DOUBLE if input data is type DOUBLE or
DOUBLE_CPLX, if the **-d** option is set, or if the value of *dflag* in
the parameter file is *yes*. Otherwise *filter* is type FLOAT.

If the Kaiser windowing method is used in filter design, *rej_db* and
*trans_band* are written as type FLOAT. Otherwise, *sfwin_type* and
*sfwin_len* are written as type CODED and FLOAT, respectively.

The header item, *source_file*, is the input file name. If the input
data is multichannel, channels selected for sampling frequency
conversion is written in the header item *channels*.

# EXAMPLES

Converting the input sampling frequency 8000 Hz of input data channels
1, 3, 4, and 5 to 6000 Hz with the aliased components 80 dB down.

*sfconvert -s6000 -R80 -e1,3:5 input.sd output.sd*

Dividing the input sampling frequency of 8000 Hz by one third
(2666.66...). The conversion factor is 1/3. However, using the option
*-s 2666* for new sampling frequency will result in large *up* and
*down* factors and long filter length. The **-v** option allows
*sfconvert* to find the exact intended conversion factor of 1/3 by
allowing a small deviation from the necessarily truncated
*new_sample_freq*. The following command finds the actual sampling
frequency to be 2666 Hz within plus or minus 26.66 Hz, or exactly 8000/3
Hz with the values of 1 and 3 for the *up* and *down* ratios.

*sfcovnert -s2666 -v1 input.sd output.sd*

Converting the input sampling frequency 8000 Hz to 6000 Hz with a
lowpass filter of corner frequency of 2500 Hz instead of the default
3000 Hz, Nyquist frequency.

*sfcovnert -s6000 -c2500 input.sd output.sd*

Frequency conversion to 12000 Hz using a lowpass filter designed by
Hamming window for input data sampled at 8000 Hz. The filter will be
0.02 second long, or 160 points in samples.

*sfconvert -s12000 -wHAMMING -l0.02 input.sd output.sd*

# ERRORS AND DIAGNOSTICS

In the case when the interpolation factor *up* is very large and window
length *sfwin_len* supplied by **-l** is too short such that no
convolution is possible, an error message is issued and the program
exits.

# BUGS

None known.

# REFERENCES

Alan V. Oppenheim and Ronald W. Schafer, *Discrete-Time Signal
Processing*. Englewood Cliffs, New Jersey: Prentice-Hall, Inc., 1989

# SEE ALSO

    filter(1-ESPS), demux(1-ESPS), type_convert(3-ESPS),
    window(3-ESPS) 

# AUTHOR

Program and man page by Derek Lin
