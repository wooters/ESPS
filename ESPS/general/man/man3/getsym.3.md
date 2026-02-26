# NAME

getsym_c, getsym_d, getsym_i, getsym_s, getsym_ia, getsym_da,
getsym_fa - get a parameter value from the symbol table created by
read_params

# SYNOPSIS

**\#include \<stdio.h\>**\
**\#include \<esps/param.h\>**

**char getsym_c (symbol)**\
**char \*symbol;**

**double getsym_d (symbol)**\
**char \*symbol;**

**int getsym_i (symbol)**\
**char \*symbol;**

**char \*getsym_s (symbol)**\
**char \*symbol;**

**int getsym_ia (symbol, arr, maxval)**\
**char \*symbol;**\
**int arr\[\];**\
**int maxval;**

**int getsym_da (symbol, arr, maxval)**\
**char \*symbol;**\
**double arr\[\];**\
**int maxval;**

**int getsym_fa (symbol, arr, maxval)**\
**char \*symbol;**\
**float arr\[\];**\
**int maxval;**

# DESCRIPTION

The functions all read the specified *symbol* from the symbol table
created by *read_params* and return its value, either a character,
double, integer, string, pointer to an array of integers or a pointer to
an array of doubles.

If the corresponding parameter is indefinite (i.e., if it was defined in
the parameter file with either of the assignments "=?" or "?=", and if
terminal input is possible (i.e., program not reading stdin), then the
user is prompted for the value. In this case, if they were present in
the parameter file, the prompt string, default value, and parameter
choices or limits are displayed.

*getsym_c* returns a character if and only if *symbol* exists in the
symbol table and the symbol is a character. Otherwise, it returns a
zero.

*getsym_d* returns a double if and only if *symbol* exists in the symbol
table and the symbol is a float or a double. Otherwise, it returns a
zero.

*getsym_i* returns an integer if and only if *symbol* exists in the
symbol table and the symbol is an integer. Otherwise, it returns a zero.

*getsym_s* returns a string if and only if *symbol* exists in the symbol
table and the symbol is a string. Otherwise, it returns NULL.

*getsym_ia, getsym_da,* and *getsym_fa* all read the specified *symbol*
from the symbol table and return the length of the array *arr*. *maxval*
is an input parameter specifying the maximum length of the array *arr*.
If *symbol* does not exist in the symbol table, then these functions
return a -1. If the length of *arr* is greater than *maxval*, then these
functions return a zero and they print a message on stderr. A pointer to
the data from the symbol table is passed through *arr*.

*getsym_da* and *getsym_fa* return entries from the parameter file that
are declared as type float. The values returned are the same; the only
difference is that one returns an array of floats and the other returns
doubles.

User feedback of common and parameter file processing is determined by
the environment variable ESPS_VERBOSE, with 0 causing no feedback and
increasing levels causing increasingly detailed feedback. At level 2,
the *getsym* functions print a message to stderr when a value taken from
the symbol table originated from the ESPS Common file. At level 3, the
*getsym* functions print a message to stderr when a value taken from the
symbol table originated from either the ESPS Common file or the
parameter file. For symbols defined to prompt the user (by using =? in
the parameter file), these message are not printed.

# EXAMPLE


    /*  read in the values of the parameters from the symbol table */
    start = getsym_i ("start");
    nan = getsym_i ("nan");
    decrem = getsym_s ("decrem");
    harmonic_mult = getsym_d ("harmonic_mult");

    if (getsym_da ("lpf_num", lpf_num, 3) == -1)
       (void) fprintf (stderr, "undefined symbol or bad type);

# DIAGNOSTICS

Undefined Symbol: *symbol*\
Not a valid real value\
Not a valid integer\
Symbol *symbol* is not (symbol-type)\
Array *symbol* is too long to fit into supplied buffer

# BUGS

# SEE ALSO

    read_params(3-ESPS), getsymdef(3-ESPS), symerr_exit(3-ESPS),
    putsym(3-ESPS), fputsym(3-ESPS), symtype(3-ESPS),
    symsize(3-ESPS), symlist(3-ESPS), symdefinite(3-ESPS),
    symchoices(3-ESPS), symrange(3-ESPS), symprompt(3-ESPS)

# REFERENCES

\[1\] ETM-S-86-12:jtb, Parameter Files in the Speech Processing System

# AUTHOR

Joe Buck, Man page by Ajaipal S. Virdy; modifications by John Shore and
Alan Parker
