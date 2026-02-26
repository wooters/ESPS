# NAME

stsolv - solve a real symmetric Toeplitz system of linear equations by
Levinson's method.

# SYNOPSIS

    int
    stsolv(r, v, order, w)
    double  *r, *v;
    int	order;
    double  *w;

# DESCRIPTION

This function solves the system of equations

*Rw = v*

where R is a Toeplitz matrix with coefficients given by

*Rij = r\|i-j\|*

The input vectors *r* and *v* and the output vector *w* are of length
*order* + 1 with indices running from 0 to *order.* In the intended
applications, *R* is an autocorrelation matrix; it should be positive
definite. Levinson's method is used - reflection coefficients are
computed as intermediate results, and the computation halts if a
reflecton coefficient with magnitude 1 or greater is computed. In that
case *w* will be the solution of a system of smaller order, indicated by
the return value of the function. The return value upon normal
completion is equal to *order,* and -1 indicates that *r*\[0\] equals 0.

# BUGS

None known.

# SEE ALSO

toep_solv(1-ESPS), auto(1-ESPS), cross_cor(1-ESPS)

# AUTHOR

Rodney Johnson
