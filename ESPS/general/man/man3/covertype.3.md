# NAME

cover_type - returns data type that can contain any data from two input
types

# SYNOPSIS

    #include <esps/esps.h>

    short
    cover_type(t1, t2)
    short t1, t2;

# DESCRIPTION

For arguments *t1* and *t2* with values among the standard ESPS FEA data
types (DOUBLE, FLOAT, LONG, SHORT, BYTE, DOUBLE_CPLX, FLOAT_CPLX,
LONG_CPLX, SHORT_CPLX, BYTE_CPLX), *cover_type* returns the data type
that "covers" the input types, in the sense that all values of the input
types can be stored in the output type.

If either of the input types is complex, the output type is also
complex; otherwise the output type is non-complex. The underlying output
type (the type of real and imaginary parts for complex types; the type
itself for non-complex types) is the first item in the list (DOUBLE,
FLOAT, LONG, SHORT, BYTE) that matches the underlying type of either
*t1* or *t2*.

Assertion errors result if either *t1* or *t2* is not a valid ESPS type.

# BUGS

None known.

# SEE ALSO

*type_convert* (3-ESPS), FEA (5-ESPS)

# AUTHOR

Manual page and program by John Shore.
