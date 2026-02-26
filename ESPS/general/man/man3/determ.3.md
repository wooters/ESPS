# NAME

determ - determinant of a matrix in single precision

determ_d - determinant of a matrix in double precision

# SYNOPSIS

    double
    determ(mat, order)
    float	**mat;
    int	order;

    double
    determ_d(mat, order)
    double  **mat;
    int     order;

# DESCRIPTION

The return value of *determ* is the determinant of an *order*-by-*order*
matrix.

The parameter *mat* should point to the first element of an array of
*order* pointers, each of which points to the first element of a row of
the matrix.

*determ_d* is the double precision version of *determ.*

# BUGS

None known.

# SEE ALSO

arr_alloc(3-ESPSu), f_mat_alloc(3-ESPSu)

# AUTHOR

Rodney Johnson
