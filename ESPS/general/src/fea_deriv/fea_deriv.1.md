# NAME

fea_deriv - derive a new FEA file containing elements from an existing
one

# SYNOPSIS

**fea_deriv** \[ **-r** *range* \] \[ **-T** *subtype* \] \[ **-t** \]
\[ **-x** *debug_level* \] *fieldfile infile.fea outfile.fea*

# DESCRIPTION

*Fea_deriv* creates a new FEA file, *outfile.fea,* with fields whose
elements are taken from an existing FEA file *infile.fea* The input file
*fieldfile* specifies the names for the fields in *outfile.fea* and
specifies how these fields are constructed from elements of the fields
in *infile.fea.* If *infile.fea* is equal to "-", then standard input is
used. If *outfile.fea* is equal to "-", standard output is used.

*Fieldfile* is an ASCII file with the following format: The first line
has the form:


        field = <new_field_name>

where "field" is a keyword and \<new_field_name\> is an ASCII string
that gives the name of the first field to be defined for *outfile.fea.*
Following this line is a series of lines containing strings of the form:


        <old_field_name> [ <element_range> ]

where \<old_field_name\> is the name of a field in *infile.fea,* and
where \<element_range\> is a list of elements in a form suitable for
*grange_switch* (3-ESPSu). These lines specify how \<new_field_name\> is
composed of elements from fields in *infile.fea.* The field names
(\<new_field_name\> and \<old_field_name\>) must follow the same rules
as C identifiers, i.e. they can only consist of letters and digits; the
first character must be a letter. The underscore "\_" counts as a
letter.

For example, suppose that *fieldfile* contains the following:


        field = svector
        raw_power[0]
        spec_param[1,3:5]

This is interpreted to mean that the output field *svector* contains
five elements derived from elements in the *raw_power* and *spec_param*
fields of *infile.fea.* In particular, the 5 elements of *svector*
correspond to *raw_power*\[0\], *spec_param*\[1\], *spec_param*\[3\],
*spec_param*\[4\], and *spec_param*\[5\]. Note that the size of the
defined field is implicit in the list of components. The default type of
the derived field is the "highest" type of the component fields. That
is, if they are all ints, then int, if one or more is float, then float,
etc.

Adding an additional line of the form


        type = <data_type>

after the line containing the keyword "field" will explicitly force the
type of the derived field to *data_type*. Additional fields can be
defined by additional sets of specifications in *fieldfile,* with each
field specification beginning with a line starting with "field =".

*Fea_deriv* will exit with an error message if any of the field
specifications do not refer to fields defined in *infile.fea, or any of
the specified fields are of type complex.*

# OPTIONS

**-r** *range*  
Specifies a restricted range of records from *infile.fea* to be
processed. If this option is not used, all records are processed.

**-T** *subtype*  
Specifies that a particular FEA subtype code be set in the output file;
for example "-**T** FEA_SD" forces the output file to be a FEA_SD file.
Note that it is the user's responsibility to make sure that the field
definitions and generic header items are defined appropriately for the
subtype.

**-t**  
Specifies that tags are to be copied from the input file to the output
file.

**-x** *debug_level*  
If *debug_level* is nonzero, debugging information is written to the
standard error output. Default is 0 (no debugging output).

# ESPS PARAMETERS

The ESPS parameter file is not read by *fea_deriv.*

# ESPS COMMON

The ESPS common file is not processed by *fea_deriv.*

# ESPS HEADERS

*fea_deriv* creates a FEA file header for *outfile.fea* based on the
field definitions in *fieldfile.* Generic header items in *infile.fea*
are copied to *outfile.fea* even though some of them may not be
meaningful.

If the input file has the generic header item *record_freq*, then the
generic header item *start_time* is written in the output file. The
value written is computed by taking the *start_time* value from the
header of the input file (or zero, if such a header item doesn't exist)
and adding to it the relative time from the first record in the file to
the first record processed.

If it exists in the input file header, the generic header item
*record_freq* is copied to the output file header. This item gives the
number of records per second of original data analyzed.

The access function *set_fea_deriv* (3-ESPS) is called to set the
*srcfields* header entries - this maintains a record of how the fields
were derived from inputs (such information is used, for example, by
*classify* (1-ESPS)).

# DIAGNOSTICS

    fea_deriv: %s is not an ESPS Feature file.
    fea_deriv: incorrect subrange given, only %d records in file.
    fea_deriv: start record greater than end record.
    fea_deriv: keyword "type" has not been implemented, yet.
    fea_deriv: unknown keyword: keyword.
    fea_deriv: encountered error in field file file, line %d: line.
    fea_deriv: encountered error in parsing component field in file, line %d: line.
    fea_deriv: no keyword found in field file file.
    fea_deriv: no component fields found for field name field_name.
    fea_deriv: no component fields found in field file file.
    fea_deriv: calloc: could not allocate memory for array.
    fea_deriv: add_fea_fld: could not add field name %s.
    fea_deriv: set_fea_deriv: %s is not a defined field in file.
    fea_deriv: get_deriv_vec: encountered an error getting derived field.

# FUTURE CHANGES

Implement "type = ... ."

# SEE ALSO

ESPS (5-ESPS), FEA(5-ESPS), FEA_STAT(5-ESPS),\
fea_stats(1-ESPS), set_fea_deriv(3-ESPSu),\
get_fea_deriv(3-ESPSu)

# AUTHOR

Manual page by John Shore, program by Ajaipal S. Virdy.
