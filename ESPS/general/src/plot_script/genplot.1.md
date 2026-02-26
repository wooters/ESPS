# NAME

genplot - plot data from ESPS files in multiline format

# SYNOPSIS

**genplot** \[ **-e** *range* \] . . . \[ **-f** *function* \] \[ **-i**
*item range* \] . . . \[ **-l** *int* \] \[ **-m**{**cpv**} \]\
\[ **-n** \] \[ **-o** *outdir* \] \[ **-r** *range* \] \[ **-s** *int*
\] \[ **-t** *text* \] \[ **-x** *debug level* \]\
\[ **-y** *range* \] \[ **-z** \] \[ **-E** \] \[ **-T** *device* \] \[
**-V** *text* \] \[ **-X** *scale* \] \[ **-W** *generic window system
options* \] *file*

# DESCRIPTION

*Genplot* treats files as "generic" ESPS files containing records with
some fixed number of numerical elements per record. In some ESPS files,
each record has a numerical tag giving a location in some source file
(this source file is usually a sampled-data file, so that the tag
corresponds to a time coordinate).

*Genplot* reads an input file *file* and produces *xy-*plots of
arbitrary record elements *vs.* record number (the default), record tag.
or position within the record. If the file name is \`\`-'', the standard
input is read. By default, the output is in Unix GPS (\`\`Graphics
Primitive String'') format and is displayed on the MASSCOMP or Sun
display, but with the **-T** option, this may be sent to the standard
output, obtained in Tektronix format rather than GPS, or plotted on a
hardcopy device.

The abscissas are scaled so that the spacing between plotted points is
an exact integer number of device resolution units in the horizontal
direction. Each selected record element is plotted on separate axes; the
axes for the second selected element are lined up below those of the
first, etc. If the required number of points for each specified record
element will not fit in the available width of the page, the plots are
continued on additional \`\`lines'': sets of axes lined up below the
first set. If more continuation lines are needed than will fit on one
page, the plot is continued on additional pages.

If the graph is to be displayed on a MASSCOMP or Sun display, then a
page corresponds to a *region* in MASSCOMP GPS universe coordinates, and
up to 25 regions can be displayed simultaneously on the screen. If the
**-o** option is specified, then a directory is created with the name
given by *outdir,* and a file is created for each page (region)
generated. Note, the **-o** option only applies if the device name
specified is\`\`gps'' or \`\`mcd'' (the default), and the output is
*also* sent to standard output or displayed on the screen unless the
**-n** option is chosen. The program *mcd* is supplied by MASSCOMP on
their systems, and by ESI on others.

On MASSCOMP workstations the color and line style of output to \`\`gps''
or \`\`mcd'' depend on the environment variable BUNDLE. The default is
GPS bundle number 20, which gives solid lines on monochrome displays.

On a Sun workstation (not running X windows), this program must be run
from within the *Suntools* window system. The plot will appear in a new
window, which can be moved, resized, closed (reduced to an icon), and
removed by using the functions on the *Suntools* menu. To get this menu,
move the mouse cursor to the title bar of the plot window and press the
right mouse button.

# ESPS PARAMETERS

This program does not access the parameter file.

# ESPS COMMON

This program does not access the ESPS common file.

# ESPS HEADERS

The following items of the input sampled-data file header are accessed:
common.type, common.ndrec, common.ndouble, common.nfloat, common.nlong,
common.nshort, common.nchar, and common.tag.

# OPTIONS

The following options are supported. Values in brackets are defaults.

**-e** *grange* **\[1\]**  

**-e "***field-name*** \[ ***grange*** \] "**

**-e** *field-name*  
This option specifies a set of elements within each record; each element
separately is plotted against the record number or, if **-E** is
specified, against the tag.

The argument may be a general range specification acceptable to
*grange_switch*(3-ESPSu). This specifies a set of integers that indicate
the positions of the elements within a record. The tag, if present is
counted as element zero. The other elements are counted starting with
one, whether tags are present or not. To find the element number of an
element in an ESPS file, use *fea_element*(1-ESPS). The following are
allowable forms for *grange.*

*element*  
A single integer specifies a single record element.

*first***:***last*  
A pair of elements specifies an inclusive range of elements.

*first***:+***incr*  
The form with the plus sign is equivalent to *first***:***last* with
*last* = *first* + *incr.*

*range***,** *. . .* **,** *range*  
A comma-separated list of range specifications of the first three forms
allows for noncontiguous sets of elements. The ranges should be given in
increasing order and without overlaps.

If the specified range contains points not in the file, the range is
reduced as necessary.

If the input file is an ESPS feature (FEA) file, a field within a record
may be specified by name. In that case, the bracketed *grange* refers to
positions within the field, counting the first as position zero. A field
name without a bracketed *grange* refers to the entire field. In that
case the double quotes can be omitted as well, as their only purpose is
to prevent the shell from giving the usual special interpretation to the
brackets.

The command line may contain several **-e** options with field names.
The **-e** option without a field name may be used at most once and may
not be used in the same command with the form containing a field name.

**-f** *function* **\[(none)\]**  
Apply the function *function* to the y-axis in order to compress its
amplitude range. Only two functions are recognized in this version:
"sqrt" (for the square root) and "log" (for the natural logarithm).

**-i** *grange* **\[1\]**  

**-i "***field-name*** \[ ***grange*** \] "**

**-i** *field-name*  
This option, like the **-e** option, specifies a set of elements within
each record; however, the elements within a record are plotted together
in the order specified, and this is done separately for each record. The
arguments have the same form as those for the **-e** option, and the
same restrictions apply: the form without a field name may be used with
any file type, may be used only once, and may not be used together with
the form containing a field name; the latter may be used only with FEA
files and may be repeated. The **-e** and **-i** options may not be used
together.

**-l** *int*  
Number of element values per labeled tic mark on the *x-*axis. If
elements are plotted *vs.* record number, the default for *int* is 10.
If elements are plotted vs tag value, the default for *int* is 100.

**-m**{**pvc**} \[c\]  
\`\`Mode.'' Selects one of 3 styles.

**c**  
Connected. Successive data points are connected by straight lines.

**p**  
Point. Individual data points are plotted without connecting lines.

**v**  
Vertical line. Each point is connected to the *x-*axis (*y*=0) by a
vertical line.

**-n**  
Suppress output to screen or stdout when writing into a directory with
the **-o** option.

**-o** *outdir* **\[(none)\]**  
Create a directory named *outdir* and write output pages (regions) into
files named *page1, page2, page3,* etc. This option is only valid if the
output device is gps or mcd.

**-r** *first***:***last* **\[(first in file):(last in file)\]**  
**-r** *first***:+***incr*  
In the first form, a pair of unsigned integers specifies the range of
records from which element values are to be plotted. Either *first* or
*last* may be omitted; then the default value is used. If *last* =
*first* + *incr,* the second form (with the plus sign) specifies the
same range as the first. If the specified range contains points not in
the file, the range is reduced as necessary.

**-s** *int* **\[1\]**  
Samples are numbered starting with the given integer, rather than 1, for
the first sample in the file.

**-t** *text* **\[(none)\]**  
Title to be printed at the bottom of each page.

**-x** *debug level* **\[0\]**  
Print diagnostic messages as program runs (for debugging purposes only).

**-y** *upper***:***lower*  
**-y** *limit*  
Ordinate range. Specifies values for the upper and lower *y-*axis
limits. The second form is equivalent to **-y** *-limit***:***limit.* If
the option is omitted, or if both limits are omitted, (**-y:**) then a
range is computed from the data by finding the maximum and minimum value
for each element (or, if the **-i** option is in effect, for each
record). If one limit is omitted, a default limit is computed from the
data.

**-z**  
Do not draw the *x-*axis (*y*=0).

**-E**  
Specifies that elements are to be plotted *vs.* tags (rather than record
numbers).

**-T** *device* **\[mcd\]**  
*Device* may be **gps**, **mcd**, **tek**, **suntools**, **hp**, or
**hardcopy**. The default is **-Tmcd,** which displays the output on the
graphics screen by piping it through *xmcd (1-ESPS)*. Specifying
**-Tgps** sends output to the standard output in MASSCOMP Unix GPS
format. Specifying **-Ttek** causes output to be sent to the standard
output in Tektronix 4000-series format, and If **-Tsuntools** is used,
then the display will be forced to use *suntools* window system (on Suns
and Solbournes only), even if ESPS has been configured to use the X
window system. If ESPS is built for X, then it uses X for plotting by
default. If **-Tmcd** is used on a Masscomp and ESPS has been configured
to use X windows, then the old SP-40 *mcd* is used instead of X windows.
Specifying **-Thardcopy** plots it on a hardcopy device, if one was set
up in the installation script. Note that the word *imagen* was used for
this option in previous versions. It is still accepted, but *hardcopy*
is meant to be more general. **-Thp** produces output for an HP LaserJet
printer. Note that the output is produced on standard out and it is not
spooled to the printer by this command. Use of this option will result
in about 750K bytes of output per page. If the link to your LaserJet is
slow, it might take several minutes to send it to the printer. In a
later version, this will be merged with the *hardcopy* option above for
direct spooling.

**-V** *text* **\[(none)\]**  
Title to be printed along the left edge of each page (running upward).

**-X** *scale* **\[4\]**  
Number of resolution units along the *x-*axis between plotted samples.
Must be an integer.

**-W**  
This option is followed by a character string consisting of the generic
window system options. These options are passed onto *mcd* or *xmcd*.
This option is used to pass along generic X window arguments to *xmcd*
or Suntool arguments to *mcd* on Suns. This option might not have an
effect on all systems. For example, on a system running X windows, to
cause the plot to appear at a particular screen location the following
command could be used:\
*genplot -W "=300x250+50+200" file*.\
See *xmcd(1-ESPS)* for details.

For Sun systems, this program will plot under either X windows, or
Suntools. By default, if the **-T** option is not used, it will expect X
windows. To plot under Suntools you can use the **-Tsuntools** option.
If you always use Suntools, you can avoid using the **-T** option by
defining the environment variable **EPLOTDEV** to be *suntools*. This
will make the Suntools window system the default. This variable is
ignored if the machine type is not Sun4, SUN3, or SUN386i.

# EXAMPLE

    % genplot -T hardcopy -e 1:2 file.ana
    # Send output to be printed on a laser printer.

    % genplot -e3:5 -o TEST -n  file.ana
    # create a directory called TEST to which to send the output, and
    # suppress output to stdout (-n option).  The files generated will
    # correspond to pages generated by the first example above.  To view
    # the second page on a MASSCOMP Graphics Terminal, type the following:

    mcd TEST/page2
    # or
    ged TEST/page2

    # The latter command allows you to zoom into various parts of the
    graph; see the DATA PRESENTATION APPLICATION PROGRAMMING MANUAL for
    more information concerning ged.

# FILES

None.

# SEE ALSO

    mlplot(1-ESPS), plotsd(1-ESPS), igenplot(1-ESPS),
    scatplot(1-ESPS), xmcd(1-ESPS)

# DIAGNOSTICS

    genplot: unknown option -letter
    Usage: genplot [-e range]...[-f function][-i item range]...[-l int]
    	[-m{cpv}][-n][-o outdir][-r range][-s int][-t text]
    	[-x debug level][-y range][-z][-E][-T device][-V text]
    	[-X scale] file
    genplot: unknown function type function
    genplot: conflicting options, -i and -e cannot be used together.
    genplot: element range should not be less than zero.
    genplot: can't open filename: reason
    genplot: filename is not an ESPS file
    genplot: empty amplitude range specified.
    genplot: invalid element range
    genplot: tags specified but not available
    genplot: only nelements elements in a record, truncating specified range.
    genplot: sorry, plotting tags has not been implemented, yet.
    genplot: empty amplitude range specified.
    genplot: calloc: could not allocate memory for variable.
    genplot: only nrecords records read.
    genplot: fatal error: argument out of range for sqrt.  element no.
    genplot: fatal error: argument out of range for log.  element no.
    genplot: fatal error: TRYING TO DIVIDE BY ZERO
    	 problem with element number element no.
    	 you are trying to plot a CONSTANT element without -y option
    	 either explicitly give an amplitude range or don't plot this range.
    genplot: Warning, only 25 regions can be displayed on Masscomp Terminal.
    	 stopping output to stdout.

# FUTURE CHANGES

Options to allow more control over format. More intelligent choice of
axis subdivisions. Option to suppress Imagen document-control header and
allow output to actual Tektronix-4014 terminal. Selection of default
*y*-axis limits according to header information. Multiple input files.
Simultaneous plotting of "markers", just as *mlplot* (1-ESPS) plots
tags.

# BUGS

This version of the program does not handle complex feature fields with
the **-e** or **-i** option with a field name. You must use fea_element
to get element numbers for the desired fields and then use those numbers
with the **-e** or **-i** options. This will be improved.

Default for the **-l** option should depend on the *x-*scale (**-X**
option).

# AUTHOR

Ajaipal S. Virdy, man page by John Shore.
