# NAME

addclass - add a FEA_VQ codebook record to a FEA_VQ codebook file

# SYNOPSIS

**addclass** \[ **-x** *debug_level* \] \[ **-p** *field_rep* \] \[
**-f** *field* \] \[ **-r** *record_num* \] \[ **-s** *source_name* \]
\[ **-t** *source_type* \] \[ **-n** *signal_name* \] *infile.cbk*
*outfile.cbk*

# DESCRIPTION

*Addclass* adds the **-r** specified codebook record from *infile.cbk*
to *outfile.cbk*. Note both *infile.cbk* and *outfile.cbk* are FEA_VQ
files. If the output codebook file doesn't exist, *addclass* creates it.
If it does exist, in the process of updating it, *addclass* creates a
temporary file is created in the directory specified by the environment
variable ESPS_TEMP_PATH (default /usr/tmp). *Addclass* also fills in
five fields in the output codebook record: *field_rep, field,*
source_name, source_type, and *signal_name*. Any previous contents of
these fields is lost.

*Field* contains the name of the field in the FEA file that was used as
source data to design the codebook. *Field_rep* is the *field*'s
representation. For example, the *spec_param* field in FEA_ANA files has
the following possible *field_rep* representations: AUTO, AFC, LSF, CEP,
RC, and LAR. *Source_name* contains the name of the source for the data.
For speaker or speech recognition, this is the name of the speaker.
*Source_type* contains a category descriptor of the source. For example
in speaker identification, *source_type* could be either male or female.
*Signal_name* describes the type of signal that the source produced. In
speaker identification, for example, this is the identity of the word
that was spoken by the unknown speaker. Note that all of these
parameters may take on a value of *NONE*, and this is the default value.

*Addclass* also checks for equality among all the codebooks for the
following parameters: *codeword_dimen, cbk_struct, field,* and
*field_rep.* If each of these fields is not the same in all codebooks,
then processing is stopped and an error message is printed.

If *infile1.fea* is set equal to "-", standard input is used for the
input file.

# OPTIONS

**-x** *debug_level* **\[0\]**  
Values greater than 0 cause messages to print to *stderr*.

**-p** *field_rep* **\[NONE\]**  
A *field*'s representation may be specified by using this option.

**-f** *field* **\[NONE\]**  
Specifies the field in the codebook's input data file that the codebook
represents.

**-r** *record_num*  
Specifies an integer record number within *infile.cbk* to copy to the
output file. If no **-r** value is specified, the last record in the
input codebook is copied.

**-s** *source_name* **\[NONE\]**  
Specifies the source of the data that was used to design the codebook.

**-t** *source_type* **\[NONE\]**  
Specifies the source's category.

**-n** *signal_name* **\[NONE\]**  
Specifies the type of signal that the source produced.

# ESPS PARAMETERS

The PARAMS file is not processed.

# ESPS COMMON

The Common file is not processed.

# ESPS HEADERS

*Infile.cbk* is added to the output header as a source.

See FEA_VQ(5-ESPS) for a description of the standard header items.

# FUTURE CHANGES

# WARNINGS

*Addclass* warns and exits if the input and output file type is not
correct.

# SEE ALSO

vqdes(1-ESPS), vq(1-ESPS), FEA_DST(5-ESPS), FEA_VQ(5-ESPS),
vqclassify(1-ESPS), vqdst(1-ESPS)

# BUGS

None known.

# AUTHOR

Manual page by David Burton. Program by Alan Parker.
