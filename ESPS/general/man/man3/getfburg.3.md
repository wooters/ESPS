# NAME

get_fburg - Compute reflection coefficients using fast modified Burg
method.

# SYNOPSIS

     
    get_fburg (x, lnt, c, order, rc, pgain)
    float *x;
    int   lnt;
    float *c;
    int   order;
    float *rc;
    float *pgain;

# DESCRIPTION

This function computes the reflection coefficients and the lpc filter
coefficients directly from sampled data. The algorithm is a faster
version of the modified Burg method used in *get_burg*(3-ESPSsp);
relative to that function, *get_fburg* provides computational savings on
the order of 50 to 70 per cent.

Unlike the standard Burg algorithm, where reflection coefficients are
obtained from the forward and backward prediction errors, this
(unpublished) method works with the sample covariance matrix of the
data.

*get_fburg* takes data of size *lnt* in array *x* as input, and computes
*order* reflection coefficients *rc*\[1\] to *rc*\[*order*\], *order*
lpc filter coefficients *c*\[1\] to *c*\[*order*\], and the lpc filter
gain \**pgain*.

# BUGS

None known

# SEE ALSO

    estimate_covar(3-ESPSsp), get_burg(3-ESPSsp),
    get_vburg(3-ESPSsp), strcov_auto(3-ESPSsp),
    genburg(3-ESPSsp), compute_rc(3-ESPSsp)

# REFERENCES

# AUTHOR

Program and man page by Shankar Narayan; revisions by John Shore
