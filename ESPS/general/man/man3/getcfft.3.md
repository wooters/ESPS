# NAME

    get_cfft - Compute the fast Fourier transform of a FLOAT_CPLX data sequence.
    get_cfftd - Compute the fast Fourier transform of a DOUBLE_CPLX data sequence.
    get_cfft_inv - Compute the inverse fast Fourier transform of a FLOAT_CPLX data sequence.
    get_cfftd_inv - Compute the inverse fast Fourier transform of a DOUBLE_CPLX data sequence.

# SYNOPSIS

void\
get_cfft (data, log_fft_size)\
float_cplx \*data;\
int log_fft_size;

void\
get_cfftd (data, log_fft_size)\
double_cplx \*data;\
int log_fft_size;

void\
get_cfft_inv (data, log_fft_size)\
float_cplx \*data;\
int log_fft_size;

void\
get_cfftd_inv (data, log_fft_size)\
double_cplx \*data;\
int log_fft_size;

# DESCRIPTION

The *get_fft* and *get_cfft_inv* routines compute the discrete Fourier
transform and the inverse discrete Fourier transform, respectively, of a
given complex data sequence using the fast Fourier transform algorithm.
The input data is supplied through an array **data** that is of type
FLOAT_CPLX. The transform size is **2\*\*log_fft_size.** This is also
assumed to be the size of the input data array. The FFT output is
returned through the input array. For transform size N, there are N/2
negative frequencies, and N/2 positive frequencies. The order in which
the frequency components are returned is as follows: f(0), f(1),...,
f(N/2), f(-(N/2) + 1), f(-(N/2) + 2),..., f(-1). This amounts to N
values, with no explicit value for f(-(N/2)) since f(N/2) = f(-(N/2)).

The functions *get_cfftd* and *get_cfftd_inv* are the analogous
functions for data of type DOUBLE_CPLX.

# BUGS

None

# SEE ALSO

    get_fft(3-ESPS), get_fft_inv(3-ESPS), get_rfft(3-ESPS)

# COMMENTS

The sine and cosine tables needed by the FFT algorithm are computed
first time these routines are called. During the subsequent calls, these
tables are recomputed only if the transform sizes are different from the
previous calls. This information can be exploited to implement the
user's program efficiently in certain situations.

# REFERENCES

\[1\] A. V. Oppenheim and R. W. Schafer, *Digital Signal Processing,*
Prentice-Hall, NJ. 1975.

# AUTHOR

FFT routines by Shankar Narayan; complex covers by David Burton.
