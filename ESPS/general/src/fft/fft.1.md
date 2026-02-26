# NAME

fft - Fast Fourier Transform of ESPS sampled data file to an ESPS
FEA_SPEC file

xfft - run *fft* with X Windows interactions and displays

# SYNOPSIS

**fft** \[ **-c** \] \[ **-l** *frame_len* \] \[ **-o** *order* \] \[
**-{pr}** *range* \] \[ **-w** *window_type* \] \[ **-x** *debug_level*
\] \[ **-z** \] \[ **-P** *param* \] \[ **-O** *frequency_offset* \] \[
**-S** *step* \] *sd_file* *fea_spec_file*\

**xfft** \[ **-c** \] \[ **-{rp}** *range* \] *sd_file*

# DESCRIPTION

*Fft* takes an input ESPS Sampled Data (SD or FEA_SD) file, *sd_file,*
and takes the Fast Fourier Transform of one or more fixed-length
segments to produce an ESPS Spectral Feature (FEA_SPEC) file
*fea_spec_file* containing one or more spectral records. If the input
file name *sd_file* is replaced by "-", then stdin is read; similarily,
if *fea_spec_file* is replaced by "-", then the output is written to
stdout.

For details about the FEA_SPEC file format, see FEA_SPEC(5-ESPS). The
power spectra in such FEA_SPEC files are suitable for plotting with
*plotspec*(1-ESPS).

Note that FEA_SD(5-ESPS) files support complex sampled data, and
*fft*(1-ESPS) supports complex sampled data inputs.

By default, the output FEA_SPEC file has spectral type SPTYP_DB; i.e. it
contains logarithmically scaled powers (in decibels) stored in the real
part of the records. If the complex spectrum is desired, use the **-c**
option. This results in spectral type SPTYP_CPLX; see FEA_SPEC(5-ESPS).
Note that *fftinv*(1-ESPS) assumes spectral records of the type produced
with the **-c** option.

If the input data type is real and **-c** is not used, the frequency
format in the FEA_SPEC file is SPFMT_SYM_EDGE; the spectrum is
symmetetric with only the positive-frequency part being stored. If the
input data type is complex or **-c** is used, the frequency format is
SPFMT_ASYM_EDGE; the negative-frequency and positive-frequency parts are
both stored.

All input frames have the same length *frame_len* (see the **-l**
option). The initial point of the first frame is determined by the
**-r** option or by *start* in the parameter file. Initial points of any
subsequent frames follow at equal intervals *step* (see **-S** option).
Thus the 3 cases *step* \< *frame_len,* *step* = *frame_len,* and *step*
\> *frame_len,* correspond to overlapping frames, exactly abutted
frames, and frames separated by gaps.

The power values stored in the records of *fea_spec_file* are based on
the windowed data and are averaged over the actual number of points
contributing to the transform (this is the transform length unless it
exceeds *frame_len*, in which case it is *frame_len*).

The number of frames is the minimum sufficient to cover a specified
range of *nan* points (see **-r** option), given *frame_len* and *step*.
The last frame in each file may overrun the range, in which case a
warning is printed. If a frame overruns the end of a file, it is filled
out with zeros.

*xfft* is a script that runs *fft* on a single frame of data that is
specified by the range option (**-r** or **-p**) or by means of ESPS
Common. A pop-up window is used to prompt the user for the *window_type*
and *order*. The results of the *fft* are displayed in a pop-up window
containing a spectral plot. *xfft* is well suited for addition to the
*xwaves*+ menu via the *xwaves*+ command "add_espsn name FFT command
xfft". The (only) advantage of *xfft* over *xspectrum* is that *xfft*
will do arbitrarily long FFTs (well, how much memory do you have?).
*xfft* makes used of *exprompt*(1-ESPS) and *plotspec*(1-ESPS).

The parameter prompting for *xfft* is performed by means of the
parameter file named PWfft, which is normally obtained from
\$ESPS_BASE/lib/params. However, if you have a file by this name in the
current directory (or if you define the environment variable
ESPS_PARAMS_PATH and put one on that path), it will be used instead.

# OPTIONS

The following options are supported (only **-r** or **-p** can be given
for *xfft*).

**-P** *param*  
uses the parameter file *param* rather than the default, which is
*params.*

**-p** *range*  
**-p** is a synonym for **-r**, and the allowed forms for *range* are
the same.

