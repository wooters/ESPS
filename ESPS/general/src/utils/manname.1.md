# NAME

man_name - normalize names of ESPS manual-page files for use with *eman*

# SYNOPSIS

**man_name** \[ **-r** \] \[ **filename** . . . \]

# DESCRIPTION

The arguments *filename* . . . , if given, should each be of the form
*name***.***ext,* where *name* is a manual-page name and *ext* consists
of a digit, possibly followed by a letter. *Man_name* normalizes each
filename by removing any underscores from *name* and truncating the
result so that *name***.***ext* has a maximum of 12 characters. This
normalized form is that preferred for use with *eman*(1-EPSP) to cope
with filename length restrictions on some versions of Unix and to
squeeze more significant characters into limited space.

Ordinarily, the modified filenames are written to the standard output,
one to a line. But if the **-r** option is given, *man_name* assumes
that the filenames name files in the current directory and attempts to
rename each such file with the normalized form of its name.

If no filename arguments are given on the command line, *man_name* reads
filenames from the standard input, separated by whitespace or newlines,
and either writes the normalized names to standard output, one to a
line, or attempts to rename the named files.

# EXAMPLES

The name of the man page for the function that allocates filter-file
records is *allo_filt_rec,* and its section number is 3 (not followed by
*t,* since the page contains no tables). The result of

> man_name allo_filt_rec.3

is

> allofiltre.3

on the standard output. That is the name that the source file for this
man page should have in the ESPS *man* directory tree. The user can
access the information by giving *eman*(1-SPS) an argument of
*allo_filt_rec* or *allofiltrec* or even *allofiltre.*

Executing

> ls dir \| man_name \> tmpfile

will put a list of the normalized names of all the files in the
directory *dir* into the file *tmpfile*. Then

> ls dir \| diff - tmpfile

will show whether there are any files in the directory that ought to be
renamed.

The command

> man_name -r \*

will rename all the files in the current directory; but use caution, and
read the Bugs section below before trying this one.

# ESPS PARAMETERS

This program does not access an ESPS parameter file or the ESPS common
file.

# ESPS HEADERS

This program is not concerned with ESPS file headers.

# OPTIONS

The following option is supported.

**-r**  
Rename files, rather than writing out normalized filenames.

# DIAGNOSTICS

The message

> man_name: Can't rename *name* to *name.*

is given when some normalized name differs from the original name and
*rename*(2) fails. The program then exits immediately.

The message

> man_name: Badly formed input: *name.*

means that a filename does not end with a period followed with a one- or
two-character extension. The program exits immediately if **-r** is in
force but continues if merely writing out normalized names.

# SEE ALSO

eman(1-ESPS), rename(2)

# BUGS

When renaming, the program does not check whether the normalized from of
a filename is the name of another file or whether two filenames have the
same normalized form. In either case, you lose a file.

Checking for well-formed names could be stricter than it is.

# AUTHOR

Rodney W. Johnson
