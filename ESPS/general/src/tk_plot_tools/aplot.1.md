# NAME

aplot - Plot an array of data in ASCII format.

# SYNOPSIS

**aplot** \[ **-d** \] \[ **-l** \] \[ **-z** \] \[ **-W** *generic
window system options* \] \[ **-T** *plot title* \] \[ *data_file* \]

# DESCRIPTION

*aplot* plots an array of ordered pairs \<x, y\>, stored in ASCII
format. If *data_file* is \`\`-'' or omitted, the standard input is
read.

The plot is displayed in an X window. The display has three pull down
menus: **File**, **Views**, and **Help**. The **File** menu has two
items: **Print** and **Quit**. **Print** selects a dialog box that has
controls to produce a PostScript output of the plot. The **Quit** item
causes the program to exit.

The **Views** menu has selectors that enable or disable display of the
box around the plot, the horizontal grid, the vertical grid, any text
(usually the file name and date), and the tick marks on the reticle.
This menu also has buttons to enable all of the above items, to redraw
the original plot, and to refresh the plot as it is currently shown.

The **Help** menu has two items: **on Plot Tool** and **About** Plot
Tool. These display a help file and version information.

# DATA FORMAT

The *data_file* is expected to contain the following parameters, each
separated by a blank.

\<*No_of_Samples*\>

\<*No_of_plots*\>

\<*x_axis_min*\> \<*x_axis_max*\> \<*x_axis_step*\>

\<*y_axis_min*\> \<*y_axis_max*\> \<*y_axis_step*\>

followed by plot data (x and y values separated by blank).

Any *Text* following the data (after a blank line) is reproduced as
plotter output.

In the case of multiple plots, the line thickness is varied to
distinguish between different plots.

# OPTIONS

Normally, a coninuous plot is generated. However, the following options
can be used, in the case of single plots:

**-d**  
If this option is specified, there will be a dot for each \<x, y\> pair.
However, there will be no continuous plot.

**-l**  
If this option is specified, there will be a vertical line from \<x,
y_axis_min\> to \<x, y\> for each \<x, y\> pair; the points themselves
will not be connected to each other.

**-z**  
If this option is specified, the vertical and horizontal grid lines are
suppressed - only tick marks are made on the graph.

**-W**  
This option is followed by a character string consisting of the generic
window system options. For example, on a system running X windows, to
cause the plot to appear at a particular screen location the following
command could be used:

\
*aplot -W "=300x250+50+200" file*.

**-T** *title_string*  
This option allows the user to specify the title of the plot. The title
is the string that goes in the window manager supplied title bar.

# ESPS PARAMETERS

No ESPS parameter file is read.

# ESPS COMMON

The ESPS common file is not read or written.

# ESPS HEADERS

No ESPS headers are processed, since the input and output are not ESPS
files.

# DIAGNOSTICS

    aplot: unknown option -letter
    Usage: aplot [-d] [-l] [-z] [-T title_string] [input_file]
    aplot: Cannot specify both -d and -l flags
    aplot: can't open filename: reason
    aplot: EOF encountered

# SEE ALSO

    plotsd(1-ESPS), plotspec(1-ESPS), scatplot(1-ESPS)

# AUTHOR

    Original: Shankar Narayan, Entropic Speech, Inc.
    Improvements: Rodney Johnson, Alan Parker, David Burton.
