# NAME

get_burg - compute reflection coefficients using standard Burg and
modified Bu rg methods.

# SYNOPSIS

get_burg (x, lnt, r, order, c, rc, pgain, method)\
float x\[\], c\[\], rc\[\], \*pgain;\
double r\[\];\
int order, lnt;\
char method;

# DESCRIPTION

This routine computes the reflection coefficients and the lpc filter
coefficients directly from the data using Burg ( or modified Burg)
method.

get_burg function takes data of size **lnt** in array **x\[\]** as input
and computes **order** reflection coefficients, **rc\[1\]** to
**rc\[order\],** **order** lpc filter coefficients, **c\[1\]** to
**c\[order\],** lpc filter gain, **\*pgain,** and signal energy (sum of
squares), **r\[0\],** using Burg method ( **method = 'b'** ) or modified
Burg method ( **method = 'm'** ). For more information on modified Burg
method, refer to \[2\].

# BUGS

None

# SEE ALSO

# REFERENCES

\[1\] L. R. Rabiner and R. W. Schafer, *Digital Processing of Speech
Signals.* Prentice-Hall, NJ. 1978.\
\[2\] ETM-S-86-49:ssn, *Spectrum Analysis of periodic data,* by Shankar
Narayan.

# AUTHOR

Shankar Narayan
