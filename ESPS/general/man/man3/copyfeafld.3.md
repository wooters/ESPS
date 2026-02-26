# NAME

copy_fea_fld - replicate a feature field definition

# SYNOPSIS

\#include \<esps/fea.h\>\
int\
copy_fea_fld(hd1, hd2, name)\
struct header \*hd1;\
struct header \*hd2;\
char \*name;

# DESCRIPTION

*copy_fea_fld* attempts to add a definition of the feature field *name*
from *hd2* to *hd1*. If *name* exists in *hd2*, then a corresponding
field with the same name, size, rank, etc. is created in *hd1* (see
FEA(5-ESPS) for details concerning feature field definitions). Only the
field definition is copied, not the actual data contents of the feature
field *name*. The program returns a zero if successful.

If *name* is either NULL or does not exist in *hd2*, the program returns
a -1. The program prints a message on stderr and terminates if either
*hd1* or *hd2* do not point to ESPS Feature File headers.

# EXAMPLE


    struct header *hd1, *hd2;

    if (copy_fea_fld(hd1,hd2,"field_name") == -1) . . . /* trouble */

# DIAGNOSTICS

    copy_fea_fld: called with non fea hd

# BUGS

None known.

# SEE ALSO

    add_fea_fld(3-ESPSu), copy_fea_fields(3-ESPSu), 
    copy_fea_rec(3-ESPSu), FEA(5-ESPS)

# AUTHOR

Man page by Ajaipal S. Virdy.
