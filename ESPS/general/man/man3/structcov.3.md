# NAME

struct_cov - compute a structured covariance estimate of a Toeplitz
autocorrelation matrix

# SYNOPSIS

int\
extern int debug_level;

struct_cov(S, R, distance, size, cvgtst, max_iter)\
double \*\*S, \*R, \*distance, cvgtst;\
int size;

# DESCRIPTION

*Struct_cov* estimates the autocorrelation coefficients, *R*,
(equivalent to a Toeplitz autocorrelation matrix) that corresponds to
the input sampled covariance matrix (*S*). *Size* is the number of rows
(or columns) in the input covariance matrix, and the number of returned
autocorrelation values. *Distance* is the final distortion between the
input covariance matrix and the resulting autocorrelation matrix.
*struct_cov* estimates *R* iteratively; the estimator terminates after
*max_iter* iterations, or after the relative change in autocorrelation
values falls below the convergence threshold *cvgtst*.

Input sample covariance matrices can be obtained from *estimate_covar*
(3-ESPSsp).

# DIAGNOSTICS

*Struct_cov* returns 0 if no problem is discovered in the process of
estimating the autocorrelation values, and it returns 1, if a problem
arises. If the external *debug_level* is positive, debugging output is
printed on stderr, with higher values yielding more verbose output.

# SEE ALSO

*estimate_covar*(3-ESPSsp), *strcov_auto*(3-ESPSsp),\
*genburg*(3-ESPSsp), *get_vburg*(3-ESPSsp), *get_fburg*(3-ESPSsp)

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

# AUTHOR

Code by B. Frankel; ESPS modification by D. Burton; manual page by D.
Burton. Additional mods by John Shore
