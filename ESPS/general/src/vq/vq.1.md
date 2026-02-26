# NAME

vq - vector quantize a field in FEA records

# SYNOPSIS

**vq** \[ **-x** *debug_level* \] \[ **-h** *histfile* \] \[ **-f**
*fieldname* \] \[ **-c** *record* \] \[ **-i** \] *cbk.fea fea.in
fea.out*

# DESCRIPTION

*Vq* reads the ESPS FEA_VQ file *cbk.fea* to obtain a vector
quantization codebook. *Vq* then reads an file *fea.in,* encodes a
particular field from each FEA record, and then outputs the encoded
fields to *fea.out.* *Fea.out* also contains the rest of the information
from *fea.in,* i.e., the contents of the two files are identical except
for the quantized field within each record.

If "-" is supplied in place of *fea.in,* then standard input is used. If
"-" is supplied in place of *fea.out,* then standard output is used.

*Vq* determines which distortion measure to use from the information
stored in the FEA_VQ file. In many cases, *vq* will be used with
codebooks designed using *vqdes* (1-ESPS), although this is not
required. If there are field to be quantized in *input.ana* is larger
than the dimension of the codewords in *cbk.fea,* the extra elements are
set to zero in the output file.

The field to quantize (specified by the **-f** option) must be of type
FLOAT. Note that *feafunc* can be used to transform the data type of
fields.

# OPTIONS

The following options are supported:

**-x** *debug_level*  
If *debug_level \[0\]* is positive, *vq* outputs debugging messages and
other information about the codebook design to a history file. The
messages proliferate as *debug_level* increases. For level 0, there is
no output. For level 1, the size of the input sequence, the average
distortion, the standard deviation of the distortion, and the maximum
distortion are output. For level 2, the codebook itself is also output.
For level 3, information is output for every input vector, namely the
index of the closest codeword, the distortion with respect to the
closest codeword, and the cumulative average distortion. For level 4,
the output also includes the input vectors and the output vectors.

**-h** *histfile \[vqhist\]*  
Specifies the file to use for history and debugging output.

**-f** *fieldname \[spec_param\]*  
Specifies the name of the field to be quantized in each *fea.in record.*

**-c** *record*  
Specifies an integer record number within *cbk.fea* to use as the
codebook. If the **-c** option is not used, then the last record in
*cbk.fea* is used as the codebook.

**-i**  
Specifies that only the codword index and not the quantized field
*fieldname* be written to *fea.out*.

# ESPS PARAMETERS

The ESPS parameter file is not read.

# ESPS COMMON

No values are written to ESPS Common.

# ESPS HEADERS

*Vq* reads the usual information from the *fea.in* header. The header
for *fea.out* is created using *copy_header(3-ESPS),* with the usual
record-keeping fields filled in. A field is added which contains the
codeword index associated with the quantized value of *fieldname*. The
name of this field is obtained by appending the suffix *\_cwndx* to the
name of the quantized field, e.g. the default field name is
*spec_param_cwndx*. This field is a single integer of data type LONG. If
the **-i** option is specified, the field *fieldname* is not included in
the file *fea.out*.

The generic header item *start_time* is written in the output file. The
value written is computed by taking the *start_time* value from the
header of the input file (or zero, if such a header item doesn't exist)
and adding to it the relative time from the first record in the file to
the first record processed. This relative time is computed using the
generic *record_freq* from the input file. If *record_freq* doesn't
exist in the input file, *start_time* is copied from the input file to
the output file.

If it exists in the input file header, the generic header item
*record_freq* is copied to the output file header. This item gives the
number of records per second of original data analyzed.

The generic header item *quantized* is set to YES in the output file.

Both *cbk.fea* and *fea.in* are added to the output header as sources.

*Vq* creates and writes the following generic header items (names
incremented using *uniq_name* (3-ESPS) if they exist already):

*quantized_field*

This is the name of the quantized field (from **-f** option).

*cbk_current_size*

The size of the quantization codebook.

*cbk_dimen*

The dimension of codewords in the quantization codebook.

*cbk_dist_type*

The type of distortion used in designing the codebook and in quantizing
*fea.in.*

*cbk_cbk_struct*

The structure of the quantization codebook.

*cbk_cbk_type*

The type of the quantization codebook.

*cbk_final_dist*

The final distortion of the training sequence that was used in the
original design of the quantization codebook.

*encode_distortion*

The average distortion resulting from encoding *fea.in.* This is left as
-1 if the output is standard output.

# FUTURE CHANGES

# SEE ALSO

    vqdes(1-ESPS), vqdesasc(1-ESPS), vqasc(1-ESPS), 
    vqdesign(3-ESPS), feafunc(1-ESPS), mergefea (1-ESPS),
    FEA_VQ(5-ESPS), FEA(5-ESPS), ESPS(5-ESPS)

# WARNINGS AND DIAGNOSTICS

Vq will exit with a diagnostic if any of the following hold:

> It can't read the input ESPS file headers or they are not of the right
> type.

> *Fieldname* is not a valid record field in *fea.in*.

> The field *fieldname* in *fea.in* is not of type FLOAT.

> The field *fieldname* in *fea.in* is smaller than the size of the VQ
> codewords.

> There are insufficient records in *cbk.fea*.

Warnings will be issued if any of the following hold:

> The field *fieldname* in *fea.in* is larger than the size of the VQ
> codewords.

> The field *fieldname* in *fea.in* has a different name than the
> contants generic header item *fea_field* in *cbk.fea*, if that generic
> header item exists.

> The generic header item *quantized* is YES in *fea.in* (i.e., if any
> quantization has occured already on the input file).

# BUGS

None known.

# REFERENCES

See *vqdesign* (3-ESPS).

# AUTHOR

Manual page by John Shore; program by John Shore. Codeword index field
added by Bill Byrne.
