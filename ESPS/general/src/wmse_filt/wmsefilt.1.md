# NAME

wmse_filt - design an FIR filter using the weighted mean square error
criterion.

# SYNOPSIS

**wmse_filt** \[ **-P** *param_file* \] \[ **-n** *filt_length* \] \[
**-d** *d_file* \] \[ **-w** *w_file* \] \[ **-x** *debug_level* \]
*file.filter*

# DESCRIPTION

The program *wmse_filt* designs a linear-phase finite-impulse response
(FIR) filter and prints the coefficients to the *FEA_FILT*(5-ESPS) file
*file.filter.* The user specifies the number of coefficients, the
desired filter frequency response, and a weighting function. The program
then finds the set of filter coefficients that minimizes the mean square
error between the desired response and the actual response, when
weighted by the weighting function. In other words, for desired response
*D*(*f*), and weighting function *W*(*f*), the program finds the filter
*H*(*f*) which minimizes:
