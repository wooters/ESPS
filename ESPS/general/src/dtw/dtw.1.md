# NAME

dtw - Dynamic time warping comparison of two sequences.

# SYNOPSIS

**dtw** \[ **-P** *param* \] \[ **-f** *sequence_field* \]\[ **-b**
*best_so_far* \]\[ **-d** *delta* \]\[ **-c** *distance_table_file* \]\[
**-t** *distance_table_field* \]\[ **-r** *distance_table_recno* \]\[
**-x** *debug_level* \] *reference.fea* *test.fea* *results.fea*

# DESCRIPTION

The program dtw reads a test and a reference sequence from two FEA
(5-ESPS) files and uses dynamic time warping to find a distance between
them. A constrained reordering of the reference sequence is performed to
find the smallest distance between the sequences. This distance is found
using the functions dtw_l2(3-ESPS) or dtw_tl(3-ESPS) and the numerical
result (a positive number) is echoed to standard output.

The sequences are read from the field sequence_field from both test.fea
and reference.fea. The elements in the sequences can be positive integer
codeword indicess or vectors of real numbers. By default, dtw assumes
that sequence_field is a vector of real numbers of data type FLOAT. The
routine dtw_l2 (3-ESPS) is used to find the time warping distance based
on the euclidean distance between the vectors in the sequences. In this
case, sequence_field must have the same dimension in each file.

When the -c option is specified, dtw assumes that sequence_field is a
one dimensional field of data type LONG. This field is read from both
files to form sequences of positive integers. The field
distance_table_field is read from record distance_table_recno of the
FEA_VQ (5-ESPS) file distance_table_file to obtain a table of distances
between elements in the sequence. The dynamic time warping distance
between the sequences is based on distances between integers in the
sequences as found from the distance table. An intended application of
this is the comparison of vector quantized sequences obtained by vq
(1-ESPS). The program cbkd (1-ESPS) can be used to generate
distance_table_file from the codebook used by vq.

The file results.fea is optional. If it is specified, dtw creates a
tagged FEA file of that name and fills it with information about the
dynamic time warping comparison. This information is found by
backtracking after the dynamic programing comparison is complete, so dtw
finishes quicker if results.fea is not created.

If backtracking information is to be written to results.fea, the best
alignment of the reference sequence with the test sequence is found from
information stored during the dynamic programming distance computation.
The records of reference.fea are copied to results.fea in the order
specified by this alignment, and the field mapping in the output record
points back to the source reference record. A new field, dtw_distance,
of data type DOUBLE is added which contains the distance from the vector
sequence_field in the current vector to the vector sequence_field in the
corresponding record of test.fea.

The option best_so_far is used when comparing test.fea to many reference
files. If intermediate values of the dynamic time warping distance
exceed best_so_far during computation, the dynamic programmming
comparision halts. Dtw then echos best_so_far to standard out, and the
file results.fea is not created.

The parameter delta allows the time warping comparison to begin
elsewhere than the initial points in each sequence and end at points
other than the last in the sequences (see the function dtw (3-ESPS) for
a complete description). If delta=0 (default), the time warping
comparison forces the endpoints to be aligned. By allowing delta to be
non-zero, it is possible to account for errors in the detection of the
end points of sequences.

Not all sequences of arbitrary lengths can be compared (see dtw (3-ESPS)
and \[2\]). If the record lengths of test.fea and reference.fea are such
that dynamic time warping cannot be performed, dtw echos to standard out
the value best_so_far, if it is provided, or DBL_MAX (see the include
file \<esps/limits.h\>), if it is not. If debug_level is greater than 0,
a warning is also issued.

The files test.fea and reference.fea must be specified, and standard
input is not allowed. Dtw will write the backtracking information to
standard output if "-" is used for results.fea.

# OPTIONS

The following options are supported:

**-P** *param*  
Uses the parameter file param, rather than the default, which is params.

