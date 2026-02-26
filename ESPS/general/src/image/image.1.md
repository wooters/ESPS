# NAME

image - plot data from ESPS file as a color, gray-scale, or halftone
image

# SYNOPSIS

**image** \[ **-**{**ef**} ***range*** \] . . . \[ **-l** *range* \] \[
**-o** \] \[ **-**{**prs**} ***range*** \] \[ **-t** *text* \]\
\[ **-x** *debug_level* \] \[ **-A** *algorithm* \] \[ **-B** *scale* \]
\[ **-C** *colormap* \] \[ **-D** \] \[ **-F** *function* \]\
\[ **-G** *range* \] \[ **-L**{**prs**} \] \[ **-M** magnification \] \[
**-P** *param* \] \[ **-S** *width\[***:***height\]* \] \[ **-T**
*device* \] \[ **-V** *text* \] \[ **-W** *X_geometry* \] *file*

# DESCRIPTION

*Image* interprets data from a specific ESPS FEA field as comprising the
rows (or columns) of an image, and it displays the resulting image. A
typical use for *image* to display data from an ESPS spectrum (FEA_SPEC)
file as a spectrogram (see *plotsgram* (1-ESPS), which is a script that
calls *image*).

In general, data values are obtained from the input records, scaled to
represent gray-scale values, and displayed as a two-dimensional image
with one axis representing time or record number and one axis
representing frequency or relative position within a record. On
single-plane systems, the gray scale is simulated by a half-tone
technique: the density of dots near a point is proportional to the value
being represented. Alternatively, on some devices, a true gray-scale
image may be obtained, consisting of dots of various intermediate
intensities, and a colormap may be specified for use on color systems. A
range of records within the file may be selected with the **-p**,
**-r**, or **-s** option, and a range of elements within the record may
be selected with the **-f** option. By default, the image is displayed
on the user's graphics display; hard copy may also be obtained, or the
image may be saved to a file.

# OPTIONS

The following options are supported. Values in brackets are defaults.

