# NAME

lsq_solv - minimum least-squares solution of a system of linear
equations\
lsq_solv2 - minimum least-squares solutions of systems of linear
equations\
moore_pen - Moore-Penrose generalized inverse of a matrix

# SYNOPSIS

    int
    lsq_solv(a, b, m, n, x, eps)
        double  **a, *b;
        int	    m, n;
        double  *x, eps;

    int
    lsq_solv2(a, b, m, n, p, x, eps)
        double  **a, **b;
        int	    m, n, p;
        double  **x, eps;

    int
    moore_pen(a, m, n, x, eps)
        double  **a;
        int	    m, n;
        double  **x, eps;

# DESCRIPTION

The function *lsq_solv* attempts to solve a linear system

\(1\)  
*Ax = b,*

where *a* is a given *m* by *n* matrix, *b* is a given *m-*component
vector, and *x* is an *n-*component vector to be determined. There may
not be a solution - for example it is typical for equation (1) to be
inconsistent when *m \> n.* If there is no solution, then a
least-squares approximate solution of (1) is obtained. This is a vector
*x* for which the norm

> *\|\|Ax - b\|\|*

of the difference vector *Ax - b* is as small as possible. (Here the
norm of a vector, denoted by the symbols \|\| \|\|, is defines as the
square root of the sum of the squares of its components.) If there is
more than one such vector *x,* then the *minimum* least-squares
approximate solution is found. That is, among all the vectors *x* for
which *\|\|Ax - b\|\|* is minimum, the one chosen is the one for which
*\|\|x\|\|* is least.

The argument *a* of *lsq_solv* is an input argument that gives the
matrix *A,* represented as a pointer to the first element of an array of
*m* pointers, each of which points to the first element of an array of
*n* doubles that represents a row of *A.* (Matrices allocated by the
functions *arr_alloc*(3-ESPSu) and *d_mat_alloc*(3-ESPSu) have this
format.) The argument *b* points to the first element of an array of *m*
doubles that represents the right-hand side of (1). The arguments *m*
and *n* give the dimensions. The argument *x* points to the first
element of an array of *n* doubles that receives the solution; this must
be allocated by the caller before the function is called. The argument
*eps* is a relative tolerance for use in pseudorank determination. The
function attempts to test whether the matrix *A* is nearly
rank-deficient - that is, approximately equal to a matrix of some rank
less than min(*m, n*). If so, *A* is treated as being of the smaller
rank, known as the pseudorank. The pseudorank is returned as the value
of the function. In general, *eps* should at least be greater than the
machine precision - say 1e-15 for IEEE double-precision floating point.
If it known that there are greater uncertainties in the data, *eps*
should be increased accordingly.

To find minimum least-squares solutions for several systems such as (1)
with the same matrix *A,* but different right-hand sides *b,* use
*lsq_solv2.* This function has an additional dimension parameter *p,*
and the arguments *b* and *x* are an *m* by *p* matrix and an *n* by *p*
matrix, represented as arrays of pointers like *a.* Each column of *b*
independently plays the role of right-hand side, and the solution is
stored in the corresponding row of *x.*

Use *moore_pen* to find the Moore-Penrose generalized inverse of *A.*
This is an *n* by *m* matrix *M* such that

> *x = Mb*

gives the minimum least-squares solution to (1). The result is the same
as that obtained by calling *lsq_solv2* with *p = m* and an *m* by *m*
identity matrix for *b.*

# EXAMPLES

After the declarations

    	double  adata[5][4] = { {  9,  -36,   18,   24},
    				{-36,  192, -108, -144},
    				{ 30, -180,  108,  144},
    				{  0,    0,    0,    0},
    				{  0,    0,    0,    0} };
    	double  *amat[5] = {adata[0], adata[1], adata[2], adata[3], adata[4]};

    	double  bvec[5] = {1, 0, 0, 0, 0};

    	double  bdata[5][2] = { {  1,    1},
    				{  0,    2},
    				{  0,    3},
    				{  0,    4},
    				{  0,    5} };
    	double  *bmat[5] = {bdata[0], bdata[1], bdata[2], bdata[3], bdata[4]};

    	double  *xvec;
    	double  **xmat;
    	double  **inv;

    	long    dim[2];

and the initialization

    	xvec = (double *) malloc((unsigned) 5);

executing

    	rank = lsq_solv(amat, bvec, 5, 4, xvec, 1e-12);

sets *rank* equal to 3 and stores the following in *xvec.*

    	    1           0.5         0.2         0.266667    0

After

    	dim[0] = 4;     dim[1] = 2;
    	xmat = (double **) arr_alloc(2, dim, DOUBLE, 0);
    	rank = lsq_solv2(amat, bmat, 5, 4, 2, xmat, 1e-12);

*rank* equals 3, and the contents of *xmat* are the following.

    	    1           3
    	    0.5         1.91667
    	    0.2         0.86
    	    0.266667    1.14667

After

    	dim[0] = 4;     dim[1] = 5;
    	inv = (double **) arr_alloc(2, dim, DOUBLE, 0);
    	rank = moore_pen(amat, 5, 4, inv, 1e-12);

*rank* equals 3, and the contents of *inv* are the following.

    	    1           0.5         0.333333    0           0
    	    0.5         0.333333    0.25        0           0
    	    0.2         0.15        0.12        0           0
    	    0.266667    0.2         0.16        0           0

# DIAGNOSTICS

Returned value less than min(*m, n*) when *A* is nearly rank-deficient.

# BUGS

None known.

# REFERENCES

\[1\] C. L. Lawson and R. J. Hanson, *Solving Least Squares Problems,*
Prentice-Hall, 1974.

# SEE ALSO

    toep_solv(1-ESPS), matrix_inv(3-ESPSsp), stsolv(3-ESPSsp)

# AUTHOR

Rodney W. Johnson. Functions based on Fortran code by Lawson and Hanson
(ref. \[1\]).