**-r** *first***:***last*  
**-r** *first***-***last*  
**-r** *first***:+***incr*  
In the first two forms, a pair of unsigned integers specifies the range
of sampled data to analyze. If *last* = *first* + *incr,* the third form
(with the plus sign) specifies the same range as the first two forms. If
*first* is omitted, the default value of 1 is used. If *last* is omitted
(in the first two forms), the range extends to the end of the file. If
the specified range extends beyond the end of the file, it is reduced to
end at the end of the file. If the range doesn't end on a frame
boundary, it is extend to make up a full last frame. If the range, so
extended, goes past the end of the file, the last frame is filled out
with zeros. All forms of the option override the values of *start* and
*nan* in the parameter file or ESPS Common file. The first two forms are
equivalent to supplying values of *first* for the parameter *start* and
(*last* + 1 - *first*) for the parameter *nan.* The third form is
equivalent to values of *first* for *start* and (*incr* + 1) for *nan.*
If the **-r** option is not used, the range is determined from the ESPS
Parameter or Common file if the appropriate parameters are present.

**-O** *frequency_offset* **\[0\]**  
Specifies a frequency offset, in Hz, to be subtracted from the frequency
tags attached to the spectrum values when the signal input to *fft* is
complex. This is relevant in cases where the frequency axis was rotated
by complex modulation prior to calling *fft*. This option permits
implementation of "frequency zooming" functions like that in the example
below.

**-l** *frame_len* **\[0\]**  
Specifies the length of each frame. If the option is omitted, the
parameter file is consulted. A value of 0 (from either the option or the
parameter file) indicates that a default value is to be used: the
transform length determined by the fft order. (See the **-o** option and
the *order* parameter.) This is also the default value in case
*frame_len* is not specified either with the **-l** option or in the
parameter file.

**-S** *step* **\[***frame_len***\]**  
Initial points of consecutive frames differ by this number of samples.
If the option is omitted, the parameter file is consulted, and if no
value is found there, a default equal to *frame_len* is used (resulting
in exactly abutted frames). The same default applies if the argument
*step* is specified as 0.

**-w** *window_type* **\[RECT\]**  
The name of the data window to apply to the data in each frame before
computing the transform. If the option is omitted, the parameter file is
consulted, and if no value is found there, the default used is a
rectangular window with amplitude one. Possible window types include
rectangular ("RECT"), Hamming ("HAMMING"), Hanning ("HANNING"), cos\*\*4
("COS4"), and triangular ("TRIANG"); see the window(3-ESPSsp) manual
page for the complete list.

**-o** *order* **\[10\]**  
The order of the fft; the transform length is 2^order (2 to the order-th
power). If the number of data points in each frame (frame length) is
less than the transform length, the frame is padded with zeros (a
warning is given). If the number of data points in each frame exceeds
the transform length, only the first 2^order points from each frame are
transformed - i.e., points are effectively skipped between each
transform (a warning is given). The default order is 10 (transform
length 1024). If the **-c** option is not used and the input data type
is real, the number of frequencies in the output spectral records is 1 +
2^(order - 1). If the **-c** option is used or the input data type is
complex, the number of frequencies in the output spectral records is 1 +
2^order.

**-c**  
Specifies that complex spectra (type SPTYP_CPLX) be stored in the output
FEA_SPEC file.

**-z**  
Specifies that *fft* operate silently, without issuing various warnings.

**-x** *debug_level* **\[0\]**  
A positive value specifies that debugging output be printed on the
standard error output. Larger values result in more output. The default
is 0, for no output.

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
parameter values that apply. If the parameter file does exist, the
following parameters are read:

*start - integer*  
> The first point in the input sampled data file that is processed. A
> value of 1 denotes the first sample in the file. This is only read if
> the **-r** and **-p** options are not used. If it is not in the
> parameter (or Common) file, the default value of 1 is used.

*nan - integer*  
> The total number of data points to process. If *nan* is 0, all points
> from *start* through the end of the file are processed. This parameter
> is not read if the **-r** or **-p** option is used. (See the
> discussion under **-r**).

*frame_len - integer*  
> The number of points in each frame. This parameter is not read if the
> **-l** option is specified. A value of 0 indicates that the transform
> length (determined by the fft order) is to be used as a default; the
> same default value is used in case *frame_len* is specified neither
> with the **-l** option nor in the parameter file.

*step - integer*  
Initial points of consecutive frames differ by this number of samples.
This parameter is not read if the **-S** option is specified. If the
option is omitted and no value is found in the parameter file, a default
equal to *frame_len* is used (resulting in exactly abutted frames). The
same default applies if *step* is given the value 0.

*window_type - string*  
The data window to apply to the data. This parameter is not read if the
command-line option **-w** is specified. If the option is omitted and if
no value is found in the parameter file, the default used is "RECT", for
a rectangular window with amplitude one. Other acceptable values include
"HAMMING", for Hamming, "HANNING" for Hanning, "COS4" for cos^4, and
"TRIANG", for triangular; see the window(3-ESPSsp) manual page for the
complete list.

*order - integer*  
> The order of the fft - the transform length is 2^order (2 to the
> order-th power). If no value is given in the file, a default value of
> 10 is used (transform length 1024). This value is not read if the
> command line option **-o** is used.

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