**-e** *range*  
The option letters **-e** and **-f** are synonymous, and *range* may
have any of the forms shown below with **-f.** The preferred letter is
now **-f** (mnemonic for \`\`field name''), but **-e** (mnemonic for
\`\`element number'') is supported for backward compatibility.

**-f** *grange*  

**-f "***field-name*** \[ ***grange*** \] "**

**-f** *field-name* **\[re_spec_val\]**  
This option specifies a set of elements within each record.

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

The command line may contain several **-f** options with field names.
The **-f** option without a field name may be used at most once and may
not be used in the same command with the form containing a field name.

If the input file is an ESPS spectrum (FEA_SPEC) file and this option is
not specified, the spectrum values are converted to logarithmically
scaled power (in dB) and plotted against frequency instead of position
withing the record.

The first form of this option (with no field name) was devised to permit
specifying elements of ESPS files of arbitrary types, including non_FEA
types. With the replacement of non-FEA file types by FEA subtypes, this
form has become obsolescent; the forms involving a field name are
preferred for use with FEA files. The first form is not supported with
input files that contain fields with complex data types. The forms
involving a field name are supported with real fields even though other
fields in the file may be complex.

**-l** *low***:***high* **\[(determined from data)\]**  
**-l** *low***:+***incr*  
The first form gives the data values corresponding to the limits of the
grayscale. Values of *low* or less correspond to a blank region of the
image, and values of *high* or more correspond to a completely filled-in
region. If *high* = *low* + *incr,* the second form (with the plus sign)
specifies the same range as the first.

**-o**  
The default orientation of the image has the origin in the lower left
corner with the horizontal axis representing time or record number and
the vertical axis representing frequency or relative position within the
record. If this option is specified, the origin is moved to the upper
left corner, and the roles of the axes are reversed.

**-**{**prs**} *first***:***last* \[(first in file):(last in file)\]  
**-**{**prs**} *first***:+***incr*  
In the first form, a pair of unsigned integers specifies the range of
records from which element values are to be plotted. If **-r** is used,
the limits refer to the record number, counting the first record in the
file as number one. If **-p** is used, the file must be tagged, and the
limits refer to the values of the tags. If **-s** is used, the limits
are times in seconds. It must then be possible to associate times with
records. There are two possibilities. The first is that the file is
tagged, and the header contains the generic header item "src_sf", which
gives the sampling frequency of the reference file. (In tagged FES_SPEC
files without "src_sf", the header item "sf" is used instead.) Then the
time associated with a record is (*tag* - 1) divided by the sampling
frequency. The second possibility is that the file contains the generic
header item "record_freq". In that case the time associated with record
number *r* is given by *start_time* + (*r*-1)/*record_freq,* where
*start_time* is given by the generic header item "start_time" or 0 if
the item is not present.

Either *first* or *last* may be omitted; then the default value is used.
If *last* = *first* + *incr,* the second form (with the plus sign)
specifies the same range as the first. If the specified range contains
records not in the file, the range is reduced as necessary.

**-t** *text* **\[(none)\]**  
Title to be printed at the bottom of the page.

**-x** *debug level* **\[0\]**  
Print diagnostic messages as program runs (for debugging purposes only).
Higher levels give more messages. The default level of zero suppresses
all debugging messages.

**-A** *algorithm* **\[(device-dependent)\]**  
Gray-scale algorithm. The following arguments give black-and-white dot
halftone renderings:

*od1 od2 od3 od4 fs fs2*

On Masscomp, X Windows, and Sun multiplane color systems, the following
arguments give multilevel gray-scale renderings by manipulating the
color map:

*16lvl 16od1 16od1_2 16od1_3.*

In the first set, *od1-od4* are just ordered-dither algorithms with
various threshold matrices. Better results may usually be obtained with
*fs,* which is a Floyd-Steinberg algorithm. Algorithm *fs2* first
squares the scaled values between 0 and 1 that represent the gray
levels: then it applies *fs.* The squaring operation enhances the
contrast in the darker areas of the image, and *fs2* is recommended for
use with spectrograms.

The algorithms of the second group use 16 entries in the color map to
obtain 16 different gray levels. The first one, *16lvl,* is a
simple-minded algorithm that just rounds each gray level to the nearest
of the 16 levels. It produces contouring and is not recommended. The
other three use dithering between adjacent gray levels to simulate a
much greater number of gray levels than 16. Algorithm *16od1_2* is a
variant of *16od1* just as *fs2* is a variant of *fs* - it uses a
squaring operation to enhance contrast in the darker areas. Algorithm
*16od1_3* is similar, but cubes instead of squaring. For spectrograms,
*16od1_2* or *16od1_3* is recommended. On the multiplane color systems
mentioned above, the default is *16od1_2* for FEA_SPEC input files and
*16od1* for other file types. On other output devices, the default is
*fs2* for FEA_SPEC input files and *fs* for other file types.

**-B** *scale* **\[0\]**  
Include a border containing titles and axis labels. Unless this option
is invoked, only the unadorned gray-scale image is displayed, and the
**-t** and **-V** options have no effect. The argument is a scale factor
that controls the sizes and spacing of tick marks and characters in axis
labels and titles. The default value of 0 causes a reasonable scale to
be selected for the particular output device.

**-C** *file-name*  

**-C** *file-name*** \[ ***grange*** \] **

> Read a file containing triples of intensities (red, green, blue) and
> load the color map used by *image.* This option is effective only on
> color systems running X Windows or Sun's SunView window system, and
> only when the \`\`gray-scale'' algorithm (see **-A**) actually uses
> multiple color-map entries. The file should be an Ascii file
> containing lines that begin with three integers (base 10) in the range
> 0-255. The numbers should be delimited by whitespace; anything that
> follows on the same line is ignored. Colormap files used with *waves+*
> have this format and can be read by *image.* The filename may
> optionally be followed by a bracketed range specification of the type
> accepted by *grange_switch*(3-ESPSu). This specifies a sequence of
> line numbers in the file; for example **-C** cmap**\[**25:85**\]**
> selects the colormap entries from lines 25 through 85 of the file
> *cmap.* The line numbering begins with 0 for the first line. Omitting
> the bracketed range specification selects all lines in the file. If
> this option is not specified, and if there is no *colormap* entry in
> the parameter file, the program uses a default scale of grays starting
> with {255, 255, 255} (white) and decreasing in equal steps to {0, 0,
> 0} (black). At present all the algorithms that set the color map at
> all use a 16-entry color map. However, it is not necessary for the
> file or the selected sequence of lines to contain exactly 16 entries;
> if there are too many or too few, a sequence of 16 triples is derived
> by linear interpolation.

**-D**  
Disable linear interpolation. Normally *image* interpolates between data
points to make the intensity (or color) vary continuously from point to
point in the image. When **-D** is specified, the data points each
appear in a rectangle with a sharp boundary and a uniform intensity or
color representing the actual data value.

**-F** *function***\[(log for FEA_SPEC files, NONE for other types)\]**  
Apply a function to the data before the gray-scale algorithm is applied.
The possible arguments are

*NONE log exp sq sqrt.*

The default is *NONE* for FEA files.

For FEA_SPEC files, *log* converts the spectral values to dB, whatever
the actual FEA_SPEC-file subtype; this is the default for FEA_SPEC
files. *NONE* converts to actual power, and *sqrt* gives the square root
of the power. Though available, *sq* and *exp* are unlikely to be useful
with FEA_SPEC files.

The **-F** option interacts with the **-l** option in that the limits
given with **-l** apply to the values that result from applying the
function. Thus if, for instance, **-FNONE** is used with a FEA_SPEC
file, then the arguments of **-l** are interpreted as actual power
rather than dB.

**-G** *low***:***high* **\[(none)\]**  
Normalize gains to enhance features in low-level spectrum records. This
option causes the mapping of data values to gray levels to be adjusted
individually in each time slice. For example, **-G-20:-1** means that
anything more than 20 dB below the maximium value in the time slice is
rendered as white, and anything less than 1 dB below the maximium in the
time slice is rendered as black. These limits can be chosen to improve
the appearance of a spectrogram. Lowering the lower limit will bring out
more faint detail but will also permit more intrusion of gray into the
spaces between formants. Lowering the upper limit will broaden the
high-level formant tracks but wil also introduce more gray.

In the absence of **-G**, the lower and upper limits on data values,
corresponding to white and black, are globally determined, either
explicitly with **-l** or by default from the global maximum data value.
When **-G** is used, there are additional adjustments to keep the limits
determined by **-G** from overstepping the bounds given by the global
limits.

**-L**{**prs**}  
> Label the *x*-axis in terms of \`\`**p**oints'' (*i.e.* tag values),
> **r**ecord numbers, or **s**econds.w If this option is not specified,
> and if the parameter file does not specify a value for *label_units,*
> the axis is labeled in the units in which the range was specified with
> the **-p***,* **-r***,* or **-s** option. If none of those three were
> used, the final default is **-Lr**. If **-Lp** is used, the file must
> be tagged. If **-Ls** is used, it must be possible to associate times
> with records as described for the **-s** option.

**-M** *magnification* **\[1\]**  
This option if effective for laser-printer output via **-Timagen**,
**-Tpostscript**, or **-Thp** The option causes each pixel of the image
to be rendered as an *m*×*m* block of device resolution cells, where *m*
is the magnification; thus a magnification greater than 1 causes output
at a coarser resolution than the finest the device is capable of. The
default magnification of 1 gives full-resolution images. When the lower
resolution is acceptable, a magnification greater than 1 can greatly
speed up the printing of images by reducing the number of bits that must
be sent to the printer. Acceptable magnifications are 1, 2, and 4 for an
Imagen; any positive integer for Postscript; and 1, 2, 3, and 4 for an
HP printer.

**-P** *param* **\[param\]**  
The name of the parameter file.

**-S** *width***:***height***"\[(device-dependent)\]**  
**-S** *width*  
The size in pixels of the image. The second form implies a square image.
For a graphics display, the default size depends on the size of the
screen or window.

**-T** *device* **\[x11 *or* mcd\]**  
Output device. The default value calls for displaying the image on the
user's graphics terminal. A value of **x11** calls for use of the X
Window System (Version 11), which is usually the default on systems
where it is available. Otherwise the default is **mcd**, which calls for
use of a system's native graphics system, if any. A value of **imagen**
causes output on *stdout* suitable for an Imagen laser printer. The
output may be piped directly to *ipr*(1). A value of **postscript**
causes PostScript output on *stdout,* and **hp** causes output on
*stdout* suitable for a Hewlett-Packard printer. A value of **ras**
causes output on *stdout* in Sun raster-file format; this may be viewed
on the Sun by piping into the program *showras*(ESPS-1). A value of
**type** causes a crude Ascii typewriter plot to be sent to *stdout.*

**-V** *text* **\[(none)\]**  
Title to be printed along the left edge of the page (running upward).

**-W** *X_geometry*  
For versions of this program that use X-window graphics, this option is
used to specify the location and size of the plot. The standard X
windows syntax is used:
"=\<width\>x\<height\>{+-}\<xoffset\>{+-}\<yoffset\>, where items
enclosed in "\<\>" are integers and items enclosed in "{}" are a set
from which one is allowed. If this option is not specified, internally
generated defaults are used, as is the case for non X-window based
systems.

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
values for all parameters. If the file exists, the following parameters
may be read if they are not determined by command-line options.

*elements - integer array*  
The element positions selected in each record. This parameter is not
read if the command-line option **-f** (or **-e**) is specified. If the
set of element positions is specified neither with the option nor in the
parameter file, the default is as described for the option.

*minlevel - real*  
Data value corresponding to the lower limit of the grayscale. This
parameter is not read if the **-l** option is specified. If the
command-line option is not specified and the paramter is not present in
the parameter file, the default used is the lowest data value to be
represented.

*maxlevel - real*  
Data value corresponding to the upper limit of the grayscale. This
parameter is not read if the **-l** option is specified. If the option
is not specified and the paramter is not present, the default used is
the greatest data value to be represented.

*orientation - string*  
The orientation of the image. This parameter is not read if the **-o**
option is specified. Two values are recognized: "default" and "rotated".
The string "default" refers to the default orientation as described for
the **-o** option, and assigning this value is equivalent to omitting
the parameter entirely. The string "rotated" refers to the orientation
obtained when the **-o** option is specified.

*startrec - integer*  
The record number of the first record to be processed. This parameter is
not read if the **-p**, **-r**, or **-s** option is specified. The
default value is 1 in case these options are not specified and the
parameter is omitted from the parameter file.

*nrecs - integer*  
The number of record to be processed. This parameter is not read if the
**-p**, **-r**, or **-s** option is specified. The default is to
continue processing until the end of the file in case these options are
not specified and the parameter is omitted from the parameter file.

*x_text - string*  
Text to b printed at the bottom of the page. This parameter is not read
if the **-t** option is specified. If no text is specified either with
the option or in the parameter file, none is printed.

*algorithm - string*  
Gray-scale algorithm. The possible values are arguments for **-A**
listed under Options. This parameter is not read if the **-A** option is
specified. The default is "fs" (Floyd-Steinberg) in case no algorithm is
specified with either the command-line option or this parameter.

*b_scale - integer*  
Scale factor that determines the sizes and spacing of tick marks, axis
labels, titles, and other features that occupy the border around the
actual image. This parameter is not read if the **-B** option is
specified. If the option is not specified and the parameter is not
present, the plot consists of the image alone, and the border is
omitted. A value of 0 for the option calls for a default appropriate to
the output device.

*colormap_file - string*  
The name of a file to be read for colormap entries. As in the argument
to the **-C** option, the file name may be followed by a bracked
*grange* specification indicating a list of line numbers. This parameter
is not read if the **-C** option is specified. If no colormap file is
specified with either the command-line option or in the parameter file,
the default is an internally computed scale of grays ranging between
white and black.

*function - string*  
A function to be applied to the data before the gray-scale algortihm is
applied. The possible values are the arguments to **-F** listed under
Options. This parameter is not read if the **-F** option is specified.
In case no function is specified with either the command-line option or
in the parameter file, the default is "log" (convert to dB) for FEA_SPEC
files and "NONE" for other types.

*gain_low_lim - real*  
*gain_high_lim - real*  
Limits used in normalizing gains as described for the **-G** option.
This parameter is not read if the **-G** option is specified. If the
option is not specified and these parameters are not in the parameter
file, no gain normalization is done. If the option is not specified and
either of these parameters is present, the other must be present also.

*label_units - char*  
Allowed values are 'p', 'r', and 's', indicating whether to label the
*x*-axis in terms of \`\`points'' (*i.e.* tag values), record numbers,
or seconds. This parameter is not read if the **-L** option is
specified. The default when the option is not specified and the
parameter is not present is as described for the **-L** option.

*magnification - integer*  
Magnification factor to control the resolution of "imagen",
"postscript", and "hp" laser-printer images. This parameter is not read
if the **-M** option is specified. The default is 1 when the option is
not specified and the parameter is not present.

*width - integer*  
*height - integer*  
The dimensions in pixels of the image. These parameters are not read if
the **-S** option is specified. The default dimensions, used when the
option is not specified and the parameter is not present, depend on the
output device.

*device - string*  
The name of the output device. This parameter is not read if the **-T**
option is specified. The default, used when the option is not specified
and the parameter is omitted, is "x11" or "mcd", depending on what is
available on a particular system. Other possible values are as described
under **-T** in the Options section.

*y_text - string*  
Text to be printed up the left side of the page. This parameter is not
read if the **-V** option is specified. If no text is specified either
with the option or in the parameter file, none is printed.

# ESPS COMMON

The ESPS common file is not accessed.

# ESPS HEADERS

# EXAMPLES

On a black-and-white display, try the following on a sampled-data file
*speech.sd* containing a half-second or second of speech.

    filter -Ppreemp_params speech.sd - \
        | fft -o6 -l32 -S10 -p1:2000000000 - - \
        | image -t"Time (seconds)" -V"Freq. (Hz)" -s: -Afs2 -B0 -G-20:0 -

On a multiplane color display, try changing "-Afs2" to "-A16od1_2" or
"-A16od1_3".

The file preemp_params may contain the following.

    # parameter file for preemphasis with filter(1-ESPS) program
    float	filter_num = {1.0, -1.0}: "Preemphasis filter numerator";
    float	filter_den = {1.0}: "Preemphasis filter denominator";
    int	filter_nsiz = 2: "Number of numerator coefficients";
    int	filter_dsiz = 0: "Number of denominator coefficients";

# SEE ALSO

# DIAGNOSTICS

    image: unknown option -<letter>
    Usage: image [-{ef} range] . . . [-l range][-o][-{prs} range][-t text]
     [-x debug_level][-A algorithm[-B scale][-C colormap][-F function][-G range]
     [-L{prs}][-M mag][-P param][-S width[:height]][-T device][-V text] file
    image: too many file names specified.
    image: no input file name specified.
    image: only one of -p, -r, and -s may be used at one time
    image: named fields allowed only with FEA files
    image: if any -f option argument has a field name, all must.
    image: unrecognized function name.
    image: header item "spec_type" undefined or not CODED
    image: unknown spectral type
    image: header item 
    image: use -f option unless file is FEA file.
    image: axis label units must be given as p, r, or s.
    image: -p option or axis labeling in points requires tagged file
    image: -s option or axis labeling in seconds
           requires nonzero sampling or record frequency.
    image: initial tag not positive
    image: initial tag not less than final tag
    image: initial record number not positive
    image: initial record number not less than final record number
    image: starting time before start of file
    image: starting time not less than ending time
    image: starting record number not positive
    image: span of records in file doesn't overlap given range
    image: unrecognized value for "orientation" parameter
    image: magnification must be positive.
    image: header item "freq_format" undefined or not CODED
    image: header item "sf" undefined or not FLOAT
    image: freq format ARB_VAR not yet supported.
    image: unrecognized freq format <code number>.
    image: just one of "gain_low_lim" and "gain_high_lim" defined
    image: field "<name>" not defined in feature file header
    image: first record doesn't precede end of range
    image: last record doesn't follow beginning of range
    image: can't open colormap file <file name>.
    image: no line <number> in colormap file.
    SPS assertion failed: <message>


        with any of the following messages.
    can't allocate space for field name list
    can't allocate space for element array from symbol table
    can't get "elements" parameter--may be too long
    can't allocate space for array of element numbers
    can't allocate space for input FEA_SPEC record
    can't allocate space for input data vector
    can't reallocate space for vector of element numbers
    can't allocate space for buffer to make temp file
    can't allocate space for 3 rows of interpolated values
    can't reallocate space for 3 rows of interpolated values
    can't allocate space for colormap
    can't reallocate space for colormap
    can't allocate space for subset of colormap
    can't allocate space to interpolate colormap

# BUGS

# WARNINGS

# FUTURE CHANGES

Support for fields with complex data types in FEA files. New device
types will be added.

# AUTHOR

Rodney Johnson.
