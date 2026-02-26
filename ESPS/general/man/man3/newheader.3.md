# NAME

new_header - create a new, all zero ESPS header structure

# SYNOPSIS

struct header \*\
new_header (type)\
int type;

# DESCRIPTION

*new_header* allocates memory for a new ESPS header structure and
returns a pointer to the header. If *type* is zero, then only the part
of the header common to all ESPS header types is allocated. If *type* is
one of the legal ESPS file types (as defined in *\<esps/ftype.h\>*) then
the type specific part of type *type* is allocated. If *type* is
non-zero and not a legal ESPS file type, then the function returns NULL.

The current version number of *\<esps/header.h\>* is put in
*common.hdvers* and the type of the header is put in *common.type*. The
current machine type code is put into *common.machine_code*.

The case of *type* equal zero is intended primarily for use by the other
header routines. There is no function provided to application programs
to allocate the type specific part of the header.

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

If the program needs to force the output data representation format,
then it can reset the value of *common.edr*.

This function is usually used to create a header that is to be written
with *write_header(3)*. If it is used to create a header that is
immediately used with the ESPS input routines to read a file, then care
must be taken to insure that all required header items are filled in.

# EXAMPLE

if (hd = new_header(FT_FEA) == NULL) *error...*\
hd-\>common.type /\* had better be FT_FEA \*/

# DIAGNOSTICS

None.

# BUGS

None known.

# SEE ALSO

    eopen(3-ESPSu), copy_header(3-ESPSu), read_header(3-ESPSu),
    write_header(3-ESPSu)

# AUTHOR

Original version by Joe Buck.\
Modified by Alan Parker for new header structures.
