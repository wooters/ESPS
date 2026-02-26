# NAME

    zero_pad - append or prepend empty records to a fea file

# SYNOPSIS

**zero_pad** \[ **-x** *debug_level* \] \[ **-l** *padding* \] \[ **-L**
*padding* \] \[ **-i** \] \[ **-d** \] input.fea output.fea

# DESCRIPTION

*zero_pad* reads data from the fea file *input.fea* and copies it to the
fea file *output.fea.* Additional records are appended to the data from
*input.fea,* unless the **-i** option is specified, in which case they
are written to *output.fea* before the data from *input.fea.* By default
the additional records are empty (the fields in the records are zeros)
unless the **-d** option is specified.

# OPTIONS

The following options are supported:

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *zero_pad* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

**-i**  
If specified, the additional records are written to *outfile.fea* before
the data of *input.fea.* If not specified, the additional records are
written to *outfile.fea* after the data of *input.fea.*

**-l** *padding \[0\]*  
specifies the number of additional records which should be written to
**output.fea.**

**-L** *padding \[0\]*  
specifies in seconds the duration of the additional data which should be
written to **output.fea.** The generic header item **record_freq** is
read from the header of **input.fea** to convert the duration from
seconds to records. **-L** and **-l** cannot be used together.

**-d**  
specifies that data from **input.fea** should be extended to provide the
additional records. The default is to use empty records. If **-i** is
specified, the first record of *input.fea* is duplicated to provide the
additional data needed to prepend. If **-i** is not specified, the last
record of *input.fea* is duplicated to provide the data to append.

# ESPS PARAMETERS

No parameters are supported.

# ESPS COMMON

Common is not processed.

# ESPS HEADERS

The header of *input.fea* is copied to *output.fea.* The (long) generic
header item *records_padded* is added to the output header.

# BUGS

None known.

# AUTHOR

Bill Byrne
