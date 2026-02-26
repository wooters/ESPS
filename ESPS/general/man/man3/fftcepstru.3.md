# NAME

    fft_cepstrum - Find the cepstrum of a data sequence.
    fft_cepstrum_r - Find the cepstrum of real data sequence.
    fft_ccepstrum - Find the complex cepstrum of a data sequence.
    fft_ccepstrum_r - Find the complex cepstrum of a real data sequence.

# SYNOPSIS

    extern int debug_level;

    void
    fft_cepstrum(data, order)
    float_cplx *data;
    long order;

    void
    fft_cepstrum_r(data_real, data_imag, order)
    float *data_real, *data_imag;
    long order;

    void
    extern int debug_level;
    fft_ccepstrum(data, order)
    float_cplx *data;
    long order;

    void
    extern int debug_level;
    fft_ccepstrum_r(data_real, data_imag, order)
    float *data_real, *data_imag;
    long order;

# DESCRIPTION

The *fft_cepstrum* and *fft_ccepstrum* routines compute the cepstrum and
complex cepstrum, respectively, of a complex data sequence using fast
Fourier transform techniques. The input data is supplied through the
array *data* of size 2^*order*. The cepstral data is returned through
this array.

The routine *fft_ccepstrum* first computes the input spectrum from
*data* by using *get_cfft*(3-ESPS). The complex logarithm of this
spectrum is then found as described in \[1,2\]. The inverse FFT of this
log spectral data is found by using *get_cfft_inv*(3-ESPS) and returned
through *data*. The routine *fft_cepstrum* works identically except that
the log magnitude of the input spectrum is found rather than the complex
logarithm.

The functions *fft_cepstrum_r* and *fft_ccepstrum_r* are identical to
*fft_cepstrum* and *fft_ccepstrum* except that they process only real
data sequences. They use *get_rfft* (3-ESPS) instead of *get_fft*, and
so are faster than *fft_cepstrum* and *fft_ccepstrum*. The array
*data_imag* must be filled with zeros when *fft_cepstrum_r* and
*fft_ccepstrum_r* are called. The real and imaginary parts of the result
are returned through *data_real* and *data_imag*.

# SEE ALSO

*get_cfft*(3-ESPS) *get_cfft_inv*(3-ESPS) *get_rfft*(3-ESPS)

# COMMENTS

The routine used to compute the complex logarithm attempts to smooth the
phase angle of the spectrum by adding or subtracting 2\*pi to phase
values which differ by more than pi from their predecessors. An
additional, linear term is added to the phase to insure that the phase
varies smoothly when continued as a periodic function---that is, that
the first and last phase values differ by less than pi---and, in the
case of *fft_ccepstrum_r*, that the result is real. In terms of the
original data, this linear phase shift amounts to a circular shift of
the input array and, in the case of *fft_ccepstrum_r*, a possible sign
inverison. In order for this phase unwrapping to succeed, the phase
needs to be slowly varying, which can be achieved by increasing *order*.
If *debug_level* is greater than 0, the unwrapping algorithm checks that
unwrapped phase satisfies the continuity criterion. The warning "Phase
unwrapping failed." is echoed to standard output the first time the
criterion is violated.

# REFERENCES

\[1\] A. V. Oppenheim and R. W. Schafer, *Digital Signal Processing*
Prentice-Hall, N.J. 1975

\[2\] D. G. Childers, D. P. Skinner, R. C. Kemerait, *The Cepstrum: A
Guide to Processing* Proceedings of the I.E.E.E., vol. 65, no. 10
October 1977, pp. 1428-1443

# AUTHOR

Program and manual page by Bill Byrne.
