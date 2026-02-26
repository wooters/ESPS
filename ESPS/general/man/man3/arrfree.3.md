# NAME

arr_free - free storage allocated by arr_alloc or marg_index

# SYNOPSIS

    #include <esps/esps.h>

    void
    arr_free(arr, rk, typ, lvl)
    char    *arr;
    int     rk, typ, lvl;

# DESCRIPTION

*arr_free* uses *free*(3C) to free storage allocated by
*arr_alloc*(3-ESPSu) or *marg_index*(3-ESPSu).

If *arr* is the result of an invocation of *arr_alloc*(3-ESPSu), say

> arr = arr_alloc(rk, dim, typ, lvl);

then calling

> arr_free(arr, rk, typ, lvl);

with the same values of *rk,* *typ,* and *lvl* will free the storage.
Both the storage for array elements and the pointer structure that
supports indexing are freed.

Usually the result of *arr_alloc* will have been converted to a type
other than (char \*) before being used. For example, with *rk* = 3,
*typ* = FLOAT, and *lvl* = 1, the appropriate type would be (float
\*\*\*\*), and instead of the above, *arr* would be defined by

> arr = (float \*\*\*\*) arr_alloc(3, dim, FLOAT, 1);

This must then be converted back to (char \*) in the invocation of
*arr_free,* as in

> arr_free((char \*) arr, 3, FLOAT, 1);

If *arr* is the result of an invocation of *marg_index*(3-ESPSu) of the
form

> arr = marg_index(p, rk, dim, typ, lvl);

then calling

> arr_free(arr, rk, typ, lvl);

will free the storage for the pointer structure created by *marg_index*
and will also attempt to free the storage that *p* points to. This will
work only if *p* is a pointer returned by *malloc*(3C) or *calloc*(3C);
the result will be disaster otherwise.

If *p* does not point to a block allocated by *malloc* or *calloc,* it
is still possible to free the pointer structure created by *marg_index,*
but leave the storage that *p* points to alone. To do this, replace *rk*
by *rk* - 1 and *lvl* by *lvl* + 1 in the invocation of *arr_free.*

*marg_index,* like *arr_alloc,* returns a pointer that is likely to be
converted to another type for use and require conversion back to (char
\*) when *arr_free* is called. For example, after

> arr = (float \*\*\*\*) marg_index(p, 3, dim, FLOAT, 1);

the statement

> arr_free((char \*) arr, 3, FLOAT, 1);

will free the storage allocated by *marg_index* and will execute
*free(p);* as well. The statement

> arr_free((char \*) arr, 2, FLOAT, 2);

will free only the storage allocated by *marg_index.*

# SEE ALSO

*arr_alloc*(3-ESPSu), *marg_index*(3-ESPSu), free(3C)

# DIAGNOSTICS

    arr_free: rank < 0
    arr_free: level < 0
    arr_free: unrecognized type

# BUGS

None known.

# AUTHOR

Rodney Johnson
