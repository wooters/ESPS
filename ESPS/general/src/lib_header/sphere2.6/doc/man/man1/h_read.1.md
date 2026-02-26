# NAME

h_read - scan NIST SPHERE-format '.wav' file

# SYNOPSIS

    h_read [options] [file ...]

# DESCRIPTION

The command **h_read** reads the headers of the '.wav' files specified
on the command line and, by default, prints the names and values of all
header fields one-per-line. Various options alter the behavior of the
program.

# OPTIONS

**-f h**  
print filename (between ":::::" strings) before processing every file

**-f a**  
print filename with every field

**-n**  
suppress printing of fieldnames

**-t**  
print field types (i, r, or s) with field values

**-d**  
suppress printing of field values

**-N f**  
number fields printed on per-file basis

**-N t**  
number fields printed on per-run basis

**-C fieldname**  
check that the specified field is in all headers

**-S**  
restrict field output to standard NIST fields

**-F fieldname**  
restrict field output to explicitly-named fields

**-c**  
complement fieldname selection test (for output)

**-s string**  
delimit components of field lines by *string* \[one blank\]

**-a**  
check for odd characters in string fields (by default, odd characters
are non-printable characters)

**-o string**  
characters in *string* are added to the list of characters to be
considered not odd

**-V**  
verify that the number of bytes in each file is correct based on the
fields *sample_count* and *sample_n_bytes*

**-e n**  
verify that the number of fields in each file is *n*

**-B n**  
separate output for different files by *n* blank lines \[0\]

**-T string**  
restrict output to fields of type integer, real, and/or string as
specified by characters i, r, and s in *string* \[irs\]

**-v**  
select verbose output

**-q**  
print field values between quotes

**-0**  
number fields starting at 0 \[1\]

Options **-F** and **-S** cannot both be specified. No more than one
**-o** option may be specified.

# EXIT STATUS

Exit status is 0 if no errors occur in processing the entire set of
files. Otherwise, the exit status is non-zero.

# SEE ALSO

isalnum(3), isprint(3)

# AUTHOR

Stan Janet (stan@jaguar.ncsl.nist.gov)
