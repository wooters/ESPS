# NAME

savestring - save a string in dynamic memory

# SYNOPSIS

char \*\
savestring (text)\
char \*text;

# DESCRIPTION

*savestring* allocates dynamic memory for a string, copies the argument
string to the copied space, and returns a pointer to the copy. If the
argument is NULL, no space is allocated and NULL is returned.

The dynamic memory may be reclaimed with free(3C).

# DIAGNOSTICS

If enough dynamic memory cannot be allocated, savestring returns NULL.

# SEE ALSO

calloc(3C), free(3C), malloc(3C)

# AUTHOR

Joe Buck
