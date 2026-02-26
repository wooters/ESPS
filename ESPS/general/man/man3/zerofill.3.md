# NAME

zero_fill - fill a newly allocated or existing numeric array with zeros

# SYNOPSIS

    #include <esps/esps.h>

    char *
    zero_fill(num, type, destination)
    long	num;
    int	type;
    char    *destination;

# DESCRIPTION

The function puts a specified number of zeros of a specified data type
into the result array, which can either be an existing array or be
allocated by the function.

The argument *num* gives the number of zeros to put into the array.

The argument *type* is a code that indicates the data type. Legal values
are the constants DOUBLE, FLOAT, LONG, SHORT, BYTE, DOUBLE_CPLX,
FLOAT_CPLX, LONG_CPLX, SHORT_CPLX, and BYTE_CPLX defined in the include
file *esps/esps.h.*

The argument *destination* must be either (char \*) NULL or the starting
location of the storage area for the zeros. If *destination* is NULL,
the function will use *malloc*(3C) to allocate an array to hold the
zeros.

The value returned by *zero_fill* is a pointer to the starting location
of the result array--- equal to *destination* if that is non-NULL, and
otherwise a pointer to the block of storage the function obtained from
*malloc.* In either case the pointer must be cast to the proper type
(*e.g.* (double \*) if *type* is DOUBLE) before being used.

# EXAMPLES

    /*
     * Zero out part of an existing array (elements a[200] through a[299]).
     */
        double  a[500];

        (void) zero_fill(100, DOUBLE, (char *) &a[200]);

    /*
     * Allocate storage with malloc and fill with zeros.
     */
        double_cplx *b;

        b = (double_cplx *) malloc((unsigned) 100 * sizeof(double_cplx));
        (void) zero_fill(100, DOUBLE_CPLX, (char *) b);

    /*
     * Repeatedly initialize an array with zeros.
     * This allocates storage the first time and thereafter reuses the same array.
     * The size must not increase after the first time.
     */
        long    size = 100;
        short   *c = NULL;

        for ( . . . ) {
            . . .
            c = (short *) zero_fill(size, SHORT, (char *) c);
            . . .
        }
        free((char *) c);

# BUGS

None known.

# SEE ALSO

arr_op(3-ESPSsp), type_convert(3-ESPSu), malloc(3C), free(3C)

# AUTHOR

Rodney Johnson, ESI.
