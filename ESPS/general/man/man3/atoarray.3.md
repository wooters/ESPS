# NAME

    atoarrayf - convert ASCII file to data array of floats
    atoarray - convert ASCII file to data array of specified numeric type
    atoarrays - convert ASCII file to data array of strings

# SYNOPSIS

    #include <esps/esps.h>

    float *
    atoarrayf(strm, nvalues, max)
    FILE *strm;
    long *nvalues;
    float *max;

    char *
    atoarray(strm, type, nvalues, max)
    FILE *strm;
    int type;
    long *nvalues;
    double *max;

    char **
    atoarrays(strm, nvalues, max)
    FILE    *strm;	
    long    *nvalues;
    int      *max;	

# DESCRIPTION

*atoarrayf* and *atoarray* read the Ascii file stream *strm,* which is
assumed to contain a series of numerical values separated by white space
or new lines; they convert the values to the required type and return a
pointer to the converted data.

The required data type is FLOAT for *atoarrayf.* For *atoarray* it is
indicated by the value of *type,* which must be one of the integer
constants DOUBLE, FLOAT, LONG, SHORT, BYTE, DOUBLE_CPLX, FLOAT_CPLX,
LONG_CPLX, SHORT_CPLX, and BYTE_CPLX defined in *esps/esps.h.* See the
table in the FEA*(5-ESPS)* man page; non-numeric types are not allowed.
If the type is complex, the input values are taken in pairs; the first
value in a pair gives the real part of a complex number, and the second
value gives the imaginary part. An input value is written as an
optionally signed string of decimal digits, which, for types DOUBLE,
FLOAT, DOUBLE_CPLX, and FLOAT_CPLX, may contain a decimal point and may
be followed by an *E* or *e* and an optionally signed integer.

*atoarrays* reads the Ascii file stream *strm* and returns an array of
strings, one string per line in file stream. Trailing line feeds are
dropped before each line is added to the string array.

For all three functions, the number of values read is returned through
the parameter *nvalues.* (For complex types, that is the number of
complex values, not the number of real values.)

The maximum absolute value or maximum string length (in the case of
*atoarrays*) encountered is returned through *max* if *max* is non-NULL.
A NULL value for *max* is treated as an error by *atoarrayf.* A value of
NULL for *max* is a signal to *atoarray* and *atoarrays* that the
maximum absolute value or maximum string length is not wanted.

The returned values from *atoarrayf* and *atoarray* is a pointer to the
first byte of the storage area for the results. The storage is allocated
by *malloc*(3c) and may be freed by *free*(3c). Before being used, the
pointer returned by *atoarray* must be cast to a pointer type depending
on *type* (*e.g.* (double \*) for DOUBLE, (byte_cplx \*) for BYTE_CPLX).
The value returned by *atoarrayf* does not require a cast.

*atoarrayf,* *atoarray* and *atoarrays* can be used on standard input.

# EXAMPLE

        float   *sdata;	 
        float   maxvalf;
        double  maxvald;
        long    points;
        FILE    *instrm;
         .
         .
         .
        sdata = atoarrayf(instrm, &points, &maxvalf);
        	/* or */
        sdata = (float *) atoarray(instrm, FLOAT, &points, &maxvald);
        /*
         * process data in sdata
         */

# DIAGNOSTICS

The functions will an assertion failure and a diagnostic message if any
of the following are true:

The function is unable to allocate sufficient memory.

A NULL pointer is passed for *strm* or *nvalues.*

A NULL pointer is passed to *atoarrayf* for *max.*

An illegal value is passed to *atoarray* for *type.*

The function encounters an illegal format in the input.

*atoarray* finds an odd number of real input values while reading
complex data.

# BUGS

None known.

# FUTURE CHANGES

Version of *atoarray* that will read into a user-supplied data area and
will stop reading after a specified maximum number of elements.

# SEE ALSO

*addstr* (3-ESPS), malloc(3c), free(3c).

# AUTHOR

*atoarrayf* and *atoarrays* by John Shore. *atoarray* by Rodney Johnson,
based on *atoarrayf.*
