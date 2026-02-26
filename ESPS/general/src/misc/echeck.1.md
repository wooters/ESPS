# NAME

echeck - look up entry in ESPS general and local lint libraries

# SYNOPSIS

**echeck** *function1* \[ *function2 ...* \]

# DESCRIPTION

*Echeck* looks up its arguments in the ESPS general and local lint
library source files and prints the entries found. Entries found in the
local library are marked as such. A message is printed if the function
is not found in either library.

This program is useful to provide a quick check of the calling sequence
for an ESPS function without looking up the manual page. It is also
useful to confirm that an entry is in the lint library correctly.

An emacs mock-lisp file echeck.ml is provided with the ESPS distribution
to facilitate calling *echeck* from within emacs.

# SPS PARAMETERS

This program does not access the parameter file.

# OPTIONS

No options are supported.

# EXAMPLE(S)

echeck get_fea_ptr f_mat_alloc

will print the lint library entries for get_fea_ptr and f_mat_alloc.

# BUGS

*Echeck* uses a relatively simple-minded pattern match algorithm that
will work almost always but may fail under some circumstances.

# FILES

The library locations may differ on different systems. The defaults for
the general and local lint library source files are
/usr/esps/lib/llib-lespsg.c and /usr/esps/lib/llib-lespsl.c.

# AUTHOR

Alan Parker; revised by John Shore
