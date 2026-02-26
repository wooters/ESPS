# NAME

d_mat_free - frees a pointer to a matrix of doubles

# SYNOPSIS

**\#include \<stdio.h\>**\
**d_mat_free (mat, nb_row)**\
**double \*\*mat;**\
**int nb_row;**

# DESCRIPTION

*d_mat_free* frees a pointer to a matrix of doubles pointed to by *mat.*

# EXAMPLE

int row_size; /\* number of rows to free \*/\
double \*\*matrix; /\* two-dimensional array to free \*/\

(void) d_mat_free (matrix, row_size);\

# DIAGNOSTICS

None.

# BUGS

None Known.

# AUTHOR

Code by Bernard G. Fraenkel, Man page by Ajaipal S. Virdy.
