# NAME

    fbuttons - create panel with buttons that run programs on specific files

# SYNOPSIS

**fbuttons** \[ **-F** *file_menu* \] \[ **-s** *max_scroll_lines* \] \[
**-R** *regexp* \] \[ **-L** *proglist_file* \] \[ **-S**
*progmenu_file* \] \[ **-M** *mbuttons_menu* \] \[ **-a** \] \[ **-b**
*but_per_row* \] \[ **-q** *quit_button* \] \[ **-Q** *quit_label* \] \[
**-l** *quit_command* \] \[ **-c** \] \[ **-h** \] \[ **-w**
*window_title* \] \[ **-i** *icon_title* \] \[ **-X** *x_pos* \] \[
**-Y** *y_pos* \] \[ **-x** *debug_level* \] \[ *filename1* \] \[
*filename2* ... \]

# DESCRIPTION

*fbuttons* ("file buttons") pops up an X window with screen buttons (or
a scrollble list) for invoking one of a given set of programs on one of
a given set of files. By default, the window displayed by *fbuttons* has
two panels, one panel to provide selections for the program to be run,
and one panel with buttons that invoke the selected program on a given
file. By default, *fbuttons* is configured to either play or view the
header of all files in the current directory with suffixes ".sd" or
".d". If the **-M** option is used, a third panel is created with screen
buttons that can have arbitrary functions in the style of *mbuttons*
(1-ESPS).

Programs are invoked on a given file by pressing (left mouse) the
corresponding button in the bottom panel of the window. Buttons there
may have menus associated with them, in which case programs are invoked
on a given file by making an appropriate menu selection. Often the
button labels duplicate the file names, but (if **-F** is used) it is
possible to create file buttons with arbitrary labels. The program that
is invoked by pressing such a file button (or making a button-menu
selection) is controlled by an exclusive set of toggle-buttons in the
top panel of the window (or in the middle panel if the **-M** option is
used). Pushing the "program button" labelled with the desired program
selects the named program as the one that will be invoked on a file when
a the file is selected by pressing a file button in the bottom panel or
making a button-menu selection there. (Note that the act of pushing a
program button has no effect other than selecting that program for
subsequent invocation via the file buttons.) Programs invoked by
*fbuttons* inherit its environment. A QUIT button is also provided in
the panel containing the program buttons; it can be disabled using the
-**q** option.

File names associated with the file buttons, scrollable file list, or
file button-menus can be provided to *fbuttons* using any combination of
three methods: (1) a list on the command line (*filename1* *filename2*
...), in which case the button labels are given by the file names; (2) a
regular expression for a set of file names (**-R**), in which case the
button labels are also given by the file names; and (3) a menu file
containing button labels and associated file names (**-F**). If none of
these three methods is used, by default *fbuttons* uses the regular
expression "\\s\*d\$" to select all files in the current directory with
suffixes ".sd" or ".d", If the **-a** is used, file names will be sorted
alphabetically (but note that sorting does not apply to a menu file
associated with **-F**).

If **-s** is used, a scrollable list is provided instead of buttons in
the bottom panel. The number of files shown is limited to
*max_scroll_lines* (but of course the list can be scrolled). If **-s**
is used, the list labels are limited to file names (i.e., **-F** cannot
be used). A scrollable list cannot be used if a *file_menu* is specified
(**-F**).

The *file_menu* specified with **-F** uses uses the same format as menu
files for the OPEN LOOK window manager *olwm* (same as *sunview* menu
files). If submenus are specified, they result in menu buttons with
pull-down menus.

The simplest case for *file_menu* is a file with two columns - the
button labels are taken from the first column and the corresponding
files are taken from the second column. If blanks are needed in the
button labels, use quotes to surround the string in the first column
(e.g., "Max Headroom"). More complicated cases can be created using the
full syntax of *olwm*(1) menu files. The only restriction is that there
can only be one level of submenus - i.e., each entry in the *file_menu*
can itself specify a menu (either directly or by giving the full path to
another menu file), but the specified submenu cannot have additional
submenus. Also, while the *olwm* command keyword DEFAULT is handled,
others (PROPERTIES, REFRESH, FLIPDRAG, etc.) are treated as ordinary
strings. For details about the format of menu files, see *olwm*(1) - the
manual page is included in the ESPS distribution. Also, see *mbuttons*
(1-ESPS) and the EXAMPLES.

Program names for the program buttons can be provided to *fbuttons* in
one of two ways: (1) by means of a file containing a list of programs
(**-L**) - in this case, the program "name" is actually the full command
line to be used (i.e., each "name" is used both as a button label and as
the command line to be executed); (2) by means of a file containing a
list of names and associated command lines (**-S**) - in this case, the
name is used as the button label and is independent of the command line
to be executed. If neither **-L** or **-S** is specified, *fbuttons*
uses a default *progfile_menu* to create two program buttons: one
labeled "play file" and one labeled "show header". The former causes
"play -r1: " to be invoked on any file whose file button is pressed; the
latter causes "xtext psps -aD" to be invoked (this results in a pop-up
window with a full-history header but no data). If the default menu
cannot be found, *fbuttons* uses "play -r1:" and "xtext psps -aD" both
as program button labels and command strings.

