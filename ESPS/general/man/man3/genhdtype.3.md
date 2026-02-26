# NAME

genhd_type - get the type and size of an generic header item

# SYNOPSIS

\#include \<esps/esps.h\>

int\
genhd_type(name, size, hd)\
char \*name;\
int \*size;\
struct header \*hd;

# DESCRIPTION

*genhd_type* returns a code indicating if *name* is defined as an
generic header item for the ESPS file header pointed to by *hd* and its
type.

If *name* is defined then one of **DOUBLE, FLOAT, LONG, SHORT, CODED**,
or **CHAR** is returned as the function value and the size of the item
is returned through *size*. **HD_UNDEF** is returned if *name* is not
defined.

# EXAMPLE

int size;\
if (genhd_type("zeta",&size,hd) != **HD_UNDEF**) ...\
if (size == 1) ...

# SEE ALSO

add_genhd(3-ESPSu), get_genhd(3-ESPSu), genhd_list(3-ESPSu),
copy_genhd(3-ESPSu)

# AUTHOR

Alan Parker
