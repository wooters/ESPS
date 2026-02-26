# NAME

    fea2esig - write FEA file data to Esignal file

# SYNOPSIS

**fea2esig** \[ **-a** *format* \] \[ **-f** *field* \] . . . \[ **-r**
*range* \] \[ **-x** *debug_level* \] \[ **-A** *width* \] \[ **-F** \]
*input.fea output.esig*

# DESCRIPTION

*fea2esig* reads a file *input.fea* in ESPS FEA format (see
*ESPS*(5-ESPS), *FEA*(5-ESPS)) and writes an output file *output.esig*
in *Esignal* format (see Ref. \[1\]) containing the same information (or
a subset thereof). If *input.fea* is "-", standard input is used for the
input file. If *output.esig* is "-", standard output is used for the
output file. The input and output should not be the same file; however,
you can run the program as a filter by specifying "-" for both input and
output.

Normally, the contents of all fields in all input records are copied to
the output; one output record is written for each input record. However,
with the **-r** option, one can restrict processing to a subrange of the
input records, and with the **-f** option, one can restrict processing
to a specified subset of the input fields.

Each ESPS FEA field in the input (if retained) becomes an Esignal
REQUIRED field with the same name in the output. The rank and dimensions
of the field are preserved. The data type of the output is the Esignal
type corresponding to the ESPS type of the input field, as shown in the
following table.


    	ESPS	Esignal	Esignal   	ESPS
    	DOUBLE	DOUBLE	DOUBLE_CPLX	DOUBLE_COMPLEX
    	FLOAT	FLOAT	FLOAT_CPLX	FLOAT_COMPLEX
    	LONG	LONG	LONG_CPLX	LONG_COMPLEX
    	SHORT	SHORT	SHORT_CPLX	SHORT_COMPLEX
    	BYTE	SCHAR	SCHAR_CPLX	BYTE_COMPLEX
    	CHAR	CHAR
    	CODED	SHORT

The output field for an ESPS CODED field (see *FEA*(5-ESPS)) has a
GLOBAL subfield named "enumStrings" that is a character matrix (type
CHAR, rank 2) containing the string values of the coded type, one per
row, padded to a common length with null characters '\0' on the right.
Row 0 (the first row) contains the string for code 0, row 1 contains the
string for code 1, etc.

If the input file is tagged, the tags map into a REQUIRED field named
"Tag" in the output; the field is scalar (rank 0) with data type LONG.

Each ESPS generic header item in the input becomes an Esignal GLOBAL
field with the same name in the output. The rank of the Esignal field
is 1. Its data type is given by the following table.


    	Esignal	ESPS	Esignal	ESPS
    	DOUBLE	DOUBLE	CHAR	CHAR
    	FLOAT	FLOAT	EFILE	CHAR
    	LONG	LONG	AFILE	CHAR
    	SHORT	SHORT	CODED	SHORT

The output field for a CODED header item, like that for a CODED field,
has a GLOBAL subfield named "enumStrings" that is a character matrix
containing the string values of the coded type.

The command line with which *fea2esig* is invoked is converted to a
character string and added to the output file header as a GLOBAL field
named "commandLine".

If the input file belongs to a special FEA subtype such as FEA_SD,
FEA_ANA, or FEA_SPEC, the output file had a scalar GLOBAL field named
"FeaSubtype" that has type SHORT and contains the subtype code (e.g. 8
for FEA_SD, 2 for FEA_ANA, 7 for FEA_SPEC; the complete set of codes is
defined in the ESPS header file *esps/fea.h*). If defined, *FeaSubtype*
has a GLOBAL subfield *enumStrings* like that for CODED FEA fields and
header items. Each row of the character matrix contains the name of the
corresponding subtype---e.g. "FEA_SD" in row 8, "FEA_ANA" in row 2, etc.
Row 0 contains the string "NONE" as a placeholder, though *fea2esig*
does not create the field *FeaSubtype* if the subtype code is 0. The
field *FeaSubtype* is created only to preserve information in the FEA
header so that the program *esig2fea*(1-ESPS) can restore the subtype
when converting the Esignal file back to a FEA file; the notion of a FEA
subtype has no exact parallel in the Esignal framework.

The output file header has a single VIRTUAL field named "source_0",
whose subfield list consists of the input header, converted from FEA
format to Esignal. The field contains a string that gives the name of
the input file, or "\<stdin\>" if "-" was specified for the input. The
source-file field list is usually similar to the output-file field list,
but there are a number of differences. The source-file field list
records all the fields of the input file, even if the **-f** option is
used to specify that only some input fields are retained in the output.
The "commandLine" field in the source-file field list contains the
*variable.comment* string from the input header. The field lists of the
VIRTUAL fields "source_0", "source_1", . . . within "source_0" (i.e. the
subfields "source_0.source_0", "source_0.source_1", etc.) consist of the
embedded source headers of the input file, converted from FEA format to
Esignal.

