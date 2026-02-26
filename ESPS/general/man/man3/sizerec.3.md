# NAME

size_rec - return the size of a record in an ESPS file

# SYNOPSIS

\#include \<esps/esps.h\>\
size_rec(hptr)\
struct header \*hptr;

# DESCRIPTION

*size_rec* returns the size, in bytes, of records in an ESPS file. It
determines this information by examining fields in the supplied ESPS
file header.

# DIAGNOSTICS

None.

# BUGS

# AUTHOR

Joe Buck
