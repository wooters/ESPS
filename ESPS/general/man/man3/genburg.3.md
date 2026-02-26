# NAME

    genburg - generalized Burg (structured covariance) estimation of covariance matrix

# SYNOPSIS

     
    #include <esps/stdio.h>
    #include <esps/window.h>
    #include <esps/ana_methods.h>

    extern int debug_level;

    genburg(sigma_in, isigma_in, qd, pdist, sigma_out, isigma_out, c_flag, 
    	monitor_flag, ret_flag, R_out, iR_out, init_flg, anderson)

    double *sigma_in;*
    double *isigma_in;*
    int    *qd;*
    double *pdist;
    doulbe *sigma_out;*
    doulbe *isigma_out;*
    double *R_out;*
    double *iR_out;*
    int    c_flag;*
    int    monitor_flag;*
    int    *ret_flag;*
    int    init_flg;*
    int    anderson;

# DESCRIPTION

*genbug* uses the algorithms discussed in \[1\] and \[2\] to find the
best estimate for the covariance matrix of single channel real or
complex problem. The input is a Hermitian sample covariance matrix, and
the output is a Hermition (block) Toeplitz matrix. All matrics are
stored in row order. Input sample covariance matrices can be obtained
from *estimate_covar* (3-ESPSsp).

*sigma_in* is the address of the real part of the input sample
covariance matrix, and *isigma_in* is the address of the imaginary part.
*qd* is the size (1 dimension) of the input (and output) matrices.

*sigma_out* is the address of the real part of the output output matrix,
and *isigma_out* is the address of the imaginary part. If *init_flg* ==
1 (see below), *sigma_out* and *isigma_out* are also as inputs to pass
an initial guess to *genburg*. *R_out* and *iR_out* are the final
solution vectors used to construct *simga_out* and *isigma_out*. The
finnal distance or measure is returned via *pdist*.

If *c_flag* != 0, the inputs are complex. If *monitor_flag* != 0,
intermediate results are printed on stdout.

A function return status is returned in *ret_flag*, with values as
follows (some of these refer to internals of the algorithm):


    	0 = no decrease in measure after 4 attempts
    	1 = Rinit or Rnew is singular or Rinit is negative definite
    	2 = sigma_in or Rinit is non-pos-definite 
    	3 = Aij singular 
    	4 = unsuccessful interpolation, or non positive definite Rnew
    	5 = successful measure ratio convergence test 
    	6 = insufficient storage allocation

The parameter *init_flag* has the following meanings:


    	0 = use identity matrix as initial guess 
    	1 = use sigma_out and possibly isigma_out as initial guess
    	2 = use the first projection of sigma_in as initial guess
    	3 = use average + first projection as initial guess

IF *anderson* != 0, the Anderson version of the algorithm is used.
Otherwise, the Burg version is used.

# EXAMPLES

# ERRORS AND DIAGNOSTICS

# FUTURE CHANGES

# BUGS

This function is more general though not as reliable as the function
*struct_cov*(3-ESPSsp).

# REFERENCES

\[1\]  
J.P.Burg, D.G.Luenberger, D.L.Wenger, "Estimation of Structured
Covariance Matrices" *Proceedings of the IEEE*, Vol. 70, No. 9 September
1982

\[2\] T.W. Anderson, "Estimation for Autoregressive Moving Average  
Models in the Timne and Frequency Domain," *The Annals of* Statistics,
1977, Vol. 5, No. 5, 842-865.

\[3\]  
J.E. Shore, "On a Relation Between Maximum Liklihood Classification and
Minimum Relative-Entropy Classification, *IEEE Transactions on*
Information Theory, Vol. IT-30, No. 6, Nov. 1984, pp. 851-854.

# SEE ALSO

    estimate_covar(3-ESPS), get_auto(3-ESPS), 
    strcov_auto(3-ESPS), struct_cov(3-ESPS),
    get_vburg(3-ESPS), refcof(1-ESPS), 
    me_spec(1-ESPS)

# AUTHOR

Program by Daniel Wenger, minor revisions and man page by John Shore.
