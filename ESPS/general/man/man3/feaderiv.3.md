# NAME

    get_fea_deriv - see if FEA field is derived, and get source fields
    set_fea_deriv - declare FEA field to be derived and give source fields

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>

    char **
    get_fea_deriv(name, hd)
    char *name;
    struct header *hd;

    int
    set_fea_deriv(name, srcfields, hd)
    char *name;
    char **srcfields;
    struct header *hd;

# DESCRIPTION

*get_fea_deriv* is called with the header to an ESPS feature file and a
name of a field in that file. If the field is a derived field,
*get_fea_deriv* returns the list of source fields. If *name* is not a
derived field, or is not a field in the feature file, then the function
returns NULL. See *FEA(5-ESPS)* for a detailed discussion of the meaning
and format of *srcfields.*

*set_fea_deriv* declares an existing FEA file field to be derived and
provides a list of source fields. The name of the field is given by
*name*, and the source fields are given by *srcfields.* See
*FEA(5-ESPS)* for a detailed discussion of the meaning and format of
*srcfields.* The function returns 0 on success and -1 if *name* is not
defined as a field in this file. This function should be called after
the header *hd* is created and fields are defined with
*add_fea_fld*(3-ESPSu), but before using *write_header*(3-ESPSu). This
function should only be used on headers to be written out.

# EXAMPLE


    if((svecsrces = get_fea_deriv("svector", hd) != NULL) /*print source fields*/
        for (i = 0; svecsrces[i] != NULL; i++) 
    	fprintf(stdout, "%s\n", svecsrces[i]);

    char *svecsrces[] = {"raw_power[0]", "spec_param[1,3:5]", NULL};
    /* create a short item of size 5 */
    if(add_fea_fld("svector",1,0,NULL,SHORT,NULL,hd) == -1) trouble...
    if(set_fea_deriv("svector", svecsrces, hd) == -1) trouble...

# BUGS

None known.

# SEE ALSO

    add_fea_fld(3-ESPSu), allo_fea_rec(3-ESPSu), get_fea_rec(3-ESPSu),
    get_fea_ptr(3-ESPSu), put_fea_rec(3-ESPSu), FEA(5-ESPS)

# AUTHOR

Manual page by John Shore.
