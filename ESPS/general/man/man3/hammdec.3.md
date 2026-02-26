# NAME

hamm_dec - decode an 8-bit Hamming (8,4) coded integer into an integer
that lies in the range \[0,15\].

# SYNOPSIS

int hamm_dec (data, code)\
short \*data;\
int code;

# DESCRIPTION

*hamm_dec* decodes an integer *code* into an integer between \[0,15\]
and returns it in *data.* *hamm_dec* does single error correction and
double error detection. If no errors were detected, *hamm_dec* returns a
value of 0 and the *data* value; if a single error was corrected,
*hamm_dec* returns a value of 1 and the corrected *data* value; if a
double error is detected, it returns a value of 2 and a *data* value of
-1.

# DIAGNOSTICS

*hamm_dec* returns a value of -1 if *code* is greater than 255 or less
than 0.

# SEE ALSO

*hamm_enc*(3-ESPSsp)

# REFERENCES

\[1\] R. E. Hamming, Coding and Information Theory, Prentice-Hall, Inc.,
Englewood Cliffs, New Jersey, 1980

# AUTHOR

Code by D. Burton, manual page by D. Burton
