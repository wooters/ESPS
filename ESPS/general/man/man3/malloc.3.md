# NAME

malloc_s - call Unix memory allocator for shorts\
malloc_i - call Unix memory allocator for ints\
malloc_l - call Unix memory allocator for longs\
malloc_f - call Unix memory allocator for floats\
malloc_d - call Unix memory allocator for doubles

# SYNOPSIS

\#include \<esps/esps.h\>

    short *
    malloc_s(n)
    unsigned n;

    int *
    malloc_i(n)
    unsigned n;

    long *
    malloc_l(n)
    unsigned n;

    float *
    malloc_f(n)
    unsigned n;

    double *
    malloc_d(n)
    unsigned n;

# DESCRIPTION

These macros call *malloc*(3C) to allocate a block of memory of size *n*
of the correct type (depending on which macro was used).

These macros are defined in *\<esps/esps.h\>* and should not be declared
in your program.

# EXAMPLE

    /* get a block of 100 floats and shorts */
    float *fptr;
    short *sptr;

    fptr = malloc_f(100);
    sptr = malloc-s(100);

# DIAGNOSTICS

# SEE ALSO

    malloc(3), calloc(3), calloc(3-ESPSu)
