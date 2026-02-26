# NAME

    name - does type code represent a numeric data type

# SYNOPSIS

    #include <esps/esps.h>

    int
    is_type_numeric(type)
        int type;

# DESCRIPTION

This function checks whether *type* is the numeric code for a numeric
data type. It returns YES if *type* is equal to one of the constants
BYTE, SHORT, LONG, FLOAT, DOUBLE, BYTE_CPLX, SHORT_CPLX, LONG_CPLX,
FLOAT_CPLX, or DOUBLE_CPLX. It returns NO if *type* is a non-numeric
type code (e.g. CODED, EFILE) or invalid.

# EXAMPLES

# ERRORS AND DIAGNOSTICS

None.

# FUTURE CHANGES

# BUGS

None known.

# REFERENCES

# SEE ALSO

*is_file_complex*(3-ESPSu) *is_field_complex*(3-ESPSu)\
*is_type_complex*(3-ESPSu) *cover_type*(3-ESPSu)

# AUTHOR

Rod Johnson
