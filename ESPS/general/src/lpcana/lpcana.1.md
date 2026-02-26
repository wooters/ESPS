# NAME

lpcana - Performs LPC analysis using a crude pitch-synchronous method

# SYNOPSIS

**lpcana** \[ **-P** *param_file* \] \[ **-r** *range* \] \[ **-p
range** \] \[ **-m** *anal_method* \] \[ **-F** \] \[ **-x**
*debug_level* \] *input_sd output_fea*

# DESCRIPTION

Use of this program is not recommended. For pitch synchronous analysis,
see *epochs* (1-ESPS) and *ps_ana* (1-ESPS). *lpcana* takes as input an
ESPS sampled data FEA_SD (5-ESPS) file

and it computes LPC filter coefficients and the excitation parameters
using a crude pitch-synchronous method. The results are stored in the
FEA_ANA (5-ESPS) file *output_fea*. For each analysis frame of data,
*lpcana* generates reflection coefficients, power, and voicing
information. An output FEA_ANA record is generated for each pulse
(several pulses per analysis frame), with enough information to enable
*lpcsynt* (1-ESPS) to re-synthesize speech. The nominal frame size is
set by the parameter *lpc_frame_size* but is determined adaptively by
the program. If the **-F** option is not used, *refcof* performs an
additional spectral analysis on each pulse within the analysis frame and
puts out a different set of reflection coefficients for each pulse (if
**-F** is used, all pulses from the same analysis frame have the same
reflection coefficients).

If "-" is used in place of *input_sd,* standard input is used. If "-" is
used in place of *output_fea,* standard output is used.

# OPTIONS

The following options are supported:

**-P** *param_file*  
uses the parameter file *param_file* rather than the default file
*params.*

**-p** *range*  
Selects a subrange of points to be analyzed. The start and end points
are defined with respect to the original SD file that is the source of
the input FEA_ANA file. The range is specified using the format
*start-end* or *start:end* or *start:+nan*. Either *start* or *end* may
be omitted, in which case the omitted parameter defaults respectively to
the start or end of the input SD file.

**-r** *range*  
**r** is a synonym for **p**.

**-m** *anal_method\[mburg\]*  
Specifies the spectrum analysis method. The default is the modified Burg
method. Also available are the autocorrelation method ("autoc"),
ovariance method ("cov"), Burg method ("burg"), fast modified Burg
method ("fburg"), stuctured covariance ("strcov" and "strcov1"), and
vector Burg ("vburg", fast approximation to structured covariance. Of
the two structured covariance methods, the first ("strcov" is
considerably faster and better behaved; "strcov1" is older but included
as it may prove useful on occasion. The **-m** option overrides the
value that may be in the parameter file. The default applies only if
there is no value in the parameter file.

**-F**  
Specifies use of the framing method of the previous version of *refcof*,
in which the reflection coefficients for each pulse in an analysis frame
are determined by a spectral analysis of the entire frame. If **-F** is
not used, an additional spectrum analysis is performed for each pulse.

**-x** *debug_level \[0\]*  
option specifies that various information or debugging messages be
printed on standard error.

# ESPS HEADER

The generic header item *start_time* (type DOUBLE) is written in the
output file. The value written is computed by taking the *start_time*
value from the header of the input file (or zero, if such a header item
doesn't exist) and adding to it the offset time (from the beginning of
the input file) of the first point or record processed. Unlike many
other ESPS programs, *lpcana* does *not* write the generic header item
*record_freq* (used by *waves*+ for time synchronization); this is
because the output records from *lpcana* result from a variable frame
length analysis.

The following generic header items are added (in addition to the
standard ones (FEA_ANA-5):

> *p_offset - integer*

> How many points before the beginning of the pulse the spectrum
> analysis window is started.

> *dcrem - string*

> Yes means that the DC component was removed before the data was
> analyzed.

> *psynch - string*

> Yes means that the spectrum analysis is done pitch synchronously.

> *matsiz - integer*

> The size of the autocorrelation matrix that was used in the spectrum
> analysis.

# ESPS PARAMETERS

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3. The following parameters are read from the parameter file:

> *start - integer*

> This is the starting point in the input file. Its value is superseded
> by a **-p** value. The default value is 1.

> *nan - integer*

> This is the number of points to analyze. Its value is superseded by a
> **-p** value.

> *lpc_filter_order - integer*

> This is the order of the linear prediction filter that represents the
> vocal tract. The maximum allowable size is 20. The default value is
> 10.
>
> *lpc_frame_size - integer*

> This is the nominal frame size for performing spectral analysis. The
> default value is 160.
>
> *minimum_pulse_length - integer*

> This specifies the minimum pitch period. The algorithm has been well
> tested for the pitch range of 50-400 Hz. Thus a typical value of this
> variable is 20, assuming a sampling rate of 8000 Hz. The default value
> is 20.
>
> *method - string*

> The spectrum analysis method to use. The available methods are
> autocorrelation ("autoc"), covariance ("covar"), Burg ("burg"),
> modified Burg ("mburg"), fast modified Burg method ("fburg"),
> stuctured covariance ("strcov" and "strcov1"), and vector Burg
> ("vburg", a fast approximation to structured covariance. If no value
> is given in the file, the modified Burg method is used by default. The
> *method* is not read from the parameter file if the command line
> option **-m** is used.

# ESPS COMMON

If the input is standard input, COMMON is not read. If COMMON is read
and the command line input filename does match the filename listed in
COMMON then, the following items are read. If the two filenames do not
match, then no further parameters are read from COMMON.

> *start - integer*

> This is the starting point in the input file. Any **-p** option value
> supersedes the COMMON specified value.

> *nan - integer*

> This is the number of points to analyze. A **-p** specified value
> supersedes the COMMON specified value.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# COMMENTS

The algorithm has been developed for speech sampled at 8000 Hz. It works
best when the data is recorded using a good microphone. Its quality is
degraded, when working with telephone speech (especially if carbon
microphone is used).

The speech data is not pre-emphasized prior to LPC analysis, and the
modified Burg method is used for computing the LPC parameters.

# FUTURE CHANGES

NONE.

# BUGS

If the input data consists of a long string of zeros, the program bombs.

# SEE ALSO

*refcof* (1-ESPS), *lpcsynt* (1-ESPS), FEA_ANA (5-ESPS),\
*FEA_SD* (5-ESPS), *compute_rc* (3-ESPSsp)

# AUTHOR

S. Shankar Narayan. ESPS 3.0 modification by David Burton. Modified for
*compute_rc* (3-ESPSsp) and for single-pulse output by John Shore.
