# NAME

    h_add - add an empty NIST Sphere header to raw speech data

# SYNOPSIS

    h_add [-vh] { infile | - } { outfile | - }

# DESCRIPTION

**H_add** adds an empty NIST Sphere header to raw speech data. The
option -v shows the sphere library version. The option -h shows the
command usage.

# EXAMPLES

**h_add r.dat f.wav**  
adds an empty NIST Sphere header to the raw speech data in *r.dat*,
storing the output in *f.wav*.

# SEE ALSO

raw2nist(1)

# AUTHOR

Stan Janet (stan@jaguar.ncsl.nist.gov)
