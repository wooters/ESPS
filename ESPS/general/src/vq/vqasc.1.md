# NAME

vqasc - vector quantize ASCII vectors with a codebook from a FEA file

# SYNOPSIS

**vqasc** \[ **-l** *max_line_len* \] \[ **-x** *debug_level* \] \[
**-h** *histfile* \] \[ **-c** *record* \] *cbk.fea data.in data.out*

# DESCRIPTION

*Vqasc* reads the ESPS FEA_VQ file *cbk.fea* to obtain a vector
quantization codebook. *Vqasc* then reads an ASCII file *data.in*
containing vectors, it encodes each vector using the codebook, and it
outputs to *data.out* each resulting quantized vector. The components of
each input vector are separated by white space, and the vectors are
separated by new-lines. If "-" is supplied in place of *data.in,* then
standard input is used. If "-" is supplied in place of *data.out,* then
standard output is used.

*Vqasc* determines which distortion measure to use from the information
stored in the FEA file. In many cases, *vqasc* will be used with
codebooks designed using *vqdesasc*(1-ESPS), although this is not
required. It is a requirement that the dimensions of the input vectors
all be the same as the dimension of the codewords in the codebook.

# OPTIONS

The following options are supported:

**-l** *max_line_len \[500\]*  
Specifies the maximum length of input lines.

**-x** *debug_level*  
If *debug_level \[0\]* is positive, *vqasc* outputs debugging messages
and other information about the codebook design to a history file. The
messages proliferate as *debug_level* increases. For level 0, there is
no output. For level 1, the size of the input sequence, the average
distortion, the standard deviation of the distortion, and the maximum
distortion are output. For level 2, the codebook itself is also output.
For level 3, information is output for every input vector, namely the
index of the closest codeword, the distortion with respect to the
closest codeword, and the cumulative average distortion. For level 4,
the output also includes the input vectors and the output vectors.

**-h** *histfile \[vqaschist\]*  
Specifies the file to use for history and debugging output.

**-c** *record*  
Specifies an integer record number within *cbk.fea* to use as the
codebook. If the **-c** option is not used, then the last record in
*cbk.fea* is used as the codebook.

# ESPS PARAMETERS

The ESPS parameter file is not read.

# ESPS COMMON

No values are written to ESPS Common.

# ESPS HEADERS

*Vqasc* reads the usual information from the FEA file header. No headers
are written.

# FUTURE CHANGES

# SEE ALSO

    vqdesasc(1-ESPS), vqdes(1-ESPS), vq(1-ESPS),
    vqdesign(3-ESPS), FEA_VQ(5-ESPS), FEA(5-ESPS), 
    ESPS(5-ESPS)

# WARNINGS AND DIAGNOSTICS

*Vqasc* will exit with appropriate messages if the feature vectors in
*input* do not all have the same dimension, or if this dimension is not
equal to the dimension of the codewords in the codebook.

# BUGS

None known.

# REFERENCES

See *vqdesign* (3-ESPS).

# AUTHOR

Manual page by John Shore; program by John Shore.
