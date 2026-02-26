# NAME

hditem - print an item from an ESPS file header

# SYNOPSIS

**hditem** \[ **-s** \] **-i** *item_name* *file*

# DESCRIPTION

*Hditem* prints an item from an ESPS file header on the standard output.
If the **-s** (silent) option is given, it merely returns a success or
failure status, depending on whether or not the given generic item is
defined in the file header.

*Hditem* looks for items by the name given in ESPS(5-ESPS) (the common
or universal part of the header) and generic header items. Sometimes
these names are the same as the names printed by psps(1-ESPS), but this
is a coincidence. Support for the psps(1-ESPS) item names is not
provided.

If - is specified as the input file, standard input is read.

The following "items" are universal or common header items and are
always recognized:

program  
The program that created the file

version  
The version of the program that created the file.

progdate  
The date the program that created the file was compiled.

date  
The file creation date

typtxt  
The typtxt field in the file header

comment  
The comment text in the file header

current_path  
The path (including host name) to the directory where the file was
created

ndrec  
The number of data records in the file

type  
The ESPS type code.

hdvers  
The version number of header.h used to make the input file.

user  
The first 8 characters of the username (login name) of the creater of
the file.

Two pseudo items are also always recognized:

hostname  
The host system on which the file was created

cwd  
The directory path to where the file was created on the host system.

These two items make up the *current_path* item described above. They
have been broken out to make shell script processing easier.

Other items are searched for using the *get_genhd*(3-ESPS) call.

# OPTIONS

The following options are supported:

**-s**  
Silent mode. Just return success or failure to the shell (unless the
file specified is not a valid ESPS file).

**-i** *item_name*  
Specify the name of the header item whose value is desired.

# ESPS PARAMETERS

The parameter file is not read.

# ESPS COMMON

The common file is not used.

# WARNINGS

Note that *hditem* gives the warning message **Broken pipe**, if it is
on a pipe line.

# EXAMPLES

Print the number of samples in *peter.sd*:


        %hditem -i ndrec peter.sd

# BUGS

None known.

# EXPECTED CHANGES

Add support for fea_type, segment_labeled, and field_count as items in
FEA files and complex generic header items.

# AUTHOR

Joe Buck. ESPS 3.2 conversion and item expansion by David Burton.
