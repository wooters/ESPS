# NAME

sgram - compute sequence of FFTs suitable for display as a spectrogram

# SYNOPSIS

**sgram** \[ **-d** *data_window* \] \[ **-m** *method* \] \[ **-o**
*fft_order* \] \[ **-p** *range* \] \[ **-s** *range* \] \[ **-w**
*window_len* \] \[ **-x** *debug_level* \] \[ **-E** *pre_emphasis* \]
\[ **-P** *param_file* \] \[ **-S** *step_size* \] \[ **-T**
*desired_frames* \] \[ **-z** \] *input.sd output.fspec*

# DESCRIPTION

*Sgram* reads an ESPS sampled data file, preemphasizes it, and produces
an FFT-based ESPS FEA_SPEC file that is suitable for displaying as a
spectrogram. (See *plotsgram*(1-ESPS).)

By default (specifying no options) or by specifying *wb* for the **-m**
option, *sgram* produces a FEA_SPEC file that simulates the analysis
done to produce a wide-band speech spectrogram. Alternatively, by
specifying *nb* for the **-m** option, a FEA_SPEC file that simulates
the analysis for a narrow-band spectrogram is computed. The **-m**
option defines different defaults for the other options. By specifying
any of the other options, in addition to **-m**, the default values are
overridden by the specified option values. This allows the user to alter
the basic display to highlight facets of the spectrogram that are of
particular interest.

The output FEA_SPEC file has freq_format SPFMT_SYM_EDGE, spec_type
SPTYP_DB, and frame_meth SPFRM_FIXED. To compress space, the output data
type for re_spec_val is BYTE (see FEA_SPEC(5-ESPS)).

The number of output frames is the minimum sufficient to cover a
specified range of points (see **-p** and **-s** options), given
*window_len* and *step_size*. In the **-T** option is used, *sgram*
chooses *step_size* so that the number of output frames is close to
*desired_frames*, which provides a convenient means of varying the
time-domain resolution in terms that relate to the physical size of a
resulting display via *xwaves*+ (see the description under **-T**
below). Whether or not **-T** is used, the last frame analyzed may
overrun the range, in which case a warning is printed if the **-x**
option is used. If a frame overruns the end of a file, it is filled out
with zeros. Neither complex nor multichannel sampled data files are
supported yet.

If "-" is specified for the input file, standard input is used. If "-"
is specified for the output file, standard output is used.

# OPTIONS

**-d** *data_window* **\[(see **-m**)\]**  
The data window applied to the data before the computation of the power
spectrogram. If the option is omitted, the parameter file is consulted,
and if no value is found there, the default implied by *method* (see
**-m**) is used. Possible window types include RECT (rectangular),
HAMMING, HANNING, COS4, and TRIANG (triangular). See *window*(3-ESPSsp)
for a complete list of supported data windows.

**-m** *method \[wb\]*  
The basic method for spectrogram computation. There are two possible
values: *wb* for wide band and *nb* for narrow band. By specifying *wb,*
the following default values are set: preemphasis = .94, fft_order = 8,
window_len = 8 ms, step_size = 2 ms, and data_window = HANNING. By
specifying *nb,* the following default values are set: preemphasis =
.94, fft_order = 9, window_len = 40 ms, step_size = 2 ms, and
data_window = HANNING. If the option is omitted, the parameter file is
consulted, and if no value is found there, the default *wb* is used. If
the parameter file contains a value for *method*, corresponding default
values are determined for the other parameters - in this case, these
defaults can be overriden by command line options but not by other
parameter file values (there is one exception - see the discussion under
ESPS PARAMETERS).

**-o** *fft_order* **\[(see **-m**)\]**  
The FFT length used in computing the power spectrum is 2 to the power
*fft_order.* If the number of data points in each frame (*window_len*)
is less than the transform length, the frame is padded with zeros, and a
warning is given if the **-x** option is used. If the number of data
points per frame exceeds the transform length, each frame is effectively
truncated to the transform length, and a warning is given if the **-x**
is used. The number of frequencies in the output spectral records is 1
more than half the transform length. If this option is not specified,
the parameter file is consulted, and if no value is found there, the
default implied by *method* (see **-m**) is used.

**-p** *first***:***last* **\[1:(last in file)\]**  
**-p** *first***:+***incr*  
The range of points in the input file over which the spectrogram values
are to be computed. In the first form, a pair of unsigned integers gives
the first and last points of the range, counting from 1 for the first
point in the file. If *first* is omitted, 1 is used. If *last* is
omitted, the range extends to the end of the file. The second form is
equivalent to the first with *last = first + incr .* This option should
not be specified if **-s** is specified. If neither option is specified,
the range is determined by the parameters *start* and *nan* as read from
the parameter file. If either parameter is missing from the parameter
file, it is determined by default.

