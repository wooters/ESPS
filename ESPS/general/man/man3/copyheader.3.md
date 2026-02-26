# NAME

copy_header - copies an ESPS file header to a new header of the same
type

# SYNOPSIS

struct header \*\
copy_header(src)\
struct header \*src;

# DESCRIPTION

*copy_header* allocates memory for a new ESPS file header of the same
type as *src*. All values from the type specific part of the header are
copied from the source header to the new header. All values, except
*common.prog,* common.vers, common.date, common.progdate, common.hdvers,
common.edr and *hd.fea-\>field_order* (assuming the file is a feature
file) are copied from the source header to the new header. The item
*common.hdvers* is filled in with the current version of
*\<esps/header.h\>*. Except for *common.edr* the others mentioned here
are cleared. The values of *variable.refer and* *variable.typtxt* are
copied from the variable part of the header. All generic header items
are copied.

If the Unix environment variable **ESPS_EDR** is defined and has a value
of *on*, then the header item *common.edr* is set to YES, which means
that this data file will be written to the disk in Entropic's external
data representation (EDR). Otherwise the file is written in the host
machine's native data format. The default action is not to have
**ESPS_EDR** defined and to write files in native format. File written
with *common.edr* *on* can be read by any ESPS implementation on any
supported machine. Files written in native format will be more efficient
on some machines, but might not be usable on all ESPS implementations.
That is, all implementations can read both their own representation and
EDR. In addition, some implementations can read their own format, EDR,
and other formats (for example SPARC and 680X0 machines can read files
in EDR, their own native, SUN 386i, and the DEC DS3100 (MIPs CPU)).

Since all generic header items are copied, if the items
*foreign_hd_length* and *foreign_hd_ptr* are defined in the source
header they will be copied to the desitnation header. This has the side
effect of copying the foreign header block when the destination header
is written out. If it is desired to not copy the foreign header, then
change the value of the *foreign_hd_length* generic to zero in the
destination header after *copy_header* is called and before
*write_header* is called.

# EXAMPLE

b_hd = copy_header(a_hd) /\* copy header a to header b \*/

# DIAGNOSTICS

None.

# BUGS

None known.

# SEE ALSO

    add_source_file(3-ESPSu), add_comment(3-ESPSu), comment(1-ESPS)
    copy_genhd(3-ESPSu), eopen(3-ESPSu), new_header(3-ESPSu), 
    read_header(3-ESPSu), write_header(3-ESPSu)

# AUTHOR

Original version by Joe Buck.\
Modified by Alan Parker for new header structures.
