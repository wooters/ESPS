# NAME

scatplot - make a scatter plot

# SYNOPSIS

**scatplot** \[ **-e** *range* \] \[ **-r** *range* \] \[ **-s**
*symbols* \] \[ **-t** *text* \] \[ **-x** *debug_level* \]\
\[ **-H** *text* \] \[ **-T***"***device** \] \[ **-V** *text* \] \[
**-X** *range* \] \[ **-Y** *range* \] \[ **-W** *generic window system
options* \] *file1* \[ *file2* \] . . .

# DESCRIPTION

*Scatplot* makes a scatter plot of pairs of elements from multiple ESPS
files *file1, file2, . . . .* When used as a file name, \`\`-'' denotes
standard input.

By default, the output is in Unix GPS (\`\`Graphics Primitive String'')
format and is displayed on the Masscomp or Sun display, but with the
**-T** option, this may be sent to the standard output, obtained in
Tektronix format rather than GPS, or plotted on a hardcopy device.

On a Sun workstation, this program must be run from within the
*Suntools* window system. The plot will appear in a new window, which
can be moved, resized, closed (reduced to an icon), and removed by using
the functions on the *Suntools* menu. To get this menu, move the mouse
cursor to the title bar of the plot window and press the right mouse
button.

If the **-r** option is omitted, then the entire contents of all files
are plotted.

The **-e** option specifies which elements to plot. An even number of
elements must always be given since there are no default elements to
plot. The first pair of elements is associated with the first file, the
second pair with the second file, and so on up to the last file or until
no other pair of elements remains, in which case the last pair of
elements is associated with the remaining files. The first element in
the pair is plotted as the abscissa and the second element as the
ordinate. Default symbols are used to distinguish between multiple
files, but they can be overridden by the **-s** option.

*Scatplot* finds the maximum and minimum of the *x* values and the *y*
values in the specified ranges of the input files and computes
appropriate scales This automatic scaling can be overridden by the
**-X** and **-Y** options.

On Masscomp systems the color and line style of output to \`\`gps'' or
\`\`mcd'' depend on the environment variable BUNDLE. The default is GPS
bundle number 20, which gives solid lines on monochrome displays.

# OPTIONS

The following options are supported:

**-e** *elements*  
Determine which elements within a record to plot. The elements may be
separated by commas, or, more generally, any construct acceptable to
*grange_switch*(3-ESPSu) may be used, as long as the number of elements
specified is even. The first pair of elements is associated with the
first file, the second pair with the second file, and so on up to the
last file or until no other pair of elements remains, in which case the
last pair of elements is associated with the remaining files. The first
element in the pair is plotted as the abscissa and the second element as
the ordinate.

**-r** *first:last*  
**-r***"***first:+incr**  
Determines the range of records to be plotted. In the first form, a pair
of unsigned integers gives the first and last records of the range. If
*first* is omitted, 1 is used. If *last* is omitted, the last record in
the file is used. The second form is equivalent to the first with *last
= first + incr .*

This option may be repeated. The first **-r** option applies to the
first input file, the second **-r** option to the second input file, and
so on. If there are more files than **-r** options, then the last option
applies to all remaining files.

**-s** *symbols \[xo\*abcdefghijklmnpqrstuvwyz\]*  
Plot the scatter plot using the symbols specified. The first symbol is
used for the first file, the second symbol for the second file, and so
on up to the last file. There must be at least as many symbols as files.
The default symbols are given in brackets.

The positions of the symbols *\`x'* and *\`o'* have been modified so
that the plotting point falls very close to the "center" of the
character. Other characters will not have their centers exactly at the
plotting points.

**-t** *text*  
Print a line of text above the graph.

**-x** *level*  
If *level* is nonzero, debugging information is written to the standard
error output. Default is 0 (no debugging output).

**-H** *text*  
Print a line of text below the graph.

**-T** *device*  
*Device* may be **gps**, **mcd**, **tek**, **suntools**, **hp**, or
**hardcopy**. The default is **-Tmcd,** which displays the output on the
workstation graphics screen by piping it through *mcd*(1) or
*xmcd*(1-ESPS). The program *mcd* is supplied by Masscomp for their
systems, and by ESI for other workstations. Specifying **-Tgps** sends
output to the standard output in Masscomp Unix GPS format. Specifying
**-Ttek** causes output to be sent to the standard output in Tektronix
4000-series format. If **-Tsuntools** is used, then the display will be
forced to use *suntools* window system (on Suns and Solbournes only),
even if ESPS has been configured to use the X window system. If ESPS is
built for X, then it uses X for plotting by default. If **-Tmcd** is
used on a Masscomp and ESPS has been configured to use X windows, then
the old SP-40 *mcd* is used instead of X windows. Specifying
**-Thardcopy** plots it on a hardcopy device, if one was set up in the
installation script. Note that the word *imagen* was used for this
option in previous versions. It is still accepted, but *hardcopy* is
meant to be more general. **-Thp** produces output for an HP LaserJet
printer. Note that the output is produced on standard out and it is not
spooled to the printer by this command. Use of this option will result
in about 750K bytes of output per page. If the link to your LaserJet is
slow, it might take several minutes to send it to the printer. In a
later version, this will be merged with the *hardcopy* option above for
direct spooling.

**-V** *text*  
Print a line of text along the left side of the graph going upwards.

**-X** *low:high*  
Specifies lower and upper limits for the x-axis, disables automatic
computation of limits.

**-Y** *low:high*  
Specifies lower and upper limits for the y-axis, disables automatic
computation of limits.

**-W**  
This option is followed by a character string consisting of the generic
window system options. These options are passed onto *mcd* or *xmcd*.
This option is used to pass along generic X window arguments to *xmcd*
or Suntool arguments to *mcd* on Suns. This option might not have an
effect on all systems. For example, on a system running X windows, to
cause the plot to appear at a particular screen location the following
command could be used:\
*scatplot -W "=300x250+50+200" file*.\
See *mcd(1-ESPS)* and *xmcd(1-ESPS)* for details.

For Sun systems, this program will plot under either X windows, or
Suntools. By default, if the **-T** option is not used, it will expect X
windows. To plot under Suntools you can use the **-Tsuntools** option.
If you always use Suntools, you can avoid using the **-T** option by
defining the environment variable **EPLOTDEV** to be *suntools*. This
will make the Suntools window system the default. This variable is
ignored if the machine type is not Sun4, SUN3, or SUN386i.

# EXAMPLES

**scatplot -r***1:500* **-s***xo* **-e***5,6,15,19 file1 file2*  
makes a scatter plot (using the letter *x* for file1 and the letter *o*
for file2) of element 5 versus element 6 in *file1* and of element 15
versus element 19 in *file2* across the record range 1 to 500. The plot
is displayed on the graphics terminal.

**scatplot -Tgps** *\<options\> \<files\>*  
sends the plot to standard output in Masscomp Unix GPS (\`\`Graphic
Primitive String'') format.

**scatplot -Thardcopy** *\<options\> \<files\>*  
plots on the hardcopy plotter.

**scatplot -Ttek** *\<options\> \<files\>*  
sends the plot to standard output in Tektronix format and may be used to
plot on a Tektronix terminal.

# ESPS PARAMETERS

*Scatplot* does not read an ESPS parameter file.

# ESPS COMMON

*Scatplot* does not read or write the ESPS common file.

# ESPS HEADERS

*Scatplot* reads the following fields from the ESPS file headers:
*common.ndrec,* *common.tag.*

# DIAGNOSTICS

    scatplot: please give only one -e option.
    scatplot: -e option: even number of elements required.
    scatplot: please specify an element range with the -e option.
    scatplot: data is not tagged in file, cannot plot element 0.
    scatplot: please specify n_symbols symbols with the -s option.
    scatplot: start point after end point.
    scatplot: only n_points in file.
    scatplot: only n_records records read in file.
    scatplot: calloc: could not allocate memory for array.
    scatplot: d_mat_alloc: could not allocat memory matrix.
    scatplot: command line too long: truncating string.

# EXPECTED CHANGES

Allow range specifications of the form *\<field
name\>***\[***\<range\>***\]** with FEA files.

# SEE ALSO

mlplot(1-ESPS), genplot(1-ESPS), fea_element(1-ESPS),
grange_switch(3-ESPS).

# AUTHOR

    Ajaipal S. Virdy
    Generalized by Rodney Johnson to allow independent ranges in the input
    files.
