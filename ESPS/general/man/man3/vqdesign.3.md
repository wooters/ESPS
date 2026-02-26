# NAME

vqdesign - design full-search vector quantization codebook

# SYNOPSIS

    #include <esps/vq.h>
    #include <stdio.h>
    int
    vqdesign	(histrm, hdetail, data, len, dim, cbk, enc, init, split_crit, 
    	get_chunk, vec_to_cdwd, distort, split, checkpoint, max_iter)
    FILE 		*histrm;
    int 		hdetail;
    float		**data;
    long		len;
    long		dim;
    struct		vqcbk *cbk;
    int 		init;
    long		*enc;
    int 		split_crit;
    long		(*get_chunk)();
    int 		(*vec_to_cdwd)();
    double		(*distort)();
    int		(*split)();
    int		(*checkpoint)();
    int		max_iter;

# GENERAL DESCRIPTION

*vqdesign* is a fairly-general routine that uses the Linde-Buzo-Gray
(LBG) (generalized Lloyd) algorithm to design a full-search vector
quantization codebooks based on a training sequence of feature vectors.
*vqdesign* can be used whether or not the training data fits entirely in
memory. Provided that certain conditions are satisfied, *vqdesign* can
be used with arbitrary distortion measures and arbitrary
codebook-splitting algorithms.

The main assumption that restricts the application of *vqdesign*
concerns the computation of a cluster centroid. It is assumed that a
cluster centroid is a function (vec_to_cdwd) of the feature vector that
results from averaging, component by component, all of the feature
vectors in the cluster. This assumption holds for a large class of
distortion measures, including mean-square error, weighted mean-square
error, and Itakura-Saito. It holds for the class of minimum
relative-entropy distortion measures discussed in \[1\], of which the
Itakura-Saito is a special case.

The training data is passed to *vqdesign* through the parameter *data,*
which points to *len* feature vectors of dimension *dim.* The array
*data* may or may not contain the entire set of training data. If it
does not (for example, when the training data does not fit in memory),
*vqdesign* uses the function *get_chunk* to update *data* whenever a
chunk of training data is needed. If *get_chunk* is NULL, then *data* is
assumed to contain the entire training sequence.

The codebook designed by *vqdesign* is passed back to the calling
program through the parameter *cbk.* If the codebook passed through
*cbk* is not empty when *vqdesign* is called, then this codebook is used
as an initial codebook by *vqdesign.* In this case, the input codebook
may or may not be re-clustered before splitting, depending on the value
of *init* (see below).

The parameter *enc* is used by *vqdesign* to pass back the indices of
the closest codeword corresponding to the feature vectors passed via
*data.* If *data* holds the full training sequence, then , after
*vqdesign* returns, enc\[i\] is the index of the final codeword closest
to data\[i\]; that is, cbk-\>codeword\[enc\[i\]\] is the closest
codeword to data\[i\]. Actually, *enc* is used throughout the design
process to hold the indices of the closest codewords to the feature
vectors in *data.* Thus, provided that the pointer enc passed to
*vqdesign* is in the scope of *get_chunk,* the current contents of *enc*
could be copied elsewhere whenever *get_chunk* is called. This may be
useful when *data* does not hold the full training sequence, i.e., if
*get_chunk* is used to step through the training sequence.

Besides *get_chunk,* several other function pointers are passed to
*vqdesign,* namely *vec_to_cdwd,* *distort,* *split,* and *checkpoint.*

The function *vec_to_cdwd* transforms a feature vector into a codeword;
if it is NULL, then no transformation is necessary.

The function *distort* computes a distortion measure between a feature
vector and a codeword; if it is NULL a mean-square-error distortion
function is used by default.

The function *split* is used to split a codeword whenever an additional
codeword is needed, either because an empty cell has been found or
because the codebook is being enlarged. Which codeword to split is
determined by *split_crit.* The *split* function performs the actual
splitting operation. If *split* is NULL, a "generic split" routine is
used by default. This generic routine splits each codeword by adding or
subtracting a random amount from each codeword element. The amount is
uniformly distributed over 1% of the particular codeword element, and
the algorithm is used both to compute a new codeword from an existing as
well as to modify the existing one.

The function *checkpoint* is called by *vqdesign* periodically to allow
the current codebook to be written to a checkpoint file. It is called
after each adjustment of the cluster centroids (i.e., after each pass
through the training sequence); it is also called before the current
codebook is to be enlarged (i.e., after the design has converged at a
given size).

