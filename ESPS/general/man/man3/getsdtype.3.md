# NAME

get_sd_type - get the type of data in an ESPS sampled-data (FEA_SD or
SD) file

# SYNOPSIS

\#include \<esps/esps.h\>\
int\
get_sd_type(hd)\
struct header \*hd;

# DESCRIPTION

*get_sd_type* returns the type of the data in the ESPS sampled-data (SD
or FEA_SD) file for which *hd* is a pointer to the header. The type is
one of the constants DOUBLE, FLOAT, LONG, SHORT, CHAR, BYTE,
DOUBLE_CPLX, FLOAT_CPLX, LONG_CPLX, SHORT_CPLX, BYTE_CPLX. These values
are defined in *\<esps/esps.h\>.*

# DIAGNOSTICS

If *hd* does not point to the header of an SD or FEA_SD file, an error
message is printed and the program is terminated with exit status 1.

# BUGS

None known.

# SEE ALSO

    ESPS(5-ESPS), SD(5-ESPS), set_sd_type(3-ESPSu)

# AUTHOR

Alan Parker
