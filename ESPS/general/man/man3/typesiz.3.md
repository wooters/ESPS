# NAME

typesiz - return the size of an element of a given ESPS data type

# SYNOPSIS

    #include <esps/esps.h>

    int
    typesiz(type)
    int type;

# DESCRIPTION

The argument should be one of the integer type codes DOUBLE, FLOAT,
LONG, SHORT, CHAR, DOUBLE_CPLX, FLOAT_CPLX, LONG_CPLX, SHORT_CPLX,
BYTE_CPLX, CODED, BYTE, EFILE, and AFILE defined in the ESPS include
file *esps.h.* The result is the size, in bytes, of a single element of
the given type, as stored in memory--- for example, *sizetyp*(*DOUBLE*)
== *sizeof*(*double*). BYTE has the same size as CHAR, and CODED has the
same size as SHORT. EFILE and AFILE have the same size as CHAR, since
they are represented as character arrays.

# DIAGNOSTICS

If *type* is not a valid type code, *typesiz* prints an error message,
and the program exits.

# BUGS

None known.

# AUTHOR

Alan Parker
