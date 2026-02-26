# NAME

    dtw_l2 - Dynamic time warp distance computation between sequences.
    dtw_tl - Dynamic time warping distance computation using table lookup.

# SYNOPSIS

double\
dtw_l2(test, ref, N, M, dim, delta, bsofar, mapping, dist_fn)\
float \*\*test, \*\*ref;\
double \*bsofar;\
long N, M, dim, delta, \*mapping;\
double (\*dist_fn)();\
extern int debug_level;\

double\
dtw_tl(test, ref, N, M, dim, delta, bsofar, mapping, dist_tbl)\
long \*test, \*ref, N, M, delta, dim, \*mapping;\
double \*\*dist_tbl;\
double \*bsofar;\
extern int debug_level;

# DESRIPTION

The functions *dtw_l2* and *dtw_tl* find a distance between two
sequences *test* and *ref* using a dynamic time warping algorithm as
described in \[1\] and \[2\]. *Dtw_l2* compares two sequences based on
the euclidean distance between vectors in the sequences. *Dtw_tl*
compares two sequences of positive integers, where the distance between
integers in the sequences is found from a table of distances,
*dist_tbl*. One intended application of these functions is discrete word
recognition. *Dtw_l2* can find the distance between the acoustic feature
representations of two utterances. *Dtw_tl* can find the distance
between the vector quantized acoustic feature representations of two
utterances. In this case, *ref* and *test* are code book labels, and
*dist_tbl* is a table of distances between codebook centroids.

The sequence *test* should have length *N* and *ref* should be length
*M*. In *dtw_l2*, the parameter *dim* is the dimension of vectors in the
sequences *ref* and *test*, i.e. *test*\[m\]\[j\] and *ref*\[n\]\[j\]
must be valid floating point values for 0\<=j\<*dim*, 0\<=m\<*M*, and
0\<=n\<*N*. In *dtw_tl*, *test*\[m\], *ref*\[n\], and
*dist_tbl*\[j\]\[k\] must be valid for 0\<=m\<*M*, 0\<=n\<*N*, and
0\<=j,k\<*dim*.

The functions find a distance **DT** which corresponds to

**DT** = **D**(ref(**w**(0)),test(0)) + ... +
**D**(ref(**w**(N-1)),test(N-1))

where **w(n)** is the mapping from \[0,N-1\] to \[0,M-1\] such that this
sum is minimized, subject to the constraints below. In *dtw_l2*, the
distance, **D**, between vectors in the sequence is found using
*dist_fn*; if *dist_fn* is a NULL pointer, the euclidean distance is
used. The synopsis of *dist_fn* is

double\
dist_fn( vec1, vec2, dim)\
float \*vec1, \*vec2;\
long dim;

and the function should return the distance between the the two vectors.
In *dtw_tl*, the distance between integers in the sequence is found from
the table *dist_tbl*, i.e. if i and j are elements in the sequences the
distance between them is *dist_tbl*\[i\]\[j\].

The constraints which **w** must satisfy are:

    0<=w(0) <= delta
    M-1-delta <= w(N-1) <= M-1
    w(n+1) - w(n) = 0, 1, 2   ( w(n) <> w(n-1) )
    w(n+1) - w(n) = 1, 2       ( w(n) = w(n-1) )

If *delta*=0, the mapping is forced to compare the initial and final
points of *test* and *ref* to each other. Errors in detecting the
endpoints of sequences can be acounted for by allowing *delta* to be
larger than 0.

The distance **DT** is found using dynamic programing; the mapping **w**
is not computed explicitly. However, **w** is often of interest for time
alignment, etc. If the parameter *mapping* is a NULL pointer, the
functions do not compute **w**. However, if *mapping* is not null, the
functions perform backtracking to find **w** which is then returned in
*mapping*, i.e. *mapping*\[i\] = **w**(i) 0\<=i\<*N*. If it is not null,
*mapping* should point to a block of memory of size *N* **x
sizeof(long)**.

The parameter *bsofar* is used when comparing a test sequence to more
than one reference sequence. If *bsofar* is not NULL, the value
**bestsofar** is set to *\*bsofar*. The functions then check to make
sure that **DT** is less than **bestsofar** at all intermediate points
of computation. If **DT** exceeds **bestsofar**, the dynamic programming
search halts and the functions return the value **bestsofar**.
Backtracking is not performed. If **DT** is less than *bestsofar*, the
functions return **DT** and *\*bsofar* is set to **DT**. This can be
used to find efficiently which of several reference sequences is closest
to a particular test sequence.

A positive value of *debug_level* causes debugging output to be printed
on the standard error output. Larger values give more output. The
default is 0, for no output.

The functions check that *N*, *M*, and *delta* form a valid comparison
region, i.e. for a given set of these values there is a mapping **w**
which obeys the constraints. If there is no comparison region, the
functions return **best_so_far**, if it was passed as a parameter, or
DBL_MAX (see the ESPS include file "limits.h") if it was not; if
*debug_level* \> 0, the functions echo a message to standard error.

# SEE ALSO

    dtw(1-ESPS), vq(1-ESPS), cbkd(1-ESPS), 
    f_mat_alloc(3-ESPS), d_mat_alloc(3-ESPS), 
    f_mat_free(3-ESPS), d_mat_free(3-ESPS)

# BUGS

None known.

# FUTURE CHANGES

Other distance measures.

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