The parameter *max_iter* specifies the maximum number of iterations for
clustering at any given level.

*vqdesign* writes history and debugging information to the stream
*histrm.* The amount of information written to *histrm* increases as the
value of *hdetail* increases from 0. If *hdetail* is zero, only fatal
error messages are written. No information is written if *histrm* is
NULL.

*vqdesign* returns one of the following integer status values, which are
defined in \<esps/vq.h\>:


    	0	normal exit, codebook designed OK;
    	VQ_NOCONVG	convergence failed
    	VQ_GC_ERR	error in get_chunk
    	VQ_VECWD_ERR	error in vec_to_cdwd
    	VQ_DIST_ERR	error in distort
    	VQ_SPLIT_ERR	error in split
    	VQ_INPUT_ERR	inconsistency or other problem with input parameters;

The function parameters vec_to_cdwd, split, and checkpoint should really
be of type void. Type int is used owing to compiler bugs on certain
machines.

For more information, see the section "DETAILED DESCRIPTION".

# PARAMETERS

*histrm, hdetail*  
*Histrm* points to an output stream used by *vqdesign* to write out
history and debugging information. The amount of information written to
*histrm* increases as the value of *hdetail* increases from 0, as
described in the following (information written when hdetail == n
includes all information written when hdetail \< n):

hdetail == NULL

No information is written.

hdetail == 0

Only fatal error messages are written.

hdetail == 1

Each time the codebook has converged at a given current size or after
empty cells have been filled, the following are written: current date
and time, current codebook size, size of training sequence for current
codebook, total number of clustering iterations so far, average
distortion of the current codebook, the total number of empty cells
found so far, and the entropy of the current codebook (probability of
each cluster computed as proportional to the cluster size).

hdetail == 2

Each time the full training sequence is encoded with respect to the
current codebook, the average distortion is written. Whenever empty
cells are found, the identities of the empty cell and the cell split to
replace the empty cell are written.

hdetail == 3 Each time the information for hdetail == 1 is written, so
are the following: the size of each cluster in the last pass over the
training sequence, the average distortion of each cluster, and the
current set of codewords (transformed cluster centroids). The current
set of codewords is also written each time the codebook is enlarged.
Whenever an empty cell has been discarded (and another cell split), the
foregoing information is also written.

hdetail == 4

The information described for hdetail == 1 and hdetail == 3 is written
again after each cluster iteration, i.e., each time the training
sequence has been encoded and the codebook adjusted.

hdetail == 5

The number of training vectors resulting from each call to *get_chunk*
is written.

hdetail == 6

Each time a feature vector is encoded with respect to the current
codebook, the following are written out: the feature vector, the index
of the closest codeword, and the distortion with respect to that
codeword.

*data, len, dim*  
*vqdesign* interprets *data* as a pointer to a *len-*row by *dim-*column
matrix of floats. Space for this matrix must be allocated by the calling
program - such a pointer can be assigned by means of *f_mat_alloc*
(3-ESPSu). With this interpretation, the pointers
data\[0\]...data\[len-1\] each points to a "row" containing a feature
vector of dimension *dim.* Thus, data\[i\]\[j\] is the jth element of
the ith feature vector.

*cbk*  
This parameter is a pointer to a codebook structure of type *vqcbk,*
which is defined in \<esps/vq.h\>. The following structure definition
contains the subset of the definition in \<esps/vq.h\> that is relevant
to *vqdesign:*

<!-- -->


    struct vqcbk {
    double *conv_ratio;	/*fractional distortion convergence threshold*/
    double *final_dist;	/*average distortion of current codebook*/
    float **codebook;	/*codeword matrix; codeword[j] points to jth codeword*/
    float *clusterdist;	/*distortion of the cluster corresponding 
    				    to each codeword*/
    long *clustersize;	/*size of the cluster corresponding to each codeword*/
    long *train_length;	/*length of training sequence used*/
    long *design_size;	/*design goal for number of codewords*/
    long *current_size;	/*current number of codewords in codebook*/
    long *dimen;	/*dimension of codewords*/
    long *num_iter;	/*total number of cluster iterations*/
    short *cbk_type; 	/*codebook type, e.g, RC_VQCBK;
    				  see vq_cbk_types[] in <esps/header.h>*/
    short *dist_type;	/*distortion type, e.g, MSE; see
    				  dist_types[] in <esps/header.h>*/ 
    short *cbk_struct;	/*codebook structure, e.g., FULL_SEARCH;
    				  see cbk_structs[] in <esps/header.h>*/
    };

