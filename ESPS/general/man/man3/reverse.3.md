# NAME

long_reverse - reverse the bytes in a long integer.

short_reverse - reverse the bytes in a short integer.

# SYNOPSIS

\
long long_reverse (l);\
long l;\
short short_reverse (s);\
short s;

# DESCRIPTION

*long_reverse* returns the value which results from reversing the order
of the bytes in *l.* *short_reverse* returns the value which results
from reversing the order of the bytes in *s.* These functions are useful
in converting between machine dependent data formats.

# EXAMPLE


    long l; lswap;
    short s, sswap;

    lswap = long_reverse (l);
    sswap = short_reverse (s);

# DIAGNOSTICS

None.

# BUGS

None known.

# AUTHOR

Brian Sublett
