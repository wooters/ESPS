# NAME

new_zfunc - creates a new zfunc structure

# SYNOPSIS

\#include \<esps/esps.h\>\
struct zfunc \*\
new_zfunc (ns, ds, num, den)\
int ns, ds;\
float \*num, \*den;

# DESCRIPTION

*new_zfunc* creates a new zfunc structure from dynamic memory. (The
zfunc structure is defined in ESPS(5-ESPS)). Memory is allocated to
store *ns* numerator coefficients and *ds* denominator coefficients of a
filter transfer function.

# EXAMPLE


    struct zfunc *z;
    float *num = { 1.0, 0.5 };
    float *den = { .78, -0.94, -0.32 };

    z = new_zfunc (2, 3, num, den);

# DIAGNOSTICS

None.

# BUGS

None known.

# SEE ALSO

add_genzfunc(3-ESPSu), get_genzfunc(3-ESPSu), ESPS(5-ESPS)

# AUTHOR

Man page by Ajaipal S. Virdy, Entropic Speech, Inc.
