# NAME

    put_ddata - convert and write double precision data to a binary file
    put_fdata - convert and write float data to a binary file

# SYNOPSIS

put_ddata(stream,dtype,data,npoints)\
FILE \*stream;\
char dtype;\
float data\[\];\
int npoints;

\
put_fdata(stream,dtype,data,npoints)\
FILE \*stream;\
char dtype;\
float data\[\];\
int npoints;

# DESCRIPTION

*Put_data* writes data to a binary file. The data to be written is an
array of double precision floating values. The data in the file is will
consist of bytes, short integers, long integers, floating values, or
double precision floating values. The *dtype* argument indicates the
type of data to be written to the file; it may be 'b' (byte), 'w'
(word - short integer), 'l' (long integer), 'f' (float), or 'd'
(double). *Npoints* values from the *data* array are converted from
double by *put_ddata,* from float by *put_fdata,* to the desired type
(with rounding) and written to the file. If the absolute value of a
value in *data* is too large to be represented in the output type, it is
clipped - replaced by the largest positive or negative value of the
output type.

# DIAGNOSTICS

If a write error occurs, *put_ddata* prints an error message on the
error output and exits.

# BUGS

Ideally, an error status should be returned on error and the program
should be allowed to determine whether to exit.

# SEE ALSO

    get_ddata(3-ESPSu), get_fdata(3-ESPSu)

# EXPECTED CHANGES

Fix the flaw described in "BUGS".

# AUTHOR
