# NAME

write_header - write a ESPS file header out to data file\
inhibit_hdr_date - inhibit updating the header field date

# SYNOPSIS

void write_header (hd,fd)\
struct header \*hd;\
FILE \*fd;

\

void inhibit_hdr_date ()

# DESCRIPTION

*write_header* attempts to write a ESPS file header onto a stream *fd.*
It computes and fills in values for *common.hsize, common.fixsiz, and*
common.check. Normally, it also udpates *common.date* with the current
date and time. If *inhibit_hdr_date* is called prior to *write_header*
then *common.date* is not updated. The next call to *write_header* will
behave normally; that is *inhibit_hdr_date* must be called prior to each
*write_header* call to disable updating *common.date*.

If an I/O error occurs, *write_header* prints a message on stderr and
terminates the calling program. For file types FT_ANA, FT_PIT, FT_ROS,
FT_SPEC, and FT_FILT, *write_header* calls the appropriate function to
fill in the data type fields in the header. For file type FT_SD, the
user program must call *set_sd_type*(3-ESPSu).

If the generic header item *foreign_hd_length* is defined and greater
than zero, and *foreign_hd_ptr* is non-NULL, then *foreign_hd_length*
bytes of memory pointed to by *foreign_hd_ptr* are written to the stream
*fd* after the ESPS header. This would usually be a foreign header which
was created by using *addfeahd*(1-ESPS) or *btosps*(1-ESPS) with the
**-F** option.

# EXAMPLE

hd = new_header (FT_ANA); /\* get a new header \*/\
hd-\>sd.ana-\>order = foo; /\* do something \*/\
fd = fopen (outputfile, "w"); /\* open the new file \*/\
(void) write_header (hd,fd); /\* write the header \*/

Normally, the data records in ESPS files are written in order of the
data type of the elements. All doubles are written first, followed by
floats, longs, shorts, and characters (bytes). For feature files
(FT_FEA) an option is to write the data elements in *field_order*. This
means that the data fields are written to the file in the order that the
fields were created (with *add_fea_fld*). If the program sets the header
item *hd.fea-\>field_order* to YES before calling *write_header* then
the file will be written in field_order. An alternative is for the user
to define the UNIX environment variable *FIELD_ORDER* to any value other
than *off*. If this variable is defined (and does not equal *off*) then
*write_header* will set *hd.fea-\>field_order* to YES before writing the
header to the file. When the file is read back, the ESPS input routines
take note of the value of *hd.fea-\>field_order* and ensure that the
data is correctly read.

# DIAGNOSTICS

There are a number of error messages that might be output to stderr if
parts of the header are bad. The calling program is terminated by
exit(1). Such an error would indicate a programming error.

# BUGS

None known.

# SEE ALSO

eopen(3-ESPSu), new_header(3-ESPSu), read_header(3-ESPSu),
copy_header(3-ESPSu)

# AUTHOR

Original version by Joe Buck.\
Modified by Alan Parker for new header structures.
