# NAME

hamm_enc - code an integer between \[0,15\] with an (8,4) Hamming code.

# SYNOPSIS

int hamm_enc (data, code)\
int data;\
short \*code;

# DESCRIPTION

*hamm_enc* encodes an integer ( *data* ) between \[0,15\] with a (8,4)
Hamming code and returns it in *code.* This allows single error
detection and double error detection.

# DIAGNOSTICS

hamm_enc returns -1 if the input *data* is less than 0 or greater than
15, and it returns 0 otherwise.

# SEE ALSO

*hamm_dec*(3-ESPSsp)

# REFERENCES

\[1\] R. E. Hamming, Coding and Information Theory, Prentice-Hall, Inc.,
Englewood Cliffs, New Jersey, 1980

# AUTHOR

Code by D. Burton, manual page by D. Burton
