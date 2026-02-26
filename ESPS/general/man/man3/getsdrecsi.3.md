# NAME

get_sd_recsize - returns the size of an ESPS SD sampled-data file record

# SYNOPSIS

\#include \<esps/sps.h\>\
int\
get_sd_recsize(hd)\
struct header \*hd;

# DESCRIPTION

*get_sd_recsize* returns the size, in C **sizeof** units, of the sampled
data file records. The pointer *hd* must point to a valid SD file
header.

This function is obsolete. Instead, use *size_rec*(3-ESPSu), which works
for all file types.

# DIAGNOSTICS

If *hd* does not point to a sampled data file header, then an error
message is printed and the program is terminated with exit 1.

# BUGS

None known.

# SEE ALSO

    ESPS(5-ESPS), SD(5-ESPS), size_rec(3-ESPSu)

# AUTHOR

Alan Parker
