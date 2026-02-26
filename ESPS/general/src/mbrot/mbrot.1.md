# NAME

mbrot - compute elements of Mandelbrot set

# SYNOPSIS

**mbrot** \[ **-b** *bottom_edge* \] \[ **-t** *top_edge* \] \[ **-l**
*left_edge* \] \[ **-r** *right_edge* \] \[ **-c** *confidence* \] \[
**-g** *grid_pts* \] \[ **-C** \] \[ **-x** \] *output_file*

# DESCRIPTION

*Mbrot* computes points that are in the Mandelbrot set. This is the set
of all points *Z* in the complex plane such that C = C \* C + *Z* stays
bounded as it is recursively repeated.

*Mbrot* produces an ESPS feature file, FEA(5-ESPS), that contains two
fields: *X_pos* ( type DOUBLE) and *mbrot* (type SHORT). *X_pos* is a
scalar variable and is the x-axis coordinate of the vertical data vector
stored in the *mbrot* field. *mbrot* is a vector of size *grid_pts* + 1
(see **-g**); the zeroth element of the *mbrot* field has y-axis
coordinate of *bottom_edge* (see **-b**). If "-" is supplied in place of
*output_file,* then standard output is used.

# OPTIONS

The following options are supported:

**-b** *bottom_edge \[-1.\]*  
Specifies the lower edge of the region over which the Mandelbrot set is
computed.

**-t** *top_edge \[1.\]*  
Specifes the upper edge of the region over which the Mandelbrot set is
computed.

**-l** *left_edge \[-1.9\]*  
Specifies the left edge of the region over which the Mandelbrot set is
computed.

**-r** *right_edge \[.6\]*  
Specifies the right edge of the region over which the Mandelbrot set is
computed.

**-c** *confidence \[342\]*  
Specifies the number of iterations used to decide whether the point is
in the set. That is, if after **-c** specified iterations of the
recursion the point is still bounded (real and imaginary parts less than
2 in magnitude), then the point is considered to be in the set. The
larger the *confidence* factor, the sharper the set boundaries become
(and often the more interesting the image looks).

**-g** *grid_pts \[100\]*  
Specifies the number of grid cells to use in dividing the region of
interest. Often, the larger the number of *grid_pts*, the more
interesting the image looks.

**-C**  
By default, *mbrot* returns 0 if the point is not in the set and 1 if
the point is in the set. By specifying **-C**, each point is assigned a
value between -64 and 50. Points in the set get 50. Proportionally lower
values are given to all other points based on how close there are to
being in the set. For example, if the *confidence* factor is 114 and the
point falls out of the set after 90 iterations, the value given this
point is 26 ( = 90 - 64 ). To make full use of the *xwaves* colormaps,
make sure that the **-c** specified value is an integer multiple of 114.

**-x**  
If specified, debug information is printed to stderr.

# ESPS PARAMETERS

The parameter file is not processed.

# ESPS COMMON

ESPS Common is not read by *mbrot.*

# ESPS HEADERS

In addition to the usual header values for FEA (5-ESPS) files, *mbrot*
writes the following values: *num_grid_pts* (LONG), *num_iterations*
(LONG), *left_edge* (DOUBLE), *right_edge* (DOUBLE), *bottom_edge*
(DOUBLE), *top_edge* (DOUBLE), *X_inc* (DOUBLE), *Y_inc* (DOUBLE),

# FUTURE CHANGES

Parameter file processing will be added.

# EXAMPLES

By default, *mbrot* (1-ESPS) produces the classical fuzzy bug. Try the
following:

> %mbrot - \| image -embrot -S500:400 -

For a more interesting display, try

> %mbrot -C -l-1.254 -r-1.2536 -b.0234 -t.0238 -g800 -c798 - \|

> tofspec -fmbrot - mbrot.fspec&

This will take a while to complete, but when it is done use *xwaves* to
view the FEA_SPEC (5-ESPS) file.

In general, the more interesting images are found on the edges of the
set.

# SEE ALSO

*image* (1-ESPS), *xwaves* (1-ESPS), *tofspec* (1-ESPS)

# WARNINGS AND DIAGNOSTICS

# BUGS

None known.

# REFERENCES

James Gleick, *CHAOS*, New York, PENGUIN BOOKS, 1987

# AUTHOR

Program and manual page by David Burton