**-s** *start_time***:***end_time***"***\[0.0:(end***of***file)\]*  
**-s** *start_time***:+***duration*  
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
first with *end = start + duration .* This option should not be
specified if **-p** is specified. If neither option is specified, the
range is determined by the parameters *start* and *nan,* as discussed
above for **-p.**

**-w** *window_len* **\[(see **-m**)\]**  
The duration of data in milliseconds over which the the power spectrum
is computed for each column of the spectrogram. The analysis bandwidth
is inversely proportional to this value. If this option is not
specified, the parameter file is consulted, and if no value is found
there, the default implied by *method* (see **-m**) is used.

**-x** *debug_level*  
A positive value causes debugging output to be printed on the standard
error output. Larger values give more output. The default is 0, for no
output.

**-E** *pre_emphasis* **\[(see **-m**)\]**  
The coefficient *A* in the preemphasis filter 1 - *A/z.* This filter is
applied to the sampled data before computing the power spectrum. A value
of 1.0 provides a 6 dB/octave boost to the high frequencies; a value of
0.0 provides no boost. If this option is not specified, the parameter
*pre_emphasis* is read from the parameter file, and if no value is found
there, the default value implied by *method* (see **-m)** is used.

**-P** *param_file*  
Use the parameter file *param_file* rather than the default, which is
*params.*

**-S** *step_size* **\[(see **-m** and **-T**)\]**  
The time step in milliseconds between columns in the spectrogram. The
time resolution and horizontal magnification are affected by this
parameter. If this option is not specified, the parameter file file is
consulted, and if no value is found there, the default value implied by
*method* (see **-m)** is used.

**-T** *desired_frames*  
Specifies that the number of output records (number of frames computed)
be close to *desired_frames*. If this option is used, *sgram* tries to
choose a value for *step_size* that will yield *desired_frames* of
output when *range* points are anaylzed. (Since the number of data
points shifted for each frame is an integer, exactly *desired_frames* of
output will happen only in special cases.) Use of this option overrides
any specification for *step_size* resulting from defaults, from **-m**,
or from **-S**. The **-T** option yields a useful alternative to
zooming-in or bracketing the markers in an *xwaves*+ spectrogram
display. For example, suppose an existing spectrogram display is about
400 pixels wide, and suppose that a new item is added to waveform menus
by means of the command:

<!-- -->


       add_espsf name "400-Frame Spectrogram (W.B.)" command sgram -m wb -T 400

If a small range is marked on an existing spectrogram, the "bracket
markers" operation can be used to zoom in on the marked region (assuming
that horizontal rescaling is enabled). This results in the existing
spectrogram being re-displayed with the data stretched out (with or
without linear interpolation). Alternatively, if the "400-Frame
Spectrogram (W.B.)" item is invoked from the corresponding waveform
window, a new spectrogram will be computed and displayed. This
spectrogram will be about 400 pixels wide, with each pixel-column
corresponding to one frame (one FFT). In effect, this is a "bracket
markers" operation in which the data is recomputed to have finer
resolution in the time domain.

**-z**  
Specifies that *sgram* should issue warning messages regarding partially
filled buffers, zero power in spectra, etc. Without the **-z** option,
it operate silently and does not issue warnings.

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
parameter values that apply. If the parameter file does exist, the
following parameters are read:

*method - string*  
The spectrogram method to use. This parameter is not read if the **-m**
option is used. If the parameter is present and is read, it determines
the values for all other parameters as discussed under the **-m**
option. The other parameters are not read subsequently (i.e., their
values are fully determined by *method*) unless *method* is "other". In
this special case, defaults for the other parameters are those of the
"wb" method, but they can be superceded by the values of other
parameters in the file. The purpose of this exception is to provide the
following behavior when *sgram* is called with the system default
parameter file by means of *eparam*(1-ESPS): The user is prompted for
*method*. If either "wb" or "nb" is specified, processing proceeds with
the named method. If "other" is specified, the user is prompted for all
of the needed parameters.

*data_window - string*  
The data window to apply to the data. This parameter is not read if the
**-d** option is specified or if *method* is in the parameter file and
does not have the value "other". Acceptable values include "RECT" for a
rectangular window, "HAMMING" for Hamming, "HANNING" for Hanning, and
"TRIANG", for triangular; see the *window*(3-ESPSsp) manual page for the
complete list.

