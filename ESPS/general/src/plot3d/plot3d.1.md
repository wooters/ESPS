# NAME

plot3d - interactive 3-d plots (perspective plots with hidden lines
removed) of data from FEA files.

# SYNOPSIS

**plot3d** \[ **-d** *depth* \] \[ **-f
"***field*** \[ ***range*** \] "** \] \[ **-o** *orientation* \] \[
**-r** *range* \] \[ **-x** *debug_level* \] \[ **-B**
*length***,***width***,***height* \] \[ **-I** {**aAbBcCpP**} . . . \]
\[ **-P** *param* \] \[ **-R** *bearing***,***elevation***,***rotation*
\] \[ **-S** *h_skew***:***v_skew* \] \[ **-w** \] \[ **-M** \] *file*

# DESCRIPTION

*plot3d* reads data from a specified field of an ESPS FEA file and
constructs a three-dimensional plot of the data versus two independent
variables. A plot of data from the *re_spec_val* field of a FEA_SPEC
file, for example, could show time along one axis, frequency along
another axis, and spectral power density (or its log) along the third
axis. In general, the *x*-axis corresponds to the order of records in
the file, the *y*-axis corresponds to the order of elements in the
field, and the *z*-axis represents the data values. The
three-dimensional plot is rendered in a window on the screen as a
perspective drawing.

The user has complete control over the scaling, orientation, depth of
perspective, and angle of view of the plot. These plotting parameters
are set initially by command-line options or values in an ESPS parameter
file, but they can be adjusted interactively with mouse-operated sliders
and other controls in a control-panel window, or with mouse movements in
the plot window. Operating the controls causes a wire-frame drawing of
the bounding box of the plot to move and change size accordingly, and
clicking on a button in the control-panel window causes the plot to be
redrawn with the new parameters. The current set of parameters can be
saved to a file so that other plots may later be drawn with the same
viewpoint. Saved parameter sets may be loaded from a file at any time.

Data may be loaded from a file interactively; the file name, range of
records to be read, field name, and range of items in the field may all
be respecified.

A moving cursor, controlled by the mouse, allows the coordinates of
points of the graph to be read off numerically.

In addition to the display on the user's screen; the plot image may be
saved in a file, so that it can be printed or imported into a word
processing system. The plot image can be saved as either PostScript or
PCL. It can be directly sent to a printer, if there is no need to save
the image file.

# OPTIONS

The following options are supported. Values in brackets are defaults.

**-d** *depth* **\[50\]**  
Depth of perspective. A value of 0 corresponds to projection of the
3-dimensional plot onto the 2-dimensional plotting surface from an
infinite distance *i.e.* parallel projection. Positive values of *depth*
correspond to projection from inversely proportional finite distances
with the result that foreground features are shown at a somewhat larger
scale than features farther from the viewer. The default value of 50 is
reasonable for normal viewing distances. Large values produce highly
exaggerated perspective effects.

**-f "***field*** \[ ***range*** \] "** \["re_spec_val\[0:\<*last*\>\]"\]  
**-f** *field*  
Name of a field in an ESPS FEA file and range of elements in field to be
plotted. (Numbering of field elements starts with 0.) The quotes are
needed only to suppress the shell's usual special interpretation of
brackets. The bracketed *range,* if present, may have any of the forms
acceptable to *range_switch*(3-ESPSu).

*element*  
A single integer specifies a single field element (not at present useful
with *plot3d*).

*first***:***last*  
A pair of integers specifies an inclusive range of elements.

*first***:+***incr*  
The form with the plus sign is equivalent to *first***:***last* with
*last* = *first* + *incr.*

If the specified range contains elements not present in the field, the
range is reduced as necessary.

**-o** *orientation* **\[L\]**  
Left-handed coordinate system ("L") or right-handed ("R")? When the axes
are in their default initial position, record number increases with
distance from the viewer, element number increases from left to right,
and data values increase in the upward direction. For some possible
positions, a mirror-reflected orientation may seem more natural.
Specifying *R* instead of *L* effectively reverses the direction of the
*y* (element number) axis.

**-r** *range* **\[1:\<*end of file*\>\]**  
Range of records in the file to be read and plotted (counting the first
as number 1.) The allowable forms for *range* are those for
*range_switch*(3-ESPSu); see the discussion of **-f** above or the
*range_switch* manual entry.

