# NAME

aplot - Plot an array of data in ASCII format.

# SYNOPSIS

**aplot** \[ **-d** \] \[ **-l** \] \[ **-z** \] \[ **-T** *device* \]
\[ **-W** *generic window system options* \] \[ *data_file* \]

# DESCRIPTION

*aplot* plots an array of ordered pairs \<x, y\>, stored in ASCII
format. If *data_file* is \`\`-'' or omitted, the standard input is
read. By default, the output is in Unix GPS (\`\`Graphics Primitive
String'') format and is displayed on the workstation graphics display
but with the **-T** option, this may be sent to the standard output,
obtained in Tektronix format rather than GPS, or plotted on a hardcopy
device.

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

On a Sun workstation (not running X windows), this program must be run
from within the *Suntools* window system. The plot will appear in a new
window, which can be moved, resized, closed (reduced to an icon), and
removed by using the functions on the *Suntools* menu. To get this menu,
move the mouse cursor to the title bar of the plot window and press the
right mouse button.

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

**-T** *device*  
*Device* may be **gps**, **mcd**, **tek**, **suntools**, **hp**, or
**hardcopy**. The default is **-Tmcd,** which displays the output on the
graphics screen by piping it through *mcd* or
*xmcd*(for*X*window*system).* The program *mcd* is supplied by Masscomp
for their systems and by ESI for other systems and those running X
windows. Specifying **-Tgps** sends output to the standard output in
Masscomp Unix GPS format. Specifying **-Ttek** causes output to be sent
to the standard output in Tektronix 4000-series format. If
**-Tsuntools** is used, then the display will be forced to use
*suntools* window system (on Suns and Solbournes only), even if ESPS has
been configured to use the X window system. If ESPS is built for X, then
it uses X for plotting by default. If **-Tmcd** is used on a Masscomp
and ESPS has been configured to use X windows, then the old SP-40 *mcd*
is used instead of X windows. Specifying **-Thardcopy** plots it on a
hardcopy device, if one was set up in the installation script. Note that
the word *imagen* was used for this option in previous versions. It is
still accepted, but *hardcopy* is meant to be more general. **-Thp**
produces output for an HP LaserJet printer. Note that the output is
produced on standard out and it is not spooled to the printer by this
command. Use of this option will result in about 750K bytes of output
per page. If the link to your LaserJet is slow, it might take several
minutes to send it to the printer. In a later version, this will be
merged with the *hardcopy* option above for direct spooling.

**-W**  
This option is followed by a character string consisting of the generic
window system options. These options are passed onto *mcd* or *xmcd*.
This option is used to pass along generic X window arguments to *xmcd*
or Suntool arguments to *mcd* on Suns. This option might not have an
effect on all systems. For example, on a system running X windows, to
cause the plot to appear at a particular screen location the following
command could be used:\
*aplot -W "=300x250+50+200" file*.\
See *mcd(1-ESPS)* and *xmcd(1-ESPS)* for details.

For Sun systems, this program will plot under either X windows, or
Suntools. By default, if the **-T** option is not used, it will expect X
windows. To plot under Suntools you can use the **-Tsuntools** option.
If you always use Suntools, you can avoid using the **-T** option by
defining the environment variable **EPLOTDEV** to be *suntools*. This
will make the Suntools window system the default. This variable is
ignored if the machine type is not Sun4, SUN3, or SUN386i.

# ESPS PARAMETERS

No ESPS parameter file is read.

# ESPS COMMON

The ESPS common file is not read or written.

# ESPS HEADERS

No ESPS headers are processed, since the input and output are not ESPS
files.

# DIAGNOSTICS

    aplot: unknown option -letter
    Usage: aplot [-d] [-l] [-z] [-T] [input_file]
    aplot: Cannot specify both -d and -l flags
    aplot: can't open filename: reason
    aplot: EOF encountered

# SEE ALSO

plotsd(1-ESPS), plotspec(1-ESPS), scatplot(1-ESPS), mcd(1G)(Masscomp),
mcd(1-ESPS), xmcd(1-ESPS)

# AUTHOR

    Shankar Narayan, Entropic Speech, Inc.
    Modified for -T option by Rodney Johnson.
    -z option added by David Burton.
