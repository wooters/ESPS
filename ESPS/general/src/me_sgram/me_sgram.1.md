# NAME

me_sgram - produces a maximum-entropy-based FEA_SPEC file suitable for
displaying as a spectrogram

# SYNOPSIS

**me_sgram** \[ **-s***"***range** \] \[ **-P***"***param_file** \] \[
**-p***"***range** \] \[ **-r** *range* \] \[ **-m** *method* \] \[
**-a** *lpc_method* \] \[ **-w** *window_len* \] \[ **-E**
*pre_emphasis* \] \[ **-o** *analysis_order* \] \[ **-S** *step_size* \]
\[ **-d** *data_window* \] \[ **-c** *conv_test* \] \[ **-i** *max_iter*
\] \[ **-D** \] *input.SD output.SPEC*

# DESCRIPTION

*Me_sgram* reads an ESPS sampled data file, pre-emphasizes it, and
produces an ESPS FEA_SPEC(5-ESPS) file, which qresults from maximum
entropy spectral analysis. This file is suitable for displaying as a
speech spectrogram. (See *plotsgram* (1-ESPS).) By default (specifying
no options) or by specifying *wb* for the **-m** option, *me_sgram*
produces a FEA_SPEC file that simulates the analysis done to produce a
wide-band speech spectrogram. Alternatively, by specifying *nb* for the
**-m** option, a FEA_SPEC file that simulates the analysis for a
narrow-band spectrogram is computed. The **-m** option simply defines
different defaults for the other options. By specifying any of the other
options, in addition to **-m**, the default values are overridden by the
specified option values. This allows the user to alter the basic display
to highlight facets of the spectrogram that are of particular interest.

*me_sgram* is a shell script that uses *filter*(1-ESPS),
*refcof*(1-ESPS), and *me_spec*(1-ESPS); the parameter file is processed
using *getparam*(1-ESPS).

If "-" is specified for the output file, standard output is used. Note,
standard input cannot be read by this script.

# OPTIONS

**-s** *start_time:end_time \[0.0:(end of file)\]*  
**-s** *start_time:+duration*  
Determines the range in seconds in the input file over which the
spectrogram values are to be computed. In the first form, a pair of real
numbers gives the starting and ending times of the range. The
correspondence between samples and times is determined by two
quantities: the starting time of the file and the interval between
samples. The former is given by the generic header item *start_time* in
the input file, or 0.0 if the header item is not present. The latter is
the reciprocal of the sample frequency *sf* in the type-dependent part
of the SD header. If *start_time* is omitted, the starting time of the
file is used. If *end_time* is omitted, the range extends through the
end of the file. The second form of the option is equivalent to the
first with *end = start + duration .*

**-p** *starting_point:end_point \[1:(end of file)\]*  
**-p** *starting_point:+incr*  
Determines the range in points in the input file over which the
spectrogram values are to be computed. In the first form, a pair of
unsigned integers gives the first and last points of the range, counting
from 1 for the first point in the file. If first is omitted, 1 is used.
If last is omitted, the range extends to the end of the file. The second
form is equivalent to the first with last = first + incr . This option
should not be specified if -s is specified.

**-r** *range*  
**-r** is a synonym for **-p**.

**-m** *method \[wb\]*  
The basic method is specified here. There are two possible values: *wb*
for wide band and *nb* for narrow band. By specifying *wb*, the
following values are set: lpc_method = fburg, pre-emphasis = .94,
analysis_order = 10, window_len = 8 msec., step_size = 2 msec., and
data_window = RECT. By specifying *nb*, the following values are set:
lpc_method = fburg, pre-emphasis = .94, analysis_order = 10, window_len
= 40 msec., step_size = 2 msec., and data_window = RECT.

