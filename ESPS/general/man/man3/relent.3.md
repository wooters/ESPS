# NAME

rel_ent - compute relative entropy of two probability distributions

# SYNOPSIS

    double
    rel_ent(q, p, n)
        double  *q, *p;
        int	    n;

# DESCRIPTION

Given two probability distributions *p* and *q,* this function returns
the *relative entropy*

> SUMj qj log qj/pj

of *q* with respect to *p.* Terms of the form 0 log 0 or 0 log 0/0 in
this formula are taken to be 0 by convention.

The arguments *q* and *p* should each be an array of *n* nonnegative
numbers that sum to 1. The argument *n* gives the array lengths.

# DIAGNOSTICS

The function does no error checking. If *p* or *q* is not a probability
distribution - that is, if it has a negative element or if the sum of
its elements is not 1, *rel_ent* simply applies the formula. A floating
exception will occur if *log*(3M) is given a negative argument, or if
there is an index *j* for which pj is 0 but qj is not.

# SEE ALSO

min_rel_ent(3-ESPSsp)

Rodney W. Johnson, ESI
