# NAME

plotsd - plot real sampled data from single-channel FEA_SD files

# SYNOPSIS

**plotsd** \[ **-{prs}** *range* \] \[ **-t** *text* \] . . . \[ **-x**
*level* \] \[ **-y** *range* \] \[ **-E** *expansion* \]\
\[ **-M** *maxpnts* \] \[ **-T** *device* \] \[ **-Y** *range* \] \[
**-W** *generic window system options* \] *file*

# DESCRIPTION

*Plotsd* plots a portion of an ESPS sampled data file *file.* The file
must be a single-channel file. If the file is complex, only the real
part is plotted. For multi-channel or complex files, consider using
*demux* (1-ESPS) together with *plotsd*, or *genplot* (1-ESPS) to plot
directly.

If *file* is "-", the standard input is read. By default, the output is
in Unix GPS (\`\`Graphics Primitive String'') format and is displayed on
the Masscomp or Sun display (using *mcd*), but with the **-T** option,
this may be sent to the standard output, obtained in Tektronix format
rather than GPS, or plotted on a hardcopy device.

If the **-p** option is omitted, then the *range* is computed from the
parameter and common files; otherwise the entire contents of *file* is
used as the default range.

*Plotsd* finds the maximum and minimum values in the specified range and
computes appropriate scales for the *x*- and *y*-axes. These automatic
values can be overriden by the **-y** or **-Y** options.

When displayed on the screen (see EXAMPLES, below), the plots will take
a long time if every point is plotted. For this reason, *plotsd* plots a
maximum of approximately 3000 points across the range specified by the
user (intermediate points are skipped). This behavior can be changed by
means of the **-M** option.

*Plotsd* will run faster if the **-Y** option is used, especially in the
case of large files.

On Masscomp workstations the color and line style of output to \`\`gps''
or \`\`mcd'' depend on the environment variable BUNDLE. The default is
GPS bundle number 20, which gives solid lines on monochrome displays.

# OPTIONS

The following options are supported:

**-p** *first:last*  
**-p***"***first:+incr**  
**-r** *first:last*  
**-r***"***first:+incr**  
Determines the range of points to be plotted. In the first form
(first:last), a pair of unsigned integers gives the first and last
points of the range. If *first* is omitted, 1 is used. If *last* is
omitted, the last point in the file is used. The second form
(first:+incr) is equivalent to the first with *last = first + incr .*
The **-r** is a synonym for **-p**.

**-s** *range*  
Select a range of points to be plotted in seconds. For compatibility
with DSC LISTEN, the beginning of the file is 0.

**-t** *text*  
A line of text to be printed below the plot. Up to ten **-t** options
may be specified; they are printed as text lines in order below the
plot.

**-x** *level*  
If *level* is nonzero, debugging information is written to the standard
error output. Default is 0 (no debugging output).

**-y** *low:high*  
Specifies approximate lower and upper limits for the *y*-axis. The
values are adjusted by *plotsd* in an attempt to make an esthetically
pleasing plot.

**-E** *expansion*  
The range selected by the **-p** option or by the parameter and common
files is shown in a context consisting of additional points at each end.
The selected range is expanded by a fraction given by the argument
*expansion* plus an additional amount chosen to make the endpoints round
numbers. The expanded range is plotted, and the ends of the actually
chosen range are flagged with vertical lines labeled with the
*x-*coordinate values.

**-M** *maxpnts \[3000\]*  
Specifies that *plotsd* plot up to an approximate maximum of *maxpnts*
points. If the total number of points in the *range* exceeds *maxpnts,*
points are skipped evenly throughout. As a special case, *maxpnts* = 0
specifies that no points are to be skipped.

**-T** *device*  
*Device* may be **gps**, **mcd**, **tek**, **suntools**, or
**hardcopy**. The default is **-Tmcd,** which displays the output on the
Sun or Masscomp screen by piping it through *mcd* (on Masscomp systems
*mcd* is supplied by Masscomp, on Suns, it is supplied by ESI).
Specifying **-Tgps** sends output to the standard output in Masscomp
Unix GPS format. Specifying **-Ttek** causes output to be sent to the
standard output in Tektronix 4000-series format. If **-Tsuntools** is
used, then the display will be forced to use *suntools* window system
(on Suns and Solbournes only), even if ESPS has been configured to use
the X window system. If ESPS is built for X, then it uses X for plotting
by default. If **-Tmcd** is used on a Masscomp and ESPS has been
configured to use X windows, then the old SP-40 *mcd* is used instead of
X windows. Specifying **-Thardcopy** plots it on a hardcopy device, if
one was set up in the installation script. Note that the word *imagen*
was used for this option in previous versions. It is still accepted, but
*hardcopy* is meant to be more general.

**-Y** *low:high*  
Specifies exact lower and upper limits for the *y*-axis.

**-W**  
This option is followed by a character string consisting of the generic
window system options. These options are passed onto *mcd* or *xmcd*.
This option is used to pass along generic X window arguments to *xmcd*
or Suntool arguments to *mcd* on Suns. This option might not have an
effect on all systems. For example, on a system running X windows, to
cause the plot to appear at a particular screen location the following
command could be used:\
*plotsd -W "=300x250+50+200" file*.\
See *mcd(1-ESPS)* and *xmcd(1-ESPS)* for details.

If the file to be plotted contains data of a single value, then the
horizontal grid is suppressed. Otherwise the horizontal plot tends to
get lost on top of a grid line.

# EXAMPLE

> **plotsd** *\<options\> \<filename\>*

is equivalent to

> **plotsd -Tgps** *\<options\> \<filename\>* **\| mcd**

The second form may be used if nondefault options for *mcd* are desired.

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

The following items are read from the ESPS Common file. The values for
start and nan are not used if a range is specified on the command line
or if the input file is not the same file identified in the Common file
by the "filename" symbol.

> *start - integer*

> This is the starting point in the sampled data file to begin plotting.
> If it is zero, the beginning of the file is used.
>
> *nan - integer*

> This is the number of points (starting at *start*) to plot. If it is
> zero, the entire file is used as the default.
>
> *filename - string*

> This is the name of the file to be displayed if *file* is omitted from
> the command line.

The following items are written into the ESPS Common file:

> *start - integer*

> The left point in the range selected.
>
> *nan - integer*

> The number of points in the selected range.
>
> *beginplot - integer*

> The origin of the graph (*x*-coordinate).
>
> *endplot - integer*

> The end point of the graph (*x*-coordinate).
>
> *prog - string*

> This is the name of the program (*plotsd* in this case).
>
> *filename - string*

> This is the name of the file to be displayed. The program terminates
> if *filename* does not exist when *file* is not specified on the
> command line.

ESPS Common processing may be disabled by setting the environment
variable USE_ESPS_COMMON to "off". The default ESPS Common file is
.espscom in the user's home directory. This may be overidden by setting
the environment variable ESPSCOM to the desired path. User feedback of
Common processing is determined by the environment variable
ESPS_VERBOSE, with 0 causing no feedback and increasing levels causing
increasingly detailed feedback. If ESPS_VERBOSE is not defined, a
default value of 3 is assumed.

# ESPS HEADERS

*Plotsd* reads the following field from the SD file header:
*common.type.*

# DIAGNOSTICS

*Plotsd* complains if there is no such file, if the file is not a
sampled data file, or if the file is a mutli-channel file.

# WARNING

Discarding points when more than *maxpoints* points are to be plotted
can produce misleading results. In particular, aliasing is possible if
the data has periodic components with periods comparable to or less than
the spacing between the selected points.

# EXPECTED CHANGES

Many more options may be added.

# SEE ALSO

*demux* (1-ESPS), *mlplot* (1-ESPS), *genplot* (1-ESPS),\
*scatplot* (1-ESPS), *plotspec* (1-ESPS), *aplot* (1-ESPS),\
FEA_SD (5-ESPS)

# AUTHOR

    Joseph T. Buck, Entropic Speech, Inc.
    Adapted from a program by Shankar Narayan.
    Converted by Rod Johnson to read new ESPS format.
    Modified for ESPS Common by Ajaipal S. Virdy.
    Modified for -y, -Y, and -M by John Shore.
    Manual page revised by John Shore.
    -T and -E options added by Rod Johnson.
    SunView changes by Alan Parker
