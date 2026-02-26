# NAME

    allo_scbk_rec - allocate memory for SCBK file record
    get_scbk_rec - get the next data record from an ESPS SCBK data file
    print_scbk_rec - print an ESPS SCBK data record
    put_scbk_rec - put an ESPS SCBK data record onto the file

# SYNOPSIS

\#include \<esps/scbk.h\>\
struct scbk_data \*\
allo_scbk_rec(hd)\
struct header \*hd;

\
\#include \<esps/scbk.h\>\
int\
get_scbk_rec(data, hd, file)\
struct scbk_data \*data;\
struct header \*hd;\
FILE \*file;

\
void\
print_scbk_rec(data, hd, file)\
struct scbk_data \*data;\
struct header \*hd;\
FILE \*file;

\
\#include \<esps/scbk.h\>\
void\
put_scbk_rec(data, hd, file)\
struct scbk_data \*data;\
struct header \*hd;\
FILE \*file;

# DESCRIPTION

*allo_scbk_rec* allocates memory for an SCBK file record and returns a
pointer to it. The number of elements allocated to *cswd_dist*,
*final_pop*, and *qtable* is given by the header item
*hd.scbk-\>num_cdwds*. Since the size of the allocated record depends on
a value in the data file header, it is important to be sure that a given
SCBK record is consistent with the header of the file it is being used
with. The SCBK data read/write routines use this same value in the
header to determine the amount of data to read or write. A mismatch
could cause the program to fail in unpredictable ways. It is possible to
allocate only one record, for both input and output, if the programmer
is certain that the value of *hd.scbk-\>num_cdwds* is the same in both
the input and output files. If the record is being allocated for a new
file (to be written), then *hd.scbk-\>num_cdwds* in the new header
(after *new_header*(3-ESPSu)) must be filled in before calling
*allo_scbk_rec.*

*get_scbk_rec* reads the next SCBK record from stream *file* into the
data structure pointed to by *data*. The ESPS file header pointed to by
*hd* is consulted for the value of *hd.scbk-\>num_cdwds*. This value
determines the size of the data record. See the caution on
*allo_scbk_rec*. EOF is returned upon end of file. A positive non-zero
value is returned otherwise.

*print_scbk_record* prints the SCBK record pointed to by *data* onto the
stream *file*. The ESPS header pointed to by *hd* is consulted for the
value of *hd.scbk-\>num_cdwds*. This value determines the size of the
data record. See the caution on *allo_scbk_rec*. This function is useful
for debug output in programs which process SCBK data files.

*put_scbk_rec* writes an SCBK data record pointed to by *data* onto the
stream *file*, which should be an open ESPS SCBK file. The header must
be written out to the SCBK file before calling this function. The ESPS
file header pointed to by *hd* is consulted for the value of
*hd.scbk-\>num_cdwds*. This value determines the size of the data
record. See the caution on *allo_scbk_rec*.

# EXAMPLE

struct scbk_data \*p;\
struct header \*ih;\
ih = read_header(file); /\* read scbk file header \*/\
p = allo_scbk_rec(ih); /\* allocate record \*/\
if(get_scbk_rec(p,ih,file) == EOF) *eof...* /\* read a record \*/\
x = p-\>final_dist; /\* record reference \*/\
(void) print_scbk_record(p,ih,stderr) /\* print the record \*/

\
struct header \*oh;\
oh = new_header(FT_SCBK); /\* create file header \*/\
*... fill in some values, including hd.scbk-\>num_cdwds...*\
(void) write_header(oh,file); /\* write out header \*/\
p = allo_scbk_rec(oh); /\* allocate record \*/\
*... fill in desired data record values...*\
(void) put_scbk_rec(p,oh,file); /\* write data record \*/

# DIAGNOSTICS

If *hd* does not point to a SCBK header then a message is printed on
stderr and the program terminates with exit 1. If the value of
*hd.scbk-\>num_cdwds* is less than 1, a message is printed on stderr and
the program terminates with exit 1. If an I/O error occurs during write
in *put_scbk_rec,* a message is output to standard error and the program
exits with status 1.

# BUGS

None known.

# SEE ALSO

eopen(3-ESPSu), read_header(3-ESPSu), copy_header(3-ESPSu),
SCBK(5-ESPS), ESPS(5-ESPS)

# AUTHOR

Alan Parker
