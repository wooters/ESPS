# NAME

    copy_genhd - copy generic header items 
    copy_genhd_uniq - copy generic header items and force unique names

# SYNOPSIS

\#include \<esps/esps.h\>

\
int\
copy_genhd(dest, src, name)\
struct header \*dest;\
struct header \*src;\
char \*name;\

int\
copy_genhd_uniq(dest, src, name)\
struct header \*dest;\
struct header \*src;\
char \*name;

# DESCRIPTION

*copy_genhd* copies one or all of the generic header items from header
*src* to header *dest*. If *name* is NULL, all header items in *src* are
copied; if an item by the same name already exists in *dest*, it is
replaced by the corresponding item from *src*.

If *name* is non-NULL, it is interpreted as the name of a single generic
header item that is copied from *src* to *dest*. If an item by the same
name already exists in *dest*, it is replaced by the item from *src*. If
no item with the name *name* exists in *src*, then no action is taken.

The number of generic header items copied is returned by *copy_genhd*.
Thus, for example, zero is returned if *name* is non-NULL and does not
correspond to an existing generic in *src*.

*Copy_genhd_uniq* works just like *copy_genhd* except that an item in
*dest* is not replaced by a corresponding item with the same name from
*src*. Instead, the value is stored in *dest* with a unique generic
header item name. The name is created by appending a suitable digit to
the original name. For details on the naming scheme, see *uniq_name*
(3-ESPS), which is used in this case to generate the new name.

# DIAGNOSTICS

None

# BUGS

None known.

# SEE ALSO

    add_genhd (3-ESPS), genhd_list (3-ESPS), 
    get_genhd_val (3-ESPS), genhd_type (3-ESPS),
    copy_header (3-ESPS), uniq_name (3-ESPS)

# AUTHOR

Man page by John Shore. Code by Alan Parker and John Shore
