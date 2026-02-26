# NAME

get_auto - Compute auto-correlation coefficients of a data segment.

# SYNOPSIS

get_auto (data, lnt, r, order)\
float data\[\];\
double r\[\];\
int order, lnt;

# DESCRIPTION

This routine computes the energy, **r\[0\],** and **order** normalized
auto-correlation coefficients **r\[1\]** to **r\[order\]** of a given
data array, **data,** of size **lnt.**

# BUGS

None

# COMMENTS

Routine *get_atal* can be used to obtain reflection coefficients from
the computed auto-correlation coefficients.

# SEE ALSO

get_atal(3-ESPSsp), compute_rc(3-ESPSsp)

# AUTHOR

Shankar Narayan
