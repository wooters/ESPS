# NAME

get_vburg - Compute reflection coefficients using a vector Burg method.

# SYNOPSIS


    get_vburg (x, lnt, r, order, c, rc, pgain, matsiz)


    float     *x;
    int      lnt;
    double    *r;
    int    order;
    float     *c;
    float    *rc;
    float *pgain;
    int   matsiz;

# DESCRIPTION

This routine computes the reflection coefficients and the lpc filter
coefficients directly from the data using a Burg-like algorithm. The
resulting reflection coefficients are found to be very close to those
obtained using structured covariance method, so we think of this as a
fast approximation to structured covariance.

*get_vburg* takes data of size *lnt* in array *x* as input and computes
*order* reflection coefficients, *rc*\[1\] to *rc*\[*order*\], *order*
lpc filter coefficients, *c*\[1\] to *c*\[*order*\], the signal *power*
\*r, and the lpc filter gain, \**pgain*. The parameter *matsiz*
specifies the size of the sample covariance matrix that is to be used in
obtaining the reflection coefficients (when *get_vburg* is used in
*refcof*, *matsiz* = *order* + 1). For more details on this algorithm,
see \[1\].

# BUGS

None

# SEE ALSO

    strcov_auto(3-ESPSsp), genburg(3-ESPSsp),
    estimate_covar(3-ESPSsp), struct_cov(3-ESPSsp),
    get_fburg(3-ESPSsp), get_burg(3-ESPSsp),
    compute_rc(3-ESPSsp), refcof(1-ESPS) 

# REFERENCES

\[1\]  
Shankar Narayan and J.P. Burg, "Spectral Estimation of Quasi-Periodic
Data", *Proceedings ICASSP 87*, pp. 944-947.

# AUTHOR

Shankar Narayan