The **-M** option can be used to specify a menu file of the type used by
*mbuttons* (1-ESPS) to create arbitrary screen buttons. The syntax of
the menu file and the semantics of the resulting button panel are
exactly the same as for *mbuttons*, execept that the panel appears as
the top panel within the *fbuttons* window rather than in its own window
(as is the case for *mbuttons*). Pressing a simple button invokes an
associated command. Pressing a menu button (specified as a sub-menu
within the *mbuttons_file*) produces a pop-down menu; selecting an item
from the menu invokes an associated command. If the -**c** is specified
a set of exclusive choice buttons is presented instead of a menu button.
For details, see the *mbuttons* man page.

In a typical application, each file name (as specfied on the command
line or via **-F** and **-R**) is the name of an existing file. In some
cases, however, it makes sense for the names to have other meanings that
are known to the invoked programs. For example, in the TIMIT demo
(included in the ESPS demo directory), the button labels are file
prefixes, and the invoked programs derive relevant file names by
appending appropriate suffixes.

If **-S**, **-M**, or**- F** is used, *fbuttons* looks looks for the
named *progmenu_file*, *mbuttons_menu* or *file_menu* file first in the
current directory and then in \$ESPS_BASE/lib/menus. This default search
path can be overriden by setting the *unix* environment variable
ESPS_MENU_PATH. *find_esps_file*(3-ESPS) is used in implementing this
behavior, so environment variables (preceeded by the character \$) can
be embedded within the *progmenu_file* and *mbuttons_menu* strings.

# OPTIONS

The following options are supported:

**-F** *file_menu*  
Specifies that file buttons be created from the file *file_menu*. In the
simplest case, the button labels are taken from the first column and the
associated files are taken from the second column. Butons with
associated pop-down menus can also be created (see the discussion above
under DESCRIPTION). Note that the **-F** option can be used in
combination with **-R** and with file names listed explicitly on the
command line.

**-R** *regexp* \['\\\\.s\*d\$'\] Specifies that file buttons be  
created for any file in the current directory that matches the regular
expression *regexp*. By default, any file name with suffix ".sd" or ".d"
is selected, provided that the **-F** option isn't use and that file
names are not given explicitely on the command line. The **-R** option
can be used in combination with **-F** and with file names listed
explicitly on the command line.

**-L** *proglist_file*  
Specifies that program buttons be created for the strings listed in the
file *proglist_file*, one string per line (empty lines are ignored). A
set of exclusive toggle-buttons is created. The button labels are the
strings in *proglist_file*. The same string is used as a program command
line if a given program button is down when any file button is pressed,
the file name is appended to the program button label (i.e., to the
string that was in *proglist_file*) and the resulting command is
executed. The command inherits the environment of *fbuttons*. This
option and **-S** are mutually exclusive. If neither are used, then a
default menu file is used to create two program buttons: one labeled
"play file" and one labeled "show header". The former causes "play -r1:
" to be invoked on any file whose file button is pressed; the latter
causes "xtext psps -aD" to be invoked (this results in a pop-up window
with a full-history header but no data). If the default menu cannot be
found, *fbuttons* uses "play -r1:" and "xtext psps -aD" both as program
button labels and command strings.

**-S** *progmenu_file*  
Specifies that program buttons be created from the file *progmenu_file*,
with the button labels taken from the first column in the file and the
corresponding command strings taken from the second column. If blanks
are needed in the button labels, use quotes to surround the string in
the first column (e.g., "Display Header"). Do not use quotes in the
command string unless they are part of the command (you may have to
escape them). The *progmenu_file* format corresponds to a special case
of *olwm* and *sunview* menu files, namely single-level menus (no
submenus). Thus, a menu title line and certain other standard keywords
can be present, although they are ignored by *fbuttons*. For more
information, see *olwm*(1) - the manual page is included in the ESPS
distribution.

**-M** *mbuttons_file*  
Specifies that a top panel be created with arbitrary screen buttons
defined by the menu file *mbuttons_file*. This ASCII file defines button
names and associated commands using the same format as menu files for
the OPEN LOOK window manager *olwm* (same as *sunview* menu files). If
submenus are specified, they result in menu buttons with pull-down
menus. The resulting button panel behaves exactly the same as the
independent button windows created by *mbuttons* (1-ESPS). For details,
see the manual pages for *mbuttons* (1-ESPS) and *olwm*(1).

**-s** *max_scroll_lines*  
Specifies that a scrollable list be used in the bottom panel instead of
buttons, with *max_scroll_lines* being the number visible. A scrollable
list cannot be used if a *file_menu* is specified (**-F**).

