# NAME

plotspec - Plot spectral record files (.spec)

# SYNOPSIS

**plotspec** \[ **-d** \] \[ **-l** \] \[ **-r** *range* \] \[ **-t**
*text* \] . . . \[ **-x** *debug_level* \] \[ **-y** *range* \]\
\[ **-D** \] \[ **-F** \] \[ **-T** *device* \] \[ **-W** *generic
window system options* \] \[ **-X** *range* \] \[ **-Y** *range* \]
*file.fspec*

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

By default, the output is in Unix GPS (\`\`Graphics Primitive String'')
format and is displayed on the Masscomp or Sun display, but with the
**-T** option, this may be sent to the standard output, obtained in
Tektronix format rather than GPS, or plotted on a hardcopy device.

On Masscomp systems the color and line style of output to \`\`gps'' or
\`\`mcd'' depend on the environment variable BUNDLE. The default is GPS
bundle number 20, which gives solid lines on monochrome displays.

On a Sun workstation (not running X windows), this program must be run
from within the *Suntools* window system. The plot will appear in a new
window, which can be moved, resized, closed (reduced to an icon), and
removed by using the functions on the *Suntools* menu. To get this menu,
move the mouse cursor to the title bar of the plot window and press the
right mouse button.

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

**-x***debug_level*  
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
parts. The input file must contain data of type SPTYP_CPLX. The verical
axis is scaled in radians, from -pi to pi, and the **-y** and **-Y**
options are ignored.

**-T** *device*  
*Device* may be **gps**, **mcd**, **tek**, **suntools**, **hp**, or
**hardcopy**. The default is **-Tmcd,** which displays the output on the
worstation graphics screen by piping it through *mcd* or *xmcd.* The
program *mcd* is supplied by Masscomp for their systems, and by ESI for
other workstations. Specifying **-Tgps** sends output to the standard
output in Masscomp Unix GPS format. Specifying **-Ttek** causes output
to be sent to the standard output in Tektronix 4000-series format. If
**-Tsuntools** is used, then the display will be forced to use
*suntools* window system (on Suns and Solbournes only), even if ESPS has
been configured to use the X window system. If ESPS is built for X, then
it uses X for plotting by default. **-Thp** produces output for an HP
LaserJet printer. Note that the output is produced on standard out and
it is not spooled to the printer by this command. Use of this option
will result in about 750K bytes of output per page. If the link to your
LaserJet is slow, it might take several minutes to send it to the
printer. In a later version, this will be merged with the *hardcopy*
option above for direct spooling. If **-Tmcd** is used on a Masscomp and
ESPS has been configured to use X windows, then the old SP-40 *mcd* is
used instead of X windows. Specifying **-Thardcopy** plots it on a
hardcopy device, if one was set up in the installation script. Note that
the word *imagen* was used for this option in previous versions. It is
still accepted, but *hardcopy* is meant to be more general.

**-W**  
This option is followed by a character string consisting of the generic
window system options. These options are passed onto *mcd* or *xmcd*.
This option is used to pass along generic X window arguments to *xmcd*
or Suntool arguments to *mcd* on Suns. This option might not have an
effect on all systems. For example, on a system running X windows, to
cause the plot to appear at a particular screen location the following
command could be used:\
*plotspec -W "=300x250+50+200" file*.\
See *mcd(1-ESPS)* and *xmcd(1-ESPS)* for details.

**-X** *low***:***high*  
**-X** *limit*  
Frequency range. Specifies frequency values for the lower and upper
*x-*axis limits. If *low* or *high* is omitted, the limit is determined
from the file contents. The second form is equivalent to **-X**
0**:***limit* if the header value *freq_format* is SPFMT_SYM_CTR or
SPFMT_SYM_EDGE and to **-X** *-limit***:***limit* otherwise.

**-Y** *range*  
Specifies exact lower and upper limits for the *y-*axis.

For Sun systems, this program will plot under either X windows, or
Suntools. By default, if the **-T** option is not used, it will expect X
windows. To plot under Suntools you can use the **-Tsuntools** option.
If you always use Suntools, you can avoid using the **-T** option by
defining the environment variable **EPLOTDEV** to be *suntools*. This
will make the Suntools window system the default. This variable is
ignored if the machine type is not Sun4, SUN3, or SUN386i.

# EXAMPLE

> **plotspec** *\<options\> \<filename\>*

is equivalent to

> **plotspec -Tgps** *\<options\> \<filename\>* **\| mcd**

The second form may be used if nondefault options for *mcd* are desired.

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
Usage: plotspec \[-d\] \[-r range\] \[-t text\]... \[-x
debug_level\]\[-y range\]\
\[-E\] \[-T device\] \[-X range\] \[-Y range\] \[file.fspec\]\
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
plotspec: discrete distributions not het supported.\
plotspec: -s option not implemented yet.\
plotspec: -d and -F optins incompatible.\
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

To overlay FEA_SPEC files from *fft*(1-ESPS) on FES_SPEC files from
*me_spec*(1-ESPS), the **-G** option of *me_spec* must be used.

# BUGS

Frequency formats SPFMT_ARB_VAR and SPFMT_ARB_FIXED are not yet
supported.

# FUTURE CHANGES

Data conversions - *e.g.,* between log (dB) and linear representations.

# AUTHOR

S. Shankar Narayan. Made SDS compatible by Joe Buck. Originally called
*pspc.* Modified for ESPS by Rod Johnson, Entropic Speech, Inc.\
-d option added by Ajaipal S. Virdy. -T, -l, -D, and -F added by Rod
Johnson. Revised by Rod Johnson for input from FEA_SPEC file.
