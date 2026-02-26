# NAME

    h_edit - edit Sphere-format speech file headers

# SYNOPSIS

    h_edit [-cuvf] -{S|I|R}field=value ... [-D dir] file ...
    h_edit [-cuvf] -{S|I|R}field=value ... -o outfile file

# DESCRIPTION

Sphere file headers can be modified using the utility *h_edit*. In its
first form, the specified file(s) is copied to a new directory the *-D
dir* option is present; otherwise the file(s) is to be edited in-place.
In its second form, the specified file is written to a new file if the
*-o outfile* option is present; otherwise the file is to be edited
in-place. The *-D* and *-o* options are not compatible.

At least one file must be present on the command line, as well as at
least one field modifier.

If a specified field exists and the modifier would change the type, the
edit will fail with a "type mismatch". Use *h_delete(1)* to delete the
field first.

If a file is to be edited in-place and the editing does not change the
size of its header, the new header is written over the old one and the
speech samples do not need to be copied.

The update to version 2.0 of sphere forces restrictions on the use of
certain fields and there types. Consult sphere.doc in this distribution
for complete description of the required fields.

# OPTIONS

**-u**  
unlink the source files after creating new ones (requires -D or -o)

**-v**  
turns on verbose output

**-f**  
if edits fail for some fields of a file, continue trying others

**-S fieldname=value**  
change the string field's value (create if necessary)

**-I fieldname=value**  
change the integer field's value (create if necessary)

**-R fieldname=value**  
change the real number field's value (create if necessary)

**-D directory**  
copy output files to new directory, retaining source file basenames

**-o outfile**  
copy output file to specified destination file

**-c**  
compute and add a sample checksum, fieldname "sample_checksum", the
header. The checksum is computed after all specified header
modifications have been made.

# EXIT STATUS

Zero if all edits succeed on all files, non-zero otherwise

# EXAMPLES

**h_edit -Sfoo=bar -Isamples=65536 f1.wav f2.wav**  
Edit files f1.wav and f2.wav in-place, setting the values of string
field *foo* to bar and integer field *samples* to 65536.

# AUTHOR

Stan Janet (stan@jaguar.ncsl.nist.gov)
