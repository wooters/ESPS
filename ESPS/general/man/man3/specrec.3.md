# NAME

    allo_spec_rec - allocate memory for an ESPS SPEC file record
    get_spec_rec - get the next data record from an ESPS SPEC data file
    print_spec_rec - print an ESPS SPEC data record
    put_spec_rec - put an ESPS SPEC data record onto the file

# SYNOPSIS

\#include \<esps/spec.h\>\
\#include \<esps/header.h\>

\
struct spec_data \*\
allo_spec_rec(hd)\
struct header \*hd;

\
int\
get_spec_rec(data, hd, file)\
struct spec_data \*data;\
struct header \*hd;\
FILE \*file;

\
void\
print_spec_rec(data, hd, file)\
struct spec_rec \*data;\
struct header \*hd;\
FILE \*file;

\
void\
put_spec_rec(data, hd, file)\
struct spec_rec \*data;\
struct header \*hd;\
FILE \*file;

# DESCRIPTION

*allo_spec_rec* allocates memory for a SPEC file record and returns a
pointer to it. The number of elements allocated to *re_spec_val,
im_spec_val,* and *frqs* is\
*hd-\>hd.spec-\>num_freqs*. Since the size of the allocated record
depends on a value in the data file header, it is important to be sure
that a given SPEC record is consistent with the header of the file it is
being used with. The SPEC data read/write routines use this and other
header values to determine the amount of data to read or write. A
mismatch could cause the program to fail in unpredictable ways. It is
not recommended that the same record be allocated for both input and
output (*e.g.* for use with two different headers). If the record is
being allocated for a new file (to be written) then the above mentioned
value in the new header (after *new_header*(3-ESPSu)) must be filled in
before calling *allo_spec_rec.*

*get_spec_rec* reads the next SPEC record from stream *file* into the
data structure pointed to by *data*. The ESPS file header pointed to by
*hd* is consulted for the values of *hd.spec-\>num_freqs,*
hd.spec-\>freq_format, and *hd.spec-\>frame_meth*. The values determine
the size of the data record. See the caution on *allo_spec_rec*. EOF is
returned upon end of file. A positive non-zero value is returned
otherwise.

*print_spec_rec* prints the SPEC record pointed to by *data* onto the
stream *file*. The ESPS header pointed to by *hd* is consulted for the
values of *hd.spec-\>num_freqs,* hd.spec-\>freq_format, and
*hd.spec-\>spec_type*. These values determine the size and format of the
data record. See the caution on *allo_spec_rec*. Only significant values
are printed. For example, *im_spec_val* is not printed unless
*hd.spec-\>spec_type == ST_CPLX*. This function is useful for debug
output in programs which process SPEC data files.

*put_spec_rec* writes a SPEC data record pointed to by *data* onto the
stream *file*, which should be an open ESPS SPEC file. The header must
be written out to the SPEC file before calling this function. The ESPS
file header pointed to by *hd* is consulted for the value of
*hd.spec-\>num_freqs,* hd.spec-\>spec_type, hd.spec-\>freq_format, and
hd.spec-\>frame_meth. The values determine the size of the data record.
See the caution on *allo_spec_rec*.

# EXAMPLE

struct spec_data \*p;\
struct header \*ih;\
ih = read_header(file); /\* read spec file header \*/\
p = allo_spec_rec(ih); /\* allocate record \*/\
x = p-\>re_spec_val\[0\]; /\* record reference \*/\
if(get_spec_rec(p,ih,file) == EOF) *eof...* /\* read a record \*/\
(void) print_spec_record(p,ih,stderr) /\* print the record \*/\
struct header \*oh;\
oh = new_header(FT_SPEC); /\* create file header \*/\
*... fill in some values, including hd.spec-\>num_freqs,*\
hd.spec-\>frame_meth, hd.spec-\>spec_type, hd.spec-\>freq_format...\
(void) write_header(oh,file); /\* write out header \*/\
p = allo_spec_rec(oh); /\* allocate record \*/\
*... fill in desired data record values...*\
(void) put_spec_rec(p,oh,file); /\* write data record \*/

# DIAGNOSTICS

If *hd* does not point to a SPEC header (or an I/O error occurs in
*put_spec_rec* ),then a message is printed on stderr and the program
terminates with exit 1.

# BUGS

None known.

# SEE ALSO

eopen(3-ESPSu), read_header(3-ESPSu), copy_header(3-ESPSu) SPEC(5-ESPS),
ESPS(5-ESPS)

# AUTHOR

Alan Parker
