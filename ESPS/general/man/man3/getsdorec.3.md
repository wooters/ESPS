# NAME

    get_sd_orecd - get overlapping data from an ESPS SD or FEA_SD file in DOUBLE format
    get_sd_orecf - get overlapping data from an ESPS SD or FEA_SD file in FLOAT format
    get_sd_orecs - get overlapping data from an ESPS SD or FEA_SD file in SHORT format

# SYNOPSIS

\#include \<esps/esps.h\>

int\
get_sd_orecd(dframebuf, framelen, nmove, first, hd, file)\
double \*dframebuf;\
int framelen;\
int nmove;\
int first;\
struct header \*hd;\
FILE \*file;

int\
get_sd_orecf(fframebuf, framelen, nmove, first, hd, file)\
float \*fframebuf;\
int framelen;\
int nmove;\
int first;\
struct header \*hd;\
FILE \*file;

int\
get_sd_orecs(sframebuf, framelen, nmove, first, hd, file)\
short \*sframebuf;\
int framelen;\
int nmove;\
int first;\
struct header \*hd;\
FILE \*file;

# DESCRIPTION

Like the *get_sd_rec* functions (*get_sd_recd*(3-ESPS) etc.) the
*get_sd_orec* functions read frames of sampled data from ESPS SD or
single-channel FEA_SD files. However, while *get_sd_rec* moves a full
frame length between calls, *get_sd_orec* moves an arbitrary amount and
is therefore suitable for use by programs that analyze overlapping
frames.

If *first*==1, *get_sd_orec* attempts to read the next *framelen* ESPS
sampled data file records (points) from stream *file* into the buffer
pointed to by *dframebuf*, *fframebuf*, or *sframebuf*, and it returns
the number of valid samples in the buffer. If the return value is less
than *framelen* then the end of the input file has been reached. If the
return value is zero, then there are no valid samples in the buffer. The
ESPS file header pointed to by *hd* is consulted for the type of data in
the file. The data is converted to double, float, or short if necessary.
If fewer than the requested *framelen* points are read (because end of
file is reached), *dframebuf*, *fframebuf*, or *sframebuf* is
zero-filled.

If *first*==0, the contents of *dframebuf*, *fframebuf*, or *sframebuf*
are assumed to contain the sampled data from the previous call.
*Get_sd_orec* then drops the first *nmove* points, shifts the the
remaining contents *nmove* positions to the left (thinking of the
zero-th element as left-most), and then attempts to fill out the buffer
by reading the next *nmove* samples from *file*. It returns the number
of valid samples in the buffer (including previous samples in the buffer
and new ones from the input file). If the return value is less than
*framelen* then the end of the input file has been reached. If the
return value is zero, then there are no valid samples in the buffer
(i.e. nothing more can be read from the input file and all samples have
been shifted out of the buffer). The ESPS file header pointed to by *hd*
is consulted for the type of data in the file. The data is converted to
double, float, or short if necessary. If fewer than the requested
*framelen* points are read (because end of file is reached),
*dframebuf*, *fframebuf*, or *sframebuf* is zero-filled.

If *first*==0 and *nmove*\>=*framelen*, *get_sd_orec* ignores the
contents of *dframebuf*, *fframebuf*, or *sframebuf*, skips
*nmove*-*framelen* points in *file*, and then attempts to read the next
*framelen* points - i.e., after skipping *nmove-framelen* points, it
operates as in the case *first*==0 described above. Note that, if
*nmove*==*framelen*, the net effect is for adjacent, non-overlapping
frames (i.e., same as *get_sd_rec*).

These functions can be called with *nmove* == 0; they simply return
*framelen* and the buffer is not altered.

The file may be either an SD file (see *SD*(5-\SPS)) or a
*single-channel* FEA_SD file (see *FEA_SD*(5-ESPS)). These functions
were originally written for use with the SD file type, which is being
replaced with FEA_SD. Limited FEA_SD support is provided in these
functions to help in converting existing programs from using SD files to
using FEA_SD files. More complete FEA_SD support is provided by the
function *get_feasd_orecs*(3-ESPSu), which should be used in all new
programs.

# EXAMPLE


    double data[100];		/* room for 100 samples */
    hd = read_header(file);	/* read header */
    /*read first 100 samples*/
    first = 1;
    if ((get_sd_orecd(data,100,50,first,hd,file) == 0) 
        error;
    else
        .... /*process first frame*/
    /*shift 50 points into file*/
    first = 0;
    if ((get_sd_orecd(data,100,50,first,hd,file) == 0) 
        error;
    else
        .... /*process next frame*/

# DIAGNOSTICS

If *hd* does not point to the header of an SD file or a single-channel
FEA_SD file, then an error message is printed on stderr, and the program
is terminated with exit status 1. In an SD file, if the header type
information is not set, then an error message is printed on stderr, and
the program is terminated with exit 1. If *nmove*\<0, the program exits
with an assertion error.

# BUGS

None known.

# SEE ALSO

    ESPS(5-ESPS), SD(5-ESPS), FEA_SD(5-ESPS),
    get_sd_recf(3-ESPSu), get_sd_recs(3-ESPSu),
    get_sd_recd(3-ESPSu), get_feasd_recs(3-ESPS),
    get_feasd_orecs(3-ESPS)

# AUTHOR

Manual page by John Shore\
Functions by Alan Parker
