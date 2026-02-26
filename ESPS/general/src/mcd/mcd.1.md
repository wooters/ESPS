# NAME

mcd - Sun filter for plot data in Unix GPS format and interactive
plot/play program when used with plotsd

# SYNOPSIS

**mcd** \[ **-r** *region* \] \[ **-u** \] \[ **-x** *level* \] \[
**-R** \] \[ **-i** *icon file* \] \[ **-P** \] \[ **-p** *play options*
\] \[ *file.gps* \]

# DESCRIPTION

*Mcd* reads plot data in Unix Graphic Primitive String (GPS) format and
displays the plot in a Sun window. The program emulates a subset of the
functions of the Masscomp program of the same name. *Mcd* is intended to
be invoked in a *shelltool*(1), or *cmdtool*(1) window and creates a new
window for the plot. The initial size of the window is 24 by 80
characters (using the standard Sun font), but it may be adjusted by the
user to any size (width or height) by using the *resize* function on the
from the *suntools* menu obtained by pressing the right mouse button
while pointing to the title bar of the plot window. All of the other
standard *suntools* menu items are available through that menu,
including moving, closing (reducing the window to an icon), and quiting.

*Mcd* includes the function of the ESPS Masscomp *range* program. This
feature supports the selection of a range from the plot, zooming in,
zooming out, and calling the ESPS play program on sections of the plot.
See the **-R** and the **-P** options below. Normally these features are
only used by the ESPS script that implements *plotsd(1-ESPS)*.

*Mcd* uses the SunView window system calls, and remains active after
drawing the plot. This is so that the plot can be resized, refreshed, or
moved. To exit use the *quit* function on the main frame menu (click the
right mouse button on the frame title bar at the top of the window). If
you want to regain control of the shell window without removing the plot
window, then be sure to run *mcd* as a subprocess by putting a **&**
after the command.

Output from the programs *mlplot*(1-ESPS) and *genplot*(1-ESPS) can be
displayed with *mcd;* files written by the Masscomp *plot*(1G) program
and the graphics editor *ged*(1G) are also acceptable input. The ESPS
programs *plotsd*(1-ESPS), *plotspec*(1-ESPS), *mlplot*(1-ESPS), and
*genplot*(1-ESPS) use *mcd* internally to implement their **-Tmcd**
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
Cause *mcd* to go into *select/range* mode, after drawing the plot. This
mode is used with some plot programs (*plotsd*(1-ESPS)) and is called
directly by the ESPS plot program. When used this way, *mcd* allows the
user to select a range from a sampled data plot that is currently
displayed and to enter that range into the ESPS Common file. It can also
be used with *plotsd* and *play* as an interactive plot/play program.
After *plotsd* is used to display a sampled data plot in a window, *mcd*
displays instructions at the top of the display. The program is now in
what we will call *select mode*. At this point, the left mouse button
will select the starting point of the range, the middle button will call
the *play* program on the entire displayed plot (if the **-P** option is
used), and the right buttton will zoom out the plot (replot the entire
sampled data file). After the starting point of the range is selected
(with the left button) the current range will be displayed at the top of
the screen as the mouse is moved across the graph. The program is now in
*range mode*. In this mode pressing the left button will zoom in on the
selected range (replot the sampled data file using the selected range).
The middle button will save the selected range into the Common file. The
right button will abort the current range and allow you to reselect the
starting point again (that is it returns to *select mode*).

**-P**  
If the **-P** option is used, then *mcd* will call the *play* program,
instead of just saving the selected range when the middle button is
pressed in *range mode*. This causes the selected range to by played
(assuming of course, that your system has playback capability and the
ESPS *play* program has been correctly configured). When *play* returns,
if the mouse has not been moved, pressing the middle button again will
save the range into Common. If the mouse has moved, then the program
simply remains in *range mode*.

The ESPS Common file is updated whenever the plot is redrawn (zoom in or
out), or when a segment is played. This could be useful when running
*plotsd/mcd* in one window and another ESPS program that uses Common in
another window. The top line of the display always tells what the mouse
buttons will do in each mode. To exit at anytime, use the *quit*
function on the SunView frame menu.

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

    usage: mcd [-r region][-u][-R][-P][-p][-x level] [file.gps]
    mcd: unexpected end of file.
    mcd: can't open filename: reason

# BUGS

Only a minimal set of the GPS primitives is implemented.

# AUTHOR

Rodney Johnson and Alan Parker.
