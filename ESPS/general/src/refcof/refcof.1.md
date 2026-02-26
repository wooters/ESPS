# NAME

    refcof - computes LPC reflection coefficients via various spectrum analysis methods

    xrefcof- run refcof with X Windows interactions and displays

# SYNOPSIS

**refcof** \[ **-P** *param* \] \[ **-p** *range* \] \[
**-r***"***range** \] \[ **-l** *frame_len* \] \[ **-S** *step* \] \[
**-w** *window_type* \] \[ **-m** *method* \] \[ **-o** *order* \] \[
**-e** *preemphasis* \] \[ **-c** *conv_test* \] \[ **-i** *max_iter* \]
\[ **-s** *sinc_n* \] \[ **-d** \] \[ **-Z** \] \[ **-z** \] \[ **-x**
*debug_level* \] *file.sd file.rc*\

**xrefcof** \[ **-{rp}** *range* \] *sd_file*

# DESCRIPTION

*refcof* takes an ESPS sampled data file, *file.sd,* and produces an
ESPS FEA_ANA analysis file *file.rc* containing the reflection
coefficients corresponding to one or more fixed-length sampled-data
frames.

All input frames have the same length *frame_len* (see **-l** option).
The initial point of the first frame is determined by the **-p** option
or by *start* in the parameter file. Initial points of any subsequent
frames follow at equal intervals *step* (see **-S** option). Thus the 3
cases *step* \< *frame_len,* *step* = *frame_len,* and *step* \>
*frame_len,* correspond to overlapping frames, exactly abutted frames,
and frames separated by gaps.

The number of frames is the minimum sufficient to cover a specified
range of *nan* points (see **-p** and **-Z** options), given *frame_len*
and *step*. The last frame in each file may overrun the range, in which
case a warning is printed. If a frame overruns the end of a file, it is
normally filled out with zeros (but see **-Z**).

The reflection coefficients, along with the computed values for
*raw_power* and *lpc_power,* are then stored in FEA_ANA records. No
pitch pulse information is written to the file.

If *file.sd* is "-" then the input is read from the standard input and
if *file.rc* is "-" then the output is directed to the standard output.

The following spectrum analysis methods are available:

> Autocorrelation Method (AUTOC) - see *get_auto*(3-ESPS)

> Covariance Method (COV) - see *covar*(3-ESPS)

> Burg Method (BURG) - see *get_burg*(3-ESPS)

> Modified Burg Method (MBURG) - see *get_burg*(3-ESPS)

> Fast Modified Burg Method (FBURG) - *get_fburg*(3-ESPS)

> Structured Covariance Methods (STRCOV and STRCOV1) - see
> *strcov_auto*(3-ESPS), *struct_cov*(3-ESPS), and *genburg*(3-ESPS)

> Vector Burg Method (VBURG) (fast approximation to structured
> covariance) - see *get_vburg*(3-ESPS)

By default, the program uses the autocorrelation method, which applies
the standard method of computing the autocorrelation function and the
Levinson algorithm for computing the reflection coefficients from the
autocorrelation values. Note that the standard autocorrelation method
may yield poor results when using a small number (i.e. \< 100) of data
samples. The other methods can be specified by using the **-m** option.
The most accurate usually is STRCOV, especially for small frame lengths.

The methods AUTOC, STRCOV, and STRCOV1 operate by estimating the
autocorrelation function and then transforming to reflection
coefficients. In these cases, the program can also optionally multiply
the autocorrelation function by a sinc function (**-s** option) prior to
computing the reflection coefficients. This has the effect of reducing
the spectral resolution if the spectrum of these coefficients is
plotted.

Of the two structured covariance methods \[2\], STRCOV is consderably
faster and better behaved than STRCOV1. We include STRCOV1 as it may be
useful in certain cases. STRCOV uses a fast, single channel algorithm
*struct_cov* (3-ESPS) developed by John Burg and programmed by Bernard
Fraenkel. STRCOV2 uses an older (but more general) algorithm *genburg*
(3-ESPS) that was programmed by Daniel Wenger. Note that the **-c** and
**-i** options are relevant for controlling the convergence of STRCOV.
The VBURG method is a fast approximation to structured covariance that
was developed and programmed by John Burg and Shankar Narayan \[3\].

If spectral representations other than reflection coefficients are
desired, use *transpec* (1-ESPS) or *spectrans* (1-ESPS) on the output
of *refcof.* If you want the actual spectrum, use *me_spec* (1-ESPS) on
the output of *refcof.*

*xrefcof* is a script that runs *refcof* on a single frame of data that
is specified by the range option (**-r** or **-p**) or by means of ESPS
Common. A pop-up window is used to prompt the user for *window_type*,
*method*, *order*, *conv_test*, and *max_iter*. The results of the
*analysis* are displayed in two pop-up windows - one containing the
reflection coefficents, and one containing a maximum-entropy power
spectrum computed from these reflection coeffiecients. *xrefcof* makes
used of *exprompt* (1-ESPS), *me_spec* (1-ESPS), *plotspec* (1-ESPS),
and *xtext* (1-ESPS).

