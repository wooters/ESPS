# NAME

range - select a range from a sampled data plot/interactive plot and
play

# SYNOPSIS

**range** \[ **-p** \] \[ **-b** *shift-value* \] \[ **-c** *d/a channel
number* \]

# DESCRIPTION

*range* is used to select a range from a sampled data plot that is
currently displayed on a MASSCOMP graphics terminal and to enter that
range into the ESPS Common file. It can also be used with *plotsd* and
*play* as an interactive plot/play program.

After *plotsd* is used to display a sampled data plot on the graphics
terminal screen, *range* is run. It displays instructions at the top of
the display. To use *range* simply to put a range into the ESPS Common
file, *range* is used without any options. First, click the left mouse
button while pointing to any vertical position above the origin of the
graph (extreme left side). Next, do the same thing at the end point
(extreme right side). This completes the set-up portion of the process.
The program is now in what we will call *select mode*. At this point,
the left mouse button will select the starting point of the range, the
middle button will call the *play* program on the entire displayed plot,
and the right buttton will zoom out the plot (replot the entire sampled
data file). After the starting point of the range is selected (with the
left button) the current range will be displayed at the top of the
screen as the mouse is moved across the graph. The program is now in
*range mode*. In this mode pressing the left button will zoom in on the
selected range (replot the sampled data file using the selected range).
The middle button will save the selected range into the Common file and
exit. The right button will abort the current range and allow you to
reselect the starting point again (that is it returns to *select mode*).

If the **-p** option is used, then *range* will call the *play* program,
instead of saving the selected range and exiting when the middle button
is pressed in *range mode*. This causes the selected range to by played
(assuming of course, that your system has playback capability and the
ESPS *play* program has been correctly configured). When *play* returns,
if the mouse has not been moved, pressing the middle button again will
save the range into Common and exit. If the mouse has moved, then the
program simply remains in *range mode*.

The **-b** and **-c** options are passed on to *play* when it is run.
See *play*(1-ESPS) for details.

The ESPS Common file is updated each whenever the plot is redrawn (zoom
in or out), or when a segment is played. This could be useful when
running *plotsd/range* in one window and another ESPS program that uses
Common in another window. The top line of the display always tells what
the mouse buttons will do in each mode. You can use your Unix interrupt
character to abort out of range at anytime.

Note that since this program depends on ESPS Common and processes it
often during its execution, the messages from Common processing if the
ESPS_VERBOSE environment variable is non-zero will interfere with the
plotting.

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
when using this program). The default ESPS Common file is .espscom in
the user's home directory. This may be overidden by setting the
environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

No ESPS header is read.

# DIAGNOSTICS

# BUGS

# SEE ALSO

mlplot(1-ESPS), plotsd(1-ESPS), plotspec(1-ESPS), play(1-ESPS)

# FUTURE CHANGES

Mark selected range with vertical bars.

# AUTHOR

Ajaipal S. Virdy, Alan Parker
