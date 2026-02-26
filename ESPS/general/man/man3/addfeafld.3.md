# NAME

add_fea_fld - add definition of new field to ESPS FEA file header

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>

    int
    add_fea_fld(name, size, rank, dimen, type, enums, hd)
    char *name;
    long size;
    long *dimen;
    short rank, type;
    char **enums;
    struct header *hd;

# DESCRIPTION

*add_fea_fld* creates a new field in the in the ESPS Feature file
pointed to by *hd*. The name of the field is given by *name*. See
FEA(5-ESPS) for the meaning of the arguments *size, rank, dimen,* type,
and *enums*. Note that \**dimen* has to remain "alive" after the call to
*add_fea_fld*, and can only be freed after all calls to *allo_fea_rec*
(3-ESPSu).

The function returns 0 on success and -1 if *name* is already defined as
a field in this file.

If *type* is not **CODED** then **NULL** should be given for the
argument *enums*. If *rank* is less than 2, then **NULL** should be
given for the argument *dimen*.

This function should be called after the header *hd* is created and
before it is written out with the function *write_header*(3-ESPSu). This
function should only be used on headers to be written out.

# EXAMPLE

    /* create a short item of size 1 */
    if(add_fea_fld("short1",1,0,NULL,SHORT,NULL,hd) == -1) trouble...

# BUGS

None known.

# SEE ALSO

    get_fea_type (3-ESPSu), get_fea_siz (3-ESPSu), 
    allo_fea_rec (3-ESPSu), get_fea_ptr (3-ESPSu), 
    get_fea_rec (3-ESPSu), put_fea_rec (3-ESPSu), 
    get_fea_deriv (3-ESPSu), set_fea_deriv (3-ESPSu), 
    FEA(5-ESPS)

# AUTHOR

Alan Parker
