# NAME

getsymdef_c, getsymdef_d, getsymdef_i, getsymdef_s, getsymdef_ia,
getsymdef_da, getsymdef_fa - get default parameter value from the symbol
table created by read_params

# SYNOPSIS

**\#include \<stdio.h\>**\
**\#include \<esps/param.h\>**

**char getsymdef_c (symbol)**\
**char \*symbol;**

**double getsymdef_d (symbol)**\
**char \*symbol;**

**int getsymdef_i (symbol)**\
**char \*symbol;**

**char \*getsymdef_s (symbol)**\
**char \*symbol;**

**int getsymdef_ia (symbol, arr, maxval)**\
**char \*symbol;**\
**int arr\[\];**\
**int maxval;**

**int getsymdef_da (symbol, arr, maxval)**\
**char \*symbol;**\
**double arr\[\];**\
**int maxval;**

**int getsymdef_fa (symbol, arr, maxval)**\
**char \*symbol;**\
**float arr\[\];**\
**int maxval;**

# DESCRIPTION

The functions all read the specified *symbol* from the symbol table
created by *read_params* and return its default value, either a
character, double, integer, string, pointer to an array of integers or a
pointer to an array of doubles. If a definite value was given in the
parameter file (i.e., if the assignment operator "=" was used), these
functions all return the same value as the corresponding
*getsym*(3-ESPS) function.

*getsymdef_c* returns a character if and only if *symbol* exists in the
symbol table and the symbol is a character. Otherwise, it returns a
zero.

*getsymdef_d* returns a double if and only if *symbol* exists in the
symbol table and the symbol is a float or a double. Otherwise, it
returns a zero.

*getsymdef_i* returns an integer if and only if *symbol* exists in the
symbol table and the symbol is an integer. Otherwise, it returns a zero.

*getsymdef_s* returns a string if and only if *symbol* exists in the
symbol table and the symbol is a string. Otherwise, it returns NULL.

*getsymdef_ia, getsymdef_da,* and *getsymdef_fa* all read the specified
*symbol* from the symbol table and return the length of the array *arr*.
*maxval* is an input parameter specifying the maximum length of the
array *arr*. If *symbol* does not exist in the symbol table, then these
functions return a -1. If the length of *arr* is greater than *maxval*,
then these functions return a zero and they print a message on stderr. A
pointer to the default data from the symbol table is passed through
*arr*.

*getsymdef_da* and *getsymdef_fa* return entries from the parameter file
that are declared as type float. The values returned are the same; the
only difference is that one returns an array of floats and the other
returns doubles.

Unlike the *getsym*(3-ESPS) functions, these functions do not provide
feedback in terms of Common processing. However, note that *read_params*
may process Common when creating the symbol table, so a default value
returned by *getsymdef* may have originated in ESPS Common (see
*read_params*(3-ESPS)).

# DIAGNOSTICS

Undefined Symbol: *symbol*\
Not a valid real value\
Not a valid integer\
Symbol *symbol* is not (symbol-type)\
Array *symbol* is too long to fit into supplied buffer

# BUGS

# SEE ALSO

    read_params(3-ESPS), getsym(3-ESPS), symerr_exit(3-ESPS),
    putsym(3-ESPS), fputsym(3-ESPS), symtype(3-ESPS),
    symsize(3-ESPS), symlist(3-ESPS), symdefinite(3-ESPS),
    symchoices(3-ESPS), symrange(3-ESPS), symprompt(3-ESPS)

# REFERENCES

\[1\] ETM-S-86-12:jtb, Parameter Files in the Speech Processing System

# AUTHOR

man page by John Shore.
