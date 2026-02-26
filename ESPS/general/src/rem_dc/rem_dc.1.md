# NAME

rem_dc - remove the DC component from an ESPS sampled data file.

# SYNOPSIS

**rem_dc** \[ **-x** *debug_level* \] \[ **-r***r range* \] \[ **-p**
*xrange* \] \[ **-l** *yrange* \] \[ **-a** *offset* \] *in_file
out_file*

# DESCRIPTION

The program *rem_dc* takes the ESPS sampled data file *in_file,*
computes the DC offset of the data, subtracts it from each data point,
and places the resulting data in *out_file.* The program can optionally
adjust the DC offset to a user specified value. The program enters the
total adjustment in the header of *out_file. A temporary file is created
(and removed) in the directory* specified by the environment variable
ESPS_TEMP_PATH (default /usr/tmp).

If *in_file* is "-", then the standard input is read. If *out_file* is
"-", the program writes to standard output.

# OPTIONS

The following options are supported:

**-x** *debug_level*  
A value of 0 (the default value) will cause *rem_dc* to do its work
silently, unless there is an error. A nonzero value will cause various
parameters to be printed out during program initialization.\

**-p** *xrange*  
The range of points to compute the DC value over, remove the DC value
from, and copy to the output file. The *xrange* argument is a text
string which obeys all the conventions used by the *range_switch
(3-ESPSu)* function. The default values for the beginning and ending
points of *xrange* are the first and last data points in the file.\

**-r** *xrange*  
**-r** is a synonym for **-p**.\

**-l** *yrange*  
Only data points whose values fall in the specified range will be used
to compute the DC component. This allows the user to use only small
magnitude numbers, for example, to obtain a more accurate result. The
*yrange* argument is a text string which obeys all of the conventions
used by the *frange_switch (3-ESPSu)* function. The default values for
the upper and lower limits of *yrange* are the maximum and minimum
values in the file.\

**-a** *offset*  
The DC component is adjusted to *offset.* The default value for *offset*
is 0.0.\

# ESPS PARAMETERS

The parameter file is not accessed.

# ESPS COMMON

If standard input is not specified, the following items are read from
ESPS Common:

filename  
This is the name of the input file. If no input file is specified on the
command line, *filename* is taken to be the input file name. If an input
file is specified on the command line, the input file name must match
*filename* or other items (below) are not read from Common.

start  
This is the starting point in the input file to begin processing. It is
not read if the **-p** option is used.

nan  
This is the number of points to process. It is not read if the **-p**
option is used.

If *start* and/or *nan* are not given in the Common file, then *start*
defaults to the beginning of the file and *nan* defaults to the number
of points in the file.

If standard output is not specified, the following items are written to
the ESPS Common:

start  
One is written to the Common file.

nan  
The number of points processed by *rem_de* is written to the ESPS
Common.

filename  
The name of the output file is written to ESPS Common.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADER

All appropriate input file header items are copied to the output file
header. Also, the *dc_removed* (type DOUBLE) and *start_time* (type
DOUBLE) are also added or updated. A *max_value* generic header item is
added by *rem_dc* (1-ESPS).

# BUGS

None known.

# AUTHOR

Brian Sublett; modified for ESPS by David Burton.
