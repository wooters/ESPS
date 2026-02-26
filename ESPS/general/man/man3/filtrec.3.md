# NAME

    allo_filt_rec - allocate memory for FILT file record
    get_filt_rec - get the next data record from an ESPS FILT data file
    print_filt_rec - print an ESPS FILT data record
    put_filt_rec - put an ESPS FILT data record onto the file

# SYNOPSIS

\#include \<esps/filt.h\>\
struct filt_data \*\
allo_filt_rec(hd)\
struct header \*hd;

\
\#include \<esps/filt.h\>\
int\
get_filt_rec(data, hd, file)\
struct filt_data \*data;\
struct header \*hd;\
FILE \*file;

\
void\
print_filt_rec(data, hd, file)\
struct filt_data \*data;\
struct header \*hd;\
FILE \*file;

\
\#include \<esps/filt.h\>\
void\
put_filt_rec(data, hd, file)\
struct filt_data \*data;\
struct header \*hd;\
FILE \*file;

# DESCRIPTION

*allo_filt_rec* allocates memory for an FILT file record and returns a
pointer to it. The number of items allocated to *filt_func.zeros* is the
value of FILT header item *max_num*, and the number of items allocated
to *filt_func.poles* is the value of FILT header item *max_den*. Since
the size of the allocated record depends on values in the data file
header, it is important to be sure that a given FILT record is
consistent with the header of the file it is being used with. The FILT
data read/write routines use these same values in the header to
determine the amount of data to read or write. A mismatch could cause
the program to fail in unpredictable ways. It is possible to allocate
only one record, for both input and output, if the programmer is certain
that the values of *hd.filt-\>max_num* and *hd.filt-\>max_den* are the
same in both the input and output files. If the record is being
allocated for a new file (to be written), then the above mentioned
values in the new header (after calling *new_header*(3-ESPSu)) must be
filled in before calling *allo_filt_rec.*

*get_filt_rec* reads the next FILT record from stream *file* into the
data structure pointed to by *data*. The ESPS file header pointed to by
*hd* is consulted for the values of *hd.filt-\>max_num* and
*hd.filt-\>max_den*. These values determine the size of the data record.
See the caution on *allo_filt_rec*. EOF is returned upon end of file. A
positive non-zero value is returned otherwise.

*print_filt_record* prints the FILT record pointed to by *data* onto the
stream *file*. The ESPS header pointed to by *hd* is consulted for the
values of *hd.filt-\>max_num* and *hd.filt-\>max_den*. The values
determine the size of the data record. See the caution on
*allo_filt_rec*. This function is useful for debug output in programs
which process FILT data files.

*put_filt_rec* writes an FILT data record pointed to by *data* onto the
stream *file*, which should be an open ESPS FILT file. The header must
be written out to the FILT file before calling this function. The ESPS
file header pointed to by *hd* is consulted for the values of
*hd.filt-\>max_num* and *hd.filt-\>max_den*. The values determine the
size of the data record. See the caution on *allo_filt_rec*.

# EXAMPLE

struct filt_data \*p;\
struct header \*ih;\
ih = read_header(file); /\* read filt file header \*/\
p = allo_filt_rec(ih); /\* allocate record \*/\
foo = p-\>filt_func.zeros\[1\]; /\* record reference \*/\
if(get_filt_rec(p,ih,file) == EOF) *eof...* /\* read a record \*/\
print_filt_record(p,ih,stderr) /\* print the record \*/

\
struct filt_data \*p;\
struct header \*oh;\
oh = new_header(FT_FILT); /\* create file header \*/\
*... fill in some values, including hd.filt-\>max_num and*
hd.filt-\>max_den ...\
(void) write_header(oh,file); /\* write out header \*/\
p = allo_filt_rec(oh); /\* allocate record \*/\
*... fill in desired data record values...*\
(void) put_filt_rec(p,oh,file); /\* write data record \*/

# DIAGNOSTICS

If *hd* does not point to a FILT header then a message is printed on
stderr and the program terminates with exit 1. If an I/O error occurs
during write in *put_filt_rec,* a message is output to standard error
and the program exits with exit 1.

# BUGS

None known.

# SEE ALSO

    eopen(3-ESPSu), read_header(3-ESPSu), FILT(5-ESPS), ESPS(5-ESPS)

# AUTHOR

Alan Parker
