# NAME

matrix_inv - invert a matrix with single precision\
matrix_inv_d - invert a matrix with double precision

# SYNOPSIS

**\#include \<stdio.h\>**\
**double matrix_inv (mat_in, inv_out, order)**\
**float \*\*mat_in;**\
**float \*\*inv_out;**\
**int order;**

\
**double matrix_inv_d (mat_in, inv_out, order)**\
**double \*\*mat_in;**\
**double \*\*inv_out;**\
**int order;**

# DESCRIPTION

*matrix_inv* inverts an input matrix *mat_in* of order *order* and
stores the result in *inv_out.* If the input matrix is singular to
working precision, then the output matrix *inv_out* is left unchanged.

The two parameters, *mat_in* and *inv_out*, are interpreted as pointers
to matrices of floats (or doubles) containing *order* rows and *order*
columns. Space for these matrices must be allocated by the calling
program - such a pointer can be assigned by means of
*arr_alloc*(3-ESPSu).

*matrix_inv* returns the condition number of the matrix. If the
condition number is greater than 1e6 for *matrix_inv,* or greater than
1e14 for *matrix_inv_d,* then the matrix is considered singular and -1.0
is returned.

*matrix_inv_d* is the double precision version of *matrix_inv.*

# EXAMPLE

int order = 4; /\* order of matrix to invert \*/\
float \*\*matrix; /\* input matrix to invert \*/\
float \*\*inv_matrix; /\* inverse matrix \*/

/\* allocate memory and initialize matrices \*/

if (matrix_inv (matrix, inv_matrix, order) == -1.0)\
/\* input matrix is singular to working precision \*/\
else\
/\* inv_matrix contains the inverse of input matrix \*/\

# DIAGNOSTICS

# BUGS

None Known.

# SEE ALSO

    arr_alloc(3-\SPSu)

# REFERENCES

\[1\] Forsythe, G. E., M. A. Malcolm, C. B. Moler (1977), *Computer
Methods for* Mathematical Computations. New Jersey: Prentice-Hall, Inc.,
51-55.

# AUTHOR

Ajaipal S. Virdy.