*cbk-\>codebook* is interpreted as a pointer to a matrix of floats
containing *cbk-\>design_size* rows of *cbk-\>dimen* columns each. Prior
to calling *vqdesign,* the calling program must set the values of
*\*cbk-\>design_size,* *\*cbk-\>current_size,* *\*cbk-\>dimen,*
*cbk-\>codebook,* and *\*cbk-\>conv_ratio.* It should also set
*\*cbk-\>dist_type,* although this does not affect the operation of
*vqdesign.* As in the case of *data,* the pointer *cbk-\>codebook* can
be assigned by means of *f_mat_alloc* (3-ESPSu). In most cases, the
value of *cbk-\>dimen* will be the same as that of the *vqdesign*
parameter *dim* (dimension of feature vectors), but that is not
necessary provided that the functions *vec_to_cdwd* and *distort* are
defined appropriately.

> If *\*cbk-\>current_size* is not zero, this number of rows from
> *cbk-\>codebook* are considered to define an initial codebook.

> Before *vqdesign* returns, it sets the values of
> *\*cbk-\>train_length, \*cbk-\>current_size, \*cbk-\>final_dist,* and
> *\*cbk-\>num_iter.* ( *\*cbk-\>num_iter* is the total number of
> clustering iterations since the start of the codebook design.)
> *vqdesign* fills the first *\*cbk-\>current_size* rows of
> *cbk-\>codebook* with the codewords resulting from the design
> algorithm. (Usually, *\*cbk-\>current_size = \*cbk-\>design_size* when
> *vqdesign* terminates.) Also, the values of cbk-\>clustersize\[j\] and
> cbk-\>clusterdist\[j\] are set to the size and average distortion of
> the final cluster corresponding to cbk-\>codebook\[j\] (this codeword
> is the transformed centroid of the cluster).

> The value *\*cbk-\>cbk_struct* is set to FULL_SEARCH by *vqdesign.*
> The values of *\*cbk-\>dist_type* and *\*cbk-\>cbk_type* are not
> changed by *vqdesign.*

*enc*  
This is a pointer to *len* long values that are used by *vqdesign* to
pass back the index of the closest codeword to the corresponding feature
vector in data\[i\]. For more information, see "GENERAL DESCRIPTION".

*init*  
This parameter determines whether or not an initial codebook is
clustered before being split, according to the following values which
are defined in \<esps/vq.h\>:

<!-- -->


    	INIT_CLUSTER	cluster initial codebook before splitting
    	INIT_NOCLUSTER	do not cluster initial codebook before splitting

The value of *init* is ignored if *vqdesign* is called with
cbk-\>current_size == 0.

*split_crit*  
Whenever a codeword must be split, either to enlarge the codebook or to
replace an empty cell, *split_crit* determines which codeword is split.
It has the following possible values, which are defined in
\<esps/vq.h\>:

<!-- -->


    	SPLIT_POP	split cluster with largest population
    	SPLIT_DIST	split cluster with largest average distortion

If more than one codeword is to be split the criterion is applied
repeatedly.

*get_chunk*  
This is a pointer to a function that updates *data* with the next
"chunk" of training data. Such functions must have the following
synopsis:

<!-- -->


    long
    get_chunk(data, len, dim, num_prev, error)
    float **data;
    long len;
    long dim;
    long num_prev;
    int *error;

As in *vqdesign,* *data* is interpreted as a pointer to a *len-*row by
*dim-*column matrix of floats. *Get_chunk* fills *data* with up to *len*
new feature vectors of dimension *dim.* *Get_chunk* must return the
number of new feature vectors that are in *data,* and it must return the
value 0 when the training-sequence is exhausted. If *get_chunk* is
called with num_prev == 0, it must start (perhaps again) from the
beginning of the training sequence. When *get_chunk* is called from
*vqdesign,* the parameter *num_prev* will always be set equal to the
total number of vectors from the training sequence that have been
supplied by previous calls to *get_chunk* ever since it was called with
num_prev == 0. *Get_chunk* returns, in error, a return status that
should be set to values other than 0 whenever an error is detected. For
normal returns, \*error == 0. *vqdesign* sets error == 0 before calling
*get_chunk.*

