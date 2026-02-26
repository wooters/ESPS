# NAME

d_mat_alloc - memory allocator for a pointer to a matrix of doubles

# SYNOPSIS

**\#include \<stdio.h\>**\
**double \*\*d_mat_alloc (nb_row, nb_col)**\
**unsigned nb_row;**\
**unsigned nb_col;**

# DESCRIPTION

*d_mat_alloc* allocates *nb_row* by *nb_col* block of memory. If
successful, *d_mat_alloc* returns a pointer to a matrix of doubles
otherwise it returns NULL.

# EXAMPLE

unsigned row_size, column_size; /\* dimension of memory block required
\*/\
double \*\*matrix; /\* two-dimensional array \*/\

matrix = d_mat_alloc (row_size, column_size)\
if ( matrix != NULL )\
/\* successfully allocated memory block \*/\
else\
/\* could not allocate memory \*/

# DIAGNOSTICS

None.

# BUGS

None Known.

# AUTHOR

Code by Bernard G. Fraenkel, Man page by Ajaipal S. Virdy.
