# NAME

addfea - adds a new FEA file field based on ASCII data

# SYNOPSIS

**addfea** \[ **-P** *params* \] \[ **-f** *field_name* \] \[ **-t**
*field_type* \] \[ **-s** *field_size* \] \[ **-T** *FEA_subtype* \] \[
**-x** *debug_level* \] \[ **-c** *comment* \] \[ **-C** *comment_file*
\] *ascfile feafile* \[ *feafile.out* \]

# DESCRIPTION

*Addfea* creates a new FEA file field and fills it with data taken from
the ASCII file *ascfile.* If *feafile.out* is not supplied, then the new
field is added to each record of *feafile*; if *feafile* does not exist,
a new file is created with one field per record. If *feafile.out* is
supplied, then the records from *feafile* are copied to *feafile.out*
with the new field being added to each record. In this case, *feafile*
must exist.

If *ascfile* is "-", standard input is used for the input ASCII file. If
*feafile* is "-", standard input is used for the input FEA file. (It is
an error for both *ascfile* and *feafile* to be "-".) If *feafile.out*
is "-", standard output is used. If *feafile* exists and is not an ESPS
FEA file, *addfea* prints an error message and exits.

*Ascfile* is an ASCII file containing values separated by white space or
new lines. *Addfea* takes *field_size* values at a time from *ascfile*,
converts them to type *field_type*, and stores them in a field named
*field_name* within sequential records of *feafile*. For complex types,
each complex value is represented by a two ASCII inputs - real part
followed by imaginary part. *Addfea* keeps processing the input until it
is exhausted or until all records in *feafile* (if it exists) have been
updated. If the input is exhausted before all records have been updated,
the *fea_field* in remaining records is set to zero and a warning is
issued. If additional input remains after all records have been updated,
the additional input is discarded and a warning is issued. If *ascfile*
is empty, then the new FEA field is created and set uniformly to zero.

If the field name given for the **-f** option is *Tag*, the built in tag
value of the record is modified, rather than a feature field named
*Tag*. This is a special case, to allow setting the built in tag value
on each feature record. See *fea(5-ESPS)* for details on the tag field.
In this case, the other field related options are ignored (size and
type).

If the new field is complex data type, then two values from the ASCII
file are used for each data item. The real value is given first, and
then the imaginary value. So a complex field of size 2 would require 4
values. If an odd number of ASCII values is given, then the imaginary
part is filled with zero.

For record-keeping purposes, *addfea* stores an ASCII comment in the
header of of the output file. The comment should describe the origins of
the ASCII data in *ascfile*. If a comment is not supplied in the
parameter file or by means of the **-c** or **-C** options, the user is
prompted for one. If *addfea* is called on a pipe with *ascfile* or
*feafile* as standard input, the comment must be supplied directly as
the user cannot be prompted.

Note that *pplain* (1-ESPS) and *select* (1-ESPS) (in EVAL mode) can be
used to create ASCII inputs for *addfea*.

Note that the difference between CHAR and BYTE is that CHAR is for
character data (either a single character or a character string) and
BYTE is for byte signed integer data. Also, CHAR data is handled a bit
awkwardly. A new-line is considered a deliminator for a string of
characters, but it also is retained in the string. So, for example, if
you have four lines of ASCII data

    This
    is
    a
    test

and you want to have each output record contain a single word, you must
specify a size of 5 or larger. That is, you must allow space for the
new-line character.

# OPTIONS

The following options are supported:

**-P** *param* **\[params\]**  
Specifies the name of the parameter file.

**-f** *field_name* ****  
Specifies the name of the new FEA field. If a field with this name
already exists in *feafile*, *addfea* exits with an error message. If
this option is used, it overides the parameter file value. The field
name *Tag* is handled as a special case as described above.

**-t** *field_type* **\[FLOAT\]**  
Specifies the type of the new field. Allowable types are the following:
DOUBLE, FLOAT, LONG, SHORT, CHAR, BYTE, DOUBLE_CPLX, FLOAT_CPLX,
LONG_CPLX, SHORT_CPLX, CHAR_CPLX, and BYTE_CPLX (case doesn't matter).
If this option is used, it overides the parameter file value.

**-s** *field_size* **\[1\]**  
Specifies the size of the new field. If this option is used, it overides
the parameter file value.

**-T** *FEA_subtype*  
If this option is given, the feature file sub-type code is filled in
with the given code. The symbolic name of the sub-type code must be
given, for example FEA_ANA or FEA_SD. For a complete list of defined
sub-type codes, see FEA(5-ESPS). Use of this option doesn't ensure that
the is of the correct format for the defined subtype. The user should
use this option only in cases where he or she knows that a file with the
correct fields is being produced. See the section 5 man pages for the
defined feature file types.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *testsd* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0, no messages are
printed. Only levels 0 and 1 are supported.

**-c** *comment*  
Specifies that the ASCII string *comment* be added as a comment in the
header of the output file. If this option is used, it overides the
parameter file value.

**-C** *comment_file*  
Specifies that the contents of the file *comment_file* be added as a
comment in the header of the output file. If this option is used, it
overides the parameter file value.

# ESPS PARAMETERS

The parameter file does not have to be present if all of the parameters
are specified by means of command-line options. The following parameters
are read, if present, from the parameter file:

> *field_name - string*

> This is the name of the field to add to *feafile*.

> *field_type - string*

> This is the type of the field to add to *feafile*. Allowable values
> are DOUBLE, FLOAT, LONG, SHORT, CHAR, BYTE, DOUBLE_CPLX, FLOAT_CPLX,
> LONG_CPLX, SHORT_CPLX, CHAR_CPLX, and BYTE_CPLX (case doesn't matter).

> *field_size - integer*

> This specifies the size of *field_name* - i.e., the size of the field
> added to *feafile*.

> *comment - string*

> This provides an ASCII comment that is added to the comment field in
> the output file. The comment should describe the origins of the data
> in *ascfile*. If this parameter is not present in the parameter file
> and is not specified by the **-c** or **-C** options, then the user is
> prompted for a comment provided that *addfea* is not called on a pipe
> with *ascfile* or *feafile* as standard input.

Remember that command line option values override parameter file values.

# ESPS COMMON

ESPS Common is not read or written by *addfea*.

# ESPS HEADERS

All the old header values are copied to the new header and the input FEA
file becomes a source file within the recursive header. *addgen*
(1-ESPS) can be used to add the *start_time* and *record_freq* generics
used by *waves+*, if they don't already exist.

# FUTURE CHANGES

Add CODED type to the list of possible field types.

Improve the handling of CHAR data. Make each line correspond to a data
record. Allow use of either *field_size* characters or the new-line
character as the end-of-data deliminator for each line of input. If more
than *field_size* characters exist on a line, a warning is issued and
only *field_size* characters are used. If less than *field_size*
characters occur before a new-line character, the string is null padded.

# SEE ALSO

    addgen (1-ESPS), comment(1-ESPS), psps(1-ESPS), 
    pplain (1-ESPS), select(1-ESPS), fea_deriv (1-ESPS)

# WARNINGS AND DIAGNOSTICS

*Addfea* will exit with an error message if *feafile* exists and already
contains a field named *field_name*.

*Addfea* will exit with an error message if both *ascfile* and *feafile*
are "-".

*Addfea* will exit with an error message if, when *addfea* is called on
a pipe with *ascfile* as standard input, a comment is not supplied in
the parameter file or via **-c** or **-C**.

# BUGS

None known.

# AUTHOR

Manual page by John Shore.
