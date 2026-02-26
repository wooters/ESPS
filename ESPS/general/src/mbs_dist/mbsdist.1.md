# NAME

mbs_dist - Computes the modified bark spectral distortion

# SYNOPSIS

**mbs_dist** \[ **-a** \] \[ **-{pr}** *range1* \[ **-{pr}** *range2*
\]\] \[ **-x** *debug_level* \] \[ **-A** \] \[ **-P** *param_file* \]
*inFile1* *inFile2* \[ *outFile* \]

# DESCRIPTION

*mbs_dist*(1-ESPS) computes the Modified Bark Spectral Distortion (MBSD)
\[1\] of one signal with respect to another, given power-spectrum
estimates for the two signals such as produced by *fft*(1-ESPS). The
program accepts two input FEA_SPEC files (*FEA_SPEC*(5-ESPS)):
*inFile1,* assumed to pertain to the reference signal, and *inFile2,*
assumed to pertain to a processed or corrupted version of the reference
signal. If either input filename is "-", standard input is used.
However, the input files cannot both be standard input. By default,
*mbs_dist* writes an output FEA file (*FEA*(5-ESPS)), *outFile,*
containing frame-by-frame distortion values. Optionally, the overall
distortion may be written in ASCII to standard output (see option
**-A**), and the output file may be suppressed (see **-a**). If standard
output is not used for ASCII output, *outFile* may be "-" for standard
output. The output should not be the same file as either input; however,
it is okay to run the program as a filter by specifying "-" for both
*outFile* and one of the inputs.

For each input file the program first computes "spread" critical-band
spectrum estimates similar (but not identical) to those produced by
*barkspec*(1-ESPS). It then applies a perceptual transformation to
compensate for the differing sensitivity of the human ear at different
frequencies, converting intensity levels in dB to loudness levels in
phons. This is followed by another psychoacoustically based
transformation, resulting in *subjective* loudness in sones, *Ls*(*m*)
for the reference signal and *Ld*(*m*) for the other signal, where *m*
denotes the band number. These transformations are similar to those
performed by *bs_dist*(1-ESPS) \[2\] with some differences of detail
\[1\].

The distortion for a single frame (say frame number *k*) is given by


    	MBSDk = SUMm max{|Ls(m) - Ld(m)| - M(m), 0}

where *SUMm* denotes summation over the critical bands, and *M*(*m*) is
a *noise masking threshold,* computed for each frame by a method
detailed in \[3\].

A record containing a single-frame distortion is written to the output
file for each pair of input frames (reference and processed/distorted).
Not all these values, however, contribute to the computation of overall
distortion. Two *silence thresholds* are established: one for the
reference file and one for the other input file. A single-frame
distortion value is included when the total frame energy from each input
file exceeds the corresponding silence threshold; otherwise the value is
excluded. Each output record contains a Boolean value that indicates
whether the distortion for that frame is included. The overall
distortion is simply the mean of all the included single-frame
distortions.

# OPTIONS

The following options are supported:

**-a**  
When this option is specified, *mbs_dist* sends the final average
distortion value to stdout in ASCII but does not write an output file.

**-p** *range*  
The option **-p** is a synonym for **-r**, and the allowed forms for the
range are the same.

**-r** *first***:***last* **\[1:(last in file)\]**  
**-r** *first***:+***incr*  
**-r** *first*  
This option specifies the range of data to analyze. In the first form, a
pair of unsigned integers specifies the first and last records to
analyze. If *last* = *first* + *incr*, the second form (with the plus
sign) specifies the same range as the first form. If *first* is omitted,
the default value of 1 is used. If *last* is omitted, the range extends
to the end of the file. The third form (omitting the colon) specifies a
single record.

This option may be used at most twice. If used once, it applies to both
input files. If used twice, it applies to *inFile1* the first time and
*inFile2* the second time. If two **-r** options specify definite range
sizes that are inconsistent, the program issues an error message. If the
end of one range is unspecified, the size of the other range determines
the number of records processed. If the ends of both ranges are
unspecified, processing continues until one input file is exhausted.

**-x** *debug_level* **\[0\]**  
A positive value specifies that debugging output is to be printed on the
standard error output. Larger values result in more output. For the
default value, 0, there is no output.

**-A**  
When this option is specified, *mbs_dist* sends the final average
distortion value to stdout in ASCII after writing the output file. In
this case, *outFile* must not be "-".

**-P** *param_file \[params\]*  
Use the specified parameter file rather than the default, which is
*params*.

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
parameter values that apply. If the parameter file does exist, the
following parameters are read:

*start - integer*  
> The first record in each input data file to process. A value of 1
> denotes the first record in the file. The value may be either a single
> integer, applying to both input files, or an array with two elements,
> one for each input file. This is only read if the **-p** and **-r**
> options are not used.

