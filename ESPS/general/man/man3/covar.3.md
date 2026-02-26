# NAME

covar - compute reflection coefficients using covariance method.

# SYNOPSIS

covar (x, lnt, c, order, rc, pgain, window_flag)\
float x\[\], c\[\], rc\[\], \*pgain;\
int order, lnt, window_flag;

# DESCRIPTION

This routine computes the generalized reflection coefficients and the
lpc filter coefficients for the given data using covariance method.

The covar function takes data of size **lnt** in array **x\[\]** as
input and computes **order** generalized reflection coefficients,
**rc\[1\]** to **rc\[order\],** **order** lpc filter coefficients,
**c\[1\]** to **c\[order\],** and lpc filter gain, **\*pgain.**

If the parameter **window_flag** is 0, a rectangular window is applied
to sample data vectors in the computation of the sample covariance
matrix. If **window_flag is non-zero, a triangular window is applied.**

For a more general approach (which also serves as a cover function for
*covar*), see *compute_rc* (3-ESPS).

# BUGS

None

# SEE ALSO

*compute_rc* (3-ESPS)

# REFERENCES

\[1\] L. R. Rabiner and R. W. Shaffer, *Digital Processing of speech
signals,* Prentice-Hall, NJ, 1978.

# AUTHOR

Shankar Narayan
