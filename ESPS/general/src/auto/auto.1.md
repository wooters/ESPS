# NAME

auto - Compute autocorrelation sequence of real data

# SYNOPSIS

**auto** \[ **-l** *frame_len* \] \[ **-o** *order* \] \[ **-**{**pr**}
***range*** \] \[ **-w** *window_type* \] \[ **-x** *debug_level* \] \[
**-P** *params* \] \[ **-S** *step_size* \] \[ **-B** \] *sd.in*
*fea_ana.out*

# DESCRIPTION

*auto* takes as input a single-channel, real ESPS sampled-data (FEA_SD
or SD) file, *sd.in,* and computes the positive-lag elements of the
power-normalized autocorrelation function of one or more fixed-length
segments to produce an ESPS FEA_ANA file *fea_ana.out* containing one or
more records. (The autocorrelation function for a real signal is even,
so the negative lag elements are equal to the positive lag elements.
That is, R\[1\] = R\[-1\], R\[2\] = R\[-2\], etc.)

All input frames have the same length (see **-l** below). The initial
points of successive frames are separated by the step size specified by
**-S**. Thus the three cases *step \< frame_len,* step = frame_len, and
*step \> frame_len*, correspond to overlapping frames, exactly abutted
frames, and frames separated by gaps (sometimes called underlapping
frames).

In addition to the normalized autocorrelation values, each record
contains the power corresponding to the input data segment, the length
of the data segment, and the starting point for that record in the input
sampled data file. By default the power computed for each record is the
power corresponding to the unwindowed data. This can be changed to the
power of the windowed data by using the *power* parameter in the params
file. See *power* under **ESPS** PARAMETERS for more details.

By default, a lag-product form is used to compute the autocorrelation.
If the **-B** is used, a structured covariance method is used. This is
usually provides a much better estimate, especially for short, noisy
data sequences.

If the input file name *sd.in* is replaced by "-", then *stdin* is read;
similarly, if *fea_ana.out* is replaced by "-", then the output is
written to *stdout*.

# OPTIONS

The following options are supported:

**-l** *frame_len* **\[0\]**  
Specifies the length of each frame, and overrides the *frame_len* value
that may be in the parameter file. The number of frames processed is the
largest number with the given length (*frame_len*) and spacing (see
**-S**) that will fit within the range (determined by **-p** option or
*start* and *nan* in the parameter file or from ESPS Common). If
*frame_len* is zero, *auto* sets the frame length equal to the total
range - i.e., a single frame is processed. This holds whether
*frame_len* comes from the **-l** option or from the parameter file. It
also holds if the **-l** option is not used and the *frame_len*
parameter is not given in the parameter file.

**-o** *order* **\[10\]**  
Specifies the order of the autocorrelation function. Autocorrelation
lags one through *order* are stored for each record in the *spec_param*
field of the FEA_ANA record. If the number of data points in each frame
(*frame_len*) is less than the *order*, *auto* warns and exits. The
default order is 10.

**-p** *first***:***last*  
**-p** *first***:+***incr*  
In the first form, a pair of unsigned integers specifies the range of
sampled data to analyze. If *last* = *first* + *incr,* the second form
(with the plus sign) specifies the same range as the first. If *first*
is omitted, the default value of 1 is used. Both forms of the option
override the values of *start* and *nan* in the parameter file or ESPS
Common file. If the **-p** option is not used, the range is determined
from the ESPS Common file if the appropriate parameters are present (see
ESPS COMMON).

**-r** *first***:***last*  
**-r** *first***:+***incr*  
The **-r** option is synonymous with **-p**.

**-w** *window_type* **\[RECT\]**  
Specifies the data window to apply to the data. The default window type
is a rectangular window with amplitude equal to one. Possible window
types include the following: rectangular("RECT"), Hamming ("HAMMING"),
Hanning ("HANNING"), cosine to the fourth power ("COS4"), and triangular
("TRIANG"). See the window(3-ESPSsp) manual page for a complete list of
window functions.

**-x** *debug_level* **\[0\]**  
Specifies that debugging output be printed on stderr; larger values of
*debug_level* result in more output. The default is for no output.

**-P** *param* **\[params\]**  
Specifies the name of the parameter file. The default name is *params*.

**-S** *step_size* **\[frame_len\]**  
Initial points of consecutive frames differ by this number of samples.
If this option is omitted, the parameter file is consulted, and if no
value is found in the parameter file, a default equal to *frame_len* is
used. This results in exactly abutted frames.

