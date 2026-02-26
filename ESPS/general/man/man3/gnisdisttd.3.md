# NAME

gnis_dist_td - compute the gain-normalized Itakura-Saito distortion
between two autoregressive power spectra given time domain information.

# SYNOPSIS

double gnis_dist_td (autocorrn, autocorrn_err, codeword, size)\
double \*autocorrn, autocorrn_err, \*codeword;\
int size;

# DESCRIPTION

*gnis_dist_td* computes the gain-normalized Itakura-Saito distortion
between two power spectra that are defined by *autocorrn* and
*codeword.* *gnis_dist_td* computes the distortion by using equation
(10) in \[1\] in which *autocorrn* corresponds to the first spectral
argument and *codeword* corresponds to the second spectral argument.
*autocorrn* is a set of equally spaced, time-domain autocorrelations
starting with the zero lag autocorrelation, *autocorrn_err* is the
linear predictive analysis squared error that is associated with the
*autocorrn* set of autocorrelations, and *codeword* is the
autocorrelation of a set of autoregressive filter coefficients. *size*
is the number of *autocorrn* and *codeword* values, and *gnis_dist_td*
returns the computed distortion value.

# WARNINGS

*gnis_dist_td* ignores the first term (element 0) in the arrays,
*autocorrn* and *codeword.* It assumes the arrays are defined from
*autocorrn\[1\]* to *autocorrn\[size\]* and *codeword\[1\]* to
*codeword\[size\].*

# EXAMPLE

    /* Assume the equally spaced, time-domain autocorrelation,
     * auto_corr,  is  defined  from  element 1  to element  6 and the
     * autocorrelation of the autoregressive filter coefficients,
     * cdwd, is defined from element 0 to element 5  (i.e. size = 6).
     * Also assume that the linear predictive analysis squared error
     * term ac_err has been computed.
     * To compute the Gain-Normalized Itakura-Saito distortion measure between
     * the two power spectras, we would have to call gnis_dist_td with the
     * following arguments:
     */

      GNIS_distortion = gnis_dist_td(auto_corrn, ac_err, cdwd - 1, 6);

# REFERENCES

\[1\] J. E. Shore and D. K. Burton, Discrete Utterance Speech
Recognition Without Time Alignment," IEEE Transactions on Information
Theory, Vol. IT-29, No. 4, July 1983, pp 473-491

\[2\] R. M. GRAY, A. Buzo, A. H. Gray, and Y. Matsuyama, "Distortion
Measures for Speech Processing," IEEE Transactions on Acoustics, Speech,
and Signal Processing, Vol. ASSP-28, No. 4, August 1980, pp 367-376

# SEE ALSO

    gois_dist_td(3-ESPSsp), is_dist_td(3-ESPSsp)

# AUTHOR

Code by A. Virdy, manual page by D. Burton
