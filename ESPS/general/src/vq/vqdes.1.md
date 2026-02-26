# NAME

vqdes - design a vector quantization codebook from a FEA file

# SYNOPSIS

**vqdes** \[ **-x** *debug_level* \] \[ **-P** *param_file* \] \[ **-h**
*histfile* \] \[ **-k** *checkfile* \] \[ **-i** \] *input.fea
output.fea*

# DESCRIPTION

*Vqdes* takes as input a file *input.fea* and obtains a training
sequence of feature vectors, each consisting of a contiguous subset of
elements from a FEA file field of type FLOAT (use *feafunc*(1-ESPS) to
transform types). *Vqdes* designs a vector quantization codebook from
the input training sequence with codebook characteristics determined
from information in the ESPS parameter file (see ESPS PARAMETERS).

If the **-i** option is given, an initial codebook is read from a file
determined by information in the ESPS parameter file.

The final codebook and all converged codebooks of intermediate sizes are
output as records in an ESPS FEA_VQ file *output.fea.* If "-" is
supplied in place of *output.fea,* then standard output is used.

After every pass through the training sequence, the centroid-adjusted
codebook is output to a checkpoint file. Only a single record is kept in
the checkpoint file (it is over-written each time).

If the total memory required to store the feature vectors from
*input.fea* is less than an internal limit of *vqdes,* the codebook
design algorithm will run in memory. Otherwise, *vqdes* will obtain
pieces from *input.fea* as necessary.

For a detailed description of the VQ design algorithm, see *vqdesign*
(3-ESPS).

# OPTIONS

The following options are supported:

**-x** *debug_level \[2\]*  
If *debug_level* is positive, *vqdes* outputs debugging messages and
other information about the codebook design to a history file. The
messages proliferate as *debug_level* increases. Levels up to 6 are
supported currently. For information about what output results from each
value of *debug_level,* see the discussion of the parameter *hdetail* in
*vqdesign* (3-ESPS).

For the default level (2), a summary of the various design parameters is
output to the history file at the beginning of the run. Then, the
following are written each time the codebook has converged at a given
size or after an empty cell has been filled: current date and time,
current codebook size, size of training sequence for current codebook,
total number of clustering iterations so far, average distortion of the
current codebook, and the total number of empty cells found so far.
Also, the average distortion with respect to the current codebook is
output each time the full training sequence is encoded.

**-h** *histfile \[vqdeshist\]*  
Specifies the file to use for history and debugging output.

**-k** *checkfile \[vqdes.chk\]*  
Specifies the name of the checkpoint file written by *vqdes.* .TP **-i**
Specifies that an initial codebook is to be used (otherwise a root
codebook is designed from the training sequence). The filename and
record number for the initial codebook are given respectively by the
parameters *init_file* and *init_rec* in the ESPS parameter file. The
file must be of type FEA_VQ. Whether or not the initial codebook is
clustered before splitting is determined by the parameter *init_behav*
in the ESPS parameter file.

The parameters *conv_ratio* and *dist_type* apply whether or not the
**-i** option is used. If the parameter *cbk_type* is supplied (it's
optional) it must be the same as the codebook type of the initial
codebook.

# ESPS PARAMETERS

The following parameters are read from the parameter or common file:

*string fea_field*

This is the name of the field in *input.fea* that contains the training
vectors. It must be of type FLOAT.

*int fea_dim*

This is the dimension of the feature vectors and also the dimension of
the VQ codewords. *Fea_dim* must be no larger than the size of
*fea_field.* If there are more than *fea_dim* elements in *fea_field,*
only the first *fea_dim* are used from each record.

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

*string cbk_type*

Specifies a codebook type; the values currently supported are "MISC",
"RC_VQCBK", "RC_VCD_VQCBK", "RC_UNVCD_VQCBK", "LSF_VQCBK",
"LSF_VCD_VQCBK", and "LSF_UNVCD_VQCBK" (see \<vq.h\>). Because this
parameter is stored as extra information in the codebook and does not
affect the codebook design, it is optional. The value "MISC" is assumed
if the parameter is missing. (However, if the parameter is present when
the **-i** option is used, then it must match the value in the initial
codebook.)

*string init_file*

Specifies the name of the file containing the initial codebook (only
used with **-i** option).

*int init_rec*

Specifies the record number of the initial codebook in *init_file* (only
used with **-i** option).

*string init_behav*

If this parameter is "INIT_NOCLUSTER", the initial codebook is split
right away. If it is "INIT_CLUSTER", the training sequence is used to
recluster the initial codebook (until convergence) before splitting
(only used with **-i** option).

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

*Vqdes* sets *hd.fea-\>type* to FEA_VQ, and it fills in the other header
fields so as to define FEA records of that type. The command line is
added as a comment, and *input.fea* is added as a source file. If there
is an initial codebook specified, its header is also added as a source.
*Vqdes* also creates and writes the following generic header items:

*design_size*

This is the number of codewords in the codebook.

*codeword_dimen*

This is the dimension of each codeword.

*fea_field*

This is the name of the field in *input.fea* that was used to form the
training sequence.

Note that both *design_size* and *codeword_dimen* are redundant since
the same values are stored in the FEA record itself. However, they are
also written in the header as they do determine the size of the FEA file
records.

# FUTURE CHANGES

Additional values for the parameters *dist_type,* and *cbk_struct* will
be supported. *Vqdes* will be modified so that standard input can be
used in place of *input.fea.*

# SEE ALSO

    vq(1-ESPS), vqdesasc(1-ESPS), vqasc(1-ESPS), vqdesign(3-ESPS), 
    feafunc(1-ESPS), mergefea(1-ESPS), FEA_VQ(5-ESPS), 
    ESPS(5-ESPS), FEA(5-ESPS)

# WARNINGS AND DIAGNOSTICS

*Vqdes* will exit with a diagnostic if any of the following hold:

> An initial codebook is used and its file name is the same as that of
> the checkpoint file (this is for safety).

> It can't read the input ESPS file headers or they are not of the right
> type.

> The named field in the FEA file is not large enough.

> There are insufficient records in the initial codebook file.

> The named field in the FEA file is not of type FLOAT.

> The dimension of the initial codebook doesn't match the dimension of
> vectors in the training sequence.

> An invalid distortion type was specified.

> Not enough memory could be allocated.

> The parameter *cbk_type* doesn't match that of the initial codebook
> when the **-i** option is used.

Warnings are issued if any of the following hold:

> The FEA field size is larger than the specified dimension of training
> vectors.

> The initial codebook type is not the same as that specified.

> The initial codebook does not have a named fea_field that is the same
> as that specified, or it does but it is different.

> Various warnings if characteristics of the initial codebook (**-i**
> option) are inconsistent with the design parameters.

# BUGS

None known.

# REFERENCES

    vqdesign(3-ESPS), vq(1-ESPS), vqdesasc(1-ESPS), 
    vqasc(1-ESPS), pplain(1-ESPS), addfea(1-ESPS).  

# AUTHOR

Manual page by John Shore; program by John Shore.
