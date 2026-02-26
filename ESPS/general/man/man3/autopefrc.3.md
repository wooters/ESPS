# NAME

auto_pefrc - convert autocorrelations to prediction error filter and
reflection coefficients

pef_autorc - convert prediction error filter coefficients to
autocorrelations and reflection coefficients

rc_autopef - convert reflection coefficients to autocorrelations and
prediction error filter coefficients

# SYNOPSIS

int\
auto_pefrc (order, auto, pef, rc)\
int order;\
double \*pef, \*auto, \*rc;

\
int\
pef_autorc (order, pef, auto, rc)\
int order;\
double \*pef, \*auto, \*rc;

\
int\
rc_autopef (order, rc, auto, pef)\
int order;\
double \*pef, \*auto, \*rc;

# DESCRIPTION

Each function transforms a set of coefficients that contain spectral
information (either autocorrelations, prediction error filter
coefficients, or reflection coefficients) into the other two coefficient
sets.

*auto_pefrc* transforms *order* + 1 autocorrelations into the mean
square residual (stored in *pef\[0\]* and *rc\[0\]*) and *order*
prediction error filter (*pef*) coefficients and *order* reflection
coefficients (*rc*). The prediction error filter coefficients and the
reflection coefficients are stored in the 1st through *order* positions
of *pef\[\]* and *rc\[\],* respectively.

*pef_autorc* transforms the mean square residual (stored in *pef\[0\]*)
and *order* prediction error filter coefficients into *order* + 1
autocorrelations (stored in positions 0 through *order*) and *order*
reflection coefficients (stored in position 1 through *order*).

*rc_autopef* transforms the mean square residual (stored in *rc\[0\]*)
and *order* reflection coefficients into *order* + 1 autocorrelations
(stored in positions 0 through *order*) and *order* prediction error
filter coefficients (stored in positions 1 through *order*).

# DIAGNOSTICS

All functions return 0 if no problem is discovered in the input data or
in the parameter transformation. If the mean square residual \<=0, then
-1 is returned; if any reflection coefficient \>= 1., then the index of
the invalid coefficient is returned.

# SEE ALSO

refl_to_filter(3-ESPSsp), get_atal(3-ESPSsp), refl_to_auto(3-ESPSsp)

# WARNINGS

Remember, the calling routine must allocate memory for *order* + 1
elements for each of the three pointers *\*auto, \*pef,* and *\*rc.*

# AUTHOR

Code by John P. Burg; ESPS modification by David Burton; manual page by
David Burton.
