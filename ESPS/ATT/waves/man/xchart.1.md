# NAME

xchart - time-series segment lattice display attachment for xwaves

# SYNOPSIS

**xchart** \[ **-c** *host_X_registry* \] \[ **-n** *host_name* \] \[
**-w** *wave_pro* \]

# DESCRIPTION

*xchart* is an *attachment* for the program *xwaves*(1-ESPS): a program
that runs in close cooperation with *xwaves* and provides additional
capabilities. *xchart* is an extension of the attachment
*xlabel*(1-ESPS): it provides all the features of *xlabel* together with
an additional display mode for presenting collections of signal-segment
labels called "charts". This manual entry briefly describes *xchart* but
is not intended to be a complete *xchart* manual. For full details of
the special features of *xchart,* see the chapter in *waves+ Manual* and
the chapters and in *waves+ Reference*. For details of the features that
*xchart* shares with *xlabel* see the chapter in *waves+ Manual* and the
chapters and in *waves+ Reference*. Also see *waves+ Manual* and *waves+
Reference* for information about *xwaves.*

## Introduction

An attachment is a program that extends the capabilities of *xwaves*
while running as a separate UNIX process. Attachments exchange
information with *xwaves* by communicating through the X server, using a
communication protocol that is compatible with Tcl/Tk.

*xchart,* an *xwaves* attachment, is an extended version of the
attachment *xlabel*(1-ESPS) that provides the additional capability of
manipulating displays of *charts.* A chart is a collection of possibly
overlapping signal-segment labels (for example, word hypotheses from a
speech recognizer's "front end"). Each segment label is displayed as
horizontal bar, indicating the extent of the segment, along with an
associated character string called a *symbol.* *xchart* displays these
segment labels in a window that is time-aligned with the corresponding
*xwaves* signal display.

*xchart* builds the chart display from a *chart file* that contains
segment boundary times, symbols, and other information in ASCII form.
Several chart files can be displayed simultaneously in one *xchart*
window, and *xlabel* label files can also be displayed in the same
window.

## Starting xchart

You can start *xchart* in various ways. The commonest way is to click
the **xchart** button in the **Attach:** item of the main control panel.
Another way is to issue the *xwaves* command *attach.*

*xchart* and *xlabel* are actually the same program. One executable
binary program file can be given several names through hard or symbolic
links. If invoked by the name "xchart", the program provides the special
*xchart* features. If invoked by another name (such as "xlabel") the
program makes available only the standard *xlabel* features.

Once you have started *xchart,* a *control panel* appears. This is
similar to the *xlabel* control panel.

A *chart window* appears when a name is entered in the **Object:** item
in the *xchart* control panel, or when an *xwaves* data display is
created or changed. The *object* name should be that of the associated
*xwaves* display ensemble. (The **Object:** item is usually set
automatically by *xwaves*.)

A chart file is displayed in the window after the **Chart File:** item
is filled in with a chart file name or after a *send make* command is
sent from *xwaves.*

All functions normally available in *xwaves* are active in conjunction
with the chart display.

Selecting the **QUIT** button in the *xchart* control panel updates and
closes all label files and disconnects *xchart* from *xwaves.*

## The control panel

The *xchart* control panel is similar to the *xlabel* panel, but with
two more items. The following items have the same functions in *xchart*
as in *xlabel*: **Label File:**, **Object:**, **Active fields:**,
**Label Menu File:**, and **QUIT**. Refer to "The labeler control panel"
in the chapter of *waves+ Manual* for their description. Moreover the
**xchart manual** button is essentially the same as the *xlabel*
**xlabel manual** button except that you get *xchart* documentation
instead of *xlabel* documentation. The other two items are the
following.

**Chart File:**  
Enter the name of an existing chart file in this field to display it in
the chart/label display window. The file must have the format described
in the section "Chart files" below; also see "The chart file" in the
chapter of *waves+ Manual*.

**Top Word:**  
The entered symbol is scrolled to the top of its section of the display
window.

## The chart/label display window

The chart/label display window (*chart window* for short) can display
several chart and label files, separated by horizontal lines. The label
files appear in the top part of the window and are displayed in the same
way as in *xlabel* windows.

A segment label is displayed as a horizontal line with short vertical
strokes at the ends to mark the ends of the segment; the associated
symbol is printed in the middle. *xchart* devotes one line of text
display to each distinct symbol in the chart file. One symbol may be
assigned to any number of segments, but they should not overlap in time.
Segments with different symbols may overlap arbitrarily.

There may be too many symbols for the available vertical space. To deal
with this situation there are two mechanisms for vertically scrolling
the chart. One is under mouse/menu control as described below. The other
is to enter the symbol in the **Top Word:** item in the control panel.
The (circular) list of segments is then scrolled to bring the indicated
symbol to the top.

The chart window tries to stay close to the *xwaves* window to which it
is attached, which is the most recently created window in the object
unless the window was created with an *xchart* *make* command specifying
a different signal. The chart window is automatically resized, rescaled,
and scrolled to maintain alignment with the window to which it is
attached. When you move the mouse in the chart window, the cursors in
all *xwaves* windows of the same object move so as to indicate the same
time as the cursor in the chart window.

Clicking the right mouse button in a chart display can pop up a menu
that lets you select certain operations for execution (see "Chart menus"
below or "The *xchart* menu file" in the chapter of *waves+ Manual*).

## Chart menus

The optional menu used in the chart portion of the chart window is
similar to the regular *xlabel* menus used in the label portion, but is
more limited. The menu is specified in an *xchart* menu file. See "The
*xchart* menu file" in the chapter of *waves+ Manual* for an example.
The first line may contain items *columns* or *rows* and *font* just as
in *xlabel* menu files. (See "Menu file format" in the chapter of
*waves+ Reference*.) The rest of the file contains two items per line.
The left item appears in the menu, while the right item must be one of
the following four operations.

*\*UNLOAD\**  
unloads the chart under the mouse pointer from the display.

*\*UP\**  
scrolls the line under the mouse pointer to the top of the chart
display.

*\*DOWN\**  
scrolls the top line of the chart display down to the mouse pointer
location.

*\*SHELL\**  
takes the left-hand item to be a UNIX command (e.g. the name of a
program or shell script). It executes the command with four arguments:

1)  the name of the chartfile under the mouse pointer.

