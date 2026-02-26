# NAME

xwaves - an interactive display program for X

# SYNOPSIS

**xwaves** \[ **-c** \] \[ **-n** *alternative_name* \] \[ **-p**
*socket_port* \] \[ **-s** \] \[ **-w** *wave_pro* \] \[ **-x**
*debug_level* \] \[ *infile1 infile2 ...* \]

# DESCRIPTION

This manual entry briefly describes *xwaves,* the central component of
the speech analysis package *waves+,* but does not pretend to be a
complete *xwaves* manual. For full details you will need to follow the
references to the complete documentation in *waves+ Manual* and *waves+
Reference*. See *Introducing waves+* for a hands-on tutorial
introduction.

## Introduction

*xwaves* is an interactive program for display and manipulation of
time-series data. It lets you, among other things, browse through
lengthy signals, zoom in on selected portions to examine features in
detail, cut and paste segments of the signal, do interactive spectral
analysis and signal annotation, play back signals, compute and display
speech formant frequencies and pitch contours, and perform other editing
and display operations. Operations can be selected from menus with the
mouse, activated by single keystrokes at the keyboard, or invoked
through commands in an interpreted language. Commands can be entered
manually via the control panel, supplied in command files, or sent to
*xwaves* from other programs. Besides its many built-in capabilities,
*xwaves* provides several modes for customization and functional
extension. It implements most of its signal-processing functions by
calling ESPS or other programs running somewhere on the local network.
The graphical interface is based on the X Window System. *xwaves*
displays can be generated and controlled by another UNIX process, and
*xwaves* can be used as an interface to control another UNIX process.

