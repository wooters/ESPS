# NAME

add_comment - adds a string to the comment field of a ESPS file header

# SYNOPSIS

void add_comment (hd, text)\
struct header \*hd;\
char \*text;

# DESCRIPTION

*add_comment* appends the null terminated string pointed to by *text* to
the field *variable.comment* in the ESPS header pointed to by *hd*. The
maximum length of the comment field is MAX_STRING, defined in
*\<esps/header.h\>.* If there is not enough room left in the comment
field for the new text, then the function prints a warning to *stderr*.
In most cases, ESPS programs will add new-line terminated strings to the
comment field, making notes of processing steps. This function does not,
however, add a new-line to the text passed through it.

Since *add_source_file*(3-ESPSu) copies the comments from the source
file to *variable.comment*, in most cases *add_comment* should be used
only after all calls to *add_source_file* have been made.

# EXAMPLE

add_comment (hd, get_cmd_line (argv, argc));\
/\* appends program command line to hd -\> variable.comment \*/

# BUGS

None known.

# SEE ALSO

ESPS(5-ESPS)

# AUTHOR

Alan Parker