The parameter prompting for *xrefcof* is performed by means of the
parameter file named PWrefcof, which is normally obtained from
\$ESPS_BASE/lib/params. However, if you have a file by this name in the
current directory (or if you define the environment variable
ESPS_PARAMS_PATH and put one on that path), it will be used instead.

# OPTIONS

The following options are supported (only **-r** or **-p** can be given
for *xrefcof*):

**-P** *param*  
uses the parameter file *param* rather than the default, which is
*params.*

**-p** *first***:***last*  
**-p** *first-last*  
**-p** *first***:+***incr* **\[1:+999\]**  
In the first two forms, a pair of unsigned integers specifies the range
of sampled data to analyze. If *last* = *first* + *incr,* the third form
(with the plus sign) specifies the same range as the first two forms. If
*first* is omitted, the default value of 1 is used. If *last* is
omitted, then a default frame length of 1000 results. If the specified
range contains points not in the file, the last frame is truncated to
fit the actual data. Both forms of the option override the values of
*start* and *nan* in the parameter file or ESPS Common file. If the
**-p** option is not used, the range is determined from the ESPS
Parameter or Common file if the appropriate parameters are present. Note
that the default frame length of 1000 also results if *nan* is not in
the parameter or Common file and if no **-p** is used.

**-r** *range*  
**-r** is a synonym for **-p**.

**-l** *frame_len* **\[0\]**  
Specifies the length of each frame. If the option is omitted, the
parameter file is consulted. A value of 0 (from either the option or the
parameter file) indicates that a single frame of length *nan* (see
**-p**) is processed; this is also the default value in case *frame_len*
is not specified either with the **-l** option or in the parameter file.

**-S** *step* **\[***frame_len***\]**  
Initial points of consecutive frames differ by this number of samples.
If the option is omitted, the parameter file is consulted, and if no
value is found there, a default equal to *frame_len* is used (resulting
in exactly abutted frames). (The same default applies if *step* is given
a value of 0).

**-w** *window_type***\[RECT\]**  
The name of the data window to apply to the data in each frame before
computing reflection coefficients. If the option is omitted, the
parameter file is consulted, and if no value is found there, the default
used is a rectangular window with amplitude one. Possible window types
include rectangular ("RECT"), Hamming ("HAMMING"), Hanning ("HANNING"),
cosine (COS4), and triangular ("TRIANG"); see the window(3-ESPSsp)
manual page. If the last frame is truncated, the window is applied to
the truncated data (e.g., a triangular window is zero at the start and
end of the truncated data).

