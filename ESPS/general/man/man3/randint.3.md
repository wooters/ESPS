# NAME

    rand_int - compute uniformly distributed integers
    rand_intnr - sample without replacement from uniformly distributed integers

# SYNOPSIS

long\
rand_int(max_int)\
long max_int;

\
rand_intnr(max_int, reset)\
long max_int;\
int reset;

# DESCRIPTION

Each call to *rand_int* returns a random integer uniformly distributed
between zero and *max_int.*

*rand_intnr* provides random sampling without replacement for integers
uniformly distributed between zero and *max_int.* If *reset* is not
equal to zero, *rand_intnr* resets itself so that all integers between
zero and *max_int* are available and sampling without replacement begins
with that call. *rand_intnr* also resets itself automatically on the
very first call as well as after having been called *max_int* times
following the very first call or a call with *reset* = 1. (That is,
*rand_intnr* resets itself when all of the integers in the specified
range have been sampled.)

*rand_int* and *rand_intnr* use *random*(3). *rand_int* and *rand_intnr*
do not set the random seed. Calling programs should set the seed using
*srandom*(3).

# EXAMPLE

\#define MAXVAL 1000\
long seed = 1234567;\
long \*rand_intdata;\
. . .\
(void) srandom(seed);\
for (i = 0; i \< points; i++) rand_intdata\[i\] = rand_int(MAXVAL);

\
\#define MAXVAL 1000\
long seed = 1234567;\
long \*ranvals;\
. . .\
(void) rand_intnr(MAXVAL, 1);\
(void) srandom(seed);\
for (i = 0; i \<= MAXVAL; i++) ranvals\[i\] = rand_intnr(MAXVAL, 0);

# DIAGNOSTICS

None.

# BUGS

None known.

# SEE ALSO

random(3), srandom(3), gauss(3-ESPSsp)

# AUTHOR

manual page by John Shore; program by John Shore
