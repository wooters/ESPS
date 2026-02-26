# NAME

mel_to_hz - Convert a mel-scale value to the equivalent frequency in
Hertz.\
hz_to_mel - Convert a frequency value in Hertz to the equivalent
mel-scale value.

# SYNOPSIS

double\
mel_to_hz (melValue)\
double melValue;

\

double\
hz_to_mel (freqValue)\
double freqValue;

# DESCRIPTION

These functions are reciprocal functions that warp a linear-scaled
frequency value in Hertz to the equivalent mel-scale value and back.

The mel-scale value *m* corresponding to a frequency value in Hertz *f*
is given by:

> m = 1127.01 log (1 + f/700)

where the constant shown as 1127.01 is actually 1000/log(1700/700), a
value chosen so that 1000 mel corresponds to 1000 Hz. (There is no
single universally accepted definition of the mel scale. The one used in
here is consistent with the one used in HTK \[1\].) The conversion from
a frequency value in Hertz to a mel scale value is done in the obvious
manner by using the exponential function.

# EXAMPLE

    double bigNumber = MAXFLOAT, hertz, mel;

    /* mel_to_hz can exceed MAXDOUBLE */
    errno = 0;
    hertz = mel_to_hz(bigNumber);
    if (errno)
      perror("mel_to_hz error");

    /* reasonable frequency values are fine */
    hertz = 5000.0;
    mel = hz_to_mel(hertz);
    printf("mel equivalent of 5000 Hz is %f", mel);

    /* This makes the variable hertz = 5000.0 */
    hertz = mel_to_hz(mel);
    printf("mel value converted back to hertz is %f", hertz);

# WARNINGS

A negative input value to either of these functions is invalid. Both
functions print an error message and return a negative value for a
negative input whose magnitude is greater than 1.

# BUGS

None known.

# SEE ALSO

    bark_to_hz(3-ESPS), hz_to_bark(3-ESPS), melspec(1-ESPS)

# REFERENCES

\[1\] Steve Young, Julian Odell, Dave Ollason, Valtcho Valtchev, and
Phil Woodland, *The HTK Book,* Entropic, 1997.

# AUTHOR

Code extracted from *melspec*(1-ESPS) by David Burton; manual page by
David Burton.
