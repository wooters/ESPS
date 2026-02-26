# NAME

plotsgram - plots a FEA_SPEC file as a spectrogram

# SYNOPSIS

**plotsgram** \[ **-x** \] \[ **-T** *device* \] \[ *image* options \]
*input.spec*

# DESCRIPTION

*plotsgram* calls the program *image* (1-ESPS) with appropriate options
for displaying a FEA_SPEC file (*input.spec*) produced by *sgram*
(1-ESPS) or *me_sgram* (1-ESPS) as a speech spectrogram. Various output
devices may be specified by using the **-T** option. See below for more
details. By default, on single-plane displays, a halftoning algorithm is
used to simulate a continuous grey scale with a varying density of black
and white dots; on multiplane color displays, a multilevel grey-scale
rendering is used.

*Plotsgram* is a shell script that uses *image* (1-ESPS), which is why
the parameter and Common files are not processed.

If "-" is specified for the input file (*input.spec*), standard input is
used.

# OPTIONS

**-x**  
Causes a debugging trace to be printed, including the command line that
invokes *image.*

**-T** *device*  
Specifies the output device format. Possible values are **mcd**,
**x11**, **hardcopy**, **ras**, **imagen**, **postscript**, and **hp**.
The default value calls for displaying the image on the user's graphics
terminal. A value of **x11** calls for use of the X Window System
(Version 11), which is usually the default on systems where it is
available. Otherwise the default is **mcd**, which calls for use of a
system's native graphics system, if any, by piping it through *mcd.* The
program *mcd* is supplied by Masscomp for their systems and is supplied
by ERL for Sun workstations. Specifying **-Thardcopy** causes the output
to the spooled to a hardcopy device. By default, this causes postscript
output to be spooled to the spooler program named *lpr*. If this is not
correct for your system, you can change the meaning of *hardcopy* by
editing *plotsgram* (which is a shell script), in *\$ESPS_BASE/bin*.
Comments near the top of the script direct you to the lines to edit.
Specifying **-Tras** sends output to the standard output in Sun
raster-file format; this may be viewed on the Sun by piping into the
program *showras*(ESPS-1). Specifying **-Timagen**, **-Tpostscript**, or
**-Thp** sends output to a local Imagen, PostScript, or Hewlett-Packard
laser printer. The full resolution of the laser printer is used; this
provides a higher-resolution display than a screen dump.

*image* options  
Options other than the above are passed on to *image.* What follows is a
list with brief comments. See the *image*(1-ESPS) manual entry for more
details. The forms shown in brackets, if any, are those with which
*plotsgram* normally invokes *image.* Explicit entries on the
*plotsgram* command line can override these and modify the program's
behavior in other ways.

**-e** *grange*  

**-e "***field-name*** \[ ***grange*** \] "**

**-e** *field-name*  
This option specifies a set of elements within each record.

**-l** *low***:***high*  
**-l** *low***:+***incr*  
Sets the data values corresponding to the limits of the grayscale.

**-o**  
Changes the orientation of the image.

**-p** *range*  
**-r** *range*  
**-s** *range* **\[-s:\]**  
The range of the data to be displayed is specified by using these
options. With **-p**, the range is specified in terms of sample numbers
(\`\`points'') as referrd to by record tags. With **-r**, the range is
specified in terms of record numbers, counting the first in the file as
number 1. With **-s**, the range is specified in seconds. The default
displays the entire file. On monitors, wide-band spectrograms look best
when displayed in pieces that are 1 second or less in duration, and
narrow-band spectrograms look best when displayed in pieces that are
greater than 1 second.

**-t** *text* \[-t"Time (seconds)"\]

> Title to be printed at the bottom of the page.

**-A** *algorithm*  
Specifies the algorithm used for rendering grey-scale images. On
multiplane color systems, the default is *16od1_2,* which gives superior
results but works only on such systems. On other systems, the default is
the *fs2* halftoning algorithm, which uses black and white dots.

**-B** *scale* **\[-B0\]**  
Controls the sizes and spacing of tick marks and characters in axis
labels and titles. The default value of 0 causes a reasonable scale to
be selected for the particular output device.

**-C "***file-name*** \[ ***grange*** \] "**

**-C** *file-name*  
Reads a file containing triples of intensities (red, green, blue) and
loads the color map used by *image.*

**-D**  
Disables smoothing of intensities by linear interpolation; each data
point appears as a rectangle with a sharp boundary and a uniform
intensity.

**-F** *function*  
Apply a function to the data before the gray-scale algorithm is applied.

**-G** *low***:***high* **\[-G-30:0 *or* -G-25:0\]**  
Normalize gains to enhance features in low-level spectrum records.

**-L**{**prs**} **\[-Ls\]**  
> Label the *x*-axis in terms of \`\`**p**oints'' (*i.e.* tag values),
> **r**ecord numbers, or **s**econds.

**-M** *magnification*  
For laser-printer output renders each pixel of the image as an *m*×*m*
block of device resolution cells, where *m* is the magnification.

**-P** *param*  
A parameter file is read by *image.* (Parameters *startrec,* *nrecs,*
*x_text,* *b_scale,* *gain_low_lim,* *gain_high_lim,* *label_units,* and
*y_text* have no effect since *plotsgram* calls *image* with
command-line options that take precedence. The parameter *device* may
cause confusion if included.)

**-S** *width***:***height*  
**-S** *width*  
The size of the image in pixels.

**-V** *text* \[-V"Freq. (Hz.)"\]

> Title to be printed along the left edge of the page (running upward).

# ESPS PARAMETERS

The ESPS parameter file is not read by *plotsgram;* but see **-P** under
Options.

# ESPS COMMON

The ESPS Common file is not read by *plotsgram* or by *image.*

# ESPS HEADERS

None written.

# FUTURE CHANGES

*plotsgram*(1-ESPS) might be re-implemented as a C program, so that
parameter file processing can be properly supported.

# SEE ALSO

me_sgram(1-ESPS), sgram(1-ESPS), fft(1-ESPS), image(1-ESPS),
refcof(1-ESPS)

# DIAGNOSTICS

Some errors in command-line syntax are caught by *plotsgram* and result
in one or more of the messages

> Usage: plotsgram \[-x\] \[-T device\] \[image(1-ESPS) options\]
> input.spec\
> plotsgram: -\<*letter*\> requires argument.\
> plotsgram: No input file specified.\
> plosgram: Invalid output device type \<*device*\>

The message

> plotsgram: \<*filename*\> is not a readable file.

is also possible. Some errors, including command-line syntax errors, are
caught by *image* and result in *image* error messages.

# BUGS

Escaped special characters, such as quotes, do not work as expected in
the arguments to **-t** and **-V**.

# AUTHOR

Manual page and program by David Burton. Revised by Rod Johnson to
accommodate revisions to *image.*
