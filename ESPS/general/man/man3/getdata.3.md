# NAME

    get_ddata - get data from a binary file in double precision form
    get_fdata - get data from a binary file in floating form

# SYNOPSIS

get_ddata(stream,dtype,data,npoints)\
FILE \*stream;\
char dtype;\
float data\[\];\
int npoints;

\
get_fdata(stream,dtype,data,npoints)\
FILE \*stream;\
char dtype;\
float data\[\];\
int npoints;

# DESCRIPTION

*Get_data* reads data from a binary file. This file is expected to
contain a stream of bytes, short integers, long integers, floating
values, or double precision floating values. The *dtype* argument
indicates the type of data in the file; it may be 'b', 'w', 'l', 'f', or
'd'. *Npoints* values are read from the file, converted to double by
*get_ddata,* to float by *get_fdata,* and returned in the *data* array.

# DIAGNOSTICS

If a read error occurs, *get_data* prints an error message on the error
output and exits.

# BUGS

Ideally, an error status should be returned on error and the program
should be allowed to determine whether to exit.

# SEE ALSO

    put_ddata(3-ESPSu), put_fdata(3-ESPSu)

# EXPECTED CHANGES

Fix the flaw described in "BUGS".

# AUTHOR
