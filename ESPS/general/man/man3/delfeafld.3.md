# NAME

del_fea_fld - delete a field from an ESPS Feature File Header

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>

    int
    del_fea_fld(name, hd)
    char *name;
    struct header *hd;

# DESCRIPTION

*del_fea_fld* deletes the field *name* from the feature file header
pointed to by *hd*. This function is intended to be used following a
*copy_header*(3-ESPSu) if the definition of a field must be changed or
deleted.

This function can only be called after the header *hd* is created (with
*new_header*(3-ESPSu), for example), but before it is written out with
*write_header*(3-ESPSu). This function should only be used on headers to
be written out.

The function returns zero for success and -1 for failure (*name* is not
a field in this file).

# BUGS

None known.

# SEE ALSO

    add_fea_fld(3-ESPSu), get_fea_type(3-ESPSu), get_fea_siz (3-ESPSu),
    allo_fea_rec(3-ESPSu), get_fea_ptr(3-ESPSu), get_fea_rec(3-ESPSu),
    put_fea_rec(3-ESPSu), get_fea_deriv(3-ESPSu), set_fea_deriv(3-ESPSu),
    FEA(5-ESPS)

# AUTHOR

Alan Parker
