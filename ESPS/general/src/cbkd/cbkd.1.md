# NAME

cbkd - Find distances between codewords in vector quantizer codebooks.

# SYNOPSIS

**cbkd** \[ **-P** *param* \]\[ **-r** *range* \]\[ **-t** *table_field*
\]\[ **-x** *debug_level* \] *cbk_in* *cbk_out*

# DESCRIPTION

*Cbkd* reads a vector quantizer codebook, finds the distances between
the codewords, and forms a table of the distances. This allows quick
computation of distances when processing quantized data.

Codebooks are read from the FEA_VQ (5-ESPS) file *cbk_in*, and the
euclidean distances between the codewords are found and are written to
the FEA_VQ file *cbk_out*. For each codebook in the specified input file
records, an array **table**, of size **current_size x current_size** is
formed, where **current_size** is the number of words in the codebook.
Element **table\[i\]\[j\]** is the distance between codewords **i** and
**j**. The specified records of the input file are copied to the output
file and the distance data is stored in the **design_size** x
**design_size** dimensional field *table_field*. By default, codebooks
are read from all records in *cbk_in* and the corresponding distance
tables are written to the same records in *cbk_out* (see the **-r**
option).

# OPTIONS

The following options are supported:

**-P** *param*  
Uses the parameter file *param*, rather than the default, which is
*params*.

**-r** *first***:"last"**  
**-r** *first-last*  
**-r** *first***:+***incr*  
In the first two forms, a pair of unsigned integers specifies the range
of records from *cbk_in* to process. If *last* = *first* + *nan*, the
last form specifies the same range as the first. If *first* is omitted,
the default value 1 is used. If *last* is omitted, the default is to
process all records from *start* to the last in the file. This option
overides the values of *start* and *nan* in the parameter file.

**-t** *table_field*  
Name of the field in the FEA_VQ file *cbk_out* which will contain the
codeword distance table. By default, this field name is
"distance_table".

**-x** *debug_level*  
A positive value causes debugging output to be printed on the standard
error output. Larger values give more output. The default is 0, for no
output.

# ESPS PARAMETERS

The parameter file is not required to be present; there are default
values which will apply. If the parameter file does exist, the following
parameters are read:

*start - integer*  
The first record in the input FEA_VQ file for which the codebook
distances are computed and written to the FEA_VQ output file. This
parameter is not used if the **-r** option is used. If *start* is not
specified and **-r** is not used, the default is to begin processing at
the first record in the input file.

*nan - integer*  
The number of records from the input FEA_VQ file to process. This
parameter is not used if the **-r** option is used. If *nan* is not
specified and **-r** is not used, the default is to process all records
of *cbk_in* from *start* to the last record in the file.

*table_field - string*  
Name of the field in the FEA_VQ file *cbk_out* which will contain the
codeword distance table. See the **-t** option; this paramter is not
read if the **-t** option is used.

*debug_level - int*  
A positive value causes debugging output to be printed on the standard
error output. Larger values give more output. The default is 0, for no
output. This parameter is not read if the **-t** option is used.

# ESPS COMMON

ESPS Common is not read or written.

# ESPS HEADER

*Cbkd* copies the FEA_VQ file header of *cbk_in* as the header of
*cbk_out*. The input line is added as a comment and *cbk_in* is added as
a source.

The contents of the FEA_VQ records of *cbk_in* are copied to *cbk_out*
and the field *distance_table* is created; *distance_table* contains the
distances between codewords and is a two dimension field of data type
DOUBLE and contains **design_size x design_size** elements.

# SEE ALSO

    vq(1-ESPS), vqdes(1-ESPS), vqdesign(3-ESPS), dtw(1-ESPS), 
    dtw_rec(1-ESPS), dtw(3-ESPS), d_mat_alloc(3-ESPS), 
    FEA_VQ (5-ESPS)

# BUGS

None known.

# AUTHOR

Program and manual pages by Bill Byrne.