**-a** *lpc_method \[fburg\]*  
Specifies the spectrum analysis method. The default is the fast modified
Burg ("fburg") method. Also available are the autocorrelation method
"autoc"), covariance method ("cov"), Burg method ("burg"), modified Burg
method ("mburg"), stuctured covariance ("strcov" and "strcov1"), and
vector Burg ("vburg", fast approximation to structured covariance. Of
the two structured covariance methods, the first ("strcov" is
considerably faster and better behaved; "strcov1" is older but included
as it may prove useful on occasion. \*\* If "strcov" is used, the **-c**
and **-i** options become relevant. The **-m** option overrides the
value that may be in the parameter file.

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

**-w** *window_len*  
The duration of data in milliseconds over which the the power spectrum
is computed for each column of the spectrogram. The analysis bandwidth
is inversely proportional to this value.

**-E** *pre_emphasis*  
The coefficient *A* in the pre-emphasis filter: 1 - *A*/z. This filter
is applied to the sampled data before computing the power spectrum. A
value of *A* = 1 provides a 6 dB/octave boost to the high frequencies; a
value of 0 provides no boost.

**-o** *analysis_order*  
The number of parameters in the autoregressive model that is used to
compute the power spectrum.

**-S** *step_size*  
The time step in milliseconds between columns in the spectrogram. The
time resolution and horizontal magnification are affected by this
parameter.

**-d** *data_window*  
The data window applied to the data before the computation of the power
spectrogram. Possible values include RECT (rectangular), HAMMING, and
TRIANG (triangular). See *window* (3-ESPS) for a complete list of
supported data windows.

**-D**  
Include in the output records a field *dith_spec_val* containing 1s and
0s intended for display as a simulated gray-scale spectrogram on a
black-and-white monitor. The *refcof* (1-ESPS) output is piped through
the *dither*(1-ESPS) program.

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
parameter values that apply. If the parameter file does exist, the
following parameters are read:

*method - string*  
The spectrogram method to use. This parameter is not read if the **-m**
option is used. If the parameter is present and is read, it determines
default values for all other parameters as discussed under the **-m**
option. The other parameters (or command line options), if present,
override these defaults. The choice of "other" uses defaults that are
the same as "wb".

*lpc_method - string*  
The analysis method used to compute reflection coefficients. This
parameter is not read if the **-a** is used.

*data_window - string*  
The data window to apply to the data. This parameter is not read if the
**-d** option is specified or if *method* is in the parameter file and
does not have the value "other". Acceptable values include "RECT" for a
rectangular window, "HAMMING", for Hamming, "HANNING" for Hanning,
"COS4" for cosine 4th, and "TRIANG", for triangular; see the
*window*(3-ESPSsp) manual page for the complete list.

*start - integer*  
> The first point in the input sampled data file that is processed. A
> value of 1 denotes the first sample in the file. This parameter is not
> read if any of the range command line options are used. If it is not
> in the parameter file, and neither option is specified, a default
> value of 1 is used.

*nan - integer*  
> The total number of data points to process. If *nan* is 0, processing
> continues through the end of the file. This parameter is not read if
> any of the range command line options are used.

*window_len - float*  
> The duration in milliseconds of each frame. This parameter not read if
> the **-w** option is specified of if *method* is in the file and does
> not have the value "other".

*pre_emphasis - float*  
The coefficient in the preemphasis filter (see **-E** in the Options
section). This parameter not read if the **-E** option is specified.

*step_size - float*  
Initial points of consecutive frames differ by this number of
milliseconds. This parameter not read if the **-S** option is specified.

*order - integer*  
> The number of reflection coefficients computed for each frame of input
> data. If no value is given in the file, a default value of 15 is used.
> This value is not read if the command line option **-o** is used.

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
the *filename* entry in Common matches *input.SD,* in which case
parameters present in Common override values from the parameter file,
which in turn may be overriden by command line options (see the
discussion in ESPS PARAMETERS and under each option). Common is not read
if *file.sd* is standard input. If *file.rc* is not standard output and
*file.sd* is not standard input, the Common parameters *filename* (=
file.sd), *prog* (= refcof), *start,* and *nan* are written to ESPS
Common.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is

setting the environment variable ESPSCOM to the desired path. User
feedback of Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

The generic header item *start_time* (type DOUBLE) is written in the
output file. The value written is computed by taking the *start_time*
value from the header of the input file (or zero, if such a header item
doesn't exist) and adding to it the offset time (from the beginning of
the input file) of the first point processed. Also, the generic header
item *record_freq* (type DOUBLE) is written in the output file. The
value is the number of output records per second of input data. For
details on the parameters used by all of the programs in the script,
look at all of the intermediate headers (e.g., via *psps* **-a**).

# FUTURE CHANGES

*me_sgram* will be re-implemented as a C program.

# SEE ALSO

*sgram* (1-ESPS), *plotsgram* (1-ESPS), *filter* (1-ESPS),\
*refcof* (1-ESPS), *me_spec* (1-ESPS), *compute_rc* (3-ESPSsp),\
*dither* (1-ESPS), FEA_SPEC (5-ESPS), FEA_SD (5-ESPS)

# BUGS

This script cannot read standard input.

# AUTHOR

Manual page and program by David Burton. Revisions by John Shore.
