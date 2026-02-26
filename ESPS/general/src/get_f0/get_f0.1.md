# NAME

    get_f0 - robust analysis of speech fundamental frequency (pitch tracking)

# SYNOPSIS

**get_f0** \[ **-P** *param_file* \]\[ **-{pr}***range* \]\[ **-s**
*range* \]\[ **-S** *frame_step* \]\[ **-i** *frame_step* \]\[ **-x**
*debug_level* \] *in_file* *out_file*

# DESCRIPTION

*Get_f0* implements a fundamental frequency (F0) estimation algorithm
using the normalized cross correlation function and dynamic programming.
The algorithm implemented here is described exactly in the reference
cited below.

The input file *in_file* is a standard FEA_SD sampled-data data file.
The output file *out_file* is a FEA file containing 4 fields: *F0* for
fundamental frequency estimate, *prob_voice* for "probability of
voicing", *rms* for local root mean squared measurements, and *ac_peak*
for the peak normalized cross-correlation value that was found to
determine the output F0. The RMS value of each record is computed based
on a 30 msec hanning window with its left edge placed 5 msec before the
beginning of the frame. In unvoiced regions, *ac_peak is the largest*
cross-correlation value found at any lag. The *prob_voice* element only
takes on two values: 0 and 1, whereas in the older *formant* program, it
was a graded (though error prone) measure.

Note that the analysis frame onset is well defined as the point where
the reference window used for cross-correlation begins. However the
effective frame size is really a function of the local F0, except for
the RMS measurement as stated above.

If *in_file* is replace by by "-", the standard input is read. If
*out_file* is replaced by "-", the standard output is written. The
processing is truly stream oriented. There is no limit on the length of
the input sequence.

*Get_f0* does not remove the DC component from the input signal. Large
DC offsets will impair the voiced/unvoiced decision and lead to
misleading RMS measurements, especially in low-amplitude regions. It is
recommended that the DC component be removed by a program such as
*rem_dc*(1-ESPS) before using *get_f0*.

Note that *get_f0* is designed to replace the pitch tracking function of
the older *formant* program. fIGet_f0 is both faster and more accurate
than *formant*, and does not have the batch-processing limitations of
the latter.

# OPTIONS

The following options are supported:

**-P** *param_file \[params\]*  
uses the parameter file *param_file* rather than the default, which is
*params*.

**-r** *first:last*  
**-r** *first:+incr*  
Determines the range of points from input file. In the first form, a
pair of unsigned integers gives the first and last points of the range.
If *first* is omitted, 1 is used. If *last* is omitted, the last point
in the file is used. The second form is equivalent to the first with
*last = first + incr*. If no range is specified, the whole input file is
processed.

**-p** **  
Same as the **-r** option. (Note that this is a change from version 5.0,
where **-p** was used for the frame intertval option.)

**-s** *first:last*  
**-s** *first:+incr*  
Same function as the **-r** option, but specifies the range of input
data in seconds

**-i** *frame_step \[0.01\]*  
Specifies frame step in second, between 0.1 and 1/sampling rate in sec.

**-S** *frame_step \[0.01 \* sampling frequency\]*  
Same as the -i option, but specifies frame step in samples

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *get_f0* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

*Get_f0* is designed for use "as is" with little or no need to change
its parameters under most circumstances. Exceptions include the frame
rate, and the maximum F0 and minimum F0 to track. If the F0 estimates
from *get_f0* do not appear reasonable, you should check your signal or
signal conditioning before beginning parameter adjustments. Common
causes of difficulty include a strong periodic component in the
background causing the voicing to stay on, or a significant DC offset
causing poor RMS estimates. The following parameter file options are
supported.

*start - integer*  
> The first point in the input sampled data file that is processed. A
> value of 1 denotes the first sample in the file. This is only read if
> the **-p** option is not used. If it is not in the parameter file, the
> default value of 1 is used.

*nan - integer*  
> The total number of data points to process. If *nan* is 0, the whole
> file is processed. *Nan* is read only if the **-p** option is not
> used. (See the discussion under **-l**).

 *frame_step - float*  
