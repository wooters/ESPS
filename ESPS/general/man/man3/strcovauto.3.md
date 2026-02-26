# NAME

    strcov_auto - estimation of auto-correlation coefficients using structured covariance

# SYNOPSIS


    extern debug_level;

    strcov_auto(data, lnt, r, order, matsiz, window_flag, alg, conv_test, max_iter)
    float   *data;
    int	lnt;
    double  *r;
    int	order;
    int	matsiz;
    int	window_flag
    char	alg;
    double	conv_test;
    int	max_iter;

# DESCRIPTION

*strcov_auto* computes the auto-correlation coefficients of a given data
sequence using the structured covariance method method.

*strcov_auto* takes data of size *lnt* in array *data* as input,
computes the sample covariance matrix of size *matsiz*, and then
estimates the energy *r*\[0\] and *order* auto-correlation coefficients
*r*\[i\] using the structured covariance method (the computed data *r*
has size *order*+1). The parameter *matsiz* should be larger than
*order*; typically, *matsiz* = *order* + 1;

If the parameter *window_flag* is non-zero, triangular window is applied
to the sample data vectors in the computation of sample covariance
matrix.

If the parameter *alg* is 'f' (the default), the structured covariance
computation is performed by *struct_cov* (3-ESPS). If the parameter
*alg* is 'w', the structured covariance computation is performed by
*genburg* (3-ESPS). *struct_cov* uses a fast, single channel algorithm
developed by John Burg and programmed by Bernard Fraenkel. *genburg*
uses an older (but more general) algorithm *genburg* (3-ESPS) that was
programmed by Daniel Wenger.

If the case of *alg* == 'f', the estimator terminates after *max_iter*
iterations, or after the relative change in autocorrelation values falls
below the convergence threshold *conv_test*.

If the external *debug_level* is non-zero, various debugging messages
are printed. Higher values yield more verbose output.

# BUGS

None known

# SEE ALSO

*get_auto*(3-ESPSsp), *genburg*(3-ESPSsp), *struct_cov*(3-ESPSsp),
*get_vburg*(3-ESPSsp), *estimate_covar*(3-ESPSsp),\
*get_fburg*(3-ESPSsp)

# FUTURE CHANGES

The restriction on the size of *order* should be changed.

# REFERENCES

\[1\]  
J.P.Burg, D.G.Luenberger, D.L.Wenger, "Estimation of Structured
Covariance Matrices" *Proceedings of the IEEE*, Vol. 70, No. 9 September
1982

\[2\]  
Shankar Narayan and J.P. Burg, "Spectral Estimation of Quasi-Periodic
Data", *Proceedings ICASSP 87*, pp. 944-947.

# AUTHOR

program by Shankar Narayan; man page by John Shore
