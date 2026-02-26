# NAME

    cadd - returns the complex sum of two complex numbers
    csub - returns the complex difference of two complex numbers
    cmult - returns the complex product of two complex numbers
    cdiv - returns the complex division of two complex numbers
    conj - returns the complex conjugate of its argument
    realmult - returns the complex product of a real and a complex number
    realadd - returns the complex result of adding a real and a complex
    cmultacc - returns the product of two complex numbers added to a third
    modul - returns the absolute value of a complex number
    csqrt - returns the square root (positive real if possible) of a complex number

# SYNOPSIS

typedef struct {\
double real;\
double imag;\
} double_cplx;

\# include \<esps/esps.h\>

double_cplx cadd (x, y)\
double_cplx x, y;

double_cplx csub (x, y)\
double_cplx x, y;

double_cplx cmult (x, y)\
double_cplx x, y;

double_cplx cdiv (x, y)\
double_cplx x, y;

double_cplx conj (x)\
double_cplx x;

double_cplx realmult (x, r)\
double r;\
double_cplx x;

double_cplx realadd (x, r)\
double r;\
double_cplx x;

double_cplx cmultacc (x, y, z)\
double_cplx x, y, z;

double modul (x)\
double_cplx x;

double_cplx csqrt(x)\
double_cplx x;

# DESCRIPTION

Each function operates on one or more complex numbers. The typedef
double_cplx is defined by the inclusion of *\<esps/esps.h\>*, and it is
shown above for reference. The typedef COMPLEX was used in previous
versions of ESPS, and is defined and for convenience is now defined as a
synonym for double_cplx.

*cadd* adds two complex numbers and returns their sum.

*csub* subtracts *y* from *x* and returns the difference.

*cmult* multiplies *x* by *y* and returns the product.

*cdiv* divides *x* by *y* and returns the quotient.

*conj* returns the complex conjugate of *x*.

*realmult* multiplies the complex number *x* by the real number *y* and
returns the product.

*realadd* addes the complex number *x* to the real number *r* and
returns the sum.

*cmultacc* multiplies *x* by *y*, adds it to *z*, and returns the sum.

*modul* returns the absolute value, or modulus, of *x*.

*csqrt* returns the square root of *x*.

# DIAGNOSTICS

*cdiv* warns and exits if the divisor is zero.

# AUTHOR

Code by B. F. Frankel; ESPS modification, sqrt, and realadd by D.
Burton; manual page by D. Burton.
