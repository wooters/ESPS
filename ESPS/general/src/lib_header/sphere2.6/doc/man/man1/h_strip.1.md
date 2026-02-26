# NAME

    h_strip - strip header Sphere-format speech file headers

# SYNOPSIS

    h_strip { - | infile } { - | outfile }

# DESCRIPTION

Sphere file headers can be removed using the utility *h_strip*. The
Sphere file is read from the standard input if argument one is a dash,
otherwise it is read from the file specified by argument one. The speech
samples are written to the standard output if the second argument is a
dash, otherwise they are written to the file specified by the argument
two.

# EXIT STATUS

Zero if the header is removed successfully, non-zero otherwise

# EXAMPLES

**h_strip foo.wav foo.dat**  

# AUTHOR

Stan Janet (stan@jaguar.ncsl.nist.gov)
