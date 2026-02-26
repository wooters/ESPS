# NAME

    blt - Find the bilinear transform of a sequence.

# SYNOPSIS

void\
blt(data, n, a)\
int n;\
float \*data;\
float a;

# DESCRIPTION

The routine *blt* performs a bilinear transformation of a real sequence
as described in \[1\]. The transform of the length *n* sequence, *data*,
is obtained through recursive application of IIR filters (see \[1\]).
The transformed sequence, also length *n*, is returned in *data*.

A single parameter, *a*, describes the bilinear transformation. The
Z-Transform of the original sequence, F, and the transformed sequence,
G, are related by\

F( e^(jw) ) = G( e^(jw') )\

where\

w = arctan\[ ( (1-a^2) sin w')/( 2a + (1+a^2) cos w') \].

An intendend application of this routine is to obtain a frequency
warping which approximates the mel-scale. An example of this is the
mel-warped cepstrum, which is described in \[2\].

# SEE ALSO

*acf*(1-ESPS), *afc2cep*(3-ESPS), *fft_cepstrum*(3-ESPS)

# COMMENTS

The transformation is performed in-place. Internal static memory is
allocated as required. If *blt* is called with *a* equal to 0, the
routine returns without performing any computation; no error message is
generated.

# REFERENCES

\[1\] A. V. Oppenheim and D. H. Johnson, *Discrete Representation of
Signals.* Proceedings of the I.E.E.E., vol. 60, no. 6, June 1972
p681-691

\[2\] K. Lee, *Automatic Speech Recognition: the Development of the
SPHINX System* Kluwer Academic, Norwell, MA. 1989

# AUTHOR

Manual page and program by Bill Byrne.
