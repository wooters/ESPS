# NAME

comment - displays or adds strings in comment or typtxt field in
existing ESPS file headers

# SYNOPSIS

**comment** \[ **-C** *commfile* \] \[ **-c** *comment* \] \[ **-t** \]
\[ **-a** \] \[ **-S** \] *espsfile*

# DESCRIPTION

When called without the options, *comment* writes the contents of the
*variable.comment* field in the header of the ESPS file *spsfile* to
standard output. Normally this field contains the command line that was
used to create the file along with informal comments added subsequently
(using *comment **-c**).* Other options result in the output of comments
from all the embedded headers thereby yielding a complete history of
*espsfile* (**-a**), the addition of new comments (**-c** and **-C**)
and the treatment of the *variable.typtxt* field instead of the
*variable.comment* field. If *espsfile* is not an ESPS file, *comment*
prints an error message and exits. *Comment* prepends the comment with a
line containing the user name and the current date and time (this can be
suppressed using the **-S** option).

*comment* creates a temporary file in the directory specified by the
environment variable ESPS_TEMP_PATH (default /usr/tmp).

# OPTIONS

The following options are supported:

**-C**  
Causes *comment* to add a comment to *espsfile.* If the argument
*commfile* is given and is the name of an ASCII file, the contents of
*commfile* are added to *variable.comment* in the header of *espsfile.*
If the argument *commfile* is "-", the user is prompted for the comment,
which is then typed in directly and terminated with a blank line or a
**^**D. If the argument *commfile* is given but is not the name of an
ASCII file, *comment* exits with an error message.

**-t**  
Causes *comment* to work on *variable.typtxt* instead of
*variable.comment.* The *typtxt* field is normally used to record the
text corresponding to sampled data.

**-c *comment***  
The ASCII string *comment* is added as a comment.

**-a**  
Causes *comment* to output the comments from all the embedded headers.
Since the comment field includes the command line used to generate the
header, the **-a** option yields an informal history of *espsfile*.

**-S**  
Suppresses the (otherwise automatic) comment that records the user name,
current date, and current time).

# ESPS PARAMETERS

The ESPS parameter file is not read by *comment.*

# ESPS HEADERS

When a comment is added to the header, the input ESPS file is not
treated as a source file within the output recursive header (since the
input and output files are the "same"). The *date* field in the
universal portion of the output header is not affected by *comment*
(i.e., it is the same as that of the input header). Besides the usual
command line in the comment field, a comment is added giving the name of
the added generic header item, the user's name, and the date/time at
which it was added.

# WARNINGS

Sphere, esignal and PC WAVE file formats are not supported. You need to
create an ESPS version by using copysps(1-ESPS) to add a comment.

# FUTURE CHANGES

None Contemplated.

# SEE ALSO

    psps (1-ESPS), addgen (1-ESPS), pplain (1-ESPS), 
    inhibit_hdr_date (3-ESPS), ESPS(5-ESPS)

# WARNINGS

# BUGS

# AUTHOR

Alan Parker
