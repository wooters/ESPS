# NAME

    nodiff - nth order difference program

# SYNOPSIS

**nodiff \[** **-o** *order* \] \[ **-f** *field_name* \] \[ **-r**
*range* \] \[ **-x** *debug_level* \] fea.in fea.out

# DESCRIPTION

*Nodiff* is a shell script which finds the nth-order difference of field
*field_name* in the ESPS FEA (5-ESPS) file *fea_in* and writes the
result to the output file *fea.out*. The name of the field in the output
file is obtained by appending one of *\_d1, ..., \_d5* to *field_name*,
in agreement with *order*.

The first order difference of *field_name* is computed element-
by-element as *field_name\[i\]\[recno\] - field_name\[i\]\[recno-1\]*
for all elements **i** of the field *field_name*. The second order
difference is found as *field_name\[i\]\[recno\] -2
field_name\[i\]\[recno-1\]* + field_name\[i\]\[recno-2\].

*Nodiff* uses *tofeasd* (1-ESPS) to translate the specified field in the
input file into a FEA_SD (5-ESPS) file. The output of *tofeasd* is piped
to *filter* (1-ESPS), which uses predefined FEA_FILT (5-ESPS) files to
find the correct order difference. *feafunc* (1-ESPS) is used to give
the filtered data the correct field name, and *mergefea* (1-ESPS) is
used to combine the differenced data with the original data to form the
output records.

# OPTIONS

The following options are supported:

**-o** *order \[1\]*  
determines which order difference to compute; valid values are 1
through 5. The FEAFILT files *diff1.filt*, ..., *diff5.filt* contain the
necessary filter coefficients. They are found in the directory
\$ESPS_BASE/lib/filters.

**-f** *field_name \[spec_param\]*  
name of the field whose difference is to be found.

**-r** *range \[1:last_in_file\]*  
range of records to process. Default is to process every record in the
input file. The **-r** option cannot be used with standard input.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, debugging messages and other information
are printed on the standard error output. The messages proliferate as
the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

There is no paramter processing.

# ESPS COMMON

Common files are not used.

# ESPS HEADERS

All header information is copied from input to output. Additionally,
*filter* (1-ESPS) adds information about the difference filter used.

# BUGS

None known.

# SEE ALSO

copysps (1-ESPS), tofeasd (1-ESPS), filter (1-ESPS),\
feafunc (1-ESPS), mergefea (1-ESPS), ESPS (5-ESPS),\
FEA (5-ESPS), FEA_SD (5-ESPS)

# AUTHOR

Program and man page by Bill Byrne.
