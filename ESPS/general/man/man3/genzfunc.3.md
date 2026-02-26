# NAME

    add_genzfunc - create generic header items to store a filter (zfunc)
    get_genzfunc - obtain a filter (zfunc) from generic header items 

# SYNOPSIS

    #include <esps/esps.h>

    void
    add_genzfunc(name, filter, hd)
    char *name;		
    struct zfunc *filter;
    struct header *hd;	

    struct zfunc *
    get_genzfunc(name, hd)
    char *name;		
    struct header *hd;	

# DESCRIPTION

*add_genzfunc* creates three generic header items to store the
information in the zfunc *filter,* and it stores the information in
those header items. *get_genzfunc* obtains information from three
generic header items in *hd*, turns this into a zfunc, and returns a
pointer to the zfunc. The names of the generic header items are based on
the "basename" *name.* The number of numerator coefficients and
denominator coefficients are stored as two values in "*name\_*siz" as
shorts. These coefficients are normally the transfer function
coefficients of a digital filter. The numerator coefficients are stored
in "*name*\_zeros" and the denominator coefficients are stored in
"*name*\_poles" as floats.

*get_genzfunc* returns NULL if "*name\_*siz" is not a defined SHORT
generic header item or its size is not 2. NULL is also returned if
"*name*\_zeros" or "*name*\_poles" is not a defined FLOAT generic or has
a size different from that specified in "*name\_*siz".

# EXAMPLE

    struct header *ana_ih; /*ANA input header*/
    struct header *fea_oh; /*FEA output header*/
    add_genzfunc("pre_emp", ana_ih->hd.ana->pre_emp, fea_oh);

    struct header *fea_ih; /*FEA input header*/
    struct header *ana_oh; /*ANA output header*/
    ana_oh->hd.ana->pre_emp = get_genzfunc("pre_emp", fea_ih);

# BUGS

None known.

# SEE ALSO

    genhd_codes(3-ESPSu), genhd_list(3-ESPSu), genhd_type(3-ESPSu)

# AUTHOR

John Shore
