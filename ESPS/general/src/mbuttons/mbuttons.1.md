# NAME

    mbuttons - create arbitrary screen buttons from menu file

# SYNOPSIS

**mbuttons** \[ **-b** *but_per_row* \] \[ **-c** \] \[ **-h** \] \[
**-w** *window_title* \] \[ **-i** *icon_title* \] \[ **-q**
*quit_button* \] \[ **-Q** *quit_label* \] \[ **-l** *quit_command* \]
\[ **-X** *x_pos* \] \[ **-Y** *y_pos* \] \[ **-x** *debug_level* \] \[
*menu_file*

# DESCRIPTION

*mbuttons* ("menu buttons") pops up an X window with screen buttons for
invoking arbitrary Unix commands. Specifications for the button names
and associated commands are given in an ASCII file *menu_file* using the
same format as menu files for the OPEN LOOK window manager *olwm* (same
as *sunview* menu files). If submenus are specified, they result in menu
buttons with pull-down menus, or (if -**c** is used) in a set of
exclusive push-buttons choices.

The simplest case for *menu_file* is a file with two columns - the
button labels are taken from the first column and the corresponding
commands are taken from the second column. If blanks are needed in the
button labels, use quotes to surround the string in the first column
(e.g., "Display Header"). Do not use quotes in the command string unless
they are part of the command (you may have to escape them). More
complicated cases can be created using the full syntax of *olwm*(1) menu
files. The only restriction is that there can only be one level of
submenus - i.e., each entry in the *menu_file* can itself specify a menu
(either directly or by giving the full path to another menu file), but
the specified submenu cannot have additional submenus. Also, while the
*olwm* command keyword DEFAULT is handled, others (PROPERTIES, REFRESH,
FLIPDRAG, etc.) are treated as ordinary strings by *mbuttons*. For
details about the format of menu files, see *olwm*(1) - the manual page
is included in the ESPS distribution. Also, see the section EXAMPLES.

By default, submenus yield menu buttons with pull-down menus (if a
DEFAULT is specified, it becomes the default selection in the pull-down
menu). If the -**c** option is used, sets of exclusive choice buttons
are used instead of pull-down menus (if a DEFAULT is specified, the
corresponding button comes up depressed); by default, the buttons are
displayed vertically, but they will be displayed horizontally if the
-**h** is used. Note that each set of exclusive choice buttons
(corresponding to a submenu in the *olwm* menu file) is counted as one
"button" in laying out the panel (see -**b**).

*mbuttons* looks for the named *menu_file* first in the current
directory and then in \$ESPS_BASE/lib/menus. This default search path
can be overriden by setting the *unix* environment variable
ESPS_MENU_PATH. Since *find_esps_file* (3-ESPS) is used in implementing
this behavior, environment variables (preceeded by the character \$) can
be embedded within the *menu_file* string.

# OPTIONS

The following options are supported:

**-b** *but_per_row \[10\]*  
Specifies the number of file buttons per row. For example, if
*but_per_row* is set to 1, a single column of buttons will result. The
optional quit button (**-q**) is not included in the count; if it is
specified via **-q** or the environment variable BBOX_QUIT_BUTTON, it
appears on a row by itself at the top of the panel. Thus, a quit button
may be added or removed without affecting the layout of the other
buttons (see **-q**).

**-c**  
Use a set of exclusive panel choice buttons for each *olwm* submenu
instead of a menu button with a pull-down menu.

**-h**  
Lay out each set of panel choice buttons horizontally instead of
vertically (this option has no effect unless -**c** is used).

**-w** *window_title* \["ESPS Button Panel"\]  
Specifes a title for the *mbuttons* window.

**-i** *icon_title \[mbuttons\]*  
Specifies a title for the *mbuttons* icon.

**-q** *quit_button \[0\]*  
If non-zero, specifies that a "QUIT" button be included in the panel. If
the *unix* environment variable BBOX_QUIT_BUTTON is defined, this
results in a "QUIT" button being added even if *quit_button* is 0. The
main reason for providing global control via BBOX_QUIT_BUTTON is to
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

**-X** *x_pos*  
Specifies the x-position (in the root window) of the frame displayed by
*mbuttons*. Both *x_pos* and *y_pos* must be specified and be
non-negative; otherwise, the positioning will be left up to the window
manager. The standard XView **-Wp** and standard X11 **-geometry**
options can also be used to position the window.

**-Y** *y_pos*  
Specifies the y-position (in the root window) of the frame displayed by
*mbuttons*. Both *x_pos* and *y_pos* must be specified and be
non-negative; otherwise, the positioning will be left up to the window
manager. The standard XView **-Wp** and standard X11 **-geometry**
options can also be used to position the window.

**-x** *debug_level \[0\]*  
If *debug_level* is positive, *mbuttons* prints debugging messages and
other information on the standard error output. The messages proliferate
as the *debug_level* increases. If *debug_level* is 0 (the default), no
messages are printed.

# ESPS PARAMETERS

ESPS parameter files are not used by the current version of *mbuttons*.

# ESPS COMMON

ESPS Common is not processed by *mbuttons*.

# FUTURE CHANGES

Add parameter file processing.

# EXAMPLES

Suppose one defines the simple script *xtestsd* as follows:


    	#!/bin/sh
    	exprompt -P $ESPS_BASE/lib/Ptestsd tparams
    	testsd -Ptparams $1

This script creates a test signal in the file test.sd after the user
fills out a form generated by *exprompt* (1-ESPS). Now consider the
following simple example of a menu file:


       "Make test signal"	exec xtestsd test.sd
       "Play test signal"	exec splay test.sd
       "xwaves+ on test signal"     exec xwaves+ test.sd

With this menu file as input, *mbuttons* will pop up a window with three
buttons (plus optional Quit button). The first will provide an
interactive means for creating a test signal, the second will play the
signal, and the third will run *xwaves*+ on the signal.

Here's a more elaborate example:


      "make play buttons"	exec fbuttons 
      "test signal" MENU
    	"Play test signal" 	exec splay test.sd
    	"Make test signal" DEFAULT	exec xtestsd test.sd
    	"xwaves+ on test signal"	exec xwaves+ test.sd
      "test signal" END
      "plot3d example"	exec plot3d -r1:100 /usr/esps/demo/speech.sgram
      "waves+ demo"		cd "/usr/esps/demo; ENTROPIC

Here, we've made the three buttons from the first example into a
submenu. This causes the second button to have the label "test signal";
right-mousing it brings up a pull-down menu with the three entries from
the previous example. The second item of the three is the default (i.e.,
it's what you get if you just left-mouse the "test signal" button. An
alternative would be to introduce the sumenu indirectly, as follows:


       "make play buttons"	exec fbuttons 
       "test signal" MENU	/h1/shore/demo/testsig.men
       "plot3d example"	exec plot3d -r1:100 /usr/esps/demo/speech.sgram
       "waves+ demo"		cd "/usr/esps/demo; ENTROPIC

# ERRORS AND DIAGNOSTICS

*mbuttons* will exit with an error message if it can't connect to the
specified X server (DISPLAY variable or standard -display option).

*mbuttons* will exit with error messages if it can't create the button
window for various reasons (e.g., no valid list of files, invalid or
empty file given to **-E** or **-M**, etc.)

If, after pressing a button, *mbuttons* (or /bin/sh) claims that the
command is not found, you may have some extraneous quote characters in
the menu file (remember to not surround the command string with quotes).

# BUGS

None known.

# REFERENCES

# SEE ALSO

*fbuttons* (1-ESPS), *xtext* (1-ESPS), *exprompt* (1-ESPS), *exv_bbox*
(3-ESPSxu), *espsenv* (1-ESPS)

# AUTHOR

Program and man page by John Shore
