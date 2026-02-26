# NAME

get_fea_type - return the type of a FEA file field

# SYNOPSIS

\#include \<esps/fea.h\>\
short\
get_fea_type(name, hd)\
char \*name;\
struct header \*hd;

# DESCRIPTION

*get_fea_type* returns the type of the feature field *name* from the
ESPS Feature File header *hd*. Valid types are DOUBLE, FLOAT, LONG,
SHORT, CODED, and CHAR. These are defined in \<esps/esps.h\>.

If *name* is NULL or if it does not exist in *hd*, the type returned is
UNDEF. The program prints a message on stderr and terminates if either
*hd* does not point to an ESPS Feature File header.

# EXAMPLE


    struct header *hd;
    int	type;

    if ((type = get_fea_type("field_name", hd)) == UNDEF) . . . /* trouble */

# DIAGNOSTICS

    get_fea_type: called with non fea hd

# BUGS

None known.

# SEE ALSO

    get_fea_siz(3-ESPSu), allo_fea_rec(3-ESPSu),
    add_fea_fld(3-ESPSu), get_fea_ptr(3-ESPSu),
    get_fea_rec(3-ESPSu), put_fea_rec(3-ESPSu),
    get_fea_deriv(3-ESPSu), set_fea_deriv(3-ESPSu),
    FEA(5-ESPS)

# AUTHOR

Man page by Ajaipal S. Virdy, Entropic Speech, Inc.
