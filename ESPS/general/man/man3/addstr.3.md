# NAME

    addstr - append a string to a null-terminated array of strings

    strlistlen - return number of strings in a null-terminated array of strings

# SYNOPSIS


    evoid
    addstr(str, arr)
    char	*str;
    char	***arr;

    int
    strlistlen(strlist)
    char **strlist;

# DESCRIPTION

If the location \**arr* to which *arr* points (typically a variable in
the calling program) is not NULL, it must contain a pointer to the
beginning of a block of storage allocated by *malloc*(3C) or
*calloc*(3C) and containing a NULL-terminated string array - that is, an
array of elements of type (char \*), the last of which is (char \*)
NULL. Such arrays are used, for instance, to hold lists of field names
in FEA file headers and to hold lists of values for CODED items in FEA
file headers and generic header items.

If the location \**arr* to which *arr* points is NULL, then *addstr*
allocates the necessary initial storage and assigns it to \**arr.*

In both cases, the function then reallocates the storage with
*realloc*(3C) to hold one more element, inserts *str* as a new last
element (overwriting the terminating NULL), and follows it with a new
terminating NULL. The pointer in \**arr* is updated to point to the
beginning of the reallocated block.

The function *strlistlen* returns the current number of strings in the
string array *strlist*, and is intended for use on string arrays
maintained by *addstr*.

# EXAMPLE

A program may allow a command-line option to be specified several times
with different arguments. Here is one way to get a list of the
arguments. (This is a quadratic algorithm and not recommended for
building up extremely long arrays.)


    extern int	optind;
    extern char	*optarg;
    int		ch;
    char		**fields = NULL;

    while ((ch = getopt(argc, argv, "f:<other option letters>") != EOF)
    	switch (ch)
    	{
    	case 'f':
    		addstr(optarg, &fields);
    		break;
    	<other cases>
    	}

# DIAGNOSTICS

ESPS assertion failed: can't reallocate memory for string array

# BUGS

None known.

# SEE ALSO

    atoarrays (3-ESPSu), lin_search(3-ESPSu), lin_search2 (3-ESPSu), 
    FEA (5-ESPS), genhd_codes (3-ESPSu), genhd_list(3-ESPSu)

# AUTHOR

Rodney Johnson, with mods by John Shore
