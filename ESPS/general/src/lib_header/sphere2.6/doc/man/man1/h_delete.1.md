# NAME

    h_delete - delete fields from Sphere-format speech file headers

# SYNOPSIS

    h_delete [-uvf] -Ffield ... [-D dir] file ...
    h_delete [-uvf] -Field ... -o outfile file

# DESCRIPTION

Fields can be deleted from Sphere file headers using the utility
*h_delete*. In its first form, the specified file(s) is copied to a new
directory the *-D dir* option is present; otherwise the file(s) is to be
modified in-place. In its second form, the specified file is written to
a new file if the *-o outfile* option is present; otherwise the file is
to be modified in-place. The *-D* and *-o* options are not compatible.

At least one file must be present on the command line, as well as at
least one field.

If a file is to be modified in-place and the changes do not alter the
size of its header, the new header is written over the old one and the
speech samples do not need to be copied.

# OPTIONS

**-u**  
unlink the source files after creating new ones (requires -D or -o)

**-v**  
turns on verbose output

**-f**  
if deletes fail for some fields of a file, continue trying others

**-F field**  
add *field* to the list of fields to be deleted

**-D directory**  
copy output files to new directory, retaining source file basenames

**-o outfile**  
copy output file to specified destination file

# EXIT STATUS

Zero if all deletes succeed on all files, non-zero otherwise

# EXAMPLES

**h_delete -Ffoo -Fbar f1.wav f2.wav**  
Remove fields "foo" and "bar" from files f1.wav and f2.wav.

# AUTHOR

Stan Janet (stan@jaguar.ncsl.nist.gov)
