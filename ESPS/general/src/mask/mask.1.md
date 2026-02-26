# NAME

    mask - masks/fades out or mixes segments of sampled data file

# SYNOPSIS

**mask** \[ **-f** *mask_field* \]\[ **-s** *subfile* \]\[ **-x**
*debug_level* \] *maskfile* *infile* *outfile*

# DESCRIPTION

*Mask* is useful for fading or masking out selected segments of an
utterance. Both the input and output files, *infile* and *outfile* are
FEA_SD files of SHORT data type. The file *maskfile* is a FEA file with
the field *mask_field* that contains a masker to fade or mask out
segments in *infile*. Data in *outfile* is a result of the masker
multiplied with the data in *infile*. The file *subfile* is an optional
FEA_SD file of SHORT data type with sampling frequency the same as
*infile*. If *subfile* is specified, the "masker" signal should be
bounded in the range of 0 and 1, since it will be used to fade between
the infile and subfile. Each sampled data point in *outfile* is the sum
of the masker multiplied with the data point in *infile* and (1 -
masker) multiplied with the data point in *subfile*.

*Mask* is particularly useful for gating out the unvoiced segments of an
utterance or to substitute unvoiced regions from one version of an
utterance into another utterance. Use *get_f0(1-ESPS)* to obtain voicing
estimate in the *prob_voice* field of its output file as decisions to
mask out the unvoiced regions in *infile*.

If the record frequency in *infile* is larger than that in *maskfile*,
the masker in *maskfile* is interpolated linearly.

If the starting times, as indicated by the generic header item
*start_time*, and ending times are different for *maskfile* and
*infile*, *outfile* starts with the later starting time and ends with
the earlier ending time. The substitution signal in *subfile* must start
no later than the the later staring time of *infile* and *maskfile*, and
end no earlier than the earlier ending time of these files.

# OPTIONS

The following options are supported:

**-f** *mask_field \[***prob_voice"\]"**  
The field name in the input FEA file *maskfile* that contains masker
signal for masking/fading data segments in *infile* or mixing segments
in *infile* and *subfile*. The default name is *"prob_voice"* as the
field name for probablity of voicing for file produced by *get_f0
(1-ESPS)*. This field is a scalar field of FLOAT data type. If the
**-s** option is used, this field should be bounded between 0 and 1;
otherwise, a warning message is sent to *stderr*, and an undefined
result is produced.

**-s** *subfile*  
The file name of a FEA_SD file which will be mixed with that of *infile*
in the proportion to the masker specified by the *mask_field* field in
*maskfile*.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *mask* prints debugging messages and other
information on the standard error output. The messages proliferate as
the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

No ESPS parameter processing is supported

# ESPS COMMON

No ESPS common processing is supported

# ESPS HEADERS

*Mask* writes the usual generic header items *record_freq* and
*start_time* in the output file header.

# FUTURE CHANGES

# EXAMPLES

# ERRORS AND DIAGNOSTICS

# BUGS

None known.

# REFERENCES

# SEE ALSO

mergefea(1-ESPS)

# AUTHORS

David Talkin, Derek Lin
