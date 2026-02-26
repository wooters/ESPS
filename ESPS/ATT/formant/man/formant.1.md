# NAME

formant - speech formant and fundamental frequency (pitch) analysis

# SYNOPSIS

**formant** \[ **-p** *preemphasis* \] \[ **-n** *num_formants* \] \[
**-o** *lpc_order* \] \[ **-i** *frame_step* \] \[ **-w**
*window_duration* \] \[ **-W** *window_type* \] \[ **-t** *lpc_type* \]
\[ **-F** \] \[ **-O** *output_path* \] \[ **-r** *range* \] \[ **-S**
\] \[ **-f** *ds_freq* \] \[ **-y** *f0_max* \] \[ **-z** *f0_min* \] \[
**-N** *nom_f0_freq* \] \[ **-B** *max_buff_bytes* \] \[ **-R**
*maxrms_duration* \] \[ **-M** *maxrms_value* \] \[ **-x** *debug_level*
\] *infile*

# DESCRIPTION

*Formant* estimates speech formant trajectories, fundamental frequency
(F0) and related information. In particular, for each frame of sampled
data, *formant* estimates formant frequencies, formant bandwidths, pole
frequencies corresponding to linear predictor coefficients, and voicing
information (fundamental frequency, voiced/unvoiced decision, rms
energy, first normalized autocorrelation, and the first reflection
coefficient).

If only F0 analysis is desired, the new and better F0 estimation program
*get_f0*(1-ESPS) should be used, since it is faster, more accurate and
more convenient to use. *Get_f0* processes data in stream mode, and so
has no constraints on the length of the input data sequence (or file).

Dynamic programming is used to optimize F0 and formant trajectory
estimates by imposing frequency continuity constraints. The formant
frequencies are selected from candidates proposed by solving for the
roots of the linear predictor polynomial computed periodically from the
speech waveform. The local costs of all possible mappings of the complex
roots to formant frequencies are computed at each frame based on the
frequencies and bandwidths of the component formants for each mapping.
The cost of connecting each of these mappings with each of the mappings
in the previous frame is then minimized using a modified Viterbi
algorithm.

The input file *infile* is a sampled-data file---typically an ESPS
FEA_SD file, though other formats are accpted as well (see
*get_feasd_recs*(3-ESPS)). *Formant* produces various output files with
the same file name body as *infile* (the name body results from removing
the last of any extensions---e.g., the name body of "foo.sd" is "foo"),
but with different extensions. Voicing information is stored in a FEA
file with extension ".f0", formants and bandwidths are stored in a FEA
file with extension ".fb", and pole frequencies are stored in an ASCII
file with extension ".pole". For details on these and related files that
are relevant for use with *xwaves*, see "FILE FORMATS", below. The
**-O** option permits specification of an alternate output path in cases
where it is undesirable or impossible to write in the input directory.

If the sampling frequency of the input speech file is greater than 10
kHz (or the **-f** specified value), *formant* downsamples the input
file to the appropriate sampling rate and saves the results in an ESPS
FEA_SD file with a ".ds" extension. The input signal, possibly
downsampled, is then high-pass filtered to remove low frequency rumble
(cut-off at approximately 80 Hz), with the result stored in an ESPS
FEA_SD file with a ".hp" extension. The ".hp" file is then used for the
F0 and formant frequency estimates in the manner described above.

Preemphasis is applied prior to the linear prediction analysis in order
to compensate partially for voice source and radiation characteristics.
The high-pass filtering is intended to provide a zero-mean signal for
linear prediction analysis when there is a possibility of residual DC
because the real zero of the preemphasis filter is within the unit
circle. For reliable F0 estimation based on cross correlations, it is
essential that the DC and rumble be removed, which is another reason for
the high pass filtering.

If ".ds" or ".hp" files already exist in the current directory when
*formant* is run, they are used directly and not re-computed. This
shortcut is intended to save time when analysis conditions are varied.
It is, however, somewhat error prone so you should be aware of what
files are around.

# OPTIONS

**-d** *debug_level* **\[0\]**  
Values greater than 0 cause messages to print to stderr.

**-p** *preemphasis* **\[.7\]**  
Specifies the pre-emphasis constant to use before linear predictor
analysis. Possible values range from 0 to 1.

**-n** *num_formants* **\[4\]**  
Specifies the number of formants to attempt to track. For adult
speakers, this number is normally less than or equal to the sampling
frequency in kHz. (after down sampling) divided by 2, and less than or
equal to (*lpc_order* - 4) / 2. Currently, a maximum of seven formants
are supported.

**-w** *window_duration* **\[.049\]**  
Specifies the length of the data window in seconds over which the linear
predictor analysis takes place. Note that this default window size is
intended for use with a cos\*\*4 window. The equivalent length for a
hanning window would be about 25 ms.

**-W** *window_type* **\[cos\*\*4\]**  
Specifies the type of data window to apply to the data prior to linear
predictor analysis. Possible values are 0 (rectangular), 1 (Hamming), 2
(cos\*\*4) and 3 (hanning).

