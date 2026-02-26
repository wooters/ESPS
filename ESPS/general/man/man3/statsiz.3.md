# NAME

statsiz, fstatsiz - get size of a file in bytes

# SYNOPSIS

long statsiz(name)\
char \*name;

long fstatsiz(stream)\
FILE \*stream;

# DESCRIPTION

*statsiz* returns the size of the file named by the argument in bytes.

*fstatsiz* is identical to *statsiz* except that the argument is a file
descriptor (as returned by *fopen*) rather than a file name. It calls
the system service *fstat*.

# DIAGNOSTICS

If the file does not exist, or if there is no permission to run *stat*
or *fstat* on the file, -1 is returned.

# SEE ALSO

Unix documentation for stat(2).

# AUTHOR
