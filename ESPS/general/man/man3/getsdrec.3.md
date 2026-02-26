# NAME

    get_sd_recd - get data from an ESPS sampled-data file in DOUBLE format
    get_sd_recf - get data from an ESPS sampled-data file in FLOAT format
    get_sd_recs - get data from an ESPS sampled-data file in SHORT format

# SYNOPSIS

\#include \<esps/esps.h\>

int\
get_sd_recd(dbuf, nsmpls, hd, file)\
double \*dbuf;\
int nsmpls;\
struct header \*hd;\
FILE \*file;

int\
get_sd_recf(fbuf, nsmpls, hd, file)\
float \*fbuf;\
int nsmpls;\
struct header \*hd;\
FILE \*file;

int\
get_sd_recs(sbuf, nsmpls, hd, file)\
short \*sbuf;\
int nsmpls;\
struct header \*hd;\
FILE \*file;

# DESCRIPTION

The *get_sd_rec* functions attempt to read the next *nsmpls* ESPS
sampled-data records from stream *file* into the buffer pointed to by
*dbuf*, *fbuf*, or *sbuf*, and they return the actual number of samples
read. If no samples are read (end of file), zero is returned. The ESPS
file header pointed to by *hd* is consulted for the type of data in the
file. The data is converted to double, float, or short if necessary. If
fewer than the requested *nsmpls* points are read (because end of file
is reached), *dbuf*, *fbuf*, or *sbuf* is zero-filled.

The file may be either an SD file (see *SD*(5-ESPS)) or a
*single-channel* FEA_SD file (see *FEA_SD*(5-ESPS)). These functions
were originally written for use with the SD file type, which is being
replaced with FEA_SD. Limited FEA_SD support is provided in these
functions to help in converting existing programs from using SD files to
using FEA_SD files. More complete FEA_SD support is provided by the
function *get_feasd_recs*(3-ESPSu), which should be used in all new
programs.

# EXAMPLE

double data\[100\]; /\* room for 100 samples \*/\
hd = read_header(file); /\* read header \*/\
if ((get_sd_recd(data,100,hd,file) == 0) *eof or problem ...*\

# DIAGNOSTICS

If *hd* does not point to the header of an SD file or a single-channel
FEA_SD file, then an error message is printed on stderr, and the program
is terminated with exit status 1. In an SD file, if the header type
information is not set, then an error message is printed on stderr, and
the program is terminated with exit status 1.

# BUGS

None known.

# SEE ALSO

    ESPS(5-ESPS), SD(5-ESPS), FEA_SD(5-ESPS),
    get_sd_orecf(3-ESPSu), get_sd_orecs(3-ESPSu),
    get_sd_orecd(3-ESPSu), get_feasd_recs(3-ESPS),
    get_feasd_orecs(3-ESPS)

# AUTHOR

Alan Parker
