# NAME

calloc_s - call Unix memory allocator (calloc) for shorts\
calloc_i - call Unix memory allocator (calloc) for ints\
calloc_l - call Unix memory allocator (calloc) for longs\
calloc_f - call Unix memory allocator (calloc) for floats\
calloc_d - call Unix memory allocator (calloc) for doubles

# SYNOPSIS

\#include \<esps/esps.h\>

    short *
    calloc_s(n)
    unsigned n;

    int *
    calloc_i(n)
    unsigned n;

    long *
    calloc_l(n)
    unsigned n;

    float *
    calloc_f(n)
    unsigned n;

    double *
    calloc_d(n)
    unsigned n;

# DESCRIPTION

These macros call *calloc*(3C) to allocate a block of memory of size *n*
of the correct type (depending on which macro was used). Since calloc is
called, the block is zero filled.

These macros are defined in *\<esps/esps.h\>* and should not be declared
in your program.

# EXAMPLE

    /* get a zero filled block of 100 floats and shorts */
    float *fptr;
    short *sptr;

    fptr = calloc_f(100);
    sptr = calloc-s(100);

# DIAGNOSTICS

# SEE ALSO

malloc(3C), calloc(3C), *malloc*(3-ESPSu)
