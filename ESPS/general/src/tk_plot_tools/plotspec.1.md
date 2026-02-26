# NAME

plotspec - Plot spectral record files (.fspec)

# SYNOPSIS

**plotspec** \[ **-d** \] \[ **-l** \] \[ **-r** *range* \] \[ **-t**
*text* \] . . . \[ **-x** *debug_level* \] \[ **-y** *range* \]\
\[ **-D** \] \[ **-F** \] \[ **-W** *generic window system options* \]
\[ **-X** *range* \] \[ **-Y** *range* \] *file.fspec*

# DESCRIPTION

*plotspec* plots records from ESPS spectral-feature-record (FEA_SPEC)
files. These files can be created by the *me_spec* command. More than
one record may be plotted, superposed on one set of axes. If the input
file is \`\`-'', the standard input is read.

The default action is to plot the contents of the *re_spec_val* field of
the input records and, if the type is SPTYP_CPLX, the contents of
*im_spec_val* as well. However, alternative output formats are available
with the **-d**, **-D**, and **-F** options. When the spectrum type is
SPTYP_REAL and a power is required, as with the **-d** and **-D**
options, the square of *re_spec_val* is used.

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

# OPTIONS

The following options are supported.

**-d**  
Plot the power spectrum cumulative distribution function.

**-l**  
Plot frequencies on a logarithmic scale (labeled in decades). When the
vertical scale is in dB, this option results in Bode-plot format.

**-r** *first***:***last*  
**-r** *first***:+***incr*  
**-r** *frame*  
Range of records to be plotted. The default range is the entire file. In
the first form, a pair of unsigned integers gives the first and last
records of the range. The first frame in the file counts as number 1
regardless of any reference file. If *first* is omitted, 1 is used. If
*last* is omitted, the last record of the file is used. The second form
is equivalent to the first with *last* = *first* + *incr.* The third
form is equivalent to **-r** *frame***:***frame.*

**-t** *text*  
A line of text to be printed below the plot. If this option is specified
more than once, the lines are printed in the order given.

**-x** *debug_level*  
If *debug_level* is nonzero, debugging information is written to the
standard error output. The higher the level, the more messages are
written. Default is 0 (no debugging output).

**-y** *low***:***high*  
Data range. Specifies spectral values for the lower and upper *y*-axis
limits. If *low* or *high* is unspecified, the limit is determined from
the file contents. The values are adjusted by *plotspec* in an attempt
to make an esthetically pleasing plot. To specify exact limits, use
**-Y** instead.

**-D**  
Plot the logarithmically scaled power (in dB) regardless of whether the
spectrum type is SPTYP_DB or not. The arguments of the **-y** and **-Y**
options are interpreted in dB.

**-F**  
Plot the phase of complex data, rather than the real and imaginary
parts. The input file must contain data of type SPTYP_CPLX. The vertical
axis is scaled in radians, from -pi to pi, and the **-y** and **-Y**
options are ignored.

**-W**  
This option is followed by a character string consisting of X window
geometry information to specify the size and location of the plot
window. The form of the string is *=width*x*height+x+y* (any of *=*,
*width*x*height*, or *+x+y* can be omitted). For example, an initial
position can be specified as *+100+0*, and an initial size can be
specified as *=500*x*200*.

**-X** *low***:***high*  
**-X** *limit*  
Frequency range. Specifies frequency values for the lower and upper
*x-*axis limits. If *low* or *high* is omitted, the limit is determined
from the file contents. The second form is equivalent to **-X**
0**:***limit* if the header value *freq_format* is SPFMT_SYM_CTR or
SPFMT_SYM_EDGE and to **-X** *-limit***:***limit* otherwise.

**-Y** *range*  
Specifies exact lower and upper limits for the *y-*axis.

# ESPS PARAMETERS

The ESPS parameter file is not read.

# ESPS COMMON

The ESPS common file is not read or written.

# ESPS HEADERS

The following values are explicitly read from the header of the
spectral-feature-record file: *common.type,* and the generic header
items *num_freqs* and *freq_format.* In addition, the header is examined
by the library routines *allo_feaspec_rec,* *get_feaspec_rec,* and
*put_feaspec_rec.*

# SUBROUTINES CALLED

plotscale, drawbox, plot2data and printtime.

# SEE ALSO

me_spec(1-ESPS), plotsd(1-ESPS), FEA_SPEC(5-ESPS)

# DIAGNOSTICS

plotspec: unknown option: -*letter*\
Usage: plotspec \[-d\] \[-l\] \[-r range\] \[-t text\]... \[-x
debug_level\]\[-y range\]\
\[-D\] \[-F\] \[-X range\] \[-Y range\] file.fspec\
plotspec: Too many -t options\
plotspec: no input file\
plotspec: more than one input file\
plotspec: *filename* is not an ESPS file.\
plotting records *n1* thru *n2.*\
plotspec: can't open temporary file.\
plotspec: EOF encountered before start reached.\
can't allocate memory for *n* points.\
plotspec: only freq formats SPFMT_SYM_EDGE, SPFMT_SYM_CTR,
SPFMT_ASYM_EDGE, SPFMT_ASYM_CEN supported so far.\
plotspec: discrete distributions not yet supported.\
plotspec: -s option not implemented yet.\
plotspec: -d and -F options incompatible.\
plotspec: -F option requires complex data.\
plotspec: can't open temporary file.\
plotspec: freq format SPFMT_ARB_VAR not yet supported.\
plotspec: freq format SPFMT_ARB_FIXED not yet supported.\
plotspec: unrecognized freq format *n.*\
frequency out of range.\
data out of range.\
plotspec: no input records\
-T option requires argument.

# WARNINGS

To overlay FEA_SPEC files from *fft*(1-ESPS) on FEA_SPEC files from
*me_spec*(1-ESPS), the **-G** option of *me_spec* must be used.

# BUGS

Frequency formats SPFMT_ARB_VAR and SPFMT_ARB_FIXED are not yet
supported.
