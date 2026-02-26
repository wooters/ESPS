# NAME

bark_to_hz - Convert a Bark scale value to the equivalent frequency in
Hertz.\
hz_to_bark - Convert a frequency in Hertz to the equivalent Bark-scale
value.

# SYNOPSIS

double\
bark_to_hz (barkValue)\
double barkValue;

\

double\
hz_to_bark (freqValue)\
double freqValue;

# DESCRIPTION

These functions are reciprocal functions that warp a linear-scaled
frequency value in Hertz to the equivalent Bark-scale value and back.

The frequency *f* in hertz corresponding to a Bark-scale value *b* is
given by:

> f = 600 sinh (b/6)

as shown in ref. \[1\]. The conversion from a frequency value to a Bark
scale value is done in the obvious manner by using the inverse
hyperbolic function.

# EXAMPLE


    double bigNumber = MAXFLOAT, hertz, bark;

    /* bark_to_hz can exceed MAXDOUBLE */
    errno = 0;
    hertz = bark_to_hz(bigNumber);
    if (errno)
      perror("bark_to_hz error");

    /* reasonable frequency values are fine */
    hertz = 5000.0;
    bark = hz_to_bark(hertz);
    printf("bark equivalent of 5000 Hz is %f", bark);

    /* This makes the variable hertz = 5000.0 */
    hertz = bark_to_hz(bark);
    printf("bark value converted by to hertz is %f", hertz);

# WARNINGS

In general, these functions should not be used with negative valued
inputs. No checking is done, however, by these functions.

# BUGS

None known.

# SEE ALSO

    mel_to_hz(3-ESPS), hz_to_mel(3-ESPS), barkspec(1-ESPS)

# REFERENCES

\[1\] S. Wang, A. Sekey, and A. Gersho, \`\`An objective measure for
predicting subjective quality of speech coders,'' *IEEE Journal on
Selected Areas in Communications,* **SAC-10** (5), 819-829 (June 1992)

# AUTHOR

Code extracted from *barkspec*(1-ESPS) by David Burton; manual page by
David Burton.
