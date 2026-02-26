# NAME

get_rec_len - return the number of elements in a record of an ESPS file

# SYNOPSIS

\#include \<esps/headers.h\>\
long\
get_rec_len (hd)\
struct header \*hd;

# DESCRIPTION

*get_rec_len* returns the number of elements in a record of an ESPS
file. This is the number of items (elements) in a record, as opposed to
the number of bytes that a record takes (that's called size). It
determines this information by examining fields in the supplied ESPS
file header.

# DIAGNOSTICS

None.

# SEE ALSO

    size_rec(3-ESPSu)

# AUTHOR

Alan Parker, man page by Ajaipal S. Virdy.
