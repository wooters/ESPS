# NAME

    raw2nist.sh - convert raw speech data to NIST Sphere format file

# SYNOPSIS

    raw2nist.sh { infile | - } outfile

# DESCRIPTION

**Raw2nist** converts raw speech data to NIST Sphere format by first
running *h_add(1)*, passing its first two arguments. If any other
arguments appear on the command line, they are assumed to be options to
*h_edit*. Therefore that program is run with those arguments followed by
*outfile*.

# EXAMPLES

**raw2nist.sh r1 r1.wav -Sdatabase_id=xyz -Isample_count=16000**  
converts raw file *r1* to NIST Sphere file *r1.wav*, adding string field
*database_id* and integer field *sample_count*.

# SEE ALSO

h_add(1), h_edit(3)

# NOTES

Should have been called *raw2sphere*, but that name is too long for DOS.

# AUTHOR

Stan Janet (stan@jaguar.ncsl.nist.gov)
