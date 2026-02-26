# NAME

get_fea_ptr - get pointer to storage for field in FEA file record

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>

    char *
    get_fea_ptr(rec, name, hd)
    struct fea_data *rec;
    char *name;
    struct header *hd;

# DESCRIPTION

*get_fea_ptr* returns a pointer to the data associated with a field
(*name*) in the ESPS Feature file pointed to by *hd* at record *rec*.
The function returns type (char \*) and it must be coerced to the
correct type.

If *name* is not a defined field name in the Feature file (or is NULL)
the function returns NULL.

This function must be called after *allo_fea_rec*(3-ESPSu) and need not
be called more than once for any given record-header set.

# EXAMPLE

    short *sp;
    struct fea_data *rec;

    /* allocate a record */
    rec = allo_fea_rec(hd);

    /* get a pointer to the data for "short1" */
    sp = (short *)get_fea_ptr(rec,"short1",hd);

    /* get a record */
    if(get_fea_rec(rec,hd,file) == EOF)  eof ...

    /* access the data */
    alpha = *sp + 100;

# DIAGNOSTICS

If *hd* does not point to a ESPS Feature file or *rec* is NULL a message
is printed and the program terminates with an exit 1.

# BUGS

None known.

# SEE ALSO

    allo_fea_rec(3-ESPSu), add_fea_fld(3-ESPSu), get_fea_deriv(3-ESPSu),
    get_fea_rec(3-ESPSu), put_fea_rec(3-ESPSu), set_fea_deriv(3-ESPSu),
    FEA(5-ESPS)

# AUTHOR

Alan Parker
