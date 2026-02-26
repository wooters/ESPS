# NAME

    lp_syn -  speech LPC synthesis from an excitation signal or a parametric source

# SYNOPSIS

**lp_syn** \[ **-P** *param_file* \] \[ **-{pr}** *range* \] \[ **-s**
*range* \] \[ **-i** *int_const* \] \[ **-t** *synth_rate* \] \[ **-f**
*f0_ratio* \] \[ **-u** *up_ratio* \] \[ **-d** *damp* \] \[ **-z** \]
\[ **-x** *debug_level* \] **lpfile** **exfile** **outfile**

# DESCRIPTION

*Lp_syn* uses the LP (linear prediction) or reflection coefficients
stored in the file *lpfile* to synthesize a speech signal from an
excitation source or a parametric source in the file *exfile*. *Lpfile*
is a FEA file with the field *spec_param* to store the spectral
coefficients and with the generic header item *spec_rep* specifying the
type of spectral representation -- *"RC"* for reflection coefficients or
*"AFC"* for LP coefficients. *Exfile* may be a FEA_SD file of SHORT data
type as an excitation source, or a FEA file as a parametric source. If
*exfile* is a FEA file, it must contain three fields: *rms* for the
frame RMS value, *F0* for the frame fundamental frequency, and
*prob_voice* for the frame voicing state.

The synthesizer uses a Rosenberg-polynomial glottal-flow pulse,
open-phase damping, and per-sample gain correction.

# OPTIONS

The following options are supported:

**-P** *param_file \[params\]*  
uses the parameter file *param_file* rather than the default, which is
*params*.

**-r** *first:last*  
**-r** *first:+incr*  
Determines the range of frames from input file, *lpfile*. In the first
form, a pair of unsigned integers gives the first and last frame of the
range. If *first* is omitted, 1 is used. If *last* is omitted, the last
frame in the file is used. The second form is equivalent to the first
with *last = first + incr*.

**-p** **  
Same as the **-r** option.

**-s** *first:last*  
**-s** *first:+incr*  
Same function as the **-r** option, but specifies the range of input
frames in seconds.

**-i** *int_const \[0.95\]*  
specifies the coefficient of a first-order integrator to be applied to
the output if parametric source is used. This constant is applied in the
fricative regions only. When synthesizing from residual excitation
*int_const* would usually be set to 0.0.

**-t** *synth_rate \[1.0\]*  
specifies the time-scale modification rate. This speeds up or slows down
the rate of speech without distorting the pitch. Use values less than
1.0 to slow the speech, use values more than 1.0 to speech it up. This
can only be used during parametric source synthesis.

**-f** *f0_ratio\[1.0\]*  
specifies the output fundamental frequency scale factor if and only if
parametric source is used. The output fundamental frequency is
multiplied by this factor.

**-u** *up_ratio \[1\]*  
specifies the upsampling ratio to use during synthesis from a parametric
source. This produces an output file with sampling rate of *up_ratio*
times the value of *src_sf* generic header item in the input *lpfile*.
If *src_sf* does not exist in *lpfile*, a value of 2 times the value of
*bandwidth* generic header in *lpfile* is assumed. Valid values are
integers greater or equal to one.

**-d** *damp \[0.1\]*  
specifies a parameter that controls the amount of open-glottal-phase
damping that is applied to the lattice filter state vector when
parametric source synthesis is performed. When LP coefficients are
computed using standard frame-synchronous analysis (e.g. hanning window;
25ms duration), it is usually best to set *damp* to 0.0. When parameters
are computed using *ps_ana*, values greater than zero often improve the
naturalness of the synthetic speech.

**-z**  
inverts the sign of input spectral parameters before using them for
synthesis.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *lp_syn* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

The following ESPS parameters have the same meanings as the command-line
options supported

*start - integer*  
> The first frame in the input file *lpfile* that is processed. A value
> of 1 denotes the first frame in the file. This is only read if the
> **-p** option is not used. If it is not in the parameter file, the
> default value of 1 is used.

*nan - integer*  
> The total number of frames in the file *lpfile* to process. If *nan*
> is 0, the whole file is processed. *Nan* is read only if the **-p**
> option is not used. (See the discussion under **-p**).

*int_const - float*  

*synth_rate - float*

*f0_ratio - float*

*up_ratio - int*

*damp - float*

# ESPS COMMON

No ESPS common parameter processing is supported

# ESPS HEADERS

The usual *record_freq*, *start_time* header items, and all supported
parameters are stored as generic header items.

# FUTURE CHANGES

# EXAMPLES

The example shell script included below shows how one might use some of
the analysis and synthesis programs supplied with ESPS. The script takes
one argument, the basename of a speech file with the extension ".sd".
Read the comments in the script for details.

    #!/bin/sh
    #
    # Determine the sample rate of the original speech file.
    sf=`hditem -i record_freq $1.sd`
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
           -o$order $1.sd $1.rc
    #
    # Get a high-resolution estimate of F0 and a reasonably accurate
    #  voicing-state estimate.
    get_f0 -i $step $1.sd $1.f0
    #
    # Compute the LPC residual (approximates the glottal flow derivative).
    get_resid -a 1 -i 0.0 $1.sd $1.rc $1.res
    #
    # Blank out the residual signal in the unvoiced regions.
    mask $1.f0 $1.res $1.resm
    #
    # Find the points of glottal closure in the voiced regions.
    epochs  -o $1.lab $1.resm $1.pe
    #
    # Perform epoch-synchronous LPC analysis.
    ps_ana -f $1.f02 -i $step -e .97 $1.sd $1.pe $1.rc
    #
    # Perform synthesis using these parameters.
    lp_syn $1.rc $1.f02 $1.syn
    #
    # Alternatively, the better F0 and voicing-state estimates from get_f0
    # can be used by merging them with the preemphasized RMS feature from
    # ps_ana:
    rm -f $1.f03
    mergefea -fF0 -fprob_voice  $1.f0 $1.f03
    mergefea -a -f rms $1.f02 $1.f03
    #
    # Perform synthesis using these new parameters.
    lp_syn $1.rc $1.f03 $1.syn2

# ERRORS AND DIAGNOSTICS

# BUGS

Synthesis using LPC (AFC) parameters does not work in the parametric
excitation mode. This will be fixed in the next release. Synthesis using
reflection coefficients (RC), does work in both modes.

# REFERENCES

Talkin, D. and Rowley, J., "Pitch-Synchronous analysis and synthesis for
TTS systems," *Proceedings of the ESCA Workshop on Speech* Synthesis, C.
Benoit, Ed., Imprimerie des Ecureuils, Gieres, France, 1990.

# SEE ALSO

refcof (1-ESPS), get_resid (1-ESPS), mask (1-ESPS), get_f0 (1-ESPS),
ps_ana (1-ESPS), transpec (1-ESPS)

# AUTHORS

David Talkin, Derek Lin
