# NAME

mlplot - plot single-channel sampled data files in multiline format

# SYNOPSIS

**mlplot** \[ **-l** *int* \] \[ **-m**{**cpv**} \] \[ **-n** \] \[
**-o** *outdir* \] \[ **-{pr}** *range* \] \[ **-s** *int* \]\
\[ **-t** *text* \] \[ **-x** *debug level* \] \[ **-y** *range* \] \[
**-z** \] \[ **-L** *file.esps* \] \[ **-N** \]\
\[ **-T** *device* \] \[ **-V** *text* \] \[ **-X** *scale* \] \[ **-W**
*generic window system options* \] \[ *file1.sd file2.sd . . . filen.sd*
\]

# DESCRIPTION

*Mlplot* reads *n* ESPS sampled data files *file1.sd* to *filen.sd* and
produces an *xy-*plot of sample value *vs.* sample number.

The input files must be single-channel files. If any of them are
complex, only the real part is plotted. For multi-channel or complex
files, consider using *demux* (1-ESPS) together with *mlplot*, or
*genplot* (1-ESPS) to plot directly.

If *file1.sd* is \`\`-'', the standard input is read along with any
other file names specified. If no input file names are specified, but an
ESPS file containing tags is given with the **-L** option, then the
first source file named in its header is used as an input Sampled Data
file.

By default, the output is in Unix GPS (\`\`Graphics Primitive String'')
format and is displayed on the workstation graphics display, but with
the **-T** option, this may be sent to the standard output, obtained in
Tektronix format rather than GPS, or plotted on a hardcopy device.

The abscissas are scaled so that the spacing between plotted points is
an exact integer number of device resolution units in the horizontal
direction. If the required number of points will not fit in the
available width of the page, the plot is continued on a second
\`\`line'': a second set of axes lined up below the first. If more
continuation lines are needed than will fit on one page, the plot is
continued on additional pages.

If the graph is to be displayed on a MASSCOMP or Sun display, then a
page corresponds to a *region* in MASSCOMP GPS universe coordinates and
up to 25 regions can be displayed simultaneously on the screen. If the
**-o** option is specified, then a directory is created with the name
given by *outdir* and a file is created for each page (region)
generated. Note, the **-o** option only applies if the device name
specified is \`\`gps'' or \`\`mcd'' (the default) and the output is
*also* sent to standard output or displayed on the screen unless the
**-n** option is chosen. The program *mcd* is supplied by MASSCOMP on
their systems, and by ESI on Suns.

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
*common.type,* *common.ndrec,* *common.ndouble,* *common.nfloat,*
*common.nlong,* *common.nshort,* *common.nchar,* and *common.tag.* If
the **-L** option is specified, the following items of the file header
are accessed: *variable.source*\[0\] and *common.tag.*

# OPTIONS

The following options are suported. Values in brackets are defaults.

**-l** *int* **\[100\]**  
Number of samples per labeled tic mark on the *x-*axis.

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

**-{pr}** *first***:***last* **\[(first in file):(last in file)\]**  
**-{pr}** *first***:+***incr*  
In the first form, a pair of unsigned integers specifies the range of
samples to be plotted. Either *first* or *last* may be omitted; then the
default value is used. If *last* = *first* + *incr,* the second form
(with the plus sign) specifies the same range as the first. If the
specified range contains points not in the file, the range is reduced as
necessary. Note that the options **-p** and **-r** are synonymous.

**-s** *int* **\[1\]**  
Samples in the input file are numbered starting with the given integer,
rather than 1, for the first sample. This option may be specified *m*
times, where *m* is less than or equal to the number of files to be
plotted. Only the first *m* files will be affected by this option.

**-t** *text* **\[(none)\]**  
Title to be printed at the bottom of each page.

**-x** *debug level* **\[0\]**  
Print diagnostic messages as program runs (for debugging purposes only).

**-y** *upper***:***lower*  
**-y** *limit*  
Amplitude range. Specifies sample values for the upper and lower
*y-*axis limits. The second form is equivalent to **-y**
*-limit***:***limit.* If the option is omitted, or if both limits are
omitted, (**-y:**) then a default range for each file is computed from
the data. If one limit is omitted, a default limit for each file is
computed from the data.

**-z**  
Do not draw the *x-*axis (*y*=0).

**-L** *file* **\[(no tagged file)\]**  
Mark tag locations given in the named file. This option only applies to
the first input file specifed or, if none are given, to the first source
file of the file specified with this option. Any additional files are
plotted without any tag markings.

**-N**  
If this option is specified, then the sample values are plotted starting
with the range given by the **-p** option. Otherwise, the plots are
plotted by an offset determined by the number of horizontal resolution
units.

**-T** *device* **\[gps\]**  
*Device* may be **gps**, **mcd**, **tek**, **suntools**, **hp**, or
**hardcopy**. The default is **-Tmcd,** which displays the output on the
MASSCOMP screen by piping it through *mcd.* Specifying **-Tgps** sends
output to the standard output in MASSCOMP Unix GPS format. Specifying
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
*mlplot -W "=300x250+50+200" file*.\
See *xmcd(1-ESPS)* for details.

# EXAMPLES

% **mlplot** **-T** hardcopy **-p** 4555:9000 **-N** flute.sd jesdec.sd\
\# begin plot at sample 4555 and send output to be printed\
\# on a laser printer.

% **mlplot** **-T** hardcopy **-X** 1 **-l** 300 file1.sd file2.sd

    # Plot two sampled data files on the hardcopy device
    # with 1 pixel per point resolution and tic marks every 300 samples.

% **mlplot** **-T** gps **-o** FLUTE **-n** flute.sd\

    # create a directory called FLUTE to which to send the output, and
    # suppress output to stdout (-n option).
    The files generated will
    # correspond to pages generated by the first example above.
    # To view the second page on a MASSCOMP Graphics terminal,
    # type the following:

% **mcd** *FLUTE/page2*\
\# or\
% **ged** *FLUTE/page2*\


    # The latter command allows you to zoom into various parts of the
    graph; see the DATA PRESENTATION APPLICATION PROGRAMMING MANUAL for
    more information concerning ged.

    For Sun systems, this program will plot under either X windows, or
    Suntools.   By default, if the -T option is not used, it will 
    expect X windows.   To plot under Suntools you can use the -Tsuntools
    option.    If you always use Suntools, you can avoid using the -T
    option by defining the environment variable EPLOTDEV to be
    suntools.  This will make the Suntools window system the default.
    This variable is ignored if the machine type is not Sun4, SUN3, or
    SUN386i.

# FILES

None.

# SEE ALSO

*demux* (1-ESPS), *genplot* (1-ESPS), *genplot* (1-ESPS),\
*xmcd* (1-ESPS), *scatplot* (1-ESPS),\
*plotspec* (1-ESPS), *aplot* (1-ESPS)

# DIAGNOSTICS

    mlplot: unknown option -letter
    Usage: mlplot [-l int][-m{cpv}][-n][-o outdir][-p range][-s start]
    	[-t title][-x debug level][-y range][-z][-L file.esps][-N]
    	[-T device][-V text][-X scale][file1.sd ...]
    mlplot: can't allocate memory for n points
    mlplot: can't open filename: reason
    mlplot: filename is not an ESPS file
    mlplot: filename is not a sampled-data file.
    mlplot: filename is not tagged.
    mlplot: empty amplitude range specified.

# FUTURE CHANGES

Options to allow more control over format. More intelligent choice of
axis subdivisions. Selection of default *y*-axis limits according to
header information.

# BUGS

Default for the **-l** option should depend on the *x-*scale (**-X**
option).\

# AUTHOR

Rodney W. Johnson and Ajaipal S. Virdy, Entropic Speech, Inc.
