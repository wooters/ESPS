# NAME

    erlsupport - send a support request to ERL.

# SYNOPSIS

erlsupport

# DESCRIPTION

*Erlsupport* allows you to create a support request form that helps
ensure quick and accurate support by Entropic Research Laboratory (ERL)
engineers. Note that the form editor has not been ported to all
architectures that ERL supports for ESPS/waves+. If it hasn't been
ported, then erlsupport will just print out the information that you can
use to contact us and help us support you.

You may email the form directly to ERL, or print the form for faxing or
mailing, or both. The form may also be email carbon copied to whoever
you want to see it.

Initial data for the form is created via an data entry screen that gets
information that any problem or support request will require. You may
then edit the form with the editor of your choice, prior to it's being
emailed or printed.

# CONFIGURATION

The file *\$ESPS_BASE/lib/erlsupport.defs* contains standard definitions
that *erlsupport* uses. It is a Bourne shell script (sh(1)). You may
edit it to set whatever defaults you like. Make sure to keep a backup of
the original, in case the defaults you like break **erlsupport**.

# OPTIONS

*Erlsupport* has no options.

# FUTURE CHANGES

An X-Window's version would be nice.

# ERRORS AND DIAGNOSTICS

**Erlsupport** *uses the program* **mail** *for email. If it can't find*
mail, or *\$ESPS_BASE/bin/sf* then it will terminate. If your system
desn't have mail, then edit the *erlsupport* script to use a mail
program you do have. Don't hesitate to call ERL if you have trouble.

# BUGS

None known.

# FILES

\$ESPS_BASE/lib/erlsupport.defs - standard definitions that erlsupport
uses.

# SEE ALSO

# AUTHOR

Ken Nelson wrote *erlsupport* and this man page. Paul Lew wrote
shellforms (sf). The source to sf is in the \$ESPS_BASE/pub.
