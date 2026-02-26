# NAME

phon_to_sone - Convert loudness level in phons to subjective loudness in
sones

# SYNOPSIS

double\
phon_to_sone(phonValue)\
double phonValue;

# DESCRIPTION

The increase in level (phons) needed to double the subjective loudness
is not constant with loudness level. This function nonlinearly
compresses the phon loudness scale in the audible region to better match
the subjective loudness scale (sones). See \[1\] and its references for
details.

The level in *sones* corresponding to a loudness level in *phons* is
given by:

> *soneValue = 2^(phonValue - 40)/10*

The input phon level is in dBs.

# EXAMPLE


    double sone, phon, bigNumber = 10000;

    /* phon_to_sone may exceed MAXDOUBLE */
    errno = 0;
    sone = phon_to_sone(bigNumber);
    if (errno)
      perror("phon_to_sone error");

    /* reasonable frequency values are fine */
    phon = 100;
    sone = phon_to_sone(phon);
    printf("sone equivalent of 100 phons is %f", sone);

# WARNINGS

In general, this function should not be with a negative valued input. No
checking is done, however, by this function.

# BUGS

None known.

# SEE ALSO

    bs_dist(1-ESPS)

# REFERENCES

\[1\] S. Wang, A. Sekey, and A. Gersho, \`\`An objective measure for
predicting subjective quality of speech coders,'' *IEEE Journal on
Selected Areas in Communications,* **SAC-10** (5), 819-829 (June 1992)

# AUTHOR

Code extracted from *bs_dist*(1-ESPS) by David Burton; manual page by
David Burton.
