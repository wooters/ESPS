# NAME

fea_encode - get code corresponding to string for coded field in ESPS
FEA file

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>

    short
    fea_encode(str, name, hd)
    char *str;
    char *name;
    struct header *hd;

# DESCRIPTION

*fea_encode* returns the numeric value corresponding to the character
string *str* in the value space of Feature file field *name* in the
header pointed to by *hd*. If *str* is not a possible value for *name*
then -1 is returned. If *name* is not defined as a CODED field in *hd*
then -2 is returned.

# EXAMPLE

Assume field name *zeta* was created as a field of type coded with
possible values "ZA", "ZB", and "ZC" in ESPS feature file *hd*. "ZA"
corresponds to a value of 0, "ZB" corresponds to a value of 1, and "ZC"
corresponds to a value of 2. Calling:


    value = fea_encode("ZB","zeta",hd);

will return 1.

# SEE ALSO

    allo_fea_rec(3-ESPSu), add_fea_fld(3-ESPSu), get_fea_deriv(3-ESPSu),
    get_fea_ptr(3-ESPSu), fea_decode(3-ESPSu), set_fea_deriv(3-ESPSu), 
    FEA(5-ESPS)
