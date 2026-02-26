# NAME

fea_decode - get string corresponding to code for coded field in ESPS
FEA file

# SYNOPSIS

    #include <esps/esps.h>
    #include <esps/fea.h>

    char *
    fea_decode(code, name, hd)
    short code;
    char *name;
    struct header *hd;

# DESCRIPTION

*Fea_decode* returns a pointer to a character string corresponding to
value *code* in the value space of Feature file field *name* in the file
pointed to by *hd*.

The returned value is a character pointer to the CODED value string in
the header *hd*. Bad things could happen the area pointed to is
modified.

NULL is returned if *code* is out of the range of the values for *name*
or if *name* is not a valid CODED field in this file.

# EXAMPLE

Assume field name *zeta* was created as a field of type coded with
possible values "ZA", "ZB", and "ZC" in ESPS feature file *hd*. "ZA"
corresponds to a value of 0, "ZB" corresponds to a value of 1, and "ZC"
corresponds to a value of 2. Calling:

    char *s;

    s = fea_decode(2, "zeta", hd);

will return a pointer to "ZC".

# SEE ALSO

    allo_fea_rec(3-ESPSu), add_fea_fld(3-ESPSu), get_fea_deriv(3-ESPSu),
    get_fea_ptr(3-ESPSu), fea_encode(3-ESPSu), set_fea_deriv(3-ESPSu),
    FEA(5-ESPS)
