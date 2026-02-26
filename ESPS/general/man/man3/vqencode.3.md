# NAME

vqencode - vector quantize a single feature vector using a full-search
codebook

# SYNOPSIS

    long
    vqencode(fea, fea_dim, codebook, cbk_size, cbk_dim, dist_val, distort, dist_err)
    float *fea;		/*feature vector to be encoded*/
    long fea_dim;	/*dimension of feature vector*/
    float **codebook;	/*the full search vq codebook*/
    long cbk_size;	/*number of codewords in codebook*/
    long cbk_dim;	/*dimension of each codeword*/
    double *dist_val;	/*distortion between fea and selected codeword*/
    double (*distort)();	/*routine to compute distortions*/
    int *dist_err;	/*for passing back errors from distort*/

# DESCRIPTION

*vqencode* takes a feature vector *fea* of length *fea_dim* and searches
the full-search vector quantization codebook *codebook* for the closest
codeword. The index of the closest codeword is returned as the function
value. Thus if *ind* is the return value from *vqencode,* then
*codebook*\[*ind*\] is a pointer to the closest codeword. The distortion
value between *fea* and this codeword is returned via the parameter
*dist_val.*

The *codebook* parameter is interpreted as a pointer to a matrix of
floats containing *cbk_size* rows of *cbk_dimen* columns each. Space for
this matrix must be allocated by the calling program - such a pointer
can be assigned by means of *f_mat_alloc* (3-ESPSu). Such codebook
matrices correspond to the *codebook* element of the struct vqcbk (see
*vqdesign* (3-ESPSsp)).

The distortion measure used in searching *codebook* is passed to
*vqencode* as the function pointer *distort.* If *distort* == NULL, a
mean-square-error distortion is used, in which case *vqencode* requires
that *fea_dim* and *cbk_dim* be the same (it exits with an assertion
violation if this is not the case). Otherwise, the indicated function is
called to compute distortions. For the required synopsis of *distort,*
see *vqdesign* (3-ESPSsp). Valid distortion functions include in their
synopsis an error return value, and this value is passed back to the
caller of *vqencode* via the parameter *dist_err.* Thus, if *\*dist_err*
is non-zero after *vqencode* returns, then an error was detected when
*vqencode* called *distort.*

# EXAMPLE

# BUGS

None known.

# SEE ALSO

vqdesign(3-ESPSsp), f_mat_alloc (3-ESPSu), vqdes(1-ESPS), vq(1-ESPS)

# REFERENCES

See *vqdesign* (3-ESPSsp)

# AUTHOR

Manual page and program by John Shore.
