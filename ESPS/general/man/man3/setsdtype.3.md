# NAME

set_sd_type - set the type codes in a ESPS sampled data file header

# SYNOPSIS

\#include \<esps/esps.h\>\
void\
set_sd_type(hd,type)\
struct header \*hd;\
int type;

# DESCRIPTION

*set_sd_type* sets the type codes in the ESPS sampled data file header.
This determines the type representation used when the data is written
and read from the SD file. The type is one of FLOAT, DOUBLE, LONG,
SHORT, CHAR. These values are defined in *\<esps/esps.h\>.*

# DIAGNOSTICS

If *hd* does not point to a sampled data file header, then an error
message is printed and the program is terminated with exit 1.

# BUGS

None known.

# SEE ALSO

ESPS(5-ESPS), SD(5-ESPS), get_sd_type(3-ESPSu)

# AUTHOR

Alan Parker
