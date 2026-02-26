# NAME

copy_fea_fields - replicate all feature field definitions

# SYNOPSIS

\#include \<esps/fea.h\>\
int\
copy_fea_fields(hd1, hd2)\
struct header \*hd1;\
struct header \*hd2;

# DESCRIPTION

*copy_fea_fields* attempts to add a field definition to *hd1* for each
record field found in *hd2*. That is, for each field definition in
*hd2*, a corresponding field with the same name, size, rank, etc. is
created in *hd1* (see FEA(5-ESPS) for details concerning feature field
definitions). Only the field definitions are copied, not the actual data
contents of the fields.

If the source file header (*hd2*) indicates that the file is segment
labeled, the destination file header (*hd1*) is marked as segment
labeled.

If a field with a particular name and size cannot be created in *hd1*,
the program prints a warning message and exits. The program prints a
message on stderr and terminates if either *hd1* or *hd2* do not point
to ESPS Feature File headers.

# DIAGNOSTICS

    copy_fea_fields: dest is NULL.
    copy_fea_fields: dest not FEA.
    copy_fea_fields: src is NULL.
    copy_fea_fields: src not FEA.
    copy_fea_fields: couldn't add field to dest header.

# BUGS

None known.

# SEE ALSO

    add_fea_fld(3-ESPSu), copy_fea_rec(3-ESPSu), 
    copy_fea_fld(3-ESPSu), FEA(5-ESPS)

# AUTHOR

Man page by David Burton.
