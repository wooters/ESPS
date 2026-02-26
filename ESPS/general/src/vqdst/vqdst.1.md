# NAME

vqdst - encode a field in a FEA file in a VQ codebook file.

# SYNOPSIS

**vqdst** \[ **-x** *debug_level* \] \[ **-P** *params_file* \] \[
**-d** *distortion* \] \[ **-f** *field* \] \[ **-n** *rep_number* \] \[
**-s** \] \[ **-t** \] \[ **-c** \] \[ **-q** \] *infile1.fea*
*infile2.cbk* *outfile.dst*

# DESCRIPTION

*Vqdst* encodes the **-f** specified field from every record of
*infile1.fea* in every codebook record of the FEA_VQ codebook
*infile2.cbk* and writes the resulting distortion and identification
information to *outfile.dst* (a FEA_DST(5-ESPS) file). If *outfile.dst*
already exists, *vqdst* appends one new record to it for each codebook
record in *infile2.cbk*; otherwise, *vqdst* creates *outfile.dst* and
writes one record to it for each codebook record in the input codebook
file. The **-d** option is used to specify the type of distortion
measure to use in the encoding, and the **-c**, **-s**, and **-t**
options allow the user to enforce certain consistencies between the two
input files.

More specifically, the **-s** option forces the *input_source* field in
the input FEA file header to be identical to the *source_name* fields in
the input *FEA_VQ*(5-ESPS) file's records. If they are different,
*vqdst* warns and exits. Similarly, the **-t** option forces the
*input_signal* field in the input FEA file and the *signal_name* field
in the input FEA_VQ file to be identical. Finally, the **-c** option
forces the *field* and *quant_field* (and if the input file is a
*FEA_ANA*(5-ESPS) file, the *field_rep* fields) in the two input files
to be identical.

The field to encode in the codebooks must be of type FLOAT. Note that
*feafunc*(1-ESPS) can be used to transform the data type of fields.

If *infile1.fea* is set equal to "-", standard input is used for the
input FEA file. If *outfile.dst* is equal to "-", standard output is
used.

# OPTIONS

**-x** *debug_level* **\[0\]**  
Values greater than 0 cause messages to print to *stderr*.

**-P** *params_file*  
The name of a parameter file may be specified here. The default name is
*params*.

**-d** *distortion***\[MSE\]**  
At this time only one distortion method is supported: mean square error
(MSE).

**-f** *field*  
Specify the field in *input.fea* to encode.

**-n** *rep_number \[-1\]*  
Specify the repetition number for input files with identical values in
the *input_source* and *input_signal* fields.

**-c**  
If this option is set, a difference in the *field* or *field_rep* fields
in the two input files is a fatal error.

**-s**  
If this option is set, a difference in the *source_name* or
*input_source* field values in the two input files is a fatal error.

**-t**  
If this option is set, a difference in the *signal_name* or
*input_signal* field values in the two input files is a fatal error.

**-q**  
This option must be specified to append to an existing FEA_DST file. By
using this option, the header information of the current input file is
lost - *vqdst* simply appends records to the existing file. No header
information is copied over.

# ESPS PARAMETERS

The strings values for *distortion* and *field* can be obtained from the
parameter file. Remember that any command line value over rides the
parameter file value.

The values of parameters obtained from the parameter file are printed if
the environment variable ESPS_VERBOSE is 3 or greater. The default value
is 3.

# ESPS COMMON

If only two files are specified on the command line, *vqdst* checks
Common for a file name. If one exists, it uses it as the *infile1.fea*.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is

the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

Both *infile1.fea* and *infile2.cbk* are added to the output header as
sources.

See FEA_DST(5-ESPS) for a description of the standard header items.

# FUTURE CHANGES

If *vqdst* output is to be used for speaker verification, the input FEA
file needs to have the following two generic header items filled in:
*input_source* (character) and *input_signal* (character). These values
are copied by *vqdst* to the output FEA_DST(5-ESPS) file, and the values
are used by *thresh* and *spkver*. These two programs are not part of
the standard distribution, but may be made so at some time in the
future.

Itakura Saito (IS), gain-normalized Itakura Saito (GNIS), and
gain-optimized Itakura Saito (GOIS) will be added. The IS, GNIS, and
GOIS distortion measures are valid only for fields that contain spectral
parameters. See \[1\] for a description of the IS, GNIS, and GOIS
distortion measures.

# WARNINGS

*Vqdst* warns and exits if the input file types are not correct, the
named *field* is not in *input1.fea*, or the number of elements in the
input *field* does not equal the number of elements in *infile2.cbk*
codebook records. If a field containing spectral information does not
contain a valid spectral type (see *spec_reps* table in *anafea.h* for
valid types) and either IS, GNIS, or GOIS is specified as the distortion
measure, *vqdst* warns and exits.

# SEE ALSO

    refcof(1-ESPS), FEA_DST(5-ESPS), addclass(1-ESPS), 
    vq(1-ESPS), vqdes(1-ESPS), FEA_VQ(5-ESPS)

# BUGS

None known.

# REFERENCES

\[1\] R. M. Gray *et al.*, "Distortion Measures for Speech Processing,"
*IEEE Trans. Acoust., Speech, Signal Processing*, vol. ASSP-28,
pp.367-376, Aug, 1980

# AUTHOR

Manual page and code by David Burton.
