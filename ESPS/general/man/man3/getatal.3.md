# NAME

get_atal - get reflection coefficients from auto-correlations using
Levinson.

# SYNOPSIS

get_atal (r, order, c, rc, pgain)\
float c\[\], rc\[\], \*pgain;\
double r\[\];\
int order;

# DESCRIPTION

This routine computes the reflection coefficients, **rc\[1\], ...,
rc\[order\],** and the lpc filter coefficients, **c\[1\], ...,
c\[order\],** corresponding to the given set of normalized
auto-correlation coefficients, **r\[1\], ..., r\[order\],** using
standard Levinson's algorithm. If stability problem is encountered in
the computation of reflection coefficient **rc\[k\],** the reflection
coefficients **rc\[k\]** to **rc\[order\]** are set to zero and a
message is displayed on *stderr.*

# BUGS

None

# COMMENTS

The auto-correlation coefficients needed can be obtained from the data
using *get_auto* function. The maximum value of **order** allowed is
1000. User should be aware of it.

# FUTURE CHANGES

The restriction on **order** will be removed. If instability is noticed
during Levinson recursion, this information should be transmitted back
to the calling program by appropriately changing the parameter
**order.**

# SEE ALSO

get_auto (3-ESPSsp).

# REFERENCES

\[1\] L. R. Rabiner and R. W. Schafer, *Digital Processing of Speech
Signals.* Prentice Hall, NJ. 1978.

# AUTHOR

Shankar Narayan
