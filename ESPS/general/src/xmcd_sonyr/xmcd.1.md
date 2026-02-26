# NAME

xmcd - X filter for plot data in Unix GPS format and interactive
plot/play program when used with plotsd

# SYNOPSIS

**xmcd** \[ **-r** *region* \] \[ **-u** \] \[ **-x** *level* \] \[
**-R** \] \[ **-P** \] \[ **-p** *play options* \] \[ *file.gps* \]

# DESCRIPTION

*Xmcd* reads plot data in Unix Graphic Primitive String (GPS) format and
displays the plot in an X window display. The program emulates a subset
of the functions of the Masscomp program of the same name. *Xmcd* is
intended to be invoked in a *xterm*(1) window and creates a new window
for the plot.

*Xmcd* includes the function of the ESPS Masscomp *range* program. This
feature supports the selection of a range from the plot, zooming in,
zooming out, and calling the ESPS play program on sections of the plot.
See the **-R** and the **-P** options below. Normally these features are
only used by the ESPS script that implements *plotsd(1-ESPS)*.

*Xmcd* uses the X window system calls, and remains active after drawing
the plot. This is so that the plot can be resized, refreshed, or moved.
If you want to regain control of the shell window without removing the
plot window, then be sure to run *xmcd* as a subprocess by putting a
**&** after the command.

Output from the programs *mlplot*(1-ESPS) and *genplot*(1-ESPS) can be
displayed with *xmcd;* files written by the Masscomp *plot*(1G) program
and the graphics editor *ged*(1G) are also acceptable input. The ESPS
programs *plotsd*(1-ESPS), *plotspec*(1-ESPS), *mlplot*(1-ESPS), and
*genplot*(1-ESPS) use *xmcd* internally to implement their **-Tmcd**
option.

If *file.gps* is \`-' or is omitted, standard input is used.

# OPTIONS

**-r** *region*  
Scale the plot so that graphing region number *region* just fits in the
window. Valid values are 1-25.

**-u**  
Scale the plot so that the entire graphing universe just fits in the
window.

The **-r** and **-u** options are mutually exclusive. The default
behavior, in case neither is selected, is to scale the plot so that the
actual plot just fits in the window.

**-R**  
Cause *xmcd* to go into *select/range* mode, after drawing the plot.
This mode is used with some plot programs (*plotsd*(1-ESPS)) and is
called directly by the ESPS plot program. When used this way, *xmcd*
allows the user to select a range from a sampled data plot that is
currently displayed and to enter that range into the ESPS Common file.
It can also be used with *plotsd* and *play* as an interactive plot/play
program.

**-P**  
If the **-P** option is used, then *xmcd* will call the *play* program,
instead of just saving the selected range when the middle button is
pressed in *range mode*. This causes the selected range to by played
(assuming of course, that your system has playback capability and the
ESPS *play* program has been correctly configured). When *play* returns,
if the mouse has not been moved, pressing the middle button again will
save the range into Common. If the mouse has moved, then the program
simply remains in *range mode*.

The ESPS Common file is updated whenever the plot is redrawn (zoom in or
out), or when a segment is played. This could be useful when running
*plotsd/xmcd* in one window and another ESPS program that uses Common in
another window. The top line of the display always tells what the mouse
buttons will do in each mode. To exit at anytime, use the *quit* menu
button.

**-p** *play options*  
This character string is passed to the *play* program on its command
line, each time *play* is called. Enclose the etire argument in quotes.

**-x** *level*  
Print debugging messages to standard error-more messages at higher
levels. The default is 0 (no messages).

In most cases, these options are used by other ESPS programs and not
used directly by user's. See the *plotsd*(1-ESPS) script for an example
of the usage of this program.

# ESPS PARAMETERS

No ESPS parameter file is read.

# ESPS COMMON

The following items are read from the ESPS Common file:

> *beginplot - integer*

> This is the x-coordinate position at the origin of the graph.
>
> *endplot - integer*

> This is the x-coordinate position at the end point of the graph.

The following items are written into the ESPS Common file:

> *start - integer*

> The left point in the range selected.
>
> *nan - integer*

> The number of points in the selected range.

The ESPS Common file is updated everytime *play* or *plotsd* is called
by *range*.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off" (though it would be pointless to do so
when using this program). The default ESPS Common file is

the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

No ESPS file headers are read or written.

# ESPS PARAMETERS

No parameter file is read.

# SEE ALSO

plotsd(1-ESPS), plotspec(1-ESPS), mlplot(1-ESPS), plotspec(1-ESPS)

# FUTURE CHANGES

Implement more of the GPS primitives and expand to a more general
GPStool.

# DIAGNOSTICS

    usage: xmcd [-r region][-u][-R][-P][-p][-x level] [file.gps]
    xmcd: unexpected end of file.
    xmcd: can't open filename: reason

# BUGS

Only a minimal set of the GPS primitives is implemented.

# AUTHOR

Ajaipal S. Virdy
