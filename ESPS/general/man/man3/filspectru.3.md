# NAME

fil_spectrum - computes FIR, IIR filter spectral response

# SYNOPSIS

    #include <esps/feafilt.h>
    #include <esps/feaspec.h>

    int fil_spectrum( spec_rec, mag, phase, filt_rec, fhd, nsamp )
    struct feaspec *spec_rec;
    double *mag;
    double *phase;
    struct feafilt *filt_rec;
    struct header *fhd;
    long nsamp;

# DESCRIPTION

*fil_spectrum* computes the spectral response from a FIR or IIR filter
as specified by *filt_rec*. The number of output points for frequency
range from 0 to the Nyquist rate is given by *nsamp*. Output can be
pointed to by any one of the non-NULL pointers, *spec_rec, mag*, or
*phase*. Output complex spectrum is pointed to by *spec_rec*, output
linear spectral magnitude response is pointed to by *mag*, and ouput
phase response is pointed to by *phase*. *fhd* is the file header of the
*filt_rec*. Currently *fhd* is not used in the function.

For IIR spectral response, *nsamp* can be an arbitrary number if poles
and zeros coefficients are stored in *filt_rec*. The overall gain for
the IIR pole/zero system equals to *filt_rec-\>re_num_coeff\[0\]*. If
*filt_rec-\>re_num_coeff\[0\]* does not exist, the gain is set to 1.

For FIR spectral response, *nsamp* must be a power of 2 plus 1.

# EXAMPLES

    /* The following computes linear spectral magnitude */

    double mag[1025];
    struct feafilt *filt_rec;
    struct header *fhd;
    FILE fp;

    get_feafilt_rec( filt_rec, fhd, fp);
    fil_spectrum( NULL, mag, NULL, filt_rec, fhd, 1025 );

# ERRORS AND DIAGNOSTICS

The function returns 0 upon success, 1 otherwise. The function prints an
error message if *nsamp* is not a power of 2 plus 1 when computing FIR
spectral response.

# SEE ALSO

*filtspec*(1-ESPS), *FEA_FILT*(5-ESPS)

# AUTHOR

Derek Lin
