# NAME

    linear_to_mu - converts 14-bit integer data to 8-bit mu-law compressed data
    mu_to_linear - converts 8-bit mu-law compressed data to 14-bit data

# SYNOPSIS

int\
**linear_to_mu(inbuf, outbuf, bufsize)**\
**short \*inbuf;**\
**char \*outbuf;**\
**long bufsize;**\

int\
**mu_to_linear(inbuf, outbuf, bufsize)**\
**char \*inbuf;**\
**" short \*outbuf;**\
**long bufsize;**\

# DESCRIPTION

These two functions do quasi-logarithmic companding (compression and
expansion) of 2-byte integer data by using the *mu*-law with a value of
*mu* = 255. This is the North American PCM standard \[1\]. This
compression law is linear for small amplitudes and logarithmic for large
amplitudes. *Inbuf* contains input data to be converted; *outbuf*
contains the converted data; and *bufsize* is the number of elements in
the *inbuf* array.

*Linear_to_mu* converts integer data with 14 significant bits (including
sign) to 8 bits by using a 15-segment, piecewise linear approximation to
the *mu*-law compression characteristic \[1\]. The conversion is done by
using a binary search through an ordered list of input signal
magnitudes. No checking of input data magnitudes is done by
*linear_to_mu*, so the calling routine should insure that all input
samples have magnitude \<= 8159.

*Mu_to_linear* converts 8-bit, logarithmically compressed data to 14-bit
linear data by using the piecewise-linear *mu*-law approximation. A
table lookup procedure is used to decode the magnitudes of the
compressed values.

# SEE ALSO

# BUGS

None Known.

# REFERENCES

\[1\] John C. Bellamy, "Digital Telephony", Appendix B

# AUTHOR

Manual page and program by David Burton.