If the input file contains the waves generic header items *record_freq*
and *start_time,* the program creates corresponding waves GLOBAL fields
*recordFreq* and *startTime* in the output file. These are the header
items that *xwaves*(1-ESPS) uses for time alignment of displays of files
with uniformly spaced records. The value of *recordFreq* is just that of
*record_freq.* The value of *startTime* is obtained from that of
*start_time* by adding an offset that is the time difference between the
first record of the input file and the first record that is copied to
the output. The offset is 0 unless the **-r** option is used to specify
a starting point other than the first input record. (See the
\`\`Options'' section.) In that case, the offset is the result of
subtracting 1 from the first record number and then dividing by the
value of *recordFreq.* Like other input generic header items,
*record_freq* and *start_time,* if present, are represented in the
output by GLOBAL fields with the same names. In this case, the field
*start_time* is simply a copy of the input generic header item
*start_time;* it is the GLOBAL field *startTime* that contains the
correct starting time of the output file.

# OPTIONS

The following options are supported. Default values are shown in
brackets.

**-a** *format \[NATIVE\]*  
specifies whether the output Esignal format is ASCII (ASCII), native
binary (NATIVE---the default), or portable binary (EDR1 or EDR2).

**-f** *field*  
specifies the name of an input field to be retained in the output file.
The option may be repeated to specify several input fields to be
retained. If the option is not specified, all input fields are retained.

**-r** *start***:***last \[1:(last in file)\]*  
**-r** *start***:+***incr*  
**-r** *start*  
In the first form, a pair of unsigned integers specifies the range of
input records to be processed. Input record numbers follow ESPS FEA file
conventions: the first record in the file is number 1. Either *start* or
*last* may be omitted; then the default value is used. If *last* =
*start* + *incr,* the second form (with the plus sign) specifies the
same range as the first. The third form (omitting the colon) specifies a
single record.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *fea2esig* writes debugging messages on
the standard error output. Larger values result in more output. The
default is 0, for no output.

**-A** *width*  
specifies that ASCII output contains bracketed annotations that indicate
record numbers, field names, and array indices. The argument indicates
the desired approximate width of the output (number of characters per
line). In the present implementation the approximation is quite rough:
many lines, especially in headers, may well exceed the specified width,
and others, particularly in CHAR data, may be narrower than necessary.
The option is ignored for binary output.

**-F**  
specifies output in *field order.* If the option is not specified, the
output is in *type order,* the default.

# ESPS PARAMETERS

The ESPS parameter file is not read.

# ESPS COMMON

The ESPS common file is not accessed.

# ESPS HEADERS

As mentioned under \`\`Description'' above, GLOBAL fields corresponding
to generic header items in the input are added to the output file, and
embedded FEA-file source headers, converted to Esignal field lists, are
added as VIRTUAL fields. The comment string in the input header becomes
a GLOBAL field *commandLine* in the output. The input FEA subtype code,
if any. is recorded as a GLOBAL field *FeaSubtype* in the output. If
generic header items *record_freq* and *start_time* are present in the
input header, GLOBAL fields *recordFreq* and *startTime* are added to
the output; see \`\`Description'' above for details.

# FUTURE CHANGES

Fix some of the problems listed under "Bugs".

# EXAMPLES

# ERRORS AND DIAGNOSTICS

The program exits with a "Usage" message if an unrecognized option is
used on the command line, or if too many or too few file names are
specified. It may exit with one of the following error messages if the
described conditions occur:

    can't start before beginning of file;
    empty range of records specified;
    can't allocate memory for input record;
    failure converting input header to field list;
    output order neither TYPE_ORDER nor FIELD_ORDER;
    can't set field ordering of output;
    write header failed.

# BUGS

History information is lost if any of the embedded source headers is a
non-FEA ESPS file (e.g. an old-style SD, ANA, or SPEC file, as distinct
from a FEA_SD, FEA_ANA, or FEA_SPEC file). Confusion is possible if the
input file contains fields with names that *fea2esig* uses for special
purposes---for example, if there is an input field named "commandLine"
or "source_0", or if a tagged input file has a field named "Tag".
*A*-law and *mu*-law encoded FEA_SD files are not recognized as such and
given the appropriate special handling.

# REFERENCES

\[1\] R. W. Johnson, \`\`The Esignal File Format'', Entropic Research
Laboratory, Inc., 1995

# SEE ALSO

*esig2fea*(1-ESPS) *Esignal*(3-Esignal) *ESPS*(5-ESPS),\
*FEA*(5-ESPS),

# AUTHOR

Rod Johnson
