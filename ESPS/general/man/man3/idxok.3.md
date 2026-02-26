# NAME

idx_ok - check that an index value is within range of a null-terminated
array of character pointers

# SYNOPSIS

int\
idx_ok(index, array)\
int indent;\
char \*array\[\];

# DESCRIPTION

*idx_ok* checks that *index* is a valid index into an array of character
pointers, *array*. It returns true (1) if the index is within range and
false (0) if it is not. It is assumed that the last element of *array*
points to a NULL string, therefore the length used for the check is one
less than its true length. This function is intended to be used with the
arrays of type codes and methods declared in *\<esps/header.h\>.*

# SEE ALSO

    ESPS(5-ESPS), SD(5-ESPS), SPEC(5-ESPS), lin_search(3-ESPSu)

# AUTHOR
