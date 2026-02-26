# NAME

get_gen_recd - get an arbitrary ESPS record as doubles

# SYNOPSIS

\#include \<esps/esps.h\>\
int\
get_gen_recd(dbuf, tagp, hd, file)\
double \*dbuf;\
long \*tagp;\
struct header \*hd;\
FILE \*file;

# DESCRIPTION

*get_gen_recd* gets the next record (including the tag, if any) from an
ESPS file. All fields in the record are converted to double type.

The data is read from stream *file* into the buffer pointed to by
*dbuf*. The ESPS file header pointed to by *hd* is consulted to
determine the number of elements to read and the types of each. The data
are converted to double if necessary. If the file does not contain tags,
the longword pointed to by *tagp* is set to zero.

The stream is assumed to point to the beginning of a record. It is left
pointing to the subsequent record after the call. The *data* array is
assumed to be large enough to hold a record.

# EXAMPLE

    double data[100];	/* room for 100 samples */
    long tag;
    hd = read_header(file);	/* read header */
    if ((get_gen_recd(data,&tag,hd,file) == EOF) 

# DIAGNOSTICS

EOF is returned on end of file. The number of elements read is returned
otherwise.

# BUGS

None known.

# SEE ALSO

    ESPS(5-ESPS)

# AUTHOR

Joe Buck, Alan Parker