Analysis frame step interval. Computation increases as 1/*frame_step*.
Valid value lies in \[1/sampling rate, 0.1\].

 *min_f0 - float*  
Minimum F0 to search for. Note that computational cost grows as
1/min_f0. Valid values are greater than or equal to (Fs/10000) Hz, where
Fs is the sample rate of the input speech signal. Default is 50.0.
*min_f0* and *max_f0* determine the number of cross-correlation lags to
compute for each frame.

 *max_f0 - float*  
Maximum F0 to search for. Valid values are greater than *min_F0* and
smaller than one half the sampling rate of input file. Default is 550.0.
*min_f0* and *max_f0* determine the number of cross-correlation lags to
compute for each frame.

The default settings of the following parameters were determined by
exhaustive search of the parameter space using hand-verified data as the
reference. Twiddling with the parameters is not recommended.

 *cand_thresh - float*  
Determines cross correlation peak height required for a peak to be
considered a pitch-peak candidate. Valid value lies in \[.01, .99\].
Default is 0.3.

 *lag_weight - float*  
Amount of weight given to the shortness of the proposed pitch interval.
Higher numbers make high F0 estimates more likely. Valid value lies in
\[0, 1\]. Default is 0.3.

 *freq_weight - float*  
Strength of F0 continuity. Higher numbers impose smoother contours.
Valid value lies in \[0, 1\]. Default is 0.02.

 *trans_cost - float*  
Fixed cost of making a voicing-state transition. Higher numbers
discourage state changes. Valid value lies in \[0, 1\]. Default is
0.005.

 *trans_amp - float*  
Voicing-state transition cost modulated by the local rate of amplitude
change. Higher numbers discourage transitions EXCEPT when the rate of
amplitude change is great. Valid values lie in \[0, 100\]. Default is
0.5.

 *trans_spec - float*  
Voicing-state transition cost modulated by the local rate of spectral
change. Higher numbers discourage transitions EXCEPT when the rate of
spectral change is great. Valid values lie in \[0, 100\]. Default is
0.5.

 *voice_bias - float*  
Determines fixed preference for voiced or unvoiced state. Positive
numbers encourage the voiced hypothesis, negative numbers the unvoiced.
Valid values lie in \[-1, 1\]. Default is 0.0.

 *double_cost - float*  
The cost of a rapid one-octave (up or down) F0 change. High numbers
discourage any jumps, low numbers permit octave jumps. Valid values lie
in \[0, 10\]. Default is 0.35.

 *wind_dur - float*  
Size of correlation window. Computation increases directly as wind_dur.
Valid values lie in \[10/sampling rate, .1\]. Default is 0.0075.

 *n_cands - integer*  
The maximum number of correlation peaks considered as possible F0-peak
candidates in any frame. At most, the top n-cands candidates are
considered in each frame. The computational cost grows approximately as
n_cands SQUARED. Valid values lie in \[3, 100\]. Default is 20.

# ESPS COMMON

No ESPS common parameter processing is supported.

# ESPS HEADERS

The usual *record_freq*, *start_time* header items, all supported
parameters are stored as generic header items. In addition, the
*record_freq* header item of the *in_file* input file is saved as the
*src_sf* header item.

# FUTURE CHANGES

In a future release DC will be removed prior to RMS comutation. Also, an
optional element may be added to the output vector to include RMS
computed on the preemphasized speech.

# EXAMPLES

# ERRORS AND DIAGNOSTICS

# BUGS

None known.

# REFERENCES

Talkin, D. (1995). A Robust Algorithm for Pitch Tracking (RAPT). In
Kleijn, W. B. and Paliwal, K. K. (Eds.), *Speech Coding and* Synthesis.
New York: Elsevier.

# SEE ALSO

FEA(5-ESPS), epochs(1-ESPS), formant(1-ESPS), rem_dc(1-ESPS)

# AUTHORS

David Talkin, Derek Lin