**-x** *debug_level* **\[0\]**  
Values greater than 0 cause various debugging messages to be printed as
the program runs. Larger values call out more messages. The default
level of 0 suppresses all debugging messages.

**-B** *length***,***width***,***height \[400,250,150\]*  
Dimensions, in pixels, of a rectangular box that bounds the 3-d plot
(except for axis labels and the like).

**-I** {**aAbBcCpP**} . . . **\[abcp\]**  
Initial actions, taken when the plot window is first brought up. Draw
axes (a, A), draw bounding box (b, B), bring up control panel (c, C), or
plot data (p, P). A lower-case letters (a, b, c, p) invokes the action,
and upper-case (A, B, C, P) suppresses it.

**-P** *param_file* **\[params\]**  
Name of parameter file to be read initially.

**-R** *bearing***,***elevation***,***rotation \[45.00,35.26,0.00\]*  
Three angles of rotation (measured in degrees) that describe the
relative positions of the 3-dimensional plot and the 2-dimensional
plotting window. The *bearing* and *elevation* determine the direction,
relative to the 3-d coordinate system, of the line normal to the window
at its center. Changing the bearing lets you look at the plot from
various sides, and increasing the elevation lets you look at it from the
top. The third degree of freedom, *\`\`rotation,''* corresponds to a
rotation about the line normal to the window at its center and for most
purposes is probably best set equal to 0.

**-S** *h_skew***:***v_skew* **\[0,0\]**  
Changing *h_skew* moves the front parts of the plot one way horizontally
and the back parts of the plot the opposite way, in proportion to the
distance forward or back with respect to the plane of the plot window.
The effect is somewhat similar to adjusting *bearing* (**-R** above) in
that both adjustments let you see more or less of the left or right side
of the plot. However, adjusting *h_skew* does not produce a rotation:
planes parallel to the plane of the plot window remain so. Similarly,
changing *v_skew* moves the front parts of the plot one way vertically
and the back part of the plot the opposite way. The effect is somewhat
similar to adjusting *elevation* in that both adjustments let you see
more or less of the top of the plot. However, adjusting *v_skew* does
not produce a rotation of planes parallel to the plot window.

**-w**  
This option causes *plot3d* to attempt to connect to an *xwaves*(1-ESPS)
running with its server mode enabled. If this connection is made, then
*plot3d* will send cursor movement commands to *xwaves+* to maintain
cursor time alignment between the view in *plot3d* and the view in
*xwaves+*. Note that *plot3d* has no way of knowing if the files being
viewed in *plot3d* and *xwaves+* are related and if the time alignment
makes sense. A side effect of invoking this mode is to put the axis into
time and frequency display mode. If the information in the displayed
file cannot support this mode then the **-w** option is ignored. For
example, if the displayed file has no *record_freq* generic then then it
cannot send time cursor movements to *xwaves+*. If the displayed file,
is not a FEA_SPEC file, then it cannot send frequency cursor movements
to *xwaves+*.

When this option is used, the environment variable **WAVES_HOST** is
read to determine the name of the host that is running the *xwaves*
server. If **WAVES_HOST** is undefined, then the connection is attempted
to an *xwaves+* on the same host as *plot3d* is running on. The default
socket port number of the attempt is determined by a ESPS wide default
which is compiled in. If the environment variable **WAVES_PORT** is
defined, then its value is used instead as the socket port. This program
uses the facility of *send_xwaves*(3-ESPS). See its manual page for
details.

**-M**  
This option forces *plot3d* to paint everything in black and white
(monochrome), useful if you're doing screendumps.

# ESPS PARAMETERS

The parameter file is not required to be present, as there are default
values for all parameters. If the file exists, the parameters below may
be read. These provide an alternative way of specifying quantities that
can also be determined by command-line options. The general rule is that
if a command-line option is specified, it takes precedence; if the
command-line option is not specified, then the parameter file is
consulted; and if a quantity is not given either on the command line or
in the parameter file, then a default is used. Eventually this program
will support parameter-file entries corresponding to all command-line
options except **-x** and **-P**. These parameters may also be adjusted
interactively from the control panel. Current values may be saved to a
file, and new values may be read from a file interactively. (See the
discussion of the *load params* and *save params* items on the *files*
button menu under "Control Panel and Menus" below.

*box_length - integer*  
*box_width - integer*  
*box_height - integer*  
These correspond to the arguments *length,* *width,* and *height* of the
**-B** option.

*depth - float*  
This corresponds to the argument of the **-d** option.

*horizontal_skew - float*  
*vertical_skew - float*  
These correspond to the arguments *h_skew* and *v_skew* of the **-S**
option.

*orientation - string*  
This corresponds to the argument of the **-o** option.

*bearing - float*  
*elevation - float*  
*rotation - float*  
These correspond to the arguments of **-R**.

# CONTROL PANEL AND MENUS

The *length,* *width,* and *height* sliders in the first column adjust
the dimensions of the bounding box of the plot. The *scale* slider
allows all three dimensions to be increased or decreased by the same
factor simultaneously. The *depth* slider in the second column adjusts
the same parameter as the parameter-file entry *depth* or the **-d**
command-line option. Likewise the *H. skew* and *V. skew* sliders in the
second column, the *orientation* selector in the third column, and the
*rotation,* *bearing,* and *skew* sliders in the third column adjust the
same parameters as the similarly named parameter-file entries or
command-line arguments. To operate a slider, move the cursor to the
slider bar, press the left mouse button, and, while holding the button
down, move the cursor left or right.

There are buttons in the bottom row and the center top position that
perform various functions. To invoke one of the functions, move the
cursor to the panel button and click the left mouse button. In addition,
the three buttons (*files* , *axes* and *plot*) marked with small
triangles have associated menus. To bring up one of the menus, move the
cursor to the panel button and press the right mouse button.

The *plot* button redraws the plot. The associated menu has two items
related to printing the graphic image of the plot. The *print setup*
item invokes a setup panel that allows the user to configure the graphic
print feature. Select PostScript or PCL, Portrait or Landscape,
resolution of output device, scaling factor, and output to a file or
printer. In most cases a scale factor of about 4 is correct to fill a
page with the plot. The *print graphic* item causes the image on the
screen to be rerendered with the parameters selected from the *printer
setup* panel.

The *axes* button draws or removes graduated *x-, y-,* and *z-*axes
labeled with the values at the two ends. The associated menu has an
*on/off* item that performs the same function and two other items that
control the scaling and labeling of two of the axes.

Selecting the *record labeling* item brings up a submenu with various
options for the *x-*axis. The default is to scale the axis in terms of
record number (counting from 1 for the first record in the file). The
item *time (from rec \#)* can be selected when the header item
"record_freq" is defined in the input file header. It relabels the axis
in units of time, where the time associated with a record is
*start_time* + (*record_number* - 1)/*record_freq.* If the header item
"start_time" is not present, 0 is used for *start_time.* The item *tag*
can be selected when the input file is tagged. It relabels the axis in
terms of tags (*i.e.* record or sample numbers in the \`\`refer'' file
of the input filesee *ESPS*(5-ESPS) or *FEA*(5-ESPS)). The item *time
(from tag)* can be selected when the input file is tagged and the header
item "src_sf" is defined in its header. (In a FEA_SPEC file without
"src_sf", the header item "sf" is accepted in its place.) This item
relabels the axis in units of time, where the time associated with a
record is (*tag* - 1)/*src_sf.*

Selecting the *item labeling* item of the *axes* button menu brings up a
submenu with options for the *y-*axis. The default is to scale the axis
in terms of element number (counting from 0 for the first element of a
field). The item *frequency* can be selected when the input file is a
FEA_SPEC file whose "freq_format" (see *FEA_SPEC*(5-ESPS)) is not
SPFMT_ARB_VAR. It relabels the axis in units of frequency, where the
frequency of each field element is determined by values in the file
header (see *FEA_SPEC*(5-ESPS)).

If a file has nonuniformly spaced tags, switching the *x-*axis labeling
between *record* or *time (from rec \#)* and *tag* or *time (from tag)*
renders the plot incorrect. It is not redrawn automatically, so you
should do it manually with the *plot* button. Similarly, if the input
file is a FEA_SPEC file whose "freq_format" is SPFMT_ARB_FIXED, and the
frequencies defined in the header are nonuniformly spaced, you should
redraw the plot after switching the *y-*axis labeling between *item
number* and *frequency.*

Selecting the item *enable waves cursors* causes the program to attempt
to connect to an *xwaves+* in server mode. See the section about the
**-w** option.

The item *disable waves cursor* turns off this mode.

The *box* button draws or removes the bounding box of the plot.

The *clear* button clears the plot window.

The *points* button plots individual data points without connecting
lines or hidden-line removal.

The *help* button brings up a window containing the *plot3d* manual
entry.

The *quit* button terminates the program.

The *file* button has an associated menu with items for interactively
reading new data, reading new parameters, or writing out the current
parameters. Clicking on this panel button with the left mouse button
activates the first menu item, *load data.* Clicking with the right
mouse button brings up the menu and lets any item be selected.

The *load data* menu item brings up a panel for reading data from a new
file or reading a different part of the data in the same file. The panel
has various text fields that you can type into and a *load* button for
reading the data after the text fields are filled in to your
satisfaction. The *directory* field may be left blank. If it contains a
directory, the program supplies a terminating "/" and prefixes the
result to the *file* field to get the pathname of the file to be read.
The text field labeled *field* should contain a FEA file field name
defined in the header of the file to be read. The pair of fields after
*-r* determine the range of records to be read. Either of the forms
*first***:***last* and *first***:+***incr* allowed with the **-r**
command-line option may be used. Leaving the fields blank gets the
defaults. The same holds for the pair of fields between brackets after
the field name, which determine the range of field elements to be read.

The *load params* menu item brings up a panel for redefining parameter
values by reading a file. To use it, fill in the text fields to specify
a file that has the format of an ESPS parameter file (see *read_params
(3-ESPSu));* then click on the *load* button.

The *save params* menu item brings up a panel for saving the current
parameter values to a specified file in ESPS parameter-file format. If
the specified file already exists, it is overwritten.

Moving the mouse cursor into the base rectangle of the plot box in the
plot window brings up a set of cursors with which you can use the mouse
to select values of the independent variables (*e.g.* time and
frequency) and see these values together with the corresponding data
value in digital readouts at the top of the plot window. Moving the
mouse anywhere in the plot window with a mouse button depressed gives
you alternative ways of doing things you could accomplish with the
controls in the control panel. With the left button down, horizontal and
vertical mouse movements control the horizontal skew parameters. With
the middle button down, horizontal and vertical mouse movements control
bearing and elevation. Pressing the right mouse button brings up a menu
with items that duplicate some of the panel-button functions: *plot,
axes, box, print setup, print graphic,* and *clear.*

# ESPS COMMON

The ESPS common file is not accessed.

# ESPS HEADERS

# SEE ALSO

FEA_SPEC(5-ESPS), FEA(5-ESPS), ESPS(5-ESPS),\
read_params(3-ESPS), range_switch(3-ESPS), plotspec(1-ESPS),\
image(1-ESPS), send_xwaves(3-ESPS)

# DIAGNOSTICS

Many error conditions will print diagnostic messages to *stdout.* Some
errors in the use of the *load data, load params,* and *save params*
panels cause error messages in red to appear in the panels.

# BUGS

There are positions for the plot for which transformations used in the
hidden-line-elimination algorithm become singular, with disastrous
results for the appearance of the plot. This can occur, for example, if
you are viewing planes of the plot directly edge-on. Usually, slightly
perturbing the position of the box or moving the *depth* control a
little away from 0 will clear up the problem. If you view the plot from
a position such that some planes of the plot are seen from the front and
some from the back, you may notice a break in the edge between the two
parts of the plot. The axes and the box can interfere: a line segment of
one superposed on a segment of the other yields a segment of a third
color that may be invisible, or nearly so, against the background. The
cursors in the base plane may get out of coordination with the actual
mouse position. Toggling the axes on and off will get them back in step.

# FUTURE CHANGES

Fix the bugs noted above. Allow adding straight lines connecting the
edges of the plot to the edges of the base rectangle. Show underside of
the plot. Allow plotting "longitudinal" traces (connecting points in
different records, but with the same element number) instead of, or in
addition to the present "lateral" traces (connecting points in the same
record, but with different element numbers). Allow selecting slices with
the mouse for plotting in a separate window. Parameters and command-line
options for controlling the axis limits (now determined automatically
from the data). Control over box dimensions by mouse movements in the
plot window. Better rendering of axes. "Footprint" (color base rectangle
differently from background). Decent-looking axis titles. Other choices
for axis labeling (e.g. specified header item or scalar field). Allow
specifying input record and element ranges in "engineering units."
Intuitive interface for controlling all three rotational degrees of
freedom with mouse movements in the plane. Control over the color
scheme.

# AUTHOR

Rodney Johnson.