**-i** *frame_step***"***\[.01\]*  
Specifies the step size in seconds between frames. This determines the
amount by which the onset of the data window is moved between analysis
frames.

**-o** *lpc_order* **\[12\]**  
Specifies the order of the linear predictor analysis done in each frame.
Maximum order is 30.

**-f** *ds_freq* **\[10000\]**  
Specifies the sampling frequency of the data to be used in the voicing
and formant frequency analysis. If *ds_freq* is lower than the input
file's sample frequency, the data is down sampled. Othwewise, the input
sample rate prevails.

**-N** *nom_f1_freq***\[500\]"**  
Specifies the nominal value of the first formant frequency. This value
is used by the program to adjust the nominal values of all other
formants and of the ranges over which the formants are permitted to
exist. The default value of 500Hz assumes that the vocal tract length is
17 cm and that the speed of sound is 34000 cm/sec. Nominal F1 values
scale directly with sound velocity and inversely with vocal-tract
length.

**-t** *lpc_type* **\[autocorrelation\]**  
Specifies the linear predictor analysis method. Possible values include
0 (autocorrelation) and 1 (stabilized covariance). If stabilized
covariance method is chosen, however, *window_duration* (**-w**) is set
to .025, *preemphasis* (**-p**) is set to exp{-1800\*pi/samp_freq), and
*window_type* (**-W**) is set to rectangular.

**-y** *f0_max* **\[maximum F0 value\]**  
Specifies the maximum F0 value to search for. Default is 500 Hz.

**-y** *f0_min* **\[minimum F0 value\]**  
Specifies the minimum F0 value to search for. Default is 60 Hz.

**-S**  
Enable the creation of *SIGnal* files for the F0 estimates in addition
to the normal ESPS files. In previous versions of *formant* this was the
default, since *xwaves* required files with *SIGnal* headers to
correctly invoke the special F0 display. *Xwaves* now develops this
display from the ESPS files. Those who still desire the old behavior may
reenable it with this option.

**-r** *range*  
Select a subrange of points to be processed, using the format
*start-end*, *start:end* or *start:+count*. Either the start or the end
may be omitted; the beginning or the end of the file are used if no
alternative is specified. If no range is specified, the entire input
file will be processed.

If multiple files were specified, the same range from each file is
processed. This option was made available primarily so that *formant*
could be used more easily with *add_espsf* in *xwaves*.

**-O** *output_path* **\[\<null\>\]**  
A directory pathname where all output files created by *formant* will be
placed. If **-O** is not specified, output files are placed in the same
directory as the input file.

**-F**  
Only compute F0 and voicing information. Pole frequency (".pole") and
formant frequency (".fb") files are not computed or written.

**-B** *max_buff_bytes* **\[2000000\]**  
Maximum buffer size (in bytes) for holding input data signal. Signals
larger than this will be truncated. At 16,000 samples/second, 2
megabytes corresponds to 62.5 seconds of input data (represented as
SHORTS). Increasing *max_buff_bytes* will allow longer input data
signals to be processed by *formant*. The maximum buffer size that your
system can support is a function of available memory, swap space size,
and current system usage.

**-R** *maxrms_duration* **\[0\]**  
Window (in seconds) of past data over which the maximum rms energy is
computed. The maximum rms energy is needed when computing the
probability of voicing for each cross_correlation frame
(cross-correlation frames are fixed at .01 seconds each). The value used
is the maximum rms energy value from all of the frames in the preceeding
maxrms_duration seconds of data. If maxrms_duration is 0, the maximum
rms energy used is a constant, independent of frame position; in this
case, the value is the maximum of the rms energy of all frames from the
start of the file to the end. (The case with maxrms_duration == 0
corresponds to the previous behavior of *formant*, before **-R** was
added.) The **-R** option cannot be used at the same time as the **-M**
option.

**-M** *maxrms_value* **\[0\]**  
Fixed value to use as the maximum rms energy value need when computing
the probability of voicing for each cross_correlation frame. The **-M**
option cannot be used at the same time as the **-R** option. If neither
**-R** nor **-M** is used, the default is **-R**0.

# EXAMPLES

