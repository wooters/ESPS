# NAME

fftcep - FFT-based complex cepstrum of ESPS sampled data

# SYNOPSIS

**fftcep** \[ **-P** *param* \] \[ **-r** *range* \] \[ **-l**
*frame_len* \] \[ **-S** *step* \] \[ **-w** *window_type* \] \[ **-o**
*order* \] \[ **-F** \] \[ **-R** \] \[ **-e** *element_range* \]\[
**-z** *zeroing_range* \]\[ **-x** *debug_level* \] *sd_file* *fea_file*

# DESCRIPTION

*fftcep* takes an input ESPS sampled data (SD or FEA_SD) file,
*sd_file*, and finds the complex cepstrum of one or more fixed length
segments to produce an ESPS FEA file, *fea_file.* If the input file name
*sd_file* is replaced by "-", stdin is read; similarly, if *fea_file* is
replaced by "-", the output is written to stdout. The *FEA_SD*(5-ESPS)
files support complex sampled data, and *fftcep* will process complex
input data, as well as multichannel data.

The complex cepstrum of a single frame is computed by obtaining the FFT
of the (possibly windowed) data frame, computing the complex logarithm
of this spectrum, and finding the inverse FFT of the log spectral data.
The complex cepstrum of single channel input is stored in the field
*cepstrum_0* whose default data type is FLOAT_CPLX. If the input has *N*
channels, the cepstral data corresponding to the *ith* channel is stored
in field *cepstrum_i*, where 0 \<= *i* \< *N*; the data in each channel
is processed identically.

The **-R** option specifies that the cepstrum rather than the complex
cepstrum should be computed. In this case, the inverse FFT is performed
on the log magnitude of the spectrum, rather than on the complex
logarithm of the spectrum. Under the **-R** option, the cepstrum of
single channel data is stored in the field *cepstrum_0* and its default
data type is FLOAT_CPLX. Field names for multichannel data are
constructed as in the complex cepstrum case, and the data in each
channel is processed identically.

When computing either the cepstrum or complex cepstrum, the option
**-F** specifies that the imaginary part of the resulting data be
discarded and only the real part be stored; the field *cepstrum_0* then
has type FLOAT.

All input frames have the same length *frame_len* (see the **-l**
option). The initial point of the first frame is determined by the
**-r** option or by *start* in the parameter file. Initial points of
subsequent frames follow at equal interval *step* (see **-S** option).
Thus the 3 cases *step* \< *frame_len,* *step* = *frame_len,* *step* \>
*frame_len,* correspond to overlapping frames, exactly abutted frames,
and frames separated by gaps.

The number of frames is the minimum sufficient to cover a specified
range of *nan* points (see **-r** option), given *frame_len* and *step.*
The last frame may overrun the range, in which case a warning is issued.
If a frame overruns the end of the input file, it is filled out with
zeros.

The FFT cepstral routines used by *fftcep* return 2^*order* values (see
*fft_cepstrum*(3-ESPS)). The default is always to store all 2^*order*
values in *cepstrum_0* in the same order as returned by
*get_cfft_inv*(3-ESPS); the cepstral sequence is returned in the
following order: c(0), c(1),..., c(N/2), c(-(N/2) + 1), c(-(N/2) +
2),..., c(-1). It is possible to specify that a subrange of these values
be used to form *cepstrum_0* (see **-e** option). This makes it possible
to discard cepstral information not relevant to further processing.

It is possible to perform simple filtering on the cepstral data. The
**-z** option can be used to set elements of the cepstral data to zero.
To apply more complicated operations to the cepstral data,
**feafunc**(1-ESPS) can be used to process the field *cepstrum_0*
directly and **make_sd**(1-ESPS) can be used to create *FEA_SD*(5-ESPS)
files which can be processed with **window** (1-ESPS).

