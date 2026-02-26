# NAME

get_fea_siz - get the size information for a ESPS FEA file field

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>

    long
    get_fea_siz(name, hd, rank, dimen)
    char *name;
    struct header *hd;
    short *rank;
    long **dimen;

# DESCRIPTION

*get_fea_siz* returns the size of the Feature file field *name* in the
header pointed to by *hd*. The size is the number of elements of the
particular data type, not the size in units like bytes or chars. The
function also returns through the pointers *rank* and *dimen* the
information associated with this field from the header items
*hd.fea-\>ranks* and *hd.fea-\>dimens*. *rank* indicates the number of
dimensions the field has (0 for scaler, 1 for vector, 2 for matrix,
etc.). *dimen* is the address of an array of longs that is set to the
dimensions of the field. The size of the array is the equal to the value
of *\*rank*. (see *FEA*(5-ESPS).

If *name* is not a defined field name in the Feature file (or is NULL)
the function returns 0. The function can be called with NULL for *rank*
or *dimen* if that value is not desired.

# EXAMPLE

    short size, rank;
    long *dimen;

    size = get_fea_siz("zeta",hd,&rank,&dimen);

    size = get_fea_siz("zeta",hd,(short *)NULL,(long **)NULL);  /* return only size */

# DIAGNOSTICS

If *hd* does not point to a ESPS Feature file a message is printed and
the program terminates with an exit 1.

# BUGS

None known.

# SEE ALSO

    get_fea_type(3-ESPSu), allo_fea_rec(3-ESPSu),
    add_fea_fld(3-ESPSu), get_fea_ptr(3-ESPSu),
    get_fea_rec(3-ESPSu), put_fea_rec(3-ESPSu),
    get_fea_deriv(3-ESPSu), set_fea_deriv(3-ESPSu)
    FEA(5-ESPS)

# AUTHOR

Alan Parker