Here is a UNIX C-shell script that shows several featurs of *formant*
and its use with *xwaves*. This is designed as a tutorial example more
than a serious proposal for getting work done! We suggest that if large
amounts of data are to be processed, *formant* should be run in a "batch
mode" and the results viewed with *xwaves* the next day.


    #!/bin/csh
    # This script, which we shall call "formant_examp",
    # works around the idiosyncratic behavior of formant and provides an
    # xwaves plot of F0 and a spectrogram with estimated formants overlaid.
    # It is designed to be called via an "add_op" menu function from
    # xwaves.  When called this way, xwaves provides the script with
    # arguments specifying the interval to be analyzed, the input file and
    # an output file name.  This script uses the output file name for the
    # F0 estimates.  Assuming the script is made executable and placed
    # somewhere on your executable path, and that xwaves is running,
    # it can be added as a waveform menu item with a shell command like
    #
    # send_xwaves add_op name FTRACK menu wave op formant_examp _range_samp #      _file _out.g.F0 _name _l_marker_time _r_marker_time

    # Create a scratch area.
    mkdir /tmp/fmt$$

    # Determine the name of the xwaves display ensemble.
    set ob = $4

    # Start a spectrogram computation.
    send_xwaves $ob spectrogram file $2 start $5 end $6

    # Now run the formant/F0 tracker.  Put all output files in /tmp.
    formant  -O /tmp/fmt$$ $1 $2

    # Overlay the formant tracks on the just-created spectrogram.
    send_xwaves $ob overlay file /tmp/fmt$$/*.fb.sig

    # Put the F0 (pitch) estimate file where xwaves expects to find it.
    mv /tmp/fmt$$/*.f0 $3

    # Remove all scratch files
    /usr/bin/rm -f /tmp/ob$$ /tmp/fmt$$/* ; rmdir /tmp/fmt$$

# ESPS PARAMETERS

ESPS parameter files are not processed.

# ESPS COMMON

ESPS Common is not processed or written.

# ESPS HEADERS

Standard ESPS record keeping is provided via embedded source file
headers.

All output files have the generic *start_time*, which gives the starting
time (in seconds) of the first record. All FEA files have the generic
*record_freq*, which gives the number of records per second of original
data.

Analysis parameters that can be set by command line options are recorded
as generics in the ".f0" file. In particular, the following generics are
included: *preemphasis, window_duration,* frame_step, lpc_order,
lpc_type, and *window_type*.

# FILE FORMATS

The ".fb" file is an ESPS FEA file with two fields per record, with
field size *num_formants* (**-n** option). The field *fm* stores the
formant frequencies and the field *bw* stores the corresponding formant
bandwidths. Both fields have type DOUBLE.

The ".f0" file is an ESPS FEA file with the following five fields (all
of type DOUBLE):


    	F0 - estimate of fundamental frequency

    	prob_voice - probability of voicing

    	rms - rms in rectangular window

    	ac_peak - peak value of cross correlation at the estimated F0

    	k1 - ratio of the first two cross-correlation values

The ".pole" file is an ASCII file. After the ASCII header, the
variable-length records each contain the following:

> \(1\) The total number of values in the record. This number is
> (2\*N)+2, where N is the number of pole frequencies and bandwidths
> stored in items (4) and (5).

> \(2\) The rms in the LPC analysis window (typically preemphasized).

> \(3\) Zero (yeah, not used).

> \(4\) N complex pole frequencies in Hz.

> \(5\) N complex pole bandwidths in Hz.

The data in the ".fb" file is also output in a SIGnal format file
".fb.sig". This is provided because *xwaves* has formant display and
interaction facilities that are specially tuned for these files.
Although the equivalent ESPS FEA file can also be viewed and modified
through *xwaves*, the ".fb.sig" is often preferable, especially when
formants are overlaid on spectrograms. The need for the (anachronistic)
SIGnal format files will be eliminated in the Spring 1993 software
update. The FEA files are more convenient for use with standard ESPS
tools (e.g., *epsps*, *select*, *fea_stats*, *fea_edit*, *genplot*,
*classify*, etc.).

# FUTURE CHANGES

A complete rewrite is planned to provide much faster computation and the
potential for pipelined operation. (This has already been done for the
F0 estimator---see *get_f0*(1-ESPS).)

Output file specifications will be normalized. Automatic output filename
generation will be eliminated.

The voicing decision will be integrated with the F0 estimation to
improve accuracy and robustness. This is the case for *get_f0*.

# SEE ALSO

    formsy(1-ESPS), FEA(5-ESPS), FEA_SD(5-ESPS), 
    select(1-ESPS), fea_stats(1-ESPS), psps(1-ESPS), 
    refcof(1-ESPS), transpec(1-ESPS), classify(1-ESPS),
    get_feasd_recs(3-ESPS)

# BUGS

Sampled data are read in as SHORTs; hence, accuracy may be lost when
processing FLOAT or DOUBLE data.

The default LPC order and number of formants to track (**-o** and **-n**
options) are only appropriate for 10kHz input data. Unless specified,
these should scale automatically with input sample frequency. In a
future program version, they will.

The interpretation of the start and end points (**-r** option) may be
off by 1 when the input is a NIST Sphere file.

# AUTHOR

Code by David Talkin, AT&T Bell Laboratories; ESPS and other
enhancements by John Shore. Manual page by John Shore, David Burton and
David Talkin.

# REFERENCES

The F0 tracking algorithm implemented in *formant* is related to the one
described in:

B.G. Secrest and G.R. Doddington, "An integrated pitch tracking
algorithm for speech systems", *Proceedings ICASSP83*, pp. 1352-1355.
