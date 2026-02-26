# NAME

addgen - adds generic header items to an existing or new ESPS file
header

# SYNOPSIS

**addgen** \[ **-g** *generic_name* \] . . . \[ **-t** *generic_type*
\] . . . \[ **-v** *generic_value* \] . . . \[ **-x** *debug_level* \]
\[ **-F** \] \[ **-P** *params* \] *espsfile.in* \[ *espsfile.out* \]

# DESCRIPTION

*Addgen* creates a new file *espsfile.out*, copies the header from
*espsfile.in* to *espsfile.out*, adds the specified generic header item,
and copies the data from *espsfile.in* to the output file. If
*espsfile.out* is not supplied, then the generic header item is added to
the input file *espsfile.in*. In this case a temporary copy is created
in the process. (The temporary file will be create in the directory
specified by the environment variable ESPS_TEMP_PATH, with /usr/tmp as
the default).

If *espsfile.in* does not exist, then *addgen* creates a new ESPS FEA
file and adds the generic header item (in this case *espsfile.out* may
not be supplied). The resulting file *espsfile.in* has a single field
defined (name: ADDGEN; type: SHORT; size: 1) and no data records. This
*addgen* capability is useful when the resulting file (with additional
generics defined in the header) will serve as an external ESPS file
reference in the headers of other ESPS files. Thus, common parameters
for a large set of ESPS files can be stored one time only.

Values for all three options **-g**, **-t**, and **-v** must be
specified, or *addgen* exits with an error message. The values may be
specified on the command line, in the params file, or jointly in the
params file and on the command line. If *espsfile.in* is not an ESPS
file, *addgen* prints an error message and exits.

If *espsfile.in* = "-", standard input is read; if *espsfile.out* = "-",
standard output is written.

More than one generic header item can be added to the output header by
repeating the three options **-g**, **-t**, and **-v** on the command
line. Each must be given the same number of times, up to a maximum of
100.

# OPTIONS

The following options are supported:

**-g** *generic_name*  
Specifies the name of the generic header item. If a generic header item
by this name already exists, *addgen* warns and exits unless **-F** is
also specified.

**-t** *generic_type*  
Specifies the type of the generic header item. Allowable values are
DOUBLE, FLOAT, LONG, SHORT, CHAR, EFILE, and AFILE.

**-v** *generic_value*  
Specifies the value of the generic header item. For CHAR, EFILE, and
AFILE, the value is a quoted string. For EFILE (external ESPS file) and
AFILE (external ASCII file) the string gives the name of the file, which
can be a full path name. If there is no leading "/" or hostname in the
string, the path to the current working directory is prepended
automatically. If there is a leading hostname, the hostname must be
followed by a full path (i.e., starting with "/"). A leading hostname
has the form of a string followed by a colon. For example,
"epiwrl:/usr/speech_data/male/fricative.sd" is a properly formated EFILE
value. If a leading hostname is not followed by a full path, *addgen*
prints an error and exits. Note that the use EFILE and AFILE types with
leading hostnames can be expensive, as the current implementation causes
programs like *psps*(1-ESPS) **-e** or *get_genhd_efile*(3-ESPS) to copy
the entire referenced file from across the network via *rcp*.

**-x** *debug level \[0\]*  
If *debug_level* is nonzero then debugging output from library functions
is enabled. *addgen* does not do any debug output currently.

**-F**  
This forces the overwriting of an existing header item. If the **-g**
named generic header item already exists in the input file, *addgen*
(1-ESPS) normally warns the user and exits. By specifying the **-F**
option, *addgen* (1-ESPS) will overwrite the existing value with the new
specified value.

**-P** *param* **\[params\]**  
Specifies the name of the parameter file.

# ESPS PARAMETERS

The following parameters are read, if present, from the parameter file:

> *generic_name - string*

> This is the name of the generic header item to add.

> *generic_type - string*

> This is the type of generic header item to add. Allowable DOUBLE,
> FLOAT, LONG, SHORT, CHAR, EFILE, and AFILE.

> *gen_value_f - float*

> *gen_value_i - integer*

> *gen_value_s - string*

> These are used to specify the value of the generic header item to add.

> At present, there are three types of values that can be specified in a
> parameter file: *int*, *float*, and *string*. *Int* is used to input
> LONG and SHORT. *float* is used to input FLOAT and DOUBLE, and
> *string* is used to specify character strings. Only one value is read
> from the parameter file for the generic header item that is being
> added - either *gen_value_f*, *gen_value_i*, or *gen_value_s* - and
> which value is read depends on the value of *generic_type*. For
> example if *generic_type = DOUBLE*, *gen_value_f* should be specified
> in the params file. If *generic_type* is CHAR, EFILE, or AFILE,
> *gen_value_s* should be specified in the params file. See the
> discussion of string format under **-v**, above.

Remember that command line option values override parameter file values.

# ESPS HEADERS

All old header values are copied and the specified header value is
added. The input ESPS file is not treated as a source file within the
recursive header. The *date* field in the universal portion of the
output header is not affected by *addgen* (i.e., it is the same as that
of the input header). Besides the usual command line in the comment
field, a comment is added giving the name of the added generic header
item, the user name, and the date/time at which it was added.

*addgen* (1-ESPS) can be used to add the *start_time* and *record_freq*
generics that are required by *waves+*. It can also be used to modify
the values of any generic header items.

# ESPS COMMON

ESPS Common is not used.

# FUTURE CHANGES

None contemplated.

# SEE ALSO

    addfea (1-ESPS), comment (1-ESPS), psps (1-ESPS), pplain (1-ESPS), 
    bhd (1-ESPS), inhibit_hdr_date (3-ESPS), ESPS(5-ESPS)

# WARNINGS

Sphere files are not supported. Files in Esignal format are not
supported. PC WAVE format files are not supported. To add generic header
items to files of these types (and convert them to ESPS files) put
addgen(1-ESPS) on a pipe from copysps(1-ESPS).

# BUGS

# AUTHOR

Manual page and code by David Burton. Modifications by John Shore, Alan
Parker, Derek Lin, and Rod Johnson.
