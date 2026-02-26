# NAME

bs_dist - Computes the bark spectral distortion

# SYNOPSIS

**bs_dist** \[ **-a** \] \[ **-e** *threshold* \] \[ **-m**
*distortionType* \] \[ **-{pr}** *range1* \[ **-{pr}** *range2* \]\] \[
**-x** *debugLevel* \] \[ **-A** \] \[ **-P** *paramFile* \] *inFile1*
*inFile2* \[ *outFile* \]

# DESCRIPTION

*bs_dist*(1-ESPS) supports the measurement of the Bark Spectral
Distortion (BSD) \[1\] given input data containing "smeared"
critical-band spectrum estimates \[1\], as produced by
*barkspec*(1-ESPS). *bs_dist*(1-ESPS) applies perceptual weighting to
the input filter bank data to compensate for *perceived* loudness by
human listeners, which requires converting intensity levels in dBs to
loudness level in phons. This is followed by another perceptual
transformation from loudness level in phons to *subjective* loudness
(sones). These transformations are described in \[1\].

*bs_dist* accepts two input *FEA_SPEC*(5-ESPS) files (*inFile1* and
*inFile2*), and it processes the data found in the *re_spec_val* field.
*bs_dist* computes distortion values for data in the frequency range
from 0 to 4000 Hz. Spectral values corresponding to frequency values
outside this range are ignored, but data that only covers a subset of
the 0 to 4kHz range is supported. To compute the BSD as described in
\[1\] you need Bark spectral values for 15 bands with filter peak
locations of 1.5 bark, 2.5 bark, ..., 15.5 bark. In this case the lower
-3dB frequency of the first band is 0.91 bark (about 91 Hz), and the
upper -3dB frequency of the 15th band is 15.91 bark (about 4232 Hz);
these limits can be obtained by specifying the option **-B** 0.91:15.91
when running *barkspec*(1-ESPS).

If either input file is "-", standard input is used. Note, however, that
the input files cannot both be standard input. If *outFile* is "-",
standard output is used. In performing the calculations, *inFile1* is
assumed to be the reference file.

By default, an output *FEA*(5-ESPS) file containing the frame-by-frame
distortion values (data type FLOAT) is produced. The frame-by-frame
values are the raw

    	BSDk =  SUMm { Ls(m) - Ld(m) }^2

where *BSDk* is the Bark Spectral Distortion for the *k*th frame, *SUMm*
is the sum from 0 to *M-1* (the length of the vector), *Ls* is the set
of loudness-derived values taken from the original or reference speech,
and *Ld* is the set of loudness-derived values taken from the processed
or distorted speech.

The overall BSD is an average taken over all frames scaled by the
average Bark loudness in the reference signal:

    	BSD = { SUMk BSDk } / { SUMk SUMm { Ls(m)^2 } }

where *L(s)*, *BSDk*, and *SUMm* are as above, and *SUMk* is the sum
over all input frames. You can modify the computed BSD value by using
the **-e** option to set a lower threshold on the input power level for
frames to include in the computation.

The average distortion value (in ASCII) can be sent to standard output
by using the **-a** option. (This also inhibits the generation of an
output file.) Both the distortion waveform and the total average
distortion value can be produced by using the **-A** option. In this
case, the average distortion value is written after the data file is
written.

Accurate measurements require time-alignment and gain-normalization of
the original input sampled data files. *fea_stats*(1-ESPS) and
*copysd*(1-ESPS) are useful for gain normalization. *xwaves*(1-ESPS) is
useful for measuring delay offsets, and *addgen*(1-ESPS) is useful for
resetting start times.

# OPTIONS

The following options are supported:

**-a**  
Specifying this option tells *bs_dist* to send the final average
distortion value to stdout, but do not write an output file.

**-e** *BSD threshold* **\[0.0\]**  
Specifies the value of a threshold to use in the BSD computation. If the
input frames do not both exceed this threshold, the for this time frame
is not included in the overall BSD computation. The specified value must
be \>= 0.0, and the default value is 0.0. The output distortion file
includes values for all frames, however, regardless of the value set for
this threshold.

**-m** *distortion type* **\[BSD\]**  
Specifies the type of distortion measure to compute. The only possible
value at present is Bark Spectral Distortion (BSD).

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
Setting this option makes *bs_dist* produce output to stderr. Normally,
this is used for debugging. By default no output is generated.
Increasing the *debug_level* value increases the quantity of debug
output.

