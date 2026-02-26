# NAME

vqdesasc - design a vector quantization codebook from an ASCII training
sequence

# SYNOPSIS

**vqdesasc** \[ **-x** *debug_level* \] \[ **-P** *param_file* \] \[
**-h** *histfile* \] \[ **-k** *checkfile* \] \[ **-l** *max_line_len*
\] \[ **-i** \] \[ **-c** *comment* \] \[ **-C** *comment_file* \]
*input output.fea*

# DESCRIPTION

*Vqdesasc* takes as input an ASCII file *input* containing a training
sequence of feature vectors. The components of each vector are separated
by white space, and the vectors are separated by new-lines. *Vqdesasc*
designs a vector quantization codebook from the input training sequence
with codebook characteristics determined from information in the ESPS
parameter file (see ESPS PARAMETERS). The dimension of the codewords in
the codebook is set to the dimension of the first vector in the input
file *input,* and all input vectors are assumed to be this length.

If the **-i** option is given, an initial codebook is read from a file
determined by information in the ESPS parameter file.

The codebook and all converged codebooks of intermediate sizes are
output as records in an ESPS FEA_VQ file *output.fea.* If "-" is
supplied in place of *output.fea,* then standard output is used.

After every pass through the training sequence, the centroid-adjusted
codebook is output to a checkpoint file. Only a single record is kept in
the checkpoint file (it is over-written each time).

For record-keeping purposes, *vqdesasc* stores an ASCII comment in the
header of *output.fea.* If a comment is not supplied by means of the
**-c** or **-C** options, the user is prompted for one. The comment
should describe the origin of the training sequence.

For a detailed description of the VQ design algorithm, see *vqdesign*
(3-ESPS).

If the total memory required to store the contents of *input* is less
than an internal limit of *vqdesasc,* the codebook design algorithm will
run in memory. Otherwise, *vqdesasc* will obtain pieces from *input* as
necessary.

# OPTIONS

The following options are supported:

**-x** *debug_level \[2\]*  
If *debug_level* is positive, *vqdesasc* outputs debugging messages and
other information about the codebook design to a history file. The
messages proliferate as *debug_level* increases. Levels up to 6 are
supported currently. For For information about what output results from
each value of *debug_level,* see the discussion of the parameter
*hdetail* in *vqdesign* (3-ESPS).

For the default level (2), a summary of the various design parameters is
output to the history file at the beginning of the run. Then, the
following are written each time the codebook has converged at a given
size or after an empty cell has been filled: current date and time,
current codebook size, size of training sequence for current codebook,
total number of clustering iterations so far, average distortion of the
current codebook, total number of empty cells found so far, and codebook
entropy. Also, the average distortion with respect to the current
codebook is output each time the full training sequence is encoded.

**-h** *histfile \[vqdesaschist\]*  
Specifies the file to use for history and debugging output.

**-k** *checkfile \[vqdesasc.chk\]*  
Specifies the name of the checkpoint file written by *vqdesasc.*

**-l** *max_line_len \[500\]*  
Specifies the maximum length of input lines.

**-i**  
Specifies that an initial codebook is to be used (otherwise a root
codebook is designed from the training sequence). The filename and
record number for the initial codebook are given respectively by the
parameters *init_file* and *init_rec* in the ESPS parameter file. The
file must be of type FEA_VQ. Whether or not the initial codebook is
clustered before splitting is determined by the parameter *init_behav*
in the ESPS parameter file.

The parameters *conv_ratio* and *dist_type* apply whether or not the
**-i** option is used.

**-c** *comment*  
Specifies that the ASCII string *comment* be added as a comment in the
header of *output.fea.*

**-C** *comment_file*  
Specifies that the contents of the file *comment_file* be added as a
comment in the header of *output.fea.*

# ESPS PARAMETERS

The following parameters are read from the parameter or common file (see
also the description of the **-i** option):

*double conv_ratio*

Each clustering iteration of the codebook design algorithm is repeated
until the fractional decrease in the overall average distortion between
successive iterations falls below *conv_ratio.* A reasonable initial
value is .05

*int vq_size*

Specifies the size of the desired VQ codebook.

*string dist_type*

Specifies the type of distortion measure to use. Currently supported
values are "MSE" (mean-square-error) and "MSE_LAR" (mean-square-error on
log area ratios, which assumes that the input vectors are reflection
coefficients).

*string cbk_struct*

Specifies the search-structure of the desired codebook. "FULL_SEARCH" is
the only value supported at this time.

*string init_file*

Specifies the name of the file containing the initial codebook (see
**-i**).

*int init_rec*

Specifies the record number of the initial codebook in *init_file* (see
**-i**).

*string init_behav*

If this parameter is "INIT_NOCLUSTER", the initial codebook is split
right away. If it is "INIT_CLUSTER", the training sequence is used to
recluster the initial codebook (until convergence) before splitting.
(See **-i**).

*int max_iter* Specifies the maximum number of iterations per level. If
this parameter is not present, a default value of 500 is used.

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

# ESPS COMMON

ESPS Common is read if *filename* in Common matches *input.* No values
are written to ESPS Common.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

*Vqdesasc* sets *hd.fea-\>type* to FEA_VQ, and it fills in the other
header fields so as to define FEA records of that type. The command line
is added as a comment. It there is an initial codebook specified, its
header is added as a source. *Vqdesasc* also writes the following
generic header items:

*design_size*

This is the number of codewords in the codebook.

*codeword_dimen*

This is the dimension of each codeword.

Note that both of these generic header items are redundant since the
same values are stored in the FEA record itself. However, they are also
written in the header as they do determine the size of the FEA file
records.

# FUTURE CHANGES

Additional values for the parameters *dist_type,* and *cbk_struct* will
be supported. *Vqdesasc* will be modified so that standard input can be
used in place of *input.*

# SEE ALSO

vqasc(1-ESPS), vq(1-ESPS), vqdes(1-ESPS), vqdesign(3-ESPS),
FEA_VQ(5-ESPS), ESPS(5-ESPS), FEA(5-ESPS)

# WARNINGS AND DIAGNOSTICS

*Vqdesasc* will exit with appropriate messages if any of the following
hold:

> An initial codebook is used and its file name is the same as that of
> the checkpoint file (this is for safety).

> There is no data in the input file.

> The feature vectors in *input* do not all have the same dimension or
> their dimension is less than 2.

> Sufficient memory could not be allocated.

> It can't read the ESPS header of the initial codebook file, or the
> file is not of type FEA_VQ, or there are insufficient records in the
> file.

> The dimension of the initial codebook doesn't match that of the
> training sequence.

> An invalid distortion type is specified.

*Vqdesasc* performs various consistency checks on the initial codebook.

# BUGS

None known.

# REFERENCES

    vqdesign(3-ESPS), vqasc(1-ESPS), vqdes(1-ESPS), 
    vq(1-ESPS), pplain(1-ESPS), addfea(1-ESPS).  

# AUTHOR

Manual page by John Shore; program by John Shore.
