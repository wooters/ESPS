# NAME

classify - maximum-likelihood or maximum-posterior-probability
classification of feature vector

# SYNOPSIS

    int
    classify(feavec, nfea, nclas, means, invcovars, priors, posteriors)
    float	*feavec;
    int	nfea, nclas;
    float	**means, ***invcovars, *priors;
    float	*posteriors;

# DESCRIPTION

*Classify* classifies a vector *feavec* of *nfea* numerical features
into one of *nclas* classes, where each class is represented by an
*nfea*-element mean vector, an *nfea*-by-*nfea* inverse covariance
matrix, and, for maximum-posterior-probability classification, a prior
probability.

The input arrays *means* and *invcovars* should each have *nclas*
elements, as should *priors* for maximum-posterior-probability
classification; for maximum-likelihood classification, *priors* should
be NULL. For each index *c* in the range (0 \<= *c* \< *nfea*),
*means*\[*c*\] and *invcovars*\[*c*\] should point to the mean vector
and inverse covariance matrix for one class, and *priors*\[*c*\], if
defined, should be the prior probability for the same class. (More
precisely, *means*\[*c*\] points to the first element of the mean
vector, and *invcovars*\[*c*\] points to a pointer to the first row of
the inverse covariance matrix.)

*Posteriors* should point to the first element of an *nfea*-element
output vector, which will receive the posterior probabilities. If
*priors* is NULL, these are computed as though all priors had been
specified as 1/*nclas.*

The return value of *classify* is the index *c* for which the posterior
probability is greatest. How ties are broken is unspecified.

# BUGS

None known.

# SEE ALSO

*fea_stats*(1-ESPS), *f_mat_alloc*(3-ESPSu), FEA_STAT(5-ESPS)

# AUTHOR

Rodney Johnson
