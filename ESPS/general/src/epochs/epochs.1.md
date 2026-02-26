# NAME

    epochs - glottal-pulse analysis using dynamic programming 

# SYNOPSIS

**epochs** \[ **-P** *param_file* \]\[ **-p** \]\[ **-n** \]\[ **-b**
*in_labelfile* \]\[ **-f** *in_f0file* \] **-o** *out_labelfile* \]\[
**-x** *debug_level* \] *in_file* *out_file*

# DESCRIPTION

*Epochs* uses dynamic programming optimization to determine both the
polarity and locations of the pitch epoch pulses (times of vocal fold
closure) during voiced speech. The algorithm will work for any
quasi-periodic input signal, but is currently tuned for operation on
integrated LPC speech residual signals.

The input file *in_file* is typically a 16-bit PCM inverse-filtered
speech file of FEA_SD type processed to approximate the derivative of
the glottal volume velocity. A speech residual signal produced by
*get_resid (1-ESPS)* would be appropriate. The output file *out_file* is
a FEA_SD file with impulses at the epoch locations and zeros elsewhere.
The polarity of the output pulses reflects the polarity of the peaks
chosen in the input signal.

Unvoiced speech in *in_file* often results in false pitch epoch
estimation. Consider using *mask(1-ESPS)* to gate out unwanted pitch
epochs by masking them against a better voice/unvoiced estimator, such
as that produced by *get_f0(1-ESPS)*.

# OPTIONS

The following options are supported:

**-P** *param_file \[params\]*  
uses the parameter file *param_file* rather than the default, which is
*\$ESPS_BASE/lib/params/Pepochs*.

**-p**  
**-n**  
specifies that only positive (*-p*) or negative (*-n*) local extrema in
*in_file* need be considered as potential epochs. If neither option is
specified, all local extrema are considered. The processing time can be
cut in half or more by specifying one of these options, if the polarity
of the *in_file* is known in advance. *In_file* may be examined with
*waves+* to determine the polarity of any given data set. NOTE: if the
pulse polarity is incorrectly specified, analysis results will range
from tolerable to horrible.

**-b** *in_labelfile*  
*In_labelfile* is the name of a label file (as created by *waves+*; "V"
label for voiced, "O" label for unvoiced and others) used to gate on the
epoch finder only in selected regions. Best epoch-location results
(especially near voice onset/offset) are obtained if neither *-b* or
*-f* option is used.

**-f** *in_f0file*  
*In_f0file* is the name of a FEA file containing the *prob_voice* field
(as created by *get_f0(1-ESPS)*) used to gate on the epoch finder only
in selected regions. Best epoch-location results (especially near voice
onset/offset) are obtained if neither *-b* or *-f* option is used.

**-o** *out_labelfile*  
*Out_labelfile* is the name of a file to contain epoch marks in *waves+*
"label" format (see *xlabel*(1-ESPS)).

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *epochs* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

The following parameters are supported. Except the *polarity* parameter,
all parameters have default settings optimally determined by exhaustive
search of the parameter space using electro-glottographic data as the
reference. Twiddling with the parameters is NOT recommended. A possible
exception to this is the *clip_level* which can be increased to reduce
the number of peaks considered using dynamic progrmming. This will speed
up operation, but can result in loss of peaks for some voicing
conditions (e.g. extreme breathy voice).

*polarity - string*  
Similar to *-p* and *-n* command-line options: a value of "+" to
consider only peaks with positive polarity as potential epochs; a value
of "-" for negative polarity; and a value of "NONE" is to consider all
peaks as potential epoch locations.

All parameters below have values between 0.0 and 1.0.

*clip_level - float*  
The clipping level that determines what fraction of the local RMS a peak
must exceed to be considered as an epoch candidate. Default is 0.5.

*peak_quality_wt - float*  
Weight given to peak quality. Default is 1.0.

