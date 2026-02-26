# NAME

    putsym_f, putsym_i, putsym_s - put a parameter value into an ESPS Common file
    fputsym_f, fputsym_i, fputsym_s - put a parameter value into an arbitrary file

# SYNOPSIS

**\#include \<stdio.h\>**\
**\#include \<esps/esps.h\>**

**int putsym_f (symbol, value)**\
**char \*symbol;**\
**float value;**

**int putsym_i (symbol, value)**\
**char \*symbol;**\
**int value;**

**int putsym_s (symbol, value)**\
**char \*symbol;**\
**char \*value;**

**int fputsym_f (symbol, value, file)**\
**char \*symbol;**\
**float value;**\
**char \*file;**

**int fputsym_i (symbol, value, file)**\
**char \*symbol;**\
**int value;**\
**char \*file;**

**int fputsym_s (symbol, value, file)**\
**char \*symbol;**\
**char \*value;**\
**char \*file;**

# DESCRIPTION

*putsym_f,* *putsym_i,* and *putsym_s,* all write the specified *symbol*
and its *value* into an ESPS Common file if Common processing is
enabled.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. If Common
processing is disabled, then these functions simply return without doing
anything.

*fputsym_f,* *fputsym_i,* and *fputsym_s,* all write the specified
*symbol* and its *value* into an arbitrary named file *file*. Their
behavior does not depend on whether or not Common processing is enabled.

In all cases, a return value of zero indicates success and a return
value of -1 indicates error (i.e. the Common file or specified file
could not be updated or created).

The output for all these functions is written in the same format as ESPS
Parameter files (see \[1\] for more details). (Definite assignments are
used, without the optional prompt string and parameter limitations).
Values written with these functions can be read with *getsym_xx*.

# EXAMPLE

    /* parameter values to store in an ESPS Common file */
    start = 5001;
    dcrem = "no";

    if (putsym_i ("start", start) != 0)
       (void) fprintf (stderr, "could not write into ESPS Common file.);
    if (putsym_s ("dcrem", dcrem) != 0)
       (void) fprintf (stderr, "could not write into ESPS Common file.);

# DIAGNOSTICS

# BUGS

# SEE ALSO

*read_params* (3-ESPS), *symerr_exit* (3-ESPS), *getsym* (3-ESPS),
*getsymdef* (3-ESPS), *symtype* (3-ESPS), *symsize* (3-ESPS),\
*symlist* (3-ESPS), *symdefinite* (3-ESPS), *symchoices* (3-ESPS),
*symrange* (3-ESPS), *symprompt* (3-ESPS), *symerr_exit* (3-ESPS)

# REFERENCES

\[1\] ETM-S-86-12:jtb, Parameter Files in the Speech Processing System

# AUTHOR

Ajaipal S. Virdy, Alan Parker, John Shore
