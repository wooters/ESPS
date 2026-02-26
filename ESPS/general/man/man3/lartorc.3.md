# NAME

    lar_to_rc - convert log area ratio to reflection coefficient
    rc_to_lar - convert reflection coefficient to log area ratio

# SYNOPSIS

float\
lar_to_rc(lar)\
double lar;

\
int\
rc_to_lar(rc, lar)\
double rc; float \*lar;

# DESCRIPTION

*lar_to_rc* converts the log area ratio *lar* to a reflection
coefficient *rc* according to the formula:


    	rc = [(A - 1)/(A + 1)]

where *A* is the antilog (base 10) of *lar.*

*rc_to_lar* converts the reflection coefficient *rc* to a log area ratio
*lar* according to the formula


    	lar = log [(1 + rc)/(1 - rc)]

where the logarithm is to base 10. If -1 \< *rc* \< +1, the value
returned in *lar* is computed according to the formula above and
*rc_to_lar* returns the value 0.

*rc* \>= 1, the value returned in *lar* is the system's maximum floating
point value. If *rc* \<= -1, the value returned in *lar* is the system's
maximum negative floating point value. In both of these cases,
*rc_to_lar* returns the value 1.

# EXAMPLE

float refco, logratio;\
refco = lar_to_rc(logratio);

float refco, logratio;\
if (rc_to_lar(refco, &logratio) != 0)\
fprintf(stderr, "WARNING - reflection coefficient out of range.\n");

# DIAGNOSTICS

None, other than the function return value.

# BUGS

None known.

# SEE ALSO

    larcbk2rc(1-ESPS)

# AUTHOR

Manual page by John Shore