# EXAMPLE

The following *csh* script demonstrates the use of *fft* and other ESPS
programs to produce a frequency-zoomed spectrogram suitable for display
by *xwaves*.


    #!/bin/csh -f

    # This script is designed to be used as an xwaves "add_espsf" program.
    # To use it with xwaves, send a command like
    # 
    #   add_espsf name zoom7k.2k menu wave command xwzoomer 7000 2000
    # 
    # This will add a menu entry to the waveform display menu that will
    # produce a zoomed-in spectrogram with a bandwidth of 2kHz and a center
    # frequency of 7kHz.  By modifying the "-l" and "-o" options sent to fft
    # (see below), you can effectively increase or decrease the frequency
    # resolution as needed.  Commands like the one above can either be
    # entered directly into the xwaves command window in the "COMMAND (or
    # @file)" line, or from an external process via the "send_xwaves"
    # program (see eman send_xwaves).
    # Note that this script is pretty slow, and can be made VERY slow, if
    # the "bandwidth" parameter is not an integral sub-multiple of the input
    # file's sample frequency.

    if ( $#argv < 5 ) then
      echo Usage: xwzoomer center_freq bandwidth range input.sd output.fspec
    endif

    # Center Frequency
    set cf = $1

    # Analysis bandwidth
    set bw = $2

    # Range of points to include in zoomed analysis (e.g. -r1234:23000)
    set range = $3

    set input = $4
    set output = $5

    # Analysis frame interval for FFT (sec)
    set frint = .004

    set sf = `hditem -i record_freq $input`
    set step = `echo $frint $bw p q | dc`

    set np = `echo $range | sed 's/-r//' | sed 's// /'`
    set npoints = `echo $np[2] $np[1] - 1 + p q | dc`

    echo int new_sample_freq = $bw";" > /tmp/Psfparams

    testsd -c -r $sf -p $npoints -f -$cf - | multsd $range -t -z $input - - | sfconvert -P/tmp/Psfparams - - | /h8/dt/apl/zoomer/fftnew/fft -z -l256 -S $step -o8 -O$cf -wHANNING - - | feafunc -fre_spec_val -f- -tBYTE  - - | clip -m0:118 -fre_spec_val -f- - $output

# ESPS COMMON

ESPS Common is read provided that Common processing is enabled and that
the *filename* entry in Common matches *sd_file,* in which case
parameters present in Common override values from the parameter file,
which in turn may be overriden by command line options (see the
discussion in ESPS PARAMETERS and under each option).

If Common processing is enabled and if *fea_spec_file* is not standard
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

# ESPS HEADERS

*fft* reads the value of *common.type* from the input SD file *sd_file.*

Relevant fields in the type-dependent portion of the output file header
are filled appropriately. The standard generic header items required for
FEA_SPEC files are filled in (see *FEA_SPEC*(5-ESPS) for details). The
generic header item *fft_length* is set to the length of the fft
(2^order), the item *step* is set to the step size (see **-S**), and the
item *input_data,* value either complex or real, is added. The CODED
generic header item *window_type* is set according to to the window type
(see **-w**).

The generic header item *start_time* (type DOUBLE) is written in the
output file. The value written is computed by taking the *start_time*
value from the header of the input file (or zero, if such a header item
doesn't exist) and adding to it the offset time (from the beginning of
the input file) of the first point processed plus one half of
*frame_len*. (Thus, *start_time* is middle of the first frame, which is
appropriate since the output data represent the entire frame; without
this adjustment for *frame_len*, *waves*+ displays would not line up
properly.)

The generic header item *record_freq* (type DOUBLE) is written in the
output file. The value is the number of output records per second of
input data.

# FUTURE CHANGES

# SEE ALSO

    fftinv(1-ESPS), plotspec(1-ESPS), exprompt(1-ESPS), 
    expromptrun(1-ESPS), refcof(1-ESPS), me_spec(1-ESPS),
    xtext(1-ESPS), FEA_SD(5-ESPS), FEA_SPEC(5-ESPS), 
    ESPS(5-ESPS).

# BUGS

# REFERENCES

J. W. Cooley and J. W. Tukey, "An Algorithm for the Machine Calculation
of Complex Fourier Series," *Math. Computation*, Vol. 19, 1965, pp.
297-301.

Alan V. Oppenheim and Ronald W. Schafer, *Digital Signal Processing*.
Englewood Cliffs, New Jersey: Prentice-Hall, Inc., 1975.

# AUTHOR

Original manual page and program by Rod Johnson; revised by John Shore
for ESPS 3.0. Revised by John Shore for windowing and overlapping
frames. Revised by Rod Johnson for output to FEA_SPEC file. Revised for
FEA_SD input files by David Burton. *xfft* by John Shore.
