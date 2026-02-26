# NAME

bhd - behead an ESPS file

# SYNOPSIS

**bhd** \[ **-h** \] \[ **-F** \] *infile* *outfile*

# DESCRIPTION

*Bhd* reads an ESPS file (*infile*), chops the header from the data,
discards the header, and writes the data to *outfile*. If the **-h** is
used, *bhd* instead discards the data and writes the header to
*outfile*.

When used without **-h**, *bhd* allows the contents of an ESPS file to
be passed to non-ESPS programs (For a table giving the binary data
format, use *fea_element* (1-ESPS).) If you want to pass the data to
non-ESPS programs in ASCII format, use *pplain* (1-ESPS).

When used with **-h**, *bhd* yields pure-header files that may be useful
as external ESPS references in the headers of other files. (See *addgen*
(1-ESPS).)

The **-F** option causes a foreign header to be retained on the output
file, if one is present. In most cases, such a foreign header would have
been included in the ESPS file by the use of the **-F** option on either
*addfeahd*(1-ESPS) or *btosps*(1-ESPS). However, the foreign header
could also have been saved by a user written program.

If the **-F** option is used with the **-h** option, then the foreign
header is written to the output file following the ESPS header. If the
**-F** option is used without the **-h** option, then the foreign header
is written to the output file before the data.

If infile = "-", standard input is read; if outfile = "-", standard
output is written.

If the input file is in EDR format a warning is printed on those
machines where the native machine format is not the same as EDR. In
these cases, the output file might not be very useful. The file can
first be converted to native format if necessary.

# ESPS HEADERS

This program ignores all header items.

# ESPS PARAMETERS

This program does not access the parameter file.

# OPTIONS

The following options are supported:

**-h**  
Produce a header-only ESPS file in *outfile*.

# EXAMPLE(S)

Suppose you need to check that two versions of a program are writing
identical output data, though there may have been header changes. Do the
following with output files from the two programs.

**bhd** *file.1 file.1.nh* \
**bhd** *file.2 - \|* **cmp** *- file.1.nh*

# SEE ALSO

    hdshrink (1-ESPS) , addgen (1-ESPS), addfea (1-ESPS), 
    pplain (1-ESPS), btosps (1-ESPS), addfeahd (1-ESPS), 
    ESPS(5-ESPS), read_header (3-ESPS)

# DIAGNOSTICS

    Usage: bhd [-h] infile outfile
    bhd: can't open filename: reason
    bhd: filename is not an ESPS file

# BUGS

None known.

# AUTHOR

Rodney Johnson.
