# NAME

eman - displays or prints ESPS manual pages

# SYNOPSIS

**eman** \[ **-x** *debug_level* \] \[ **-m** *man page directory* \] \[
**-t** \] \[ *section* \] *name*\
**eman** \[ **-x** *debug_level* \] \[ **-m** *man page directory* \]
**-k** *keyword*

# DESCRIPTION

*Eman* is a *man*-like program for examining the ESPS documentation. The
main differences are that a different directory tree is searched, and
not all the features of the Berkeley *man* program are implemented.

If no section number is given, *eman* searches the ESPS man directory
tree for a file

> man?/name.?

or

> man?/name.?t

where the question marks are replaced with the same digit, the section
number, and the *t* suffix indicates that the file must be run through
*tbl* before being formatted for viewing or printing. Sections 1 through
8 are searched. If *section* is given, it must be a digit from 1 to 8,
and only that section is searched.

*Eman* normalizes *name* by removing underscores and truncating to a
length of at most 10 characters before searching for

> man?/name.?

If no match is found, the program further truncates *name* to a maximum
length of 9 before searching for

> man?/name.?t

If still no match is found, the program tries leaving the underscores in
and just truncating as above, both without the *t* suffix and with it.

If a match is found, *eman* looks for a preformatted version of the
document, named

> cat?/name.?

If the preformatted version is found and is more recent than the source
page, a pager program is executed to print the formatted version. This
is the program, if any, whose name is the value of the environment
variable PAGER; the default is *more.* If no preformatted version is
found, a new one is generated.

# OPTIONS

The following options are supported.

**-x** *debug_level*  
If *debug_level* is 1 or greater, debugging information is written to
standard error.

**-m man page directory**  
The directory to look for the man pages. This directory should contain
sub-directories *man1*, *man2*, etc., and *cat1*, *cat2*, etc. By
default *eman* looks in the directory specified for the manual pages in
the ESPS installation script. This option is only needed to override
that.

**-t**  
The source for the manual page is formatted with *troff* and typeset.

**-k** *keyword*  
The *whatis* file in the ESPS man directory tree is searched for entries
that match *keyword.*

The organization of sections is the same as for the Unix manual tree;
main programs are described in section 1; library routines are described
in section 3; data file formats are described in section 5; system
maintenance documents are in section 8. Other sections (for which the
correspondence with the Unix manual tree makes no sense) are reserved
for future use.

# SEE ALSO

man(1), col(1), grep(1), more(1), nroff(1), troff(1), tbl(1)

# FILES

    man[1-8]/*.[1-8],
    man[1-8]/*.[1-8]t	source files
    cat[1-8]/*.[1-8]	preformatted pages
    whatis	database for -k option.

# DIAGNOSTICS

The user is informed if no document with the requested name can be
found, or if execution of the pager, *troff,* or *nroff* fails.

# AUTHOR

Joseph T. Buck. Revisions by Ajaipal S. Virdy and Rodney W. Johnson.
