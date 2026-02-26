# NAME

    symtype - return the type of a parameter 
    symsize - return the size of a parameter 
    symlist - get list of parameter names and return number of parameters
    symdefinite - indicates whether a run-time parameter prompt will occur
    symchoices - get list of discrete choices for a parameter's value
    symrange -  get the value range for a parameter 
    symprompt - returns the prompt string for a parameter

# SYNOPSIS

\#include \<esps/esps.h\>\
int\
symtype(name)\
char \*name;

\
int\
symsize(name)\
char \*name;

\
char \*\*\
symlist(nparams)\
int \*nparams;

\
int\
symdefinite(name)\
char \*name;

\
char \*\*\
symchoices(name, nchoices)\
char \*name;\
int \*nchoices;

\
int\
symrange(name, min, max)\
float \*min, \*max;

\
char \*\
symprompt(name)\
char \*name;\

# DESCRIPTION

These functions all obtain information from the symbol table created by
calling *read_params* (3-ESPS). For the values themselves, use the
appropriate *getsym* (3-ESPS) function.

*symtype* returns the type of the symbol *name*. Valid symbol types are
ST_INT, ST_CHAR, ST_FLOAT, ST_STRING, ST_IARRAY, ST_FARRAY, and also
ST_UNDEF. These are defined in \<esps/param.h\>.

*symsize* returns the size of the symbol *name*. That is, for a scaler
it returns 1 and for an array it returns the array size. If *name* is
undefined, then *symsize* returns -1.

*symlist* returns a list of the defined symbols in the form of a
null-terminated array of character pointers (the same form as used by
*lin_search* (3-ESPS)). If the pointer *nparams* is not NULL, the
corresponding variable is set to the number of symbols in the symbol
table (number of symbols that were defined in the parameter file
specified in the call to *read_params*). If there are no parameters
defined in the symbol table, *symlist* returns NULL and sets \**nparams*
to 0 (if *nparams* is non-NULL).

*symdefinite* returns 1 if the parameter symbol *name* was assigned a
definite value in the parameter file (i.e., if "=" was used as the
assignment operator). If the assigned value was indefinite (i.e., "?="
or "=?" was used as the assignment operator), 0 is returned. (An
indefinite value causes a runtime prompt when the appropriate *getsym*
is called.) If *name* is undefined, then *symdefinite* returns -1.

*symchoices* returns, a list of the possible choices for the value of
the symbol *name*, represented as a null-terminated array of character
pointers (suitable for use with *lin_search* (3-ESPS)). If the pointer
*nchoices* is not NULL, the corresponding variable is set to number of
choices. If the choices were not given for *name* in the parameter file,
*symchoices* returns NULL and sets \**nchoices* to 0 (if *nchoices* is
non-NULL). Note that it is acceptable to provide a list of discrete
choices for a numeric parameter.

*symrange* returns 1 if an (optional) parameter range was given in the
parameter file for the symbol *name*, and 0 if no range was given. If a
range was given the minimum and maximum values are returned as floats
via the parameters *min* and *max*. If no range was given, NULL is
assigned to *min* and *max*. Note that it is an error to provide a range
for a non-numeric parameter.

*symprompt* returns the (optional) prompt string for the symbol *name*;
if no prompt string was provided in the parameter file, NULL is
returned.

# DIAGNOSTICS

None.

# BUGS

None known.

# SEE ALSO

*read_params* (3-ESPS), *getsym* (3-ESPS), *getsymdef* (3-ESPS),
*putsym* (3-ESPS), *fputsym* (3-ESPS), ESPS (5-ESPS)

# AUTHOR

Man page by Ajaipal S. Virdy, Entropic Speech, Inc.; additions by John
Shore