*xwaves* is executed like any other UNIX process, and input files can be
specified on the command line. However, there are many other ways of
specifying input files, and output file names are never specified on the
command line. The files, if any, specified on the command line are
interpreted either as data to be displayed or as commands to be
executed, depending on the file contents. If the first non-comment line
(not starting with \#) in the file is a line beginning with "waves", the
file is interpreted as a command file. Up to 50 files can be specified
on the command line.

## The main control panel

The basic interface to *xwaves* is its *main control panel.* This
contains text input items that specify data file names, commands, and
command-file names, and it contains buttons that access on-line help and
control program flow in various ways. By default, the control panel
appears in the upper left corner of the screen when startup is complete.
The value of a text item can be modified by activating it with the left
mouse button and then typing in or editing text. The new value does not
take effect until *entered* by hitting the RETURN key (while the item is
active). The panel buttons perform their functions immediately when
selected with the left mouse button. The names of the panel items and
brief explanations follow. For more complete explanations, see "The
*xwaves* main control panel" in *waves+ Manual*.

**INPUT file:**  
The relative or absolute pathname of a signal to be displayed. To read
in and display a new signal, enter the file name here.

**OUTPUT file:**  
Specifies the names of output files to be created by the **save segment
in file** and **insert file** functions (see "Data window menu items" in
*waves+ Manual*). An extension appropriate to the data type is
automatically appended. A purely alphabetic name is used without
modification (except for the appended extension). A name whose basename
ends in a number increments the number after the output waveform segment
is stored. A name preceded with "@" specifies a text file containing a
list of output filenames. If **OUTPUT file:** is blank, the filename of
the source signal is modified by insertion of a "." followed by a number
chosen to maintain uniqueness. A list of files generated during the
current run can be browsed by clicking on the **OUTPUT file:** item with
the right mouse button.

**OBJECT name:**  
The name by which to refer to an *object* or *display ensemble*: a set
of data display windows that are treated as a unit for certain purposes.
The time cursors and markers of all display windows in an object are
synchronized. If a new object name is specified, subsequently generated
data display windows become part of a logically distinct and independent
object.

**COMMAND (or @file):**  
A direct command in the *xwaves* command language or the pathname of a
text file (preceded by the character "@") containing commands to be
executed.

**PAUSE**  
Clicking on this button with the mouse while commands are being executed
from a command file causes the command file to suspend execution. The
**PAUSE** button has no effect on commands coming from processes via the
*send_xwaves*(1-ESPS) program or the *SendXwaves*(3-ESPS) library
functions.

**CONTINUE**  
Clicking on this button causes *xwaves* to resume processing of a
command file that was suspended by a *pause* or *sleep* command or by
clicking on the **PAUSE** button. If the global variable *command_step*
is non-zero, **CONTINUE** causes *xwaves* to execute only the next
pending command and then pause again, allowing the user to single-step
through a sequence of commands.

**Attach:**  
This collection of buttons provides a selection of auxiliary programs
(*attachments*---see "The attachments" in *waves+ Manual*) that can each
be activated by pressing the corresponding button or deactivated by
pressing the button again.

**Overlay name:**  
The relative or absolute name of any ESPS *FEA* file. Each element of
each field in the file is overlaid as a separate track labeled with the
field name and (if non-scalar) indices. By default the overlay is placed
on the most recently created spectrogram display window, if any, and
otherwise simply on the most recently created display window. You can
override the default by following the overlaying file's name with the
filename (separated by whitespace) of the window on which to place the
overlay.

**QUIT!**  
Clicking on this item causes all modified or newly created signals to be
saved and *xwaves* to exit.

**waves MANUAL**  
This pops up a copy of *waves+ Reference* in a searchable text window.

When a wildcard construct (e.g. "\*") is entered in **INPUT file:** or
**Overlay:**, a window appears to the right of the main control panel
containing a scrollable list of files matching the construct. A
directory path generates a list of all files in the directory. If
signals have been generated and saved in files, they are entered in a
list that can be viewed by clicking on **OUTPUT file:** with the right
mouse button. A file can be selected as input to the panel item with the
left mouse button. The right button displays a menu of operations on the
files. See "The file browsers" in *waves+ Manual* for a list of the
operations with explanations.

## The miscellaneous controls panel

When you start *xwaves,* another panel normally appears to the right of
the main control panel: **Miscellaneous xwaves Controls**. This normally
contains the 12 buttons listed below. However, the panel is fully
customizable; it is just another panel created with the *xwaves* command
*make_panel* (see in *waves+ Reference*), and you can change its
functionality by editing the relevant files (see "The init_file" under
"Changing the *xwaves* environment" in *waves+ Manual*, "The *waves+*
directory structure" in *waves+ Manual*, and the discussions of the
individual buttons under "The miscellaneous controls panel" in *waves+
Manual*).

**Add_op...**  
Clicking on this button with the left mouse button pops up a new panel
that lets you interactively specify new functions to be added to your
menu lists. For a full description of the functionality of the window
see the description of the *xwaves* command *add_op_panel* in the
chapter of *waves+ Reference*.

**Image Painting**  
This button allows control of the appearance of spectrogram displays and
their behavior when their windows are resized.

**Audio extensions...**  
Clicking with the left mouse button pops up a panel with a help file and
menus that you will need only if you purchased ETSM (an optional waves+
add-on product for time scale modified playback) or if you are using a
third party DSP board (Ariel DSP 32C, LSI C30, or Townshend DATLink) for
playback and/or recording. The play and record program menus are using
for controlling playback and recording sound with the 3rd party DSP
boards as listed above. The play menus lets you select the play program
(*play_prog*---see "Using audio" in *waves+ Manual*) used by *xwaves* to
play audio files. If you are using native hardware for playback and
recording, you will not need to use these menus.

**waves+ profile...**  
Clicking with the left mouse button pops up a panel that lets you
examine and change command configurations and the profile file
*.wave_pro.*

**Print setup...**  
Clicking with the left mouse button pops up a panel that let you set the
*xwaves* global variables that control printing. See "Printing graphics"
in *waves+ Manual* and in *waves+ Reference* for more information on
printing and the individual variables.

**Annotation...**  
Clicking with the left mouse button pops up a panel that gives you
detailed control over whether the following annotations on the data
windows are displayed: ESPS field names, field values at the cursor
position, and axis tick marks or grids.

**Ganging...**  
Clicking with the left mouse button pops up a panel that lets you
control which of the following operations are performed simultaneously
on all windows of an object and which affect only one window at a time:
scrolling, zooming, and deletion of segments.

**Colormap...**  
Clicking with the left mouse button pops up a panel that lets you change
the colors in which waveforms and spectrograms are displayed.

**Toolbars...**  
Clicking with the left mouse button pops up a panel that lets you add
*toolbar creators* to the waveform and spectrogram menus. This means
that an entry in the display menu lets you create a toolbar with
functions that apply to a specific display. Several ready-to-use
toolbars are available, and it is easy to create more yourself. See the
help file available through the **Toolbars...** panel, and see the
**Toolbars...** entry under "The miscellaneous controls panel" in
*waves+ Manual*.

**Menu Changes...**  
Clicking with the left mouse button pops up a panel that lets you change
the waveform and spectrogram display menus by adding items or selecting
predefined alternative menus. A help function is also provided.

**Mouse bindings...**  
Clicking with the left mouse button pops up a panel that lets you select
the functions performed by the left and middle mouse buttons in waveform
and spectrogram windows. See also "Mouse button modes" in *waves+
Manual*.

**Debug...**  
Clicking with the left mouse button pops up a panel that lets you set
*xwaves* global variables that control the verbosity of information and
debugging messages and turn on single-stepping mode for command-file
interpretation. See in *waves+ Reference*.

## Data display windows

There are two major types of signal data display windows: *waveform*
windows and *spectrogram* windows. Waveform windows display plots of
single or multiple sampled-data and parameter tracks. Spectrogram
windows display data as intensities or colors in the time-frequency
plane. Each window has a frame that includes a title bar. If the right
mouse button is pressed while the cursor is in the frame, the window
system frame menu appears. The contents of this frame menu depend on the
window manager, but common items allow the window to be iconized
removed, resized, etc.

Inside the frame are three regions: a data display that fills most of
the window, a scrollbar region just above it, and an information region
just above the scrollbar. As the cursor moves in the data region, the
corresponding time values are continually updated in the information
region, and data values are updated either there or in the data region.
Cursors in other windows of the same object (see **OBJECT name:** under
"The main control panel" above) move in synchrony.

Pressing the right mouse button while the cursor is in the data display
region calls up a menu listing data- and display-manipulation options.
The left and middle mouse buttons have several programmable functions,
such as moving markers, playing segments, modifying data, or any of the
right-button menu items. Menu operations and *xwaves* commands permit
changing the button semantics. The functions currently in effect are
displayed in the frame title bar. There are four distinguished markers,
two horizontal and two vertical, that can be positioned with the mouse
pointer if an appropriate mouse-button function is enabled. To move the
horizontal markers, hold down the shift key on the keyboard while
operating the mouse; otherwise the vertical markers are moved. See
"Mouse button modes" in *waves+ Manual* for more information.

Mouse buttons pressed while in the scrollbar region cause the following
operations: *left* moves the displayed point marked by the mouse pointer
to the left window edge; *right* moves the displayed point at the left
window edge to the position of the mouse pointer; *middle* centers the
display window over the point in the data file proportional to the
distance along the scrollbar at which the button was pressed. When the
mouse pointer is in the scrollbar, the time readout changes to reflect
not the time in the displayed portion of the file, but the time in the
whole file, with the beginning corresponding to the left end of the
scrollbar and the end of the file corresponding to the right end. The
shaded portion of the scrollbar corresponds to the portion of the data
file that is currently visible in the window.

In spectrogram windows the operations that can be bound to the left or
middle mouse button include three that are inapplicable to waveform
windows: **mark formants**, **move contour**, and **modify intensity**.
The latter is the default action of the middle button; it lets you
modify the threshold and dynamic-range values that control the mapping
from spectral density to display intensity or color; think of it as
analogous to manipulating the brightness and contrast controls of a
television set. For the other mouse button functions, see "Mouse button
modes" in *waves+ Manual*.

In a spectrogram window, data can be displayed at the "natural scale" of
one point per pixel, or it can be rescaled vertically or horizontally to
accommodate changes in the height and width of the window. Scaling
behavior is controlled by four global variables that can be set by an
*xwaves* command or with the help of the **Image Painting** item of the
miscellaneous controls panel. See the description of the panel item
above, and see "Scaling, interpolation, and zooming" under "Data display
windows" in *waves+ Manual*.

To determine the colors used for plotting waveforms and spectrograms and
for drawing cursors, markers, axes, etc., *xwaves* reads a colormap
file, whose name is given by the global variable *colormap.* This can be
initialized in the *.wave_pro* file and changed at any time by an
*xwaves* command. The **Colormap...** button, mentioned above under "The
miscellaneous controls panel", works by setting the variable to the name
of one of several predefined colormap files. See "Colormaps" in *waves+
Manual* to find out how to create your own colormap files.

## Data window menu items

Using *xwaves* commands, you can customize the contents of the menus
that pop up when you press the right mouse button in the data region of
an *xwaves* display window. You can do this separately for the waveform
and spectrogram menus. There are commands for deleting and restoring
menu items. With the *add_op* command, you can define new menu items
that invoke arbitrary UNIX shell commands or *xwaves* commands. For full
information, see "Data window menu items" in *waves+ Manual* and the
commands *delete_item,* *delete_all_items,* *add_op,* *add_waves,* and
*op* under in *waves+ Reference*. In addition there are a number of
"built-in" menu operations that are present by default unless explicitly
removed. See "Data window menu items" in *waves+ Manual* for more
information on the individual items.

**play between marks**, **play window contents**, **play entire file**,
and **play to end of file** let you listen to various portions of a
signal by sending them to a D/A converter. **page ahead**, **page
back**, **window ahead**, and **window back** move the view in the
display window forward or backward through the file. **align and
rescale** rescales and repositions windows so that all other windows in
an object align vertically with the selected window. **bracket
markers**, **zoom in**, **zoom out**, and **zoom full out** expand or
contract the time scale of the window, as suggested by the names.
**spectrogram (W.B.)** and **spectrogram (N.B.)** create spectrograms of
the portion of a signal delimited by the markers. **save segment in
file** writes an output file containing the segment of the signal
delimited by the markers. **delete segment** and **insert file** let you
edit a signal by cutting and pasting. **Button Modes** lets you
determine which functions are invoked by the left and middle mouse
buttons. **kill window** removes the display window. (This is needed on
systems where a window cannot be removed by using the window-manager
frame menu.) **print graphic** and **print ensemble** output one or more
display windows for printing.

## Printing graphics

There are two built-in *xwaves* menu operations for producing printable
output: **print graphic** and **print ensemble**. (There are also
ordinary *xwaves* commands that perform the same functions.) **print
graphic** renders a single display window in either Encapsulated
PostScript or PCL (HP Laserjet code). **print ensemble** renders all
display windows in an object in Encapsulated PostScript (only). The
relative positions of the windows on the screen are preserved in the
printed output. Some attachments (see "Attachments" below) can cooperate
with *xwaves* to let **print ensemble** include windows created by the
attachment in the output along with those created by *xwaves* itself.

There are several *xwaves* global variables that control various aspects
of the printing, such as whether the output goes to a file or directly
to a printer. See "Printing graphics" in *waves+ Manual* for a list of
the variables with explanations. The **Print setup...** button,
mentioned under "The miscellaneous controls panel" above, lets you set
these variables.

## The command language

The *xwaves* command language provides control over essentially the
entire domain of actions available to *xwaves* and its attachments. The
commands of this language subsume all the functions available through
the mouse-oriented interface, and they provide a means for extending the
command set and enhancing the interface. *xwaves* lets you assign values
to symbols (variables) with the *set* command. It also has a large set
of built-in symbols that affect its behavior in various ways (e.g. the
colormap filename) or reflect various aspects of its state (e.g. the
cursor position). These variables can be incorporated in commands you
add yourself. For a full description of the syntax and use of *xwaves*
commands, see "The *waves+* command language" in *waves+ Manual*. For
descriptions of the individual symbols and commands, see and in *waves+
Reference*.

*xwaves* distinguishes between *object commands,* which are directed to
a particular object (display ensemble), and *global commands,* which are
simply directed to *xwaves* itself. The syntax of simple *xwaves*
commands is

> object  command  keyword  value  keyword  value ...

where *object* is the name of the object to which the command is
directed, and *command* is the name of the command to be executed. There
may be any number of keyword-value pairs, including zero. For a global
command, *object* is "waves" or is simply omitted.

For example, the simplest form of the command that creates a waveform
display might look like

> waves make file speech.sd

or simply

> make file speech.sd

since *make* is a global command. The keyword *file* indicates that the
following argument, *speech.sd,* is the name of the data file to be read
and displayed. The command *make* has many other optional keywords that
permit control of various window attributes, such as size, etc. The
documentation for each command in *waves+ Reference* lists the keywords
recognized by the command and explains the meaning of each.

For the command *set,* any variable name can be used as a keyword, and
the following value is assigned to the variable. For example

> set colormap my_colormap

assigns the value *my_colormap* to the variable *colormap.*

The command *add_op* lets you define new operations. For example

> add_op name my_op op "doit.sh _l_marker_time _r_marker_time"

defines a new operation *my_op* that runs a shell script *doit.sh.* The
keyword *name* identifies the following argument, "my_op", as the name
of the operation; new items containing the name "my_op" are added to the
display window menus and will invoke the new operation when selected.
The keyword *op* indicates that the following string "doit.sh
\_l_marker_time \_r_marker_time" is the definition of the new operation.
In the definition, *l_marker_time* and *r_marker_time* are examples of
variables whose values are to be substituted in the string. They are
identified as such by the underscores ("\_") that precede them.
*l_marker_time* and *r_marker_time* are built-in *xwaves* symbols that
contain the times (in seconds) corresponding to the left and right
marker positions (see in *waves+ Reference*). Thus, whenever the new
operation is invoked, the values of the variables at that time are
substituted in the definition string. Suppose the values are 0.25 and
0.35. Then

> doit.sh 0.250000 0.350000

is executed as a shell command, running the script *doit.sh* with
arguments that give the marker times.

There are several ways to convey commands to *xwaves.*

\(1\) The main control panel.  
Just type the command in the field **COMMAND (or @file):**.

\(2\) Command files.  
You can store a number of commands in a file, and they can then be
executed from *xwaves.* You can enter the file preceded by "@" in the
field **COMMAND (or @file):** or, if the first line starts with the word
"waves", enter it on the command line when starting *xwaves.* A command
file that is always executed when *xwaves* is started is the file
indicated by the *init_file* entry in the *.wave_pro* file. See below.

\(3\) The program *send_xwaves*.  
*send_xwaves*(1-ESPS) is a program that takes an *xwaves* command string
as a parameter and sends the command to *xwaves.* The program can easily
be used to control *xwaves* from a UNIX shell script.

\(4\) C library functions.  
If you have the ESPS function library, you can write application
programs in C, using the functions *SendXwavesNoReply*(3-ESPS) and
*SendXwavesReply*(3-ESPS) to send commands to *xwaves.*

\(5\) Auxiliary panels.  
The command *make_panel* lets you build X window panels from which you
can issue commands by pushing buttons or selecting from menus. See the
command description under in *waves+ Reference*.

\(6\) Display window menus.  
As described above, you can associate *xwaves* commands with
display-window menu items by using the command *add_op.*

\(7\) Keyboard bindings.  
With the command *key_map* you can bind an operation to a character on
the keyboard to be executed when the key is pressed. See the command
description under in *waves+ Reference*.

There is much more to be said about using *add_op* and about *xwaves*
commands in general. See "The *waves+* command language" in *waves+
Manual*.

## xwaves initialization

Initial values for *xwaves* global variables and other symbols can be
assigned in a profile file that is read when *xwaves* starts. By default
this is a file named *.wave_pro* found in the user's home directory or,
if not there, in the directory *\$ESPS_BASE/lib/waves.* (However, see
**-w** under OPTIONS below.) See the *.wave_pro* in the latter directory
for a fully commented example of a complete *xwaves* profile. The file
contains lines of the form

> name value

where *value* is a value to be assigned to the symbol *name.* For
example, you could specify a non-default colormap at startup by
including a line:

> colormap MyColormap

The variables that have special meaning for *xwaves* are listed with
explanations under in *waves+ Reference*. Some variables have meaning to
*xwaves* attachments (see "Attachments" below) which get the values by
communicating with *xwaves.* You can assign values to other variables
for any convenient purpose---e.g. for use in *add_op* commands.

One important global variable is *init_file.* This is the name of an
*xwaves* command file that is executed after the *.wave_pro* has been
read; it allows more elaborate startup processing than is possible
through simple assignments of values to variables. See
*\$ESPS_BASE/lib/waves/commands/xw_init.WC* for a default *init_file.*
It is through the *init_file* that the contents of the **Miscellaneous
xwaves Controls** panel is created. By specifying a different (modified)
*init_file* in the *.wave_pro,* you can customize the panel contents,
change the contents of the display-window menus, and otherwise modify
the initial configuration of *xwaves.* See and "Changing the menu files"
under "Changing the *xwaves* environment" in *waves+ Manual* for details
and an example.

## UNIX environment variables

There are numerous UNIX environment variables that affect the operation
of ESPS programs and *xwaves.* For a list see *espsenv*(1-ESPS). Those
that are important for *xwaves* are described in "The UNIX environment
variables" in *waves+ Manual*. Only two are mandatory. ELM_HOST must be
set to the host name of the machine on your network that is running the
Entropic license manager daemon. ESPS_BASE must be set to the top of the
ESPS/*waves*+ installation directory tree. In order to have easy access
to the programs that are likely to be used in conjunction with *xwaves,*
be sure that *\$ESPS_BASE/bin* is in your UNIX PATH definition before
running *xwaves.*

## File formats

*xwaves* supports the use of different data file formats. The most
natural way is to use ESPS *FEA* files. *xwaves* is tuned to these files
and can handle them very easily. When *FEA* files are used, they can be
either in machine native format or EDR format, which makes it easy to
port signals between different systems. See "File formats and *xwaves"*
in *waves+ Manual* for details. On the other hand there are various ways
to read non-*FEA* files with *xwaves.* Like most ESPS programs, *xwaves*
will directly read sampled-data files in the NIST *Sphere* format and
many files in the new Entropic *Esignal* format. If *xwaves* does not
recognize a file, it assumes it is headerless. If the UNIX environment
variable DEF_HEADER is defined and points to a file with a valid *FEA*
header, that header is used as a "virtual" header for the headerless
file. Thus, the data description in the file defined by DEF_HEADER
should be valid for the input data. The ESPS conversion programs
*btosps*(1-ESPS), *testsd*(1-ESPS), and *addfeahd*(1-ESPS) are useful in
creating such headers. The *xwaves* global variable *def_header* can be
used instead of the environment variable and can be changed while
*xwaves* is running. Files that are headerless from the ESPS and
*xwaves* viewpoint may in fact contain "foreign" headers. If a *FEA*
header contains certain "generic header items", a foreign header (i.e. a
block of information at the head of the file) is skipped when reading
data. (A copy is kept inside the *FEA* header, however, so that the
foreign header can subsequently be exposed again.) See
*read_header*(3-ESPS) for more details and for information about setting
the relevant generics in the headers specified by DEF_HEADER or
*def_header.*

## UNIX, ESPS, and xwaves

The discussion of the command *add_op* under "The command language"
above showed a simple example of executing a UNIX shell command from
within *xwaves.* See the discussion of *add_op* under "Global *xwaves*
Commands" in *waves+ Manual* for more information and examples. In
general, the mechanism can start a unix process to run an external
program (while *xwaves* goes on its merry way). If output is to be
displayed, *xwaves* is signaled when the forked process terminates.

In addition to *add_op,* there are more special facilities for calling
ESPS programs from *xwaves.*

When built-in *xwaves* support for a DSP board is not used, external
programs are used to generate spectrograms. In particular the program or
command indicated by the global variable *sgram_prog* is invoked with
appropriate command-line options. The default value is "sgram", which
calls the program *sgram*(1-ESPS), but *me_sgram*(1-ESPS) can be used
instead, or any program or script that supports the right command-line
options. See "ESPS spectrogram computation" under "UNIX, ESPS, and
*xwaves"* in *waves+ Manual* for details.

Support for the built-in audio of most workstation on which *xwaves*
runs is built into *xwaves* and is used by default for audio output.
However, you can specify other means of output by setting the *xwaves*
global variable *play_prog* to a program or command that supports
appropriate command-line options. See "Using audio" in *waves+ Manual*
for details.

## Attachments

Attachments are programs that run as separate UNIX processes, but in
close cooperation with *xwaves.* In fact they will not do anything
useful unless *xwaves* is running. In general, attachments are used for
tasks that require a specific user interface that cannot be realized
with *xwaves* alone. These tasks require transfer of information between
*xwaves* and the attachment. Attachments communicate with *xwaves*
through the X server, using a communications protocol that is compatible
with Tcl/Tk.

At the moment there are four standard *xwaves* attachments:
*xlabel*(1-ESPS), *xspectrum*(1-ESPS), *xmarks*(1-ESPS), and
*xchart*(1-ESPS). These are described in corresponding chapters of
*waves+ Manual* ( and *waves+ Reference* ( etc.).

An attachment is normally started with the *xwaves* command *attach* or
by clicking on a button in the **Attach:** field in the *xwaves* main
control panel. It can also be started from the command line, but then
you may have to worry about the command line options. The attachments
are stopped when *xwaves* stops.

The attachments have their own command languages, which resemble that of
*xwaves.* The individual commands are described in the "... reference"
chapters of *waves+ Reference*.

The attachments do not have their own command-entry facilities. Instead,
commands are sent to attachments via the *xwaves* command *send.* This
can be issued in any of the usual ways, including *send_xwaves*(1-ESPS).
Thus attachments can be controlled from UNIX shell scripts. For examples
of the use of *send,* see "Using the program *send_xwaves"* and
"Attachments and the command language" under "The *waves+* command
language" and the chapters on the individual attachments in *waves+
Manual*.

The attachment *xlabel*(1-ESPS) is a general-purpose signal segmentation
and labeling program. It can be used to view multiple label/segmentation
files simultaneously. Labels can be selected from a user-configurable
menu or typed in directly from the keyboard. They are displayed in a
window containing markers with attached labels in time alignment with a
signal in an *xwaves* signal display window. *xlabel* is especially
useful for comparing and generating multiple segmentations of the same
signal when the label sequence is not known in advance.

*xspectrum*(1-ESPS) facilitates interactive power-spectrum analysis of
data that is displayed in *xwaves* windows. Individual spectra displayed
by *xspectrum* can be compared by overlaying them on a common plot. The
spectrum analysis method and parameters can be varied by entering values
in the *xspectrum* control panel. If a linear-prediction
(maximum-entropy) spectrum-analysis method is used, *xspectrum* also
supports inverse filtering of the selected data and formant/bandwidth
estimation. *xspectrum* will also display "spectral slices"
(single-frame power spectra) from data in *xwaves* spectrogram windows.

*xmarks*(1-ESPS) is specialized for assigning times in waveforms to
pre-defined label sequences. It is specifically designed for labeling
speech in that it supports labeling of sentence-like structures. Labels
are supplied in a specific format in a file created before the
attachment is run. *xmarks* lets you quickly place labels by clicking a
mouse button in the signal window. *xmarks* automatically selects the
next label to be placed.

*xchart*(1-ESPS) is an extension of *xlabel* that offers all the
features of *xlabel* and provides an additional display mode. *xchart*
was designed to manipulate displays of "charts". A chart is a collection
of possibly overlapping signal-segment labels---for example, word
hypotheses from a speech recognizer's "front end". Each segment label is
associated with a character string called a *symbol.* *xchart* displays
these symbols in a window below an *xwaves* signal display, possibly
along with label files of the type described in the chapter on *xlabel.*

# OPTIONS

The command-line options recognized by *xwaves* are the following.

**-c**  
Specifies that *xwaves* creates its colormap segment as STATIC, making
it sharable with other applications on the same X server. Since *xwaves*
uses a rather large colormap, there may be interference if another
application on the same X server (such as another copy of *xwaves*) also
tries to allocate a large colormap. If you must run more than *xwaves*
on the same server, and you have colormap problems (flashing as you move
the mouse or incorrect colors), start each *xwaves* with the **-c**
option and have them all load the same colormap via the *.wave_pro* file
(see "Changing the *xwaves* environment" in *waves+ Manual*). They will
then share the colormap segment.

A side effect of this option is that the colormap cannot be changed
after the initial one is loaded. In addition, interactive alteration of
the color threshold and contour marking via the mouse in spectrogram
views do not work with STATIC colormaps.

**-n** *alternative_name*  
*xwaves* has an interprocess communication capability, which programs
such as *send_xwaves*(1-ESPS) can use to send commands to *xwaves* and
get results in reply. The communication method is based on communicating
through the X server and is compatible with Tcl/Tk (version 4). When
*xwaves* starts, it registers itself with the server that it is using
for display. By default, it registers under the name "xwaves", but a
different name can be specified by means of this option. This might be
done if, for example, it were necessary to run two *xwaves* processes at
once on the same X display.

**-p** *socket_port*  
Specifies the INET domain socket port number to listen on when in
"server mode" (as a result of the **-s** option or the *enable_server*
command). See the comment under **-s** concerning the phaseout of this
server mode.

If this option is not used, and if the UNIX environment variable
WAVES_PORT is defined, the port is set to the value of WAVES_PORT. If
WAVES_PORT is not defined, a compiled-in default is used. The port
number can be changed at any time through an *xwaves* command by setting
the *xwaves* global variable *socket_port* (see the chapter in *waves+
Reference*); the change takes effect the next time the *enable_server*
command is executed.

**-s**  
Specifies that *xwaves* starts up in "server mode". This is equivalent
to executing the *xwaves* command *enable_server.* When in server mode,
*xwaves* listens on a socket for commands sent by external scripts or
programs that use the *send_xwaves*(3-ESPS) library functions. In
pre-5.0 versions of *xwaves* it was necessary to be in the server mode
for the *send_xwaves*(1-ESPS) program to function. This is no longer
true, since *send_xwaves*(1-ESPS) now uses a different communication
protocol. In the current release this server mode is not needed by any
Entropic-supplied programs and is provided only for compatibility with
old user-written programs. For new programs, use the library functions
*SendXwavesNoReply*(3-ESPS) and *SendXwavesReply*(3-ESPS).

**-w** *wave_pro*  
Specifies the startup profile to read. If this option is not used,
*xwaves* attempts to read the file *.wave_pro* along the search path
*\$HOME:\$ESPS_BASE/lib/waves.* That is, it first looks for a file
*.wave_pro* in the user's home directory and then for
*\$ESPS_BASE/lib/waves/.wave_pro.* The search path used can be
overridden by setting the UNIX environment variable WAVES_PROFILE_PATH
before starting *xwaves.* The same search path is used for names
supplied with the **-w** option.

**-x** *debug_level*  
If the argument is positive, *xwaves* prints debugging messages on the
standard error output. The number of messages increases with increasing
values of *debug_level.* No messages are printed for a *debug_level*
of 0. The value can be changed at any time through an *xwaves* command
by setting the *xwaves* global variable *debug_level* (see the chapter
in *waves+ Reference*).

# SEE ALSO

*waves+ Manual*, *waves+ Reference*, *Introducing waves+*,\
*addfeahd*(1-ESPS), *btosps*(1-ESPS), *espsenv*(1-ESPS),\
*me_sgram*(1-ESPS), *send_xwaves*(1-ESPS), *sgram*(1-ESPS),\
*testsd*(1-ESPS), *xchart*(1-ESPS). *xlabel*(1-ESPS),\
*xmarks*(1-ESPS), *xspectrum*(1-ESPS),\
*SendXwavesNoReply*(3-ESPS), *SendXwavesReply*(3-ESPS),\
*read_header*(3-ESPS), *send_xwaves*(3-ESPS)

# AUTHOR

Original program by David Talkin at AT&T Bell Laboratories. Later
enhancements by Rod Johnson, Alan Parker, John Shore, David Talkin, and
others at Entropic. This manual page largely extracted by Rod Johnson
from *waves+ Manual* and earlier manual pages, all derived ultimately
from Talkin's original documentation with many revsions and additions by
David Burton, Joop Jansen, Rod Johnson, Alan Parker, John Shore, David
Talkin, and others at Entropic.
