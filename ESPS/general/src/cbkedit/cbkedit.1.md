# NAME

cbkedit - codebook file editor

# SYNOPSIS

**cbkedit** \[ **-x** *debug_level* \] *file*

# DESCRIPTION

*Cbkedit* converts an ESPS SCBK file into a form suitable for editing
with a text editor, opens the editor of your choice on it and then
converts the edited file back to a SCBK file. The environment variable
EDITOR is checked for the name of your editor. If EDITOR is not in the
environment, then *vi(1)* is used.

*Cbkedit* can be used to edit both the codebook file data record and the
header. The header item *num_cdwds* is reset to the correct number of
codewords in the edited file. It cannot be edited directly.

When the editor is exited, *cbkedit* asks if it should go ahead and make
the changes, or abort the session. If the changes are accepted, then a
copy of the old file is kept with *.bak* appended to the filename.

# OPTIONS

The following options are supported:

**-x** *debug level*  
Only debug level 1 is defined in this version; this causes several
messages to be printed. The default level is zero, which causes no debug
output.

# ESPS HEADERS

All header items in the output file are the same as those from the input
file, except that *num_cdwds* is updated if codewords were added or
deleting during the edit.

# ESPS PARAMETERS

The ESPS parameter file is not referenced.

# ESPS COMMON

The ESPS Common file is not used by this program.

# BUGS

The conversion from ASCII back to the SCBK file is simple-minded. When
editing keep the format the same as the program produced. Only delete
lines from the data record portion of the file. Do not delete any blank
lines or comments.

# AUTHOR

Alan Parker
