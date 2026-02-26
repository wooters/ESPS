# NAME

refl_to_auto - convert reflection coefficients and prediction filter
error to autocorrelation coefficients.

# SYNOPSIS

refl_to_auto (refl_coeff, pfe, autocorrn, order)\
float \*refl_coeff, pfe, \*autocorrn;\
int order;

# DESCRIPTION

*refl_to_auto* converts *order* reflection coefficients *refl_coeff* and
the prediction filter error *pfe* (also called the linear predictive
analysis gain or error) into the equivalent *order + 1* autocorrelation
coefficients *autocorrn.* For the input, only *refl_coeff\[1\]* to
*refl_coeff\[order\]* are processed and *refl_coeff\[0\]* is ignored. On
return *autocorrn\[1\]* to *autocorrn\[order+1\]* are the desired
autocorrelation coefficients and *autocorrn\[0\]* should be ignored.

# EXAMPLE

    /*
     * We want to convert order reflection coefficients to
     * order + 1 autocorrelation coefficients. Assume the
     * array ref_coeff contains order reflection coefficients
     * starting from ref_coeff[0] to ref_coeff[order - 1] and the
     * autocorrelation coefficient array auto_corr has enough memory
     * to hold order + 1 coefficients.
     *
     */

    	int	order = 3;
    	float	ref_coeff[3] = {	/* reflection coefficients */
    		 -0.248618, 0.81, 0.0
    		};
    	float	alpha = 10.0;	/* prediction filter error, AKA alpha */
    	float	auto_corr[4];	/* order + 1 array */

    	/*
    	 * The following statement will convert the order ref_coeff
    	 * array to the proper order + 1 auto_corr array.
    	 *
    	 */

    	refl_to_auto (ref_coeff - 1, alpha, auto_corr, order);

    	/*
    	 * Notice we are sending (ref_coeff - 1) pointer;
    	 * it is the one before ref_coeff[0].
    	 * Therefore, in the refl_to_auto routine,
    	 * refl_coeff[1] will actually be ref_coeff[0].
    	 * 
    	 */

# REFERENCES

\[1\] Programs for Digital Signal Processing, edited by the Digital
Signal Processing Committee, IEEE Acoustics, Speech, and Signal
Processing Society, Chapter 4.3, pp 4.3-1 to 4.3-7.

# SEE ALSO

covar(3-ESPSsp), get_atal(3-ESPSsp), get_burg(3-ESPSsp),
lar_to_rc(3-ESPSsp), refl_to_filter(3-ESPSsp)

# AUTHOR

Code by Ajaipal S. Virdy, manual page by D. Burton and A. Virdy.
