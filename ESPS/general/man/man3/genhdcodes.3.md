# NAME

genhd_codes - get the string array of possible values for generic header
of coded type

# SYNOPSIS

\#include \<esps/esps.h\>

char \*\*\
genhd_codes(name, hd)\
char \*name;\
struct header \*hd;

# DESCRIPTION

*genhd_codes* returns a pointer to a NULL terminated array of character
pointers, each of which points to character string being a possible
value for the generic header item *name*. If *name* is undefined or is
not of type **CODED** NULL is returned.

# DIAGNOSTICS

There are internal checks to be sure *name* and *hd* are not NULL.

# BUGS

# SEE ALSO

add_genhd(3-ESPSu), get_genhd(3-ESPSu), genhd_list(3-ESPSu),
copy_genhd(3-ESPSu)

# AUTHOR

Alan Parker
