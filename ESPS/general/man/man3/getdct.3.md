# NAME

get_dct - Compute the forward or inverse discrete cosine transform of a
data sequence.

# SYNOPSIS

get_dct ( data_in, data_out, size )\
float data_in\[\], data_out\[\];\
int size;

# DESCRIPTION

This routine computes the forward or inverse discrete cosine transform
of a sequence of data, using matrix multiplication. The input data are
supplied through the array **data_in.** The transform size is specified
by **size.** Positive and negative values are used to indicate the
forward and inverse operations, respectively. The output data are
returned in the array **data_out.**

The maximum transform size is 256. If the size is 0, or is greater than
256, no operations are performed and the routine aborts with an
assertion failure. If the size is 1, **data_in\[0\]** is copied to
**data_out\[0\].**

# BUGS

None known.

# SEE ALSO

    get_fft(3-ESPSsp).

# COMMENTS

This routine is intended for use with transform sizes which are not
powers of 2. In cases where the transform size is a power of 2, the well
known approach based on the double-size discrete Fourier transform is
far more efficient.

Because matrix multiplication is used, the computational time may be
quite significant for large transforms.

# FUTURE CHANGES

None anticipated.

# REFERENCES

\[1\] Elliott, D. F., and Rao, K. R., *FAST TRANSFORMS: Algorithms,
Analyses, Applications,* Academic Press, Inc., Orlando, FL, 1982, p.
387.

# AUTHOR

Jim Elliott