**-B**  
Specifies that the "best" autocorrelation method be used -- i.e., a
structured covariance method, rather than the standard lag-product
algorithm.

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
parameter values that apply. If the parameter file does exist, the
following parameters are read:

> *start - integer*

> The first point in the input sampled-data file that is processed. A
> value of 1 denotes the first sample in the file. This is only read if
> the **-p** option is not used. If it is not in the parameter (or
> Common) file, the default value of 1 is used.
>
> *nan - integer*

> The total number of points to analyze. If no value is given, the value
> is set equal to the total number of points in the input file minus
> *start* + 1. Both the parameter file value and the default value may
> be overridden by means of the **-p** option.
>
> *frame_len - integer*

> The number of points analyzed for each frame. If no value is given, or
> the value is zero, the value is set equal to the range (i.e., so that
> only a single frame is processed). This value is not read if the
> command line option **-l** is used. Both the parameter file value and
> the default value may be overridden by means of the **-l** option. To
> see how the number of frames is determined see the **-l** option.
>
> *step_size - integer*

> Initial points of consecutive frames differ by this number of samples.
> This parameter is not read if the **-S** option is specified. If the
> option is omitted and no value is found in the parameter file, a
> default equal to *frame_len* is used (resulting in exactly abutted
> frames).
>
> *order - integer*

> The order of the autocorrelation function. If no value is given in the
> file, a default value of 10 is used. This value is not read if the
> command line option **-o** is used.
>
> *window - string*

> Specify a data window to apply to the sampled data before computing
> the autocorrelation function. This value is not read if the command
> line option **-w** is used. If the option is omitted and no value is
> found in the parameter file, the default used is a rectangular window
> with amplitude one.
>
> *power - string*

> Specify the method for computing the power in each record. Two methods
> are supported: *unwindowed* (the default) and *windowed*. For
> *unwindowed*, the power corresponding to the input data before any
> windowing is computed; for *windowed*, the power corresponding to the
> windowed data is computed.
>
> *strcov_auto - string*

> Specify whether ("yes") or not ("no") to use a structured covariance
> method rather than a lag-product method. This parameter is not read if
> the **-B** option is used. The default is not to use structured
> covariance.

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

# ESPS COMMON

It the **-p** option is not used and ESPS Common is enabled, the
parameters *start* (starting point) and *nan* (number of points) are
read from ESPS Common if they exist and if the Common parameter
*filename* matches *sd.in.* If Common processing is enabled and if
*fea_ana.out* is not standard output, the Common parameters *filename,
prog, start, step_size, frmlen,* and *nan* are written to Common, where
*filename* is set to the input *sd.in.*

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overridden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

*auto* reads the value of *common.type* from the input sampled-data file
*sd.in.*

Relevant fields in the type-dependent portion of the output file header
are filled appropriately.

Two generic header items that describe the processing are written to the
output file header: *data_window - coded* and *step_size - integer*.
*data_window* contains the name of the type of data window used on the
data prior to the computation of the autocorrelation function;
*step_size* contains the number of points between consecutive frames. In
addition, the generic header item *start_time* (type DOUBLE) is written
in the output file. The value written is computed by taking the
*start_time* value from the header of the input file (or zero, if such a
header item doesn't exist) and adding to it the offset time (from the
beginning of the input file) of the first point processed plus one half
of *frame_len*. (Thus, *start_time* is in the middle of the first frame,
which is appropriate since the output data represent the entire frame;
without this adjustment for *frame_len*, *waves*+ displays would not
line up properly.)

# FUTURE CHANGES

Add more data window types.

# SEE ALSO

    refcof(1-ESPS), cross_cor(1-ESPS), me_spec(1-ESPS), rem_dc(1-ESPS), 
    transpec(1-ESPS), spectrans(1-ESPS), toep_solv(1-ESPS), window(3-ESPS), 
    FEA_SD(5-ESPS), SD(5-ESPS), FEA_ANA(5-ESPS), ESPS(5-ESPS), 
    get_auto (3-ESPSsp), strcov_auto (3-ESPSsp)

# BUGS

None known.

# AUTHOR

Manual page and program by Dave Burton. Conversion from SD to FEA_SD by
Rod Johnson. Structured covariance added by Shore.
