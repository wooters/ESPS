# NAME

uniq_name - create unique generic header item name by modifying proposed
name

# SYNOPSIS

    #include <esps/esps.h>

    char *
    uniq_name(name_in, names)
    char *name_in;
    char **names;

# DESCRIPTION

*uniq_name* checks a proposed generic header item name *name_in* against
a given list of names *names,* and returns a pointer to a unique name
that it generates. In many cases, *names* are generic header item names
that have already been defined for a particular ESPS file header; such
lists can be obtained using *genhd_list* (3-ESPSu).

If *name_in* is different from any of *names,* then the returned name is
the same as *name_in.* Otherwise, the returned name is is generated from
*name_in* by appending the digit "1" if there is no trailing numerical
string in *name_in,* or by incrementing the trailing number if one
already is present.

uniq_name allocates the memory required for the returned name.

Names created by *uniq_name* are referred to as "incremented names". The
value of *name_in* without any trailing digit is known as the "base
name".

# EXAMPLE

    int  size;
    char *newname;
    float bias;
    char *fieldname = "spec_param";
    /*create "normal" generic header items*/
    (void) add_genhd_f("bias", &bias, sizeof(float), hd);
    (float *) *add_genhd_f("foo", NULL, sizeof(float), hd) = 3*bias + 2.3;
    /*create "incremented" generic header item*/
    newname = uniq_name("quant_field", genhd_list(&size, hd));
    (void) add_genhd_c(newname, fieldname, strlen(fieldname), hd);

# BUGS

None known.

# SEE ALSO

genhd_list(3-ESPSu), add_genhd(3-ESPSu), get_genhd(3-ESPSu),
genhd_type(3-ESPSu)

# AUTHOR

Manual page by John Shore.