*period_dissim_cost -float*  
Cost of dissimilarities in the shape of consecutive peaks. Default is
0.4.

*peak_qual_dissim_cost - float*  
Cost for peak quality dissimilarity. Default is 0.05.

*shape_to_peak - float*  
Relative contribution of shape to peak quality. Default is 0.35.

*freq_dh_cost - float*  
Cost of each frequency doubling/halving. Sometimes the F0 really does
jump by octaves. Low values make octave jumps more likely. Default is
0.7.

*peak_award - float*  
Award for selecting a peak. Determines average peak density. Default is
0.4.

*v_uv_cost - float*  
cost for V-UV transition. High values discourage state transitions.
Default is 0.2.

*uv_v_cost - float*  
Cost for UV-V transition. High values discourage state transitions.
Default is 0.2.

*rms_onoff_cost - float*  
Cost for RMS rise/fall appropriateness. This assumes RMS rises at voice
onset and falls at voice offset. The extent to which voicing transition
costs are relaxed at these points is adjusted by this factor. Default is
0.3.

*uv_cost - float*  
Cost of unvoiced classification. Default is 0.7.

*jitter - float*  
Reasonable inter-period variation expressed as a fraction of a period.
Default is 0.1.

# ESPS COMMON

No ESPS common parameter processing is supported.

# ESPS HEADERS

The generic header items saved are the standard header items,
*start_time* and *record_freq*, and any parameter under **ESPS
PARAMETERS** if its value is acquired by means of parameter file.

# FUTURE CHANGES

# EXAMPLES

The following fragment of a Bourne shell script demonstrates how epochs
might be located in an ESPS speech file named "spch.sd". The resulting
"spch.lab" file contains epoch marks expressed in time in a form
compatible with the *xlabel* program. The "spch.pe" file represents the
epoch locations as a series of pulses in a file directly viewable using
*xwaves*. See also the example in *lp_syn (1-ESPS)*.

    # Determine the sample rate of the original speech file.
    sf=`hditem -i record_freq spch.sd`
    #
    # Establish the window size and frame step for periodic analyses.
    size=.02
    step=.005
    #
    # Get analysis step size and window length in samples.
    ssize=`echo $sf $size \* p q | dc`
    sstep=`echo $sf $step \* p q | dc`
    #
    # Standard rule-of-thumb computation for LPC order.
    order=`echo $sf 1000 / 2 + p q | dc`
    #
    # Compute reflection coefficients using a standard set of parameters
    refcof -z -r1:1000000 -e.97 -x0 -wHANNING -l$ssize -S$sstep \
           -o$order spch.sd spch.rc
    #
    # Get a high-resolution estimate of F0 and a reasonably accurate
    #  voicing-state estimate.
    get_f0 -i $step spch.sd spch.f0
    #
    # Compute the LPC residual (approximates the glottal flow derivative).
    get_resid -a 1 -i 0.0 spch.sd spch.rc spch.res
    #
    # Blank out the residual signal in the unvoiced regions.
    mask spch.f0 spch.res spch.resm
    #
    # Find the points of glottal closure in the voiced regions.
    epochs  -o spch.lab spch.resm spch.pe

# ERRORS AND DIAGNOSTICS

# BUGS

None known.

# REFERENCES

Talkin, D., "Voicing epoch determination with dynamic programming," *J.
Acoust. Soc. Amer.*, 85, Supplement 1, 1989.

Talkin, D. and Rowley, J., "Pitch-Synchronous analysis and synthesis for
TTS systems," *Proceedings of the ESCA Workshop on Speech* Synthesis, C.
Benoit, Ed., Imprimerie des Ecureuils, Gieres, France, 1990.

# SEE ALSO

    refcof(1-ESPS), get_resid(1-ESPS), mask(1-ESPS), 
    get_f0(1-ESPS), ps_ana(1-ESPS)

# AUTHORS

David Talkin, Derek Lin
