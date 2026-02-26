# NAME

gauss - compute zero-mean, unit standard-deviation Gaussian random
number

# SYNOPSIS

float\
gauss()

# DESCRIPTION

*gauss* returns zero-mean, unit standard-deviation (RMS amplitude)
gaussian distributed floats. It uses *random*(3) to generate
uniformly-distributed values and transforms these to
Gaussian-distributed values. *gauss* does not set the random seed so
that calling programs can do so. Calling programs should set the seed
using *srandom*(3).

# EXAMPLE

long seed = 1234567;\
float \*gaussdata;\
int n;\
. . .\
(void) srandom(seed);\
for (i = 0; i \< points; i++) gaussdata\[i\] = gauss();

# DIAGNOSTICS

None.

# BUGS

None known.

# SEE ALSO

random(3), srandom(3), testsd(1-ESPS)

# AUTHOR

John Shore (modified a routine by Shankar Narayan)
