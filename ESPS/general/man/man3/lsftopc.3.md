# NAME

lsf_to_pc - convert line spectral frequencies to linear prediction
coefficients

# SYNOPSIS

int lsf_to_pc(lsf, pc, order, bandwidth)\
float pc\[\], lsf\[\], bandwidth;\
int order;

# DESCRIPTION

This routine takes an input vector *lsf* of line spectral frequencies
(see \[1\]) and computes the corresponding linear prediction
coefficients *pc,* also known as autoregressive filter coefficients or
prediction-error filter coefficients. The convention adopted is that the
first such coefficient is -1, and it does not appear in the output
vector. The argument *order* is the analysis filter order---i.e. the
number of input *lsf* parameters and the number of output *pc*
coefficients---and *bandwidth* should equal one-half the sampling
frequency of the original sampled data.

# ASSUMPTIONS

This routine assumes that *order* is even.

# BUGS

None known.

# REFERENCES

\[1\] G. S. Kang and L. J. Fransen, *Low-Bit Rate Speech Encoders Based
on Line-Spectrum Frequencies (LSFs),* NRL Report 8857, Naval Research
Laboratory, Washington, D.C., January, 1985.

# AUTHOR

Manual page D. Burton, Code by D. Burton
