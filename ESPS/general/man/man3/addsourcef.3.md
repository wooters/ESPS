# NAME

add_source_file - add a source file name and header to header

# SYNOPSIS

void add_source_file(hd, name, srchd)\
struct header \*hd, \*srchd;\
char \*name;

# DESCRIPTION

*add_source_file* inserts a source file name (*name*) and header
(*srchd*) into the next available *variable.source* and
*variable.srchead* positions in the header pointed to by *hd*. The
fields *variable.nnames* and *variable.nheads* are incremented. Only
pointers are copied, so the source fields must not be altered before
*write_header* is called. Note that either *name* or *srchd* may be
NULL. If *name* is NULL, the name "NONE" is added to *variable.source*,
and *srchd* is added to *variable.srchead*. If *srchd* is NULL,
*variable.source* is updated with *name*, but *variable.srchead* is left
unchanged.

If the destination header does not have a foreign header (i.e.
*foreign_hd_length* generic is not defined or it is zero) and the source
header does have *foreign_hd_length* defined and greater than zero and
*foreign_hd_ptr* defined and non-NULL these generics are copied from the
source header to the destination header. This has the side effect of
causing the foreign header of a source file to become a foreign header
of the destination header. Since there can be only one foreign header in
a file, only the first foreign header encountered by *add_source_file*
will be copied.

# EXAMPLE

in_fd = fopen(in_name, "r"); /\* get input file \*/\
out_fd = fopen(out_name, "w"); /\* get output file \*/\
in_hd = read_header(in_fd); /\* read input header \*/\
out_hd = new_header(FT_ANA); /\* make new header\
for output file \*/\
add_source_file(out_hd, in_name, in_hd);\
write_header(out_hd, out_fd); /\* write the new header \*/

# DIAGNOSTICS

There can be MAX_SOURCES included headers and source names. If this is
exceeded, then an error message is printed and the calling program is
terminated. Therefore, application programs should be careful to compare
*variable.nheads* with MAX_SOURCES before trying to add a header and
*variable.nnames* with MAX_SOURCES before trying to add a source name.

# SEE ALSO

    ESPS(5-ESPS), write_header(3-ESPSu), new_header(3-ESPSu), 
    read_header(3-ESPSu), eopen(3-ESPSu), add_comment(3-ESPSu), 
    copy_header(3-ESPSu)

# AUTHOR

Original version by Joe Buck.\
Modified by Alan Parker for new header structures.
