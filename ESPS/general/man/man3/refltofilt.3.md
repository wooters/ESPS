# NAME

refl_to_filter - Convert reflection coefficients to autoregressive
filter coefficients.

# SYNOPSIS

int\
refl_to_filter (refl_coeff, filter, size)\
float \*refl_coeff, \*filter;\
int size;

# DESCRIPTION

*refl_to_filter* converts *size - 1* reflection coefficients,
*refl_coeff,* (in positions 1 through *size - 1* in the *refl_coeff*
array) into the equivalent *size* autoregressive filter coefficients
*filter* (with the first coefficient being = -1.0). *refl_to_filter*
returns 1 on failure (one of the reflection coefficients has magnitude
\> 1.0) and 0 on successful completion.

Note: this routine uses the sign convention for reflection coefficients
mentioned in FEA_ANA(5-ESPS).

# EXAMPLE

    /* We want to convert 3 reflection coefficients to
     * 4 autoregressive filter coefficients. Assume the
     * array ref_coeff contains the reflection coefficients
     * starting from ref_coeff[0] to ref_coeff[2] and the
     * autoregressive filter coefficient array, filt_coeff, has
     * enough memory to hold 4 coefficients.
     */

    	int	size = 3;
    	float	ref_coeff[3] = {	/* reflection coefficients */
    		 -0.248618, 0.81, 0.0
    		};
    	float	filt_coeff[4];	/* size + 1 array */

    /* The following statement will convert the size ref_coeff
     * array to the proper size + 1 filt_coeff array.
     */

    	refl_to_filter (ref_coeff - 1, filt_coeff, 4);

    /* Notice we are  sending (ref_coeff  - 1)  pointer; it  is the one
     * before  ref_coeff[0].    Therefore,  in  refl_to_filt  routine,
     * refl_coeff[1]  will actually  be ref_coeff[0].
     */

# REFERENCES

\[1\] Programs for Digital Signal Processing, edited by the Digital
Signal Processing Committee, IEEE Acoustics, Speech, and Signal
Processing Society, Chapter 4.3, pp 4.3-1 to 4.3-7.

# SEE ALSO

rc_autopef(3-ESPSsp)

# AUTHOR

Code by B. Fraenkel, manual page by D. Burton and A. Virdy.