*nan - integer*  
> The total number of data records to process. If *nan* is 0, processing
> continues until one input file is exhausted. This is read only if the
> **-p** and **-r** options are not used.

# ESPS COMMON

The ESPS common file is not used by this program.

# ESPS HEADERS

A new file header is created for the FEA output file. The file headers
from the input FEA data files are added as source files in the output
file header, and the command line is added as a comment.

The output header contains definitions for a FLOAT field *MBSD,* to hold
the distortion value for each frame, and a CODED field *MBSD_included,*
to hold a Boolean value (NO or YES) indicating whether the distortion
value is included in the computation of the overall average distortion.

The program writes the usual values into the common part of the output
header. *mbs_dist* writes the following values into the specified
generic header items:


    	start = (LONG, size 2) starting record numbers
    	nan = (LONG) number of records analyzed in file
    	distortion_type = (CODED) MBSD

which are added to the output FEA file header.

If the input files are both tagged feature files, then, for each file,
the value of the header item *src_sf* is obtained if present, or *sf* if
*src_sf* is not present. If the value is the same in both files, it is
recorded in a generic header item *src_sf* added to the output header,
and the output file is tagged.

If generic header items *record_freq* are present in both input files
and have the same value, then the value is recorded in a header item
*record_freq* in *outFile,* and a generic header item *start_time* (type
DOUBLE) is also written in the output file. The value of *start_time* is
computed by taking the *start_time* value from the header of *inFile1*
(or zero, if such a header item doesn't exist) and adding to it the
offset time (from the beginning of *inFile1*) of the first record
processed.

# FUTURE CHANGES

None contemplated.

# EXAMPLES

Suppose *orig.sd* is a sampled-data file containing a reference speech
signal, and *proc.sd* contains a processed or distorted version of the
speech in *orig.sd.* For compatibility with ref. \[1\], a sampling rate
of 8000 Hz is recommended, and the inputs to *mbs_dist* should be
prepared by using *rem_dc*(1-ESPS) followed by *fft*(1-ESPS) with the
options shown here.

    rem_dc orig.sd - \
    	| fft -wHANNING -o10 -l320 -S160 - orig.spec
    rem_dc proc.sd - \
    	| fft -wHANNING -o10 -l320 -S160 - proc.spec
    mbs_dist -A orig.spec proc.spec dist.fea > dist.txt

This set of commands should result in an output file *dist.fea,*
containing frame-by-frame distortions, and a one-line text file
*dist.txt,* containing the overall average distortion in ASCII.

# ERRORS AND DIAGNOSTICS

The program prints a synopsis of command-line usage and exits if an
unknown option is specified, if **-r** is used more than twice, or if
the number of file names is wrong. It prints a warning and exits if both
input files are standard input, if the same file is specified for both
input and output, or, when **-A** is used, if the output file is
standard output.

The program prints a warning and exits unless the two input files either
(1) have consistent values of *record_freq* or (2) are tagged and have
consistent values for *src_sf* (or *sf*, when *src_sf* is not present).
In the latter case, if the the tag values in the two selected ranges of
records do not match, the program prints a warning and continues.

The program warns and exits if a **-r** option specifies a starting
record before the beginning of the file or specifies an empty range of
records, or if two **-r** options specify ranges with different explicit
lengths.

If the generic header item values of *contin* in the two input files
don't match, or if the values of *freq_format* are not both SYM_EDGE,
the program warns and exits.

The program warns and exits if a parameter read from the parameter file
has the wrong data type,

# BUGS

None known.

# SEE ALSO

*barkspec*(1-ESPS), *bs_dist*(1-ESPS), *fft*(1-ESPS),\
*rem_dc*(1-ESPS), *FEA_SPEC*(5-ESPS), *FEA*(5-ESPS),

# REFERENCES

\[1\] W. Yang, M. Benbouchta, and R. Yantorno, \`\`*Performance of the
Modified Bark Spectral Distortion* as an Objective Speech Quality
Measure,'' 1998 ICASSP Proceedings, pp 541-544.

\[2\] S. Wang, A. Sekey, and A. Gersho, \`\`An Objective Measure for
Predicting Subjective Quality of Speech Coders,'' *IEEE Journal On
Selected Areas In Communications*, Vol. 10, no. 5, 819-829 (June 1992).

\[3\] J. Johnston, \`\`Transform Coding of Audio Signals Using
Perceptual Noise Criteria,'' *IEEE Journal On Selected Areas In
Communications*, Vol. 6, no. 2, 314-323 (February 1988).

# AUTHOR

Manual page by Rodney Johnson, based in part on *bs_dist* man page.
Program based on code supplied by Wonho Yang, adapted to ESPS by Rodney
Johnson.
