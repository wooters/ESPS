    fea2mat - convert field in FEA file to MATLAB .mat file

# SYNOPSIS

**fea2mat** \[ **-r** *range* \] \[ **-x** *debug_level* \] **-f**
*field_name* *infile.fea outfile.mat*

# DESCRIPTION

This program reads data from the numeric field *field_name* in the FEA
file *infile.fea* and writes it to the file *outfile.mat* in a format
which Matlab can read.

The field *field_name* can be either scalar, vector, or matrix (rank =
0, 1, or 2). If it is a scalar or vector, data is read from records
specified through *range*. The Matlab variable is then a matrix in which
row *i* contains the values of *field_name* from record *i* in
*infile.fea*. If *field_name* is a matrix, a single record must be
specified from which the data is to be read.

# OPTIONS

The following options are supported:

**-x** *debug_level* **\[0\]**  
Increasing values provide more detailed commentary on program's
progress.

**-r** *range*  
Select a range of records to process. The default is to process all the
records in the file.

**-f** *field_name*  
Name of field in the input file from which data is read - this field
must be provided.

# ESPS PARAMETERS

No parameter file is read.

# ESPS COMMON

No common processing is performed.

# ESPS HEADERS

Output file is not an ESPS file.

# SEE ALSO

mat2fea(1-ESPS), FEA(5-ESPS)

# AUTHOR

Program and man page by Bill Byrne.
