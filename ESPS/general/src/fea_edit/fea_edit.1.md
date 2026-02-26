# NAME

fea_edit - feature file editor

# SYNOPSIS

**fea_edit** \[ **-n** \] \[ **-g** \] *file* \[ *output_file* \]

# DESCRIPTION

*Fea_edit* converts an ESPS feature file into a form suitable for
editing with a text editor, opens the editor of your choice on it and
then converts the edited file back to a feature file. The environment
variable EDITOR is checked for the name of your editor. If EDITOR is not
in the environment, then *vi*(1) is used. The (temporary) text file is
created in the directory specified by the environment variable
ESPS_TEMP_PATH (default /usr/tmp).

*Fea_edit* can be used to edit both the feature file data records and
the header.

The following options are supported:

**-n**  
If the -n option is given, then the header from the input file is not
saved as a source header in the output file.

**-g**  
If the **-g** option is given, then generic header items are also
presented for editing. Otherwise, they are copied from the input to the
output, but not included in the text for editing.

The ascii file to be edited consists of the header information followed
by the data records. The first line in the text contains the value of
the *common.tag* value, the feature file type code, and the
*segment_labeled* value. These values are given in hex (without a
leading 0x). You may edit these values if you know what you are doing.

The next group of lines in the text are the feature file record
definitions from the header. They consist of the field name, followed by
the type of the field (**SHORT, FLOAT,** etc), the size of the field,
the rank, and the dimension values if rank is greater than 1 (see
*FEA*(5-ESPS)). If the field is of type **CODED**, then the possible
values follow this line, each value to a line with a leading blank. This
blank is required and must be maintained if the header is edited. Field
definitions may be added, deleted, or changed. If a field type or size
is changed be sure that data for that field is in the correct format in
the record part of the file. If a field is added, then there should be
no references to that field in the data records.

After the field definitions, there is a blank line, followed by any
generic headers if the **-g** option is used. All generic header item
names are preceded by an '@' (at sign). The type, size, and the values
assigned follow the names. For the coded generic items, the list of
possible coded values are given between brackets ('\[' and '\]') after
the size of the generic field. The white space must always exist before
and after the brackets. Following the possible coded types is the actual
coded type(s) that is assigned to the coded generic item.

The generic headers are followed by a blank line, then the data records.
The format is simply the field name, followed by data of the appropriate
type. If fewer data items are given than required, then the record is
zero filled. If too many data items are given for the field size, then
the extra items are ignored.

# ESPS PARAMETERS

The ESPS parameter file is not referenced.

# ESPS COMMON

The ESPS Common file is not referenced.

# DIAGNOSTICS

If the edited text cannot be parsed, *fea_edit* will print a message and
ask if you want to edit the text again or abort.

# BUGS

This version of the program does not handle feature files with any
complex fields. The next version will.

The conversion from ASCII back to the feature file is fairly rigid. When
editing keep the format the same as the program produced. Do not delete
any blank lines or comments. Future versions will be more
fault-tolerant.

# AUTHOR

Alan Parker and Ajaipal S. Virdy