**-f** *sequence_field*  
Name of field in test.fea and reference.fea from which test and
reference sequences are read. If -c option is specified, the field must
contain a single integer of type LONG; the default field name is
spec_param_cwndx and the dynamic time warping comparison is performed by
dtw_tl (3-ESPS). If -c is not specified, the field must be of data type
FLOAT and have the same dimension in each file; the default field name
is spec_param and the dynamic time warping comparison is performed by
dtw_l2 (3-ESPS).

**-b** *best_so_far*  
If set, dtw monitors the dynamic programing distance comparison to see
if the distance exceeds this value during computation. If it does, the
comparison stops, and dtw returns this value.

**-d** *delta*  
If set, the comparison algorithm may ignore the first and last delta
vectors in the reference sequence when finding the closest distance to
the test sequence. For a full explanation, see dtw (3-ESPS).

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
If the -t option is specified, the table of distances is read from field
distance_table_field in record distance_recno of file
distance_table_file. The default name of the file read is
"distance_table".

**-r** *distance_table_recno*  
If the -c option is specified, the table of distances is read from field
distance_table_field in record distance_table_recno of file
distance_table_file. By default, the last record of distance_table_file
is read.

**-x** *debug_level*  
A positive value causes debugging output to be printed on the standard
error output. Larger values give more output. The default is 0, for no
output.

# ESPS PARAMETERS

The parameter file is not required to be present; there are default
values which will apply. If the parameter file does exist, the following
parameters are read:

*sequence_field*  
> Name of field from which test and reference sequences are read; see
> the description of the -f option. This parameter is not read if the -f
> option is used.

*best_so_far*  
> Specifies a threshold value for the dynamic time warping distance. See
> the description of the -b option. This parameter is not read if the -b
> option is used.

*delta*  
> Allows the comparison algorithm to ignore the first and last delta
> points of the reference sequence in finding the closest distance to
> the test sequence. See the description of the -d option. This
> parameter is not read if the -d option is used.

*distance_table_file*  
Name of FEA_VQ file from which distance table is read to perform dynamic
time warping comparison between sequences of indices. This parameter is
not read if the -c option is used. If this parameter is used, dtw acts
as if the file name was obtained with the -c option; see the -c option
description.

*distance_table_field*  
If either the c option or the distance_table_file parameter is used, the
distance table is read from the field distance_table_field. This
parameter is not read if the -t option is used.

*distance_table_recno*  
If either the -c option or the distance_table_file parameter is used,
the distance table is read from record distance_table_recno of the
specified file. This parameter is not read if the -r option is used.

*debug_level*  
> A positive value causes debugging output to be printed on the standard
> error output. Larger values give more output. This parameter is not
> read if the -x option is used.

# ESPS COMMON

ESPS Common is not read or written.

# ESPS HEADER

If results.fea is specified, the FEA file header of reference.fea is
used as its header. The headers of reference.fea and test.fea are added
as source file headers, and the input line is added as a comment.

Dtw writes the following values into the specified generic header items
in the output FEA file:


    dtw_best_so_far = best_so_far
    dtw_delta = delta
    dtw_result 
    dtw_sequence_field = sequence_field
    dtw_distance_file = distance_table_file
    dtw_distance_field = distance_table_field
    dtw_distance_recno = distance_table_recno

The fields dtw_sequence_field and dtw_distance_file, dtw_distance_field,
are data type STRING, dtw_delta, mapping, and dtw_distance_recno are
data type LONG, and dtw_best_so_far is data type DOUBLE, as is
dtw_result, which contains the numerical result of the dynamic time
warping comparison. The fields dtw_distance_file, dtw_distance_field and
dtw_distance_recno are added only if the -c option or the
distance_table_file parameter is used.

# SEE ALSO

    cbkd(1-ESPS), vq(1-ESPS), dtw_l2(3-ESPS), dtw_tl(3-ESPS), 
    FEA(5-ESPS), FEA_VQ(5-ESPS)

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
