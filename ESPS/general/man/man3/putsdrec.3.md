# NAME

    put_sd_recd - put data onto an ESPS sampled-data file from DOUBLE data
    put_sd_recf - put data onto an ESPS sampled-data file from FLOAT data
    put_sd_recs - put data onto an ESPS sampled-data file from SHORT data

# SYNOPSIS

\#include \<esps/esps.h\>

\
void\
put_sd_recd(dbuf, nsmpls, hd, file)\
double \*dbuf;\
int nsmpls;\
struct header \*hd;\
FILE \*file;

\
void\
put_sd_recf(fbuf, nsmpls, hd, file)\
float \*fbuf;\
int nsmpls;\
struct header \*hd;\
FILE \*file;

\
void\
put_sd_recs(sbuf, nsmpls, hd, file)\
short \*sbuf;\
int nsmpls;\
struct header \*hd;\
FILE \*file;

# DESCRIPTION

The *put_sd_rec* functions write *nsmpls* ESPS sampled-data records
pointed to by *dbuf*, *fbuf*, or *sbuf* onto the stream *file*, which
should be an open ESPS SD file or *single-channel* FEA_SD file. The
header must be written out to the file before calling this function. The
ESPS file header pointed to by *hd* is consulted for the type
representation of the data in the file, and the data is converted if
necessary. The type information must be set in the header before calling
this function; see *set_sd_type*(3-ESPSu) for SD files and
*init_feasd_hd*(3-ESPSu) for FEA_SD files.

These functions were originally written for use with the SD file type,
which is being replaced with FEA_SD. Limited FEA_SD support is provided
in these functions to help in converting existing programs from using SD
files to using FEA_SD files. More complete FEA_SD support is provided by
*put_feasd_recs*(3-ESPSu), which should be used in all new programs.

# EXAMPLE

double data\[100\]; /\* room for 100 samples \*/\
(void) put_sd_recd(data, 100, hd, file);/\* write them out \*/\

# DIAGNOSTICS

If *hd* does not point to the header of an SD or single-channel FEA_SD
file, then an error message is printed on *stderr,* and the program is
terminated with exit status 1. In an SD file, if the type of the data in
the output file hasn't been set yet, then an error message is printed on
*stderr,* and the program terminates with exit status 1. A file error
will cause a message to be printed on stderr, and the program will
terminate with exit status 1.

# SEE ALSO

ESPS(5-ESPS), SD(5-ESPS), FEA_SD(5-ESPS),\
set_sd_type(3-ESPSu), init_feasd_hd(3-ESPSu), put_feasd_recs(3-ESPSu),
get_feasd_recs(3-ESPS), get_feasd_orecs(3-ESPS)

# AUTHOR

Alan Parker
