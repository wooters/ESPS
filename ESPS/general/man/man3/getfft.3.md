# NAME

    get_fft - Compute the fast Fourier transform of a data sequence.
    get_fftd - Compute the fast Fourier transform of a (double) data sequence.
    get_fft_inv - Compute the inverse fast Fourier transform of a data sequence.
    get_fftd_inv - Compute the inverse fast Fourier transform of a (double)data sequence.
    get_rfft - Compute the fast Fourier transform of a real data sequence.

# SYNOPSIS

void\
get_fft (data_real, data_imag, log_fft_size)\
float \*data_real, \*data_imag;\
int log_fft_size;

void\
get_fftd (data_real, data_imag, log_fft_size)\
double \*data_real, \*data_imag;\
int log_fft_size;

void\
get_fft_inv (data_real, data_imag, log_fft_size)\
float \*data_real, \*data_imag;\
int log_fft_size;

void\
get_fftd_inv (data_real, data_imag, log_fft_size)\
double \*data_real, \*data_imag;\
int log_fft_size;

void\
get_rfft (data_real, data_imag, log_fft_size)\
float \*data_real, \*data_imag;\
int log_fft_size;

# DESCRIPTION

The *get_fft* and *get_fft_inv* routines compute the discrete Fourier
transform and the inverse discrete Fourier transform, respectively, of a
given complex data sequence using the fast Fourier transform algorithm.
The input data is supplied through two arrays **data_real** and
**data_imag.** The transform size is **2\*\*log_fft_size.** The FFT
output is returned through the same arrays. For transform size N, there
are N/2 negative frequencies, and N/2 positive frequencies. The order in
which the frequency components are returned is as follows: f(0),
f(1),..., f(N/2), f(-(N/2) + 1), f(-(N/2) + 2),..., f(-1). This amounts
to N values, with no explicit value for f(-(N/2)) since f(N/2) =
f(-(N/2)).

The functions *get_fftd* and *get_fftd_inv* are the same as *get_fft*
and *get_fftd* except they pass data through arrays of type double.

The function *get_rfft* is an FFT routine similar to *get_fft* except
that the input data is assumed to be real. If the input array
*data_imag* is not filled with zero, *get_rfft* will exit with an error
message. *get_rfft* function is two times faster than the *get_fft*
routine.

# BUGS

None

# SEE ALSO

    get_arspect(3-ESPSsp).

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

Shankar Narayan
