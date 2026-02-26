# NAME

dtw_rec - Dynamic time warping sequence recognition system.

# SYNOPSIS

**dtw_rec** \[ **-P** *param* \] \[ **-f** *sequence_field* \] \[ **-d**
*delta* \] \[ **-l** *best_list_length* \] \[ **-b** \]\[ **-c**
*distance_table_file* \]\[ **-t** *distance_table_field* \]\[ **-r**
*distance_table_recno* \] \[ **-x** *debug_level* \] *reference_list*
*test_list* *results*

# DESCRIPTION

Dtw_rec compares test sequences to reference sequences using a dynamic
time warping algorithm (see dtw (3-ESPS)). Comparisons can be made
between sequences of floating point vectors or sequences of codeword
indices.

Dtw_rec reads a list of FEA file names from the the ASCII file
reference_list. Sequences are read from these files to form a database
of reference sequences. Dtw_rec then reads the ASCII file test which
contains names of FEA files which contain test sequences. A test
sequence is read from each of these files and compared to every
reference sequence. For each test sequence, the identity of the closest
reference sequence is written to the ASCII file results. Dtw attempts to
read the CHAR generic header item sequence_id from the FEA files named
in reference_list and test_list to identify each of the sequences. If
this field is not present, the sequences are identified by the name of
the file from which they were read. The tasks performed by dtw_rec can
also be done using dtw within a shell script, but dtw_rec avoids
repeatedly opening and closing reference files.

The ASCII file results contains entries for each test sequence. Each
entry contains the identity of a test sequence, the identity of a
reference sequence, and the distance between the two found by the time
warping algorithm. The parameter best_list_length is the number of
entries for each test sequence. For the default value of 1, results
contains a single entry for each test sequence, which identifies the
closest reference utterance to the test sequence and gives the DTW
distance between the two sequences. If best_list_length is specified,
this information is written for the best_list_length closest reference
sequences to each test sequence.

The parameter delta specifies the range of points in the reference
sequence which may be aligned with the initial and final points of the
test sequence. For delta = 0 (default), the algorithm forces the initial
and final points of the test and reference sequences to be aligned.

The files reference_list, test_list, and results must be provided. For
results, "-" can be used to specify that results be written to standard
output, but standard input cannot be used for the other files.

