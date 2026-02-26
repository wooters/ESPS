# NAME

    pz_to_co - convert pole or zero locations to filter coefficients.
    pz_to_co_d - convert pole or zero locations to filter coefficients.

# SYNOPSIS

\
int pz_to_co (nroots, real, imag, pnco, co);\
int nroots;\
double \*real, \*imag;\
float \*co;\
short \*pnco;

int pz_to_co_d (nroots, real, imag, pnco, co);\
int nroots;\
double \*real, \*imag;\
double \*co;\
short \*pnco;

# DESCRIPTION

*pz_to_co* and *pz_to_co_d* take in *nroots* root locations and returns
the coefficients for the expanded polynomial. The root locations are
specified as complex numbers in rectangular form and are passed to the
function in the *real* and *imag* arrays. The resulting polynomial
coefficients (starting with order zero) are returned in the *co* array,
and the number of them is returned in the variable pointed to by *pnco.*
If a root does not lie on the real axis (i.e. its imaginary part is
nonzero) then its complex conjugate is automatically included, and
should not be specified. Those roots lying on the real axis are left as
is.

# EXAMPLE


    int nzero;
    double *real, *imag;
    	.
    	.
    	.

    /* This converts a set of zero locations to a filter record. */
    /* Assume nzero and the real and imag arrays have been initialized. */

    oh->hd.filt->max_num = nzero = NUM_COEFF;
    oh->hd.filt->max_den = 0;
    frec = allo_filt_rec (oh);

    pz_to_co (nzero, real, imag, &(frec->filt_func.nsiz), frec->filt_func.zeros);
     
    /* Write the filter record to the output file. */
    write_header (oh, fpout);

# DIAGNOSTICS

None.

# BUGS

None known.

# SEE ALSO

zero_pole (1-ESPS)

# AUTHOR

Brian Sublett. pz_to_co_d added by Bill Byrne.