*vec_to_cdwd*  
This is a pointer to a function that transforms a feature vector into a
codeword. For many applications, no such transformation is needed - a
feature vector (e.g., the centroid of a cluster of feature vectors) can
be used as a codeword without transformation. In such cases,
*vec_to_cdwd* is set to NULL and the transformation is bypassed. In
other applications, a transformation is needed - for example, in some
applications of vector quantization to speech coding, the feature vector
components are autocorrelations while the codeword components are filter
coefficients, so a transformation is needed. If it is supplied, the
function *vec_to_cdwd* must have the following synopsis:

<!-- -->


    int
    vec_to_cdwd(fea_vector, vec_dim, codeword, cdwd_dim, error)
    float *fea_vector;
    long vec_dim;
    float *codeword;
    long cdwd_dim;
    int *error;

The feature vector to be transformed is passed to *vec_to_cdwd* via the
parameter *fea_vector,* and the resulting codeword is passed back via
*codeword.* The dimensions of *fea_vector* and *codeword* are given
respectively by *vec_dim* and *cdwd_dim.* *Vec_to_cdwd* returns, in
error, a return status that should be set to values other than 0
whenever an error is detected. For normal returns, error == 0.
*vqdesign* sets error == 0 before calling *vec_to_cdwd.*

> If get_chunk == NULL, then *data* is assumed to hold the entire
> training sequence.

*distort*  
This is a pointer to a function that computes a distortion measure
between a feature vector and a codeword. Such functions must have the
following synopsis:

<!-- -->


    double
    distort(fea_vector, vec_dim, codeword, cdwd_dim, error)
    float *fea_vector;
    long vec_dim;
    float *codeword;
    long cdwd_dim;
    int *error;

*Distort* computes the distortion between the feature vector
*fea_vector* and the codeword *codeword.* The resulting distortion value
is the function's return value. The dimensions of *fea_vector* and
*codeword* are given respectively by *vec_dim* and *cdwd_dim.* *Distort*
also returns, in error, a return status that should be set to values
other than 0 whenever an error is detected. For normal returns, error ==
0. *vqdesign* sets error == 0 before calling *distort.*

> If distort == NULL, then a mean-square-error distortion function is
> used, but this requires that *dim* and *cbk-\>dimen* be the same.

*split*  
This is a pointer to a function that splits a codeword. Such functions
must have the following synopsis:

<!-- -->


    int
    split(cdwd_dest, cdwd_src, cdwd_size)
    float	*cdwd_dest;	
    float	cdwd_src;	
    long	cdwd_size;

*Cdwd_src* points to *cdwd_size* floats containing a codeword that is to
be split, and *cdwd_dest* points to *cdwd_size* floats in which *split*
writes the new codeword. *Split* may also modify the source codeword
*cdwd_src.*

> If split ==NULL, a generic split routine is used; this generic routine
> modifies both *cdwd_dest* and *cdwd_src.* For details about the
> generic split algorithm, see "GENERAL DESCRIPTION".

*checkpoint*  
This is a pointer to a function that can be used to write the current
codebook out to a checkpoint file or to calculate and output some
intermediate information. (At least that's the motivation; in principle,
*checkpoint* can do anything with or to the current codebook.) It must
have the following synopsis:

<!-- -->


    int
    checkpoint(cdbk, chk_type)
    struct vqcbk *cdbk;
    int chk_type;

*Cdbk* is a pointer to the current codebook. Note that unpredictable
things will happen if *checkpoint* modifies the current codebook.

> *Chk_type* is set by *vqdesign* to indicate at which design stage the
> call to *checkpoint* is being made. If chk_type == CHK_ENCODE, then
> the call to *checkpoint* occured after the codewords were adjusted
> following a pass through the training sequence. If chk_type == SPLIT,
> the call to *checkpoint* occured after the codebook converged at a
> given size and before it is enlarged by means of a call to *split.*
> (There are many more calls with chk_type == CHK_ENCODE than with
> chk_type == CHK_SPLIT.) For an example, see the source for *vqdes*
> (1-ESPS), where a *checkpoint* routine does nothing when chk_type ==
> CHK_ENCODE and writes out the current codebook to a checkpoint file
> when chk_type == CHK_SPLIT.

> If checkpoint == NULL, then no checkpoint-related action is taken.

*max_iter*  
This parameter determines the maximum number of iterations allowed at
any one clustering level. If the number is exceeded, a message is
written to the history output and *vqdesign* exist with return value
VQ_NOCONVG.

# DETAILED DESCRIPTION

If *vqdesign* is called with cbk-\>current_size !=0, it interprets the
first cbk-\>current_size rows of cbk-\>codebook to be an initial
codebook. Alternatively, if *vqdesign* is called with cbk-\>current_size
== 0, it designs a rate 0 initial codebook by finding the centroid of
the entire training sequence. It does this by averaging each component
of the feature vectors in the training sequence and then transforming
the resulting vector to a codeword by means of *vec_to_cdwd.*