USAGE EXAMPLE\
The following shell script contains an example of using dtw_rec for a
vector quantizer recognition task. The directory ref_data contains FEA
reference files, each of which contains a reference sequence in the
field re_spec_val, which has dimension 512. The test sequences are in
FEA files in the directory test_data. These sequences must also be in
the field re_spec_val.

    #!/bin/csh
    # Create the vector quantizer codebook
    foreach ref (`ls ref_data/*`)
    	copysps -f $ref vq.in
    end
    echo "string fea_field = "re_spec_val";" > vq.params
    echo "int fea_dim = 512; >> vq.params
    echo "double conv_ratio =  0.05;" >> vq.params
    echo "string dist_type = "MSE";" >> vq.params
    echo "int vq_size = 256;" >> vq.params
    vqdes -P vq.params vq.in vq.cbk
    # Create file of distances between codewords
    cbkd vq.cbk distance.fea_vq
    # Quantize test and reference FEA files
    foreach sequence (`ls ref_data/* test_data/*`)
    	vq -i -f spec_param vq.cbk $sequence $sequence.vq
    end
    # Create the ASCII file of reference FEA file names
    ls ref_data/*.vq > r_list
    # Create the ASCII file of test FEA file names
    ls test_data/*.vq > t_list
    # Compare all test sequences to the reference sequences 
    # and write recognition results to the file results.
    dtw_rec -c distance.fea_vq -f re_spec_val_cwndx r_list t_list results

# OPTIONS

The following options are supported:

**-P** *param*  
Uses the parameter file param, rather than the default, which is params.

**-f** *sequence_field*  
Name of the FEA field from which test and reference sequences are read.
If -c option is specified, the field must contain a single integer of
type LONG; the default field name is then spec_param_cwndx and the
routine dtw_tl (3-ESPS) is used. If -c is not specified, the field must
be data type FLOAT and have the same number of elements in each file;
the default field name is then spec_param and the routine dtw_l2
(3-ESPS) is used.

**-c** *distance_table_file*  
The FEA_VQ file distance_table_file should contain a two dimensional,
square, field distance_table_field of data type DOUBLE. This field is
read from record distance_recno to form a dim x dim array of distances,
where the value dim is taken from the FEA_VQ defined item current_size
in the same record. The dimension dim is used to check the labels read
from the field sequence_field. If the labels fall outside the range
\[0,dim-1\], dtw warns and exits. The file distance_table_file can be
created from a FEA_VQ codebook file using cbkd (1-ESPS).

**-t** *distance_table_field*  
If the -c option is specified, the table of distances is read from field
distance_table_field in record distance_recno of file
distance_table_file. The default name of the file read is
"distance_table".

**-r** *distance_table_recno*  
If the -c option is specified, the table of distances is read from field
distance_table_field in record distance_table_recno of file
distance_table_file. By default, the last record of distance_table_file
is read.

**-b** **  
If set, dtw_rec keeps track of the least distance between each test
sequence and all the reference sequences. If this distance is exceeded
during the comparison of a test and reference sequence, the comparison
halts, and comparison to the next reference sequence begins. This can
speed computation.

**-d** *delta*  
If set, the comparison algorithm may ignore the first and last delta
vectors in the reference sequence when finding the closest distance to
the test sequence. For a full explanation, see dtw (3-ESPS). The default
is 0, which requires that the endpoints be compared to each other.

**-l** *best_list_length*  
Number of entries in results for each test sequence. The default is 1.
By default, only the identity of the closest reference sequence and the
corresponding distance is written to results for each test sequence. If
the -l option is used, this information is written to results for the
best_list_length closest reference sequences. The -b and -l options
cannot be used simultaneously.

**-x** *debug_level*  
A positive value causes debugging output to be printed on the standard
error output. Larger values give more output. The default is 0, for no
output.

# ESPS PARAMETERS

The parameter file is not required to be present; there are default
values which will apply. If the parameter file does exist, the following
parameters are read:

*sequence_field*  
> Name of field from which test and reference sequences are read. This
> parameter is not read if the -f option is used.

*distance_table_file*  
> Name of FEA_VQ file from which distance table is read to perform
> dynamic time warping comparison between sequences of indices. This
> parameter is not read if the -c option is used. If this parameter is
> used, dtw_rec acts as if the file name was obtained with the -c
> option; see the -c option description.

*distance_table_field*  
> If either the c option or the distance_table_file parameter is used,
> the distance table is read from the field distance_table_field. This
> parameter is not read if the -t option is used.

*distance_table_recno*  
> If either the -c option or the distance_table_file parameter is used,
> the distance table is read from record distance_table_recno of the
> specified file. This parameter is not read if the -r option is used.

*best_so_far*  
> If set to 1, this dtw_rec behaves as if the -b option is used. This
> parameter is not read if the -b option is used.

*delta*  
> Allows the comparison algorithm to ignore the first and last delta
> points in the reference sequence in finding the closest distance to
> the test sequence. See the description of the -d option. This
> parameter is not read if the -d option is used.

*best_list_length*  
> Number of entries in results for each test sequence. See the
> description of the -l option. This parameter is not read if the -l
> option is used.

*debug_level*  
> A positive value causes debugging output to be printed on the standard
> error output. Larger values give more output. This parameter is not
> read if the -x option is used.

# ESPS COMMON

ESPS Common is not read or written.

# ESPS HEADER

The file results is an ASCII file and has no ESPS header.

# SEE ALSO

dtw (1-ESPS), vq (1-ESPS) dtw_l2 (3-ESPS), dtw_tl (3-ESPS), FEA
(5-ESPS), FEA_VQ (5-ESPS)

# COMMENTS

Dtw_rec uses the routine free_header (3-ESPS) when reading reference and
test sequences. This avoids consuming and not freeing memory when
reading FEA headers using the routine eopen (3-ESPS). There are
instances when free_header should not be used, e.g. eopen reads an
SD(5-ESPS) file and returns an FEA_SD(5-ESPS) header. This should not be
a problem here.

# BUGS

None known.

# FUTURE CHANGES

# REFERENCES

\[1\] L.R. Rabiner, A.E. Rosenberg, S.E. Levinson "Considerations in
Dynamic Time Warping Algorithms for Discrete Word Recognition," I.E.E.E.
Transactions on Acoustics, Speech, and Signal Processing, Vol. 26, No.
6, December 1978, pp 575-582

\[2\] S.E. Levinson, "Structural Methods in Automatic Speech
Recognition," Proceedings of the I.E.E.E., Vol. 73, No. 11, November
1985, pp 1625-1650

# AUTHOR

Program and manual pages by Bill Byrne.