*fft_order - integer*  
> The order of the FFT - the transform length is 2 to the power
> *fft_order.* This parameter is not read if the **-o** is specified of
> if *method* is in the file and does not have the value "other".

*start - integer*  
> The first point in the input sampled data file that is processed. A
> value of 1 denotes the first sample in the file. This parameter is not
> read if the **-p** or **-s** option is specified. If it is not in the
> parameter file, and neither option is specified, a default value of 1
> is used.

*nan - integer*  
> The total number of data points to process. If *nan* is 0, processing
> continues through the end of the file. This parameter is not read if
> the **-p** or **-s** option is specified. If it is not in the
> parameter file, and neither option is specified, a default value of 0
> is used.

*window_len - float*  
> The duration in milliseconds of each frame. This parameter not read if
> the **-w** option is specified of if *method* is in the file and does
> not have the value "other".

*pre_emphasis - float*  
The coefficient in the preemphasis filter (see **-E** in the Options
section). This parameter not read if the **-E** option is specified of
if *method* is in the file and does not have the value "other".

*desired_frames - int*  
The desired number of output frames (see the description of the **-T**
option). A value of 0 means that the step size is to be determined from
other considerations (e.g., via *method* and *step_size*). This
parameter is not read if the **-T** option is specified.

*step_size - float*  
Initial points of consecutive frames differ by this number of
milliseconds. This parameter not read if the **-S** or **-T** options
are specified, if *method* is in the parameter file and does not have
the value "other", or if desired_frames is in the parameter file and has
a non-zero value.

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

# ESPS COMMON

ESPS Common is read provided that Common processing is enabled and that
the *filename* entry in Common matches *input.sd.* In that case
parameters present in Common override values from the parameter file and
may in turn be overridden by command line options. That is, in the
sections on ESPS Parameters and Options, parameters described as being
found in the parameter file may instead be found in the Common file if
Common processing is enabled.

If Common processing is enabled and if *output.fspec* is not standard
output, the Common parameters *filename, prog, start,* and *nan* are
written to Common, where *filename* is set equal to *input.sd.*

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overridden by setting
the environment variable ESPSCOM to the desired path. User feedback from
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

*Sgram* reads the value of *common.type* and the generic header item
*start_time* from the input file.

Relevant fields in the type-dependent portion of the output file header
are filled appropriately. The standard generic header items required for
FEA_SPEC files are filled in (see FEA_SPEC(5-ESPS) for details). The
generic header item *fft_order* is set to the order of the FFT, the item
*fft_length* is set to the length of the FFT, the item *step* is set to
the step size (but measured in samples rather than milliseconds (see
**-S**), and the item *sgram_method* is set to the spectrogram method.
The value "other" is used for *sgram_method* if there are any changes
from the two standard methods "wb" and "nb". The CODED generic header
item *window_type* is set according to to the window type.

The generic header item *start_time* (type DOUBLE) is written in the
output file. The value written is computed by taking the *start_time*
value from the header of the input file (or zero, if such a header item
doesn't exist) and adding to it the offset time (from the beginning of
the input file) of the first point processed plus one half of
*frame_len* (thus, *start_time* is middle of the first frame, which is
appropriate since the output data represent the entire frame; without
this adjustment for *frame_len*, *waves*+ displays would not line up
properly.

If the **-T** option is used (or if a non-zero *desired_frames* value is
obtained from the parameter file), the generic header item
*desired_frames* is written to the output file.

The generic header item *record_freq* (type DOUBLE) is written in the
output file. The value is the number of output records per second of
input data.

The preemphasis filter coefficient is recorded in a header item
*pre_emphasis.*

# SEE ALSO

    plotsgram(1-ESPS), fft(1-ESPS), me_sgram(1-ESPS),
    image(1-ESPS), dither(1-ESPS), refcof(1-ESPS),
    me_spec(1-ESPS), filter(1-ESPS), window(3-ESPS),
    FEA_SPEC(5-ESPS), FEA_SD(5-ESPS)

# BUGS

Like other ESPS programs, *sgram* stops processing when the analysis
window of a particular frame extends past the upper limit of the range
(see the discussion about number of frames in "DESCRIPTION"). As a
result, spectrograms computed from *waves*+ may end noticeably before
the end of the marked segment for cases in which the analysis window is
long (e.g., narrow-band spectrograms). The workaround is to mark a
larger segment before calling for the spectrogram. This will be fixed in
a later release.

# AUTHOR

David Burton, Rod Johnson, John Shore.
