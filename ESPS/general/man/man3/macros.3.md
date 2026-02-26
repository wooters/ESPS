# NAME

macros - useful macros for ESPS programs

# SYNOPSIS

\#include \<esps/esps.h\>

TRYOPEN(prog,filename,mode,fd)\
char \*prog,\*filename,\*mode;\
FILE \*fd;

CANTOPEN(prog,filename)\
char \*prog, \*filename;

USAGE(text)\
char \*text;

NOTSPS(prog,filename)\
char \*prog,\*filename;

BOOL(arg)\
int arg;

ROUND (arg)\
float arg;

LROUND (arg)\
float arg;

MAX (a,b)

MIN (a,b)

# DESCRIPTION

The TRYOPEN macro attempts to open a file with fopen(3), using the given
mode, which may be "r", "w", or any other mode allowed by fopen(3). If
the file cannot be opened, a message is printed on the error output of
the form


    program: can't open filename: reason

and the program exits with error status 1. The reason text is obtained
from the perror(3) call, which interprets the system error status.
Examples include "no such file or directory" or "permission denied".

The CANTOPEN macro is invoked by TRYOPEN; it may also be invoked
directly. It just prints the error message described above and causes an
exit with error status 1.

The USAGE macro prints the message


    Usage: text

on the error output and causes a program exit with error status 1.

The NOTSPS macro prints an error message of the form


    program: filename is not an ESPS file

on the error output and causes an exit with error status 1.

The BOOL macro returns true (1) if the argument is 1, 'y', or 'Y', and
false (0) otherwise. It is useful for testing ESPS header values or
parameter file values.

The ROUND macro is used to round a floating value to the nearest integer
value. This is used for floating to integer conversions when rounding is
desired, rather than truncation.

The LROUND macro is like ROUND, but it returns a type LONG.

MIN and MAX return the maximum or minimum of their arguments. They can
be used with any data type.
