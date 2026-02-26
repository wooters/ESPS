    mat2fea - convert Matlab .mat file data to FEA file

# SYNOPSIS

**mat2fea** \[ **-c** *comment_text* \] \[ **-x** *debug_level* \] \[
**-m** \] **-f** *variable_name* *infile.mat outfile.fea*

# DESCRIPTION

This program reads the Matlab matrix variable *variable_name* from the
Matlab data file *infile.mat*, creates the ESPS FEA file *outfile.fea*,
and writes the variable data to the FEA field *variable_name*. The
variable is taken as a *M x N* matrix. The default behavior is to create
a field of size *N* in the output file and write row *n* to record *n*
so that *outfile.fea* has *N* records. If **-m** is specified, the
output field is created as a *M x N* matrix and the data is written to a
single record of *outfile.fea*. Matlab string variables (ASCII data) are
not supported.

# OPTIONS

The following options are supported:

**-x** *debug_level* **\[0\]**  
Increasing values provide more detailed commentary on program's
progress.

**-m**  
Write data to single record output file as a matrix. Default behavior is
is to write one record for each row of the matrix.

**-f** *field_name*  
Name of variable in the input file from which data is read - this field
must be provided.

# ESPS PARAMETERS

No parameter file is read.

# ESPS COMMON

No common processing is performed.

# ESPS HEADERS

The command line and comment string, if provided, are added to the
output header as comments. The output field *variable_name* has data
type DOUBLE or DOUBLE_CPLX, depending on the input data.

# BUGS

Sometimes has trouble reading information about the variables when
*infile.mat* contains more than one variable.

# SEE ALSO

fea2mat(1-ESPS), FEA(5-ESPS)

# AUTHOR

Program and man page by Bill Byrne.