2)  the symbol corresponding to the line in the chart display under the
    mouse pointer.

3)  the time (in seconds) corresponding to the mouse pointer X position.

4)  the name of a temporary file that *xchart* will try to load (as a
    chartfile) when the program exits. If *xchart* finds this file, it
    loads it immediately, also maintaining the original display;
    otherwise it does nothing further.

Thus the external command might be some operation that simplifies or
otherwise processes a chart, then redisplays the results. Two examples
are given under "Use of the *\*SHELL\** command" in the chapter of
*waves+ Manual*.

The *xchart* menu can be established by assigning a value to the
variable *xchart_chartmenu* in the *.wave_pro* file or with the *xchart*
command *make* or *set* sent via the *xwaves* command *send.* The chart
menu should be specified before loading a chart. See "Invoking the
*xchart* menu" in the chapter of *waves+ Manual* for example commands
and for details of the path used in searching for menu files.

## Chart files

The format of the ASCII chart file resembles that of *xlabel* label
files. It begins with a header, possibly empty, consisting of
keyword-value pairs separated by blanks or tabs. Next comes a line,
always required, starting with a "#" sign. Then come the segment-label
descriptions, one per line. Here is an example.

> signal long_utterance.sd
>     type 1
>     frequency 8000
>     color 124
>     comment created  Fri Jun  6 17:55:46 1997
>     comment ASR-44, version 3.2.1
>     font 6x9
>     #
>     12	0.234	0.456	0.77		foobar
>     12	0.567	1.987	0.97		foobar
>     15	0.267	1.456	0.27		barfoo
>     	.
>     	.
>     	.

If the *type* is 1, segment boundaries in the segment-label lines are
taken to be times in seconds. If *type* is 2, they are interpreted as
sample numbers. If *type* is 2, the sampling frequency should be
specified. If not, 8000 Hz is assumed.

The keyword *frequency* indicates the sampling frequency in Hz, used
when *type* is 2.

The *color* is an integer specifying the colormap table entry to use
when printing the symbols on the chart.

The *font* is the name of the character font used to display the chart
file. If multiple files are displayed, each can have its own font.
Although you can choose the fonts for the data display window, there is
currently no way to change the fonts used in the menus.

