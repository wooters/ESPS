# NAME

fea_print - print data from FEA records with user-controlled formatting

# SYNOPSIS

**fea_print** \[ **-r** *range* \] \[ **-l** *layout* \] \[ **-x**
*debug_level* \] *stylefile infile.fea*

# DESCRIPTION

*fea_print* outputs the values of selected elements of FEA file records
to stdout in a user-defined format. The input file *stylefile* contains
one or more layout specifications, which specify the elements from
*infile.fea* whose values are to be printed, and the format to be used.
If *infile.fea* is equal to "-", then standard input is used.

*stylefile* is an ASCII file containing a number of multi-line layout
specifications. Each specification is separated from the next by
intervening blank lines. The first line of each layout specification has
the form:


        layout=<layout name>

where "layout name" is a name chosen for that layout. It is this name
which can be specified, using the "-l" option above, to select the
layout specification to be used, and thereby the set of elements to be
printed and the format to be used.

Immediately following the layout keyword line in each specification, up
to three header lines can be specified using one or more of the
constructs:


        header1=<header line one>
        header2=<header line two>
        header3=<header line three>

where "header line n" is an ASCII string to be printed at the beginning
of the output.

Following these keyword lines in the layout specification are a series
of lines of the form:


        <field_name>[<element_range>] <format_string>
    or  <string_constant> <format_string>

where \<field_name\> is the name of a field in *infile.fea,*
\<element_range\> is a list of elements in a form suitable for
*grange_switch* (3-ESPSu), and \<format_string\> is a format string
appropriate for passing to fprintf() in order to print *one* element of
\<field_name\>: fprintf() is called repeatedly to print each specified
element of each field named in the layout specification. A maximum of
100 elements, including string constants, can be printed per record.
Note that an element range must be given for every field name - for
scalar fields, use "\[0\]". Note also that a string format should be
used for printing coded types - although a coded type is stored as a
short in each record, *fea_print* prints the corresponding ASCII string.

Each field name must follow the same rule as C identifiers, i.e. it can
only consist of letters and digits, with the first character being a
letter. The underscore "\_" counts as a letter. The *first* space
following the "\]" character is stripped off: additional spaces, if any,
become part of the corresponding format string. (But it is better to use
"\s" to represent spaces: see below.) In the case of \<string_constant\>
\<format_string\> lines, the *first* space found in the line is
considered to separate the \<string_constant\> from the
\<format_string\>

For example, suppose that *stylefile* contains the following:


        layout=example
        header1= **************** OUTPUT ****************\n
        raw_power[0] power: %5.2f
        frame_type[0] 	type: %s
        spec_param[0] 	RCs: %4.2f
        spec_param[3,5:6]   %4.2f
        spec_param[7]   %4.2f\n

Invoking this layout with a FEA_ANA file would result, for example, in
the following:


        **************** OUTPUT ****************
        power: 52.78    type: VOICED    RCs: 0.92  -0.36  -0.29  -0.04  -0.29
        power: 55.71    type: VOICED    RCs: 0.92  -0.36  -0.29  -0.04  -0.29
        power: 506.98   type: VOICED    RCs: 0.92  -0.36  -0.29  -0.04  -0.29
        power: 154.47   type: UNVOICED  RCs: 0.31  -0.27  -0.22  -0.05  -0.19
        power: 9143.28  type: UNVOICED  RCs: 0.31  -0.27  -0.22  -0.05  -0.19

*fea_print* will exit with an error message if any of the field
specifications do not refer to fields defined in *infile.fea.*

The header and format strings in the layout specifications may contain
"C-like" escape codes. These are two-character sequences beginning with
"\\. The escape codes currently supported are:

    	\n:	newline
    	\t:	tab
    	\s:	space
    	\f:	formfeed
    	\e:	equal sign

Note that it is a good idea for the each header line, and the final
format string in each layout, to end with "\n". Otherwise, LONG output
lines are liable to result!

# OPTIONS

**-r** *range*  
Specifies a restricted range of records from *infile.fea* to be
processed. If this option is not used, all records are processed.

**-l** *layout*  
Use the layout specification named *layout* in *stylefile.* If this
option is not specified, the first layout in *stylefile* is used.

**-x** *debug_level*  
If *debug_level* is nonzero, debugging information is written to the
standard error output. Default is 0 (no debugging output).

# ESPS PARAMETERS

The ESPS parameter file is not read by *fea_print.*

# ESPS COMMON

The ESPS common file is not processed by *fea_print.*

# ESPS HEADERS

*fea_print* does not print any header information.

# DIAGNOSTICS

    fea_print: style and feature files can't BOTH be from stdin!
    fea_print: %s is not an ESPS Feature file.
    fea_print: incorrect subrange given, only %d records in file.
    fea_print: start record greater than end record.
    fea_print: unknown keyword: keyword.
    fea_print: error in style file stylefile:
    	component name %s on line %d precedes layout keywords.
    fea_print: more than %d elements to print per record.
    fea_print: couldn't find format string in stylefile.
    fea_print: layout %s not found in style file stylefile.
    fea_print: no component fields found for field name %s.
    fea_print: get_deriv_vec: encountered error getting field.
    fea_print: more than %d elements to print per record.
    fea_print: can't handle complex fields

# FUTURE CHANGES

Implement formatting of complex type elements, which are not currently
supported. Permit printing of the record number (as a workaround, use
*addfea* or *mergefea* to add a field containing the record number and
then print with *fea_print*).

# SEE ALSO

    ESPS(5-ESPS), FEA(5-ESPS), pplain(1-ESPS), psps(1-ESPS), 
    addfea(1-ESPS), mergefea (1-ESPS)

# BUGS

None known.

# AUTHOR

Program and manual page by Richard Goldhor, Sensimetrics Corp; minor
modifications by John Shore