As mentioned earlier, *vqdesign* interprets *data* as a pointer to a
*len-*row by *dim-*column matrix of floats, and each row of *data* is
one feature vector from the training sequence. If get_chunk == NULL,
*vqdesign* assumes that there are only *len* feature vectors in the
training sequence, and that they are all stored in *data.* Otherwise,
*vqdesign* uses the function *get_chunk* to step through the training
sequence. In this case (get_chunk != NULL), vqdesign does not assume
that any of the training sequence is stored in *data* when *vqdesign* is
called. (It does, however, assume that the space for data was allocated
properly in the calling program.)

If *vqdesign* is called with an initial codebook (cbk-\>current_size !=
0), and if init == INIT_CLUSTER, *vqdesign* will "cluster" the initial
codebook before proceeding. This works as follows: The entire training
sequence is encoded with respect to the codebook; this determines a set
of codeword clusters (a codeword cluster comprises all of the feature
vectors that are closest to a particular codeword), and it determines
the average distortion of all cluster members with respect to the
corresponding codeword. (The function *distort* is used to compute the
distortion between a feature vector and a codeword.) Next, the centroid
of each codeword cluster is computed by averaging the feature vectors in
the cluster, and the function *vec_to_cdwd* is used to replace each
codeword with the corresponding feature-vector centroid. This process is
repeated iteratively until the fractional decrease in the overall
average distortion between successive iterations falls below
*cbk-\>conv_ratio* (successful convergence - see below), or until
*max_iter* iterations have been tried, in which case *vqdesign* exits.

If convergence was successful but an empty cluster remains, the empty
cluster is discarded and then filled by splitting a codeword selected by
the criterion determined by *split_crit* and using the *split* function
on this codeword. Note that the new codeword will be created with a
codeword index immediately following the codeword that is split. The
codebook is then reclustered until convergence is reached again. This
process continues until no empty cells remain. If the number distinct
vectors in the training sequence is less than the desired number of
codewords, this process could loop forever. However, it will terminate
when the limit *max_iter* is reached.

If convergence was successful and no empty cells remain, *vqdesign*
enlarges the codebook by selecting codewords according to *split_crit*
and using the *split* function on these codewords. *vqdesign* continues
to select and split codewords like this until the codebook has been
exhausted, in which case it has doubled in size, or the design size is
reached.

The enlarged codebook is then clustered as described above, and the the
split-cluster process iterates until the codebook size reaches
*cbk-\>design_size.*

If any of the functions *get_chunk, distort, vec_to_cdwd,* or *split*
report a non-zero error status, *vqdesign* writes a suitable message on
*histrm* (provided histrm != NULL) and returns with an appropriate
status value (see the list, above).

If the codebook does not converge during any of the clustering steps,
*vqdesign* writes appropriate information on *histrm* and returns with
the value VQ_NOCONVG.

# ASSUMPTIONS

It is assumed that a cluster centroid can be obtained by applying
*vec_to_cdwd* to the feature vector that results from averaging,
component by component, all of the feature vectors in the cluster. This
assumption holds for a large class of distortion measures, including
mean-square error, weighted mean-square error, and Itakura-Saito. It
holds for the class of minimum relative-entropy distortion measures
discussed in \[1\], of which the Itakura-Saito is a special case.

# FUTURE CHANGES

# BUGS

None known.

# SEE ALSO

vqencode(3-ESPSsp), f_mat_alloc (3-ESPSu), vqdes(1-ESPS), vq(1-ESPS)

# REFERENCES

\[1\] J. E. Shore and R. M. Gray, "Minimum cross-entropy pattern
classification and cluster analysis," IEEE Trans. Pattern Analysis and
Machine Intelligence PAMI-4, January, 1982, pp. 11-17.

\[2\] Y. Linde, A. Buzo, and R. M. Gray, "An algorithm for vector
quantizer design," IEEE Trans. on Communications COM-28, January, 1980,
pp. 84-95.

\[3\] R. M. Gray, "Vector quantization," IEEE ASSP Magazine, April,
1984, pp. 4-29.

\[4\] J. Makhoul, S. Roucos, and H. Gish, "Vector quantization in speech
coding," Proceedings IEEE 73, November, 1985, pp. 1551-1588.

# AUTHOR

Manual page and program by John Shore.