**Example Shell Script**\
The following shell script is an example of using *fftcep* to analyze a
segment of speech. The FFT spectrum as found by *fft*(1-ESPS) can be
compared to the spectrum of the liftered cepstral sequence computed by
*fftcep*. A 512 point segment is read from the file
*/usr/esps/demo/speech.sd* by *fft* and *fftcep*. Both programs compute
a 1024 point FFT from the Hamming windowed sequence, and *fftcep* is
forced to compute and store the real part of the power cepstrum.
Liftering is performed by using the **-z** option to set the long-time
cepstral components to zero. The program *make_sd*(1-ESPS) must be used
to translate the FEA file output of *fftcep* into the FEA_SD file format
expected by *fft*. The program *plotspec*(1-ESPS) can be used to compare
the FFT spectrum with the spectrum of the liftered cepstral sequence.

\#!/bin/csh\
set spfile = /usr/esps/demo/speech.sd\
set sf = \`hditem -i record_freq \$spfile\`\
\#\
fft -r1000:1511 -o10 -l512 -wHAMMING \$spfile speech.spec\
plotspec -p0:4000 speech.spec\
\#\
fftcep -r1000:1511 -o10 -l512 -wHAMMING -F -R -z23:1000 \\\
\$spfile speech.cep\
make_sd -r1: -fcepstrum_0 -S\$sf speech.cep speech.cepsd\
fft -p1:3072 -o10 -l1024 speech.cepsd speech.cspec\
plotspec -p0:4000 speech.cspec

# OPTIONS

The following options are supported:

**-P** *param*  
uses the parameter file *param* rather than the default, which is
*params.*

**-r** *first***:***last*  
**-r** *first***-***last*  
**-r** *first***:+***incr*  
In the first two forms, a pair of unsigned integers specifies the range
of sampled data to analyze. If *last* = *first* + *incr,* the third form
(with the plus sign) specifies the same range as the first two forms. If
*first* is omitted, the default value of 1 is used. If *last* is
omitted, the range extends to the end of the file. If the specified
range extends beyond the end of the file, it is reduced to end at the
end of the file. Then, if the range doesn't end on a frame boundary, it
is extend to make up a full last frame. If the range, so extended, goes
past the end of the file, the last frame is filled out with zeros. All
forms of the option override the values of *start* and *nan* in the
parameter file or ESPS Common file. The first two forms are equivalent
to supplying values of *first* for the parameter *start* and (*last* +
1 - *first*) for the parameter *nan.* The third form is equivalent to
values of *first* for *start* and (*incr* + 1) for *nan.* If the **-r**
option is not used, the range is determined from the ESPS Parameter or
Common file if the appropriate parameters are present.

**-l** *frame_len* **\[0\]**  
Specifies the length of each frame. If the option is omitted, the
parameter file is consulted. A value of 0 (from either the option or the
parameter file) indicates that a default value is to be used: the
transform length determined by the order. (See the **-o** option and the
*order* parameter.) This is also the default value in case *frame_len*
is not specified either with the **-l** option or in the parameter file.

**-S** *step* **\[***frame_len***\]**  
Initial points of consecutive frames differ by this number of samples.
If the option is omitted, the parameter file is consulted, and if no
value is found there, a default equal to *frame_len* is used (resulting
in exactly abutted frames). The same default applies if *step* is given
a value of 0.

**-w** *window_type* **\[RECT\]**  
The name of the data window to apply to the data in each frame before
computing the FFT. If the option is omitted, the parameter file is
consulted, and if no value is found there, the default used is a
rectangular window with amplitude one. Possible window types include
rectangular ("RECT"), Hamming ("HAMMING"), Hanning ("HANNING"), cos^4
("COS4"), and triangular ("TRIANG"); see the window (3-ESPS) manual page
for the complete list.

**-o** *order* **\[10\]**  
The order of the FFT and inverse FFT; the transform length is 2^*order*
(2 to the *order*-th power). If the number of data points in each frame
(frame length) is less than the transform length, the frame is padded
with zeros (a warning is given). If the number of data points in each
frame exceeds the transform length, only the first 2^*order* points from
each frame are transformed - i.e., points are effectively skipped
between each transform (a warning is given). The default order is 10
(transform length 1024).

**-F**  
Discard imaginary part of cepstral data and force field *cepstrum_0* to
have data type FLOAT.

**-R**  
Compute cepstrum rather than complex cepstrum. The DFT of the cepstrum
is the log magnitude cepstrum when it is computed in this way.

**-e** *element_range* **\[0:2^*order*-1\]**  
By default, the field *cepstrum* in *fea_file* contains the full
2^*order* values returned by the inverse FFT. By supplying
*element_range* it is possible to specify that a subrange of elements be
used to create the field *cepstrum_0*. For example, specifying
*20,25:30* will result in *cepstrum_0* having 7 elements taken from
positions 20, 25,...,30 in the data returned by the inverse FFT (whose
indices run from 0 to 2^*order*-1). If *element_range* specifies indices
outside the range 0 to 2^*order*-1, *fftcep* issues an error message and
exits.

**-z** *zeroing_range* **\[null\]**  
By default, the cepstral data is stored unmodified in *cepstrum_0*. If
the **-z** option is used, the elements of *cepstrum_0* specified by
*zeroing_range* are set to zero. This is useful in deconvolution and
echo removal (see \[1\]-\[3\]). Note that this zeroing operation is
performed after *cepstrum_0* is formed, so if *-z* is used with *-e*,
*zeroing_range* must be a subrange of *element_range*; if it is not,
*fftcep* issues an error message and exits.

**-x** *debug_level* **\[0\]**  
A positive value specifies that debugging output be printed on the
standard error output. Larger values result in more output. The default
is 0, for no output.\

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
parameter values that apply. If the parameter file does exist, the
following parameters are read:

*start - integer*  
> The first point in the input sampled data file that is processed. A
> value of 1 denotes the first sample in the file. This is only read if
> the **-r** option is not used. If it is not in the parameter (or
> Common) file, the default value of 1 is used.

*nan - integer*  
> The total number of data points to process. If *nan* is 0, the whole
> file is processed. *Nan* is read only if the **-r** option is not
> used. (See the discussion under **-r**).

*frame_len - integer*  
> The number of points in each frame. This parameter is not read if the
> **-l** option is specified. A value of 0 indicates that the transform
> length (determined by the order) is to be used as a default; this is
> also the default value in case *frame_len* is specified neither with
> the **-l** option nor in the parameter file.

*step - integer*  
> Initial points of consecutive frames differ by this number of samples.
> This parameter is not read if the **-S** option is specified. If the
> option is omitted and no value is found in the parameter file, a
> default equal to *frame_len* is used (resulting in exactly abutted
> frames). The same default applies if *step* is given the value 0.

*window_type - string*  
> The data window to apply to the data. This parameter is not read if
> the command-line option **-w** is specified. If the option is omitted
> and if no value is found in the parameter file, the default used is
> "RECT", for a rectangular window with amplitude one. Other acceptable
> values include "HAMMING", for Hamming, "HANNING" for Hanning, "COS4"
> for cos^4, and "TRIANG", for triangular; see the window(3-ESPSsp)
> manual page for the complete list.

*data_type - string*  
> The data type of the field *cepstrum_0*. The two possible types are
> "FLOAT" and "FLOAT_CPLX" (the default). This parameter is not read if
> the command line option **-F** is used.

*method - string*  
> Specifying "CEPSTRUM" forces the cepstrum to be computed by performing
> the inverse FFT on the log magnitude of the input spectrum. If
> "CPLX_CEPSTRUM" is specified, or if no parameter is given, the inverse
> FFT is performed on the complex logarithm of the input spectrum. This
> option is not read if the command line option **-R** is used.

*order - integer*  
> The order of the FFT - the transform length is 2^*order* (2 to the
> *order*-th power). If no value is given in the file, a default value
> of 10 is used (transform length 1024). This value is not read if the
> command line option **-o** is used.

*element_range - string*  
> This string is scanned by *grange_switch* (3-ESPS) to determine which
> elements of the cepstral data are used to form the field *cepstrum_0*
> in *fea_file.* This parameter is not read if the command line option
> **-e** is used.

*zeroing_range - string*  
> This string is scanned by *grange_switch* to determine which elements
> of the field *cepstrum_0* should be set to zero. This parameter is not
> read if the command line option **-z** is used.

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

# ESPS COMMON

ESPS Common is read provided that Common processing is enabled and that
the *filename* entry in Common matches *sd_file,* in which case
parameters present in Common override values from the parameter file,
which in turn may be overriden by command line options (see the
discussion in ESPS PARAMETERS and under each option).

If Common processing is enabled and if *fea_file* is not standard
output, the Common parameters *filename, prog, start,* and *nan* are
written to Common, where *filename* is set to the input *sd_file.*

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADER

A new file header is created for the FEA file. The sampled data header
from the input header is added as a source in the output file header,
and the command line is added as a comment. The input file *sd_file* is
set as the reference header for tags.

*fftcep* writes the following values into the specified generic header
items in the output FEA file:


    start = start;
    nan = nan;
    step = step;
    frmlen = frame_len;
    order = order;
    src_sf = sample frequency of sd_file;

All these fields have data type LONG, except for *src_sf* which has data
type FLOAT.

In addition, the CODED type generic header items *window_type*,
*cplx_cepstrum*, and *data_type* are created and filled with the values
used by *fftcep*. Item *cplx_cepstrum* is set to YES or NO, depending on
whether the complex cepstrum or the cepstrum is computed (see the **-R**
option and *method* parameter). Item *data_type* is set to FLOAT_CPLX or
FLOAT depending on the **-F** option and the *data_type* parameter.

The charcter type generic header items *cep_range* and *cep_zeroed*
contain the strings *element_range* and *zeroing_range*.

The generic header item *start_time* (type DOUBLE) is written in the
output file. The value written is computed by taking the *start_time*
value from the header of the input file (or zero, if such a header item
doesn't exist) and adding to it the offset time (from the beginning of
the input file) of the first point processed plus one half of
*frame_len* (thus, *start_time* is middle of the first frame, which is
appropriate since the output data represent the entire frame; without
this adjustment for *frame_len*, *waves*+ displays would not line up
properly.

The generic header item *record_freq* (type DOUBLE) is written in the
output file. The value is the number of output records per second of
input data.

# SEE ALSO

    plotsd(1-ESPS), refcof(1-ESPS), transpec(1-ESPS),
    spectrans(1-ESPS), me_spec(1-ESPS), plotspec(1-ESPS), 
    get_fft(3-ESPS),fft_cepstrum(3-ESPS),get_feasd_orecs(3-ESPS),
    FEA(5-ESPS), FEA_SD(5-ESPS)

# WARNINGS

The routines *fft_ccepstrum* and *fft_ccepstrum_r*(3-ESPS) used by
*fftcep* to compute the complex cepstrum perform phase unwrapping to
find the complex logarithm of the input spectrum (see \[1\],\[3\]). This
procedure adds or subtracts 2\*pi to the phase angle of the spectrum in
an attempt to remove discontinuities. If the unwrapping algorithm fails
to satisfy the continuity criterion, it will echo a warning message to
standard error, provided *debug_level* is greater than 0. This does not
mean that the the resulting cepstrum is useless, but that the user
should check that the input and output data make sense.

# BUGS

None known.

# FUTURE CHANGES

# REFERENCES

\[1\] A. V. Oppenheim and R. W. Schafer, *Digital Signal Processing*
Prentice-Hall, N.J. 1975

\[2\] L. R. Rabiner and R. W. Schafer, *Digital Processing of Speech
Signals* Prentice-Hall, N.J. 1978 \[3\] D. G. Childers, D. P. Skinner,
R. C. Kemerait, *The Cepstrum: A Guide to Processing* Proceedings of the
I.E.E.E., vol. 65, no. 10 October 1977, pp. 1428-1443

# AUTHOR

Program and manual page by Bill Byrne.
