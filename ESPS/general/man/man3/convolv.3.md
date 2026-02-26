# NAME

convolv - convolution of regular polynomials or auto-correlations

auto_convolv - convolution of symmetric polynomials or auto-correlations

# SYNOPSIS

convolv (pol_1, size_1, pol_2, size_2, pol_out, out_siz)\
double \*pol_1, \*pol_2, \*pol_out;\
int size_1, size_2, \*out_siz;

auto_convolv (pol_1, size_1, pol_2, size_2, pol_out, out_siz)\
double \*pol_1, \*pol_2, \*pol_out;\
int size_1, size_2, \*out_siz;

# DESCRIPTION

*convolv* and *auto_convolv* perform the convolution (product) of the 2
input polynomials. In other words:\
pol_out\[Z\] = pol_1\[Z\] \* pol_2\[Z\].

*convolv* is to be used in the case of "regular" polynomials, while
*auto_convolv* is to be used in the case of symmetric polynomials.
Symmetric refers to polynomials with positive and negative powers where
the coefficients of the negative and positive powers are equal, as it is
the case, for example, in auto-correlation functions. Coefficients are
stored in order of increasing powers. In the case of *auto_convolv,* it
is assumed that only the coefficients of the positive powers are stored
in the arrays.

*Pol_1* and *pol_2* are the input polynomials. The sizes, i.e. 1 plus
the order, of the polynomials are respectively *size_1* and *size_2.*
*Pol_out* is the result polynomial, and *out_siz* is a pointer to its
size. We have:\
*\*out_siz = size_1 + size_2* - 1.

# DIAGNOSTICS

None

# BUGS

None known.

# SEE ALSO

# AUTHOR
