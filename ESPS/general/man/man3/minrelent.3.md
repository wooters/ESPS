# NAME

min_rel_ent - compute maximum-entropy or minmum-relative-entropy
estimate of probability distribution

# SYNOPSIS

    double
    min_rel_ent(p, c, q, beta, m, n, maxit, thresh)
        double  *p, **c, *q, *beta;
        int	    m, n, maxit;
        double  thresh;

# DESCRIPTION

Given *p,* an *initial estimate* of a probability distribution, and *c,*
a *constraint matrix,* the function *min_rel_ent* computes *q,* a *final
estimate* of the probatility distribution. This is a vector with
nonnegative elements qj that satisfies the *constraints*

> SUMj cijqj = 0,

> SUMj qj = 1,

and, subject to those constraints, minimizes the *relative entropy,*

> SUMj qj log qj/pj

of *q* with respect to *p.* The solution is of the form

> qj = "alphapj exp SUMi betaicij

where "alpha and the elements of beta are Lagrange multipliers chosen to
satisfy the constraints. The value of beta is available as an additional
output *beta.*

To obtain a maximum-entropy estimate *q* subject to the stated
constraints, use an initial estimate *p* whose elements are all equal.

The function argument *p* should be an array of *n* nonnegative numbers
(or more precisely a pointer to the first element of such an array). The
sum of the elements of *p* need not be normalized to 1, and the same
results should be obtained as if each element were divided by the sum.
The argument *c* should be an *m* by *n* matrix, represented as an array
of *m* pointers to rows of length *n.* (Such structures can be allocated
by *arr_alloc*(3-ESPSu)). The arguments *q* and *beta* should be arrays
of lengths *n* and *m* to hold the results; these must be allocated by
the calling program. The arguments *m* and *n* give the array
dimensions. The argument *thresh* is a convergence criterion. The
function uses an iterative procedure that terminates as soon as the
relative change in the computed value of every element of *q* is less
than *thresh* from one iteration to the next. If the convergence
criterion is not satisfied after *maxit* iterations, the procedure
prints an error message and terminates anyway. The function value
returned by *min_rel_ent* is the maximum relative change in any element
of *q* between the last iteration and the next to last. It is less than
*thresh* in case of successful termination and not otherwise.

# DIAGNOSTICS

Function value greater than or equal to *thresh;* error message:

> min_rel_ent: convergence failed after *n* iterations.

# BUGS

None known.

# REFERENCES

1\. R. Johnson, \`\`Determining Probability Distributions by Maximum
Entropy and Minimum Cross-Entropy,'' *APL Quote Quad,* vol. 9, no. 4,
June 1979, pp. 24-29. (APL 79 Conference Proceedings).

2\. J. Shore and R. Johnson, \`\`Axiomatic Derivation of the Principle
of Maximum Entropy and the Principle of Minimum Relative Entropy,''
*IEEE Trans. Information Theory,* vol. IT-26, no. 1, pp. 26-37, Jan.
1980

# SEE ALSO

    rel_ent(3-ESPSsp)

# AUTHOR

Rodney W. Johnson, Entropic Speech, Inc. Based on an APL function from
Ref. 2 and on a Fortran adataption by Joseph T. Buck.