**-A**  
Specifying this option tells *bs_dist* to send the final average
distortion value to stdout, after the output data file is written. In
this case, the *outFile* must not be "-".

**-P** *parameter file* **\[params\]**  
Use the specified *parameter file* rather than the default, which is
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
> continues until one input file is exhausted. *Nan* is read only if the
> **-p** and **-r** options are not used.

*distortion_type - string*  
> Specifies the type of distortion to compute between the two input
> files. The only possible value at present is "BSD". This parameter is
> not read if the **-m** option is specified.

*threshold - float*  
> Specifies the value of a threshold to use in the BSD computation. This
> value must be \>= 0. This parameter is not used if the MBSD is
> computed, or if the **-e** is specified.

*perceptual_weights - float*  
> An array that specifies the weights used in converting input
> Bark-spectral powers to phons. These are in linear
> form---multiplicative factors to be applied to powers; the program
> converts them to logarithmic form (dB) internally. The number of items
> supplied must be at least equal to the smallest of (1) the item
> *num_freqs* from *inFile1*, (2) the item *num_freqs* from
> *inFile2*, (3) the number of freqencies not exceeding 4 kHz. Any
> additional items are ignored.

If this parameter is not obtained from the parameter file, default
values are based on the equation H(z) = (2.6 + z^-1)/(1.6 + z^-1)

in Section IV.B of ref. \[1\].

> There is no command-line option that overrides this parameter.

# ESPS COMMON

The ESPS common file is not used by this program.

# ESPS HEADER

A new file header is created for the FEA output file. The file headers
from the input FEA data files are added as source files in the output
file header, and the command line is added as a comment.

The program writes the usual values into the common part of the output
header. *bs_dist* writes the following values into the specified generic
header items:

    	start = (LONG, size 2) starting points
    	nan = (LONG) number of points analyzed in file
    	distortion_type = (CODED) BSD
    	threshold = (FLOAT) -e specified value

which are added to the output FEA file header.

If the input files are both tagged feature files, then, for each file,
the value of the header item *src_sf* is obtained if present, or *sf* if
*src_sf* is not present. If the value is the same in both files, it is
recorded in a generic header item *src_sf* added to the output header,
and the output file is tagged.

If generic header items *record_freq* are present in both input files
and have the same value, then the value is recorded in a header item
*record_freq* in *outFile*, and a generic header item *start_time* (type
DOUBLE) is also written in the output file. The value of *start_time* is
computed by taking the *start_time* value from the header of *inFile1*
(or zero, if such a header item doesn't exist) and adding to it the
offset time (from the beginning of *inFile1*) of the first record
processed.

A generic header item

    	perceptual_weights = (FLOAT array) weight factors

is added to the output header; this contains the values of the weights
used in converting input Bark-spectral powers to phons. See the
description of the parameter with the same name; the default values are
written if the parameter is not obtained from the parameter file.

# FUTURE CHANGES

None contemplated.

# BUGS

None known.

# WARNINGS

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
lengths. If the **-e** option is used and the two input files do not
have a *tot_power* field, *bs_dist* warns and exists.

If the *spec_type* in either input file is neither DB nor PWR, *bs_dist*
warns and exits.

If the generic header item values of *contin* in the two input files
don't match, or if the values of *freq_format* are not both ARB_FIXED,
the program warns and exits. The lists of frequencies in the two input
headers must be in increasing order. Any frequencies greater than 4 kHz
are dropped from both lists, and the longer is then truncated to the
length of the shorter. If the resulting lists don't match, *bs_dist*
warns and exits.

The program warns and exits if a parameter read from the parameter file
has the wrong data type, or if an array *perceptual_weights* in the
parameter file is too short or contains a non-positive element.

# SEE ALSO

    addgen(1-ESPS), barkspec(1-ESPS), copysd(1-ESPS),
    distort(1-ESPS), fea_stats(1-ESPS), mbs_dist(1-ESPS),
    tofspec(1-ESPS), xwaves(1-ESPS), get_snr(3-ESPS),
    FEA(5-ESPS), FEA_SPEC(5-ESPS)

# REFERENCES

\[1\] S. Wang, A. Sekey, and A. Gersho, \`\`An Objective Measure for
Predicting Subjective Quality of Speech Coders,'' *IEEE Journal On
Selected Areas In Communications*, Vol. 10, no. 5, 819-829 (June 1992).

# BUGS

None known.

# AUTHOR

Manual page by David Burton with revisions by Rodney Johnson.