See "The chart file" in the chapter of *waves+ Manual* for the semantics
of *signal* and *comment.*

After the "#" line come 5-item lines that describe the segment labels.
Decimal points are optional. The number of digits and the spacing
between item are arbitrary. Columns 1 and 4 are not currently used and
may have any numerical value. Columns 2 and 3 indicate the beginning and
end of the segment. Column 5 is the symbol that labels the segment.
Multiple segment assignments for a given symbol appear on separate
lines, which need not be consecutive. The ordering of symbols in the
chart display is their order of first appearance in the chart file.

## D/A output

If D/A support is available from *xwaves,* an additional D/A playback
feature is supported by *xchart.* Pressing the left mouse button when
the mouse pointer is on a particular segment label plays back the
corresponding segment of a "playable" signal displayed by *xwaves.* The
region played is marked in the *xwaves* waveform window in case you want
to perform additional operations on that segment. If the cursor is
between two segment labels with the same symbol, the interval from the
end of the first to the beginning of the second is played (and marked).
To the left of the first segment label on a line, you get the interval
from the beginning of the file to the beginning of the segment. To the
right of the last segment label on a line, you get the interval from the
end of the segment to the end of the file.

## Graphics export

All the *xlabel* graphics output features are available in *xchart.*

## xchart symbols

The *xchart* symbol set is an extension of the *xlabel* symbol set. See
in the chapter of *waves+ Reference* for the individual *xlabel* symbols
and in the chapter of *waves+ Reference* for the *xchart* extensions.

## xchart commands

The *xchart* command set is an extension of the *xlabel* command set.
See in the chapter of *waves+ Reference* for the individual *xlabel*
commands and in the chapter of *waves+ Reference* for the *xchart*
extensions. in the chapter of *waves+ Manual* contains an example that
shows how to use the program *send_xwaves*(1-ESPS) and the *xwaves*
command *send* to control *xchart* from a UNIX shell script.

# OPTIONS

*xchart* is usually started as a subordinate program by *xwaves.* In
this case, you need not be concerned with the command-line options
presented below, and you may skip this section. However, it is also
possible to run *xchart* (and the other attachments) as sibling UNIX
processes, in which case it may be necessary to specify one or more of
the following options. These are identical to the options for
*xlabel*(1-ESPS).

**-c** *host_X_registry*  
This is the name that the host program is registered under for X
server-based communications. This option is intended to be supplied by
*xwaves* when it runs *xchart.*

**-n** *host_name*  
This is the name of the program object with which *xchart* will be
communicating. When the host program is *xwaves,* this name is always
the default value, "waves".

**-w** *wave_pro*  
Specifies the startup profile to read. This option is always used when
*xchart* is invoked by *xwaves,* in which case the specified profile is
a temporary file written by *xwaves* and containing the current state of
the *xwaves* globals. If **-w** is not used (only possible if *xchart*
is run from the shell), *xchart* attempts to read the file *.wave_pro.*
In both cases the search path *\$HOME:\$ESPS_BASE/lib/waves* is used.
The search path used can be overridden by setting the UNIX environment
variable WAVES_PROFILE_PATH before starting *xwaves.*

# SEE ALSO

*waves+ Manual*,\
*waves+ Reference*,\
*Introducing waves+*,\
*cnvlab*(1-ESPS), *formant*(1-ESPS), *select*(1-ESPS),\
*xcmap*(1-ESPS), *xlabel*(1-ESPS), *xmarks*(1-ESPS),\
*xspectrum*(1-ESPS), *xwaves*(1-ESPS)

# BUGS

Occasionally, when the vertical size of the label display window is
changed manually, *xchart* insists on returning it to its previous size
or some other inappropriate height. Multiple attempts will usually yield
the desired effect. This will eventually be fixed.

The chart file does *not* automatically adjust to time changes caused by
waveform segment deletion or insertion. It is recommended that no
waveform editing be performed on files being viewed with *xchart.*

# AUTHOR

Program by David Talkin at Entropic Research Laboratory, based on his
program *xlabel*(1-ESPS). This manual page largely extracted by Rod
Johnson from *waves+ Manual*, derived ultimately from Talkin's original
documentation with contributions from others at Entropic.