**-m** *method\[autoc\]*  
Specifies the spectrum analysis method. The default is the
autocorrelation method. Also available are the covariance method
("cov"), Burg method ("burg"), modified Burg method ("mburg"), fast
modified Burg method ("fburg"), stuctured covariance ("strcov" and
"strcov1"), and vector Burg ("vburg", fast approximation to structured
covariance. Of the two structured covariance methods, the first
("strcov" is considerably faster and better behaved; "strcov1" is older
but included as it may prove useful on occasion. If "strcov" is used,
the **-c** and **-i** options become relevant. The **-m** option
overrides the value that may be in the parameter file. The default
applies only if there is no value in the parameter file.

**-e** *preemphasis\[0.0\]*  
Specifies a preemphasis factor to apply to the input signal.

**-c** *conv_test\[1e-5\]*  
Specifies, for the STRCOV method only (not including STRCOV1), a
convergence test value. The lower the value, the smaller the change
required on each iteration before the estimator terminates, and the more
iterations that normally will result.

**-i** *max_iter\[20\]*  
Specifies, for the STRCOV method only (not including STRCOV1), the
maximum number of iterations that the estimator will run through before
terminating. A warning will indicate if the estimator terminates because
max_iter has been exceeded.

**-o** *order\[15\]*  
Specifies the order (number of reflection coefficients), and overrides
the value that may be in the parameter file. The default applies only if
there is no value in the parameter file.

**-s** *sinc_n*  
For the AUTOC, STRCOV, and STRCOV1 methods, the autocorrelation the
autocorrelation function is multiplied by the function *sin (x /
sinc_n)* before computing the reflection coefficients. In the frequency
domain this has the effect of convolving the spectrum with a boxcar
function of width *f / sinc_n,* where *f* is the sampling frequency. The
value of *sinc_n* is recorded in a generic header item.

**-d**  
Specifies that the dc component of each frame is removed before the
analysis is performed. DC revmoval takes place before windowing.

**-Z**  
If the last frame normally would overrun the stated range, *refcof*
reads past the range to fill up the last frame; if the the last would go
past the file end, the frame is filled with zoes. Use of **-Z**,
inhibits this behavior by processing one less frame. The result is that
the end of the last frame falls short of the stated range. A common use
of **-Z** is to avoid getting unwanted zeros in training sequences.

**-z**  
Specifies that /fIrefcof/fP operate silently, without issuing various
warnings.

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
> the **-p** option is not used. If it is not in the parameter (or
> Common) file, the default value of 1 is used.

*nan - integer*  
> The total number of data points to process. If *nan* is 0, the whole
> file is processed. *Nan* is read only if the **-p** option is not
> used. (See the discussion under **-l**).

*frame_len - integer*  
> The number of points in each frame. This parameter is not read if the
> **-l** option is specified. A value of 0 indicates that a single frame
> of length *nan* is processed; this is also the default value in case
> *frame_len* is specified neither with the **-l** option nor in the
> parameter file.

*step - integer*  
Initial points of consecutive frames differ by this number of samples.
This parameter is not read if the **-S** option is specified. If the
option is omitted and no value is found in the parameter file, a default
equal to *frame_len* is used (resulting in exactly abutted frames).

*window_type - string*  
The data window to apply to the data. This parameter is not read if the
command-line option **-w** is specified. If the option is omitted and if
no value is found in the parameter file, the default used is "RECT", for
a rectangular window with amplitude one. Other acceptable values include
"HAMMING", for Hamming, and "TRIANG", for triangular; see the
window(3-ESPSsp) manual page for the complete list.

*order - integer*  
> The number of reflection coefficients computed for each frame of input
> data. If no value is given in the file, a default value of 15 is used.
> This value is not read if the command line option **-o** is used.

*method - string*  
> The spectrum analysis method to use. The available methods are
> autocorrelation ("auto"), covariance ("covar"), Burg ("burg"),
> modified Burg ("mburg"), fast modified Burg method ("fburg"),
> stuctured covariance ("strcov" and "strcov1"), and vector Burg
> ("vburg", a fast approximation to structured covariance. If no value
> is given in the file, the autocorrelation method is used by default.
> The *method* is not read from the parameter file if the command line
> option **-m** is used.

*preemphasis - float*  
> The preemphasis factor to be applied to input signal.

*strcov_test - float*  
> If STRCOV is used, this is the convergence test value (the lower the
> value, the smaller the change per iteration before termination). This
> is not read if **-c** is used.

*strcov_maxiter - int*  
> If STRCOV is used, this is the maximum number of iterations allowed
> before the estimator terminates. This is not read if **-i** is used.

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

# ESPS COMMON

ESPS Common is read provided that Common processing is enabled and that
the *filename* entry in Common matches *file.sd,* in which case
parameters present in Common override values from the parameter file,
which in turn may be overriden by command line options (see the
discussion in ESPS PARAMETERS and under each option). Common is not read
if *file.sd* is standard input. If *file.rc* is not standard output and
*file.sd* is not standard input, the Common parameters *filename* (=
file.sd), *prog* (= refcof), *start,* and *nan* are written to ESPS
Common.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADER

A new file header is created for the FEA_ANA file. The sampled data
header from the input header is added as a source in the output file
header, and the command line is added as a comment. The input file
*file.sd* is set as the reference header for tags.

The program writes the usual values into the common part of the output
header. *Refcof* writes the following values into the specified generic
header items in the output FEA_ANA file:


    order_vcd = 0
    order_unvcd = order
    maxpulses = 1
    maxraw = 1
    maxlpc = 1
    spec_rep = RC
    start = start
    nan = nan;
    frmlen = frame_len;
    src_sf = sample frequency of file.sd

In addition, the following generic header items are created and filled
with values used by *refcof*: *method, window_type,* DC_removed, step.
All of these are CODED types, except for *step*, which is LONG. If a
non-zero preemphasis factor is used, then the header item *preemphasis*
of FLOAT type is also written.

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

*get_resid* (1-ESPS), *mask* (1-ESPS), *get_f0* (1-ESPS),\
*ps_ana* (1-ESPS), *transpec* (1-ESPS), *spectrans* (1-ESPS),\
*me_spec* (1-ESPS), *plotspec* (1-ESPS), *exprompt* (1-ESPS),\
*expromptrun* (1-ESPS), *fft* (1-ESPS), *compute_rc* (3-ESPS),\
FEA_ANA (5-ESPS), FEA (5-ESPS), FEA_SD (5-ESPS)

# BUGS

None known. The program will not compute reflection coefficients of
complex signals; if presented with complex input data, it will warn and
exit.

# FUTURE CHANGES

None contemplated.

# REFERENCES

\[1\]  
L. R. Rabiner and R. W. Schafer, *Digital Processing of Speech Signals*,
Prentice Hall, NJ. 1978.

\[2\]  
J.P.Burg, D.G.Luenberger, D.L.Wenger, "Estimation of Structured
Covariance Matrices" *Proceedings of the IEEE*, Vol. 70, No. 9 September
1982

\[3\]  
Shankar Narayan and J.P. Burg, "Spectral Estimation of Quasi-Periodic
Data", *Proceedings ICASSP 87*, pp. 944-947.

# AUTHOR

Original program by Brian Sublett.

Modified extensively by John Shore.
