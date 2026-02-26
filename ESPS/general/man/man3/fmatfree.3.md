# NAME

f_mat_free - frees a pointer to a matrix of floats

# SYNOPSIS

**\#include \<stdio.h\>**\
**f_mat_free (mat, nb_row)**\
**float \*\*mat;**\
**int nb_row;**

# DESCRIPTION

*f_mat_free* frees a pointer to a matrix of floats pointed to by *mat.*
Such a matrix can be allocated by means of *f_mat_alloc* (3-ESPSu).

# EXAMPLE

int row_size; /\* number of rows to free \*/\
float \*\*matrix; /\* two-dimensional array to free \*/\

(void) f_mat_free (matrix, row_size);\

# DIAGNOSTICS

None.

# BUGS

None Known.

# SEE ALSO

    f_mat_alloc(3-ESPSu), d_mat_alloc(3-ESPSu), 
    d_mat_free(3-ESPSu)

# AUTHOR

John Shore
