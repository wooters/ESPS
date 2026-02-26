# NAME

psps - print headers and data from an ESPS file in pretty ASCII form

epsps - print headers and data from an ESPS file in pretty ASCII form

# SYNOPSIS

**psps** \[ **-aDghHlvxe** \] \[ **-r***range* \] \[ **-t***range* *(of
tags)* \] \[ **-f***field_name* \] *file*

# DESCRIPTION

*Psps* pretty-prints header information and data from an ESPS file. If
no options are given, the common part of the header (see ESPS(5-ESPS))
is printed followed by the data records. By default all data records are
printed.

An alternate name for *psps* is *epsps.* Use *epsps* to avoid a naming
conflict with the Sun OpenLook program psps.

The format of the output depends on the ESPS file type. If the file type
is not known to this version of *psps* it prints the data in a general
format. If unformatted, unlabelled, pure ASCII output is wanted, use
*pplain* (1-ESPS) instead.

If *file* is "-", then standard input is used.

# ESPS PARAMETERS

The parameter file is not used.

# ESPS COMMON

The ESPS Common file is neither read nor written.

# OPTIONS

The following options are supported:

**-a**  
Print headers recursively for all source files. Headers are printed in
long format with both common and type specific portions of each header.
(i.e., as for **-l** option). If the **-v** is used in addition, it is
applied to each header. If the **-e** is used in addition, it is applied
to each header.

**-D**  
Suppress printing of data records.

**-g**  
Print data records in a generic format, independent of file type.

**-h**  
Recursively prints the common part of all embedded source file headers.
If the full headers are wanted, use the **-a** option.

**-H**  
Suppress printing of headers.

**-l**  
Print the type-specific portion of the header and also generic header
items. This does not apply to embedded headers. If similar behavior is
wanted for embedded headers, use **-a**. For EFILE (external ESPS file)
and AFILE (external ASCII file) generic header items, just the filename
is printed (full path with possible leading hostname). If you want to
follow the pointer, use **-e**.

**-e**  
Follow references to external files. If any generic header items are of
type EFILE (external ESPS file), the header of that file is printed. If
any of the generic header items are of type AFILE (external ASCII file),
the contents of that file are printed. This option implies **-l** (i.e.,
if you give **-e**, you don't need to give **-l**). This option does not
apply to embedded source file headers. If similar behavior is wanted for
embedded headers, use **-a**.

For EFILE and AFILE items that refer to a file on a different host (the
hostname followed by a colon precedes the full path of the file), *psps*
will copy the file from the remote host and print it. Depending on
network configuration, this can cause *psps* to run slowly.

**-v**  
Verbose printing of FEA headers and generic header items. This option
causes printing of all **-l** information, plus the following: Generic
header types (along with their values), FEA field definitions, field
derivations (if relevant - see *fea_deriv* (1-ESPS)), and the reference
header (if present - see, for example, the discussion of variable.refhd
in *fea_stats* (1-ESPS). If **-e** is specified together with **-v**,
verbose printing also applies to external EFILE headers.

**-x**  
Enable debug output.

**-r** *start:end*  
**-r***"***start:+incr**  
Determines the range of data records to print. In the first form, a pair
of unsigned integers gives the first and last points of the range. If
*start* is omitted, 1 is used. If *end* is omitted, the last point in
the file is used. The second form is equivalent to the first with *end =
start + incr .*

**-t** *range*  
Only print the data record with a tag value within the specified range.
A warning message is printed if this option is specified and the data is
not tagged.

**-f** *field_name*  
Print only the feature file field that matches the given field name. A
warning is printed on stderr if the requested field name does not exist.
This option may be specified as often as desired.

# DIAGNOSTICS

An error message is printed if the specified file does not exist, or if
the file is not an ESPS file.

# SEE ALSO

    fea_print (1-ESPS), pplain (1-ESPS), comment (1-ESPS), 
    addfea (1-ESPS), addgen (1-ESPS), bhd (1-ESPS)

# BUGS

Multichannel FEA_SD files print as generic feature files. More
specialized FEA_SD printing will be added later.

# AUTHOR

Original version by Joe Buck,\
Modified for ESPS by Alan Parker,\
**-t**, **-v**, and **-f** options by Ajaipal S. Virdy,\
Modified (with improvements) for ESPS 3.0 by John Shore.