**-a**  
Specifies that the file names obtained from the command line and from
the **-R** option be sorted in alphabetical order. Sorting does not
apply to the button names derived from a *file_menu* (**-F** option).

**-b** *but_per_row \[10\]*  
Specifies the number of file buttons per row and is also used to adjust
the geometry of the program toggle buttons. If *but_per_row* is set to
1, for example, a single column of buttons will result.

**-q** *quit_button \[1\]*  
If zero, inhibits the "QUIT" button from the program panel. If the
*unix* environment variable BBOX_QUIT_BUTTON is defined, this results in
a "QUIT" button being added to every panel even if *quit_button* is 0.
The main reason for providing global control via BBOX_QUIT_BUTTON is to
facilitate usage on systems with window managers that do not provide an
independent means for killing windows.

**-Q** *quit_label***\[QUIT\]"**  
If a "QUIT" button is included (see -**q**), the *Q* option specifies
the label shown on the button. This option has no effect if there there
is not a quit button.

**-l** *quit_command*  
If a "QUIT" button is included, this option may be used to provide a
command that is to be executed prior to quitting. Any Unix command can
be given as the argument of the -**l** option. This option has no effect
if there there is not a quit button.

**-c**  
For the top panel, use a set of exclusive panel choice buttons for each
*olwm* submenu instead of a menu button with a pull-down menu. This
option has no effect unless -**M** is used.

**-h**  
For the top panel, lay out each set of panel choice buttons horizontally
instead of vertically (this option has no effect unless -**M** and
-**c** are used).

**-w** *window_title* \["Run Program on File"\]  
Specifes a title for the *fbuttons* window.

**-i** *icon_title \[fbuttons\]*  
Specifies a title for the *fbuttons* icon.

**-X** *x_pos*  
Specifies the x-position (in the root window) of the frame displayed by
*fbuttons*. Both *x_pos* and *y_pos* must be specified and be
non-negative; otherwise, the positioning will be left up to the window
manager. The standard XView **-Wp** and standard X11 **-geometry**
options can also be used to position the window.

**-Y** *y_pos*  
Specifies the y-position (in the root window) of the frame displayed by
*fbuttons*. Both *x_pos* and *y_pos* must be specified and be
non-negative; otherwise, the positioning will be left up to the window
manager. The standard XView **-Wp** and standard X11 **-geometry**
options can also be used to position the window.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *fbuttons* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

ESPS parameter files are not used by the current version of *fbuttons*.

# ESPS COMMON

ESPS Common is not processed by *fbuttons*.

# FUTURE CHANGES

Add parameter file processing.

# EXAMPLES

The command

    	%fbuttons
    	
    is equivalent to 
       
    	%fbuttons *.d *.sd    
    		

Here's another example of exploiting the shell to expand wild cards in
order to generate a file list for *fbuttons*:


    	%fbuttons *.sd */*.sd dataCP??.sd

Here's an example of a program file (for use with **-L**);


    	splay -g.5 
    	splay -g.5 -R2
    	back_play
    	xtext psps -l
    	xtext psps -lD

Here, *back_play* is the name of a program on the user's path. A more
"user friendly" approach would be to use the following menu file (with
**-S**):


    	play	splay -g.5 
    	"play twice"	splay -g.5 -R2
    	"play backwords"	back_play
    	"show file"	xtext psps -l
    	"show header"	xtext psps -lD

In fact, *back_play* is a one-line script containing:


    	#!/bin/sh
    	ereverse $1 - | splay -

For examples of *fbuttons* used with all three panels and with **-F**
see the TIMIT and Sounds demos in \$ESPS_BASE/demos.

# ERRORS AND DIAGNOSTICS

*fbuttons* will exit with an error message if it can't connect to the
specified X server (DISPLAY variable or standard -display option).

*fbuttons* will exit with error messages if it can't create the button
window for various reasons (e.g., no valid list of files, invalid or
empty file given to **-L** or **-S**, etc.)

# BUGS

If the environment variable BBOX_QUIT_BUTTON is set, quit buttons will
appear in all panels (not just the panel containing program buttons).
This is a bit ugly and wastes space, but should not be harmful.

In a previous version, the quit button was always present in the program
panel. So as not to break existing scripts, the more recent -**q**
option defaults to the previous behavior (i.e., having the quit button).
Unfortunately, this means that fbuttons and *mbuttons* (3-Eu) have
opposite quit button defaults.

# REFERENCES

# SEE ALSO

*mbuttons* (1-ESPS), *xtext* (1-ESPS), *exprompt* (1-ESPS), *exv_bbox*
(3-ESPSxu)

# AUTHOR

Program and man page by John Shore. Thanks to Stephen Marcus (AT&T Bell
Laboratories, Napirville) for the **-s** code.
