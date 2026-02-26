# NAME

f_mat_alloc - memory allocator for a pointer to a matrix of floats

# SYNOPSIS

**\#include \<stdio.h\>**\
**float \*\*f_mat_alloc (nb_row, nb_col)**\
**unsigned nb_row;**\
**unsigned nb_col;**

# DESCRIPTION

*f_mat_alloc* allocates *nb_row* by *nb_col* block of memory. If
successful, *f_mat_alloc* returns a pointer to a matrix of floats
otherwise it returns NULL. The allocated memory is not cleared.

# EXAMPLE

int row_size, column_size; /\* dimension of memory block required \*/\
float \*\*matrix; /\* two-dimensional array \*/\

matrix = f_mat_alloc ((unsigned) row_size, (unsigned) column_size)\
if ( matrix != NULL )\
/\* successfully allocated memory block \*/\
else\
/\* could not allocate memory \*/

# DIAGNOSTICS

None.

# BUGS

None Known.

# SEE ALSO

    f_mat_free(3-ESPSu), d_mat_alloc(3-ESPSu), 
    d_mat_free(3-ESPSu)

# AUTHOR

John Shore
